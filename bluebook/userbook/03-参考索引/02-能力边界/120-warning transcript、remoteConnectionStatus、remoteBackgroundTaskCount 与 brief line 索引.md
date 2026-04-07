# `warning` transcript、`remoteConnectionStatus`、`remoteBackgroundTaskCount` 与 brief line 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/131-warning transcript、remoteConnectionStatus、remoteBackgroundTaskCount 与 brief line：为什么 remote session 的四类可见信号分属四张账，而不是同一张 remote status table.md`
- `05-控制面深挖/122-timeout watchdog、reconnect warning、reconnecting 与 disconnected：为什么 remote session 的 recovery lifecycle 不是同一种状态.md`
- `05-控制面深挖/130-remoteSessionUrl、brief line、bridge pill、bridge dialog 与 attached viewer：为什么它们不是同一种 surface presence.md`

边界先说清：

- 这页不是 remote surface presence 页。
- 这页不替代 122 的 recovery lifecycle 页。
- 这页不替代 130 的 surface presence 页。
- 这页只抓 remote session 的四类可见信号为什么不是同一张 status table。

## 1. 四张账

| 对象 | 当前写入哪里 | 当前回答什么 |
| --- | --- | --- |
| `warning transcript` | `messages` | 本地 watchdog 是否正在发起补救提示 |
| `remoteConnectionStatus` | `AppState` | WS lifecycle 当前阶段 |
| `remoteBackgroundTaskCount` | `AppState` | 远端事件流所见的活跃任务数 |
| brief line | UI summary projection | 把前两张账的一部分压成最小前台摘要 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| transcript 里的 warning 就等于 `remoteConnectionStatus='reconnecting'` | warning 和 connection status 不是同一写路径 |
| 没有 warning 就说明连接一直健康 | `viewerOnly` 可以有 brief reconnect 却没有 watchdog warning |
| `remoteBackgroundTaskCount` 就是 `AppState.tasks` 的长度 | remote count 属于远端子任务事件账 |
| brief line 就是完整 remote 真相面 | brief line 是 lossy summary projection |
| 这四样都写在一张状态表里 | warning 当前写在 `messages`，其余三样不是同一种 ledger |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | warning 属于 transcript；`remoteConnectionStatus` / `remoteBackgroundTaskCount` 属于独立 `AppState` 槽位；brief line 只消费状态 |
| 条件公开 | warning 会跳过 `viewerOnly`；remote task count 是 best-effort；brief line 只在 brief-only idle 条件满足时出现，且隐藏 `connecting` / `connected` |
| 内部/灰度层 | `scheduleReconnect()` / `reconnect()` 细节；warning 与 conn status 的短暂失配；brief aggregate 的具体合并公式 |

## 4. 五个检查问题

- 我现在写的是 transcript 账，还是 `AppState` 槽位？
- 我是不是把 remote task count 写成了本地任务表？
- 我是不是把 brief line 当成了完整 truth surface？
- 我是不是把 `viewerOnly` 的 absence 错写成了 recovery 不存在？
- 我是不是把 122 的生命周期问题又写回成 131 的账本问题？

## 5. 源码锚点

- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
- `claude-code-source-code/src/components/Spinner.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/utils/messages.ts`
- `claude-code-source-code/src/utils/task/framework.ts`
- `claude-code-source-code/src/components/messages/SystemTextMessage.tsx`
