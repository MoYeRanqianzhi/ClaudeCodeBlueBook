# `forkSession`、`switchSession`、`copyPlanForFork`、`restoreWorktreeForResume` 与 `adoptResumedSessionFile` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/159-forkSession、switchSession、copyPlanForFork、restoreWorktreeForResume 与 adoptResumedSessionFile：为什么 --fork-session 不是较弱的原会话恢复，而是新 session 分叉.md`
- `05-控制面深挖/158-SessionPreview、loadFullLog、loadConversationForResume、switchSession 与 adoptResumedSessionFile：为什么 resume 的 preview transcript 不是正式 session restore.md`
- `05-控制面深挖/157-getSessionFilesLite、enrichLogs、LogSelector、SessionPreview 与 loadFullLog：为什么 resume 的列表摘要面不是 preview transcript.md`

边界先说清：

- 这页不是 `/resume` 总表。
- 这页不是 preview transcript 与 formal restore 的差异页。
- 这页只抓 `--fork-session` 与普通 restore 的 ownership 分叉。

## 1. 两条恢复合同

| 路径 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| 普通 resume | 取回原 session ownership | `switchSession()`、`restoreWorktreeForResume()`、`adoptResumedSessionFile()` |
| `--fork-session` | 基于旧载荷启动的新 session 分叉 | `forkSession`、`copyPlanForFork()`、`recordContentReplacement()` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `--fork-session` 只是换个新 id 的 resume | 它保留新 session 身份，并拒绝接管原 transcript / worktree ownership |
| fork 会复用原 plan | fork 复制 plan 内容，但生成新 slug |
| fork 只是少做了一点恢复 | fork 对 sidecar state 做的是重新绑定，不是原 ownership 接管 |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | normal restore adopt 原 transcript；fork 保留新 session 身份 |
| 条件公开 | `--session-id` 只有和 `--fork-session` 搭配时才允许给 fork 指定新 id |
| 内部/灰度层 | 某些 sidecar state 的迁移范围仍可能继续调整，但 ownership 分叉已经很明确 |

## 4. 五个检查问题

- 当前路径会不会 `switchSession()` 到原 session？
- 当前 plan slug 是复用原值，还是 fork 出新值？
- 当前 `contentReplacements` 是继续挂在原 session 下，还是重写到新 session 下？
- 当前会不会恢复原 `worktreeSession`？
- 当前会不会 `adoptResumedSessionFile()` 把后续写入重新绑定到原 transcript？

## 5. 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/utils/sessionRestore.ts`
- `claude-code-source-code/src/screens/ResumeConversation.tsx`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/plans.ts`
- `claude-code-source-code/src/utils/sessionStorage.ts`
