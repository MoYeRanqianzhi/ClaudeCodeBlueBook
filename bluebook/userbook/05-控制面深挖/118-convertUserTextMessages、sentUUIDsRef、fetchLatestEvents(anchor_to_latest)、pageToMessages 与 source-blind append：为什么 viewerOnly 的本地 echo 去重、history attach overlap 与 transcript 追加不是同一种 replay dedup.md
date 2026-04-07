# `convertUserTextMessages`、`sentUUIDsRef`、`fetchLatestEvents(anchor_to_latest)`、`pageToMessages` 与 source-blind append：为什么 viewerOnly 的本地 echo 去重、history attach overlap 与 transcript 追加不是同一种 replay dedup

## 用户目标

117 已经讲清：

- `system.init` 可以同时作为 metadata object
- callback-visible object
- transcript prompt
- slash bootstrap input

而不是同一种初始化可见性。

接着往下读时，读者又很容易把 viewer/history 这组相邻概念压成一句：

- `convertUserTextMessages` 打开了
- `sentUUIDsRef` 在去重
- history `anchor_to_latest` 会先拉最新页
- live `/subscribe` 还会继续 append

于是正文就会滑成一句看起来顺、实际上错误的话：

- “viewerOnly 基本上有一套统一的 replay dedup，所以不管是本地 echo 还是 history/live overlap，本质都在同一个去重机制里解决。”

从当前源码看，这也不成立。

这里至少有三种不同问题：

1. 哪些 replayed user text 该被投成 `message`
2. 哪些本地先插入的 user message 应该把后续 WS echo 丢掉
3. history latest page 和 live append 如果覆盖了同一事件窗口，谁来做跨来源重叠去重

这三者都和“重放时别重复”有关，但不是同一种 replay dedup。

## 第一性原理

更稳的提问不是：

- “viewerOnly 会不会重复显示？”

而是先问五个更底层的问题：

1. 当前说的是 visibility policy，还是 dedup policy？
2. 当前重复来自本地先插、远端后 echo，还是来自 history page 和 live stream 两个来源？
3. 当前去重键是谁写入的，何时写入的，覆盖面多宽？
4. transcript 在追加消息时，有没有跨来源 UUID/source 索引？
5. 当前这条消息之所以出现两次，是因为 adapter 太宽，还是因为不同来源都把它喂进了同一个 source-blind sink？

只要这五轴先拆开，下面几件事就不会再被写成同一套 replay dedup。

## 第一层：`convertUserTextMessages` 先回答的是 visibility，不是 dedup

`sdkMessageAdapter.ts` 对 `convertUserTextMessages` 的注释非常明确：

- 它用于 converting historical events
- 因为 user-typed messages 需要被显示出来
- live WS 模式下这些消息默认忽略，因为 REPL 已经本地加过了

所以这一项开关首先回答的是：

- “历史/回放里的 user text 要不要变成 `message`”

而不是：

- “同一条 user text 如果来自多个来源，要怎样去重”

`useRemoteSession.ts` 在 `viewerOnly` 时把：

- `convertToolResults: true`
- `convertUserTextMessages: true`

一起打开。

`useAssistantHistory.ts` 的 `pageToMessages(page)` 也用同样的 options。

这说明 live viewer 和 history replay 共享的是：

- 同一套 message visibility policy

不是：

- 同一套 dedup mechanism

如果把 `convertUserTextMessages` 直接写成“viewer dedup 开关”，正文一开始就会跑偏。

## 第二层：`sentUUIDsRef` 只解决 local-first / WS-echo 的自回声去重

真正的 dedup 逻辑在 `useRemoteSession.ts` 里写得很具体。

注释先把问题讲死：

- 本地会先 `createUserMessage(...)`
- 然后把同一个 `uuid` 传给 remote session
- server 和/或 worker 会把这条 user message 再 echo 回 WS
- 如果不丢掉 echo，viewer 会看到双写

REPL 的本地链路也吻合这段注释：

