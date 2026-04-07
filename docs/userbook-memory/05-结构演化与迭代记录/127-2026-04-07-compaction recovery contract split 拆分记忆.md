# compaction recovery contract split 拆分记忆

## 本轮继续深入的核心判断

67 已经讲过：

- `status=compacting` 同时会喂 transcript 与 timeout policy

126 又把 `4001` 从 ordinary reconnect 里单独拆出来。

但如果继续往下不补这一页，读者还是会把：

- `status=compacting`
- repeated `compacting`
- `COMPACTION_TIMEOUT_MS`
- `4001`
- `compact_boundary`

压成一句：

- “compaction 进入恢复态了。”

这轮要补的更窄一句是：

- progress/status
- keep-alive
- patience policy
- stale exception
- rewrite completion

不是同一种恢复信号。

## 为什么这轮必须单列

如果不单列，正文最容易在三种错误里摇摆：

- 把 repeated `compacting` 写成继续推进的状态
- 把 `4001` 写成 compacting 的另一种状态词
- 把 `compact_boundary` 写成“仍在 compacting”的证明

这三种都会把：

- compaction recovery contract
- transport exception
- transcript rewrite completion

重新压平。

## 本轮最关键的新判断

### 判断一：re-emit `compacting` 在这里首先是 keep-alive，不是 progress delta

### 判断二：`COMPACTION_TIMEOUT_MS` 是 local patience policy，不是 remote truth

### 判断三：`4001` 是 compaction stale-window exception，不是 ordinary reconnect

### 判断四：`compact_boundary` 是 rewrite completion marker，不是 compacting 状态延续

## 苏格拉底式自审

### 问：为什么这页不能并回 67？

答：67 讲消费者；127 讲 compaction 恢复合同的分层。

### 问：为什么这页不能并回 126？

答：126 讲 terminality bucket；127 讲 `4001` 放进 compaction 合同里后和 status/boundary/timeout 的关系。

### 问：为什么要把 `WebSocketTransport` 的 `4001` 差异拉进来？

答：因为它提醒我们：`4001` 的“可重试”不是全局协议真相，而是当前组件语义。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/127-compacting、boundary、timeout、4001 与 keep-alive：为什么 compaction recovery contract 不是同一种恢复信号.md`
- `bluebook/userbook/03-参考索引/02-能力边界/116-compacting、boundary、timeout、4001 与 keep-alive 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/127-2026-04-07-compaction recovery contract split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 127
- 索引层只补 116
- 记忆层只补 127

不扩目录，不回写旧页。

## 下一轮候选

1. 单独拆 `remoteSessionUrl`、brief 行、bridge pill、bridge dialog 与 attached viewer 为什么不是同一种 surface presence。
2. 单独拆 `warning` transcript、`remoteConnectionStatus`、`remoteBackgroundTaskCount` 与 brief 行为什么不是同一种 remote status table。
3. 单独拆 `4001` 在 `SessionsWebSocket` 与 `WebSocketTransport` 里的不同语义，为什么不是同一种 session not found 合同。
