# session not found contract split 拆分记忆

## 本轮继续深入的核心判断

126 已经把 `SessionsWebSocket` 内部的 terminality policy 拆出来了，

127 又把 compaction recovery contract 拆出来了。

但如果继续往下不补这一页，读者还是会把：

- `SessionsWebSocket` 的 `4001`
- `WebSocketTransport` 的 `4001`

重新压成一句：

- “同一个 session not found，只是一个组件愿意重试，一个组件不愿意。”

这轮要补的更窄一句是：

- 同一个 `4001`
- 在不同组件里已经不是同一种合同

## 为什么这轮必须单列

如果不单列，正文最容易在三种错误里摇摆：

- 把 `SessionsWebSocket 4001` 外推成全局 `4001` 规律
- 把 `WebSocketTransport 4001` 写成 budget 为 0 的 reconnect
- 把同样的 `onClose` sink 写成同样的 terminal reason

这三种都会把：

- component semantics
- contract owner
- sink vs reason

重新压平。

## 本轮最关键的新判断

### 判断一：`SessionsWebSocket 4001` 的主语是 compaction stale-window exception

### 判断二：`WebSocketTransport 4001` 的主语是 expired / reaped session permanent close

### 判断三：同一个 code 的 meaning 是 component-scoped，不是全局固定真义

### 判断四：同样进入 `onClose`，不等于终止语义一致

## 苏格拉底式自审

### 问：为什么这页不能并回 126？

答：126 讲同一组件内部的 terminality bucket；128 讲跨组件的 code semantics 分裂。

### 问：为什么这页不能并回 127？

答：127 讲 `4001` 放进 compaction 合同之后的层级关系；128 讲它放进别的 transport 后为什么语义变了。

### 问：为什么一定要把 `WebSocketTransport` 拉进来？

答：因为没有它，“4001 是否可重试”就会被误写成全局协议真相。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/128-SessionsWebSocket 4001、WebSocketTransport 4001 与 session not found：为什么它们不是同一种合同.md`
- `bluebook/userbook/03-参考索引/02-能力边界/117-4001 在 SessionsWebSocket 与 WebSocketTransport 的语义分裂 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/128-2026-04-07-session not found contract split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 128
- 索引层只补 117
- 记忆层只补 128

不扩目录，不回写旧页。

## 下一轮候选

1. 单独拆 `remoteSessionUrl`、brief 行、bridge pill、bridge dialog 与 attached viewer 为什么不是同一种 surface presence。
2. 单独拆 `warning` transcript、`remoteConnectionStatus`、`remoteBackgroundTaskCount` 与 brief 行为什么不是同一种 remote status table。
3. 单独拆 `headersRefreshed`、`autoReconnect`、sleep detection 与 4003 refresh path，为什么 `WebSocketTransport` 的恢复主权不是 `SessionsWebSocket` 的镜像。
