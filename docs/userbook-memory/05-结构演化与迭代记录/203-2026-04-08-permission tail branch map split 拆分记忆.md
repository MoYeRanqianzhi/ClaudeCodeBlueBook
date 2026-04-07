# permission tail branch map split 拆分记忆

## 本轮继续深入的核心判断

191-202 这条线继续往下拆后，目录层开始出现新的结构债：

- 196、198、199、201、202 都在讲 permission tail
- 但它们的主语已经不再相同

本轮要补的更窄一句是：

- 196 是 permission tail 的根页，198 / 199 / 201 / 202 则是从 verdict ledger 分叉出去的四个不同后继问题

## 为什么这轮必须单列

如果不单列，正文最容易在四种偷换里回卷：

- 把 198 和 199 压成同一种 cleanup 尾巴
- 把 201 写成 sandbox 版 198
- 把 202 写成 repo-wide generic persist family
- 把 `00-阅读路径` 当成局部子系统 anti-overlap map 的替代品

这四种都会把：

- verdict ledger
- closeout
- re-evaluation
- host sweep
- persist surfaces

重新压扁。

## 本轮最关键的新判断

### 判断一：196 是根页，不是并列尾页之一

### 判断二：198 只讲 request-level closeout

### 判断三：199 讲的是 permission context change 下的 leader-local re-evaluation

### 判断四：201 讲的是 sandbox network 分支里的 host-level sibling sweep

### 判断五：202 讲的是本地 sandbox persist 之后的 write-surface propagation，不是 repo-wide 总页

## 苏格拉底式自审

### 问：为什么这页不是 197 的附录？

答：197 讲 191-196 的 ingress 阅读链；203 讲 196 之后 permission tail 的继续分叉。

### 问：为什么这页不是 20 的附录？

答：20 在用户目标层分 continuation / host / ingress / permission；203 已经退回局部控制面，只收 permission tail。

### 问：为什么这页不是 `00-阅读路径.md` 的复制？

答：`00` 解决入口问题；203 解决进到 permission tail 之后的 anti-overlap map。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/203-pendingPermissionHandlers、cancelRequest、recheckPermission、hostPattern.host 与 applyPermissionUpdate：为什么 permission tail 的 196、198、199、201、202 不是并列尾页，而是从 verdict ledger 分叉出去的四种后继问题.md`
- `bluebook/userbook/03-参考索引/02-能力边界/191-pendingPermissionHandlers、cancelRequest、recheckPermission、hostPattern.host 与 applyPermissionUpdate 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/203-2026-04-08-permission tail branch map split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 203
- 索引层只补 191
- 记忆层只补 203

不回写 197，也不新增 `04-专题深潜` 投影页。

## 下一轮候选

1. 若继续目录优化，可再补一个更偏用户目标的 `04-专题深潜` permission 尾部专题，但前提是不能复制 20 的 continuation / ingress 职责。
2. 若继续功能面分析，可转向前台 remote runtime 与后台 bridge overlay 的分工边界。
3. 若继续状态发布线，可拆 `StructuredIO` 的 `can_use_tool`、`requires_action` 与 session state projection。
