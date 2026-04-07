# bridge continuity ledger split 拆分记忆

## 本轮继续深入的核心判断

183 已经拆开：

- local seed
- real delivery ledger

186 已经拆开：

- replay projection
- model prompt authority

但 bridge 线里还缺一句更窄的判断：

- 真实 delivery ledger 也不是跨所有 session incarnation 都能继承

本轮要补的更窄一句是：

- `reusedPriorSession`、`previouslyFlushedUUIDs`、`createCodeSession(...)` 与 `flushHistory(...)` 应分别落在 v1 continuity ledger、fresh-session break marker 与 v2 fresh-session replay contract 三层

## 为什么这轮必须单列

如果不单列，正文最容易在四种偷换里回卷：

- 把 `previouslyFlushedUUIDs` 写成 bridge 通用 suppress set
- 把 v2 不使用它写成实现偏好
- 把 183 的 ledger identity 当成已经回答完继承条件
- 把 186 的 replay object 当成已经回答完 continuity contract

这四种都会把：

- continuity
- replay
- dedup

重新压扁。

## 本轮最关键的新判断

### 判断一：v1 只有在真实 session continuity 成立时才继承 `previouslyFlushedUUIDs`

### 判断二：v1 一旦 fresh create，就必须 `clear()` 这张账

### 判断三：v2 从语义上拒绝 continuity ledger，因为它总是 fresh server session

### 判断四：因此差异核心是 suppress 的真理基础，而不是 dedup 技法

## 苏格拉底式自审

### 问：为什么这页不是 183 的附录？

答：183 讲的是 `previouslyFlushedUUIDs` 是什么账；189 讲的是这张账何时还能被继承。一个问 identity，一个问 inheritance condition。

### 问：为什么这页不是 186 的附录？

答：186 讲的是 replay object 为什么不等于 prompt authority；189 讲的是即便 replay object 相似，continuity ledger 也不等于 fresh-session replay contract。一个问对象边界，一个问连续性合同。

### 问：为什么不能只写“v1 dedup、v2 不 dedup”？

答：因为那会把差异降成实现细节，而当前源码明确告诉你 v2 拒绝这张账，是因为 fresh session 下旧 suppress 证据已经失真。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/189-reusedPriorSession、previouslyFlushedUUIDs、createCodeSession 与 flushHistory：为什么 v1 continuity ledger 与 v2 fresh-session replay 不是同一种 history contract.md`
- `bluebook/userbook/03-参考索引/02-能力边界/178-reusedPriorSession、previouslyFlushedUUIDs、createCodeSession 与 flushHistory 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/189-2026-04-08-bridge continuity ledger split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 189
- 索引层只补 178
- 记忆层只补 189

不回写 183、186。

## 下一轮候选

1. 若继续 bridge 线，可考虑把 v1 / v2 的 `writeMessages` 本地 suppress families 再单列，但必须避免重写 55 / 183。
2. 若切回 model 线，可整理 184-188 的阅读簇提示，但不应把正文膨胀成综述。
3. 若转去更细的 bridge UX 层，可单列 fresh fallback 后的 URL / pointer 语义，但必须避开 172-175 的旧主语。
