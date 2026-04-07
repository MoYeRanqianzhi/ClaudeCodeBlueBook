# permission verdict ledger split 拆分记忆

## 本轮继续深入的核心判断

193 已经拆开：

- control side-channel 的 permission verdict 返回腿

但 permission leg 内部还缺一句更细的判断：

- `pendingPermissionHandlers` 不是 generic callback registry，而是本地 pending verdict ledger

本轮要补的更窄一句是：

- `request_id`、`pendingPermissionHandlers`、`handlePermissionResponse(...)` 与 `isBridgePermissionResponse(...)` 共同定义了一张 bridge permission race 的本地 verdict ledger

## 为什么这轮必须单列

如果不单列，正文最容易在四种偷换里回卷：

- 把 `pendingPermissionHandlers` 写成 generic registry
- 把 `request_id` 写成通用 control correlation id
- 把 `handlePermissionResponse(...)` 写成通用 dispatcher
- 把 `BridgePermissionResponse` 的 payload gate 忽略掉

这四种都会把：

- transport frame
- race ownership
- local ledger

重新压扁。

## 本轮最关键的新判断

### 判断一：`BridgePermissionCallbacks` 是 permission-race-specific RPC-like surface

### 判断二：`pendingPermissionHandlers` 是挂起 verdict 的本地 ledger，不是 durable registry

### 判断三：`handlePermissionResponse(...)` 是 ledger drain 点，不是 generic dispatcher

### 判断四：`isBridgePermissionResponse(...)` 把 payload ownership 再次收窄到 permission verdict

## 苏格拉底式自审

### 问：为什么这页不是 29 的附录？

答：29 讲 control 对象家族；196 讲 permission leg 内部的本地 ownership。

### 问：为什么这页不是 193 的附录？

答：193 讲 callback 腿为什么不对称；196 讲 permission 这条腿内部为什么还有本地 pending ledger。

### 问：为什么 `request_id` 在这里不能直接写成 generic control key？

答：因为这页的 `request_id` 只在 permission race 的 request / verdict 配对里有主语，不负责所有 control frame 的 ownership。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/196-pendingPermissionHandlers、BridgePermissionCallbacks、request_id、handlePermissionResponse 与 isBridgePermissionResponse：为什么 bridge permission race 的 verdict ledger 不是 generic control callback ownership.md`
- `bluebook/userbook/03-参考索引/02-能力边界/185-pendingPermissionHandlers、BridgePermissionCallbacks、request_id、handlePermissionResponse 与 isBridgePermissionResponse 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/196-2026-04-08-permission verdict ledger split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 196
- 索引层只补 185
- 记忆层只补 196

不回写 29、193。

## 下一轮候选

1. 若切回结构层，可把 191-196 收束成 ingress 阅读簇导航，而不是继续扩正文。
2. 若继续 transcript 面，可看 webhook sanitize 与 attachment materialization 是否值得再拆，但必须避免把 195 切成纯实现噪音。
3. 若继续 permission 面，可看 cancelRequest / unsubscribe / queue recheck 的 race 收口是否值得单列，但必须避免回卷 generic registry。
