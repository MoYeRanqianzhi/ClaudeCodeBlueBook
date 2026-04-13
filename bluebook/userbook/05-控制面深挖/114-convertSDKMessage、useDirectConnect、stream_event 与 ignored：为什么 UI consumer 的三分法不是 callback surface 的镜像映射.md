# `convertSDKMessage(...)`、`useDirectConnect`、`stream_event` 与 `ignored`：为什么 UI consumer 的三分法不是 callback surface 的镜像映射

## 用户目标

111 已经讲清：

- builder/control transport
- public/core SDK surface
- direct-connect callback
- UI consumer

至少是四张逐级收窄的表。

113 又已经讲清：

- 相邻层里看起来都像“保留原样”，也不一定是同一种语义

但继续往下读时，读者仍然很容易把 `sdkMessageAdapter` 这一层写平：

- `convertSDKMessage(...)` 返回 `message` / `stream_event` / `ignored`，是不是只是在把 callback surface 换个名字？
- 既然 `useDirectConnect` 把 `sdkMessage` 丢给 adapter，那 adapter 的三分法是不是 callback union 的镜像映射？
- 如果某条 callback-visible `SDKMessage` 最后被 adapter 判成 `ignored`，是不是就说明它其实不该进入 callback？

如果这些不拆开，正文最容易滑成一句错误总结：

- “direct-connect callback 能看到什么，UI consumer 基本就会按 `message` / `stream_event` / `ignored` 原样镜像出来。”

从当前源码看，这个结论并不成立。

## 第一性原理

更稳的提问不是：

- “这条消息最后显示了没有？”

而是先问五个更底层的问题：

1. 当前说的是 callback membership，还是 UI classification？
2. 当前 adapter 在回答“它是什么类型的 SDKMessage”，还是“UI 该怎样消费它”？
3. 当前 `message` / `stream_event` / `ignored` 是 union 成员，还是 consumer decision？
4. 当前 hook 会消费 triad 的全部结果，还是只消费其中一部分？
5. 当前源码证明的是 callback surface 本身，还是 callback object 到 UI sink 的再分类？

只要这五轴不先拆开，后续就会把：

- adapter triad

误写成：

- callback surface mirror

## 第一层：`useDirectConnect` 先拿到的是 callback-visible `SDKMessage`

`useDirectConnect.ts` 里，manager 回调签名收到的是：

- `sdkMessage`

它先做两件非常 callback-local 的事：

- `isSessionEndMessage(sdkMessage)` 时 `setIsLoading(false)`
- 对 `system.init` 做 duplicate suppression

随后才：

- `const converted = convertSDKMessage(sdkMessage, { convertToolResults: true })`

这说明 `sdkMessage` 在进入 adapter 之前，就已经是：

- direct-connect callback surface 上的对象

所以 adapter 回答的问题不可能再是：

- “这条对象到底属不属于 callback surface”

它只能是在 callback 之后回答：

- “既然这条对象已经到 callback 了，UI 现在怎么消费它”

## 第二层：`convertSDKMessage(...)` 的三分法本质上是 consumer classification

`sdkMessageAdapter.ts` 的返回类型不是新的 `SDKMessage` union，而是：

- `ConvertedMessage`

在当前控制流里它至少分成三类：

- `type: 'message'`
- `type: 'stream_event'`
- `type: 'ignored'`

而 switch 里的具体映射也很清楚：

- `assistant` -> `message`
- 某些 `user` -> `message`
- `stream_event` -> `stream_event`
- success `result` -> `ignored`
- `init` / `status` / `compact_boundary` -> `message`
- 许多 `system` subtype、`auth_status`、`tool_use_summary`、`rate_limit_event` -> `ignored`

这说明 triad 回答的问题不是：

- “callback union 里有哪些成员”

而是：

- “callback-visible `SDKMessage` 在当前 UI consumer 看来，该进入正文、进入流事件侧道，还是直接忽略”

所以更准确的写法应是：

- `message` / `stream_event` / `ignored` 是 UI consumer classification

不是：

- callback surface 的镜像重命名

## 第三层：success `result` 被判成 `ignored`，正是“不是镜像映射”的硬证据

如果 adapter 只是 callback surface 的镜像映射，那么：

- callback 里出现的 `result`

就该直接在 triad 里有一个等价的“result-like”主要分类。

但当前源码恰恰不是这样：

- `result` subtype 非 success -> `message`
- success `result` -> `ignored`

而 `useDirectConnect` 又在 adapter 之前，早就拿 success `result` 做了：

- `setIsLoading(false)`

这说明同一个 callback-visible object，在相邻层回答的是两件不同的事：

- callback/hook 层：它能不能作为 completion signal 参与状态收口
- UI adapter 层：它应不应该进入正文消息面

所以 success `result` 的例子正好说明：

- callback-visible != message-visible

也正说明 triad 不是 callback surface 的镜像表。

