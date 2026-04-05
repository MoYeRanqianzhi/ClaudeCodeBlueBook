# services 层全景与 utils-heavy 设计

这一章回答六个问题：

1. `services/` 在 Claude Code 里到底承担什么角色。
2. 为什么这个仓库 `utils/` 很重，却没有立刻失控。
3. `services` 与 `utils` 的分工边界在哪里。
4. 这种分层如何支撑 prompt、状态、工具、远程、多 Agent 等能力。
5. 它的先进性体现在哪些工程基础设施上。
6. 真实工程债务又在哪里。

## 1. 先说结论

Claude Code 的 `services/` 更像“长生命周期子系统层”，而 `utils/` 更像“跨层 invariant 与基础设施层”。

当前源码里：

- `src/services/` 约 `130` 个文件
- `src/utils/` 约 `564` 个文件

这不是因为作者没有边界感，而是因为很多最关键的问题本来就跨域：

- prompt cache 稳定性
- tool ABI
- transcript / resume 兼容
- schema 延迟加载
- worker state coalescing
- markdown/frontmatter 目录治理

因此这个仓库的 `utils-heavy` 真相不是“杂物抽屉”，而是：

- 先把跨域 invariant 抽成共享基础设施
- 再让 `services/` 聚焦各个产品域

关键证据：

