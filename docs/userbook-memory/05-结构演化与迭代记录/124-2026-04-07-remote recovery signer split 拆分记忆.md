# remote recovery signer split 拆分记忆

## 本轮继续深入的核心判断

122 已经把 recovery lifecycle 内部拆成：

- watchdog
- warning
- reconnecting
- disconnected

123 又把 `viewerOnly` 拆成：

- 仍可交互
- 但不拥有 session-control 主权

但如果继续往下不补这一页，读者还是会把：

- warning
- `remoteConnectionStatus`
- `reconnect()`
- brief 行里的 `Reconnecting…`
- `viewerOnly` 下 warning 的缺席

重新压成一句：

- “系统正在恢复。”

这轮要补的更窄一句是：

- 这些 signal 不是同一种 recovery signer

更准确地说，它们分别属于：

- prompt
- durable authority
- transport action
- projection
- absence semantics

## 为什么这轮必须单列

如果不单列，正文最容易在三种错误里摇摆：

- 把 warning 写成 durable reconnecting
- 把 `reconnect()` 调用写成 recovery 已成立
- 把某张 surface 的缺席写成状态不存在

这三种都会把：

- signer ceiling
- absence semantics
- mode-conditioned visibility

重新压平。

## 本轮最关键的新判断

### 判断一：`remoteConnectionStatus` 比 warning 更接近 authority，但它也只签 WS lifecycle

它不是整个 recovery 真相面。

### 判断二：`reconnect()` 是 action edge，不是 durable signer

动作发生不等于状态已被 authority 写死。

### 判断三：`viewerOnly` 切掉的是 signer，不是整个 recovery 问题域

skip timeout 不等于没有 reconnect。

### 判断四：brief 与 footer surface 的缺席语义必须单独写

缺席常常只是 signer 没挂上，而不是 opposite proof。

### 判断五：raw authority 更靠近 `SessionsWebSocket`，`remoteConnectionStatus` 是共享投影

而 timeout warning 后的 force reconnect 不保证自然投成 `onReconnecting()`。

## 苏格拉底式自审

### 问：为什么这页不能并回 122？

答：122 讲 lifecycle 内部分层；124 讲 signer ceiling 和 proof contract。

### 问：为什么这页不能并回 123？

答：123 讲 ownership；124 讲 ownership 如何改变 signer 的存在与缺席语义。

### 问：为什么一定要单列 `remoteSessionUrl` / `remote` pill 的缺席？

答：因为 attached viewer 真 remote session 也可能没有这张面；不补这一句，absence 很容易被写假。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/124-warning、连接态、force reconnect 与 viewerOnly：为什么 recovery signer 不是同一种恢复证明.md`
- `bluebook/userbook/03-参考索引/02-能力边界/113-warning、连接态、force reconnect 与 viewerOnly 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/124-2026-04-07-remote recovery signer split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 124
- 索引层只补 113
- 记忆层只补 124

不扩目录，不回改旧页正文。

## 下一轮候选

1. 单独拆 `scheduleReconnect()`、`reconnect()`、`onReconnecting()` 与 `onDisconnected()` 为什么不是同一种 transport recovery action-state contract。
2. 单独拆 `remoteSessionUrl`、brief line、bridge pill、bridge dialog 与 attached viewer 为什么不是同一种 surface presence。
3. 单独拆 `warning` transcript、`remoteConnectionStatus`、`remoteBackgroundTaskCount` 与 brief 行为什么不是同一种 remote status table。
