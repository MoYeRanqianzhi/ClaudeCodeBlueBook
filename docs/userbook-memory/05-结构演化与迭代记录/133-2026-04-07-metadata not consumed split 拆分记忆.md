# metadata not consumed split 拆分记忆

## 本轮继续深入的核心判断

132 已经把三条链路的 front-state consumer topology 拆出来了。

但如果继续往下不补这一页，读者还是会把：

- `pending_action`
- `post_turn_summary`
- `task_summary`

压成一句：

- “既然 schema/store 里已经有这些账，CLI 前台只是还没把它们画出来。”

这轮要补的更窄一句是：

- schema/store 里有账，不等于当前前台已经消费

## 为什么这轮必须单列

如果不单列，正文最容易在三种错误里摇摆：

- 把 schema/type contract 写成 current CLI contract
- 把 worker-side store 写成 local AppState restore
- 把 restore path 写成 foreground consumer

这三种都会把：

- definition
- persistence
- restore
- render consumer

重新压扁。

## 本轮最关键的新判断

### 判断一：`SessionExternalMetadata` 是正式账本定义，不是前台消费清单

### 判断二：`pending_action/task_summary` 当前确实会进入 worker-side store

### 判断三：`externalMetadataToAppState()` 当前只恢复极少数 key

### 判断四：`post_turn_summary` 当前不是“无 consumer”，而是多条前台链路已显式过滤 / 忽略

### 判断五：全仓对 `task_summary` 的命中几乎只有定义、清空与 store 初始化，没有明确 CLI foreground consumer

## 苏格拉底式自审

### 问：为什么这页不能并回 132？

答：132 讲三链路 consumer topology；133 讲字段级 producer/store/restore/consumer split。

### 问：为什么一定要把 `externalMetadataToAppState()` 单独拉出来？

答：因为没有它，很容易把 “metadata 已读回” 错写成 “这些字段本地可用”。

### 问：为什么 `post_turn_summary` 也要纳入这一页？

答：因为它说明 producer/schema 存在，不等于 foreground consumer 存在；而且这里还是“显式过滤”，不是“暂未实现”的模糊地带。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/133-pending_action、post_turn_summary、task_summary 与 externalMetadataToAppState：为什么 schema-store 里有账，不等于当前前台已经消费.md`
- `bluebook/userbook/03-参考索引/02-能力边界/122-pending_action、post_turn_summary、task_summary 与 externalMetadataToAppState 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/133-2026-04-07-metadata not consumed split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 133
- 索引层只补 122
- 记忆层只补 133

不扩目录，不回写旧页。

## 下一轮候选

1. 单独拆 bridge v1 / v2 在 front-state consumer 上的能力分叉，为什么“bridge”不是统一的一条状态消费链。
2. 单独拆 direct connect 为什么更像 transcript+permission queue 驱动的交互壳，而不是 remote viewer / bridge 那样的显式远端状态面。
3. 单独拆 `pending_action.input` 注释里提到的 frontend consumer 与当前 CLI 实现之间的边界，避免把跨前端语义误写成 CLI 语义。
