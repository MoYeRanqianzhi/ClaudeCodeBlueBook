# remote same event different consumers 拆分记忆

## 本轮继续深入的核心判断

第 64 页已经拆开：

- durable status authority
- local interaction authority

第 65 页已经拆开：

- continuous event flow
- discrete projection

但还缺一层 remote session 内部很容易继续混写的对象：

- streaming consumer
- counter consumer
- warning consumer
- mode consumer
- transcript event consumer
- internal control consumer

如果不单独补这一批，正文会继续犯六种错：

- 把同一事件写成在所有 UI 面同厚度出现
- 把 `stream_event` 写成 footer/idle 也该消费
- 把 task 事件写成正文事件
- 把 `Status: compacting` 写成完整 compaction 状态
- 把 `remote` pill 写成连接 warning
- 把“某面不可见”写成“事件没到本地”

## 苏格拉底式自审

### 问：为什么这批不能塞回第 51 页？

答：第 51 页回答的是：

- 远端有哪些 runtime event / state carrier

而本轮问题已经换成：

- 同一事件如何被不同消费者以不同厚度消费

也就是：

- consumer projection thickness

不是：

- event family taxonomy

### 问：为什么这批不能塞回第 64 / 65 页？

答：64 回答的是：

- 状态来源差异

65 回答的是：

- continuous flow vs discrete projection

而本轮问题已经换成：

- remote session 内部不同消费者如何分工

也就是：

- one mode, many consumers

不是：

- cross-mode contrast

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/66-stream_event、task_started、status、remote pill 与 BriefIdleStatus：为什么同一 remote session 事件不会以同样厚度出现在每个消费者里.md`
- `bluebook/userbook/03-参考索引/02-能力边界/55-Remote same event different consumers 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/66-2026-04-06-remote same event different consumers 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `stream_event` 主要服务 streaming consumer
- task 事件主要服务后台计数
- `remoteConnectionStatus` 主要服务 warning consumer
- `remoteSessionUrl` 主要服务 mode consumer
- `status=compacting` 同时有 transcript 与 internal control 两层投影

### 不应写进正文的

- 51 页事件类型复述
- 64/65 页跨模式对照复述
- 过细的 handler 内部实现枝节
- generic “一个事件到处都能看到”式误导

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### consumer thickness 是本批第一根骨架

如果漏掉它，正文就会继续把所有 UI 面当成同一张复制品。

### `status=compacting` 的双层消费是本批第二根骨架

如果漏掉它，正文会继续把 transcript event 和 internal control 语义压成一层。

### `remote` pill 的模式标记身份是本批第三根骨架

如果漏掉它，正文就会继续把模式标记与 warning 混成一类。

## 后续继续深入时的检查问题

1. 我当前讲的是 consumer 分工，还是又滑回事件类型总表？
2. 我是不是又把 `stream_event` 写成所有 UI 都该消费？
3. 我是不是又把 task 事件写成正文消息？
4. 我是不是又把 mode pill 写成 warning？
5. 我是不是又把不可见写成事件没到？
6. 我是不是又把投影厚度写平了？

只要这六问没先答清，下一页继续深入就会重新滑回：

- 51/64/65 复述

而不是 remote session 内部 consumer 正文。
