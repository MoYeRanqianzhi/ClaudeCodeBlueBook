# `main.tsx`、`print.ts`、`loadInitialMessages`、`ResumeConversation` 与 `REPL.resume` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/162-main.tsx、print.ts、loadInitialMessages、ResumeConversation 与 REPL.resume：为什么 interactive resume host 与 headless print host 共享恢复语义，却不是同一种宿主族.md`
- `05-控制面深挖/161-main.tsx、launchResumeChooser、ResumeConversation、resume.tsx 与 REPL.resume：为什么 --continue、startup picker 与会内 resume 共享恢复合同，却不是同一种入口宿主.md`
- `05-控制面深挖/160-loadConversationForResume、deserializeMessagesWithInterruptDetection、copyPlanForResume、fileHistoryRestoreStateFromLog 与 processSessionStartHooks：为什么 resume 恢复包不是同一种内容载荷.md`

边界先说清：

- 这页不是 CLI 根入口总表。
- 这页不是 interactive 宿主内部的入口分叉页。
- 这页不是 remote-control / bridge host 页。
- 这页只抓 interactive TUI resume host family 与 headless print host family 的差异。

## 1. 两类宿主族

| 宿主族 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| interactive TUI resume hosts | 恢复后进入或重写 `<REPL />` | `main.tsx`、`launchResumeChooser()`、`ResumeConversation`、`REPL.resume()`、`launchRepl()` |
| headless print resume hosts | 恢复后进入 `StructuredIO` / print pipeline | `print.ts`、`loadInitialMessages()`、`StructuredIO` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| print resume 是无 UI 版 interactive resume | 它共享恢复语义，但下游消费者不是 REPL |
| startup picker 和 print loader 都只是“先加载消息” | picker 最终挂 REPL，print loader 只返回 `LoadInitialMessagesResult` |
| shared restore contract = same host family | 恢复合同可以复用，但宿主壳和执行循环仍然不同 |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | interactive TUI resume family；print/headless resume family |
| 条件公开 | `print.ts` 的某些 resume 分支还会先做 remote hydration / session-id parsing |
| 内部/灰度层 | 某些 headless remote hydration 分支和 URL resume 细节仍可能继续调整 |

## 4. 五个检查问题

- 当前恢复结果是喂给 `<REPL />`，还是喂给 `StructuredIO`？
- 当前宿主有没有 Ink root / chooser / render loop？
- 当前路径会不会进入 `launchRepl()`？
- 当前路径是否需要处理 live REPL session unwind？
- 我是不是把这页重新写回 161 的 interactive host segmentation？

## 5. 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/replLauncher.tsx`
- `claude-code-source-code/src/dialogLaunchers.tsx`
- `claude-code-source-code/src/screens/ResumeConversation.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/cli/print.ts`
