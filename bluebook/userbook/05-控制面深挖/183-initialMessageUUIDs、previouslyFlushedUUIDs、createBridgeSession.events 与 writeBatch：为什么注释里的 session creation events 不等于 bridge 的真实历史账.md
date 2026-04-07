# `initialMessageUUIDs`、`previouslyFlushedUUIDs`、`createBridgeSession.events` 与 `writeBatch`：为什么注释里的 session creation events 不等于 bridge 的真实历史账

## 用户目标

181 已经把 bridge create / hydrate 拆成：

- session birth
- history hydrate

182 又把 model 这条线拆成：

- create-time stamp
- live shadow
- durable usage
- resumed fallback

但如果正文停在这里，读者还是很容易把 bridge 里另一句很危险的注释写平：

- `initialMessageUUIDs` 不就是 “messages sent as session creation events” 吗？
- 那它不就等于建会话时已经成功送达的历史消息集合？
- 既然 `writeMessages()` 用它做 dedup，岂不是可以把它当作 create-time delivery ledger？
- `previouslyFlushedUUIDs` 不也只是同一张账的另一个缓存副本吗？

这句还不稳。

从当前源码看，这里至少还要继续拆开三种不同对象：

1. create-time event slot
2. local dedup seed
3. real history delivery ledger

如果这三层不先拆开，后面就会把：

- `createBridgeSession.events`
- `initialMessageUUIDs`
- `previouslyFlushedUUIDs`

重新压成同一种“历史已送达账本”。

## 第一性原理

更稳的提问不是：

- “哪一组 UUID 代表这批初始消息已经发给了 server？”

而是先问五个更底层的问题：

1. 当前集合是在回答“理论上哪些消息属于初始历史”，还是“哪些消息已经被 server 确认吃进去了”？
2. 当前集合是在服务本地 `writeMessages()` 的防重，还是在服务远端 delivery truth？
3. 当前集合是在 session birth 时产生，还是在 `writeBatch(...)` 成功后才更新？
4. 当前集合如果被误用，会让人把 create-time events 与 post-connect flush 混成哪一种错误叙述？
5. 如果三个对象虽然都围绕“初始消息”组织，为什么还要把它们写成不同账本？

只要这五轴不先拆开，后面就会把：

- session creation events
- initial message dedup
- actual flush success

混成一句模糊的“这批历史已经送出去了”。

## 第一层：`createBridgeSession.events` 先是 wire slot，不是当前 bridge 的真实历史账

`createSession.ts` 的 helper signature 明确接受：

- `events: SessionEvent[]`

request body 也会把：

- `events`

写进：

- `POST /v1/sessions`

这说明 `createBridgeSession.events` 首先回答的问题是：

- session create request 在 wire 上允许携带什么初始事件

但 181 已经钉死：

- 当前 bridge caller 实际都传 `events: []`
- 初始历史不走这条路径

所以更准确的理解不是：

- 当前 bridge 的初始历史已经作为 session creation events 送出了

而是：

- `events` 在当前 bridge 里只是一个未被历史回放采用的 wire slot

## 第二层：`initialMessageUUIDs` 只是从 `initialMessages` 派生出来的本地 dedup seed

`replBridge.ts` 会先做：

- `const initialMessageUUIDs = new Set<string>()`
- 遍历 `initialMessages`
- 把每条 `msg.uuid` 塞进去

这说明 `initialMessageUUIDs` 回答的问题首先是：

- 哪些消息属于当前 REPL 启动时带来的初始历史集合

它不是在回答：

- 这些消息已经通过哪条 transport 成功送达
- 这些消息是否已经被 server durable persist

更关键的是，`recentPostedUUIDs` 会立刻：

- 用 `initialMessageUUIDs` 进行 seed

注释写的是：

- 这样当 server 把初始上下文 echo 回来时，它们能被识别成 echo

所以 `initialMessageUUIDs` 的第一身份其实是：

- local dedup seed

不是：

- remote delivery ledger

## 第三层：源码注释把 `initialMessageUUIDs` 写成 session creation events，但当前实现已经不支持这句表述

`writeMessages()` 附近的注释当前写着：

- `initialMessageUUIDs: messages sent as session creation events`

但同一个文件更早处又明确写死：

- initial messages are NOT included as session creation events
- they are flushed via the ingress WebSocket once it connects

这说明当前代码里其实存在一个很窄但很关键的错位：

- 变量用途仍然成立
- 注释里的历史来源叙述已经落后于实现

换句话说，今天更准确的表述不是：

- `initialMessageUUIDs` = messages sent as session creation events

而是：

