# `loadConversationForResume`、`deserializeMessagesWithInterruptDetection`、`copyPlanForResume`、`fileHistoryRestoreStateFromLog` 与 `processSessionStartHooks` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/160-loadConversationForResume、deserializeMessagesWithInterruptDetection、copyPlanForResume、fileHistoryRestoreStateFromLog 与 processSessionStartHooks：为什么 resume 恢复包不是同一种内容载荷.md`
- `05-控制面深挖/158-SessionPreview、loadFullLog、loadConversationForResume、switchSession 与 adoptResumedSessionFile：为什么 resume 的 preview transcript 不是正式 session restore.md`
- `05-控制面深挖/159-forkSession、switchSession、copyPlanForFork、restoreWorktreeForResume 与 adoptResumedSessionFile：为什么 --fork-session 不是较弱的原会话恢复，而是新 session 分叉.md`

边界先说清：

- 这页不是 `/resume` 总表。
- 这页不是 preview vs restore 的边界页。
- 这页不是 fork vs non-fork ownership 页。
- 这页只抓 formal restore 内部的 payload taxonomy。

## 1. 四张账

| 账 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| transcript 合法化账 | 让旧消息重新可继续 | `deserializeMessagesWithInterruptDetection()` |
| plan 文件账 | 让 plan slug / file 继续成立 | `copyPlanForResume()` |
| file-history 账 | 恢复前台状态与备份目录 | `fileHistoryRestoreStateFromLog()`、`copyFileHistoryForResume()` |
| hook 注入账 | resume 当下新增的运行时上下文 | `executeSessionEndHooks()`、`processSessionStartHooks()` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| resume 恢复包就是旧 transcript | transcript 只是恢复包主干之一 |
| plan/file-history 都是消息的一部分 | 它们各自有 file-backed / AppState-backed consumer |
| hook message 只是旧消息回放 | hook 产物是在 resume 当下重新执行、重新追加的 |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | transcript 清洗、plan 复制、file-history restore、resume hooks |
| 条件公开 | plan 文件缺失时会走 snapshot / message-history recovery；file-history 只在启用时恢复 |
| 内部/灰度层 | 某些 hook additional context、watch path 与 sidecar state 细节仍可能继续调整 |

## 4. 五个检查问题

- 当前恢复的是 transcript 可用性，还是外部 sidecar 文件/状态？
- 当前内容是从旧 transcript 里清洗出来的，还是 resume 当下新增注入的？
- 当前 consumer 是 `setMessages`，还是 `AppState.fileHistory` / plan slug cache？
- 我是不是把 hook 产物误写成 persisted transcript replay？
- 我是不是把 158/159 的 ownership 话题搬回来重写了？

## 5. 源码锚点

- `claude-code-source-code/src/utils/conversationRecovery.ts`
- `claude-code-source-code/src/utils/plans.ts`
- `claude-code-source-code/src/utils/fileHistory.ts`
- `claude-code-source-code/src/utils/sessionStart.ts`
- `claude-code-source-code/src/utils/sessionRestore.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
