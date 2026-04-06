# task result return path split 拆分记忆

## 本轮继续深入的核心判断

94 已经把 `task_progress/workflow_progress` 压回宿主投影层了。

下一步最自然不是继续讲 progress，而是继续往下压到：

- 为什么 task result 本身会分叉成 XML re-entry 路
- 和 direct SDK close 路

因为这正好把 90-94 这几页里分散出现的“谁负责 close / 谁会进模型回合”收成一条更窄的 runtime 问题。

## 为什么这轮必须把 return-path split 单列

如果不单列，读者会把 90-94 的结论停在：

- 有模型层、有宿主层、有 close-signal family

但更深一层真正关键的事实是：

- 同一份结果并不会天然沿着一条统一管线回流
- 当前是不是 foreground、是不是 suppress XML，直接决定回流路径

## 本轮最关键的新判断

### 判断一：决定回流路径的主问题是“还要不要回到模型回合”

这比任务类型名字更关键。

### 判断二：`LocalMainSessionTask` 是最值钱的正例

因为它在同一家族内部同时暴露了 background XML 路和 foreground direct SDK 路。

### 判断三：direct SDK close 不是补发版 XML，而是某些路径上的唯一 close 通道

这句必须钉死。

### 判断四：anti-double-emit 在这里仍然是守门规则

多路径一出现，最容易被误写成“两条都走更保险”。

## 为什么这轮不并回 90-91

90 讲 dual-consumer。
91 讲 close-signal family。
95 讲 return-path split。

主语再次变窄，不该揉回去。

## 苏格拉底式自审

### 问：为什么这轮最先该拆 foreground/background，而不是继续列任务类型？

答：因为分叉主因是“结果还要不要回到模型回合”，而不是类名。

### 问：为什么 `LocalMainSessionTask` 值得成为正文核心例子？

答：因为它在同一任务家族内清楚地展示了两条不同 return path。

### 问：为什么还要再次写 anti-double-emit？

答：因为一旦开始讲多路径，读者天然会想把它们叠成双保险；源码的答案恰好相反。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/95-enqueuePendingNotification、emitTaskTerminatedSdk、print.ts parser、No continue 与 foreground done：为什么 headless print 的任务结果不会走同一条回流路径.md`
- `bluebook/userbook/03-参考索引/02-能力边界/84-Task result return-path split 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/95-2026-04-06-task result return path split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小改动：

- 长文层只补 95
- 索引层只补 84
- 记忆层只补 95

不把 90-95 重新揉成一篇大的 task return-system 总论。

## 下一轮候选

1. 单独拆 `drainSdkEvents()` 在 do-while、finally、heldBackResult 周围的多次冲刷排序。
2. 单独拆 foreground direct SDK `task_notification` 与 remote/viewer 面板的契约。
3. 单独拆 XML re-entry 路里 `<task-notification>` 为什么既喂 SDK，又喂模型。