1. 先 `createUserMessage(...)`
2. 先 `setMessages(prev => [...prev, userMessage])`
3. 再 `activeRemote.sendMessage(remoteContent, { uuid: userMessage.uuid })`

`useRemoteSession.sendMessage(...)` 又会：

- 在 POST 前先 `sentUUIDsRef.current.add(opts.uuid)`

注释还特意强调：

- 必须在 POST 前写入，避免 echo 先到达

之后 live WS 回调收到 user message 时才做：

- `sdkMessage.type === 'user'`
- `sdkMessage.uuid`
- `sentUUIDsRef.current.has(sdkMessage.uuid)`
- 命中就 return

所以 `sentUUIDsRef` 回答的是非常窄的一件事：

- 本地先插入过的 user message，后续从 WS 回来的同 UUID echo 要不要丢

它不是：

- 通用 viewer replay dedup

更不是：

- history 与 live 两个来源之间的 overlap dedup

## 第三层：history attach overlap 是另一类问题，因为它根本不往 `sentUUIDsRef` 里播种

`useAssistantHistory.ts` 在 mount 时会：

- `fetchLatestEvents(ctx, { anchor_to_latest: true })`
- 把返回的 latest page 经过 `pageToMessages(page)`
- 然后 `prepend(page, true)` 到 transcript 前部

而 `sessionHistory.ts` 对 `fetchLatestEvents(...)` 的注释也说得很直白：

- 取 newest page
- via `anchor_to_latest`
- 返回的是最后 `limit` 条事件

这意味着 attach 之后，viewer 很可能同时面对两条来源：

1. 由 history API 拉下来的 latest page
2. 由 live `/subscribe` 继续推来的实时事件流

如果这两个来源覆盖了同一时间窗里的某些事件，问题就已经不再是：

- “这是不是我自己刚发出去的那条本地 user message”

而是：

- “同一条远端事件，既出现在 history latest page，又出现在 live append 里，要不要跨来源去重”

而当前源码里最关键的一句注释已经把边界钉死：

- `sentUUIDsRef` does NOT dedup history-vs-live overlap at attach time
- nothing seeds the set from history UUIDs
- only `sendMessage` populates it

这句几乎就是 118 的根结论。

所以 history attach overlap 回答的是：

- cross-source overlap dedup

不是：

- local echo filter

## 第四层：`pageToMessages` 和 live `convertSDKMessage(...)` 共用 adapter，但 transcript sink 仍然是 source-blind 的

这一层最容易被漏掉。

因为很多人看到：

- history path 用 `pageToMessages(page)`
- live path 也会 `convertSDKMessage(...)`

就会以为：

- “既然都过同一个 adapter，重复应该会在这里顺手解决”

但当前源码完全不是这样。

`pageToMessages(page)` 只是：

- 遍历 `page.events`
- `convertSDKMessage(ev, { convertUserTextMessages: true, convertToolResults: true })`
- 收集 `c.type === 'message'`

live path 则是：

- `convertSDKMessage(sdkMessage, same opts)`
- `if (converted.type === 'message') setMessages(prev => [...prev, converted.message])`

history prepend 也是：

- `return [...msgs, ...base]`

live append 也是：

- `return [...prev, converted.message]`

这里没有任何一步建立：

- 跨来源 UUID 索引
- source tag
- history-vs-live 对账表

所以 transcript 这一层更准确的主语应是：

- source-blind sink

它只知道：

- 有一批 `Message` 要 prepend
- 又有一批 `Message` 要 append

并不知道：

- 它们是否来自同一原始事件

因此同一个 adapter，并不会天然带来同一个 dedup。

## 第五层：所以“同样看上去是重复”其实至少分成三类

把上面几层压实之后，更稳的总表是：

