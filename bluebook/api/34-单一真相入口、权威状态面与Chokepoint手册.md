# 单一真相入口、权威状态面与Chokepoint手册

这一章回答五个问题：

1. Claude Code 到底把哪些 API / 状态面当作权威真相，而不是任由多处自行拼装。
2. 为什么 `mode`、tool pool、schema、session metadata、worktree state 都必须有单一入口。
3. 为什么这不是普通的代码整理习惯，而是宿主一致性、prompt 稳定性与恢复正确性的前提。
4. 宿主开发者该优先消费哪些权威面，而不是自己再拼一套半真相。
5. 对 Agent 平台构建者来说，这套写法最值得迁移的 API 纪律是什么。

## 1. 关键源码锚点

- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/sessionState.ts:27-146`
- `claude-code-source-code/src/tools.ts:188-367`
- `claude-code-source-code/src/utils/toolPool.ts:20-79`
- `claude-code-source-code/src/utils/api.ts:119-259`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1-8`
- `claude-code-source-code/src/entrypoints/sandboxTypes.ts:1-6`
- `claude-code-source-code/src/utils/sessionStorage.ts:203-258`
- `claude-code-source-code/src/utils/sessionStorage.ts:533-822`
- `claude-code-source-code/src/utils/plugins/pluginPolicy.ts:1-20`

## 2. 先说结论

Claude Code 的 API 写法里有一条非常稳定但容易被忽略的原则：

- 重要真相必须有单一入口，不能让多个调用点各自维护半真相

这里的“真相”不是抽象概念，而是至少包括：

1. 当前 permission mode 到底是什么。
2. 当前模型到底能看见哪些工具。
3. SDK / settings / sandbox 的类型契约到底以哪份 schema 为准。
4. 当前 session transcript、subagent transcript、worktree state 到底写在哪里。
5. 某条组织策略到底该由哪里裁决。

所以 Claude Code 暴露给宿主和作者自己的，不只是 API 集合，而是一组：

- authoritative surfaces

如果宿主跳过这些权威面，改为自己猜 mode、自己拼 tools、自己缓存 metadata，最后几乎一定会得到：

- 看似能跑，但不同平面上的真相逐渐漂移

## 3. `mode` 真相：状态变更必须统一经过单一 choke point

`onChangeAppState(...)` 的注释写得很直白：

- `toolPermissionContext.mode` 是 CCR / SDK mode sync 的 single choke point

源码解释得更具体：

1. 之前 8+ 条 mutation path 里，只有少数路径会通知 CCR。
2. 这会让 `external_metadata.permission_mode` 落后于 CLI 真实 mode。
3. 最后的修法不是到处补通知，而是把 diff 检查统一收口到 `onChangeAppState(...)`。

这对 API 使用者的意义非常直接：

- 真正权威的 mode 变化，不应从零散命令、副作用函数或 UI 手势里倒推
- 应该从 `notifySessionMetadataChanged(...)` 与 `notifyPermissionModeChanged(...)` 这条统一外化链消费

所以更稳的宿主实现不是：

- 我监听几个看起来常见的 mode 变化入口

而是：

- 我消费被 choke point 统一外化后的 mode 真相

## 4. tool pool 真相：工具可见性不能由前台、worker、宿主各写各的

Claude Code 在工具面至少做了三层权威入口。

### 4.1 `getAllBaseTools()` 是 base tool truth

`tools.ts` 直接写明：

- 这是所有 tools 的 source of truth

它统一处理：

- build-time / runtime feature gate
- ant-only 条件工具
- worktree / workflow / LSP / search / MCP resource 工具等能力开关

这意味着“系统到底有哪些基础工具”不是某个页面决定的，而是由一个集中入口决定。

### 4.2 `assembleToolPool(...)` 是 built-in + MCP 的组合真相

同一个文件继续写明：

- 这是 built-in tools 与 MCP tools 合并的 single source of truth

它统一完成：

1. built-in tools 的 mode 过滤
2. MCP deny-rule 过滤
3. built-in 优先去重
4. prompt-cache-stable 排序

这条 API 特别关键，因为它说明工具池不只是“给模型一个列表”，而是：

- capability surface
- policy surface
- prompt-cache surface

三者重合的地方。

