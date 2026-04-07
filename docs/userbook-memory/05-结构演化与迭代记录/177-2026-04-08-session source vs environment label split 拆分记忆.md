# session source vs environment label split 拆分记忆

## 本轮继续深入的核心判断

176 已经把 session create request body 拆成：

- attach target
- 来源声明
- 上下文载荷
- 默认策略

但 remote provenance 里还缺一句更窄的判断：

- session source declaration 与 environment origin label 也不等于同一种 provenance

本轮要补的更窄一句是：

- `createBridgeSession(... source:'remote-control')` 与 `metadata.worker_type` / `BridgeWorkerType` / `claude_code_assistant` 应分别落在 session family 与 environment label 两层

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 `source:'remote-control'` 写成 environment label
- 把 `claude_code_assistant` 写成另一种 session source
- 把 session family 与 environment filter 误写成同一张 provenance 表

这三种都会把：

- session provenance family
- environment origin label

重新压扁。

## 本轮最关键的新判断

### 判断一：`source:'remote-control'` 先是 session provenance family declaration

### 判断二：`worker_type` / `BridgeWorkerType` 先是 environment origin label

### 判断三：`claude_code_assistant` 是 environment label，不是另一种 session source

### 判断四：同一 remote-control session family 可以承载在多种 environment labels 上

### 判断五：这页主语必须停在 session vs environment 两个对象层，不回卷到 175/176 的更宽分类

## 苏格拉底式自审

### 问：为什么这页不是 176 的附录？

答：因为 176 讲 create request body 的字段主语；177 讲的是 source 与 worker_type 跨 session/environment 两个对象层的 provenance 分裂。

### 问：为什么必须把 `claude_code_assistant` 写进来？

答：因为只有把它拉出来，才能直接证明 environment label 的粒度比 `source:'remote-control'` 更细，而且不在同一层。

### 问：为什么一定要保留 `worker_type` 而不是只写 `workerType`？

答：因为真正进入 wire/request 的是 `metadata.worker_type`，没有这层就很容易把代码内窄标签误写成 session source 本体。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/177-createBridgeSession.source、metadata.worker_type、BridgeWorkerType 与 claude_code_assistant：为什么 session origin declaration 与 environment origin label 不是同一种 remote provenance.md`
- `bluebook/userbook/03-参考索引/02-能力边界/166-createBridgeSession.source、metadata.worker_type、BridgeWorkerType 与 claude_code_assistant 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/177-2026-04-08-session source vs environment label split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 177
- 索引层只补 166
- 记忆层只补 177

不回写 175、176。

## 下一轮候选

1. 继续拆 `session_context.sources/outcomes/model`：为什么同属 createSession context payload，也不是同一种上下文主语。
2. 继续拆 `source:'remote-control'` 与 `BridgePointer.source`：为什么 session family declaration 与 local prior-state trust-domain 不是同一种 source。
