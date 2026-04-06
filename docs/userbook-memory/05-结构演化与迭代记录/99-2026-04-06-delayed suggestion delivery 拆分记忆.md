# delayed suggestion delivery 拆分记忆

## 本轮继续深入的核心判断

98 已经把 semantic last result 与 late system tail 拆出来了。

下一步最自然不是继续讲 tail，而是继续往下压到：

- suggestion 为什么也要服从 result-first 的真实交付顺序
- 以及为什么 acceptance tracking 只认真实交付过的 suggestion

## 为什么这轮必须把 delayed suggestion delivery 单列

如果不单列，读者会把 98 的结论停在：

- 主结果语义不会让给晚到系统尾流

但更深一层真正关键的事实是：

- suggestion 虽然不是系统尾流，却也不能绕开主结果优先级
- 生成、输出、记账三者被明确分开

## 本轮最关键的新判断

### 判断一：`pendingSuggestion` 和 `pendingLastEmittedEntry` 不是同一块缓存

一个在等交付，一个在等记账资格升级。

### 判断二：`lastEmitted` 只记录真实交付过的 suggestion

这句必须钉死，否则 acceptance tracking 会被写反。

### 判断三：未交付 suggestion 可以被主动丢弃

这条证据非常值钱，因为它直接说明系统的真标准是 delivery，不是 generation。

### 判断四：`logSuggestionOutcome(...)` 把这条边界升级成了统计合同

这使得 99 不只是 UI/输出顺序问题。

## 为什么这轮不并回 98

98 讲 semantic last result。
99 讲 suggestion delivery and accounting。

主语不同，不该揉回去。

## 苏格拉底式自审

### 问：为什么这轮最先该拆 `pendingLastEmittedEntry`？

答：因为只有把“待交付 suggestion”和“待升级 tracking 元数据”分开，才能真正看见记账边界。

### 问：为什么“可被丢弃”这么重要？

答：因为这证明系统优先守真实交付，而不是守“已经算出来就别浪费”。

### 问：为什么 `logSuggestionOutcome(...)` 值得成为本页论据？

答：因为它把 suggestion 交付边界从显示语义推进到了统计语义。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/99-pendingSuggestion、pendingLastEmittedEntry、lastEmitted、logSuggestionOutcome 与 heldBackResult：为什么 headless print 的 suggestion 不是生成即交付.md`
- `bluebook/userbook/03-参考索引/02-能力边界/88-Delayed suggestion delivery and accounting 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/99-2026-04-06-delayed suggestion delivery 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小改动：

- 长文层只补 99
- 索引层只补 88
- 记忆层只补 99

不把 98-99 重新揉成一篇大的 result/suggestion 总论。

## 下一轮候选

1. 单独拆 `post_turn_summary` 与 `task_summary` 的尾流层级差异。
2. 单独拆 headless `print` 在 CLI 输出/退出语义上如何依赖 `lastMessage` 保持为 result。
3. 单独拆 `suggestionState` 的 abort/inflightPromise 清理为什么不能被当作普通取消逻辑。