### 4.3 `mergeAndFilterTools(...)` 让 REPL 与 headless 路径继续共享真相

`toolPool.ts` 又进一步把 React-free 的合并逻辑抽出来，让 REPL 路径和 headless 路径共享同一组规则。

这说明作者很清楚：

- 权威面如果只能在某个 UI hook 里复用，就还不够权威

### 4.4 `toolToAPISchema(...)` 是 API 出口处的 schema choke point

`utils/api.ts` 里，experimental beta 字段最终统一在一个 choke point 被 strip。

这条设计很值得写进蓝皮书，因为它说明：

- tool schema 的最终 API 形态，也不允许分散到各 feature 自己判断

否则代理层、provider 兼容层、feature gate 很快就会出现多处半真相。

## 5. schema 真相：类型契约必须有可生成、可复用的权威源

`coreSchemas.ts` 和 `sandboxTypes.ts` 的开头都直接写明：

- single source of truth

这不是文案礼貌，而是 SDK/API 设计纪律：

1. schema 先成为权威源。
2. TypeScript 类型由 schema 生成或与 schema 绑定。
3. SDK、settings validation、外部 consumer 共享同一份定义。

这比“先写 TS type，再在别处补校验”稳得多，因为后者几乎必然产生：

- IDE 看见的类型
- 运行时校验的类型
- settings 接受的类型

三份不完全相同的半真相。

## 6. session / worktree 真相：恢复系统最怕 split-brain

`sessionStorage.ts` 这里的价值远超“存会话日志”。

### 6.1 transcript path 必须以 sessionProjectDir 为准

`getTranscriptPathForSession(...)` 的注释明确指出：

- 如果当前 session 的 transcript path 仍按 `originalCwd` 猜，就会和 `sessionProjectDir` 写出的真实路径分裂

作者甚至直接把这种问题命名成：

- split-brain

这说明在恢复系统里，“文件写在哪里”本身就是权威真相，不能由 hooks、resume、bridge 各自估算。

### 6.2 subagent transcript 继续复用同一权威路径体系

`getAgentTranscriptPath(...)` 并没有自创另一套路径推断，而是继续复用 sessionProjectDir 一致性。

这代表 Claude Code 对多 Agent 的处理方式不是：

- agent 多了就允许各自写出自己的局部真相

而是：

- agent 再多，也要服从主 session 的权威路径面

### 6.3 worktree state 用 tri-state 维护恢复真相

`Project.currentSessionWorktree` 被写成：

- `undefined`: 从未触碰
- `null`: 明确已退出 worktree
- `object`: 当前仍在 worktree

这比简单布尔值成熟得多，因为恢复系统必须区分：

1. 从未进入 worktree
2. 进入后干净退出
3. 中途崩溃时仍在 worktree

如果把三种情况都压成一个布尔量，恢复逻辑就只能猜。

## 7. policy 真相：策略判断应尽量做成叶子模块

`pluginPolicy.ts` 这类模块很小，却很关键。

它的注释直接说明：

- 只依赖 settings
- 保持 leaf module
- 作为 policy blocking 的 single source of truth

这说明 Claude Code 在 API 层不仅追求“有一个权威入口”，还追求：

- 这个入口尽量纯、尽量少依赖、尽量不回咬整个模块图

所以真正成熟的权威面通常同时具备两点：

1. 它是唯一应该被信任的入口。
2. 它本身也被保护成低耦合、可复用的判断面。

## 8. 宿主实现者的五条最小纪律

如果你在实现 Claude Code 宿主，至少应遵守下面五条规则：

1. 不要自己维护 permission mode 的镜像状态，优先消费已外化的 mode / metadata 真相。
2. 不要自己拼工具池，优先依赖统一的 tool pool 组合规则。
3. 不要把 schema type、settings validation、API payload 分别手写三份。
4. 不要假设 transcript / worktree 路径是 cwd 推导的，优先使用 session-aware 的权威路径。
5. 不要把策略判断散落到安装、启用、UI 过滤各处，优先围绕单一 policy truth 收口。

## 9. 一句话总结

Claude Code 的很多 API 之所以稳，不是因为字段更多，而是因为它反复把 mode、tool pool、schema、metadata、worktree 这些关键真相收口成单一权威入口。
