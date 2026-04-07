# direct connect foreground runtime split 拆分记忆

## 本轮继续深入的核心判断

134 已经把 bridge 内部的 v1 / v2 chain depth 拆开。

下一步如果不单列 direct connect，读者还是会把它写成：

- “缺少 remote footer / bridge dialog 的另一种远端模式。”

这轮要补的更窄一句是：

- direct connect 更像 foreground remote runtime，而不是 remote presence store

## 为什么这轮必须单列

如果不单列，正文最容易在三种误写里摇摆：

- 把 direct connect 的 WebSocket transport 偷换成 remote presence ledger
- 把 transcript / loading / permission queue 的本地投影写成 dedicated remote store
- 把 terminal disconnect 误读成“只是还没做 reconnect UI”

这三种都会把：

- foreground interaction
- authoritative ledger
- persistent presence surface

重新压扁。

## 本轮最关键的新判断

### 判断一：`createDirectConnectSession()` 当前给的是薄 transport config，不是 remote presence contract

### 判断二：`useDirectConnect()` 当前只消费 transcript、loading、permission queue，没有 `AppState` authoritative 写路径

### 判断三：`DirectConnectSessionManager` + `sdkMessageAdapter` 体现的是 filtered wire -> transcript projection，不是 raw wire -> shared store

### 判断四：footer、dialog、`/session` 都依赖 `remoteSessionUrl` 或 `replBridge*`，而 direct connect 根本没有把自己提升到这些账本

### 判断五：terminal disconnect 不是一个缺失的 UI 细节，而是当前产品边界的一部分

## 苏格拉底式自审

### 问：为什么不能只说 direct connect “更薄”？

答：因为“更薄”没有说清是 UI 薄、合同薄、还是 ledger 薄；这一页补的是合同和 ledger 的边界。

### 问：为什么一定要把 `/session`、footer、bridge dialog 一起拉进来？

答：因为它们能证明 repo 里的 dedicated remote surface 都需要 authoritative 字段前提，而 direct connect 当前没有。

### 问：为什么一定要写 terminal disconnect？

答：因为只要断线语义还是 `gracefulShutdown(1)`，它就更像 foreground runtime end，而不是可被管理的 remote presence。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/135-createDirectConnectSession、DirectConnectSessionManager、useDirectConnect、remoteSessionUrl 与 replBridgeConnected：为什么 direct connect 更像 foreground remote runtime，而不是 remote presence store.md`
- `bluebook/userbook/03-参考索引/02-能力边界/124-createDirectConnectSession、DirectConnectSessionManager、useDirectConnect、remoteSessionUrl 与 replBridgeConnected 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/135-2026-04-07-direct connect foreground runtime split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 135
- 索引层只补 124
- 记忆层只补 135

不扩目录，不回写旧页。

## 下一轮候选

1. 单独拆 `pending_action.input`、`task_summary`、`post_turn_summary` 为什么更像跨前端 consumer path，而不是当前 CLI foreground consumer。
2. 单独拆 mirror / outboundOnly / env-less 为什么会让 bridge 即使同属 v2，也不是同一种活跃 front-state surface。
3. 单独拆 direct connect 与 ssh remote 虽然共用 `activeRemote` 壳，却为什么不自动推出同一种远端存在账本。
