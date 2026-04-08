# headless print remote recovery double-trunk split 拆分记忆

## 本轮继续深入的核心判断

`122-127` 还不能被写成：

- 一条从 timeout warning 慢慢细化到 compaction boundary 的线性 recovery 链

更准确的结构是：

- `122/123/124` = owner-side recovery / ownership / signer 这一段主干
- `125/126/127` = transport authority / terminality / compaction 这一段主干

而真正的降层点在：

- `124 -> 125`

所以这轮最该补的是：

- 一张只覆盖 `122-127` 的 `05` 双主干结构页
- 一张新的 `03` 索引页，把“不是线性六连，而是双主干加两个 zoom”钉死
- 一条新的持久化记忆，专门记录这次的降层点

## 为什么这轮要从 branch map 升级成 double-trunk

### 判断一：212 还不够，因为它更像“总图”

212 已经说明：

- `122/123` 是双根
- `124` 是 signer zoom
- `125` 是降层根页
- `126/127` 是双枝

但继续往下推进时，更值钱的不是再重复总图，

而是把：

- `122/123/124`

整体写成第一主干，

再把：

- `125/126/127`

整体写成第二主干。

这样才能真正保护：

- recovery / ownership / signer

与

- transport / stop rule / compaction

之间的层级切换。

### 判断二：123 不是“第二页”，而是第一主干的另一根

122 讲的是：

- owner-side recovery edge

123 讲的是：

- 哪些 client 有权进入并主导这条 recovery loop

如果把 123 继续写成 122 的后续页，

正文就会很容易把：

- owner scope / gate

误写成：

- recovery edge 的补充说明

### 判断三：124 只是 zoom，不该再抬成第三根

124 只有在：

- 122 的 recovery edge 词汇
- 123 的 ownership 缺席语义

都已经成立时才稳。

所以它更像：

- 第一主干上的 signer / proof zoom

而不是：

- 第三根并列主线

### 判断四：125 是这轮最该记住的降层点

124 以前在谈：

- owner-side recovery
- ownership
- signer

125 开始在谈：

- transport authority
- close path
- reconnect / onClose / onReconnecting

如果不把这一步当成降层点，

后面就会继续把：

- `reconnect()`
- `onClose`
- `4001`
- `compact_boundary`

都写成“recovery surface”

而不是：

- transport / terminality / compaction contract

### 判断五：126 和 127 是第二主干上的 zoom + 支线

126 继续 zoom：

- stop rule / terminality bucket

127 继续分支：

- compaction contract 的五种不同信号

127 借用 126 的 `4001` 结论，

但主语已经换成：

- progress
- keep-alive
- local patience
- transport exception
- completion marker

所以 127 不能再被写成 126 的顺序尾页。

## 本轮最关键的新判断

### 判断六：absence / projection 不能越层给 transport 签字

这一轮最值钱的保护句是：

- warning、brief、remote pill、bridge pill、dialog 都是 surface；surface 缺席不等于状态缺席

更稳的顺序是：

1. 先问它是 authority、prompt、action 还是 projection
2. 再问它有没有资格给 recovery / presence / transport 签字

### 判断七：`4001` 必须被持续限定在“当前 transport + 当前语境”

稳定层可保：

- `SessionsWebSocket` 里的 `4001` 当前是 stale-window exception

灰度层必须继续降级：

- 这不等于所有 transport 都这样解释
- 也不等于同一个 code 在另一层 transport 不会走 permanent close

### 判断八：这轮要记住主工作树前置状态

这轮开始前已核对：

- `origin/main` 无新提交领先本地主树

但主工作树 `/home/mo/m/projects/cc/analysis` 仍处于：

- `main...origin/main [ahead 8]`
- 且有未解决冲突

因此本轮继续只在：

- `.worktrees/userbook`

内推进，

不触碰主工作树的冲突解决。

## 苏格拉底式自审

### 问：我现在还在第一主干，还是已经降到第二主干？

答：先判断我在谈的是：

- recovery / ownership / signer

还是：

- transport / terminality / compaction

没先判断，就不要落字。

### 问：我是不是把某个 surface 当成了 authority？

答：凡是看到：

- warning
- brief line
- remote pill
- bridge pill
- dialog

都要先追问：

- 它只是 prompt / projection，还是 state 本体？

### 问：我是不是把 `4001` 当前的处理偷换成了全局协议真义？

答：如果一句话离开：

- 当前 transport
- 当前 caller
- 当前 compaction / sleep / stale-window 语境

就不成立，

那它必须降级。

### 问：为什么这轮不新开 `04` 专题页？

答：这轮核心仍然是把 `05/03` 的结构主语收稳；`04` 只需继续在既有远端专题里挂症状入口，不值得另起一页。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/213-owner-side recovery、transport stop rule 与 compaction boundary：为什么 122、123、124、125、126、127 不是线性六连，而是双主干加两个 zoom.md`
- `bluebook/userbook/03-参考索引/02-能力边界/200-Headless print remote recovery double-trunk map 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/215-2026-04-08-headless print remote recovery double-trunk split 拆分记忆.md`

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

- 补 `05` 双主干结构页
- 补 `03` 速查索引
- 不新增 `04` 专题页，只在既有远端专题补更窄的 recovery 症状入口
- 不回写 122-127 旧正文

## 下一轮候选

1. 若继续这一簇，可把 `128-132` 收成 `cross-transport 4001 / refresh authority / presence surface / remote status table / front-state consumer` 的后继结构页。
2. 若继续用户症状入口，可继续把“warning / brief / remote pill / attached viewer 缺席不等于 opposite”投到 `04-23` 的更窄 symptom 分流里。
3. 若继续保护稳定/灰度边界，可先把 `128/129` 的 cross-transport `4001` 与 refresh 主权稳住，再决定 `130/131/132` 是一条 presence 主干，还是同样要拆成双主语。
