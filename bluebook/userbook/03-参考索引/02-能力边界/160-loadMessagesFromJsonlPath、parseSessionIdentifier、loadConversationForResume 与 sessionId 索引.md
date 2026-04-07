# `loadMessagesFromJsonlPath`、`parseSessionIdentifier`、`loadConversationForResume` 与 `sessionId` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/171-loadMessagesFromJsonlPath、parseSessionIdentifier、loadConversationForResume 与 sessionId：为什么 print --resume .jsonl 与 print --resume session-id 不是同一种 local artifact provenance.md`
- `05-控制面深挖/170-print --continue、print --resume session-id、print --resume url 与 loadConversationForResume：为什么同属 headless resume，也不是同一种 source certainty.md`
- `05-控制面深挖/163-print.ts、parseSessionIdentifier、hydrateRemoteSession 与 loadConversationForResume：为什么 print resume 的 parse、hydrate、restore 不是同一种前置阶段.md`

边界先说清：

- 这页不是更宽的 headless source-certainty 页。
- 这页不是 print 内部 stage taxonomy 页。
- 这页只抓 explicit local artifact family 内部的 provenance 差异。

## 1. 两种 provenance

| provenance | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| session-registry-backed local artifact | 直接按 UUID 去当前项目 registry 找会话 | `print --resume session-id`、`getLastSessionLog()` |
| transcript-file-backed local artifact | 先读 `.jsonl` 文件，再按 leaf tip 构链并推断 sessionId | `print --resume .jsonl`、`loadMessagesFromJsonlPath()` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `.jsonl` 与 `session-id` 只是同一显式输入的两种写法 | 同属 explicit local branch，但 provenance 不同 |
| `.jsonl` 只是把 session-id 放进文件里 | `.jsonl` 的 sessionId 还要从 transcript tip 推断 |
| 一旦都进入 `loadConversationForResume()`，就已经没有本质差异 | formal restore 合同共享，不等于 upstream artifact provenance 相同 |
| `.jsonl` 也该和 URL 一起算 remote source | `.jsonl` 仍是 local artifact family |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `print --resume session-id`、`print --resume .jsonl` |
| 条件公开 | 无 |
| 内部/灰度层 | transcript tip 选取、random UUID 占位、chain-building 细节 |

## 4. 五个检查问题

- 当前 artifact provenance 是 registry，还是 transcript file？
- 当前 `sessionId` 是来自 CLI 参数，还是来自 transcript tip？
- 当前只是共享 formal restore 合同，还是共享整个 provenance？
- 我是不是把 `.jsonl` 错写成了 remote source？
- 我是不是又把这页写回 170 的 certainty ladder？

## 5. 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/sessionUrl.ts`
- `claude-code-source-code/src/utils/conversationRecovery.ts`
