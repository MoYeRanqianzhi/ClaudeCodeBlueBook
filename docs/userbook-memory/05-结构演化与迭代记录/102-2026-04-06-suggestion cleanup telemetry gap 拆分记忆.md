# suggestion cleanup telemetry gap 拆分记忆

## 本轮继续深入的核心判断

99 解决的是：

- suggestion 为什么不能生成即交付
- 为什么 delayed delivery / delayed accounting 要一起拆

101 解决的是：

- `result` 为什么是 terminal final payload
- 但 raw tail 为什么还会继续存在

再往下最自然的一步不是回去重讲 suggestion 总论，而是继续往 telemetry settlement 这层压：

- 为什么 suggestion 即使已经真实交付，也不一定留下 accepted / ignored telemetry

## 为什么这轮必须单列

如果不单列，读者会自然把 99 的结论延伸成：

- suggestion 交付后，后面只是等待系统最终自动结算一笔 accepted / ignored

但源码并不是“自动补记”设计，而是：

- next prompt 才结算
- `interrupt` / `end_session` / output close 都可能直接放弃 settlement

这已经不是 delivery 问题，而是 settlement 问题。

## 本轮最关键的新判断

### 判断一：`lastEmitted` 是 delivered ledger，不是 settled ledger

这句必须钉死，否则正文会继续把已交付和已结算混成一个状态。

### 判断二：`interrupt` / `end_session` 的价值不只是 cleanup，而是直接制造 telemetry 空洞

这使它们值得进入正文，而不是留在实现细节里。

### 判断三：output close 最多保护 generation / delivery，不保护 settlement

“等待 in-flight suggestion 完成”这句非常容易被误读成“suggestion 完整收口”。

### 判断四：这轮要主动保护和 99、101 的边界

- 不重写 delayed delivery
- 不重写 terminal semantics
- 只写已交付 suggestion 的 missing settlement

## 苏格拉底式自审

### 问：为什么这轮不能并回 99？

答：因为 99 的主语是 delivery / delayed accounting；这轮的主语是 post-delivery cleanup 和 telemetry settlement hole。

### 问：为什么 `interrupt` / `end_session` 值得进标题？

答：因为它们不是普通 cleanup 噪音，而是已交付 suggestion 是否还会留下 accepted / ignored verdict 的分水岭。

### 问：为什么 output close 也值得进正文？

答：因为很多人会自然以为 close 前等待 in-flight suggestion 就意味着统计也完整了；源码并没有这么做。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/102-lastEmitted、logSuggestionOutcome、interrupt、end_session 与 output.done：为什么 headless print 的已交付 suggestion 不一定留下 accepted、ignored telemetry.md`
- `bluebook/userbook/03-参考索引/02-能力边界/91-Suggestion cleanup and telemetry gap 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/102-2026-04-06-suggestion cleanup telemetry gap 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 102
- 索引层只补 91
- 记忆层只补 102

不把它并回 99，也不把它揉进 101。

## 下一轮候选

1. 单独拆 `pending_action` / `task_summary` 在 restart cleanup 与 restore 缺席之间为什么不是同一种恢复面。
2. 单独拆 `post_turn_summary` 的 stdout-vs-SDKMessage split 为什么不等于“完全不可见”。
3. 单独拆 suggestionState 的 `pendingLastEmittedEntry` 在部分 cleanup 分支里为什么会留下 internal stale staging。
