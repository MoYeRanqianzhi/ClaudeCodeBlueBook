# `task_summary`、`post_turn_summary`、terminal tail、observer restore 与 suggestion settlement：为什么 100-104 不是并列细页，而是先从 summary 分家，再分叉到终态收口与恢复合同

## 用户目标

100-104 连着拆完之后，读者最容易出现一种新的误判：

- “这些页都在讲 result 之后的尾部 housekeeping，应该是五篇平行小文，按兴趣挑一篇读就行。”

这句话看似高效，

其实会让后面的很多句子重新塌掉。

因为 100 不是这组页中的一篇并列尾页，

而是这一组页的根页：

- 它先回答 `task_summary` / `post_turn_summary` 为什么根本不是同一条 summary contract

随后这条线才会继续分叉：

1. 先把 `result` 从 raw stream tail 里分出来
2. 再继续问 suggestion 为什么已交付却仍可能不结算
3. 最后再问 deferred cleanup 为什么更像留下 inert stale slot
4. 与此同时，再从 100 单独分出 observer metadata stale scrub vs restore 这条侧枝

如果这个顺序不先写死，读者就会：

- 把 101 写成 100 的输出附录
- 把 102 写成 101 的 suggestion 附录
- 把 104 写成“已经确认外部协议有 bug”的页
- 把 103 写成 100 的恢复附录

这句还不稳。

所以这里需要的不是再补一篇新的运行时正文，

而是补一页结构收束：

- 为什么 100-104 不是并列细页，而是先从 summary 分家，再分叉到终态收口与恢复合同

## 第一性原理

更稳的提问不是：

- “这五页都在讲尾部，我该先看哪篇？”

而是先问六个更底层的问题：

1. 我现在卡住的是 100 的 summary 分家，还是某个更窄的后继问题？
2. 我现在问的是 terminal cursor、telemetry settlement，还是 observer metadata restore？
3. 我现在关心的是谁才是最终输出主位，还是那些不配篡位的尾流如何各自存在？
4. 这一步是主干上的连续收口，还是从 100 分出去的一条恢复侧枝？
5. 这里讨论的是稳定用户合同，还是当前控制流下的实现证据？
6. 我是不是已经把 summary 分家、terminal tail、settlement gap 与 observer restore 混成同一种尾部 housekeeping？

只要这六轴不先拆开，

后面就会把：

- 100 的 summary contract split
- 101 的 terminal cursor vs raw tail
- 102 的 delivered vs settled
- 103 的 stale scrub vs restore
- 104 的 cleanup inertness

重新压成一句模糊的：

- “result 后面还有一些尾部细节”

## 第二层：这组页不是五篇平行尾页，而是“主干 + 侧枝”

更稳的读法是：

```text
98 semantic last result
  ↓
100 summary contract split
  ├─ 101 result terminal cursor vs raw stream tail
  │    └─ 102 delivered suggestion != settled telemetry
  │         └─ 104 cleanup asymmetry leaves inert stale slot
  └─ 103 observer metadata stale scrub vs restore
```

这里真正该记住的一句是：

- 100 是根页
- `101→102→104` 是主干
- 103 是 observer-restore 侧枝

## 第三层：100 不是尾页之一，而是整组分叉图的根页

100 先回答的是：

- `task_summary`
- `post_turn_summary`

虽然都叫 summary，

却根本不属于同一条 transport-lifecycle contract。

如果这一层没先读，

你后面会把 101、102、103、104 全都误当成：

- “同一份 summary 在不同消费面上的厚薄差异”

但事实不是。

100 的作用是给这一组页固定根页：

- 先定 summary / post-result tail 的对象分家

然后别的后继问题才能继续分叉。

## 第四层：101 不是 100 的输出附录，而是终态收口主干的起点

101 回答的问题不是：

- summary 最后怎样显示

而是：

- `result` 既然是 terminal final payload，为什么 raw stream 在它后面还能继续长尾

它的主语是：

- `result` 的终态语义
- raw stream tail 的物理尾流

不是：

- summary carrier 自己的差异

这一步如果不先拆开，

你就会把：

- `lastMessage`
- `prompt_suggestion`
- `session_state_changed(idle)`
- `gracefulShutdownSync(...)`

误写成 100 那种 summary contract 的后处理。

但 101 更准确的位置是：

- `100` 之后那条终态收口主干的起点

## 第五层：102 不是 101 的 suggestion 附录，而是主干里的 settlement 节点

102 回答的问题不是：

- `result` 之后还能不能继续出现别的 frame

