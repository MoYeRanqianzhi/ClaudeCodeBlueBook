# 能力可见性控制平面：Deferred、Delta与最小可见面

这一章回答五个问题：

1. 为什么 Claude Code 不把“能力存在”直接等同于“能力立刻暴露给模型”。
2. 为什么 deferred tools、delta attachments、managed-only source gating 应被理解成同一控制平面。
3. 为什么“模型看见什么”本身就是安全、token 与 prompt 稳定性的共同变量。
4. 为什么 Claude Code 的能力世界更像运行时可见性控制面，而不是功能说明书。
5. 这条线为什么进一步解释了 prompt 为什么会显得更稳、更省、更安全。

## 0. 代表性源码锚点

- `claude-code-source-code/src/Tool.ts:438-448`
- `claude-code-source-code/src/tools/ToolSearchTool/prompt.ts:53-105`
- `claude-code-source-code/src/utils/toolSearch.ts:385-430`
- `claude-code-source-code/src/utils/toolSearch.ts:540-560`
- `claude-code-source-code/src/services/api/claude.ts:1118-1175`
- `claude-code-source-code/src/utils/toolSchemaCache.ts:1-20`
- `claude-code-source-code/src/utils/attachments.ts:1455-1505`
- `claude-code-source-code/src/utils/attachments.ts:1550-1575`
- `claude-code-source-code/src/services/compact/compact.ts:563-575`
- `claude-code-source-code/src/utils/managedEnv.ts:93-115`
- `claude-code-source-code/src/utils/settings/types.ts:468-525`
- `claude-code-source-code/src/utils/permissions/permissionsLoader.ts:27-40`
- `claude-code-source-code/src/services/mcp/config.ts:337-360`
- `claude-code-source-code/src/utils/settings/pluginOnlyPolicy.ts:1-30`
- `claude-code-source-code/src/tools/AgentTool/runAgent.ts:108-130`
- `claude-code-source-code/src/tools/AgentTool/runAgent.ts:548-565`

## 1. 先说结论

Claude Code 的能力设计，真正高明的一点不是：

- 功能很多

而是：

- 它把“模型此刻能看见什么”做成了一条正式控制平面

这条控制平面不是单点机制，而是几类机制的合体：

1. deferred loading
2. ToolSearch 发现闭环
3. delta attachments 增量回写
4. session-stable schema
5. managed-only source gating

所以更准确的说法不是：

- Claude Code 有很多能力，然后再决定怎么用

而是：

- Claude Code 先决定当前轮哪些能力值得进入模型可见世界

这就是：

- visibility control plane

## 2. Deferred 不是优化小技巧，而是显式合同

`Tool.ts` 里直接把两件事做成了协议字段：

- `shouldDefer`
- `alwaysLoad`

这说明“哪些工具应该首轮可见、哪些工具应该经发现后再加载”不是运行时偶然策略，而是：

- 工具协议的一部分

`ToolSearchTool/prompt.ts` 里又明确列出一组永不 defer 的少数工具，说明 Claude Code 的设计不是：

- 全 defer

而是：

- 先定义最小立即可见面
- 再把其余能力推迟到发现时刻

这是一种非常成熟的控制方式，因为它承认：

- 模型不需要在 turn 1 知道一切

## 3. ToolSearch 让“存在能力”和“当前可见能力”分离

`toolSearch.ts` 与 `claude.ts` 联合说明了一个关键机制：

1. 先判断当前 model/provider 是否支持 `tool_reference`
2. 再判断 ToolSearch 是否真正可用
3. 再从历史里恢复 discovered tool names
4. 最后只把：
   - non-deferred tools
   - ToolSearch 自身
   - 已发现的 deferred tools

真正送进请求

也就是说，Claude Code 没把工具池理解成：

- 一次性完整目录

而是理解成：

- 逐步发现、逐步扩展的可见世界

这让“能力存在”与“能力可见”第一次正式分离。

## 4. Delta attachments 说明变化应该晚绑定，而不是前缀常驻

`attachments.ts` 继续把这条原则推深了一层。

当前 runtime 里至少有三类能力变化被改成了 delta：

- deferred tools delta
- agent listing delta
- MCP instructions delta

这说明 Claude Code 的默认立场不是：

- 一有变化就改 system prompt 主体

而是：

- 先保住稳定壳
- 再用增量把变化挂到尾部

这就是为什么它能同时做到：

- prompt 更稳
- cache 更稳
- 变化仍可回写

## 5. compaction 之后还要重播 delta，说明这些不是 UI 噪音

`compact.ts` 会在 compaction 后主动重播：

- deferred tools
- agent listing
- MCP instructions

这一步非常关键，因为它说明：

- 这些 delta 不是为了显示友好
- 而是为了维持 post-compact 后的能力可见真相

换句话说，Claude Code 不是把 delta 当辅助提示，而是当：

- 会话状态续传的一部分

这已经非常接近“控制平面”的定义了。

## 6. managed-only source gating 说明“谁能定义可见世界”也被收口

如果只看 deferred tools，你可能会以为 Claude Code 只是在做 token 优化。

但 `managedEnv.ts`、`types.ts`、`permissionsLoader.ts`、`mcp/config.ts`、`pluginOnlyPolicy.ts`、`runAgent.ts` 会把同一个原则推进到 source 层：

- 哪些 env 可以在 trust 前生效
- 哪些 permission rules 只能来自 managed settings
- 哪些 MCP allowlist 只能来自 managed settings
- 哪些 customization surfaces 只能来自 plugin/admin-trusted sources
- 哪些 agent frontmatter 的 MCP/hooks 可以继续注入

这说明 Claude Code 不只控制：

- 工具是否可见

它还控制：

- 谁有资格定义模型可见世界

于是“可见性控制平面”进一步升级成：

- authority-aware visibility control plane

## 7. 为什么这同时是安全、token 与 prompt 设计

因为“模型可见世界”一旦提前扩大，三类问题会一起发生：

### 7.1 安全面

模型在更多能力之间探索，权限系统的末端兜底压力上升。

### 7.2 token 面

更多 schema、更多说明、更多高波动描述进入前缀，成本与 cache churn 一起升高。

### 7.3 prompt 面

更多可见变化项意味着更难维持稳定前缀，更难共享 side-loop prefix asset。

所以 Claude Code 的成熟就在于：

- 它把“限制可见世界”当成统一第一步

不是把安全、成本、稳定性拆开分别补救。

## 8. 一句话总结

Claude Code 的能力设计，本质上不是在维护一张全量能力表，而是在维护一条“最小可见面”控制平面：能力可以存在，但必须按发现、增量回写、权限来源与会话稳定性逐步进入模型可见世界。
