# `StructuredIO`、`RemoteIO`、`setInternalEventReader`、`setInternalEventWriter` 与 `flushInternalEvents` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/168-StructuredIO、RemoteIO、setInternalEventReader、setInternalEventWriter 与 flushInternalEvents：为什么 headless transport 的协议宿主不等于同一种恢复厚度.md`
- `05-控制面深挖/20-Headless 启动链、首问就绪与 StructuredIO：为什么 print 不是没有 UI 的 REPL.md`
- `05-控制面深挖/167-restoredWorkerState、externalMetadataToAppState、SessionExternalMetadata 与 RemoteIO：为什么 CCR v2 的 metadata readback 不是 observer metadata 的同一种本地消费合同.md`

边界先说清：

- 这页不是 headless vs interactive host taxonomy。
- 这页不是 worker lifecycle 页。
- 这页只抓同属 headless protocol family 时，`StructuredIO` 与 `RemoteIO` 的恢复厚度差异。

## 1. 三层厚度

| 层 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| protocol runtime | headless turn 能不能说结构化控制协议 | `StructuredIO`、`RemoteIO` |
| recovery ledger | transcript / subagent state 能不能写进并读回 internal event ledger | `setInternalEventReader()`、`setInternalEventWriter()`、`hydrateFromCCRv2InternalEvents()` |
| persistence backpressure | shutdown / idle 前会不会显式观测并冲刷恢复账 | `flushInternalEvents()`、`internalEventsPending` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `RemoteIO` 只是远端版 `StructuredIO` | `RemoteIO` 在同一家族里额外加上 recovery ledger 厚度 |
| 能跑 headless protocol，就说明 resume 厚度也一样 | protocol runtime 与 recovery ledger 是两层合同 |
| `flushInternalEvents()` 只是 finally 里的实现噪音 | 它是 persistence backpressure 进入 runtime close discipline 的证据 |
| internal events 只是另一种前台消息流 | `writeInternalEvent()` / `readInternalEvents()` 明确服务 resume，且不面向 frontend clients |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `StructuredIO` 默认无 readback/flush/pending 厚度；`RemoteIO` 会 override 这些能力；`print.ts` 在 idle 前 flush internal events |
| 条件公开 | 这条厚度主要成立于 CCR v2 remote/headless transport |
| 内部/灰度层 | flush interval、pending count、pagination/retry 和 payload 细节仍是实现层 |

## 4. 五个检查问题

- 当前讨论的是 protocol shell，还是 recovery ledger？
- 当前对象是 client-visible stream，还是 resume-only internal ledger？
- 当前能力只保证能跑 turn，还是还能恢复 subagent transcript？
- 当前 shutdown 只是关输出，还是还要等恢复账冲刷？
- 我是不是又把这页写回 20、50、167 的主轴？

## 5. 源码锚点

- `claude-code-source-code/src/cli/structuredIO.ts`
- `claude-code-source-code/src/cli/remoteIO.ts`
- `claude-code-source-code/src/utils/sessionStorage.ts`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
- `claude-code-source-code/src/cli/print.ts`
