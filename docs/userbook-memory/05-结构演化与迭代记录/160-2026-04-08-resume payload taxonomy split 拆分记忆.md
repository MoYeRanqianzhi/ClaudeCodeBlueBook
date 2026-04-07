# resume payload taxonomy split 拆分记忆

## 本轮继续深入的核心判断

159 已经把：

- 普通 resume
- `--fork-session`

拆成了两条 ownership 合同。

但正文还缺一个更细的恢复结论：

- formal restore 自己内部也不是同一种内容载荷

本轮要补的更窄一句是：

- transcript、plan、file-history、resume hooks 都会在恢复时被带回，但它们服务的是四种不同 consumer contract

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 plan/file-history/hook 全都误写成 transcript 的附件
- 把 hook 追加层误写成旧消息回放
- 把 restore payload taxonomy 误写成 ownership taxonomy

这三种都会把：

- message payload
- sidecar file payload
- AppState payload
- runtime appended payload

重新压扁。

## 本轮最关键的新判断

### 判断一：`deserializeMessagesWithInterruptDetection()` 处理的是 transcript 合法化账

### 判断二：`copyPlanForResume()` 处理的是 plan 文件主权账

### 判断三：`fileHistoryRestoreStateFromLog()` 与 `copyFileHistoryForResume()` 共同构成 file-history 账

### 判断四：`executeSessionEndHooks()` / `processSessionStartHooks()` 构成 resume 当下的 hook 注入账

### 判断五：`loadConversationForResume()` 返回的是多层恢复包，不是单一 transcript blob

## 苏格拉底式自审

### 问：为什么这页不是 158 的附录？

答：因为 158 只拆 preview 与 formal restore；160 继续往 formal restore 内部拆 payload taxonomy。

### 问：为什么一定要写 `copyPlanForResume()`？

答：因为 plan 文件是最容易被误写成“消息里的一段文本”的 sidecar，需要单列。

### 问：为什么一定要写 `executeSessionEndHooks()`？

答：因为这样才能把 hook 层明确写成 resume 时刻的运行时注入，而不是旧 transcript 回放。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/160-loadConversationForResume、deserializeMessagesWithInterruptDetection、copyPlanForResume、fileHistoryRestoreStateFromLog 与 processSessionStartHooks：为什么 resume 恢复包不是同一种内容载荷.md`
- `bluebook/userbook/03-参考索引/02-能力边界/149-loadConversationForResume、deserializeMessagesWithInterruptDetection、copyPlanForResume、fileHistoryRestoreStateFromLog 与 processSessionStartHooks 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/160-2026-04-08-resume payload taxonomy split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 160
- 索引层只补 149
- 记忆层只补 160

不回写 152、158、159。

## 下一轮候选

1. 继续拆 CLI `--continue/--resume`、startup picker 与会内 `/resume` 为什么共享恢复合同，却不是同一种入口宿主。
2. 继续拆 transcript 合法化、interrupt 修复与 hook 注入为什么都在“恢复前后”发生，却不是同一种 runtime stage。
