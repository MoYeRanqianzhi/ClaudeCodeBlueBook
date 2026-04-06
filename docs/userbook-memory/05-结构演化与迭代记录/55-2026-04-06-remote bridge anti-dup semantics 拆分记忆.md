# remote bridge anti-dup semantics 拆分记忆

## 本轮继续深入的核心判断

第 54 页已经拆开：

- transport rebuild
- initial flush
- flush gate
- sequence handoff

但还缺一层很容易继续混写的“多层防重合同”：

- `received / processing / processed`
- `lastWrittenIndexRef` / `bridgeLastForwardedIndex`
- `recentPostedUUIDs`
- `recentInboundUUIDs`
- `sentUUIDsRef`

如果不单独补这一批，正文会继续犯六种错：

- 把 delivery ACK 写成 viewer 去重
- 把 write cursor 写成 UUID echo filter
- 把 outbound echo filter 与 inbound replay guard 写成同一种 dedup
- 把 viewer 本地回显过滤写成 bridge transport dedup
- 把 `recentInboundUUIDs` 写成第 54 页的 sequence handoff 主修复
- 把共用 `BoundedUUIDSet` 容器写成同一种防重合同

## 苏格拉底式自审

### 问：为什么这批不能塞回第 54 页？

答：第 54 页回答的是：

- transport 怎样重建
- history 怎样续接
- `connected` 为什么晚于 transport ready

而本轮问题已经换成：

- transport continuity 建好之后，重复消息究竟由哪些层分别拦掉

也就是：

- anti-dup semantics after continuity

不是：

- transport continuity itself

### 问：为什么这批不能塞回第 29 页？

答：第 29 页回答的是：

- `control_request / control_response`
- 桥接权限提示与会话控制

而本轮问题已经换成：

- 同一条控制或用户消息在不同链路里如何避免重复交付或重复显示

也就是：

- delivery / dedup semantics

不是：

- control contract semantics

### 问：为什么这批不能写成“UUID Set 大全”？

答：因为真正值得写进正文的不是：

- 所有 Set 名称
- 所有 ring 容量
- 所有 hook 内部索引变量

而是：

- delivery ACK
- write cursor
- outbound echo filter
- inbound replay safety net
- viewer local echo guard

如果写成变量大全，正文会再次滑回实现目录学。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/55-received、processing、processed、lastWrittenIndexRef、recentPostedUUIDs、recentInboundUUIDs 与 sentUUIDsRef：为什么 remote bridge 的送达回执、增量转发、echo 过滤与重放防重不是同一种去重.md`
- `bluebook/userbook/03-参考索引/02-能力边界/44-Remote Control received、processed、write cursor、echo dedup 与 replay dedup 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/55-2026-04-06-remote bridge anti-dup semantics 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `received / processing / processed` 是服务端 delivery 账本
- `lastWrittenIndexRef` / `bridgeLastForwardedIndex` 是增量转发游标
- `recentPostedUUIDs` / `sentUUIDsRef` 是两种不同作用域的 echo filter
- `recentInboundUUIDs` 是 replay safety net，不是 continuity 主修复
- `BoundedUUIDSet` 是容器，不是语义

### 不应写进正文的

- ring 容量参数本身
- 每个 hook 的全部 effect 细节
- `BoundedUUIDSet` 的循环数组实现细部

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `processed` 立即补写是本批第一根骨架

没有这根骨架，就解释不通：

- 为什么 v2 replBridge 路径宁可早写 `processed`
- 也不愿让事件长时间停在 `received`

### write cursor 与 UUID ring 分层是本批第二根骨架

没有这根骨架，正文就会把：

- “从哪里开始转发”

误写成：

- “如何按 UUID 去重”

### viewer 本地 echo guard 是本批第三根骨架

没有这根骨架，正文就会把：

- bridge transport 防重
- viewer render 防重

重新压成同一层 dedup。

## 并行 agent 额外结论

- 本批之后的优先候选可转向 `control_request / control_response / control_cancel_request / result` 与 state handoff。
- 这条线比 anti-dup 更偏控制面动作合同，应作为下一批而不是并入本批。
- 另一条候选是 standalone remote-control 的显示面合同，但当前仍不如控制三元组紧邻现有远端控制面主线。

## 后续继续深入时的检查问题

1. 我当前讲的是 delivery ledger，还是 render/forward dedup？
2. 我是不是又把 cursor 写成 UUID set？
3. 我是不是又把 outbound echo 与 inbound replay 写成一种 dedup？
4. 我是不是又把 viewer 本地回显过滤写回 bridge transport？
5. 我是不是又把 `recentInboundUUIDs` 写成第 54 页主修复？
6. 我是不是又把正文滑回变量/容器目录学？

只要这六问没先答清，下一页继续深入就会重新滑回：

- delivery 与 dedup 混写
- 或实现容器污染正文

而不是用户真正可用的 remote bridge anti-dup 正文。
