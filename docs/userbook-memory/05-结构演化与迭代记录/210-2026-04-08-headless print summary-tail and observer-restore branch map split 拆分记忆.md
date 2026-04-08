# headless print summary-tail and observer-restore branch map split 拆分记忆

## 本轮继续深入的核心判断

`100-104` 这一组页单独做成“全是并列尾页”并不稳，

但直接拉到 `100-110` 又太宽。

更准确的结构是：

- 100 先定 summary 分家
- `101→102→104` 收成终态收口主干
- 103 单独走 observer metadata stale scrub vs restore 侧枝

所以这轮最该补的不是更宽的 visibility / streamlined 总图，

而是：

- 一张只覆盖 `100-104` 的 `05` 分叉结构页
- 一张只覆盖 `89-93` 索引的 `03` 速查入口

## 为什么这轮必须单列

如果不补这一层，

正文最容易在五种偷换里回卷：

- 把 101 写成 100 的输出附录
- 把 102 写成 101 的 suggestion 附录
- 把 103 写成 100 的恢复附录
- 把 104 误写成“已经确认外部协议有 bug”
- 提前把 105 以后那组 wire/streamlined 页硬塞进这一轮结构页

## 本轮最关键的新判断

### 判断一：100 是根页，不是尾页之一

它先回答：

- `task_summary`
- `post_turn_summary`

为什么不是同一条 transport-lifecycle contract。

### 判断二：`101→102→104` 是真正的主干

它们分别在回答：

- terminal cursor vs raw stream tail
- delivered suggestion vs settled telemetry
- cleanup asymmetry leaves inert stale slot

### 判断三：103 只该作为 observer-restore 侧枝

它不应被揉回 100 的 summary 主语，

但也不该在这一轮里被 105/107/167 那组更宽恢复/可见性结构再带走。

### 判断四：这一组页更适合保护“稳定对象分裂”，不是继续追 helper 名

稳定层应写：

- `task_summary` 是 freshness-first 的 mid-turn progress metadata
- `post_turn_summary` 是 after-turn recap
- `result` 主位不等于流终点
- 已交付 suggestion 不等于已结算
- observer metadata 不等于 restore input

灰度层才写：

- `lastMessage`
- `lastEmitted`
- `pendingLastEmittedEntry`
- `externalMetadataToAppState(...)`
- worker init scrub

## 苏格拉底式自审

### 问：为什么这轮不是直接把 105-110 一起收掉？

答：因为 105-110 更像下一轮的 wire / callback / streamlined 分叉；这轮先把 100-104 的主语收稳更重要。

### 问：为什么这轮不是做 `04-专题深潜`？

答：这轮主要在修正 `05/03` 层的结构主语，不是在映射新的用户问题入口。

### 问：为什么这轮值得补 `03` 索引？

答：因为这里新增的是一个新的能力边界对象：

- summary-tail and observer-restore branch map

它不是任意一篇单页正文的附属摘要。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/208-task_summary、post_turn_summary、terminal tail、observer restore 与 suggestion settlement：为什么 100-104 不是并列细页，而是先从 summary 分家，再分叉到终态收口与恢复合同.md`
- `bluebook/userbook/03-参考索引/02-能力边界/195-Headless print summary-tail and observer-restore branch map 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/210-2026-04-08-headless print summary-tail and observer-restore branch map split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 补 `05` 分叉结构页
- 补 `03` 速查索引
- 不新增 `04` 专题投影
- 不回写 100-104 旧正文

## 下一轮候选

1. 若继续这一簇，可把 105/106/108/109/110 再收成一张更窄的 `summary-wire / callback / streamlined` 二级结构页。
2. 若继续恢复线，可把 103/107/167 再收成一张 `observer metadata / model override / local consumption` 的恢复结构页。
3. 若继续用户症状入口，再决定是否要把 headless print 的 `summary/tail/wire` 分叉投到 `04` 的自动化专题里。
