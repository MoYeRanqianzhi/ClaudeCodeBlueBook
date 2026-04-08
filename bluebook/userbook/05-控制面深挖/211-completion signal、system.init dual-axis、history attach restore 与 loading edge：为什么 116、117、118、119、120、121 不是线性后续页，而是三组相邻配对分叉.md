# `completion signal`、`system.init` dual-axis、history attach restore 与 `loading edge`：为什么 116、117、118、119、120、121 不是线性后续页，而是三组相邻配对分叉

## 用户目标

111-115 已经把：

- builder/control transport
- callback-visible surface
- streamlined path
- adapter / UI consumer policy

拆成了不同层。

继续往 116-121 读时，读者最容易再滑进一种新的误判：

- “这六页都在讲 direct connect / viewer 的后续状态，顺着编号一路往下读就行。”

这句话看似自然，

其实会把三种不同主语重新压平：

1. `result` 到来以后，completion signal 与 loading edge 怎样继续分裂
2. `system.init` 作为 public SDK object，为什么又沿着“谁看见它”和“它有多厚”两轴继续分裂
3. attach 以后，history replay 与 live restore 为什么又不是同一种恢复

所以这轮最该补的不是再加一页新的 leaf-level 证明，

而是先把 116-121 收成一张结构图：

- 为什么 116、117、118、119、120、121 不是线性后续页，而是三组相邻配对分叉

## 第一性原理

更稳的提问不是：

- “这几页都在讲远端后续状态，我该先看哪页？”

而是先问七个更底层的问题：

1. 我现在卡住的是 completion / waiting，还是 `system.init`，还是 attach/replay？
2. 我现在写的是 transcript-visible outcome、callback-visible object，还是 attach 后的 restore wiring？
3. 我现在关心的是跨层分家，还是同一层内部继续分 edge / thickness / restore 语义？
4. 当前结论在描述 public SDK object family，还是只在当前 host wiring 下成立？
5. 这是“谁看见它”的问题，还是“它有多厚”的问题，还是“attach 后恢复了什么”的问题？
6. 我是不是把同一个 bool、同一个 object、同一个 adapter，偷换成了同一种控制语义？
7. 我是不是又把 direct connect、viewerOnly、history attach 与 live `/subscribe` 压回成一条顺序链？

只要这七轴先拆开，

后面就不会再把：

- 116 的 completion signal split
- 119 的 loading edge split
- 117 的 init visibility surface
- 120 的 init payload thickness
- 118 的 replay dedup / sink split
- 121 的 attach restore split

重新压成一句模糊的：

- “远端后续状态”

## 第二层：这组页不是一条线，而是三组相邻配对分叉

更稳的读法是：

```text
210 callback / adapter / consumer split
  ├─ completion / waiting pair
  │    ├─ 116 completion signal split
  │    └─ 119 loading edge split
  ├─ system.init dual-axis pair
  │    ├─ 117 init visibility surface
  │    └─ 120 init payload thickness
  └─ attach / replay pair
       ├─ 118 replay dedup / source overlap / sink
       └─ 121 transcript replay != live bootstrap restore
```

这里真正该记住的一句是：

- 116/119 是一组 completion / waiting 配对页
- 117/120 是一组 `system.init` 双轴配对页
- 118/121 是一组 attach / replay 配对页

它们可以有前后阅读顺序，

但不该被写成：

- `116 -> 117 -> 118 -> 119 -> 120 -> 121`

这种单线后继链。

## 第三层：116 与 119 是 completion / waiting 配对，不是普通父子

116 先回答的是：

- success `result` ignored
- error `result` visible
- `isSessionEndMessage(...)`
- `setIsLoading(false)`

为什么不能写成同一种 completion signal。

它的主语是跨层分家：

- transcript-visible outcome
- turn-end classifier
- busy-state transition

119 继续问的却不是：

- 哪些层属于 completion signal

而是：

- 仅仅在 busy-state 这一层里，
  - request start
  - approval pause
  - approval resume
  - turn-end release
  - abort release
  - teardown release

为什么也不是同一种 `loading edge`

所以 119 更准确的位置不是：

- 116 的普通叶页

而是：

- completion / waiting 这一组配对里的 busy-state zoom page

更稳的写法应是：

- 先用 116 拆 completion 的跨层假等式
- 再用 119 把其中第三层 `busy-state` 自己继续拆开

## 第四层：117 与 120 是 `system.init` 双轴配对，不是父子链

117 回答的问题是：

- raw `system.init` object
- callback-visible init
- host-local dedupe
- transcript init prompt
- slash bootstrap

为什么不是同一种初始化可见性。

它的主语是：

- 谁看见它
- 谁消费它

120 回答的问题则是：

- full init payload
- bridge redacted init
- hidden/internal extra thickness
- transcript model-only banner

为什么不是同一种 init payload thickness。

它的主语是：

- object 有多厚
- 宿主如何裁剪

所以 120 也不该被写成：

- 117 的叶页

因为“谁看见它”和“它有多厚”本来就是两张正交表。

更稳的写法应是：

