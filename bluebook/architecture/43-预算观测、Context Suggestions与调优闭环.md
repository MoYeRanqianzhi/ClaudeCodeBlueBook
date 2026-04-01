# 预算观测、Context Suggestions与调优闭环

这一章回答五个问题：

1. 为什么 Claude Code 的预算器不仅会自动纠偏，还会主动暴露可调优结构。
2. `get_context_usage`、`/context`、`ContextVisualization`、`ContextSuggestions` 怎样构成观测闭环。
3. `pending_action`、`session_state_changed` 为什么应和 context budget 一起消费。
4. 为什么这套系统不是“看统计”，而是“把观测变成下一步动作”。
5. 这对宿主、CLI 和 Agent 平台设计者有什么迁移价值。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:175-305`
- `claude-code-source-code/src/utils/analyzeContext.ts:918-1085`
- `claude-code-source-code/src/utils/contextSuggestions.ts:31-220`
- `claude-code-source-code/src/commands/context/context.tsx:12-60`
- `claude-code-source-code/src/commands/context/context-noninteractive.ts:16-120`
- `claude-code-source-code/src/components/ContextVisualization.tsx:14-20`
- `claude-code-source-code/src/components/ContextVisualization.tsx:105-245`
- `claude-code-source-code/src/components/ContextSuggestions.tsx:11-45`
- `claude-code-source-code/src/cli/print.ts:2961-2978`
- `claude-code-source-code/src/utils/sessionState.ts:92-130`
- `claude-code-source-code/src/cli/transports/ccrClient.ts:476-487`

## 1. 先说结论

Claude Code 的预算器还有一个容易被低估的特性：

- 它不仅会自动纠偏，还会把“为什么要纠偏”与“接下来该怎么改”显式暴露出来

这意味着 Claude Code 的预算系统至少分成三层：

1. 预算执行层：
   - 裁能力
   - compact
   - continuation
2. 预算观测层：
   - context usage
   - session state
   - pending action
3. 预算建议层：
   - context suggestions
   - 可视化分项
   - CLI / host 的调优入口

所以它真正成熟的地方不是“会省 token”，而是：

- 它会告诉你现在为什么贵、为什么卡、接下来该怎么改

## 2. `get_context_usage` 与 `/context`：观测的是 API 真相，不是聊天感觉

`/context` 与 SDK `get_context_usage` 共享同一条 `collectContextData(...)` 路径。

而这条路径会显式复用 query 前的关键转换：

1. `getMessagesAfterCompactBoundary`
2. `projectView`
3. `microcompactMessages`

源码注释写得很直白：

- `/context` 要显示 what the model actually sees，而不是 REPL raw history

这意味着预算观测不是：

- 统计当前终端里出现过多少文本

而是：

- 统计真正进入模型上下文的工作集结构

这点决定了后续调优不会跑偏。

## 3. `analyzeContextUsage(...)`：系统在统计什么，等于系统在意什么

`analyzeContextUsage(...)` 把上下文拆成至少十类预算对象：

1. system prompt
2. system tools
3. MCP tools
4. deferred builtin tools
5. deferred MCP tools
6. custom agents
7. memory files
8. skills
9. slash commands
10. messages / autocompact buffer

这说明 Claude Code 并不把“上下文”看成一团消息历史，而是看成：

- 规则层
- 能力层
- 记忆层
- 协作层
- 消息层

五种可单独观测、单独收缩的预算平面。

## 4. `ContextVisualization`：预算不只可统计，还可被人类快速理解

`ContextVisualization.tsx` 有两个很关键的设计信号。

### 4.1 它显式显示 context-collapse 发生了什么

`CollapseStatus()` 的注释已经说明：

- 这是用户能看到“上下文被改写了”的唯一地方

也就是说，Claude Code 并不满足于内部偷偷 compact 或 collapse。
它还主动解释：

- summary 发生了多少
- staged span 有多少
- 是否出现过 collapse error

### 4.2 它把预算拆成前台可消费的结构

它不仅显示：

- `categories`
- `gridRows`
- `rawMaxTokens`

还把：

- `memoryFiles`
- `mcpTools`
- `deferredBuiltinTools`
- `systemTools`
- `systemPromptSections`
- `agents`
- `skills`
- `messageBreakdown`

都接成前台消费结构。

所以 Claude Code 的预算不是后台统计页，而是：

- 前台认知控制面的一部分

## 5. `ContextSuggestions`：系统已经在把观测结果翻译成动作建议

`generateContextSuggestions(...)` 做的不是抽象分析，而是把预算结果翻译成下一步动作。

它会判断：

- near capacity
- large tool results
- read result bloat
- memory bloat
- autocompact disabled

然后给出针对性建议，例如：

- Bash 输出太肥，改用 `head` / `tail` / `grep`
- Read 结果太大，改用 `offset` / `limit`
- Memory 太大，去 `/memory` 修剪
- 快满且 autocompact 关闭，主动 `/compact`

`ContextSuggestions.tsx` 甚至会直接显示：

- warning / info
- 预计可节省 token

这说明作者并不把预算观测停留在：

- “这里有个图，你自己想怎么办”

而是继续推进到：

- “这里有个图，而且系统已经替你把最可能的动作列出来了”

## 6. `pending_action` 与 `session_state_changed`：阻塞本身也是预算对象

如果只观测 token，不观测状态，宿主仍然会误判很多问题。

`notifySessionStateChanged(...)` 明确把：

- `requires_action`
- `pending_action`
- `session_state_changed`

外化给宿主。

更进一步，`ccrClient.ts` 在 worker 初始化时还会主动清理：

- stale `pending_action`
- stale `task_summary`

原因也写得很明白：

- worker crash 后，旧状态不会自动随进程重启一起消失

这说明 Claude Code 对“预算观测”的理解已经扩大到了：

- 当前窗口花了多少 token
- 当前系统是不是 blocked
- 当前 block 是不是仍然有效

所以阻塞状态并不是事件流附属品，而是：

- 观测型预算系统的一部分

## 7. 为什么这是调优闭环，而不是观测面堆叠

Claude Code 这里真正值得学的，不是“接口多”。

而是它形成了闭环：

1. query / compact / capability filter 执行预算收缩
2. `get_context_usage` / `/context` 把预算结构观测出来
3. `ContextSuggestions` 把观测翻译成可操作建议
4. `pending_action` / `session_state_changed` 告诉宿主当前是不是该先处理 block
5. 下一轮 prompt / tools / memory / compact 策略据此调整

这就是一个完整的：

- observe -> diagnose -> act

闭环。

## 8. 苏格拉底式追问

### 8.1 为什么“能看到 token 百分比”还不够

因为百分比只能告诉你：

- 快满了

却不能告诉你：

- 是 system prompt 太胖
- 还是 tools 太宽
- 还是 memory 太大
- 还是 tool results 太吵

### 8.2 为什么 ContextSuggestions 不是 UX 点缀

因为它把预算观测第一次翻译成了：

- 下一步该改什么

没有这一步，用户和宿主仍然会退回凭感觉调优。

### 8.3 为什么 `pending_action` 也该算预算观测

因为 blocked state 本质上是在告诉你：

- 当前真正稀缺的不是 token，而是用户动作或审批结果

## 9. 一句话总结

Claude Code 的预算系统不是“先自动纠偏，出了问题你自己猜”，而是“自动纠偏 + 结构观测 + 动作建议 + 状态外化”组成的调优闭环。
