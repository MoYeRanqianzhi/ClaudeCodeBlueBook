# owner-side recovery、transport stop rule 与 compaction boundary：为什么 122、123、124、125、126、127 不是线性六连，而是双主干加两个 zoom

## 用户目标

211 已经把：

- completion / waiting
- `system.init` 双轴
- attach / replay

拆成了三组相邻配对。

212 又已经把：

- owner-side recovery
- viewer ownership
- recovery signer
- transport authority
- terminality
- compaction

收成了“122/123 双根，124 signer zoom，125 降层根页，126/127 双枝”。

但继续往 `128-132` 读之前，

读者最容易在 122-127 这一组上留下一个新的误判：

- “虽然它们不是简单的线性六连，但大体上还是同一张 recovery 表，最多是从 122 一路细化到 127。”

这句话仍然不稳。

因为 122-127 更准确的结构不是：

- 一条 recovery 主干不断细化

而是：

- 一段 owner-side recovery / ownership / signer 主干
- 再跨到另一段 transport / terminality / compaction 主干

中间还有两个 zoom：

- 124 是 signer zoom
- 126 是 terminality zoom

所以这页要补的不是更多 leaf-level 证明，

而是先把 122-127 写成：

- 双主干加两个 zoom

本页不重讲 122、123、124、125、126、127 各页各自的页内证明，也不把 watchdog、warning、`viewerOnly`、`remoteConnectionStatus`、`handleClose(...)`、`reconnect()`、`PERMANENT_CLOSE_CODES`、`4001`、`COMPACTION_TIMEOUT_MS` 这些局部对象和 helper / 常量名重新升级成新的总纲主角；这里只把 `212` 那张 remote-recovery branch map 再收紧成“双主干 + 两个 zoom”的阅读拓扑：`122/123/124` 构成 owner-side recovery / ownership / signer 主干，`125/126/127` 构成 transport / terminality / compaction 主干，其中 `124` 与 `126` 只是 zoom，不是再长出的第三主干。换句话说，这里要裁定的是“哪一段是根页、哪一段是 zoom、哪一段是真正的降层点”，不是再把 leaf-level 的 recovery edge、proof surface、stop rule 或 compaction marker 写成一条连续细化链。

## 第一性原理

更稳的提问不是：

- “remote session 的恢复现在进行到哪一步了？”

而是先问九个更底层的问题：

1. 我现在写的是 owner-side recovery edge、ownership 边界，还是 signer surface？
2. 我现在写的是 transport authority、stop rule，还是 compaction 期间的保活 / completion marker？
3. 当前这个信号是 edge、proof、authority，还是 projection？
4. 当前这句话在描述“谁拥有恢复”，还是“transport 如何恢复”，还是“什么时候彻底停止恢复”？
5. 这个 client 只是还能发 content，还是也拥有 timeout / interrupt / title 这组三权？
6. 当前 close 属于 permanent rejection、`4001` stale exception，还是 ordinary post-connected drop？
7. 当前 `compacting` 是 progress/status、keep-alive、local patience，还是 rewrite completion？
8. 我是不是把 `4001` 在当前 remote-session 栈里的特判偷换成了所有 transport 的协议真义？
9. 我是不是又把 122-127 压回成同一张 recovery 表？

只要这九轴先拆开，

后面就不会再把：

- 122 的 recovery edge
- 123 的 ownership scope
- 124 的 signer proof
- 125 的 close-path authority
- 126 的 terminality bucket
- 127 的 compaction signal

重新压成一句模糊的：

- “恢复状态”

## 第二层：这组六页更稳的结构是“双主干加两个 zoom”

更稳的读法是：

```text
211 attach / restore boundary
  ├─ 第一主干：owner-side recovery / ownership / signer
  │    ├─ 122 recovery lifecycle           [根页]
  │    ├─ 123 viewer ownership             [并列根页 / 侧枝]
  │    └─ 124 recovery signer              [122 × 123 的 zoom]
  │
  └─ 第二主干：transport / terminality / compaction
       ├─ 125 transport close-path authority [降层根页]
       ├─ 126 terminality stop rule         [125 的 zoom]
       └─ 127 compaction contract           [125 的支线]
```

这里真正该记住的一句是：

