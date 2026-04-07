# `main.tsx`、`launchResumeChooser`、`ResumeConversation`、`resume.tsx` 与 `REPL.resume` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/161-main.tsx、launchResumeChooser、ResumeConversation、resume.tsx 与 REPL.resume：为什么 --continue、startup picker 与会内 resume 共享恢复合同，却不是同一种入口宿主.md`
- `05-控制面深挖/155-showSetupDialog、renderAndRun、launchResumeChooser、launchRepl、AppStateProvider 与 KeybindingSetup：为什么 setup-dialog host 与 attached REPL host 不是同一种 interactive host.md`
- `05-控制面深挖/158-SessionPreview、loadFullLog、loadConversationForResume、switchSession 与 adoptResumedSessionFile：为什么 resume 的 preview transcript 不是正式 session restore.md`
- `05-控制面深挖/160-loadConversationForResume、deserializeMessagesWithInterruptDetection、copyPlanForResume、fileHistoryRestoreStateFromLog 与 processSessionStartHooks：为什么 resume 恢复包不是同一种内容载荷.md`

边界先说清：

- 这页不是 `/resume` 总表。
- 这页不是 helper family 页。
- 这页不是 payload taxonomy 页。
- 这页只抓相同 restore 合同落在不同入口宿主上的分叉。

## 1. 三类入口宿主

| 宿主 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| startup direct restore host | 启动期直达恢复 | `main.tsx`、`loadConversationForResume()`、`processResumedConversation()`、`launchRepl()` |
| startup chooser host | 启动期先选再恢复 | `launchResumeChooser()`、`ResumeConversation` |
| live command host | 现有 REPL 内原地切换 | `resume.tsx`、`ResumeCommand`、`REPL.resume()` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `--continue`、startup picker、会内 `/resume` 只是不同 UI | 它们处在不同 lifecycle 阶段，宿主责任不同 |
| startup picker 等于 `--continue` 的交互版 | picker 先挂 chooser host，再决定目标 |
| 会内 `/resume` 只是再调一次 startup resume | 它还要处理当前 live session 的收尾与切换 |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | startup direct restore、startup chooser、live `/resume` command |
| 条件公开 | 某些 `--resume` 参数会先解析为 session/file/search term，再决定是 direct 还是 chooser |
| 内部/灰度层 | `print.ts` / headless 路径同样共享恢复合同，但这页只聚焦 interactive host family |

## 4. 五个检查问题

- 当前路径发生时，REPL 已经存在了吗？
- 当前路径要不要先选会话？
- 恢复逻辑是在 REPL mount 前完成，还是在 live REPL 中完成？
- 当前宿主是否需要处理 session-end / loading reset 等 live 切换责任？
- 我是不是把 155 的 helper family 和这页的 host role 混写了？

## 5. 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/dialogLaunchers.tsx`
- `claude-code-source-code/src/screens/ResumeConversation.tsx`
- `claude-code-source-code/src/commands/resume/resume.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/replLauncher.tsx`
