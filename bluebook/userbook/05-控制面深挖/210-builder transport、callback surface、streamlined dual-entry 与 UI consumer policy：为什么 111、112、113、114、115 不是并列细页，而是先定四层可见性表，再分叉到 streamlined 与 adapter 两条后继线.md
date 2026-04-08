# `builder transport`、callback surface、streamlined dual-entry 与 UI consumer policy：为什么 111、112、113、114、115 不是并列细页，而是先定四层可见性表，再分叉到 streamlined 与 adapter 两条后继线

## 用户目标

111、112、113、114、115 连着拆完之后，读者最容易出现一种新的误判：

- “这些页都在讲 callback、adapter 和 streamlined，应该是五篇平行小文，按兴趣挑一篇读就行。”

这句话看似高效，

其实会让后面的很多句子重新塌掉。

因为 111 不是这组页中的一篇并列细页，

而是整组 consumer-surface 的根页：

- 它先回答 builder/control transport、public/core SDK、direct-connect callback 与 UI consumer 至少是四张逐级收窄的表

随后这条线才会继续分叉：

1. 一条是 streamlined path 自己内部的双入口、replacement、passthrough 与 suppression
2. 另一条是 callback-visible object 进入 adapter triad 之后，如何继续分裂成不同 UI consumer policy

如果这个顺序不先写死，读者就会：

- 把 112 写成 111 的 streamlined 附录
- 把 113 写成 101 的 result 重述
- 把 114 写成 111 的 UI 版翻译
- 把 115 写成 114 的细节补丁

这句还不稳。

所以这里需要的不是再补更多 leaf-level 证明，

而是补一页结构收束：

- 为什么 111、112、113、114、115 不是并列细页，而是先定四层可见性表，再分叉到 streamlined 与 adapter 两条后继线

## 稳定主干与灰度证据

这页故意同时保护两件事：

- 在当前 headless `print` / direct connect / UI consumer 这一组源码切片里，按四层可见性表来读最稳。
- 真正更该长期保住的，不是“永远恰好四层”或某条 exact helper 链，而是：消息进入更宽一层，不保证会进入更窄一层；进入更窄一层后，也不保证会被同一种 action 或 policy 处理。

所以这页虽然继续用“111 先定四层表”的读法来组织，

但不会把：

- `DirectConnectSessionManager -> useDirectConnect -> sdkMessageAdapter`
- `shouldIncludeInStreamlined(...)`
- `convertSDKMessage(...)`
- `convertToolResults`
- `convertUserTextMessages`

直接提升成稳定公共合同。

它们更准确的位置是：

- 用来证明当前宿主怎样继续分裂出 streamlined action taxonomy 与 UI consumer policy
- 以及哪些判断仍应留在灰度/实现证据层

## 第一性原理

更稳的提问不是：

- “这几页都在讲消息消费，我该先看哪篇？”

而是先问六个更底层的问题：

1. 我现在卡住的是 111 那张四层可见性表，还是某个更窄的分叉问题？
2. 我现在问的是 streamlined path 自己内部的动作分类，还是 callback-visible object 如何继续收窄成 UI policy？
3. 我现在关心的是对象属于哪一层可见性表，还是某个 consumer 最终如何处理它？
4. 这条对象是在被 rewrite、passthrough、suppression，还是在被 adapter triad 再分类？
5. 这里讨论的是稳定用户合同，还是特定 host、特定 option、特定 hook 下的实现证据？
6. 我是不是已经把可见性表、streamlined action taxonomy 与 UI consumer policy 混成了同一种“消息过滤”？

只要这六轴不先拆开，

后面就会把：

- 111 的四层可见性表
- 112 的 dual-entry gate / action taxonomy
- 113 的 result passthrough vs terminal primacy
- 114 的 callback-visible vs adapter triad vs hook sink
- 115 的 tool_result parity / history replay / success-noise suppression

重新压成一句模糊的：

- “这些页都在讲某些消息会不会显示”

## 第二层：这组页不是五篇平行细页，而是“根页 + 两条支线”

更稳的读法是：

```text
111 four visibility tables
  ├─ 112 streamlined dual-entry / replacement / suppression
  │    └─ 113 result passthrough != terminal primacy
  └─ 114 callback-visible != adapter triad != hook sink
       └─ 115 tool_result parity / history replay / success-noise suppression
```

这里真正该记住的一句是：

- 111 是根页
- 112→113 是 streamlined 支线
- 114→115 是 adapter / UI consumer 支线

## 第三层：111 不是细页之一，而是整组分叉图的根页

111 先回答的是：

- `controlSchemas`
- `agentSdkTypes`
- `directConnectManager`
- `useDirectConnect + sdkMessageAdapter`

为什么并不是同一张消息可见性表。

如果这一层没先读，

你后面会把 112、113、114、115 全都误当成：

- “在同一张表里看不同 family 的边角差异”

但事实不是。

111 的作用是给这一组页固定根页：

- 先定在当前这组源码切片里，builder/control transport、public SDK、callback surface 与 UI consumer 可以按四层逐级收窄的表来读

然后别的后继问题才能继续分叉。

## 第四层：112 不是 111 的 streamlined 附录，而是 action taxonomy 分叉

112 回答的问题不是：

- 某个 family 最终在哪一层可见

而是：

- 进入 streamlined path 后，assistant 和 result 为什么不会走同一种“消息简化”

它的主语是：

