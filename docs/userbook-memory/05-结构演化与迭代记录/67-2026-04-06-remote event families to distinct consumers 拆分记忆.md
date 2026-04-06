# remote event families to distinct consumers 拆分记忆

## 本轮继续深入的核心判断

第 66 页已经拆开：

- 同一 remote 事件在不同消费者里的厚度差

但还缺一层更源头的划分：

- 哪类 remote 事件本来就该喂命令集
- 哪类本来就该喂流式正文
- 哪类本来就该喂后台计数
- 哪类本来就该喂 timeout / compaction 控制

如果不单独补这一批，正文会继续犯六种错：

- 把 `slash_commands` 写成纯初始化文案
- 把 `stream_event` 写成普通消息变种
- 把 `task_*` 写成后台提示消息
- 把 `compacting` 只写成 transcript 提示
- 把所有 remote 事件都写成“给用户看的东西”
- 低估把事件喂错消费者的后果

## 苏格拉底式自审

### 问：为什么这批不能塞回第 66 页？

答：第 66 页回答的是：

- 同一事件如何被不同消费者以不同厚度消费

而本轮问题已经换成：

- 哪类事件从一开始就该喂给哪种消费者

也就是：

- event-family to consumer mapping

不是：

- same-event multi-consumer projection

### 问：为什么这批不能塞回第 51 页？

答：第 51 页回答的是：

- 远端有哪些 runtime event / state carrier

而本轮问题已经换成：

- 这些 carrier 进入本地后该落到哪条控制链

也就是：

- local consumer routing

不是：

- event taxonomy

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/67-slash_commands、stream_event、task_started 与 status_compacting：为什么 remote session 的命令集、流式正文、后台计数与 timeout 策略不是同一种消费者.md`
- `bluebook/userbook/03-参考索引/02-能力边界/56-Remote slash_commands、stream_event、task_* 与 compacting consumer 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/67-2026-04-06-remote event families to distinct consumers 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `slash_commands` -> command set gate
- `stream_event` -> streaming transcript
- `task_*` -> background count
- `status=compacting` -> transcript hint + timeout policy
- 喂错消费者的四类后果

### 不应写进正文的

- 66 页消费者厚度复述
- 64/65 页跨模式复述
- 过细的 timeout 常量与 ring buffer 实现
- generic “远端事件总表”

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `slash_commands` 是本批第一根骨架

如果漏掉它，正文就会继续把 init 误写成只服务 transcript 的提示消息。

### `compacting` 的双重落点是本批第二根骨架

如果漏掉它，正文就无法说明：

- 为什么一条 `Status: compacting`

背后还在改 timeout policy。

### “喂错消费者的后果”是本批第三根骨架

如果漏掉它，正文就会继续把这些差异当成实现小节，而不是合同差异。

## 后续继续深入时的检查问题

1. 我当前讲的是 event-family mapping，还是又滑回 consumer thickness？
2. 我是不是又把 `slash_commands` 写成纯文案？
3. 我是不是又把 `task_*` 写成后台提示消息？
4. 我是不是又把 `stream_event` 写成普通消息变种？
5. 我是不是又把 `compacting` 的双重落点写成一层？
6. 我是不是又把这些差异说轻成“只是实现细节”？

只要这六问没先答清，下一页继续深入就会重新滑回：

- 51/66 复述

而不是 remote session 事件到消费者映射正文。
