# `activeRemote`、`useDirectConnect`、`useSSHSession`、`useRemoteSession`、`remoteSessionUrl` 与 `directConnectServerUrl` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/138-activeRemote、useDirectConnect、useSSHSession、useRemoteSession、remoteSessionUrl 与 directConnectServerUrl：为什么共用交互壳，不等于共用 remote presence ledger.md`
- `05-控制面深挖/135-createDirectConnectSession、DirectConnectSessionManager、useDirectConnect、remoteSessionUrl 与 replBridgeConnected：为什么 direct connect 更像 foreground remote runtime，而不是 remote presence store.md`

边界先说清：

- 这页不是 REPL 全量 remote 架构图。
- 这页不是 direct connect / ssh / remote session 功能总表。
- 这页只抓 `activeRemote` 为什么是 interaction shell，而不是 presence ledger。

## 1. 三条 remote 线当前更像什么

| 路径 | 当前更像什么 | 为什么 |
| --- | --- | --- |
| `useDirectConnect` | foreground remote runtime shell | 投影 transcript、permission queue、loading，不写 presence ledger |
| `useSSHSession` | foreground remote runtime shell | 与 direct connect 同 shape、同 REPL wiring，只是 transport 不同 |
| `useRemoteSession` | remote-session presence ledger | 会写 `remoteConnectionStatus`、`remoteBackgroundTaskCount`，并被多 surface 消费 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 既然有 `activeRemote`，REPL 已经有统一 remote subsystem | `activeRemote` 只统一交互 API，不统一 presence truth |
| `useDirectConnect` 与 `useSSHSession` 同 shape，就该共享 `--remote` 的 footer / `/session` | shared shell 不等于 shared authority |
| `directConnectServerUrl` 说明 direct connect 已有自己的远端状态账 | 它只是 bootstrap display hint |
| 缺少 dedicated footer / dialog/store，只是 UI 没做 | 缺的是 `remoteSessionUrl / remoteConnectionStatus / remoteBackgroundTaskCount` 这类 authority 字段 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `activeRemote` 统一 `isRemoteMode/sendMessage/cancelRequest/disconnect`；`useDirectConnect` 与 `useSSHSession` 是 sibling shell；`useRemoteSession` 才写 remote presence ledger；`/session` 只认 `remoteSessionUrl` |
| 条件公开 | direct connect / ssh 将来若开始写 authoritative state，才可能并入同一 presence ledger；单独补 badge 不等于 ledger |
| 内部/灰度层 | ssh transport 更细节仍压在 manager/child-process 层；未来 REPL 顶层抽象仍可能演化 |

## 4. 五个检查问题

- 我现在写的是 interaction API，还是 authoritative state ledger？
- 我是不是把 shared hook shape 偷换成了 shared presence truth？
- 我是不是把 bootstrap display hint 当成了 long-lived AppState ledger？
- 我是不是忽略了 REPL 里单独存在的 `isRemoteSession` 线？
- 我是不是把 135 的 direct connect 自身边界拿来重写，而没有真正进入 REPL 顶层 abstraction？

## 5. 源码锚点

- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/hooks/useSSHSession.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/bootstrap/state.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/commands/session/session.tsx`