- `claude-code-source-code/src/services/tools/toolExecution.ts:1-260`
- `claude-code-source-code/src/services/tools/toolOrchestration.ts:1-132`
- `claude-code-source-code/src/utils/lazySchema.ts:1-6`
- `claude-code-source-code/src/utils/toolPool.ts:1-73`
- `claude-code-source-code/src/utils/markdownConfigLoader.ts:1-240`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:1-118`
- `claude-code-source-code/src/Tool.ts:108-260`
- `claude-code-source-code/src/coordinator/coordinatorMode.ts:111-260`
- `claude-code-source-code/src/utils/swarm/inProcessRunner.ts:871-1043`

## 2. 先看 `services/`：它更像五个长生命周期子平面

从目录看，`services/` 主要可以分成五组。

### 2.1 执行平面

- `api`
- `tools`
- `compact`
- `toolUseSummary`
- `PromptSuggestion`
- `AgentSummary`

这一组负责：

- 采样
- token 经济
- tool 执行
- 压缩
- summarization
- prompt 辅助

### 2.2 连接平面

- `mcp`
- `oauth`

这一组负责：

- 连接第三方能力
- MCP server config / auth / relay / state
- 认证
- transport 级协同

### 2.3 记忆与次级 agent 平面

- `SessionMemory`
- `AgentSummary`
- `PromptSuggestion`
- `extractMemories`
- `autoDream`

这一组负责：

- 后台 forked agent
- session memory 维护
- 次级 agent summarization
- memory 提炼与自动梦境任务

### 2.4 治理平面

- `remoteManagedSettings`
- `settingsSync`
- `policyLimits`
- `plugins`

这一组负责：

- 组织策略
- 托管设置
- 用户/组织同步
- 插件能力治理

### 2.5 观测与现场平面

- `analytics`
- `lsp`
- `teamMemorySync`
- `tips`

这一组负责：

- 诊断与遥测
- 编辑器/LSP 现场回流
- team memory 同步
- 运营提示与附加体验

这说明作者没有把 `services/` 当成“随便丢网络请求”的地方，而是明确按产品能力域收纳。

## 3. 为什么 `utils/` 还会这么重

因为 Claude Code 最难维护的部分，恰好都不是单个产品域能独立拥有的。

典型例子：

### 3.1 `lazySchema.ts`

它只有几行，但影响：

- SDK schema
- server schema
- hooks schema
- settings schema
- MCP schema

这显然不属于某一个 service。

### 3.2 `toolPool.ts`

它同时关心：

- built-in / MCP 工具合并
- 去重
- prompt cache 稳定排序
- coordinator mode 的工具过滤

这也是跨工具系统、缓存系统、coordinator 模式三层的 shared invariant。

### 3.3 `markdownConfigLoader.ts`

它同时要处理：

- `.claude/*` 目录扫描
- git root / worktree 边界
- frontmatter
- 去重
- plugin-only policy

这类能力既不只是 config service，也不只是 plugin service。

### 3.4 `WorkerStateUploader`

它把：

- coalesce
- retry
- RFC 7396 merge
- last-write-wins

封成一个独立组件。
这又是跨 remote transport、worker status 与 metadata 回写的 shared primitive。

## 4. 这不是“service 太少”，而是“invariant 太多”

Claude Code 看起来 `utils` 比 `services` 更显眼，是因为作者更优先抽象下面这些东西：

1. 依赖图稳定性
2. schema 初始化成本
3. prompt cache 稳定性
4. transcript / resume 正确性
5. tool/result 拓扑正确性
6. 状态回写与恢复一致性

这些东西有一个共同特征：

- 它们不是单个产品域的 feature
- 而是整个 runtime 的底层契约

因此把它们放在 `utils/` 并不意味着“杂”，反而说明作者在有意识地区分：

- 域能力
- 共享契约

## 5. `services/tools` 与 `Tool.ts` 说明了真正的平台边界

`Tool.ts` 给出了工具平台的 ABI：

- schema
- permission
- concurrency safety
- tool progress
- UI/render 钩子
- session/state 更新入口

而 `services/tools/toolExecution.ts`、`toolOrchestration.ts` 再负责：

- 单次 tool use 执行
- 并发/串行批次
- hook 前后处理
- telemetry

这种写法说明工具系统并不是某个“工具目录”自己玩自己的，而是被明确划成：

1. 平台接口层
2. 编排层
3. 执行层
4. 具体工具实现层

这就是这个仓库“功能多但还撑得住”的原因之一。

## 6. `services` 不负责一切，多 Agent 也是分散式实现

这点特别值得写清。

Claude Code 的多 Agent / team / workflow 设计，并没有被粗暴塞进一个巨型 `services/swarm`。
相反，它被拆在多个层次：

- `coordinator/coordinatorMode.ts`：领导者 prompt 合同
- `utils/swarm/*`：teammate runtime、mailbox、permission sync、spawn backend
- `tools/AgentTool/*`：spawn/fork/run 入口
- `utils/messages.ts` / `attachments.ts`：`team_context`、`teammate_mailbox` 注入

这说明多 Agent 在 Claude Code 里不是附加 feature，而是穿透：

- prompt 层
- task 层
- tool 层
- attachment 层
- transcript 层

的运行时能力。

这也解释了为什么 `workflow` 在当前提取树里更像“任务/归档维度”而不是一个完整公开引擎：

- 有 `workflows` 配置目录
- 有 `workflow_name` 事件字段
- 有 `subagents/workflows/<runId>/` 归档形态
- 但可见实现并未完整展开

所以蓝皮书应该把 workflow 写成：

- 当前可见是正式 task 维度
- 但具体引擎实现仍有可见性边界

## 7. 为什么这套结构会显得先进

因为它把很多仓库只存在于“工程习惯”里的东西，写成了正式对象。

最典型的几个对象：

1. `lazySchema(...)`
2. `mergeAndFilterTools(...)`
3. `WorkerStateUploader`
4. `QueryGuard`
5. `ToolUseContext`
6. `markdownConfigLoader`

这些对象的共同点是：

- 名字不花哨
- 但每个都抓住一个会反复伤害大型 runtime 的 invariant

换句话说，这个仓库的先进性不是体现在“用了很多新名词”，而是体现在：

- 它先处理那些真正会让系统变脆的地方

## 8. 真实债务在哪里

这不意味着仓库没有债务。

当前最明显的债务更接近传统前端/CLI 大仓库问题：

- `REPL.tsx` 很大
- `sessionStorage.ts` 很大
- `bridge/replBridge.ts` 很大

这些文件说明即使作者已经做了不少 shared primitive，下列区域仍然承载了太多协调职责：

- 交互态 UI
- session 持久化
- bridge 控制面

所以正确判断应该是：

- 基础设施层很成熟
- 但少数协调器文件仍然有进一步拆分空间

## 9. 对蓝皮书的启发

后续写源码结构时，应该优先问：

1. 这个模块是产品域能力，还是跨层 invariant。
2. 它放在 `utils/` 是因为偷懒，还是因为多个域都依赖它。
3. 这里的“advanced”到底是新功能，还是老问题被基础设施化了。

如果不先问这三个问题，就很容易把 `utils-heavy` 草率写成结构缺陷。

## 10. 一句话总结

Claude Code 的 `services/` 负责承载产品域，`utils/` 负责守住 runtime 契约；它之所以显得先进，恰恰是因为后者被认真写成了正式基础设施。
