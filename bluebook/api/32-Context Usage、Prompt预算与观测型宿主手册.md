# Context Usage、Prompt预算与观测型宿主手册

这一章回答五个问题：

1. `get_context_usage` 到底让宿主看到了什么。
2. 为什么它不只是“token 统计”，而是 prompt 预算观测面。
3. `systemPromptSections`、`systemTools`、`attachmentsByType` 分别适合回答什么问题。
4. `pending_action`、`session_state_changed` 为什么应和 context usage 一起消费。
5. 宿主怎样用这组 API 做真正的预算调优，而不是盲猜。

## 1. 关键源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:175-305`
- `claude-code-source-code/src/components/ContextVisualization.tsx:110-220`
- `claude-code-source-code/src/utils/sessionState.ts:92-130`
- `claude-code-source-code/src/state/onChangeAppState.ts:50-92`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:332-460`

## 2. 先说结论

Claude Code 的 `get_context_usage` 不只是一个“还剩多少 token”的接口。

它更接近一块预算仪表盘，至少能让宿主观察四件事：

1. 系统前缀预算花在了哪里。
2. 工具与扩展能力各吃掉了多少上下文。
3. 消息与附件的真实膨胀点在哪里。
4. 当前系统是否处在 blocked / requires_action / mode changed 的运行态。

所以更准确的说法不是：

- Claude Code 暴露了 context usage

而是：

- Claude Code 暴露了 prompt 预算与运行态的观测面

## 3. `get_context_usage` 的四层真相

### 3.1 顶层预算

它至少给出：

- `totalTokens`
- `maxTokens`
- `rawMaxTokens`
- `percentage`
- `model`

这层回答的是：

- 当前到底离窗口上限还有多远

### 3.2 系统层预算

它继续拆出：

- `systemPromptSections`
- `systemTools`
- `deferredBuiltinTools`
- `mcpTools`
- `skills`
- `slashCommands`
- `agents`

这层回答的是：

- 系统前缀为什么会胖
- 能力目录为什么会膨胀
- 哪些工具已加载，哪些还在 deferred

### 3.3 消息层预算

它还给出：

- `messageBreakdown.toolCallTokens`
- `messageBreakdown.toolResultTokens`
- `messageBreakdown.attachmentTokens`
- `messageBreakdown.assistantMessageTokens`
- `messageBreakdown.userMessageTokens`
- `toolCallsByType`
- `attachmentsByType`

这层回答的是：

- 真正的上下文噪音到底来自工具结果、附件，还是对话本身

### 3.4 可视化层

`ContextVisualization.tsx` 说明这些字段不是内部调试残留，而是前台明确会消费的结构。

所以 `get_context_usage` 本身已经是：

- 面向人类和宿主的正式观测接口

## 4. 为什么它应和状态回写一起读

如果只看 context usage，不看运行态，宿主还是会误判。

因为用户真正要回答的常常不是：

- 还剩多少 token

而是：

- 为什么现在卡住了
- 为什么现在不能继续
- 为什么现在该 compact
- 为什么当前是 requires_action

这时就必须把 `get_context_usage` 和下面这些一起看：

- `external_metadata.pending_action`
- `permission_mode`
- `session_state_changed`

`notifySessionStateChanged(...)` 与 `onChangeAppState(...)` 已经说明：

- Claude Code 会在 blocked / idle / mode changed 后继续外化当前真相

所以更稳的宿主实现不是：

- token 仪表盘和运行态面板各做各的

而是：

- 把预算观测和状态回写视为同一控制面

## 5. 宿主怎么用这组接口做调优

### 5.1 调 prompt

如果 `systemPromptSections` 明显过胖，应先问：

- 哪些规则可以外移到稳定文件
- 哪些 section 可以改为更稳定的缓存片段
- 哪些说明根本不该每轮注入

### 5.2 调工具面

如果 `systemTools`、`mcpTools` 或 `deferredBuiltinTools` 过大，应先问：

- 当前会话真的需要这么宽的工具池吗
- 哪些能力应继续 deferred
- 哪些扩展连接只是噪音

### 5.3 调消息面

如果 `toolResultTokens` 或 `attachmentTokens` 过高，应先问：

- 是否该外置大块输出
- 是否该减少重复附件
- 是否该让某些提醒只进入模型、不进入前台

### 5.4 调宿主交互

如果系统处在 `requires_action`，宿主不应只显示“忙碌”，而应继续展示：

- 当前预算占比
- 当前阻塞来源
- 当前 pending action

这样用户才知道是在“等批准”，还是在“快爆窗”。

## 6. 最容易犯的三个错误

1. 只显示 `percentage`，不显示 `systemPromptSections` / `attachmentsByType`
2. 只看 token 占比，不看 `pending_action` / `session_state_changed`
3. 把 context usage 当 debug 信息，而不是当调优入口

这三种做法都会让宿主重新退回：

- 只能猜系统为什么变慢、变卡、变笨

## 7. 一句话总结

Claude Code 的 `get_context_usage` 不是 token 余量查询，而是一组面向 prompt、工具、附件与运行态的观测型预算 API。
