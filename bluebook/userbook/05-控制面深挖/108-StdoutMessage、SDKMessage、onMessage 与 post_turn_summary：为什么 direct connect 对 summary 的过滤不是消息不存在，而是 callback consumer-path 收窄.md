# `StdoutMessage`、`SDKMessage`、`onMessage` 与 `post_turn_summary`：为什么 direct connect 对 summary 的过滤不是消息不存在，而是 callback consumer-path 收窄

## 用户目标

61 已经讲清：

- direct connect 的远端消息流不会原样落进本地 transcript
- transport filter、adapter projection 与 REPL sink 不是同一层

105 又已经讲清：

- `post_turn_summary` 不属于 core `SDKMessage` union
- 但它仍然属于更宽的 `StdoutMessage` / stdout-control wire surface

但继续往下读时，读者仍然很容易留下一个还没拆干净的误解：

- `directConnectManager` 既然把 `post_turn_summary` 过滤掉，那是不是说明 direct connect 这条线上根本不会收到它？
- 既然 `onMessage` 永远收不到它，那是不是说明 wire 上也不可能有它？
- `isStdoutMessage(...)`、`onMessage: (message: SDKMessage) => void`、manager 里的 skip list，到底哪一层才在回答“它存不存在”？

如果这些不拆开，正文最容易滑成一句错误总结：

- “direct connect 过滤了 `post_turn_summary`，所以这条消息并不存在于 direct connect。”

从当前源码看，这个结论并不成立。

## 第一性原理

更稳的提问不是：

- “direct connect 能不能看到 `post_turn_summary`？”

而是先问五个更底层的问题：

1. 当前讨论的是 raw ingress parse，还是 callback delivery？
2. 当前讨论的是更宽的 `StdoutMessage` admissibility，还是更窄的 `SDKMessage` callback contract？
3. 当前缺的是 schema membership，还是 manager-side consumer filtering？
4. 当前说的是“可能进入这层”，还是“保证会被交付到下游 consumer”？
5. 当前源码证明的是 wire existence，还是 callback visibility？

只要这五轴不先拆开，后续就会把：

- not callback-visible

误写成：

- not present on wire

## 第一层：direct connect 的 ingress gate 从一开始就比 callback contract 更宽

`directConnectManager.ts` 一开头就把两类对象并列摆出来：

- `SDKMessage` 来自 `agentSdkTypes.js`
- `StdoutMessage` 来自 `sdk/controlTypes.js`

而同一个文件里的两个入口又在回答不同问题：

- `isStdoutMessage(...)` 回答的是：这条 raw line 能不能被当成更宽的 stdout/control message 解析
- `onMessage: (message: SDKMessage) => void` 回答的是：哪些对象有资格被交给 direct-connect callback consumer

这意味着 direct connect 从第一步就不是：

- “只要能 parse，就天然属于 callback contract”

而是：

- raw ingress contract 比 callback contract 更宽

所以这里首先要钉死的一句是：

- direct connect 的 raw message admissibility 并不等于 callback-visible message set

## 第二层：`StdoutMessageSchema` 接纳的对象，本来就比 `SDKMessageSchema` 更宽

`controlSchemas.ts` 的 `StdoutMessageSchema` 明确 union 了：

- `SDKMessageSchema()`
- streamlined variants
- `SDKPostTurnSummaryMessageSchema()`
- control families

而 `coreSchemas.ts` 里：

- `SDKPostTurnSummaryMessageSchema` 单独存在
- `SDKMessageSchema` 却没有把它并进去

这说明 direct connect 在 parse ingress 时用的更接近：

- wider stdout/control wire admissibility

而不是：

- public/core `SDKMessage` membership

因此如果一条 raw line 属于：

- `system.post_turn_summary`

那它首先并不会因为“不是 `SDKMessage`”就自动 parse 失败。

更准确的说法是：

- 它在更宽 `StdoutMessage` 层是可承载的
- 但这还没回答它会不会继续进入 `onMessage`

## 第三层：`post_turn_summary` 在 manager 里是被显式剥离，而不是被动掉出解析面

`directConnectManager.ts` 在 `parsed` 通过 `isStdoutMessage(...)` 之后，会继续做两次分流：

1. 先单独处理 `control_request`
2. 再在普通转发前跑一条显式 skip list

这条 skip list 过滤掉：

- `control_response`
- `keep_alive`
- `control_cancel_request`
- `streamlined_text`
- `streamlined_tool_use_summary`
- `system.post_turn_summary`

这里最值钱的不是“它被过滤了”，而是过滤发生的位置：

- 过滤发生在 parse 之后、callback 暴露之前

