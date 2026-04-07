# environment register authority split 拆分记忆

## 本轮继续深入的核心判断

173 已经把 environment truth layering 拆成：

- pointer env hint
- server session env
- registered env result

但 register chain 内部还缺一句更窄的判断：

- environment 字段同属 register family，也不等于主权层次相同

本轮要补的更窄一句是：

- `BridgeConfig.environmentId`、`reuseEnvironmentId`、注册返回 env，以及 `createBridgeSession` 消费的 env，应分别落在 local key、reuse claim、live result 与 attach target 四层

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 `BridgeConfig.environmentId` 写成当前 live env
- 把 `reuseEnvironmentId` 写成当前 live env，而不是 request-side claim
- 把 `createBridgeSession({ environmentId })` 写成仍在消费 reuse claim，而不是已落成的 live env

这三种都会把：

- local config slot
- backend-facing reuse claim
- live runtime env
- session attach target

重新压扁。

## 本轮最关键的新判断

### 判断一：`BridgeConfig.environmentId` 先是 local config key，而不是 runtime live env

### 判断二：当前 register request 真正进入 env-claim surface 的是 `reuseEnvironmentId`

### 判断三：`registerBridgeEnvironment(...).environment_id` 才是当前 runtime 承认的 live env

### 判断四：`createBridgeSession({ environmentId })` 消费的是 live env，而不是 request-side reuse claim

### 判断五：env mismatch 证明 request-side claim 与 response-side live env 可以分裂

## 苏格拉底式自审

### 问：为什么这页不是 173 的附录？

答：因为 173 讲的是 hint、truth、result 的厚薄；174 讲的是 register chain 里 local key、reuse claim、live env 与 attach target 的合同分层。

### 问：为什么必须把 `BridgeConfig.environmentId` 单独拉出来？

答：因为如果不把它单列，读者很容易把类型里的本地 env 槽位误写成 backend 承认的 live env。

### 问：为什么必须把 `createBridgeSession(...)` 拉进来？

答：因为只有把 attach 面拉进来，才能证明 live env 还会继续向下游变成 session attach target，而不是停在 register 结果这一步。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/174-BridgeConfig.environmentId、reuseEnvironmentId、registerBridgeEnvironment.environment_id 与 createBridgeSession：为什么本地 env key、reuse claim、live env 与 session attach target 不是同一种环境主权.md`
- `bluebook/userbook/03-参考索引/02-能力边界/163-BridgeConfig.environmentId、reuseEnvironmentId、registerBridgeEnvironment.environment_id 与 createBridgeSession 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/174-2026-04-08-environment register authority split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 174
- 索引层只补 163
- 记忆层只补 174

不回写 42、173。

## 下一轮候选

1. 继续拆 `createBridgeSession.environment_id` 与 `registerBridgeEnvironment.environment_id`：为什么 live env result 与 session attach target 仍不是同一种对象主权。
2. 继续拆 `workerType`、`metadata.worker_type` 与 environment filter：为什么环境来源标签不是 environment identity 本身。
