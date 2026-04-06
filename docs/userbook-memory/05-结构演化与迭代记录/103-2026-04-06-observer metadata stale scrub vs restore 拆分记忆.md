# observer metadata stale scrub vs restore 拆分记忆

## 本轮继续深入的核心判断

52 已经把 durable parameter 的 writeback / restore 差异拆开了。

但如果停在那里，读者还是会继续误判：

- 既然 `pending_action` / `task_summary` 也在 `external_metadata` 里，为什么不一起恢复？

这一层真正缺的是：

- observer metadata 与 durable restore input 为什么不是同一种恢复面

## 为什么这轮必须单列

如果不单列，正文会自然滑成：

- “metadata 里有的 key，要么都能恢复，要么都不能恢复”

源码真正给出的设计更细：

- durable config 窄恢复
- observer metadata crash scrub
- transcript/internal events 另走一条恢复通道

这已经不是 52 那页能顺手带过的小注脚。

## 本轮最关键的新判断

### 判断一：`SessionExternalMetadata` 是 bag，不是对称恢复契约

这是这轮最需要钉死的根句。

### 判断二：`pending_action` / `task_summary` 的恢复合同是 stale scrub first

worker startup 主动写 `null` 是这轮最硬的证据。

### 判断三：`GET /worker` 的 readback 不等于 local restore adoption

源码会先读回 prior metadata，再选择性恢复，二者不能混写。

### 判断四：transcript/internal events resume 必须从 metadata restore 里剥离出来

否则所有“恢复”都会被误写成一条通路。

## 苏格拉底式自审

### 问：为什么这轮不能并回 52？

答：因为 52 的主语是 durable parameter restore；103 的主语是 observer metadata 为什么不享有同一种恢复待遇。

### 问：为什么 startup scrub 值得进正文，而不是留在实现细节？

答：因为它直接决定用户会不会在新 worker 上看到假阻塞、假进度，这就是可见后果。

### 问：为什么要强调 transcript/internal events 是另一条恢复通道？

答：因为很多误写都来自把“恢复历史内容”和“恢复 metadata key”当成同一个动作。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/103-pending_action、task_summary、externalMetadataToAppState、state restore 与 stale scrub：为什么 CCR 的 observer metadata 不是同一种恢复面.md`
- `bluebook/userbook/03-参考索引/02-能力边界/92-Observer metadata stale scrub vs restore 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/103-2026-04-06-observer metadata stale scrub vs restore 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 103
- 索引层只补 92
- 记忆层只补 103

不把它并回 51，也不把它并回 52。

## 下一轮候选

1. 单独拆 `post_turn_summary` 的 stdout-vs-SDKMessage split 为什么不等于“完全不可见”。
2. 单独拆 suggestionState 的 `pendingLastEmittedEntry` 在部分 cleanup 分支里为什么会留下 internal stale staging。
3. 单独拆 `model` 为什么在 metadata restore 里属于 separate override，而不是 `externalMetadataToAppState(...)` 的对称逆映射。
