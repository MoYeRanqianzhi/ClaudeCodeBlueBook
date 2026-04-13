# `convertToolResults`、`convertUserTextMessages`、`useAssistantHistory`、`viewerOnly` 与 success `result` `ignored`：为什么 tool_result 本地补画、user text 历史回放与成功结果静默不是同一种 UI consumer policy

## 用户目标

114 已经把：

- callback-visible object
- adapter triad
- hook sink

拆成了三层。

但如果只停在那里，读者还是会在 adapter 内部继续压平另一组差异：

- `convertToolResults`
- `convertUserTextMessages`
- success `result -> ignored`

都发生在 `convertSDKMessage(...)` 附近，是不是只是在做同一种“哪些消息显示、哪些消息不显示”的过滤？

如果不再往下拆，正文很容易滑成一句含糊但错误的话：

- “adapter 里只是把一部分远端消息补成 `message`，把另一部分关掉，本质都是同一种 UI 过滤。”

从当前源码看，这也不成立。

这里至少有三种不同的 consumer policy：

1. remote tool result 的本地补画
2. 历史 user text 的回放补齐
3. 成功收口结果的噪音抑制

它们同处 adapter 层，不等于它们回答的是同一个问题。

## 第一性原理

更稳的提问不是：

- “最后有没有显示成 `message`？”

而是先问五个更底层的问题：

1. 这条 policy 在补一个本地原本没有的可见对象，还是在压掉一个已经不值得再显示的冗余对象？
2. 当前对象是 `user/tool_result`、`user/plain text`，还是 `result/success`？
3. 当前宿主是在 live interaction，还是 history/viewer replay？
4. 当前要避免的是空渲染、历史缺口、echo duplicate，还是 success noise？
5. 本地 UI 原本会自己创建这条消息，还是只能依赖远端 event 回放？

只要这五轴先拆开，三种 policy 就已经不是同一类东西。

## 第一层：同在 `convertSDKMessage(...)` 里，不等于同一种 policy family

`sdkMessageAdapter.ts` 先把 `ConvertOptions` 明确分成：

- `convertToolResults?`
- `convertUserTextMessages?`

随后在 `user` 分支里分别处理：

- tool result
- 非 tool result 的 user text

又在 `result` 分支里单独处理：

- success / non-success result

这说明当前源码结构已经在提醒我们：

- “同在 adapter”

不等于：

- “同一种 consumer contract”

更不等于：

- “同一种显示过滤”

## 第二层：`convertToolResults` 解决的是 remote tool result 的本地补画，不是“把 user 消息打开”

`ConvertOptions` 对 `convertToolResults` 的注释已经把主语写得很清楚：

- direct connect 模式里，tool result 来自 remote server
- 它们需要在本地被转成可渲染、可折叠的 `UserMessage`

进入 `user` 分支后，adapter 先用 `content` 形状检查 `tool_result` block。

它还特意注明：

- 不能依赖 `parent_tool_use_id`

原因不是抽象“类型不稳定”，而是更具体的实现细节：

- agent 侧 `normalizeMessage()` 会把 top-level tool result 的这个字段硬写成 `null`

所以这里解决的是：

- 如何把 remote tool result 可靠识别出来，并在本地按 tool result 语义渲染

不是：

- generic user message replay

也不是：

- callback surface membership 判断

`useDirectConnect.ts` 当前只传：

- `{ convertToolResults: true }`

这尤其关键。

它说明 direct-connect live path 当前真正想补的是：

- remote tool result 的本地显示/折叠一致性

而不是：

- 把所有远端 user text 一并放进 transcript

`useRemoteSession.ts` 在 `viewerOnly` 模式下也会打开这项能力，并直接解释原因：

- remote agent 运行 `BriefTool (SendUserMessage)` 时，`tool_use` block 本身会渲染成空壳
- 实际内容在 `tool_result`

`useAssistantHistory.ts` 也复用了同一组选项，把 history page 里的 event 转成和 viewer mode 相同的消息面。

所以更准确的写法应是：

- `convertToolResults` 是 remote tool result 的本地补画 / render parity policy

不是：

- “把 user 分支打开”的泛化开关

## 第三层：`convertUserTextMessages` 解决的是历史 user text 回放，不是 live prompt echo

