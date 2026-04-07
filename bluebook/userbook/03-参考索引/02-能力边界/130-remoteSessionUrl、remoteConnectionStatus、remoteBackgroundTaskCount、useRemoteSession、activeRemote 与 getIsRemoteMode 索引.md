# `remoteSessionUrl`、`remoteConnectionStatus`、`remoteBackgroundTaskCount`、`useRemoteSession`、`activeRemote` 与 `getIsRemoteMode` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/141-remoteSessionUrl、remoteConnectionStatus、remoteBackgroundTaskCount、useRemoteSession、activeRemote 与 getIsRemoteMode：为什么 remote-session presence ledger 不会自动被 direct connect、ssh remote 复用.md`
- `05-控制面深挖/138-activeRemote、useDirectConnect、useSSHSession、useRemoteSession、remoteSessionUrl 与 directConnectServerUrl：为什么共用交互壳，不等于共用 remote presence ledger.md`

边界先说清：

- 这页不是 remote mode 全量对比页。
- 这页不是 `activeRemote` 重复摘要。
- 这页只抓 remote-session presence ledger 为什么本来就不是给 direct connect / ssh remote 复用的。

## 1. 这张账当前最像什么

| 对象 | 当前最像什么 | 为什么 |
| --- | --- | --- |
| `remoteSessionUrl` | remote-session / assistant viewer 的 presence URL | 启动时只在 `--remote` 路径写进初始状态 |
| `remoteConnectionStatus` | viewer WS authoritative state | 只由 `useRemoteSession()` 写入 |
| `remoteBackgroundTaskCount` | viewer 远端 daemon child 的后台任务账 | 只由 `useRemoteSession()` 按远端 task 事件写入 |
| `directConnectServerUrl` | bootstrap display hint | 只说明 direct connect 连到哪，不是 presence ledger |
| `getIsRemoteMode()` | 全局 remote behavior flag | 不是多 surface 共享的 authoritative ledger |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 所有 remote mode 都该共享 `remoteSessionUrl / remoteConnectionStatus / remoteBackgroundTaskCount` | 这些字段本来就服务 `--remote` / assistant viewer presence |
| direct connect 有 `directConnectServerUrl`，所以它只差一步就能算同一张 ledger | `directConnectServerUrl` 只是 bootstrap display hint |
| `getIsRemoteMode()` 为真，就说明 `/session`、footer、brief line 都该自动适配 | 这些 surface 实际认的是 remote-session ledger |
| 没复用这张账，只是 UI backlog | producer、启动路径和 consumer 全都沿 remote-session 边界排布 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 这三个字段当前就是 remote-session / assistant viewer 账本；`useRemoteSession()` 是 producer；footer、brief line、`/session` 只消费这张账；direct connect 只写 `directConnectServerUrl`；`getIsRemoteMode()` 是全局 behavior flag |
| 条件公开 | 将来 direct connect / ssh remote 可以新增自己的 presence ledger；`getIsRemoteMode()` 很容易被误读成 presence 证明；`/session` 命令显隐和 pane 内容已分层 |
| 内部/灰度层 | 远期是否把不同 remote mode 的 presence 账本统一，当前没有稳定承诺；若要统一，必然需要新增 authority 字段与 consumer wiring |

## 4. 五个检查问题

- 我现在写的是 remote interaction，还是 remote presence？
- 我是不是把 bootstrap display hint 偷换成了 authoritative ledger？
- 我是不是把 `getIsRemoteMode()` 写成了 presence truth？
- 我是不是忽略了 footer、brief line、`/session` 实际认的是哪张账？
- 我是不是又回到 138 的 shared interaction shell，而没有真正回答“这张账为什么不通用”？

## 5. 源码锚点

- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/bootstrap/state.ts`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/components/Spinner.tsx`
- `claude-code-source-code/src/commands/session/index.ts`
- `claude-code-source-code/src/commands/session/session.tsx`