- `122/123/124` 在回答谁拥有 recovery、谁能给 recovery 签字
- `125/126/127` 在回答 transport 怎样恢复、何时终止、compaction 怎样保活与收口

所以更准确的结构主语不是：

- recovery 一直继续细化

而是：

- 从 owner-side recovery 层，降到 transport contract 层

## 第三层：122 与 123 是双根，不是父子

122 先回答的是：

- timeout watchdog
- heartbeat clear
- timeout warning
- reconnect action
- reconnecting
- disconnected

为什么 remote session 的 recovery lifecycle 不是同一种状态。

123 回答的却不是：

- recovery 还有哪些 edge

而是：

- `viewerOnly`
- history
- timeout
- `Ctrl+C`
- title

这几组主权为什么说明 assistant client 不是 session owner。

所以 123 更准确的位置不是：

- 122 的后继叶页

而是：

- recovery 语境里回答 owner scope / gate 的第二根页

这一步如果不先写死，

你就会把：

- `viewerOnly` 没 warning
- `viewerOnly` 不改 title
- `viewerOnly` 不 interrupt

误写成：

- 122 里的某些 recovery state 例外

但这其实是在换主语：

- 从 lifecycle 换到 ownership

## 第四层：124 不是第三根，也不是第三张 state 页，而是双根之上的 zoom

124 回答的是：

- warning prompt
- durable connection state
- force reconnect action
- brief projection
- mode-conditioned absence

为什么它们不是同一种恢复证明。

它并不直接新增 recovery edge，

也不直接新增 ownership gate，

而是在前两页的基础上继续问：

- 哪些 surface 能签 recovery
- 哪些只是 prompt / action / projection / absence

所以更稳的写法应是：

- 124 是 `122 × 123` 的 proof/signer zoom

不是：

- recovery 主干里的第三张状态页

## 第五层：125 才是真正的降层点

124 以前，正文主要在回答：

- recovery edge taxonomy
- ownership scope
- signer surface

125 才开始切到：

- `SessionsWebSocket.handleClose(...)`
- `scheduleReconnect(...)`
- `reconnect()`
- `onReconnecting`
- `onClose`

这些 transport action-state contract。

这一步最该保护的一句是：

- `124 -> 125` 不是普通顺序递进，而是从 owner-side recovery / proof 层降到 transport authority 层

如果这句不先写死，

你就会把：

- `reconnect()`
- `onReconnecting`
- `onClose`

继续误写成 124 那种 signer 语言，

而不是：

- close-path authority

## 第六层：126 与 127 共享 125，却不互为父子

126 回答的问题是：

- `PERMANENT_CLOSE_CODES`
- `4001`
- reconnect budget

为什么 terminality policy 不是同一种 stop rule。

它的主语是：

- permanent rejection
- stale exception
- ordinary transient retry

127 回答的问题则是：

- `status=compacting`
- repeated compacting keep-alive
- `COMPACTION_TIMEOUT_MS`
- `4001`
- `compact_boundary`

为什么 compaction contract 不是同一种恢复信号。

它虽然借用了 126 的一个子结论：

- `4001` 在这条栈里是 stale-window exception

但它真正关心的已经是：

- progress/status
- keep-alive
- local patience
- transport exception
- rewrite completion

所以 127 更稳的是：

- 125 的 compaction 支线

不是：

- 126 的继续页

## 第七层：稳定阅读骨架 / 条件公开 / 内部证据层

这里的“稳定”只指：

- `122 / 123 / 124`
- `125 / 126 / 127`
- `124 / 126`

这张双主干加两个 zoom 的阅读骨架已经收稳

不指：

- owner-side recovery
- transport stop rule
- compaction boundary

这些中间节点名本身已经升级成稳定公开能力

真正的稳定公开能力判断，仍应回到用户入口、公开主路径与能力边界写作规范。

### 稳定可见

- `122 / 123 / 124` 当前稳定回答的是 recovery edge、ownership 与 signer family 不是同一层
- warning、reconnect action、reconnecting、disconnected 当前不能被压成同一状态词
- `viewerOnly` 当前稳定回答的是 non-owning interactive client，而不是 attached owner 的弱版本
- `125 / 126 / 127` 当前稳定回答的是 transport authority path、terminality bucket 与 compaction signal 也不是同一张表
- `handleClose(...)` 当前更像 transport authority path；`scheduleReconnect(...)`、`reconnect()`、`onClose` / `onReconnecting` 不是同一状态腿
- `4001` 在当前 remote-session 栈里只该读作 stale-window exception，不等于所有 transport 的统一协议真义

