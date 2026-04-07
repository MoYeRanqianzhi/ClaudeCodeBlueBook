# CCR v2 metadata readback vs local consumption split 拆分记忆

## 本轮继续深入的核心判断

166 已经把 `print` remote recovery 拆成：

- transcript
- metadata
- emptiness

三层。

但正文还缺一句更细的状态判断：

- `metadata` 这一层内部，`restoredWorkerState` 的 readback bag 与当前 `print` 的 local consumption sink 也不是同一种合同

本轮要补的更窄一句是：

- CCR v2 把 worker metadata 读回来，不等于 observer metadata 因此自动进入同一种本地消费面

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 `restoredWorkerState` 写成所有 resume host 都天然拥有的恢复面
- 把 `SessionExternalMetadata` 的袋子宽度写成当前 `print` 的本地消费宽度
- 把 `pending_action/task_summary/post_turn_summary` 误写成“既然读回就已恢复本地前台”

这三种都会把：

- transport capability
- metadata readback
- local admission
- observer metadata non-consumption

重新压扁。

## 本轮最关键的新判断

### 判断一：`StructuredIO.restoredWorkerState = null` 说明 readback 先是 transport capability

### 判断二：`RemoteIO` 只在 CCR v2 下把 `initialize()` 挂成 `restoredWorkerState`

### 判断三：`CCRClient.initialize()` 读回旧 metadata 的同时也会 scrub stale `pending_action/task_summary`

### 判断四：同一袋 `external_metadata` 还存在 `notifySessionMetadataChanged() -> reportMetadata()` 的更宽 live publish path

### 判断五：`print.ts` 当前只接纳 mode / ultraplan，加上单独的 model override

### 判断六：observer metadata 三兄弟更像 bag presence / cross-surface intent，不是当前 headless `print` 的本地恢复面

## 苏格拉底式自审

### 问：为什么这页不是 166 的附录？

答：因为 166 讲的是 remote recovery 的 stage 差异；167 讲的是 metadata stage 内部 readback 与 consumption 的再次分裂。

### 问：为什么这页不是 103 的附录？

答：因为 103 讲 observer metadata 的恢复合同宽度；167 讲 `restoredWorkerState` 到 local sink 的 admission gate。

### 问：为什么一定要把 `CCRClient.initialize()` 拉进来？

答：因为只有把 concurrent GET + init scrub 写出来，才能说明 readback 不是“原样继续生效”的签字。

### 问：为什么一定要把 `StructuredIO` / `RemoteIO` 拉进来？

答：因为否则读者会误以为 `restoredWorkerState` 是 resume 的普遍属性，而不是 CCR v2 remote transport 的条件能力。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/167-restoredWorkerState、externalMetadataToAppState、SessionExternalMetadata 与 RemoteIO：为什么 CCR v2 的 metadata readback 不是 observer metadata 的同一种本地消费合同.md`
- `bluebook/userbook/03-参考索引/02-能力边界/156-restoredWorkerState、externalMetadataToAppState、SessionExternalMetadata 与 RemoteIO 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/167-2026-04-08-CCR v2 metadata readback vs local consumption split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 167
- 索引层只补 156
- 记忆层只补 167

不回写 103、133、137、166。

## 下一轮候选

1. 继续拆 `StructuredIO`、`RemoteIO`、`flushInternalEvents` 与 internal-event reader：为什么 remote transport 的恢复厚度不等于同一种 runtime thickness。
2. 继续拆 `CCRClient.initialize()` 的 readback、scrub、heartbeat 与 epoch lifecycle：为什么 worker init 的“恢复成功”不是同一种存活签字。