- `initialMessageUUIDs` = startup 时已知初始历史的 UUID 集，用来给本地 dedup / echo filter 提前播种

所以更准确的理解不是：

- 这句注释能作为当前历史送达路径的证据

而是：

- 这句注释恰好证明了“变量名用途”与“历史来源叙述”已经分叉

## 第四层：真正的历史送达账只有在 `writeBatch(...)` 成功后才会落到 `previouslyFlushedUUIDs`

`replBridge.ts` 的初始 flush 逻辑会：

- 先从 `initialMessages` 中过滤出 eligible messages
- 排除 `previouslyFlushedUUIDs`
- 通过 `toSDKMessages(...)` 转成 SDK messages
- `newTransport.writeBatch(events)`

而真正把 UUID 写回 ledger 的时机是：

- `writeBatch(...)` resolve 之后
- 且 `droppedBatchCount` 没有增加

只有这时才会：

- 遍历 `sdkMessages`
- 把 `sdkMsg.uuid` 加进 `previouslyFlushedUUIDs`

这说明 `previouslyFlushedUUIDs` 回答的问题才是：

- 哪些初始历史消息已经通过当前 ingress flush 成功送达，可以在以后被安全排除

所以更准确的理解不是：

- `initialMessageUUIDs` 与 `previouslyFlushedUUIDs` 只是同一张账的不同副本

而是：

- 前者是 local seed
- 后者是 flush-success ledger

## 第五层：`writeMessages()` 同时检查两张集合，恰好证明两张账不是同一层

`writeMessages(messages)` 过滤时会同时检查：

- `!initialMessageUUIDs.has(m.uuid)`
- `!recentPostedUUIDs.has(m.uuid)`

这里如果把 `initialMessageUUIDs` 写成真实 delivery ledger，
就会漏掉一个关键事实：

- 它甚至不要求这批消息真的已经 flush 成功

因为它在 startup 时就已经被建好了，
比真实 `writeBatch(...)` 成功早得多。

而 `previouslyFlushedUUIDs` 的时序恰恰相反：

- 它必须等 flush 成功后才被追加

所以这三组对象的时序已经直接分家：

1. `createBridgeSession.events`
   wire slot
2. `initialMessageUUIDs`
   startup local seed
3. `previouslyFlushedUUIDs`
   post-flush delivery ledger

这也解释了为什么如果把 `initialMessageUUIDs` 错写成“已送达账”，正文就会立刻失真。

## 第六层：为什么这页不是 181、55 或 54 的附录

### 不是 181 的附录

181 讲的是：

- create-time events 不是 history hydrate mechanism

183 继续往下压的是：

- 在这条结论已经成立之后，`initialMessageUUIDs` 这句旧注释为什么仍不能被误当成真实历史账

181 的主语是：

- birth vs hydrate

183 的主语是：

- local seed vs true delivery ledger

### 不是 55 的附录

55 讲的是：

- `recentPostedUUIDs`
- `recentInboundUUIDs`
- `sentUUIDsRef`
- `lastWrittenIndexRef`

为什么不是同一种去重。

183 当然借用了 `recentPostedUUIDs` 作为对照，
但要证明的不是 echo filtering 总论，
而是：

- `initialMessageUUIDs` 不应被误读成 create-time delivery proof

55 吃掉的是 anti-dup family，
183 吃掉的是 history ledger semantics。

### 不是 54 的附录

54 讲的是：

- initial flush
- flush gate
- reconnect continuity

183 虽然借用了 `writeBatch(...)` 成功后才写 `previouslyFlushedUUIDs` 这件事，
但要证明的不是 flush state machine，
而是：

- 哪个集合才配叫“真实历史账”

## 第七层：这页真正保护的 stable 面与 gray 面

本页真正稳定的判断只有四句：

1. `createBridgeSession.events` 在当前 bridge 实现里不是初始历史送达路径。
2. `initialMessageUUIDs` 只是由 `initialMessages` 派生出来的 local dedup seed。
3. `writeMessages()` 注释里的 “session creation events” 叙述已经落后于当前实现。
4. `previouslyFlushedUUIDs` 只有在 `writeBatch(...)` 成功后才构成真实 history delivery ledger。

而不该在正文里继续放大的灰度细节包括：

- `recentPostedUUIDs` 的环形缓冲容量
- `droppedBatchCount` 的所有失败分支
- reconnect 期间如何重跑 initial flush
- viewer / UI 侧 echo filter 的并行实现

这些可以变化，
但不会推翻本页更硬的结构判断：

- 注释里的 session creation events 不等于 bridge 的真实历史账
