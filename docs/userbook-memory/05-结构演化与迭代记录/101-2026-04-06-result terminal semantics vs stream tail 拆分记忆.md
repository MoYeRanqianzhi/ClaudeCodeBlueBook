# result terminal semantics vs stream tail 拆分记忆

## 本轮继续深入的核心判断

100 已经把 summary family 的 transport/lifecycle 合同拆开了。

下一步最自然不是继续讲 summary，而是继续往 terminal contract 本身下压：

- 为什么 `result` 是最终输出语义
- 但它仍然不是流读取终点

## 为什么这轮必须单列

如果不单列，读者会把 98 的结论停在：

- `lastMessage` 不会让位给晚到系统尾流

但真正更实用的一层是：

- downstream consumer 不能把最后一个 raw frame 当成最终答案语义
- `result`、`prompt_suggestion`、`session_state_changed('idle')` 分别回答的是不同问题

## 本轮最关键的新判断

### 判断一：`lastMessage` 是 filtered terminal cursor，不是最后一个原始流帧

这一句值得单独成页，因为它直接约束 JSON/text/exit code 的读取方式。

### 判断二：`result` 是 terminal final payload，但 raw tail 可以继续存在

`heldBackResult`、`prompt_suggestion after result`、`finally` idle drain 三条证据一起把这件事钉死了。

### 判断三：`prompt_suggestion` 最适合作为 terminal-inert 例子，而不是继续当 suggestion 理论的一部分

这轮写它，不是为了 suggestion，而是为了证明 stream-visible 与 terminal-semantic 是两条坐标轴。

### 判断四：`session_state_changed('idle')` 必须单独写成 settled signal

否则正文会继续把“答案是什么”和“回合是否结束”写成一个字段。

## 苏格拉底式自审

### 问：为什么这轮不能继续把内容堆进 98？

答：因为 98 的主语是 semantic last result；这轮的主语是 raw stream tail 与 terminal semantics 的分离，读者真正拿去接协议时最容易踩坑的正是这层。

### 问：为什么 `outputFormat` switch 值得成为核心证据？

答：因为那里把最终 JSON、默认文本与退出码都绑定到 filtered `result` 上，直接把抽象语义压成运行时合同。

### 问：为什么 `prompt_suggestion` 和 `post_turn_summary` 都值得提，却不能把本页写成“尾流大全”？

答：因为本页只拿它们证明 terminal-inert / type-surface split，不扩成各种尾流对象的总论。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/101-lastMessage、outputFormat switch、gracefulShutdownSync、prompt_suggestion 与 session_state_changed(idle)：为什么 headless print 的 result 是最终输出语义，却不是流读取终点.md`
- `bluebook/userbook/03-参考索引/02-能力边界/90-Result terminal semantics vs stream tail 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/101-2026-04-06-result terminal semantics vs stream tail 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 101
- 索引层只补 90
- 记忆层只补 101

不把它并回 98，也不把它揉进 100。

## 下一轮候选

1. 单独拆 suggestion 在 `interrupt` / `end_session` / shutdown 下的清理与 telemetry 空洞。
2. 单独拆 `pending_action` / `task_summary` 在 restart cleanup 与 restore 缺席之间为什么不是同一种恢复面。
3. 单独拆 `post_turn_summary` 的 stdout-vs-SDKMessage split 为什么不等于“完全不可见”。
