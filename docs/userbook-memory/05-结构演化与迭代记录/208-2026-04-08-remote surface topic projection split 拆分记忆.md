# remote surface topic projection split 拆分记忆

## 本轮继续深入的核心判断

204 已经把 remote surface 收成：

- front-state consumer topology 根页
- foreground runtime / interaction shell / presence ledger / gray runtime / behavior bit 分叉

但从用户问题层看，还缺一张中层承接页：

- 用户知道“现在在用远端能力”
- 却不知道眼前面对的是前台 runtime、session ledger，还是 bridge overlay

本轮要补的更窄一句是：

- `04-专题深潜` 需要一张分诊页，把 “foreground runtime / presence / overlay / remote bit” 直接映射到 135 / 138 / 141 / 142 / 143 / 204

## 为什么这轮必须单列

如果不单列，正文最容易在四种偷换里回卷：

- 把 204 继续留在 `05` 层，不给用户问题层入口
- 把 06/16 的多前端总览误当成已经覆盖了 remote surface 分诊
- 把 bridge overlay 写成第四种前台 runtime
- 把 `getIsRemoteMode()` 写成 authoritative presence truth

## 本轮最关键的新判断

### 判断一：06/16 解决的是多前端与 continuation 总览，不覆盖 remote surface 局部分诊

### 判断二：204 解决的是控制面结构，不直接服务用户症状入口

### 判断三：新的 `04` 页只负责把“我现在面对的是哪一种 remote surface”映射到 135 / 138 / 141 / 142 / 143

## 苏格拉底式自审

### 问：为什么这页不是 06 的附录？

答：06 还在做前端与远程总览；23 已经退回局部 remote surface 分诊。

### 问：为什么这页不是 16 的附录？

答：16 讲 continuation / handoff；23 讲 runtime / presence / overlay。

### 问：为什么这页不是 204 的附录？

答：204 讲控制面结构；23 讲用户问题分诊。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/04-专题深潜/23-远端前台运行、会话存在面与桥接后台分诊专题.md`
- `docs/userbook-memory/05-结构演化与迭代记录/208-2026-04-08-remote surface topic projection split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/04-专题深潜/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 只补 `04` 专题投影
- 不新增 `03` 索引页
- 不回写 204

## 下一轮候选

1. 若继续 remote 线，可把 `204` 再往 owner split / overlay publish 分裂出更细的结构图。
2. 若继续 blocked-state 线，可把 `206` 的 publish/restore 断裂再做一张 `05` 层结构页。
3. 若继续 headless / print 线，可回到 `post_turn_summary/task_summary` 的 foreground narrowing 继续向上投影。
