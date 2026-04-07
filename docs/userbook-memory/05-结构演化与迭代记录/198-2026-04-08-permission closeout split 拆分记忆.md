# permission closeout split 拆分记忆

## 本轮继续深入的核心判断

196 已经拆开：

- pending verdict ledger

但 permission race 在 verdict 之后还缺一句更细的判断：

- prompt 撤场、订阅退役、late response 消费与策略重判不是同一种 closeout contract

本轮要补的更窄一句是：

- `cancelRequest(...)`、unsubscribe、`pendingPermissionHandlers.delete(...)` 与 leader queue recheck 共同构成 permission race 的四层收口，但任何一层都不等于 `claim()` 自带的结果

## 为什么这轮必须单列

如果不单列，正文最容易在四种偷换里回卷：

- 把 `claim()` 当成所有 cleanup 的总闸
- 把 `cancelRequest(...)` 和 unsubscribe 写成一件事
- 把 `pendingPermissionHandlers.delete(...)` 写成本地赢时立即发生
- 把 leader queue recheck 写成 callback cleanup

这四种都会把：

- verdict ownership
- prompt dismiss
- subscription retirement
- queue re-evaluation

重新压扁。

## 本轮最关键的新判断

### 判断一：`claim()` 只关 verdict 主权，不关 closeout

### 判断二：`cancelRequest(...)` 负责远端 stale prompt 撤场

### 判断三：unsubscribe 负责本地 response subscription 退役

### 判断四：`pendingPermissionHandlers.delete(...)` 是 arrival-side consume，不一定随本地胜出同步发生

### 判断五：leader queue recheck 负责旧策略等待窗重判，不是 generic callback cleanup

## 苏格拉底式自审

### 问：为什么这页不是 196 的附录？

答：196 讲的是“这张 ledger 是什么”；198 讲的是“判完以后还有哪些表面没退休，而且各自谁来退”。

### 问：为什么 `cancelRequest(...)` 不能代表整个 closeout？

答：因为它只撤远端 prompt，不会自动退订本地 handler，也不会自动消费晚到 response。

### 问：为什么 queue recheck 不能算 callback cleanup？

答：因为它的主语是策略变化后的旧等待窗，remote / inbox 路径甚至直接 no-op。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/198-cancelRequest、onResponse unsubscribe、pendingPermissionHandlers.delete 与 leader queue recheck：为什么 bridge permission race 的 prompt 撤场、订阅退役、响应消费与策略重判不是同一种收口合同.md`
- `bluebook/userbook/03-参考索引/02-能力边界/187-cancelRequest、onResponse unsubscribe、pendingPermissionHandlers.delete 与 leader queue recheck 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/198-2026-04-08-permission closeout split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 198
- 索引层只补 187
- 记忆层只补 198

不回写 196。

## 下一轮候选

1. 若切回结构层，可把 191-198 再投影进更高层的功能面导航，但不能复制 197 的局部结构页。
2. 若继续 transcript 面，可看 webhook sanitize 是否值得单列，但必须避免把 195 切成实现噪音。
3. 若继续 permission 面，可看 sandbox network bridge 的 host-level sibling cleanup 是否值得与 tool-level closeout 分开，但必须避免回卷 198 的四层收口主句。
