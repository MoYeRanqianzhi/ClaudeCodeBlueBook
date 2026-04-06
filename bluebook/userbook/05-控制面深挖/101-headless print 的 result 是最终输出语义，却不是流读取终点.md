# `lastMessage`、`outputFormat` switch、`gracefulShutdownSync`、`prompt_suggestion` 与 `session_state_changed(idle)`：为什么 headless print 的 `result` 是最终输出语义，却不是流读取终点

## 用户目标

98 已经把一件事讲清：

- `lastMessage` 不会让位给晚到系统尾流

但工程接入方接下来会立刻碰到另一个更实用的问题：

- 如果 `result` 才是最终输出语义，为什么流里还能在它后面继续看到东西？
- `prompt_suggestion`、`task_*`、`session_state_changed(idle)` 到底算不算“最后一个消息”？
- consumer 能不能在看到 `result` 后就停读？
- 默认文本、非 verbose JSON、stream-json、exit code 为什么不跟着最后一个原始流帧走？

如果这些不拆开，正文最容易滑向一句错误总结：

- “`result` 就是最后一个流消息。”

源码不是这么设计的。

## 第一性原理

更稳的提问不是：

- “哪个 frame 最后到？”

而是先问六个更底层的问题：

1. 这里说的“最后”，是最后一个原始 stdout frame，还是最终语义 cursor？
2. 这里要取的是 final answer payload，还是 turn-settled signal？
3. 这个对象只是 stream-visible，还是 terminal-semantic？
4. 当前 path 走的是默认文本 / JSON 收口，还是 raw stream forwarding？
5. `result` 是否可能被 hold-back，导致它在物理顺序上晚到？
6. `result` 之后还能不能继续出现 terminal-inert 尾流？

只要这六轴没先拆开，后续就会把：

- filtered terminal cursor
- raw streamed frames

误写成：

- “看到最后一个 frame 就知道最终答案和退出语义”

## 第一层：`lastMessage` 是 filtered terminal cursor，不是最后一个原始 stdout frame

`print.ts` 一开始就把 headless 收口分成两套账：

- `messages`
- `lastMessage`

而 `lastMessage` 的更新条件非常克制。它会排除：

- `control_*`
- `stream_event`
- `keep_alive`
- `streamlined_*`
- `prompt_suggestion`
- 以及晚到的 `system` 子类：
  - `session_state_changed`
  - `task_notification`
  - `task_started`
  - `task_progress`
  - `post_turn_summary`

这意味着源码守的根本不是：

- “原始流最后到的 frame 就是最终语义”

而是：

- “只有通过 terminal filter 的消息，才有资格更新最终语义 cursor”

所以更准确的句子应该是：

- `lastMessage` 是 filtered terminal cursor

不是：

- “`lastMessage` 就等于最后一个 stdout frame”

## 第二层：默认文本、JSON 与 exit code 都读 filtered cursor，不读原始尾帧

`print.ts` 后面的 `outputFormat` switch 把这层写得很硬：

- `json` + non-verbose：输出单个 `lastMessage`
- `json` + verbose：输出 `messages` 数组，而这个数组本身也是过滤后的集合
- 默认文本：要求 `lastMessage.type === 'result'`，然后根据 `result.subtype` 打印
- `gracefulShutdownSync(...)`：只看 filtered `result.is_error`

这说明 headless `print` 真正交给调用方的 terminal contract 不是：

- “请自行看原始流的末尾”

而是：

- “最终 JSON、默认文本与退出码都绑定在 filtered `result` 上”

所以如果 downstream consumer 只是抓最后一个原始帧，它拿到的很可能不是：

- final answer

而只是：

- terminal-inert tail frame

## 第三层：`result` 不是流读取终点，因为物理尾流可以继续存在

源码里至少有三类证据说明：

- `result` 可以是 terminal final payload
- 但不一定是最后一个 raw stream frame

### 证据一：`heldBackResult` 会改变 `result` 的物理到达时机

`print.ts` 在 background agent 仍在运行时，会先 hold back `result`。

这说明：

- `result` 的物理发送顺序本来就可能被延后

所以“先后顺序”本身就不是唯一语义。

### 证据二：`prompt_suggestion` 被明确设计成出现在 `result` 之后

suggestion 那段注释写得很直接：

- `prompt_suggestion` always arrives after `result`

也就是说：

- `prompt_suggestion` 可以 stream-visible
- 但它不参与 final JSON / default text / exit code 的 terminal 结算

### 证据三：`finally` 里还会追加 idle 与 terminal task bookends

`finally_post_flush` 阶段会：

- `notifySessionStateChanged('idle')`
- 再把 `drainSdkEvents()` 的尾流灌进输出

这意味着在 `result` 之后，流里还可能继续看到：

