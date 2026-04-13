# `controlSchemas`、`agentSdkTypes`、`directConnectManager`、`useDirectConnect` 与 `sdkMessageAdapter`：为什么 builder transport、callback surface 与 UI consumer 不是同一张可见性表

## 用户目标

105 已经讲清：

- `post_turn_summary` 不在 core `SDKMessage` surface 里
- 但仍在更宽 `StdoutMessage` 层里

108 又已经讲清：

- direct connect 对 `post_turn_summary` 的过滤是 callback consumer-path narrowing
- 不是 wire existence denial

110 继续说明：

- `streamlined_*` 与 `post_turn_summary` 虽然同样在 skip list 里
- 但不是同一种 suppress reason

但继续往下读时，读者仍然很容易把更上层的一整张表写平：

- `controlSchemas.ts`、`agentSdkTypes.ts`、`directConnectManager`、`useDirectConnect` 都在谈消息，那它们是不是只是在不同文件里写同一张 visibility table？
- 既然 `directConnectManager` 先按 `StdoutMessage` parse、再把对象交给 `onMessage: SDKMessage`，是不是说明 parse gate、callback surface 和 UI consumer 其实是一回事？
- `sdkMessageAdapter` 既然又会把某些 `SDKMessage` 忽略掉，那是不是它只是在重复前面的过滤？

如果这些不拆开，正文最容易滑成一句错误总结：

- “Claude Code 对外其实只有一张消息可见性表，不同文件只是不同位置的重复实现。”

从当前源码看，这个结论并不成立。

## 第一性原理

更稳的提问不是：

- “到底哪些消息可见？”

而是先问五个更底层的问题：

1. 当前讨论的是 builder/control transport，还是 public/core SDK surface？
2. 当前讨论的是 parse admissibility，还是 callback delivery contract？
3. 当前讨论的是 callback 层，还是 UI transcript consumer？
4. 当前源码证明的是“某对象属于哪层 union”，还是“某 consumer 最终会不会显示它”？
5. 当前缺的是一张总表，还是多层逐级收窄的表？

只要这五轴不先拆开，后续就会把：

- same message family appears in multiple files

误写成：

- same visibility table

## 第一层：`controlSchemas.ts` 明说它回答的是 builder/control transport

`controlSchemas.ts` 文件头写得很直：

- these schemas define the control protocol between SDK implementations and the CLI
- used by SDK builders
- SDK consumers should use `coreSchemas.ts` instead

而它的 `StdoutMessageSchema` 又明确是一个更宽 union：

- `SDKMessageSchema()`
- `SDKStreamlinedTextMessageSchema()`
- `SDKStreamlinedToolUseSummaryMessageSchema()`
- `SDKPostTurnSummaryMessageSchema()`
- control families

这说明 `controlSchemas.ts` 回答的问题不是：

- “普通 SDK consumer 默认能拿到什么”

而是：

- “builder / control transport 这一层允许在 stdout/control wire 上承载什么”

所以这里首先要钉死的一句是：

- builder/control transport table 从一开始就比 public/core SDK surface 更宽

## 第二层：`agentSdkTypes.ts` 又明确把 public API 锚在 `coreTypes`

`agentSdkTypes.ts` 文件头同样写得很直：

- public SDK API re-exports `sdk/coreTypes.ts` and `sdk/runtimeTypes.ts`
- builders who need control protocol types should import from `sdk/controlTypes.ts` directly

而后面的类型导入也再次确认：

- `SDKMessage` 来自 `./sdk/coreTypes.js`

这说明 public API 这层回答的问题是：

- “普通 SDK consumer 默认面对哪一组 common serializable types”

而不是：

- “control transport 整体允许承载哪一切对象”

所以 `agentSdkTypes.ts` 和 `controlSchemas.ts` 并不是：

- 两个地方重复定义同一张可见性表

更准确的写法应是：

- 一个在定义更宽的 builder/control transport 面
- 一个在定义更窄的 public/core SDK 面

## 第三层：`directConnectManager` 站在两层之间，做的是 parse widening + callback narrowing

`directConnectManager.ts` 正好把这两层并列摆到一个文件里：

- parse gate 只用 `isStdoutMessage(...)` 做浅层判断
- imported type 一边是 `StdoutMessage`
- callback contract 一边是 `onMessage: (message: SDKMessage) => void`

然后它在 parse 之后、callback 暴露之前，再显式 skip 一批对象：

- control families
- `streamlined_*`
- `system.post_turn_summary`

这说明 `directConnectManager` 回答的问题不是：

- “最终 UI 到底显示什么”

而是：

- “更宽 transport ingress 里，哪些对象还能继续被转发到 direct-connect callback surface”

因此它所处的层级应写成：

- between wider transport and narrower callback

而不是：

- final visibility table

## 第四层：`useDirectConnect` 和 `sdkMessageAdapter` 又继续把 callback surface 收窄成 UI consumer

`useDirectConnect.ts` 里，manager 回调拿到 `sdkMessage` 后并不会直接写进消息列表。

它先做两步：

1. 特殊处理 `system.init` 去重
2. 调 `convertSDKMessage(sdkMessage, ...)`

而 `sdkMessageAdapter.ts` 里又不是“所有 `SDKMessage` 都变成消息”。

它会：

- `assistant` -> `message`
- 某些 `user` -> `message`
- `stream_event` -> `stream_event`
- success `result` -> `ignored`
- 只有少数 `system` subtype -> `message`
- 其他大量 subtype -> `ignored`

这说明 callback 层和 UI consumer 层也不是同一张表。

更准确的分层应是：

1. wider builder/control transport
2. narrower direct-connect callback
3. still narrower UI transcript consumer

所以即使一个对象已经进入：

- `onMessage(sdkMessage)`

