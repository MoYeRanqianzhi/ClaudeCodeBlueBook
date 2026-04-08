# headless print remote recovery branch map split 拆分记忆

## 本轮继续深入的核心判断

`122-127` 不该继续被读成：

- 一条从 timeout warning 走到 compaction boundary 的线性 recovery 后续链

更准确的结构是：

- `122` = owner-side recovery 根页
- `123` = ownership 侧枝
- `124` = signer / proof zoom
- `125` = transport authority 的降层根页
- `126` = terminality zoom
- `127` = compaction 支线

所以这轮最该补的是：

- 一张只覆盖 `122-127` 的 `05` 结构页
- 一张对应 `111-116` 索引的 `03` 速查入口
- 一条新的持久化记忆，把“双根 + zoom + 降层主干”这层结构钉死

## 为什么这轮不能写成线性链

### 判断一：123 不是 122 的附录，而是 ownership 侧枝

122 在拆：

- watchdog
- warning
- reconnect action
- reconnecting
- disconnected

123 关心的却是：

- 谁拥有 timeout / title / interrupt / history 这组主权

所以 123 更稳的是：

- ownership scope / gate

不是：

- recovery edge 的普通后续页

### 判断二：124 不是第三张 recovery state 页，而是 signer zoom

124 最值钱的不是继续列恢复状态，

而是分清：

- warning prompt
- durable authority
- force reconnect action
- brief projection
- mode-conditioned absence

谁能给 recovery 签字。

所以 124 更稳的是：

- 建立在 122 + 123 之上的 proof / signer zoom

不是：

- 122 之后的第三个 state page

### 判断三：125 才是真正的降层点

124 以前，正文还在讲：

- owner-side recovery
- ownership
- signer

125 以后，正文才开始讲：

- `SessionsWebSocket.handleClose(...)`
- `scheduleReconnect(...)`
- `reconnect()`
- `onClose / onReconnecting`

也就是 raw transport authority。

所以 125 更稳的是：

- 降层根页

不是：

- 124 的附录

### 判断四：126 与 127 不该互为父子

126 问的是：

- stop rule / terminality bucket

127 问的是：

- compaction 期间有哪些不同合同在同时发生

127 虽然借用：

- `4001` = stale-window exception

但主语已经换成：

- progress
- keep-alive
- local patience
- exception
- completion marker

所以 `127` 更稳的是：

- 从 125 分出的 compaction 支线

不是：

- 126 的继续页

## 本轮最关键的新判断

### 判断五：真正的硬边界不在 121→122，而在 124→125

121 以后虽然编号继续推进，

但 `122-124` 仍然主要回答：

- recovery / ownership / signer

只有到了 `125`，

问题才真正切到：

- transport authority
- terminality
- compaction contract

所以这轮结构页必须把：

- 124→125

写成降层点。

### 判断六：absence 不是 opposite，surface 不是 authority

这一轮最值钱的保护句是：

- 没看到 warning / brief / remote pill，不等于没有 recovery 或没有 remote session

以及：

- warning prompt、shared durable state、force reconnect action、brief projection 不是同一种恢复证明

### 判断七：`4001` 必须继续被保护在“当前栈、当前语境”里

稳定层可保：

- `SessionsWebSocket` 当前把 `4001` 当作 compaction stale-window exception

但灰度层必须继续降级：

- 这不等于所有 transport 都这样处理 `4001`
- 也不等于 `4001` 本体就是普通 reconnect 的小预算版本

## 苏格拉底式自审

### 问：我现在写的是 recovery、ownership、signer，还是 transport authority？

答：如果还没先回答这个问题，

就不该往下写。

### 问：这个 surface 只是 prompt / projection，还是 authority？

答：凡是看到：

- warning
- brief line
- remote pill
- reconnecting label

都要先追问：

- 它只是 surface，还是 state 本体？

### 问：我是不是又把 absence 写成了 opposite？

答：attached viewer、brief-only、`viewerOnly`、`KAIROS`、`remoteSessionUrl` 都会让某些 signer / surface 缺席；

缺席不自动等于状态不存在。

### 问：为什么这轮不新开独立 `04` 专题？

答：这轮核心仍然是把 `05/03` 的 recovery 主语收稳；`04` 只需要把“为什么 attached viewer 没 warning 但 recovery 仍在发生”挂进现有远端专题即可，不值得另起新专题。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/212-remote recovery、viewer ownership、transport terminality 与 compaction contract：为什么 122、123、124、125、126、127 不是一条 recovery 后续链.md`
- `bluebook/userbook/03-参考索引/02-能力边界/199-Headless print remote recovery branch map 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/214-2026-04-08-headless print remote recovery branch map split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/04-专题深潜/23-远端前台运行、会话存在面与桥接后台分诊专题.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 补 `05` 结构页
- 补 `03` 速查索引
- 不新增 `04` 专题页，只在既有远端专题补投影入口
- 不回写 122-127 旧正文

## 下一轮候选

1. 若继续这一簇，可把 `128-132` 收成 `4001 cross-transport / presence surface / remote status table / front-state consumer` 的后继结构页。
2. 若继续用户症状入口，可把“为什么 attached viewer 没 warning / remote pill，却仍然连在远端恢复链里”继续投影到 `04-23` 或相邻专题。
3. 若继续保护稳定/灰度边界，可先把 `128/129` 的 cross-transport `4001` 语义与 refresh 主权收稳，再决定是否单列 `WebSocketTransport` 分支。
