# user-only transcript adapter split 拆分记忆

## 本轮继续深入的核心判断

191 已经拆开：

- non-user ignore 不是 dedup 特例

193 又拆开：

- control side-channel 不是对称总线

但 bridge ingress 还缺一句更正面的判断：

- 这条链真正兑现的不是通用 `SDKMessage` consumer，而是单一 user-only transcript adapter

本轮要补的更窄一句是：

- `handleIngressMessage(...) -> onInboundMessage -> extractInboundMessageFields(...) -> enqueue(prompt)` 才是这条链的真实主语，non-user `SDKMessage` 在这里没有第二消费面

## 为什么这轮必须单列

如果不单列，正文最容易在四种偷换里回卷：

- 把 `SDKMessage` 宽类型写成通用 consumer 面
- 把 non-user ignore 写成“暂时没处理”
- 把 `extractInboundMessageFields(...)` 当成可有可无的小工具
- 把 hook / print 的前处理差异误写成两套不同 inbound 语义

这四种都会把：

- transcript adapter
- prompt sink
- control bypass

重新压扁。

## 本轮最关键的新判断

### 判断一：ingress 上只有 control 旁路和 user transcript adapter，没有第四条 non-user `SDKMessage` 消费面

### 判断二：`onInboundMessage` 不是通用 SDK consumer，而是 user leg 的 callback slot

### 判断三：`extractInboundMessageFields(...)` 是第二道 narrowing，不是实现噪音

### 判断四：hook / print 共享同一个 `enqueue(prompt)` sink，只是前处理厚度不同

## 苏格拉底式自审

### 问：为什么这页不是 56 的附录？

答：56 讲 phase handoff；194 讲 transcript consumer 形状。

### 问：为什么这页不是 191 的附录？

答：191 是负判断，说明 non-user ignore 不是 dedup；194 是正判断，说明这里只有 user-only transcript adapter。

### 问：为什么 attachment resolve 不能算第二消费面？

答：因为它只是把 user payload 改写得更适合 prompt sink，没把消息送去别的 consumer。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/194-handleIngressMessage、control_response-control_request、extractInboundMessageFields 与 enqueue(prompt)：为什么 bridge ingress 只有 control 旁路和 user-only transcript adapter，non-user SDKMessage 没有第二消费面.md`
- `bluebook/userbook/03-参考索引/02-能力边界/183-handleIngressMessage、control_response-control_request、extractInboundMessageFields 与 enqueue(prompt) 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/194-2026-04-08-user-only transcript adapter split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 194
- 索引层只补 183
- 记忆层只补 194

不回写 56、142、191、193。

## 下一轮候选

1. 若继续 transcript 面，可看 attachment normalization / path-ref prepend 是否值得单列，但必须避免重写 user-only adapter 主句。
2. 若继续 permission 面，可看 `pendingPermissionHandlers` 的 request ownership 与竞态边界，但必须避免回卷 29 与 193。
3. 若切回结构层，可把 191-194 收束成 ingress 阅读簇导航，而不是继续扩正文。
