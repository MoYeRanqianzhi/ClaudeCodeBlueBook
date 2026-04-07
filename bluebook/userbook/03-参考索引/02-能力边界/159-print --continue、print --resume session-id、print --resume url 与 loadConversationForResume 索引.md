# `print --continue`、`print --resume session-id`、`print --resume url` 与 `loadConversationForResume` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/170-print --continue、print --resume session-id、print --resume url 与 loadConversationForResume：为什么同属 headless resume，也不是同一种 source certainty.md`
- `05-控制面深挖/169-resume、--continue、print --resume 与 remote-control --continue：为什么 stable conversation resume、headless remote hydrate 与 bridge continuity 不是同一种接续来源.md`
- `05-控制面深挖/163-print.ts、parseSessionIdentifier、hydrateRemoteSession 与 loadConversationForResume：为什么 print resume 的 parse、hydrate、restore 不是同一种前置阶段.md`

边界先说清：

- 这页不是更宽的 source family 页。
- 这页不是 print 内部 stage taxonomy 页。
- 这页只抓同属 `print` host 时，resume source certainty 为什么仍然不同。

## 1. 三层 certainty

| 层 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| implicit recent local | 自动继续最近本地会话 | `print --continue`、`loadConversationForResume(undefined, undefined)` |
| explicit local artifact | 用户指定本地 session / `.jsonl` | `print --resume session-id`、`print --resume .jsonl`、`parseSessionIdentifier()` |
| conditional remote materialization | 先 remote hydrate，再 formal restore | `print --resume url`、`hydrateFromCCRv2InternalEvents()`、`hydrateRemoteSession()` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `print --continue` 和 `print --resume` 只是自动/手动之分 | 同属 headless host，但 source certainty 也不同 |
| `print --resume session-id` 和 `print --resume url` 都是显式指定来源 | 一个是 explicit local artifact，一个是 conditional remote source |
| `print --resume url` 只要成功进入 resume 分支，就一定恢复旧对话 | 它还可能因为空内容落成 startup |
| `.jsonl` 和 URL 都算“外部来源” | `.jsonl` 仍是本地显式 artifact family |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `print --continue`、`print --resume session-id`、`print --resume .jsonl` |
| 条件公开 | `print --resume url` 的 remote hydrate / fallback 分支 |
| 内部/灰度层 | CCR v2 specific hydrate、`restoredWorkerState` 和相关 transport thickness |

## 4. 五个检查问题

- 当前 source 是 recent local、explicit local，还是 remote materialization？
- 当前 certainty 是默认最近，还是用户显式指定？
- 当前失败会直接报错，还是可能退成 startup？
- 我是不是把 `.jsonl` 错写成了 remote source？
- 我是不是又把这页写回 163 或 169？

## 5. 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/sessionUrl.ts`
- `claude-code-source-code/src/utils/sessionStorage.ts`
