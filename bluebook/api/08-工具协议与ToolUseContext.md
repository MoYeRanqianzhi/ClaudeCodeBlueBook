# 工具协议与 ToolUseContext

这一章回答三个更底层的问题：

1. Claude Code 的 tool 到底是不是“函数调用”。
2. `ToolUseContext` 为什么比普通回调上下文重得多。
3. 工具执行链为什么能同时承载权限、渲染、缓存、并发和恢复。

## 1. 先说结论

Claude Code 的 tool 不是一个“给模型调用的 RPC 函数”，而是一份完整的能力协议对象。

它至少同时描述五类东西：

1. 输入输出契约：schema、JSON schema、等价性、结果映射。
2. 安全契约：校验、权限、自动分类器输入、破坏性、并发性。
3. 装配契约：名称、别名、搜索提示、defer/alwaysLoad、MCP 信息。
4. 表现契约：progress、tool use、tool result、grouped render、search text。
5. 运行契约：如何借助 `ToolUseContext` 访问状态、消息、缓存、UI、会话和子代理环境。

关键证据：

- `claude-code-source-code/src/Tool.ts:158-300`
- `claude-code-source-code/src/Tool.ts:362-695`
- `claude-code-source-code/src/Tool.ts:703-792`
- `claude-code-source-code/src/tools.ts:193-250`
- `claude-code-source-code/src/tools.ts:271-389`
- `claude-code-source-code/src/services/tools/toolExecution.ts:337-680`
- `claude-code-source-code/src/services/tools/toolOrchestration.ts:19-177`
- `claude-code-source-code/src/services/tools/StreamingToolExecutor.ts:35-519`

## 2. Tool 类型本身就是一套协议

### 2.1 输入/输出不是附属信息

`Tool<Input, Output, P>` 明确要求：

- `call(...)`
- `description(...)`
- `inputSchema`
- 可选 `inputJSONSchema`
- 可选 `outputSchema`
- `mapToolResultToToolResultBlockParam(...)`

证据：

- `claude-code-source-code/src/Tool.ts:362-400`
- `claude-code-source-code/src/Tool.ts:557-560`

这说明 tool 从一开始就不是“模型瞎传一个对象，客户端尽量接”；
相反，输入验证和结果映射是协议的一部分。

### 2.2 安全相关字段是第一等公民

同一个 `Tool` 接口还包含：

- `isConcurrencySafe`
- `isReadOnly`
- `isDestructive`
- `interruptBehavior`
- `validateInput`
- `checkPermissions`
- `preparePermissionMatcher`
- `toAutoClassifierInput`

证据：

- `claude-code-source-code/src/Tool.ts:401-417`
- `claude-code-source-code/src/Tool.ts:483-517`
- `claude-code-source-code/src/Tool.ts:550-556`

换句话说，tool 不是“先做事，再想安全”；
安全语义直接写进了能力对象本身。

### 2.3 装配与发现字段不是可有可无

工具对象还支持：

- `aliases`
- `searchHint`
- `shouldDefer`
- `alwaysLoad`
- `mcpInfo`
- `name`
- `strict`

证据：

- `claude-code-source-code/src/Tool.ts:367-378`
- `claude-code-source-code/src/Tool.ts:436-472`

这说明 Claude Code 不假设“所有工具总是完整暴露在 prompt 里”。
工具是否延迟加载、本轮是否应该先经 `ToolSearch`，也是协议层决定的。

### 2.4 呈现语义也被内建进工具

`Tool` 还带了一整套 UI/Transcript 渲染协议：

- `renderToolUseMessage`
- `renderToolResultMessage`
- `renderToolUseProgressMessage`
- `renderToolUseRejectedMessage`
- `renderToolUseErrorMessage`
- `renderGroupedToolUse`
- `extractSearchText`
- `getToolUseSummary`
- `getActivityDescription`

证据：

- `claude-code-source-code/src/Tool.ts:528-694`

因此 tool 在 Claude Code 里不是单纯 backend primitive。
它既服务模型，也服务 REPL 前台和 transcript 搜索。

## 3. `buildTool()` 体现了很强的 fail-closed 设计

`buildTool()` 给多个常见字段补默认值：

- `isEnabled` 默认 `true`
- `isConcurrencySafe` 默认 `false`
- `isReadOnly` 默认 `false`
- `isDestructive` 默认 `false`
- `checkPermissions` 默认 allow，但仍回到统一 permission system
- `toAutoClassifierInput` 默认 `''`
- `userFacingName` 默认 `name`