- 117 保护 `system.init` 的 consumer / visibility 分层
- 120 保护 `system.init` 的 object / thickness 分层

而不是把 120 写成：

- “117 里 transcript / bootstrap 再细讲一点”

## 第五层：118 与 121 是 attach / replay 配对，不是 replay 父子链

118 回答的问题是：

- `convertUserTextMessages`
- `sentUUIDsRef`
- `fetchLatestEvents(anchor_to_latest)`
- `pageToMessages(...)`
- prepend / append source-blind sink

为什么 viewer attach 里的 replay dedup 不是同一种机制。

它的主语已经不是：

- `system.init` 本体

而是：

- history latest page
- live stream
- 本地先插与远端 echo
- transcript sink

121 虽然继续借用了 init 词汇，

但它真正回答的是：

- history attach 里只回放 init banner
- live remote hook 才执行 `onInit(slash_commands)`

为什么 transcript replay 不等于 live bootstrap restore。

所以 121 也不该被写成：

- 118 的普通子页

更准确的位置是：

- attach / replay 这组配对里的 restore-semantics page

如果一定要给阅读顺序，

更稳的是：

- 先看 118 认识 attach wiring
- 再看 121 分 transcript restore 与 command-surface restore

但目录关系仍应写成：

- 相邻配对

不是：

- replay 父页 → restore 叶页

## 第六层：三组配对最该保护的稳定主干

| 配对 | 稳定主干 |
| --- | --- |
| 116 / 119 | `result` 是 public SDK union 成员；success `result` ignored 只回答 transcript policy；`isSessionEndMessage(...)` 与 busy-state 收口先于 transcript policy；同一 `setIsLoading(true/false)` 能承载多 edge 语义 |
| 117 / 120 | `system.init` 首先是 public SDK metadata object，不是提示文案；callback-visible、transcript-visible 与 bootstrap-visible 不是同一层；同一个 init object 也能因宿主输入不同而出现不同厚度 |
| 118 / 121 | history hook 当前只做 `events -> messages -> prepend`；live hook 才直接消费 raw init 做 `onInit(...)`；history replay 与 live restore 共用 adapter，不等于共用 dedup / restore 语义 |

这里最该保住的一句是：

- 同一个 object、同一个 bool、同一个 adapter，并不自动等于同一种控制语义

## 第七层：哪些点必须降级为条件或灰度实现证据

| 配对 | 条件 / 灰度证据 |
| --- | --- |
| 116 / 119 | success `result` 当前继续静默只是当前 UI consumer policy；`isSessionEndMessage(...)` 现在等于 `msg.type === 'result'` 只是 coarse classifier；loading edge 只能写当前最少可证集合 |
| 117 / 120 | `tengu_bridge_system_init` gate、bridge redaction、`messaging_socket_path`、`plugins[].source`、`hasReceivedInitRef` 的 once-per-turn 去重都不该升级成稳定公共合同 |
| 118 / 121 | history/live 是否真的重叠、`/subscribe` 是否带 backlog、attach 后 live init 是否一定再到、将来是否补 metadata hydration 或 cross-source guard，都只能留在灰度实现层 |

更稳的写法应先写：

- 层级分裂
- 控制语义分裂
- restore 语义分裂

再用 helper 名、gate 名、当前 hook 顺序举证，

不要反过来让 helper 名替代结构主语。

## 第八层：苏格拉底式自审

每次继续深挖 116-121，先追问自己：

1. 我现在写的是 completion / waiting、`system.init`，还是 attach / replay？
2. 我现在关心的是 transcript-visible outcome、raw object、payload thickness，还是 restore side effect？
3. 我是不是把 `success result ignored` 偷换成了“它不参与 completion”？
4. 我是不是把 `loading=false` 偷换成了“这一轮正常完成”？
5. 我是不是把 host-local dedupe 写成了 `system.init` 本体只存在一次？
6. 我是不是把 bridge redaction / feature gate 写成了所有宿主都成立的 init 合同？
7. 我是不是把 attach 后看见的 init banner 直接写成了 slash/bootstrap 已恢复？
8. 我是不是把 direct connect / SSH 的同构偷换成了所有 remote host 的统一状态机？
9. 哪些话即使 helper 名改掉、gate 名改掉以后仍然成立？哪些只是当前 wiring 证据？

如果这九个问题里有任何一个回答不稳，

就不该继续往 leaf-level 细节页下钻，

而应该先回到这张结构页重找主语。

## 第九层：阅读建议

如果你现在的问题是：

- “为什么 116-121 明明编号连着，却不能一路顺读成同一条后继链？”

建议按这个顺序：

1. 210：先记住 callback / adapter / consumer 已经分家
2. 211：先看这组六页的三组配对图
3. 如果你关心 completion / waiting：读 `116 -> 119`
4. 如果你关心 `system.init`：并列读 `117 + 120`
5. 如果你关心 attach / replay：先读 `118`，再读 `121`

如果你在 121 里再次被 init 词汇带偏，

先退回：

- 117 / 120

再回来继续看 attach / replay 这条线。