## 第四层：`stream_event` 也进一步证明 triad 和最终 UI sink 不是同一层

`convertSDKMessage(...)` 对：

- `stream_event`

返回的是：

- `{ type: 'stream_event', event: ... }`

如果 triad 就等于最终 UI sink，那么 `useDirectConnect` 应该会消费：

- `message`
- `stream_event`

两类结果。

但当前 `useDirectConnect.ts` 实际只做：

- `if (converted.type === 'message') setMessages(...)`

这意味着就连 adapter triad 本身，也还不是最后一层。

更准确的分层应是：

1. callback-visible `SDKMessage`
2. adapter triad classification
3. concrete hook sink，只消费其中一部分

所以不能再写成：

- triad already equals final UI behavior

## 第五层：`user` / `system` 的条件映射也说明 triad 回答的是 policy，不是 membership

`user` 分支里：

- tool result blocks + `convertToolResults` -> `message`
- 用户文本 + `convertUserTextMessages` -> `message`
- 否则 -> `ignored`

`system` 分支里：

- `init` -> `message`
- `status` -> 条件性 `message` / `ignored`
- `compact_boundary` -> `message`
- 其他 subtype -> `ignored`

这说明 adapter 在做的是：

- current-host current-policy 下，这条 callback-visible 对象要不要进 UI

而不是：

- 重新声明 callback union 的边界

所以 triad 的正确主语应是：

- consumer policy surface

不是：

- callback membership surface

## 第六层：稳定层、条件层与灰度层

### 稳定可见

- triad != callback mirror
- `useDirectConnect` 当前先拿 callback-visible `sdkMessage`，再调 `convertSDKMessage(...)`
- `convertSDKMessage(...)` 当前至少产出 `message` / `stream_event` / `ignored` 三类 consumer result
- success `result` 当前明明 callback-visible，却仍会被 triad 判成 `ignored`
- `stream_event` 当前是 triad 的一类结果，但并不自动等于当前 hook sink 一定消费

### 条件公开

- `useDirectConnect` 当前只把 `message` 喂进正文消息列表
- `user` / `system` 的一些 subtype 映射到 `message` 或 `ignored`，仍取决于当前 host、adapter policy 与具体 subtype
- triad 之后还有 hook-specific sink decision；哪类 triad 结果会在别的 hook/UI 上继续被消费，仍是条件化实现选择

### 内部/灰度层

- 所有宿主未来是否都会按这套 triad 消费 callback-visible `SDKMessage`
- `stream_event` 在别的 hook 或 UI 上会不会继续被消费
- 当前 triad 是否已经穷尽了所有 UI consumer 分类
- `convertSDKMessage(...)`、`useDirectConnect`、hook sink 的 exact helper 顺序与 host wiring

所以更稳的结论必须停在：

- triad != callback mirror

而不能滑到：

- triad == universal UI contract

## 第七层：为什么 114 不能并回 111

111 的主语是：

- transport、public SDK、callback 与 UI consumer 不是同一张表

114 继续往下压的主语则是：

- adapter triad 为什么不是 callback surface 的镜像映射

前者讲：

- the table stack

后者讲：

- one narrowing step inside that stack

不该揉成一页。

## 第八层：为什么 114 也不能并回 113

113 的主语是：

- `result` passthrough 与 terminal primacy 不是同一种保留原样

114 的主语已经换成：

- callback-visible `SDKMessage` 经 adapter 后为什么不会保持同一分类身份

前者讲：

- result-specific preservation split

后者讲：

- callback-to-UI classification split

也必须分开。

## 第九层：最常见的假等式

### 误判一：进入 `onMessage` 的对象，adapter 只是在给它换个显示名字

错在漏掉：

- triad 是 consumer classification，不是 callback 成员重命名

### 误判二：adapter 返回 `ignored`，就说明这条对象其实不属于 callback surface

错在漏掉：

- success `result` 明明 callback-visible，却仍会被判成 `ignored`

### 误判三：`stream_event` 既然是 triad 的一类，当前 hook 自然也会消费它

错在漏掉：

- `useDirectConnect` 当前只消费 `message`

### 误判四：`user` / `system` 的条件映射说明 callback surface 本来就不稳定

错在漏掉：

- 不稳定的是当前 UI consumer policy，不是 callback union 本身

### 误判五：triad 已经等于最终 UI 全部可见性

错在漏掉：

- triad 之后还有 hook-specific sink decision

## 第十层：苏格拉底式自审

### 问：我是不是把 callback-visible 直接写成了 UI-visible？

答：如果是，就把 `useDirectConnect` 与 `sdkMessageAdapter` 重新拆开。

### 问：我是不是把 `ignored` 写成了“不属于 callback”？

答：如果是，就回到 success `result` 这个反例。

### 问：我是不是把 triad 写成了最终 sink，而漏掉 hook 只消费 `message`？

答：如果是，就还没把 114 的主轴立起来。