也仍然不能推出：

- 它就一定会进入 REPL transcript

## 第五层：因此这里至少有四张逐级收窄的表，而不是一张总表

把前面四层合在一起，才能得到这页真正要钉死的判断：

1. `controlSchemas.ts` / `StdoutMessageSchema`：builder/control transport table
2. `agentSdkTypes.ts` / `SDKMessage`：public/core SDK surface
3. `directConnectManager` `onMessage`：direct-connect callback table
4. `useDirectConnect` + `sdkMessageAdapter`：UI transcript consumer table

这四层的共同点是：

- 都在处理“消息”

这四层的不同点是：

- 它们回答的不是同一个 visibility question

所以这页最需要避免的短路结论就是：

- “从 transport 到 UI 只是同一张表的重复实现。”

更准确的写法应是：

- 从 transport 到 UI 是一组层层收窄、对象身份不完全相同的可见性表

## 第六层：这也解释了为什么同一个 family 会在不同层得到不同答案

以 `post_turn_summary` 为例：

- 在 `StdoutMessageSchema` 层：可承认
- 在 core/public `SDKMessage` 层：不属于 union
- 在 direct-connect callback 层：被 manager 主动挡住
- 在 UI transcript 层：即便进入 callback，也没有被 adapter 设计成正文消息

以 `streamlined_*` 为例：

- 在 `StdoutMessageSchema` 层：可承认
- 在 public/core `SDKMessage` 层：不属于 union
- 在 direct-connect callback 层：被 manager 主动挡住
- 在 UI transcript 层：更谈不上进入正文主通道

所以真正的经验法则不是：

- “某个 family 可见 / 不可见”

而是：

- “先说清当前问的是哪一张表，再谈该 family 在该表里的命运”

## 第七层：稳定层、条件层与灰度层

### 稳定可见

- multiple narrowing visibility tables != one universal message-visibility contract
- `controlSchemas.ts` 当前明确面向 builder/control protocol，且 `StdoutMessageSchema` 比 `SDKMessageSchema` 更宽
- `agentSdkTypes.ts` 当前明确把 public API 锚在 `coreTypes` / `runtimeTypes`
- `directConnectManager` 当前先按 `StdoutMessage` parse，再按 `SDKMessage` callback 暴露，并在中间继续过滤
- `useDirectConnect` / `sdkMessageAdapter` 当前又把 callback-visible object 继续收窄成 UI consumer result

### 条件公开

- 这四层表现在能稳定在这页落下，是因为当前源码刚好把 transport、public/core、callback、UI consumer 并排露出；别的宿主路径是否严格沿同一梯子工作，仍取决于 host/consumer route
- 哪些 `SDKMessage` family 会在每一层保留同样厚度，仍取决于当前 manager、adapter 与 hook sink 的具体消费方式
- callback-visible object 最终会不会进入 transcript，也仍取决于当前 adapter policy 与 hook sink，而不是 callback membership 自己保证

### 内部/灰度层

- manager / adapter 的 exact helper 顺序与 host wiring
- manager / adapter 的收窄理由是否在所有 family 上都被显式文档化
- 未来宿主会不会在 transport、callback 与 UI 之间再插入第五张 consumer table

所以更稳的结论必须停在：

- multiple narrowing visibility tables

而不能滑到：

- one universal message-visibility contract

## 第八层：为什么 111 不能并回 108

108 的主语是：

- `post_turn_summary` 在 direct connect 里为什么属于 callback consumer-path narrowing

111 继续往上压的主语则是：

- wider transport、public/core surface、callback surface 与 UI consumer 为什么根本不是同一张表

前者讲：

- one family inside one narrowing step

后者讲：

- the ladder itself

不该揉成一页。

## 第九层：为什么 111 也不能并回 110

110 的主语是：

- `streamlined_*` 与 `post_turn_summary` 同样被 direct connect 过滤，却不是同一种 suppress reason

111 的主语已经换成：

- 从 builder/control transport 到 UI consumer 的四层表为什么不能压成一张

前者讲：

- two families within one callback gate

后者讲：

- the whole table stack

也必须分开。

## 第十层：最常见的假等式

### 误判一：`controlSchemas.ts` 和 `agentSdkTypes.ts` 都在写 SDK message，所以它们只是同一张表的两种写法

错在漏掉：

- 一个面向 builder/control transport，一个面向 public/core SDK surface

### 误判二：`directConnectManager` 既然输出 `SDKMessage`，那 parse gate、callback contract 和 UI consumer 就已经合并了

错在漏掉：

- `useDirectConnect` / `sdkMessageAdapter` 还会再收一次

### 误判三：进入 `onMessage` 的对象就一定会进入 transcript

错在漏掉：

- adapter 会把很多 callback-visible `SDKMessage` 继续判成 `ignored`

### 误判四：不在 `SDKMessageSchema` 里，就等于 transport 也不承认

错在漏掉：

- `StdoutMessageSchema` 本来就更宽

### 误判五：Claude Code 对外只有一张消息可见性表

错在漏掉：

- 当前源码至少展示了 transport、public/core、callback、UI consumer 四层

## 第十一层：苏格拉底式自审

### 问：我是不是又在问“可见吗”，却没先说是哪一层？

答：如果是，就回到四张表重新定位。

### 问：我是不是把 callback 结果直接写成了 UI 结果？

答：如果是，就漏掉了 `useDirectConnect` / `sdkMessageAdapter` 的第二次收窄。

### 问：我是不是把 builder/control transport 写成了普通 public SDK surface？

答：如果是，就和 `controlSchemas.ts` 文件头的分工相冲突。

### 问：我是不是又把所有宿主路径都一概压进这四层？

答：如果是，就已经超出这页的可证范围了。
