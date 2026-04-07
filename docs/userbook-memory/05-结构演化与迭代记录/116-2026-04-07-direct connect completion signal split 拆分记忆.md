# direct connect completion signal split 拆分记忆

## 本轮继续深入的核心判断

115 已经把 adapter 内：

- render parity
- replay completeness
- success noise suppression

拆开。

但如果不继续往外压，读者还是会把另一组相邻概念重新揉回一句：

- success `result` ignored
- error `result` visible
- `isSessionEndMessage(...)`
- `setIsLoading(false)`

都叫“完成信号”。

这轮要补的更窄一句是：

- visible result 是一层
- turn-end 判定是一层
- busy state 是一层

都与完成有关，但不是同一种 completion signal。

## 为什么这轮必须单列

如果不单列，正文最容易在三种错误里摇摆：

- 把 success `result` ignored 写成“不算完成”
- 把 error `result` visible 写成“更强完成”
- 把 `setIsLoading(false)` 写成 authoritative terminal close

这三种都会把：

- transcript outcome
- turn-end classifier
- busy-state transition

重新压平。

## 本轮最关键的新判断

### 判断一：`result` 在 adapter 里先被分成 visible / ignored

这是 transcript policy，不是 turn-end 语义。

### 判断二：`isSessionEndMessage(...)` 对 success / error 一视同仁

这是 coarse turn-end classifier，不是 visible outcome。

### 判断三：`setIsLoading(false)` 比 `result` 更宽

permission pause、disconnect、cancel 都会命中，所以它不是单一 completion signal。

## 苏格拉底式自审

### 问：为什么这页不能并回 115？

答：115 讲 adapter 内不同 policy；116 讲 adapter 外的 hook 收口和 busy-state 也不是同一层。

### 问：为什么这页不能并回 114？

答：114 讲 callback / adapter / sink 的层级；116 讲 completion-related semantics 在相邻层里的再拆分。

### 问：为什么一定要把 permission request 拉进来？

答：因为没有这个反例，`setIsLoading(false)` 太容易被误写成 terminal completion。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/116-success result ignored、error result visible、isSessionEndMessage、setIsLoading(false) 与 permission pause：为什么 direct connect 的 visible result、turn-end 判定与 busy state 不是同一种 completion signal.md`
- `bluebook/userbook/03-参考索引/02-能力边界/105-visible result、turn-end 判定与 busy state completion 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/116-2026-04-07-direct connect completion signal split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 116
- 索引层只补 105
- 记忆层只补 116

不新增目录，只更新导航。

## 下一轮候选

1. 单独拆 `system.init` callback-visible、`useDirectConnect` 去重与 `convertInitMessage(...)` 为什么不是同一种初始化可见性。
2. 单独拆 viewerOnly 的 `convertUserTextMessages`、`sentUUIDsRef` echo dedup 与 history attach overlap 为什么不是同一种 replay 去重。
3. 单独拆 `sendMessage -> setIsLoading(true)`、`permission allow -> setIsLoading(true)`、`result/disconnect/cancel -> setIsLoading(false)` 为什么不是同一种 loading lifecycle。