这里最该保住的一句是：

- recovery edge、ownership、signer、transport authority、terminality、compaction 不是一张表

### 条件公开

- `60s / 180s` timeout、`500ms` force reconnect 与 brief 行挂载条件，都仍受宿主和当前 transport path 约束
- `remote` pill 的 presence 条件、warning 是否出现、`KAIROS` 的参与方式，仍是条件化投影，不是普适 signer 合同
- terminality 三桶怎样显影、compaction 五类信号怎样进入不同 surface，仍取决于具体 host / hook / transport route
- `4001` 被谁当成 stale-window exception、谁直接当 permanent close，仍取决于当前 remote-session 栈与 transport 族别

### 内部/灰度层

- `MAX_RECONNECT_ATTEMPTS`、`MAX_SESSION_NOT_FOUND_RETRIES`、`RECONNECT_DELAY_MS`
- keep-alive cadence 与 reconnect scheduler 的具体节奏
- `compact_boundary.preserved_segment` 与 rewrite completion 的内部 bookkeeping
- warning / timeout / reconnect 的具体 hook 顺序与显示层投影细节

更稳的写法应先写：

- 层级分裂
- authority 分裂
- stop-rule 分裂
- compaction-signal 分裂

再用常量、gate、当前 hook 顺序举证。

所以这页最稳的结论必须停在：

- `122-127` 当前不是线性六连，而是双主干加两个 zoom
- `122 / 123 / 124` 处理 owner-side recovery、ownership 与 signer
- `125 / 126 / 127` 处理 transport、terminality 与 compaction
- `124` 与 `126` 是 zoom，不是再长出的第三主干

而不能滑到：

- 只要都在讲 remote recovery、warning、close、compacting，这六页本质上只是同一张 recovery 表不断细化

## 第八层：苏格拉底式自审

每次继续深挖 122-127，先追问自己：

1. 我现在写的是 recovery edge、ownership，还是 signer surface？
2. 我看到的是 action、authority，还是只是 projection？
3. 这个 client 只是能发 content，还是也拥有 timeout / interrupt / title 这组三权？
4. 我现在还停在 proof/signer 层，还是已经降到 transport authority 层？
5. 当前 close 属于 permanent rejection、`4001` stale exception，还是 ordinary post-connected drop？
6. 当前 `compacting` 是 progress/status、keep-alive、local patience，还是 completion marker？
7. 我是不是把 absence 直接写成了 opposite？
8. 我是不是把 `4001` 在当前栈里的特判，误写成了所有 transport 的稳定协议？
9. 我有没有把双主干又重新压回成一条 recovery 主干？

如果这九个问题里有任何一个回答不稳，

就不该继续往叶页下钻，

而应该先回到这张结构页重找主语。

## 第九层：阅读建议

如果你现在的问题是：

- “为什么 122-127 明明都围着 remote recovery 转，却不能按编号顺读成一条链？”

建议按这个顺序：

1. 211：先记住 attach / restore 这层已经结束
2. 213：先看 122-127 的双主干图
3. 如果你关心 owner-side recovery：读 `122`
4. 如果你关心 attached assistant 的主权边界：读 `123`
5. 如果你关心 recovery 证明的签字权：读 `124`
6. 如果你关心 transport authority：从 `125` 开始，再分到 `126 / 127`

如果你在 127 里再次被 `4001` 带偏，

先退回：

- 126

再回来继续看 compaction 支线。

## 结论

所以这页能安全落下的结论应停在：

- `122` 先把 owner-side recovery lifecycle 拆开，`123` 再把 viewer ownership 单列成并列根页，`124` 把 recovery signer 压成 zoom
- `125` 先把问题降到 transport / stop-rule 层，`126` 再把 terminality 压成 zoom，`127` 把 compaction 固定成平行支线
- `122-127` 因而不是一条 recovery 主干不断细化的线性六连，而是双主干加两个 zoom

一旦这句成立，

就不会再把：

- owner-side recovery
- ownership
- signer
- transport authority
- terminality
- compaction

写成同一种“remote recovery 细化页”。