这说明 `post_turn_summary` 的缺席更接近：

- manager-side forwarding suppression

而不是：

- schema-level impossibility

所以 direct connect 这段代码真正证明的是：

- 即便 raw ingress 已经承认这类对象，manager 仍可以决定不把它交给 `onMessage`

## 第四层：`onMessage` 收不到，不等于 direct connect wire 上没有

把前面三层合在一起，才能得到这页真正要钉死的结论：

- `post_turn_summary` 不属于 direct connect callback-visible surface
- 但这不等于它在 direct connect 的更宽 raw ingress / stdout wire 层根本不存在

这里的关键差别不是：

- visible vs invisible

而是：

- wire-admissible vs callback-deliverable

`directConnectManager` 做的是后者的收窄，而不是前者的存在性否定。

因此更克制也更准确的表述应是：

- 当前源码证明 direct connect 对 `post_turn_summary` 做了 consumer-specific callback filtering
- 不是证明 direct connect 的 raw wire 永远不可能出现 `post_turn_summary`

## 第五层：当前源码能稳定证明什么，不能稳定证明什么

从当前源码可以稳定证明的是：

- direct connect 的 raw parse gate 看的是更宽 `StdoutMessage`
- direct connect 的 callback contract 看的是更窄 `SDKMessage`
- `post_turn_summary` 在 `StdoutMessage` 层可承载，却不在 core `SDKMessage` union 内
- manager 会在 `onMessage` 暴露前显式 strip 掉 `system.post_turn_summary`

从当前源码不能在这页稳定证明的是：

- 每一次 direct connect 运行时都一定会收到 `post_turn_summary`
- 这条消息在所有宿主路径上都以同一种频率 emit
- 除 callback 以外，当前 direct connect 宿主一定还保留别的 pre-filter consumer

所以更稳的结论必须停在：

- wider-wire admissibility + manager-side consumer narrowing

而不能滑到：

- guaranteed arrival cadence

## 第六层：为什么 108 不能并回 61

61 的主语是：

- direct connect 的远端消息流为什么不会原样落进 transcript

那一页的重点是：

- transport filter
- adapter projection
- transcript sink

108 继续往下压到一个更窄的问题：

- 对 `post_turn_summary` 这一个 family 来说，manager 过滤究竟是在否定存在，还是在收窄 consumer path

前者讲：

- broad direct-connect transcript surface split

后者讲：

- one family inside direct connect ingress vs callback contract

不该揉成一页。

## 第七层：为什么 108 也不能并回 105

105 的主语是：

- `post_turn_summary` 不是 core SDK-visible，却不等于完全不可见

那一页的重点仍比较宽：

- core SDK surface
- wider stdout/control wire
- terminal semantics
- direct-connect callback

108 则继续把 direct connect 这一格单独拉出来，专门回答：

- 为什么 manager 的过滤证明的是 callback consumer-path narrowing，而不是 message existence denial

105 更像：

- visibility ladder

108 更像：

- one rung inside that ladder, viewed through direct-connect ingress semantics

所以也必须单列。

## 第八层：最常见的假等式

### 误判一：能过 `isStdoutMessage(...)`，就一定能进 `onMessage`

错在漏掉：

- parse admissibility 与 callback contract 本来就是两层

### 误判二：`onMessage` 收不到 `post_turn_summary`，就说明 wire 上没有它

错在漏掉：

- manager 明明是在 parse 之后、forward 之前主动 strip 它

### 误判三：direct connect 过滤了 `post_turn_summary`，就等于 schema 不允许它出现

错在漏掉：

- `StdoutMessageSchema` 恰恰单独接纳了 `SDKPostTurnSummaryMessageSchema`

### 误判四：这一页和 61、105 只是换个标题重复

错在漏掉：

- 61 讲 direct-connect transcript surface
- 105 讲 `post_turn_summary` 的 visibility ladder
- 108 讲 direct-connect callback narrowing 的证据身份

## 苏格拉底式自审

### 问：我是不是又把 callback 看不见写成了 wire 上不存在？

答：如果是，就把 manager-side filter 与 parse gate 重新拆开。

### 问：我是不是把 `StdoutMessage` 与 `SDKMessage` 当成了同一层 union？

答：如果是，就会误把 schema widening 写成 callback promise。

### 问：我是不是又在暗示“它通常会 emit”？

答：如果是，就已经超出这页的源码证据范围了。

### 问：我是不是把 `directConnectManager` 的过滤写成“协议本体的自然属性”？

答：如果是，就漏掉了 consumer-specific narrowing 这个最关键的新判断。
