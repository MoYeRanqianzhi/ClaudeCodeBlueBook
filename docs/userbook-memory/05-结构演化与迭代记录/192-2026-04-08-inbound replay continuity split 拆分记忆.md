# inbound replay continuity split 拆分记忆

## 本轮继续深入的核心判断

191 已经拆开：

- shared ingress reader 内部的 consumer split

但 bridge 读侧还缺一条更外层的句子：

- replay state 的生命周期不跟 transport 实例走，而跟 session continuity 走

本轮要补的更窄一句是：

- `lastTransportSequenceNum` 与 `recentInboundUUIDs` 在同一个 bridge 实例里的 same-session continuity 下应保留，在 fresh-session reset 下必须一起归零，而 bridge re-init 并不会恢复 `recentInboundUUIDs`

## 为什么这轮必须单列

如果不单列，正文最容易在四种偷换里回卷：

- 把 transport rebuild 和 session swap 写成同一种 reconnect
- 把 `lastTransportSequenceNum` 和 `recentInboundUUIDs` 写成同一种 replay 账
- 把 v2 的“不清空”写成“没有这层状态”
- 把 189 的 history flush 与 191 的 consumer split 重新拼回来

这四种都会把：

- continuity boundary
- replay lifetime
- reader consumer split

重新压扁。

## 本轮最关键的新判断

### 判断一：`tryReconnectInPlace(...)` / `rebuildTransport(...)` 属于 same-session continuity，不属于 reset

### 判断二：`lastTransportSequenceNum` 是主游标，`recentInboundUUIDs` 是 replay safety net，但二者共享 session 边界

### 判断三：v1 一旦 `createSession(...)` 落成 fresh-session，就必须立刻清零这两层 state

### 判断四：v2 rebuild 不清空不是遗漏，而是因为 `sessionId` 不变、read-side continuity 延续

### 判断五：`recentInboundUUIDs` 不是 durable ledger，perpetual resume / crash recovery 也不会把它种回来

## 苏格拉底式自审

### 问：为什么这页不是 189 的附录？

答：189 讲 server 是否已持有历史、初始 flush 应否重发；192 讲 live ingress continuity state 是否还能继续描述同一个 inbound stream。

### 问：为什么这页不是 191 的附录？

答：191 讲 reader 收到一帧后怎么分流；192 讲 reader 外部那套 replay state 何时保留、何时清零。

### 问：为什么不能把“transport 换了”当成统一的 reset 触发器？

答：因为真正决定 replay continuity 的不是 transport 实例，而是 session 身份有没有变。

### 问：为什么 same-session resume 也不等于恢复 `recentInboundUUIDs`？

答：因为这张账的边界比 session id 更窄，它属于当前 bridge 实例里的 ingress guard，而不是可持久化 replay ledger。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/192-lastTransportSequenceNum、recentInboundUUIDs、tryReconnectInPlace、createSession 与 rebuildTransport：为什么 same-session continuity 与 fresh-session reset 不是同一种 inbound replay contract.md`
- `bluebook/userbook/03-参考索引/02-能力边界/181-lastTransportSequenceNum、recentInboundUUIDs、tryReconnectInPlace、createSession 与 rebuildTransport 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/192-2026-04-08-inbound replay continuity split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 192
- 索引层只补 181
- 记忆层只补 192

不回写 189、191。

## 下一轮候选

1. 若继续 bridge 线，可看 control side-channel 的 callback ownership 是否能独立成页，但必须避免回卷 29 与 191。
2. 若继续 replay 线，可看 `lastTransportSequenceNum` 的 carryover 与 transport close snapshot 是否值得单列，但必须避免写成纯实现注释页。
3. 若继续 ingress 面，可看 user-only transcript adapter 与 non-user `SDKMessage` 无第二消费面的边界，但必须避免重写 191 的 non-user ignore 判断。
