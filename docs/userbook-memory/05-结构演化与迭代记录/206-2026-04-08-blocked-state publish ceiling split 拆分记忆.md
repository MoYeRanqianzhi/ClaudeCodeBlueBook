# blocked-state publish ceiling split 拆分记忆

## 本轮继续深入的核心判断

203 已经拆开了 verdict 之后的 tail，

但 verdict 之前还有一层更容易被误写的对象：

- `can_use_tool`
- `requires_action_details`
- `pending_action`
- bridge `reportState('requires_action')`

本轮要补的更窄一句是：

- `can_use_tool` 只是 ask transport，只有 `stdio -> onPermissionPrompt -> notifySessionStateChanged` 才会上升成 blocked-state 双轨投影；bridge 则只发布裸 blocked bit

## 为什么这轮必须单列

如果不单列，正文最容易在四种偷换里回卷：

- 把所有 `can_use_tool` 都写成完整 blocked session
- 把 `requires_action_details` 与 `pending_action` 写成一张面
- 把 worker-side metadata existence 写成 foreground consumer 已接上
- 把 bridge 的 `reportState('requires_action')` 写成完整 pending context 发布

这四种都会把：

- transport ask
- blocked projection
- worker metadata
- publish ceiling

重新压扁。

## 本轮最关键的新判断

### 判断一：blocked-state 升级只在 `stdio` permission host path 上成立

### 判断二：`requires_action_details` 是 typed 窄投影，`pending_action` 是 queryable JSON 镜像

### 判断三：`externalMetadataToAppState(...)` 当前不恢复 `pending_action`

### 判断四：bridge 线的 transport contract 天生只签 state bit，不签 details

### 判断五：sandbox network synthetic `can_use_tool` 不能被误写成同一条 blocked-state 升级链

## 苏格拉底式自审

### 问：为什么这页不是 51 的附录？

答：51 讲远端运行态的多张面；206 讲 ask 如何升级成 blocked-state，以及 bridge 发布上限。

### 问：为什么这页不是 133 的附录？

答：133 讲 store/consumer 断裂；206 讲 producer/publish 断裂。

### 问：为什么这页不是 203 的附录？

答：203 从 verdict ledger 之后分叉；206 还在 verdict 之前，先拆 blocked-state promotion。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/206-StructuredIO、sessionState、remoteBridgeCore、pending_action、requires_action_details 与 reportState：为什么 can_use_tool 不等于 requires_action-pending_action，而 bridge blocked-state publish 只签裸 blocked bit.md`
- `bluebook/userbook/03-参考索引/02-能力边界/193-StructuredIO、sessionState、remoteBridgeCore、pending_action、requires_action_details 与 reportState 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/206-2026-04-08-blocked-state publish ceiling split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 206
- 索引层只补 193
- 记忆层只补 206

不回写 51、133、203。

## 下一轮候选

1. 若继续 blocked-state 线，可把 `requires_action/pending_action` 再投影成一个用户问题层专题页。
2. 若继续 remote 线，可把 `204` 的 remote surface 分叉进一步投影到 `04-专题深潜`。
3. 若继续 headless / print 线，可把 `post_turn_summary`、`task_summary` 与 foreground narrowing 再做一张更高层结构页。
