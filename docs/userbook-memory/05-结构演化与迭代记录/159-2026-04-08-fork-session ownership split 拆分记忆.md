# fork-session ownership split 拆分记忆

## 本轮继续深入的核心判断

158 已经把：

- preview transcript
- formal restore

拆开了。

但正文还缺一个更细的恢复结论：

- `--fork-session` 和普通 resume 共享恢复载荷，却不是同一种 ownership 语义

本轮要补的更窄一句是：

- 普通 resume 会接管原 session 身份、worktree 和 transcript 写回；`--fork-session` 只把旧内容和部分 sidecar state 带进一个新 session lineage

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 fork 写成“换个 ID 的 restore”
- 把 plan / transcript / worktree 都误写成 fork 会继续复用
- 把 sidecar state 的迁移误写成 ownership 的继承

这三种都会把：

- shared resume payload
- distinct session ownership

重新压扁。

## 本轮最关键的新判断

### 判断一：共享恢复包不等于共享 session 身份

### 判断二：`copyPlanForFork()` 继承的是 plan 内容，不是 plan identity

### 判断三：`recordContentReplacement()` 说明 fork 会把 sidecar state 重新绑定到新 session

### 判断四：`worktreeSession: undefined` 说明 fork 明确拒绝接管原 worktree ownership

### 判断五：fork 跳过 `adoptResumedSessionFile()`，说明它不会把写回责任接回原 transcript

## 苏格拉底式自审

### 问：为什么这页不是 158 的附录？

答：因为 158 只拆 preview 和 formal restore；159 继续拆 formal restore 内部的 normal path 和 fork path。

### 问：为什么一定要写 `copyPlanForFork()`？

答：因为 plan slug 的新建最容易让读者看见“fork 继承的是内容，不是身份”。

### 问：为什么一定要写 `worktreeSession: undefined`？

答：因为这条规则把 fork 和普通 resume 在 worktree ownership 上的分叉直接写死了。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/159-forkSession、switchSession、copyPlanForFork、restoreWorktreeForResume 与 adoptResumedSessionFile：为什么 --fork-session 不是较弱的原会话恢复，而是新 session 分叉.md`
- `bluebook/userbook/03-参考索引/02-能力边界/148-forkSession、switchSession、copyPlanForFork、restoreWorktreeForResume 与 adoptResumedSessionFile 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/159-2026-04-08-fork-session ownership split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 159
- 索引层只补 148
- 记忆层只补 159

不回写 152、157、158。

## 下一轮候选

1. 继续拆 `copyPlanForResume()`、`copyFileHistoryForResume()`、resume hooks 与 transcript 本体为什么不是同一种恢复载荷。
2. 继续拆 CLI `--continue/--resume`、startup picker 与会内 `/resume` 为什么共享恢复合同，却不是同一种入口宿主。
