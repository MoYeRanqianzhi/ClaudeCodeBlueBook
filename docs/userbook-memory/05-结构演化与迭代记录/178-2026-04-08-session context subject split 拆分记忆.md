# session context subject split 拆分记忆

## 本轮继续深入的核心判断

177 已经把 remote provenance 拆成：

- session provenance family
- environment origin label

但 `session_context` 里还缺一句更窄的判断：

- 同属 context payload，也不等于主语相同

本轮要补的更窄一句是：

- `session_context.sources`、`session_context.outcomes`、`session_context.model` 应分别落在 repo source、branch outcome 与 model stamp 三层

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 `sources` 与 `outcomes` 写成同一份 repo metadata
- 把 `model` 写成 repo/branch 的同类上下文字段
- 把 typed `session_context` bag 写成统一消费面

这三种都会把：

- source-side declaration
- outcome-side projection
- model stamp

重新压扁。

## 本轮最关键的新判断

### 判断一：`sources` 先是 repo source declaration

### 判断二：`outcomes` 先是 branch outcome projection

### 判断三：`model` 先是 model stamp，不是 repo/branch 语义字段

### 判断四：当前 helper surface 已经把 `sources` 与 `outcomes` 分成不同消费路径

### 判断五：`session_context` 被 typed 出来，不等于其中字段共享同一消费宿主

## 苏格拉底式自审

### 问：为什么这页不是 176 的附录？

答：因为 176 讲的是 create request body 的 attach/source/context/policy 四分；178 讲的是 `session_context` 自己内部的三分。

### 问：为什么必须把 `outcomes` 拉出来？

答：因为只有把它和 `sources` 对照，才能直接证明 declaration 与 projection 已经分家。

### 问：为什么一定要保留 `model`？

答：因为没有它，这页就只剩 git 语义；保留 `model` 才能证明同一个 bag 里还存在完全不同主语的 stamp 字段。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/178-session_context.sources、session_context.outcomes、session_context.model 与 getBranchFromSession：为什么 repo source、branch outcome 与 model stamp 不是同一种上下文主语.md`
- `bluebook/userbook/03-参考索引/02-能力边界/167-session_context.sources、session_context.outcomes、session_context.model 与 getBranchFromSession 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/178-2026-04-08-session context subject split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 178
- 索引层只补 167
- 记忆层只补 178

不回写 39、152、167、176。

## 下一轮候选

1. 继续拆 `session_context.model` 与 durable / live metadata 里的 model：为什么 session-create model stamp 与 runtime model readback 不是同一种 model ledger。
2. 继续拆 `sources` 与 `outcomes` 的 git 语义：为什么 repo declaration 与 branch projection 不是同一种 git context。
3. 继续拆 `createBridgeSession.source` 与 `BridgePointer.source`：为什么同名 `source` 也不等于同一种 authority object，但这页必须比 177 更窄，只写 session family declaration 与 local prior-state trust-domain 的错位。