| 问题层 | 当前回答什么 | 典型例子 |
| --- | --- | --- |
| visibility policy | 哪些 replayed user text 要变成 `message` | `convertUserTextMessages` |
| local echo dedup | 本地先插入的 user message，后续 WS echo 要不要丢 | `sentUUIDsRef` |
| cross-source overlap dedup | history latest page 和 live stream 覆盖同一事件时，要不要跨来源对账 | attach-time history-vs-live overlap |
| sink behavior | 两个来源产出的 `Message` 最终如何被写进 transcript | prepend / append 的 source-blind sink |

所以真正该写成一句话的是：

- `convertUserTextMessages` 先决定“要不要显示”
- `sentUUIDsRef` 再解决“本地自回声要不要丢”
- history/live overlap 则是另一条当前没有统一索引兜底的跨来源问题

三者不是同一种 replay dedup。

## 第六层：为什么这页不能并回 117

117 的主语是：

- raw `system.init` 在 metadata、callback、dedupe、prompt 与 bootstrap 里不是同一种初始化可见性

118 的主语已经换成：

- viewer/history 两条来源在 transcript 重放时，visibility、echo dedup 与 overlap dedup 不是同一种来源协调

前者讲：

- init visibility

后者讲：

- replay source overlap

不是一页。

## 第七层：为什么 118 也不能并回 115

115 的主语是：

- adapter 内不同 policy

118 虽然也绕不过 `convertUserTextMessages`，但核心冲突已经不在 adapter 内部，而在：

- local-first insertion
- WS echo
- history latest page
- source-blind transcript sink

这些来源关系之间。

所以这页不是：

- another adapter policy page

而是：

- one replayed message across multiple origins and dedup layers

## 第八层：当前源码能稳定证明什么，不能稳定证明什么

从当前源码可以稳定证明的是：

- `convertUserTextMessages` 只是在 live viewer/history path 上打开 replay visibility
- `sentUUIDsRef` 只由 `sendMessage(..., { uuid })` 写入
- 这个 ring 只针对本地 POST 之后的 WS echo
- 代码明确声明它不处理 attach-time history-vs-live overlap
- transcript prepend/append 当前没有跨来源 UUID/source 对账层

从当前源码不能在这页稳定证明的是：

- `/subscribe` 在 attach/reconnect 时一定带 backlog replay
- 实际线上 overlap 的频率有多高
- future build 不会新增跨来源 dedup index

所以这页最稳的结论必须停在：

- same replay duplication symptom != same dedup mechanism

而不能滑到：

- viewerOnly currently guarantees universal replay dedup

## 第九层：最常见的假等式

### 误判一：`convertUserTextMessages` 打开了，所以 viewer 自然就会把重复 user text 去掉

错在漏掉：

- 这是 visibility policy，不是 dedup policy

### 误判二：`sentUUIDsRef` 既然按 UUID 去重，就会顺手处理 history/live overlap

错在漏掉：

- 它根本不从 history page 播种 UUID

### 误判三：history 和 live 都过同一个 adapter，所以最终 transcript 不会重复

错在漏掉：

- sink 仍是 source-blind prepend/append

### 误判四：同一个 viewer 里看到两条相同 user message，根因一定是 echo filter 失效

错在漏掉：

- 也可能是 latest page 与 live append 的跨来源重叠

### 误判五：history replay 里的 init/banner 重复，说明 init visibility 页面没写对

错在漏掉：

- 那是 replay source overlap 的症状，不是 init visibility 本体

## 第十层：苏格拉底式自审

### 问：我现在写的是 visibility、echo dedup，还是 cross-source overlap？

答：如果答不出来，就说明又把 replay dedup 写平了。

### 问：我是不是把 `sentUUIDsRef` 写成了通用去重索引？

答：如果是，就回到 “only `sendMessage` populates it” 这句注释。

### 问：我是不是把 history latest page 和 live stream 的重叠当成 local echo？

答：如果是，就还没把来源问题拆开。

### 问：我是不是把 source-blind transcript append 写成了 adapter 的责任？

答：如果是，就混淆了 consumer policy 和 sink behavior。
