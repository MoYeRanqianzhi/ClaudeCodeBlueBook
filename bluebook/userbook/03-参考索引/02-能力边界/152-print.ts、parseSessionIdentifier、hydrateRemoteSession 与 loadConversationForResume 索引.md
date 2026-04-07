# `print.ts`、`parseSessionIdentifier`、`hydrateRemoteSession` 与 `loadConversationForResume` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/163-print.ts、parseSessionIdentifier、hydrateRemoteSession 与 loadConversationForResume：为什么 print resume 的 parse、hydrate、restore 不是同一种前置阶段.md`
- `05-控制面深挖/162-main.tsx、print.ts、loadInitialMessages、ResumeConversation 与 REPL.resume：为什么 interactive resume host 与 headless print host 共享恢复语义，却不是同一种宿主族.md`
- `05-控制面深挖/160-loadConversationForResume、deserializeMessagesWithInterruptDetection、copyPlanForResume、fileHistoryRestoreStateFromLog 与 processSessionStartHooks：为什么 resume 恢复包不是同一种内容载荷.md`

边界先说清：

- 这页不是 print host 总表。
- 这页不是 host family 页。
- 这页不是 payload taxonomy 页。
- 这页只抓 `print.ts` resume 内部的 pre-restore stage taxonomy。

## 1. 五段前置链

| 段 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| identifier classification | 识别 UUID / URL / `.jsonl` | `parseSessionIdentifier()` |
| remote transcript materialization | 把远端日志回灌成本地 transcript | `hydrateFromCCRv2InternalEvents()`、`hydrateRemoteSession()` |
| formal restore load | 读取本地 transcript 并构造恢复包 | `loadConversationForResume()` |
| absence semantics decision | 空结果解释成 startup 还是失败 | `processSessionStartHooks('startup')`、empty-session checks |
| message-level rewind | 把恢复结果裁到指定 message uuid | `resumeSessionAt` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| print resume 就是 hydrate 再 restore | parse、hydrate、restore、fallback、rewind 是五个不同阶段 |
| URL / jsonl / UUID 都只是 session id 的变体 | 它们先决定的是解释路径，不是恢复结果 |
| 空 transcript 就等于恢复失败 | 在 URL / CCR v2 路径里它还可能回退成 startup hooks |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | identifier parse、remote hydrate、formal restore、empty fallback、resumeSessionAt |
| 条件公开 | URL / CCR v2 才会走 remote hydrate 与空会话 startup fallback |
| 内部/灰度层 | 某些 remote hydration 和 metadata side-effects 细节仍可能继续调整 |

## 4. 五个检查问题

- 当前是在解释输入，还是已经在恢复 transcript？
- 当前是在把远端写成本地文件，还是在构造恢复包？
- 当前空结果该被解释成 startup，还是失败？
- 当前动作发生在 restore 之前，还是在 restore 之后做 message-level 裁剪？
- 我是不是把这页重新写回 162 的 host family 或 160 的 payload taxonomy？

## 5. 源码锚点

- `claude-code-source-code/src/utils/sessionUrl.ts`
- `claude-code-source-code/src/utils/sessionStorage.ts`
- `claude-code-source-code/src/utils/conversationRecovery.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/sessionStart.ts`
