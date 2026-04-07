# `restoredWorkerState`、`externalMetadataToAppState`、`SessionExternalMetadata` 与 `RemoteIO` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/167-restoredWorkerState、externalMetadataToAppState、SessionExternalMetadata 与 RemoteIO：为什么 CCR v2 的 metadata readback 不是 observer metadata 的同一种本地消费合同.md`
- `05-控制面深挖/166-print.ts、externalMetadataToAppState、setMainLoopModelOverride 与 startup fallback：为什么 print remote recovery 的 transcript、metadata 与 emptiness 不是同一种 stage.md`
- `05-控制面深挖/103-pending_action、task_summary、externalMetadataToAppState、state restore 与 stale scrub：为什么 CCR 的 observer metadata 不是同一种恢复面.md`

边界先说清：

- 这页不是 remote recovery 总表。
- 这页不是 cross-frontend consumer 总表。
- 这页只抓 `restoredWorkerState` 的宽 readback、`external_metadata` 的更宽 live publish path，以及当前 `print` 本地 admission gate 的窄消费差异。

## 1. 五层差异

| 层 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| transport capability | 哪类宿主根本拿得到 worker metadata | `StructuredIO.restoredWorkerState`、`RemoteIO` |
| live publish | metadata 如何持续 fan out 到 observer-facing surfaces | `notifySessionMetadataChanged()`、`reportMetadata()` |
| metadata readback | prior worker `external_metadata` 被读回 | `CCRClient.initialize()`、`getWorkerState()` |
| local admission | 哪些 key 真正落到本地状态 | `externalMetadataToAppState()`、`setMainLoopModelOverride()` |
| observer leftovers | 哪些 key 仍停在 bag / cross-surface intent | `pending_action`、`task_summary`、`post_turn_summary` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `external_metadata` 只有一条统一消费链 | live publish path 与 resume-time local refill path 是两层不同合同 |
| 只要有 `restoredWorkerState`，observer metadata 就一起恢复给本地前台 | `restoredWorkerState` 只是 readback capability，本地 admission 仍然很窄 |
| `SessionExternalMetadata` 里有的 key，`print.ts` 都会吃掉 | 当前只接纳 mode / ultraplan，加上单独的 model override |
| `CCRClient.initialize()` 读回旧状态，就代表旧 observer 值值得继续生效 | init 同时显式 scrub stale `pending_action/task_summary` |
| 166 里的 metadata stage 已经覆盖这一页 | 166 讲 stage；156 讲 metadata stage 内部的 readback vs consumption |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `StructuredIO` 默认 `null`、`RemoteIO` 提供 readback、`notifySessionMetadataChanged()` 持续 publish metadata、`externalMetadataToAppState()` 只恢复少数 key |
| 条件公开 | `restoredWorkerState` 只在 CCR v2 remote 路径里真正参与 resume |
| 内部/灰度层 | observer metadata 未来是否有新的 foreground consumer 仍未形成稳定合同 |

## 4. 五个检查问题

- 当前是在拿 transport readback，还是在写本地 `AppState`？
- 当前 key 是 durable-ish config，还是 observer metadata？
- 当前 `print` 真正消费了哪几个 key？
- 我是不是把 readback bag 偷换成了 foreground contract？
- 我是不是把这页重新写回 103/133/137 的更宽 consumer 讨论？

## 5. 源码锚点

- `claude-code-source-code/src/cli/structuredIO.ts`
- `claude-code-source-code/src/cli/remoteIO.ts`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
- `claude-code-source-code/src/state/onChangeAppState.ts`
- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/cli/print.ts`