- `session_state_changed('idle')`
- terminal `task_notification` bookends

所以这里必须改掉一句很诱人的假话：

- “`result` 就是最后一个会出现在流里的对象”

更准确的写法是：

- `result` 是 terminal final payload，但 raw stream tail 可以继续存在

## 第四层：`session_state_changed('idle')` 是 settled signal，不是答案载体

这页最容易被写糊的，是把：

- final answer payload

和：

- turn-settled signal

混成一个东西。

`result` 在这里回答的是：

- 最终答案是什么
- 本轮是否 error
- 默认文本 / JSON / exit code 该怎么收口

而 `session_state_changed('idle')` 回答的是：

- 这一轮现在已经 settle / idle 了吗

所以对于 stream consumer，更稳的分工是：

- 拿 `result` 当 answer/error payload
- 拿 `session_state_changed('idle')` 当 turn-settled signal

不能偷换成：

- “谁最后到，谁就是最终答案”

## 第五层：stream-visible 不等于 terminal-semantic

这层最适合用两个对象对照：

### `prompt_suggestion`

`coreSchemas.ts` 里：

- 它在 `SDKMessageSchema` union 里

也就是说它对 SDK stream consumer 是可见的。

但 `print.ts` 又明确把它排除在 `lastMessage` 之外。

所以它的真实语义是：

- stream-visible
- terminal-inert

### `post_turn_summary`

`coreSchemas.ts` 里它有独立 schema，但不进 `SDKMessageSchema` union；
`controlSchemas.ts` 里它又被加回更宽的 `StdoutMessageSchema`。

再加上：

- `print.ts` 过滤它
- `directConnectManager.ts` 也过滤它

这说明它更进一步：

- 既不是 terminal-semantic
- 也不是普通 core SDK message 成员

于是这页最重要的一条第一性原则就是：

- stream-visible 与 terminal-semantic 是两条不同坐标轴

## 第六层：最常见的假等式

### 误判一：`result` 既然最重要，那它一定也是最后一个 raw frame

错在漏掉：

- suggestion、idle 与 terminal task 尾流都可能在它后面继续出现

### 误判二：最后一个原始流帧就等于最终输出语义

错在漏掉：

- 默认文本、JSON 与 exit code 都读 filtered `lastMessage`

### 误判三：`prompt_suggestion` 既然属于 `SDKMessage`，就应该影响 terminal 结算

错在漏掉：

- 它虽 stream-visible，却被显式排除在 `lastMessage` 之外

### 误判四：`session_state_changed('idle')` 是最后一个状态，所以也该代表最终答案

错在漏掉：

- 它代表 settled signal，不代表 answer payload

### 误判五：`post_turn_summary` 既然有 schema，就该和普通 SDK messages 一样参与终态判断

错在漏掉：

- 它不进 `SDKMessageSchema`，常规 CLI / direct-connect 路径还会继续过滤它

## 第七层：稳定、条件与内部边界

### 稳定可见

- `lastMessage` 是 filtered terminal cursor，不是最后一个原始 stdout frame。
- 默认文本、非 verbose JSON 与 exit code 都绑定在 filtered `result` 上。
- `result` 之后仍可能出现 raw stream tail，因此 `result` 不是流读取终点。
- `prompt_suggestion` 可以 stream-visible，但 terminal-inert。

### 条件公开

- 是否存在 `heldBackResult`、background tasks 与 `session_state_changed` env gate，会改变 `result` 后面还会不会继续出现尾流。
- `outputFormat` 不同，会改变 consumer 看到的是最终收口，还是更完整的 stream path。

### 内部 / 灰度层

- `post_turn_summary` 的 internal 边界、stdout-vs-SDKMessage split，以及具体 consumer heuristic。
- terminal task bookends 的具体类型与最终宿主如何消费这些尾流。

## 第八层：苏格拉底式自检

### 问：为什么这页不能并回 98？

答：98 讲的是为什么 result 不让位给 late tail；这页讲的是“即便不让位，为什么 tail 仍然会继续存在，以及 downstream 应该怎样分读”。

### 问：为什么 `outputFormat` switch 值得成为正文主证据？

答：因为它把 terminal semantics 从“概念判断”压成了实际收口代码：打印什么、输出什么 JSON、退出码怎么算，都在那里。

### 问：为什么 `prompt_suggestion` 值得写进这页，而不是继续写进 suggestion 页？

答：因为这页用它证明的不是 suggestion 本身，而是“stream-visible 也可以 terminal-inert”这条 terminal contract。

### 问：为什么 `session_state_changed('idle')` 必须和 `result` 分开写？

答：因为一个回答“答案是什么”，另一个回答“回合是否 settle”，二者对 consumer 的用途根本不同。

## 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts`
- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
