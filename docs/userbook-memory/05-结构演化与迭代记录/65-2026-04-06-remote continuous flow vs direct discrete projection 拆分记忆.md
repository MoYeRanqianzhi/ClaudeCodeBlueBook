# remote continuous flow vs direct discrete projection 拆分记忆

## 本轮继续深入的核心判断

第 64 页已经拆开：

- remote session 的 durable status source
- direct connect 的 local interaction source

但还缺一层很容易继续混写的对象：

- remote session 持续消费 `stream_event`
- remote session 持续消费 `task_started/task_notification`
- direct connect 主要只显示离散 transcript / overlay / stderr

如果不单独补这一批，正文会继续犯六种错：

- 把 remote session 写成只是“状态槽更多”的版本
- 把 `stream_event` 写成普通消息变种
- 把 `task_started/task_notification` 写成正文消息
- 把 direct connect 写成同样持续消费远端流
- 把两边差异继续退化成 transport 差异
- 把断线后果继续写成只是文案不同

## 苏格拉底式自审

### 问：为什么这批不能塞回第 64 页？

答：第 64 页回答的是：

- 状态来源
- 持久性
- 可复用性

而本轮问题已经换成：

- 本地究竟怎样消费远端事件

也就是：

- consumption contract

不是：

- status authority

### 问：为什么这批不能塞回第 61 页？

答：第 61 页回答的是：

- direct connect 的 message filtering / transcript surface

而本轮问题已经换成：

- remote session 的 continuous event flow vs direct connect 的 discrete projection

也就是：

- cross-mode consumption contrast

不是：

- one mode’s transcript rules

### 问：为什么这批不应写成 generic 远端流式页？

答：因为新增量不在：

- 远端所有消息类型是什么

而在：

- 当前模式如何消费它们

如果写成 generic 远端流式页，就会重新滑回：

- 事件类型总表
- 或 hook 总比较

而不是用户真正可用的消费合同边界。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/65-stream_event、task_started、task_notification 与 transcript_overlay_stderr：为什么 remote session 是持续事件流消费者，而 direct connect 只是离散交互投影.md`
- `bluebook/userbook/03-参考索引/02-能力边界/54-Remote continuous event flow vs direct-connect discrete projection 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/65-2026-04-06-remote continuous flow vs direct discrete projection 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- remote session 持续消费 `stream_event`
- remote session 用 task 事件持续维护共享计数
- direct connect 更偏离散 message / overlay / stderr sink
- 断线后 remote session 与 direct connect 的消费链后果不同
- 差别本质上是消费合同，不只是 transport

### 不应写进正文的

- 64 页 durable status authority 复述
- 61 页 direct connect transcript filtering 复述
- 57 页 hook 总比较
- 具体 stream handler / ring buffer 的实现枝节

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `stream_event` 是本批第一根骨架

如果漏掉它，正文就会继续把 remote session 写成“只是消息更多”的 direct connect。

### `task_started/task_notification` 的 event-sourced 计数是本批第二根骨架

如果漏掉它，正文就无法把：

- 持续事件流消费

和：

- 离散 message sink

稳稳区分。

### direct connect 的三类 sink 是本批第三根骨架

如果漏掉它，正文就会继续脑补：

- direct connect 也在持续消费完整远端流

## 后续继续深入时的检查问题

1. 我当前讲的是消费合同，还是又滑回状态来源？
2. 我是不是又把 `stream_event` 写成普通消息？
3. 我是不是又把 task 事件写成正文消息？
4. 我是不是又把 direct connect 写成持续流消费者？
5. 我是不是又把差异退化成 transport 差异？
6. 我是不是又把两边断线后果写成只是文案不同？

只要这六问没先答清，下一页继续深入就会重新滑回：

- 61/64 复述

而不是用户真正可用的跨模式消费合同正文。
