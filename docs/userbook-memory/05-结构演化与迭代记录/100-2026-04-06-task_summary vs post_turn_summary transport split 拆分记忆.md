# `task_summary` vs `post_turn_summary` transport split 拆分记忆

## 本轮继续深入的核心判断

如果继续沿 98/99 往下压，只盯着 `result`、tail 与 suggestion，会漏掉另一条很值钱的非对称：

- `task_summary` 与 `post_turn_summary` 不只是时间先后不同
- 它们连 carrier、union visibility、clear/restart、restore 与常规转发路径都不同

## 为什么这轮必须单列

51 已经讲过远端运行态投影面的大分层，但那一页的主语仍然太宽：

- phase
- block context
- progress
- event stream

这轮更窄的问题是：

- 为什么同样都带着 summary 之名，源码却把它们拆成两套 transport/lifecycle contract

如果不单列，读者很容易只留下：

- “一个是中途摘要，一个是事后摘要”

而丢掉真正更硬的代码事实：

- `task_summary` 会被 `idle` 和 restart cleanup 主动清 stale
- `post_turn_summary` 有独立 schema，但不进 core SDK message union
- 常规 CLI / direct-connect 路径还会继续过滤它

## 本轮最关键的新判断

### 判断一：`task_summary` 的合同核心是 freshness，不是 persistence

`idle` 清空与 worker init 清 stale 是最硬证据。

### 判断二：`post_turn_summary` 的关键不是“更完整”，而是“它属于更宽输出层，却不属于 core SDK message 主合同”

`SDKMessageSchema` 与 `StdoutMessageSchema` 的差异是这轮最值钱的新证据。

### 判断三：resume / restore 不把这些 summary 回填为本地 `AppState`

这说明它们更像观察面 side state，不是本地恢复真相。

### 判断四：这轮要主动保护 stable / gray 边界

可稳定写的是 carrier、clear、union、filter。
不要把当前树里没直接看到的具体 producer 想当然写死。

## 苏格拉底式自审

### 问：为什么这轮不能只在 51 上补两段？

答：因为 51 的主语是远端运行态投影面；这轮的主语是 summary family 自己的 transport/lifecycle asymmetry，已经值得单独成页。

### 问：为什么 `ccr init clear` 值得成为标题级证据？

答：因为它直接证明 `task_summary` 不是“应该跨 crash 保留的摘要记忆”，而是“必须优先避免 stale 污染”的运行态投影。

### 问：为什么 `SDKMessageSchema` 与 `StdoutMessageSchema` 的差异值得进正文？

答：因为读者最容易把“有 schema”偷换成“是公开核心消息”；这轮正好把这层误判拆掉。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/100-task_summary、post_turn_summary、SDKMessageSchema、StdoutMessageSchema 与 ccr init clear：为什么 Claude Code 的 summary 不是同一条 transport-lifecycle contract.md`
- `bluebook/userbook/03-参考索引/02-能力边界/89-task_summary vs post_turn_summary transport-lifecycle 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/100-2026-04-06-task_summary vs post_turn_summary transport split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 100
- 索引层只补 89
- 记忆层只补 100

不把它并回 51，也不把它揉进 98/99 的 result-tail-suggestion 链。

## 下一轮候选

1. 单独拆 `lastMessage` / output switch / `gracefulShutdownSync`：为什么 headless print 的 `result` 是最终输出语义，却不是流读取终点。
2. 单独拆 suggestion 在 `interrupt` / `end_session` / shutdown 下的清理与 telemetry 空洞。
3. 单独拆 `pending_action` / `task_summary` 在 restart cleanup 与 restore 缺席之间为什么不是同一种恢复面。