- coarse inclusion gate
- replacement / passthrough / suppression

不是：

- visibility table 自己的层级差异

这一步如果不先拆开，

你就会把：

- `shouldIncludeInStreamlined(...)`
- `streamlined_text`
- `streamlined_tool_use_summary`
- `null`

误写成 111 那种可见性表的不同列。

但 112 更准确的位置是：

- 111 之后“streamlined path 内部如何分动作”的支线起点

## 第五层：113 不是 112 的 result 附录，而是 streamlined 支线里的 preservation-reason 叶子

113 回答的问题不是：

- 哪些对象会进入 streamlined path

而是：

- `result` 在 transformer 里原样 passthrough

为什么不等于：

- terminal semantic 主位保留

它的主语是：

- payload preservation
- terminal primacy

不是：

- streamlined family 的纳入 gate

这一步如果不先拆开，

你就会把：

- `return message`
- `lastMessage stays at the result`

误写成同一种“保留原样”。

但 113 更准确的位置是：

- 112 支线里专门解释 `result` passthrough 理由的叶子页

## 第六层：114 不是 111 的 UI 版翻译，而是 adapter triad 分叉

114 回答的问题不是：

- 从 transport 到 UI 一共有几张表

而是：

- callback-visible `SDKMessage`

为什么不会被 `convertSDKMessage(...)` 原样镜像到 UI consumer

它的主语是：

- callback-visible surface
- adapter triad
- hook sink

不是：

- builder/control transport 或 public SDK 的表本身

这一步如果不先拆开，

你就会把：

- `message`
- `stream_event`
- `ignored`

误写成 callback union 的换名版本。

但 114 更准确的位置是：

- 111 之后“callback 进入 UI 前怎样再分类”的支线起点

## 第七层：115 不是 114 的细节补丁，而是 adapter policy 叶子

115 回答的问题不是：

- triad 为什么不是 callback 镜像

而是：

- 在 adapter 内部，
  - `convertToolResults`
  - `convertUserTextMessages`
  - success `result -> ignored`

为什么也根本不是同一种 UI consumer policy

它的主语是：

- render parity
- replay completeness
- success-noise suppression

不是：

- triad 自己的存在性

这一步如果不先拆开，

你就会把：

- tool_result 本地补画
- 历史 user replay
- success 收口静默

统统误写成：

- “adapter 打开或关闭某些消息”

但 115 更准确的位置是：

- 114 支线里专门解释 adapter 内三种 policy 方向不同的叶子页

## 第八层：为什么这组页要保护稳定合同，也要隔离灰度实现

这组页最容易被写坏的地方，

不是事实不够多，

而是层级和 policy 被 helper 名缠住。

更稳的写法应先分三层：

| 类型 | 应该保住什么 |
| --- | --- |
| 稳定用户合同 | 在当前切片里至少要分 builder/control transport、public SDK surface、callback-visible surface 与前台 UI consumer 的逐级收窄；更宽层可承载，不等于更窄层必消费；同为 streamlined 纳入对象也不等于同一种动作；`result` passthrough 不等于 terminal primacy；callback-visible 不等于 UI-visible；tool_result parity、history replay 与 success-noise suppression 不是同一种 policy |
| 条件性可见合同 | `streamlined_*` 还受 gate 约束；某些 adapter policy 只在 live direct connect、history replay 或 viewerOnly 等特定宿主下成立 |
| 灰度/实现证据 | exact helper 名、exact chain、`DirectConnectSessionManager -> useDirectConnect -> sdkMessageAdapter`、`convertToolResults`、`convertUserTextMessages`、`sentUUIDsRef`、`shouldIncludeInStreamlined(...)`、`setIsLoading(false)`、helper 顺序与 host wiring |

这里最该保护的一句是：

- 先写清层级与 policy，再用 helper 名举证，不要反过来让 helper 名替代结构主语。

## 第九层：苏格拉底式自审

每次继续深挖 111、112、113、114、115，先追问自己：

1. 我现在卡住的是 111 那张四层表，还是 `112→113` 支线，还是 `114→115` 支线？
2. 我现在讨论的是对象属于哪一层，还是某个 consumer 如何对它做动作/分类？
3. 这条判断在 helper 名改掉以后还成立吗？
4. 我是不是把 callback-visible 误写成了 UI-visible？
5. 我是不是把 same inclusion 写成了 same simplification，或者把 same adapter file 写成了 same policy？
6. 我是不是把 111 的总表结论直接重讲，而没有继续压到 112 或 114 的支线主语？

如果其中任何一个问题回答不稳，

就不该继续往 leaf-level 证明页下钻，

而应该先回到 111、112、114 这些支线根页补主语。

## 第十层：阅读建议

如果你现在的问题是：

- “为什么 111、112、113、114、115 看起来都在讲 callback / adapter / streamlined，却不能按顺序硬读？”

建议按这个顺序：

1. 111：先定四层可见性表
2. 210：先看整组分叉图
3. 112：如果你关心 streamlined path 内部动作
4. 113：如果你关心 `result` passthrough 的特殊性
5. 114：如果你关心 callback-visible object 怎样进入 UI triad
6. 115：最后再看 adapter 内三种 policy 的方向差异

如果你只关心 streamlined 这条线，

可读：

- 111 -> 112 -> 113

如果你只关心 direct-connect callback 到 UI 的收窄，

可读：

- 111 -> 114 -> 115
