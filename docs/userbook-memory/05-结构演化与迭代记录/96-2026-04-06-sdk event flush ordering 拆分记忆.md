# sdk event flush ordering 拆分记忆

## 本轮继续深入的核心判断

95 已经把 task result return-path split 拆出来了。

下一步最自然不是继续扩写任务路径，而是继续往下压到：

- `drainSdkEvents()` 为什么会在 `print.ts` 里多次出现
- 而且每次都站在不同的时序位置上

因为这正是最容易被误写成“顺手清缓存”的地方。

## 为什么这轮必须把 flush ordering 单列

如果不单列，读者会把 93-95 的结论停在：

- 有 SDK 事件流
- 有 result 层
- 有 return path

但更深一层真正关键的事实是：

- 这些对象不仅分层，还被刻意按顺序冲刷
- `drainSdkEvents()` 本身就是一套时序护栏

## 本轮最关键的新判断

### 判断一：do-while 顶部的 drain 是 pre-queue flush gate

它的主任务是让 start/progress 先于 queued result layer 落流。

### 判断二：mid-turn 的两次 drain 是 pre-result / real-time progress gate

它们的主任务都不是“清队列”，而是“不让 result 或普通消息把 SDK 进展拖后”。

### 判断三：finally drain 是 idle/bookend gate

这层最容易被误写成无意义收尾，但其实最关键。

### 判断四：`heldBackResult` 和 `lastMessage` 过滤让这页变得必要

一个保证 result 可以被压后，
一个保证 SDK events 不会篡位，
两者合起来才把 flush ordering 变成正式合同。

## 为什么这轮不并回 93-95

93 讲 triad vs queue lifecycle。
94 讲 progress projection。
95 讲 return-path split。
96 讲 flush ordering contract。

主语再次变窄，不该揉回去。

## 苏格拉底式自审

### 问：为什么这轮最先该拆 finally drain？

答：因为 finally 那次最像“顺手清缓存”，也最容易让真正的 idle/bookend 时序合同被忽略。

### 问：为什么 `heldBackResult` 值得和 flush 写在同一页？

答：因为一旦 result 可以被压后，SDK 事件的先后顺序就不再是体验优化，而是状态一致性的一部分。

### 问：为什么 `lastMessage` 过滤能作为本页证据？

答：因为它证明系统在追求的是“及时但不篡位”的事件落流，而不是简单多发。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/96-drainSdkEvents、heldBackResult、task_started、task_progress、session_state_changed(idle) 与 finally_post_flush：为什么 headless print 的 SDK event flush 不是一次普通 drain.md`
- `bluebook/userbook/03-参考索引/02-能力边界/85-Headless print SDK event flush ordering 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/96-2026-04-06-sdk event flush ordering 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小改动：

- 长文层只补 96
- 索引层只补 85
- 记忆层只补 96

不把 93-96 重新揉成一篇大的 SDK event runtime 总论。

## 下一轮候选

1. 单独拆 `session_state_changed(idle)` 为什么必须晚于 heldBackResult 和 bg-agent do-while。
2. 单独拆 `lastMessage` 过滤为什么要把 late-drained `task_notification` / `task_progress` / `session_state_changed` 排除在主结果之外。
3. 单独拆 `drainSdkEvents()` 与 bridge/remote host 的存活和可见性关系。
