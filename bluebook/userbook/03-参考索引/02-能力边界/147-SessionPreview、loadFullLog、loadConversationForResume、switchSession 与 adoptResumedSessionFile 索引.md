# `SessionPreview`、`loadFullLog`、`loadConversationForResume`、`switchSession` 与 `adoptResumedSessionFile` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/158-SessionPreview、loadFullLog、loadConversationForResume、switchSession 与 adoptResumedSessionFile：为什么 resume 的 preview transcript 不是正式 session restore.md`
- `05-控制面深挖/157-getSessionFilesLite、enrichLogs、LogSelector、SessionPreview 与 loadFullLog：为什么 resume 的列表摘要面不是 preview transcript.md`
- `05-控制面深挖/156-getSessionFilesLite、loadFullLog、SessionPreview、useAssistantHistory 与 fetchLatestEvents：为什么 resume preview 的本地 transcript 快照不是 attached viewer 的 remote history.md`
- `05-控制面深挖/152-sessionStorage、hydrateFromCCRv2InternalEvents、sessionRestore、listSessionsImpl、SessionPreview 与 sessionTitle：为什么 durable session metadata 不是 live system-init，也不是 foreground external-metadata.md`

边界先说清：

- 这页不是 `/resume` 总表。
- 这页不是列表摘要面与 preview transcript 面的差异页。
- 这页不是 local vs remote history provenance 页。
- 这页只抓 preview transcript 与 formal session restore / runtime ownership handoff 的差异。

## 1. `/resume` 的四段本地流水线

| 段 | 当前回答什么 | 关键对象 |
| --- | --- | --- |
| candidate discover | 哪些 session 值得进入候选集 | `getSessionFilesLite()` |
| list summary | 列表行显示什么、过滤什么 | `enrichLogs()`、`LogSelector` |
| preview inspect | 这条 transcript 长什么样 | `SessionPreview`、`loadFullLog()` |
| formal restore | 当前 runtime 是否正式接管它 | `loadConversationForResume()`、`ResumeConversation`、`switchSession()`、`adoptResumedSessionFile()` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| preview 已经等于 restore | preview 只 hydrate 并展示 transcript；restore 还要切 session、缓存、cwd 与 transcript ownership |
| `loadFullLog()` 已经完成恢复 | `loadFullLog()` 只做 transcript reconstruction，`loadConversationForResume()` 才开始组装恢复包 |
| 按 `Enter` 只是退出 preview mode | `Enter` 会跨过 runtime ownership boundary |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | preview hydrate；formal restore 的 session takeover |
| 条件公开 | `forkSession` 会复用恢复包，但跳过原 session ownership takeover |
| 内部/灰度层 | `copyPlanForResume()`、`copyFileHistoryForResume()`、resume hook 追加内容与部分 sidecar state 细节仍可能继续调整 |

## 4. 五个检查问题

- 我现在写的是 preview transcript inspection，还是 formal session restore？
- 我是不是把 full `LogOption` 误写成“恢复完成态”？
- 我是不是把 `loadFullLog()` 误写成 `loadConversationForResume()`？
- 我是不是漏掉了 `switchSession()`、`restoreWorktreeForResume()`、`adoptResumedSessionFile()` 这条 ownership handoff？
- 我是不是把 152、156、157 的结论搬回来重写了？

## 5. 源码锚点

- `claude-code-source-code/src/types/logs.ts`
- `claude-code-source-code/src/components/SessionPreview.tsx`
- `claude-code-source-code/src/commands/resume/resume.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/utils/sessionStorage.ts`
- `claude-code-source-code/src/utils/conversationRecovery.ts`
- `claude-code-source-code/src/screens/ResumeConversation.tsx`
- `claude-code-source-code/src/utils/sessionRestore.ts`
