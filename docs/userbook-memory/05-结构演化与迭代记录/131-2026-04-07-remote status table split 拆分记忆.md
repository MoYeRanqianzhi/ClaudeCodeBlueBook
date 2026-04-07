# remote status table split 拆分记忆

## 本轮继续深入的核心判断

122 已经把 warning / reconnecting / disconnected 拆成 recovery lifecycle。

130 又把几种“像远端存在”的 surface 拆成了不同 presence。

但如果继续往下不补这一页，读者还是会把：

- warning transcript
- `remoteConnectionStatus`
- `remoteBackgroundTaskCount`
- brief line

重新压成一句：

- “这些只是同一张 remote status table 的不同展示。”

这轮要补的更窄一句是：

- remote session 的四类可见信号分属四张账，而不是同一张 remote status table

## 为什么这轮必须单列

如果不单列，正文最容易在三种错误里摇摆：

- 把 transcript warning 写成连接状态本体
- 把 `remoteBackgroundTaskCount` 写成本地 task 表的别名
- 把 brief line 写成完整 remote truth surface

这三种都会把：

- transcript ledger
- WS lifecycle ledger
- remote task counter ledger
- summary projection ledger

重新压扁。

## 本轮最关键的新判断

### 判断一：warning 是 remediation prompt，不是 authoritative connection state

### 判断二：`remoteConnectionStatus` 只回答 WS lifecycle，不回答 worker 健康或恢复成功

### 判断三：`remoteBackgroundTaskCount` 是远端子任务 live counter，不是本地 `tasks`

### 判断四：brief line 是 lossy projection，天然会丢 provenance

### 判断五：`viewerOnly` 可以出现 brief reconnect，但没有 timeout warning，从反面证明它们不是同一张表

## 苏格拉底式自审

### 问：为什么这页不能并回 122？

答：122 讲 lifecycle ordering；131 讲 accounting ownership。

### 问：为什么这页不能并回 130？

答：130 讲 surface presence；131 讲 status ledgers。

### 问：为什么一定要把 `viewerOnly` 拉进来？

答：因为没有它，就很难从反面证明 warning 与 connection status 不是同一条账。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/131-warning transcript、remoteConnectionStatus、remoteBackgroundTaskCount 与 brief line：为什么 remote session 的四类可见信号分属四张账，而不是同一张 remote status table.md`
- `bluebook/userbook/03-参考索引/02-能力边界/120-warning transcript、remoteConnectionStatus、remoteBackgroundTaskCount 与 brief line 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/131-2026-04-07-remote status table split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 131
- 索引层只补 120
- 记忆层只补 131

不扩目录，不回写旧页。

## 下一轮候选

1. 单独拆 direct connect / remote session / bridge 的 authoritative runtime state 到 transcript、footer、dialog、store 的消费断点，为什么 bridge 能形成三面对齐而另外两条线更多只是 event projection。
2. 单独拆 `post_turn_summary`、`pending_action`、`task_summary` 与当前 REPL 前台，为什么 schema/store 里有账，不等于前台已经消费。
3. 如果还要继续沿 remote session 走，再把 warning transcript 与 `force reconnect` / `onReconnecting` 的失配窗口单独拆成一页。
