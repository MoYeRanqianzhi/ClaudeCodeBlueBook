# provenance label vs identity split 拆分记忆

## 本轮继续深入的核心判断

174 已经把 environment register authority 拆成：

- local env key
- reuse claim
- live env
- session attach target

但 bridge provenance 里还缺一句更窄的判断：

- 来源标签、prior-state 域与 environment identity 也不等于同一种 provenance

本轮要补的更窄一句是：

- `workerType` / `metadata.worker_type`、`BridgePointer.source` 与 `environment_id` 应分别落在 origin label、local trust domain 与 runtime identity 三层

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 `workerType` 写成 environment identity
- 把 `metadata.worker_type` 写成 environment 主键或 lookup 字段
- 把 `BridgePointer.source` 写成 `workerType` 的本地镜像，而不是 local prior-state trust domain

这三种都会把：

- origin filter label
- prior-state trust-domain marker
- runtime environment identity

重新压扁。

## 本轮最关键的新判断

### 判断一：`workerType` / `metadata.worker_type` 先是 origin label，不是 identity

### 判断二：`BridgePointer.source` 先是 local prior-state trust-domain marker，不是 web/client filter

### 判断三：`environment_id` 仍独立承担 environment lifecycle identity

### 判断四：assistant mode 改的是 origin label，而不是 environment identity space

### 判断五：同属“来源字段”，消费宿主也仍分裂为 remote-visible filter 与 local trust-domain gate

## 苏格拉底式自审

### 问：为什么这页不是 173 的附录？

答：因为 173 讲 env truth 厚度；175 讲 provenance label / trust-domain / identity 的语义分裂。

### 问：为什么必须把 `BridgePointer.source` 拉进来？

答：因为只有把它拉进来，才能直接证明“来源”在本地 prior-state 与 web/client 过滤里并不是一套消费面。

### 问：为什么一定要保留 `environment_id`？

答：因为没有 identity 这一层，就无法证明前面的字段只是 label / trust-domain，而不是对象主权。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/175-BridgeWorkerType、metadata.worker_type、BridgePointer.source 与 environment_id：为什么环境来源标签、prior-state 域与环境身份不是同一种 provenance.md`
- `bluebook/userbook/03-参考索引/02-能力边界/164-BridgeWorkerType、metadata.worker_type、BridgePointer.source 与 environment_id 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/175-2026-04-08-provenance label vs identity split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 175
- 索引层只补 164
- 记忆层只补 175

不回写 24、33、173、174。

## 下一轮候选

1. 继续拆 `createBridgeSession.environment_id` 与 `source:'remote-control'`：为什么 session attach target 与 session origin declaration 不是同一种会话归属。
2. 继续拆 `workerType`、`max_sessions` 与 `spawnMode`：为什么同在 registration metadata / payload 里，也不是同一种 environment capability label。