证据：

- `claude-code-source-code/src/Tool.ts:703-792`

最重要的是其中三项默认：

1. 并发安全默认不是安全。
2. 只读默认不是只读。
3. 自动分类器默认不参与，安全相关工具必须显式覆盖。

这是一种非常典型的工程选择：
不把“乐观假设”埋进默认值。

## 4. 工具池并不是静态表，而是运行时装配结果

### 4.1 `getAllBaseTools()` 是环境感知的全集

`getAllBaseTools()` 才是“当前环境下可能出现的全部内置工具源”：

- `AgentTool`
- `BashTool`
- `FileReadTool` / `Edit` / `Write`
- `NotebookEditTool`
- `WebFetchTool` / `WebSearchTool`
- `TodoWriteTool`
- `AskUserQuestionTool`
- `SkillTool`
- `Task*` 系列
- 以及大量 feature/env/user-type 控制的 ant-only 或 gated 工具

证据：

- `claude-code-source-code/src/tools.ts:193-250`

这份全集本身已经受：

- `feature()`
- `process.env.USER_TYPE`
- specific env flag
- worktree / swarm / REPL / LSP 等运行态开关

共同影响。

### 4.2 `getTools()` 会继续按运行模式收口

`getTools(permissionContext)` 还会做进一步过滤：

- simple mode 只给极简工具面
- REPL mode 隐藏 primitive tools，改由 `REPLTool` 包裹
- deny rules 可以在模型看到工具前就先裁掉整类工具
- `isEnabled()` 最后再执行一次

证据：

- `claude-code-source-code/src/tools.ts:253-327`

这说明 Claude Code 的“工具面”不是单一 truth，而是“运行态可见 truth”。

### 4.3 `assembleToolPool()` 的排序是为了 prompt cache 稳定

`assembleToolPool(...)` 会：

1. 拿 built-in tools
2. 过滤 MCP deny rules
3. built-in 与 MCP 分区排序
4. `uniqBy(name)` 去重，并让 built-in 优先

证据：

- `claude-code-source-code/src/tools.ts:329-367`

源码注释明确指出：
之所以不做平铺排序，是为了避免 MCP tool 插入 built-in tool 前缀中间，破坏系统 prompt cache 的稳定性。

所以工具池排序不是 UI 美学，而是 token 经济学的一部分。

## 5. `ToolUseContext` 是运行时依赖注入容器

### 5.1 它不只是“当前消息 + 当前配置”

`ToolUseContext` 里至少有这些维度：

- `options.commands`
- `options.tools`
- `options.mcpClients`
- `options.mcpResources`
- `options.agentDefinitions`
- `options.refreshTools`
- `abortController`
- `readFileState`
- `getAppState` / `setAppState`
- `messages`
- `queryTracking`

证据：

- `claude-code-source-code/src/Tool.ts:158-180`
- `claude-code-source-code/src/Tool.ts:250-300`

它更像一个 runtime container，而不是普通调用上下文。

### 5.2 它同时承载 UI、通知和交互控制

同一个 context 还能直接控制：

- `setToolJSX`
- `appendSystemMessage`
- `addNotification`
- `sendOSNotification`
- `openMessageSelector`
- `requestPrompt`
- `setStreamMode`
- `setSDKStatus`
- `onCompactProgress`

证据：

- `claude-code-source-code/src/Tool.ts:198-245`
- `claude-code-source-code/src/Tool.ts:267-299`

这再次说明 Claude Code 的 tool 并不是“后台函数”，而是 runtime 的正式参与者。

### 5.3 它还包含记忆、缓存与恢复相关状态

`ToolUseContext` 里还挂着：

- `loadedNestedMemoryPaths`
- `dynamicSkillDirTriggers`
- `discoveredSkillNames`
- `toolDecisions`
- `contentReplacementState`
- `renderedSystemPrompt`
- `preserveToolUseResults`
- `localDenialTracking`

证据：

- `claude-code-source-code/src/Tool.ts:215-299`

这些字段说明工具层与 memory、skill discovery、permission cache、prompt cache sharing 是同一张状态网的一部分。

### 5.4 `queryContext.ts` 证明这个 context 还能被“重建”

`buildSideQuestionFallbackParams(...)` 会在没有现成 cache-safe params 时手工重建一个 `ToolUseContext`，供 side question / SDK 场景复用。

证据：

- `claude-code-source-code/src/utils/queryContext.ts:76-178`