`ConvertOptions` 对 `convertUserTextMessages` 的注释同样写得很直接：

- 用于 converting historical events
- 因为 user-typed messages 需要被显示出来
- live WebSocket 模式下，这些消息默认忽略，因为 REPL 已经本地加过了

这句话几乎已经把边界钉死：

- 这里的主问题不是 tool result render parity
- 而是 history / viewer replay completeness

`user` 分支里的实现也吻合这个主语：

- 先排除 `isToolResult`
- 再在 `convertUserTextMessages` 打开时，把普通 user text 转成 `message`
- 否则默认 `ignored`

这意味着它在回答的是：

- “当本地 UI 没有亲手创建过这些 user text 时，要不要把历史里的它们补回来？”

不是：

- “所有 user 类型是不是都该显示？”

`useAssistantHistory.ts` 的 `pageToMessages(page)` 直接把：

- `convertUserTextMessages: true`
- `convertToolResults: true`

一起打开。

这不是因为二者本质相同，而是因为：

- history page 既可能缺 user text replay
- 也可能缺 remote tool result 的本地补画

`useRemoteSession.ts` 对这个边界又补了一层证据。

它专门维护 `sentUUIDsRef`，并明确说明：

- 当 `convertUserTextMessages` 打开时，viewer 会同时看到本地 `createUserMessage(...)`
- 以及 WebSocket echo 回来的同一条 user message
- 如果不做 dedup，就会双写

这说明 `convertUserTextMessages` 的副作用模型是：

- 它不是单纯“多显示一点”
- 它会把 host 带进 replay completeness 和 echo dedup 的联动问题

所以更准确的表述应是：

- `convertUserTextMessages` 是历史 / viewer user text replay policy

不是：

- live direct-connect 下的普通 transcript 开关

## 第四层：success `result -> ignored` 解决的是 success noise 抑制，不是回放/补画

到了 `result` 分支，adapter 的主语又变了。

这里不是在补一个本地缺失对象，而是在做一件相反的事：

- suppress redundant success output

源码注释写得非常明确：

- 只有 error result 需要显示
- success result 在 multi-turn session 里是 noise
- `isLoading=false` 已经是足够的 signal

所以 success `result -> ignored` 解决的不是：

- tool result 看不见
- history user text 缺失

而是：

- 成功收口如果再落成一条正文消息，会让 transcript 在多轮里过于吵

这里最容易被误写的一点是：

- success `result` 被 adapter 忽略

不等于：

- success `result` 没有被当前 host 使用

因为在 `useDirectConnect.ts` 里，`sdkMessage` 进入 adapter 之前就会先经过：

- `isSessionEndMessage(sdkMessage)`

而 `isSessionEndMessage(...)` 的定义非常宽：

- 只要 `msg.type === 'result'`

就会触发 session-end 判断。

于是当前 direct-connect path 上，同一个 success `result` 至少同时参与两件事：

1. 在 hook 状态层触发 `setIsLoading(false)`
2. 在 adapter 文本层被压成 `ignored`

这恰好说明：

- success `result` 静默是一条 transcript policy

不是：

- 对该对象整体“无意义”的判决

也不是：

- 和前两种 replay/backfill policy 属于同一方向的逻辑

前两者在补可见性缺口。

这一者在压冗余可见性。

方向本身就相反。

## 第五层：三种 policy 的真正差异

| policy | 主要对象 | 典型宿主/时机 | 它真正要解决什么 |
| --- | --- | --- | --- |
| `convertToolResults` | remote `user` 消息里的 `tool_result` blocks | direct connect live、viewerOnly、history replay | 把远端 tool result 补成本地可渲染、可折叠的 tool result message |
| `convertUserTextMessages` | 历史或回放到达的普通 user text | assistant history、viewerOnly attach/replay | 把本地从未创建过的 user text 补回消息面，同时承担 echo dedup 风险 |
| success `result -> ignored` | `result` subtype=`success` | multi-turn transcript consumer | 把冗余成功收口静默掉，避免 success noise 覆盖正文阅读体验 |

所以真正该写成一句话的是：

- `convertToolResults` 在补 render parity
- `convertUserTextMessages` 在补 replay completeness
- success `result -> ignored` 在做 noise suppression

