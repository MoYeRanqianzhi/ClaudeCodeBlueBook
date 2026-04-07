# transport terminality policy split 拆分记忆

## 本轮继续深入的核心判断

125 已经把 transport 层拆成：

- close-driven backoff
- force reconnect
- `onReconnecting`
- `onClose`

但如果继续往下不补 terminality 这一页，读者还是会把：

- `PERMANENT_CLOSE_CODES`
- `4001`
- ordinary reconnect budget

重新压成一句：

- “断了以后就是按不同次数重试。”

这轮要补的更窄一句是：

- permanent rejection
- compaction-aware stale exception
- ordinary transient retry

不是同一种 stop rule。

## 为什么这轮必须单列

如果不单列，正文最容易在三种错误里摇摆：

- 把 `4001` 写成小预算普通 reconnect
- 把 `4003` 写成 budget 为 0 的 reconnect
- 把 `onClose` 统一出口写成统一原因

这三种都会把：

- terminal sink
- terminal reason
- retry bucket

重新压平。

## 本轮最关键的新判断

### 判断一：`PERMANENT_CLOSE_CODES` 的主语是 rejection，不是 retry

### 判断二：`4001` 的主语是 compaction stale exception，不是普通 transient close

### 判断三：ordinary reconnect budget 还要求 `previousState === 'connected'`

### 判断四：统一落到 `onClose` 不等于 terminality reason 统一

## 苏格拉底式自审

### 问：为什么这页不能并回 125？

答：125 讲 action-state path；126 讲 terminality rule taxonomy。

### 问：为什么一定要把 compaction 拉进来？

答：因为不拉它，`4001` 就会被误写成普通 reconnect bucket。

### 问：为什么不把 3、5 次预算直接写进稳定合同？

答：因为这些是当前实现常量，不是稳态对外承诺。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/126-PERMANENT_CLOSE_CODES、4001 与 reconnect budget：为什么 terminality policy 不是同一种 stop rule.md`
- `bluebook/userbook/03-参考索引/02-能力边界/115-PERMANENT_CLOSE_CODES、4001 与 reconnect budget 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/126-2026-04-07-transport terminality policy split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 126
- 索引层只补 115
- 记忆层只补 126

不扩目录，不回写旧页。

## 下一轮候选

1. 单独拆 `remoteSessionUrl`、brief 行、bridge pill、bridge dialog 与 attached viewer 为什么不是同一种 surface presence。
2. 单独拆 `warning` transcript、`remoteConnectionStatus`、`remoteBackgroundTaskCount` 与 brief 行为什么不是同一种 remote status table。
3. 单独拆 `4001` stale window、`status=compacting`、`COMPACTION_TIMEOUT_MS` 与 warning suppress 为什么不是同一种 compaction recovery 合同。
