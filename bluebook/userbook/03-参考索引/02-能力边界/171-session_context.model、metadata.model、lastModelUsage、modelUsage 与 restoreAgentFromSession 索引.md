# `session_context.model`、`metadata.model`、`lastModelUsage`、`modelUsage` 与 `restoreAgentFromSession` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/182-session_context.model、metadata.model、lastModelUsage、modelUsage 与 restoreAgentFromSession：为什么 create-time model stamp、live override shadow、durable usage ledger 与 resumed-agent fallback 不是同一种 model ledger.md`
- `05-控制面深挖/107-model、externalMetadataToAppState、setMainLoopModelOverride 与 restoredWorkerState：为什么 metadata 里的 model 不是普通 AppState 回填项.md`
- `05-控制面深挖/152-sessionStorage、hydrateFromCCRv2InternalEvents、sessionRestore、listSessionsImpl、SessionPreview 与 sessionTitle：为什么 durable session metadata 不是 live system-init，也不是 foreground external-metadata.md`

边界先说清：

- 这页不是完整 model setting precedence 手册。
- 这页不是 observer metadata readback 总页。
- 这页只抓 stamp / shadow / usage / fallback 四张 model ledger。

## 1. 四张 model ledger

| 对象 | 当前更像什么 | 关键消费面 |
| --- | --- | --- |
| `session_context.model` | create-time stamp | `createBridgeSession(...)` |
| `metadata.model` | live override shadow / readback | `notifySessionMetadataChanged(...)` / remote restore |
| `STATE.modelUsage` / `lastModelUsage` | durable per-model usage ledger | cost-tracker / project config |
| `restoreAgentFromSession(...).model` | resumed-agent fallback | session resume |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `session_context.model` 就是当前 session 的 authoritative model | 它只是 create-time stamp |
| `metadata.model` 与 `lastModelUsage` 都是 model restore 值 | 一个是 live shadow，一个是 per-model usage ledger |
| `restoreAgentFromSession(...)` 也在恢复同一张 model 账 | 它只是无更强主权时的 fallback source |
| 只要字段都叫 model，就共享同一种 ledger | stamp / shadow / accounting / fallback 分属不同对象层 |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | `session_context.model` = stamp；`metadata.model` = live shadow；`STATE.modelUsage`/`lastModelUsage` = usage ledger；agent restore = fallback |
| 条件公开 | remote restore 何时读回 `metadata.model`、`lastSessionId` 匹配时才恢复 `lastModelUsage` |
| 内部/灰度层 | `activeUserSpecifiedModel`、stats cache、将来 helper 是否消费 `session_context.model` |

## 4. 五个检查问题

- 当前字段在回答 create-time stamp、live override、durable usage，还是 resumed-agent fallback？
- 当前逻辑是在恢复运行时 model，还是在恢复 per-model cost ledger？
- 我是不是把 `metadata.model` 又写回 107 那种 AppState mapper 问题？
- 我是不是把 `lastModelUsage` 误写成当前 main loop 应使用的 model？
- 我是不是把 `restoreAgentFromSession(...)` 误写成另一张 durable ledger？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/createSession.ts`
- `claude-code-source-code/src/utils/model/model.ts`
- `claude-code-source-code/src/state/onChangeAppState.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
- `claude-code-source-code/src/cost-tracker.ts`
- `claude-code-source-code/src/bootstrap/state.ts`
- `claude-code-source-code/src/utils/sessionRestore.ts`