这三者不是同一种 UI consumer policy。

## 第六层：稳定层、条件层与灰度层

### 稳定可见

- same adapter layer != same consumer rationale
- `convertToolResults` 当前在补 render parity，而不是 generic user replay
- `convertUserTextMessages` 当前在补 replay completeness，而不是 live transcript 默认开关
- success `result -> ignored` 当前在做 success-noise suppression，不是 replay/backfill 的第三种写法
- success `result` 可以在 transcript adapter 里静默，但仍在 hook 状态层触发 `setIsLoading(false)`；这说明 transcript policy != completion handling

### 条件公开

- direct connect 当前只打开 `convertToolResults`
- assistant history 与 remote viewerOnly 当前会同时打开 `convertToolResults` 和 `convertUserTextMessages`
- `convertUserTextMessages` 不是 live path 默认策略，而是 replay/history/viewer 相关策略
- 哪些宿主会补 user text、哪些宿主只保 tool_result parity，仍取决于当前 host、history 与 attach path

### 内部/灰度层

- 所有宿主未来是否仍只维持这三类 policy
- success `result` 的静默规则会不会被产品策略调整
- 其他 hook/UI 会不会再给 `result` 加第四种 consumer
- `convertToolResults`、`convertUserTextMessages`、`isSessionEndMessage(...)`、`setIsLoading(false)` 的 exact helper 顺序与 host wiring

所以这页能安全落下的结论应停在：

- same adapter layer != same consumer rationale

而不能继续滑成：

- adapter has one universal visibility rule

## 第七层：为什么 115 不能并回 114

114 的主语是：

- callback-visible object 进入 adapter 后，triad 不是 callback mirror

115 的主语则更窄：

- triad 内部几条看起来都像“message / ignored”判断的 policy，其实各自服务不同 consumer problem

114 讲的是：

- layer split

115 讲的是：

- policy split inside one layer

不该揉成一页。

## 第八层：为什么 115 也不能提前并进 completion-signal 那一页

这页确实碰到了：

- `isSessionEndMessage(...)`
- `setIsLoading(false)`
- success `result -> ignored`

但这里真正要讲的是：

- success result 的 transcript 静默不是 replay/backfill policy

还不是完整去讲：

- success `result` ignored
- error `result` visible
- `setIsLoading(false)`

为什么不是同一种 completion signal

所以这页只把边界压到：

- transcript policy != completion handling

更细的 completion split 应该单列。

## 第九层：最常见的假等式

### 误判一：`convertToolResults` 和 `convertUserTextMessages` 都返回 `message`，所以只是同一个开关的两个分支

错在漏掉：

- 一个在补 tool result render parity
- 一个在补 history user replay

### 误判二：`convertUserTextMessages` 既然存在，direct connect live 也应该默认打开

错在漏掉：

- live REPL 本地已经创建 user text
- 打开后会引入 echo duplicate 问题

### 误判三：success `result` 被 adapter 忽略，说明它没有任何消费价值

错在漏掉：

- 它仍然可以先参与 session-end / loading 收口

### 误判四：这三者都发生在 adapter，所以它们属于同一种“可见性过滤”

错在漏掉：

- replay/backfill 和 noise suppression 是相反方向的 policy

### 误判五：viewerOnly 同时打开两项 option，说明这两项 option 只是方便一起传

错在漏掉：

- viewerOnly 同时面对 tool result 缺口和 user text 缺口，是并列问题，不是同一问题

## 第十层：苏格拉底式自审

### 问：我现在写的是 render parity、replay completeness，还是 noise suppression？

答：如果答不出来，就说明又把三种 policy 写平了。

### 问：我是不是把 live local prompt echo 和 history replay 写成了一回事？

答：如果是，就回到 `convertUserTextMessages` 的注释和 `sentUUIDsRef` 的 dedup 说明。

### 问：我是不是把 success `result` 的静默直接写成“它不重要”？

答：如果是，就还没把 transcript policy 和 completion handling 分开。

### 问：我是不是把 `convertToolResults` 写成 generic user replay？

答：如果是，就漏掉了 `tool_result` 形状检测和本地折叠渲染这个主语。
