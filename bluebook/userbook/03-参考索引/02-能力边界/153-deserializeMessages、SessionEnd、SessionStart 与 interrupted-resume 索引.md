# `deserializeMessages`、`SessionEnd`、`SessionStart` 与 `interrupted-resume` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/164-deserializeMessages、SessionEnd、SessionStart 与 interrupted-resume：为什么恢复前后的合法化、修复与 hook 注入不是同一种 runtime stage.md`
- `05-控制面深挖/160-loadConversationForResume、deserializeMessagesWithInterruptDetection、copyPlanForResume、fileHistoryRestoreStateFromLog 与 processSessionStartHooks：为什么 resume 恢复包不是同一种内容载荷.md`
- `05-控制面深挖/163-print.ts、parseSessionIdentifier、hydrateRemoteSession 与 loadConversationForResume：为什么 print resume 的 parse、hydrate、restore 不是同一种前置阶段.md`

边界先说清：

- 这页不是 payload taxonomy 页。
- 这页不是 host family 页。
- 这页不是 print pre-stage 页。
- 这页只抓恢复边界附近的 runtime staging order。

## 1. 三段式

| 段 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| transcript legalization | 把旧 transcript 修成 API-valid | `deserializeMessagesWithInterruptDetection()` 前半段 |
| interruption repair | 把中断会话改造成可继续的形状 | interruption detection、synthetic continuation、assistant sentinel |
| hook boundary injection | 在 resume 边界前后注入 SessionEnd / SessionStart 运行时产物 | `executeSessionEndHooks()`、`processSessionStartHooks()`、`takeInitialUserMessage()` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| sentinel 也是 transcript 清洗的一部分 | sentinel 更像 repair artifact，为后续 splice / requeue 预留结构 |
| SessionStart hook 只是恢复时附带几条消息 | 它还会产生 additionalContext、initialUserMessage、watchPaths |
| print 路径没有 SessionEnd，所以没有 runtime stage 分层 | print 仍有 legalization、repair、SessionStart 注入与 delayed requeue |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | legalization、repair、hook boundary 三段 |
| 条件公开 | print 路径的 interrupted prompt requeue 需要环境变量开启 |
| 内部/灰度层 | 某些 hook side-effects 与 prompt requeue 细节仍可能继续调整 |

## 4. 五个检查问题

- 当前动作是在修 transcript 合法性，还是在修“中断形状”？
- 当前动作是在旧 transcript 内部完成，还是在 resume 边界新增注入？
- 当前 consumer 是 `messages`，还是 `StructuredIO` / watch paths / side channel？
- interactive 和 print 在 hook 边界上的差异，我有没有写清楚？
- 我是不是把这页重新写回 160 或 163？

## 5. 源码锚点

- `claude-code-source-code/src/utils/conversationRecovery.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/utils/sessionStart.ts`
- `claude-code-source-code/src/utils/hooks.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/types/hooks.ts`
