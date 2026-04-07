# websocket recovery ownership split 拆分记忆

## 本轮继续深入的核心判断

128 已经把：

- `SessionsWebSocket 4001`
- `WebSocketTransport 4001`

拆成了不同合同。

但如果继续往下不补这一页，读者还是会把：

- `headersRefreshed`
- `autoReconnect`
- sleep detection
- `4003` refresh path

重新压成一句：

- “`WebSocketTransport` 只是 `SessionsWebSocket` 的恢复增强版。”

这轮要补的更窄一句是：

- `WebSocketTransport` 的恢复主权是分层分配的，不是 `SessionsWebSocket` 的镜像

## 为什么这轮必须单列

如果不单列，正文最容易在三种错误里摇摆：

- 把 `refreshHeaders` 写成 `getAccessToken()` 的同构替身
- 把 sleep budget reset 写成 session resurrection
- 把 `onClose` 写成整个系统的最终失败，而不是 caller handoff

这三种都会把：

- auth repair
- budget repair
- caller takeover
- session / environment rebuild

重新压成同一种“恢复”。

## 本轮最关键的新判断

### 判断一：`SessionsWebSocket` 当前更像 component-owned recovery policy

### 判断二：`WebSocketTransport` 当前更像 layered recovery authority contract

### 判断三：`4003` 在 `WebSocketTransport` 里不是绝对 terminal，而是受外部 header signer 影响

### 判断四：sleep detection 只能重置 budget，不能证明原 session 仍活着

### 判断五：`onClose` 在某些 caller 里是更高层 recovery 的交棒点，不是终点

## 苏格拉底式自审

### 问：为什么这页不能并回 125？

答：125 讲 recovery action-state；129 讲 recovery owner。

### 问：为什么这页不能并回 128？

答：128 讲同一个 `4001` 的跨组件语义分裂；129 讲更广的恢复主权分布结构。

### 问：为什么一定要把 `remoteIO`、`sessionRunner`、`replBridge` 拉进来？

答：因为不把 caller 与 parent signer 拉进来，就会继续把恢复误写成 transport 单兵行为。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/129-headersRefreshed、autoReconnect、sleep detection 与 4003 refresh path：为什么 WebSocketTransport 的恢复主权不是 SessionsWebSocket 的镜像.md`
- `bluebook/userbook/03-参考索引/02-能力边界/118-headersRefreshed、autoReconnect、sleep detection 与 4003 refresh path 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/129-2026-04-07-websocket recovery ownership split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 129
- 索引层只补 118
- 记忆层只补 129

不扩目录，不回写旧页。

## 下一轮候选

1. 单独拆 `remoteSessionUrl`、brief line、bridge pill、bridge dialog 与 attached viewer，为什么它们不是同一种 surface presence。
2. 单独拆 `warning` transcript、`remoteConnectionStatus`、`remoteBackgroundTaskCount` 与 brief line，为什么它们不是同一种 remote status table。
3. 等并行 Agent 返回后，再判断是否需要把 v2 `SSETransport`、401、epoch mismatch 与 v1 `WebSocketTransport` 分成另一条恢复主权对照线。
