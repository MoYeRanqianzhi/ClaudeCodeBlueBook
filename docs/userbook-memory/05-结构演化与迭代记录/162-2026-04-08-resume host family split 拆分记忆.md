# resume host family split 拆分记忆

## 本轮继续深入的核心判断

161 已经把 interactive TUI 内部的三种 entry host 拆开了。

但正文还缺一个更外层的恢复结论：

- interactive resume host 与 `print.ts` / headless host 也不是同一种宿主族

本轮要补的更窄一句是：

- 两边共享 `loadConversationForResume()` 等恢复语义，但 interactive 最终挂到 `<REPL />`，headless print 最终落到 `LoadInitialMessagesResult + StructuredIO`

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 print resume 写成无 UI 版 REPL resume
- 把 `loadInitialMessages()` 写成另一个 `launchRepl()` 前置步骤
- 把 interactive host segmentation 继续错当成 host family taxonomy

这三种都会把：

- restore contract
- host family

重新压扁。

## 本轮最关键的新判断

### 判断一：interactive TUI resume host 的终点是 `<REPL />`

### 判断二：`print.ts` resume host 的终点是 `LoadInitialMessagesResult + StructuredIO`

### 判断三：共享恢复语义不等于共享下游消费者

### 判断四：print 路径没有 live REPL unwind 的宿主责任

### 判断五：这页必须避开 CLI 根入口总论和 remote-control host 体系

## 苏格拉底式自审

### 问：为什么这页不是 161 的附录？

答：因为 161 只拆 interactive TUI 宿主内部；162 第一次把 interactive 与 headless print 宿主族拆开。

### 问：为什么一定要写 `StructuredIO`？

答：因为它是 headless print 宿主最硬的下游证据。

### 问：为什么一定要写 `loadInitialMessages()`？

答：因为它是 print host 的真正恢复宿主，不是 REPL mount helper。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/162-main.tsx、print.ts、loadInitialMessages、ResumeConversation 与 REPL.resume：为什么 interactive resume host 与 headless print host 共享恢复语义，却不是同一种宿主族.md`
- `bluebook/userbook/03-参考索引/02-能力边界/151-main.tsx、print.ts、loadInitialMessages、ResumeConversation 与 REPL.resume 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/162-2026-04-08-resume host family split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 162
- 索引层只补 151
- 记忆层只补 162

不回写 155、161。

## 下一轮候选

1. 继续拆 transcript 合法化、interrupt 修复与 hook 注入为什么都在“恢复前后”发生，却不是同一种 runtime stage。
2. 继续拆 print/headless resume 里的 remote hydration、URL/jsonl/session-id 解析与 formal restore 为什么不是同一种前置阶段。