因此 `ToolUseContext` 不是某个组件私有对象，而是 runtime 可序列化推导的“调用环境描述”。

## 6. 工具执行链如何工作

### 6.1 `runToolUse(...)` 先做可见工具查找，再做兼容别名回退

执行路径先在 `toolUseContext.options.tools` 中找工具；
如果没找到，还会到 `getAllBaseTools()` 里按 alias 做一次 deprecated-name fallback。

证据：

- `claude-code-source-code/src/services/tools/toolExecution.ts:337-410`

这说明 transcript 与旧工具名兼容也被当成正式需求。

### 6.2 第一关是 schema，而不是权限

`checkPermissionsAndCallTool(...)` 的第一步是：

1. `tool.inputSchema.safeParse(input)`
2. 如失败，追加 `schema not sent` hint
3. 再跑 `tool.validateInput(...)`

证据：

- `claude-code-source-code/src/services/tools/toolExecution.ts:599-733`

其中 `buildSchemaNotSentHint(...)` 专门处理 deferred tool 未被 `ToolSearch` 先加载时，模型把 typed 参数误写成 string 的情况。

证据：

- `claude-code-source-code/src/services/tools/toolExecution.ts:572-597`

这说明 ToolSearch 不是可选优化，而是延迟工具协议的一部分。

### 6.3 第二关才是权限与 hook

同一条执行链再继续进入：

- speculative classifier check
- permission system
- pre/post tool hooks
- permission-denied hooks

证据：

- `claude-code-source-code/src/services/tools/toolExecution.ts:734-760`
- `claude-code-source-code/src/services/tools/toolExecution.ts:126-131`

所以 Claude Code 的工具调用顺序是：

1. 类型正确
2. 值正确
3. 权限允许
4. 才真正执行

### 6.4 并发并不是“一把梭”

`runTools(...)` 会先按 `isConcurrencySafe` 分批：

- 连续的 concurrency-safe 工具可并发
- 非 concurrency-safe 工具必须独占

证据：

- `claude-code-source-code/src/services/tools/toolOrchestration.ts:19-116`

这是一种非常清晰的设计：

- 是否并发由工具自己声明
- 并发边界由 orchestration 层统一执行

### 6.5 `StreamingToolExecutor` 进一步把“边流式边执行”工程化

`StreamingToolExecutor` 支持：

- 工具边流入边排队
- concurrent-safe 工具并行
- non-concurrent 工具顺序独占
- progress 消息立刻 yield
- final result 按接收顺序回放
- sibling abort
- streaming fallback discard
- context modifier 回写

证据：

- `claude-code-source-code/src/services/tools/StreamingToolExecutor.ts:34-124`
- `claude-code-source-code/src/services/tools/StreamingToolExecutor.ts:126-205`
- `claude-code-source-code/src/services/tools/StreamingToolExecutor.ts:262-405`
- `claude-code-source-code/src/services/tools/StreamingToolExecutor.ts:407-519`

这说明 Claude Code 并不是“收到完整 assistant message 后再统一执行工具”，而是在流式阶段就已经进入 tool orchestration。

## 7. 为什么这套设计比“函数调用”更重

如果只从 LLM function calling 视角看，tool 似乎只需要：

- 一个 name
- 一个 schema
- 一个 handler

但 Claude Code 明显认为这远远不够。
一个真正能长期工作的工程代理，还必须回答：

1. 这个工具能不能并发。
2. 它是不是读操作。
3. 它是否应进入自动分类器。
4. 它在 transcript/search/brief mode 中怎么显示。
5. 它是否应该被延迟到 ToolSearch。
6. 它如何访问会话状态、缓存和 UI。
7. 它出错后如何被流式执行器和 fallback 链处理。

从第一性原理看，这就是“tool protocol”比“function calling”重得多的原因。

## 8. 当前边界

需要明确三点：

1. 这里讲的是工具协议与运行语义，不是所有具体工具的逐一手册。
2. `ToolUseContext` 很大，不代表每个工具都会用到所有字段；但这些字段的存在本身表明 runtime 的设计边界。
3. 很多工具仍受 `feature()`、环境变量或用户类型控制，不能把 `getAllBaseTools()` 中出现的每一项都写成公开稳定承诺。

## 9. 一句话总结

Claude Code 的 tool 不是“模型调用函数”，而是“运行时能力对象”：
schema、权限、并发、渲染、搜索、缓存与上下文依赖都被统一写进同一协议里，而 `ToolUseContext` 就是这套协议实际落地时的运行容器。
