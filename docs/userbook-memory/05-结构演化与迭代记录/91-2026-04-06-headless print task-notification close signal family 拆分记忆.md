# headless print task-notification close signal family 拆分记忆

## 本轮继续深入的核心判断

90 已经把 `task-notification` 的 dual-consumer 语义拆出来了。

下一步最自然不是继续讲“谁来消费”，而是继续往下压到：

- 哪种信号真的关单
- 哪种只是 ping
- 哪种 terminal 路径必须 direct emit

因为真正最容易被误写成“一种完成通知”的，就是这一层。

## 为什么这轮必须把 close-signal family 单列

如果不单列，读者会把 90 的结论停在：

- `task-notification` 会同时喂给 SDK 和模型

但更深一层真正关键的事实是：

- 同样叫 `task-notification`，并不等于同样承担 close 语义
- statusless ping 和 terminal XML close 不是一类
- direct SDK close 也不是 XML close 的重复副本

## 本轮最关键的新判断

### 判断一：`<status>` 是 close gate，不是装饰字段

所以没有 `<status>` 的 statusless ping 不能给 SDK consumer 关任务。

### 判断二：direct `emitTaskTerminatedSdk(...)` 是“无 XML close 世界线”的唯一 close 路

它不是为了更保险而补发，而是因为那条终态本来就不会再经过 XML queue。

### 判断三：anti-double-emit 是这页最值钱的稳定结论

close signal 不能双发，这不是实现癖好，而是状态机约束。

## 为什么这轮不并回 90

90 讲的是：

- `task-notification` 为什么要先喂 SDK，再喂模型

91 讲的是：

- 哪种 `task-notification` 真能关单
- 哪种只是 ping
- 哪种 terminal close 必须 direct emit

主语已经换了。

## 苏格拉底式自审

### 问：为什么这轮最先该拆 `<status>`，而不是继续补更多任务来源？

答：因为 `<status>` 一旦不拆，所有来源都会被误写成同一种完成通知。

### 问：为什么 direct emit 值得成为正文主角？

答：因为它揭示了 close 语义并不统一走 XML queue，这正是最容易被写反的地方。

### 问：为什么 anti-double-emit 要反复强调？

答：因为“多发更稳”几乎是所有读者最自然的直觉，而源码明确要求相反。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/91-<status>、statusless ping、emitTaskTerminatedSdk、enqueuePendingNotification 与 double-emit：为什么 headless print 的 task-notification 不是同一种关单信号.md`
- `bluebook/userbook/03-参考索引/02-能力边界/80-Headless print task-notification close-signal family 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/91-2026-04-06-headless print task-notification close signal family 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小改动：

- 长文层只补 91
- 索引层只补 80
- 记忆层只补 91

不把 90-91 重新揉成一篇大的 task-notification 总论。

## 下一轮候选

1. 单独拆 coordinator 提示词里“看起来像 user-role message，但其实不是”的协议后果。
2. 单独拆 `task_started`、terminal `task_notification` 与 queue-side lifecycle 账本的关系。
3. 单独拆 headless `print` 与 TUI 在 background task 结果回流上的宿主差异。
