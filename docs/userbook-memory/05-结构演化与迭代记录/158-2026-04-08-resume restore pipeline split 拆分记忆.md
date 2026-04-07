# resume restore pipeline split 拆分记忆

## 本轮继续深入的核心判断

157 已经把：

- `/resume` 的列表摘要面
- `/resume` 的 preview transcript 面

拆开了。

但正文还缺一个更后的恢复结论：

- preview transcript 不是 formal session restore / runtime ownership handoff

本轮要补的更窄一句是：

- `SessionPreview + loadFullLog` 只负责把正文展开给人看；`loadConversationForResume + ResumeConversation + switchSession + adoptResumedSessionFile` 才负责让当前 runtime 正式接管那条 session

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 full `LogOption` 写成“已经恢复成功”
- 把 `loadFullLog()` 写成“完整 resume”
- 把按 `Enter` 写成“只是退出 preview mode”

这三种都会把：

- preview transcript inspection
- formal runtime restore

重新压扁。

## 本轮最关键的新判断

### 判断一：`LogOption` 是多厚度 carrier，不是 restore proof

### 判断二：`SessionPreview` 只拥有 transcript inspection 主权

### 判断三：`loadConversationForResume()` 开始组装 resume sidecar state

### 判断四：`ResumeConversation` 才执行 session / worktree / metadata / transcript ownership handoff

### 判断五：`adoptResumedSessionFile()` 是 preview 从未跨过的磁盘分水岭

## 苏格拉底式自审

### 问：为什么这页不是 157 的附录？

答：因为 157 只拆到 preview；158 继续往后拆 preview 之后的 formal restore。

### 问：为什么一定要写 `adoptResumedSessionFile()`？

答：因为 formal restore 的关键不是“已经能读旧消息”，而是“后续写入与退出清理已经回到那条旧 transcript”。

### 问：为什么一定要写 `restoreWorktreeForResume()`？

答：因为这能把目录主权也带进讨论，防止把 preview 错写成拥有 cwd/worktree 恢复能力的动作。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/158-SessionPreview、loadFullLog、loadConversationForResume、switchSession 与 adoptResumedSessionFile：为什么 resume 的 preview transcript 不是正式 session restore.md`
- `bluebook/userbook/03-参考索引/02-能力边界/147-SessionPreview、loadFullLog、loadConversationForResume、switchSession 与 adoptResumedSessionFile 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/158-2026-04-08-resume restore pipeline split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 158
- 索引层只补 147
- 记忆层只补 158

不回写 152、156、157。

## 下一轮候选

1. 继续拆 `forkSession` 与非 `forkSession` 为什么共享恢复包，却不是同一种 ownership 语义。
2. 继续拆 `copyPlanForResume()`、`copyFileHistoryForResume()`、resume hooks 与 transcript 本体为什么不是同一种恢复载荷。
