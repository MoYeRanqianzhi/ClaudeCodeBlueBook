# `post_turn_summary`、`StdoutMessage`、`SDKMessage`、stream-json raw wire 与 `streamlined_*`：为什么 105、106、108、109、110 不是并列尾页，而是从 wider-wire visibility 分叉出去的四种后继问题

## 用户目标

105、106、108、109、110 连着拆完之后，读者最容易出现一种新的误判：

- “这些页都在讲 wire / callback / streamlined，可见性差不多，应该是五篇平行小文，按兴趣挑一篇读就行。”

这句话看似高效，

其实会让后面的很多句子重新塌掉。

因为 105 不是这组页中的一篇并列尾页，

而是整组 wider-wire visibility 的根页：

- 它先回答 `post_turn_summary` 为什么不属于 core SDK-visible，却不等于完全不可见

随后这条线才会继续分叉出去：

1. `stream-json --verbose` 这条 headless raw wire 合同
2. direct connect 这条 callback consumer-path narrowing
3. streamlined 这条 pre-wire projection path
4. 最后再解释为什么 `streamlined_*` 与 `post_turn_summary` 虽然同在 skip list，却不是同一种 suppress reason

如果这个顺序不先写死，读者就会：

- 把 106 写成 105 的 `stream-json` 附录
- 把 108 写成 105 的 direct-connect 重述
- 把 109 写成“终端显示优化页”
- 把 110 写成 108 和 109 的重复证明

这句还不稳。

所以这里需要的不是再补更多 leaf-level 证明，

而是补一页结构收束：

- 为什么 105、106、108、109、110 不是并列尾页，而是从 wider-wire visibility 分叉出去的四种后继问题

## 第一性原理

更稳的提问不是：

- “这几页都在讲可见性，我该先看哪篇？”

而是先问六个更底层的问题：

1. 我现在卡住的是 core SDK-visible 与 wider wire-admissible 的根分裂，还是某个更窄的后继问题？
2. 我现在问的是 raw wire contract、callback delivery，还是 projection artifact？
3. 我现在关心的是对象能不能存在于某层，还是某个 consumer 会不会真的收到它？
4. 这条对象是 raw background family，还是 transformer 生成的 projection family？
5. 这里讨论的是稳定用户合同，还是特定宿主、特定 gate、特定 skip list 下的实现证据？
6. 我是不是已经把 wider-wire visibility、callback narrowing、pre-wire rewrite 与 suppress reason 混成了同一种“消息被过滤”？

只要这六轴不先拆开，

后面就会把：

- 105 的 wider-wire visibility
- 106 的 raw wire contract
- 108 的 callback narrowing
- 109 的 pre-wire rewrite
- 110 的 suppress-reason split

重新压成一句模糊的：

- “这些页都在讲哪些消息会不会被看见”

## 第二层：这组页不是五篇平行尾页，而是“主干分叉 + 交叉叶子”

更稳的读法是：

```text
105 wider-wire visibility root
  ├─ 106 stream-json --verbose = raw wire contract
  ├─ 108 direct connect callback narrowing
  └─ 109 streamlined pre-wire projection
       └─ 110 same skip list != same suppress reason
```

这里真正该记住的一句是：

- 105 是根页
- 106 / 108 / 109 是三条不同后继分叉
- 110 是 108 与 109 在 direct-connect skip list 处相交后长出的交叉叶子

## 第三层：105 不是尾页之一，而是整组分叉图的根页

105 先回答的是：

- `post_turn_summary`

为什么同时满足两件事：

- 不在 core `SDKMessageSchema`
- 却仍然属于更宽的 `StdoutMessageSchema`

如果这一层没先读，

你后面会把 106、108、109、110 全都误当成：

- “不同地方在重复证明 `post_turn_summary` 可见或不可见”

但事实不是。

105 的作用是给这一组页固定根页：

- 先定 core SDK-visible 与 wider wire-admissible 的根分裂

然后别的后继问题才能继续分叉。

## 第四层：106 不是 105 的 `stream-json` 附录，而是 headless raw wire 分叉

106 回答的问题不是：

- `post_turn_summary` 单个对象怎样可见

而是：

- `stream-json --verbose` 这条路径到底在输出哪一层对象

它的主语是：

- default text/json 的 terminal contract
- `stream-json --verbose` 的 raw wire contract
- core `SDKMessage` 默认 public surface

不是：

- `post_turn_summary` 自己的可见性层级

这一步如果不先拆开，

你就会把：

- `structuredIO.write(message)`
- `lastMessage`
- `--verbose`

误写成 105 那种单对象 visibility ladder。

但 106 更准确的位置是：

- 105 之后“更宽 wire 到底长什么样”的 headless raw-wire 分叉