而是：

- suggestion 明明已经真实交付了，为什么 accepted / ignored telemetry 仍然可能永远不结算

它的主语是：

- delivered ledger vs settlement ledger

不是：

- raw stream tail 厚度

这一步如果不先拆开，

你就会把：

- `lastEmitted`
- `logSuggestionOutcome(...)`
- `interrupt`
- `end_session`
- `output.done()`

写成 101 里的流尾帧问题。

但 102 更准确的位置是：

- 101 之后那条终态收口主干里的第二个节点

## 第六层：104 不是 102 的“确认有 bug”版，而是主干末端的 inertness 叶子

104 继续往 suggestion 这一条线上收窄，回答的是：

- 某些 cleanup 分支会清 `pendingSuggestion`
- 却不清 `pendingLastEmittedEntry`

为什么这更像：

- internal stale staging

而不是：

- visible protocol bug

它的主语从一开始就不是：

- delivered suggestion 是否结算

而是：

- deferred staging cleanup asymmetry 有没有机会升级成外部后果

这一步如果不先读，

你最容易把：

- incomplete staging record

误写成：

- 另一条待发 suggestion

## 第七层：103 不是 100 的恢复附录，而是 observer metadata 侧枝

103 回答的问题不是：

- summary 最后怎样跨 transport 可见

而是：

- `pending_action`
- `task_summary`

虽然也出现在 `SessionExternalMetadata` 里，

为什么仍然不享有和 `permission_mode`、`model` 一样的 restore contract。

它的主语是：

- observer metadata stale scrub vs local restore

不是：

- summary message visibility

这一步如果不先拆开，

你就会把：

- `GET /worker`
- `externalMetadataToAppState(...)`
- worker init scrub

误写成 100 那种 summary contract 差异。

## 第八层：为什么这组页要保护稳定合同，也要隔离灰度实现

这组页最容易被写坏的地方，

不是事实不够多，

而是稳定对象分裂和实现路径名缠在一起。

更稳的写法应先分三层：

| 类型 | 应该保住什么 |
| --- | --- |
| 稳定用户合同 | `task_summary` 是 freshness-first 的 mid-turn progress metadata；`post_turn_summary` 是 after-turn recap；`result` 主位不等于流终点；已交付 suggestion 不等于已结算；observer metadata 不等于 restore input |
| 条件性可见合同 | 不同宿主看到的尾流厚度不同；cleanup 分支只在特定 control-path 下出现；一部分关于 inert stale slot 的结论依赖当前控制流推断 |
| 灰度/实现证据 | `lastMessage`、`lastEmitted`、`pendingLastEmittedEntry`、`externalMetadataToAppState(...)`、worker init scrub、具体 cleanup 顺序与 helper 名 |

这里最该保护的一句是：

- 用 helper 名作证据，但不要把 helper 名误写成稳定能力名。

## 第九层：苏格拉底式自审

每次继续深挖 100-104，先追问自己：

1. 我现在卡住的是 100 的根分裂，还是 `101→102→104` 的主干，还是 103 的 observer-restore 侧枝？
2. 我现在讨论的是 summary 分家、terminal cursor、telemetry settlement，还是 observer restore？
3. 这条判断在 helper 名改掉以后还成立吗？
4. 我是不是把“已交付”误写成了“已结算”，或把“内部残影”误写成了“外部协议 bug”？
5. 我是不是把 observer metadata 的 stale scrub first，误写成了 local restore first？
6. 我是不是在还没分清 100 的根分家之前，就提前把 101/102/103/104 写成互相替代的尾页？

如果其中任何一个问题回答不稳，

就不该直接继续往 leaf-level 证明页下钻，

而应该先回到 100、101、102、103 这些根节点补主语。

## 第十层：阅读建议

如果你现在的问题是：

- “为什么 100-104 看起来都像 result 之后的尾页，却不能按顺序硬读？”

建议按这个顺序：

1. 100：先定 summary contract split
2. 208：先看整组分叉图
3. 101：再分 terminal cursor 与 raw tail
4. 102：再看 delivered suggestion 与 settlement gap
5. 104：最后再看 cleanup inertness
6. 103：如果你关心 observer metadata restore，就单独走这条侧枝

如果你只关心 suggestion 为什么显示了还可能没有 telemetry，

可读：

- 99 -> 100 -> 101 -> 102 -> 104

如果你只关心 CCR 恢复时 metadata 为什么不能一起回填，

可读：

- 51/52 -> 100 -> 103
