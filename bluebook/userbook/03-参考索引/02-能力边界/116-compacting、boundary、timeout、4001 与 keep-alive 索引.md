# `compacting`、boundary、timeout、`4001` 与 keep-alive 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/127-compacting、boundary、timeout、4001 与 keep-alive：为什么 compaction recovery contract 不是同一种恢复信号.md`
- `05-控制面深挖/67-slash_commands、stream_event、task_started 与 status_compacting：为什么 remote session 的命令集、流式正文、后台计数与 timeout 策略不是同一种消费者.md`
- `05-控制面深挖/126-PERMANENT_CLOSE_CODES、4001 与 reconnect budget：为什么 terminality policy 不是同一种 stop rule.md`

边界先说清：

- 这页不是消费者分流页。
- 这页不替代 67。
- 这页不替代 126 的 terminality taxonomy。
- 这页只抓 compaction 恢复相关的五个对象为什么不是同一种恢复信号。

## 1. 五种 compaction signal

| signal | 当前回答什么 | 典型位置 |
| --- | --- | --- |
| progress/status | 当前是否正处于 compacting 窗口 | `status='compacting'` |
| keep-alive | 如何避免 warning / stale | re-emit `compacting` + worker heartbeat |
| patience policy | 本地 watchdog 在此窗口有多耐心 | `COMPACTION_TIMEOUT_MS` |
| transport exception | stale-window 下如何对待 `4001` | `MAX_SESSION_NOT_FOUND_RETRIES` |
| rewrite completion | transcript rewrite 何时真正收口 | `compact_boundary` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `status=compacting` 就是完整 compaction recovery 状态 | 它只是 progress/status signal |
| 重复 `compacting` 说明状态继续推进 | 这里更重要的是 keep-alive 语义 |
| `COMPACTION_TIMEOUT_MS` 是远端状态的一部分 | 它是本地 watchdog 的 patience policy |
| `4001` 是 compacting 的另一种状态词 | 它是 stale-window exception |
| `compact_boundary` 只是又一条状态消息 | 它是 transcript rewrite completion marker |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | compaction 当前会发 `status='compacting'` 与 `compact_boundary`；hook 当前会在 compacting 窗口切到 `COMPACTION_TIMEOUT_MS`；`4001` 当前在 SessionsWebSocket 内被 special-handle |
| 条件公开 | repeated `compacting` 的 keep-alive 语义依赖当前 compaction 路径；`4001` 的 special retry 建立在 stale-window / compaction 语境上；`preserved_segment` 只在某些 compact 形态下存在 |
| 内部/灰度层 | keep-alive cadence、timeout 常量、retry 次数、sessionActivity gate、另一层 transport 对 `4001` 的不同语义 |

## 4. 五个检查问题

- 我现在写的是 progress/status、keep-alive、patience、stale exception，还是 completion？
- 我是不是把 `4001` 写成了普通 reconnect 或另一层 UI？
- 我是不是把 `compact_boundary` 写成了“还在 compacting”的证明？
- 我是不是把本地 timeout policy 写成了远端状态？
- 我是不是把当前常量和 cadence 写成了稳定合同？

## 5. 源码锚点

- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/services/compact/compact.ts`
- `claude-code-source-code/src/remote/SessionsWebSocket.ts`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
- `claude-code-source-code/src/QueryEngine.ts`