## 第五层：108 不是 105 的 direct-connect 重述，而是 callback narrowing 分叉

108 回答的问题不是：

- `post_turn_summary` 在哪一层可见

而是：

- direct connect 的 parse gate 为什么比 callback contract 更宽

它的主语是：

- `StdoutMessage` raw ingress admissibility
- `SDKMessage` callback contract
- manager-side forwarding suppression

不是：

- 单个 schema 是否存在

这一步如果不先拆开，

你就会把：

- `isStdoutMessage(...)`
- `onMessage(...)`
- skip list

误写成 105 的可见性重述。

但 108 更准确的位置是：

- 105 之后“某个特定 consumer 为什么继续收窄”的 direct-connect callback 分叉

## 第六层：109 不是 106 的显示优化附录，而是 projection 分叉

109 回答的问题不是：

- raw wire 里到底会出现哪些 family

而是：

- streamlined path 为什么发生在 `structuredIO.write(...)` 之前

它的主语是：

- rewrite gate
- `StdoutMessage -> StdoutMessage | null`
- write-time replacement/projection

不是：

- terminal post-processing

这一步如果不先拆开，

你就会把：

- `createStreamlinedTransformer()`
- `streamlined_text`
- `streamlined_tool_use_summary`

误写成：

- “raw wire 写完以后又补的一层显示优化”

但 109 更准确的位置是：

- 105 之后“另一类不是 raw summary family，而是 projection artifact 的对象”那条分叉

## 第七层：110 不是 108 或 109 的重复证明，而是交叉叶子

110 接着回答的是：

- `streamlined_*`
- `system.post_turn_summary`

虽然同样在 direct-connect skip list 里被过滤，

但为什么并不来自同一种 suppress reason。

它的主语不是：

- parse gate 是否更宽

也不是：

- transformer 如何 rewrite

而是：

- same skip list result
- different upstream provenance

也就是说：

- `streamlined_*` 更像 conditional projection family
- `post_turn_summary` 更像 raw background summary family

所以 110 更准确的位置是：

- 108 与 109 在 callback 过滤层相交后长出的交叉叶子

不是：

- 108 或 109 的任意一篇附录

## 第八层：为什么这组页要保护稳定合同，也要隔离灰度实现

这组页最容易被写坏的地方，

不是事实不够多，

而是对象层级和宿主实现缠在一起。

更稳的写法应先分三层：

| 类型 | 应该保住什么 |
| --- | --- |
| 稳定用户合同 | `post_turn_summary` 不属于 core SDK-visible，却属于更宽 wire-admissible；`stream-json --verbose` 是 raw wire contract，不是终态收口；direct connect 的 callback contract 比 parse gate 更窄；streamlined 是 pre-wire projection，不是 terminal 后处理；same skip list 不等于 same suppress reason |
| 条件性可见合同 | upstream 只有真 emit 某个 family、并且 consumer 真在读更宽 raw wire 时，这条对象才会被看见；`streamlined_*` 还受 feature/env/output-format gate 约束 |
| 灰度/实现证据 | `@internal`、具体 skip list、具体 emitter 频率、build feature、env var、helper 顺序与宿主 wiring |

这里最该保护的一句是：

- 用对象层级作稳定合同，用 helper 名和 gate 作实现证据，不要把后者误写成前者。

## 第九层：苏格拉底式自审

每次继续深挖 105、106、108、109、110，先追问自己：

1. 我现在卡住的是 105 的根分裂，还是某个更窄的后继分叉？
2. 我现在讨论的是 raw wire、callback contract，还是 projection artifact？
3. 这条判断在 helper 名改掉以后还成立吗？
4. 我是不是把“能进更宽 wire”误写成了“普通 SDK-visible”？
5. 我是不是把“same skip list”误写成了“same object class”？
6. 我是不是把 `streamlined_*` 写成了 raw summary tail，或者把 `post_turn_summary` 写成了 projection artifact？

如果其中任何一个问题回答不稳，

就不该直接继续往 leaf-level 证明页下钻，

而应该先回到 105、106、108、109 这些分叉根页补主语。

## 第十层：阅读建议

如果你现在的问题是：

- “为什么 105、106、108、109、110 看起来都像可见性页，却不能按顺序硬读？”

建议按这个顺序：

1. 105：先定 wider-wire visibility 根分裂
2. 209：先看整组分叉图
3. 106：如果你关心 headless raw wire
4. 108：如果你关心 direct-connect callback narrowing
5. 109：如果你关心 streamlined projection
6. 110：最后再看 suppress reason split

如果你只关心 direct connect 为什么 callback 看不到 `post_turn_summary`，

可读：

- 105 -> 108

如果你只关心 `stream-json --verbose` 与 streamlined 的关系，

可读：

- 106 -> 109 -> 110
