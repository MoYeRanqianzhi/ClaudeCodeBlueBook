# CCR v2 remote bridge transport continuity 拆分记忆

## 本轮继续深入的核心判断

第 44 页已经拆开：

- refresh scheduler 的时间语义
- v1 child sync
- v2 refresh strategy

第 47 页已经拆开：

- reconnecting / give up / sleep reset

第 50 页已经拆开：

- CCR v2 worker 的生命周期合同

但还缺一层很容易继续混写的“v2 transport continuity”：

- `rebuildTransport(...)`
- `FlushGate`
- `initialSequenceNum`
- `connected` after initial flush
- recovery 期间的 selective drop

如果不单独补这一批，正文会继续犯六种错：

- 把 proactive refresh 与 401 recovery 写成正文主线，而不是把它们当 replacement 入口
- 把 JWT refresh 写成 header hot-swap
- 把 transport rebuild 写成 replay from zero
- 把 flush gate 写成 generic retry queue
- 把普通消息 queue 与 control/result drop 写成一种恢复策略
- 把第 47 页的 reconnect budget 重新污染到第 54 页的 auth handoff

## 苏格拉底式自审

### 问：为什么这批不能塞回第 44 页？

答：第 44 页回答的是：

- refresh 什么时候触发
- v1 child 怎样吃到新 token
- v2 为什么不做 child sync

而本轮问题已经换成：

- refresh 之后，v2 transport 怎样带着新 epoch 接棒
- 怎样保证不 replay 全流、不静默丢写、不让旧控制面污染新链路

也就是：

- transport continuity after auth refresh

不是：

- refresh scheduling and delivery strategy

### 问：为什么这批不能塞回第 47 页？

答：第 47 页回答的是：

- reconnecting 状态词
- poll / heartbeat 节奏
- give up 预算

而本轮问题已经换成：

- 401 触发 auth recovery 后，transport 怎样 rebuild
- 为什么这不是简单 backoff

也就是：

- auth handoff semantics

不是：

- retry budget semantics

### 问：为什么这批不能塞回第 50 页？

答：第 50 页回答的是：

- worker register / restore / heartbeat / self-exit

而本轮问题已经换成：

- remote bridge 自己怎样从旧 transport 切到新 transport

也就是：

- bridge-side transport handoff

不是：

- worker lifecycle

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/54-transport rebuild、initial flush、flush gate 与 sequence resume：为什么 CCR v2 remote bridge 的重建 transport、历史续接与 connected 不是同一步.md`
- `bluebook/userbook/03-参考索引/02-能力边界/43-Remote Control transport rebuild、initial flush、flush gate 与 sequence resume 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/54-2026-04-06-CCR v2 remote bridge transport continuity 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- proactive refresh 与 401 recovery 只是 replacement trigger，不是正文主轴
- `/bridge` bump epoch 之后为什么必须 rebuild transport
- `initialSequenceNum` 为什么不是 replay from zero
- `FlushGate` 为什么是顺序边界，不是普通 retry queue
- 为什么 `connected` 晚于 transport ready
- recovery 期间普通消息 queue 与 control/result drop 的对象差异

### 不应写进正文的

- `authRecoveryInFlight` 的全部状态机细节
- `connectDeadline`
- `recentPostedUUIDs`
- 全部 close code 与 uploader 细枝末节

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `/bridge` bump epoch 是本批第一根骨架

没有这根骨架，就解释不通：

- 为什么 JWT refresh 不是热换 header
- 为什么必须 rebuild transport

### `sequence resume` 是本批第二根骨架

没有这根骨架，正文就会把：

- “换了 transport”

误写成：

- “整段 history 重播”

### `FlushGate` 与 selective drop 是本批第三根骨架

没有这根骨架，正文就会把：

- 普通消息 queue
- control / result drop

写成一种统一恢复策略。

## 后续继续深入时的检查问题

1. 我当前讲的是 refresh timing，还是 refresh 后的 transport continuity？
2. 我是不是又把 reconnect budget 写回 auth handoff？
3. 我是不是又把 JWT refresh 写成了 header hot-swap？
4. 我是不是又把 flush gate 写成 generic retry queue？
5. 我是不是又把所有 recovery 期间写入都写成“应补发”？
6. 我是不是又把正文滑回 `remoteBridgeCore.ts` 状态机目录学？

只要这六问没先答清，下一页继续深入就会重新滑回：

- reconnect / refresh / rebuild 混写
- 或 transport 内部状态机污染正文

而不是用户真正可用的 CCR v2 remote bridge 恢复语义正文。
