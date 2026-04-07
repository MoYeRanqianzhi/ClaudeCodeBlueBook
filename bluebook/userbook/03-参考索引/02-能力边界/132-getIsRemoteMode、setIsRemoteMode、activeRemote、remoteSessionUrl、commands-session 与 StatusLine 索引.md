# `getIsRemoteMode`、`setIsRemoteMode`、`activeRemote`、`remoteSessionUrl`、`commands/session` 与 `StatusLine` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/143-getIsRemoteMode、setIsRemoteMode、activeRemote、remoteSessionUrl、commands-session 与 StatusLine：为什么全局 remote behavior 开关，不等于 remote presence truth.md`
- `05-控制面深挖/141-remoteSessionUrl、remoteConnectionStatus、remoteBackgroundTaskCount、useRemoteSession、activeRemote 与 getIsRemoteMode：为什么 remote-session presence ledger 不会自动被 direct connect、ssh remote 复用.md`

边界先说清：

- 这页不是 remote ledger 总表。
- 这页不是 141 的重复摘要。
- 这页只抓 `getIsRemoteMode()` 为什么是 global behavior switch，而不是 presence truth。

## 1. 三层 remote 语义

| 层 | 当前更像什么 | 例子 |
| --- | --- | --- |
| turn-level interaction | remote shell | `activeRemote.isRemoteMode` |
| global behavior environment | global remote flag | `getIsRemoteMode()` |
| authoritative presence | remote-session ledger | `remoteSessionUrl / remoteConnectionStatus / remoteBackgroundTaskCount` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `getIsRemoteMode()` 被很多地方看，所以它就是系统里的 remote truth | 它只提供布尔环境位，不提供 presence 细节 |
| `activeRemote.isRemoteMode` 为真，`getIsRemoteMode()` 就该同步为真 | 前者是 turn shell，后者是 global behavior flag |
| `/session` 能显示出来，就说明当前一定有 remote-session presence 可看 | 命令显隐和 pane 内容是双重 gate |
| `getIsRemoteMode()` 和 `remoteSessionUrl` 只是同一状态源的粗细不同投影 | 一个是布尔环境位，一个是 presence field |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `getIsRemoteMode()` / `setIsRemoteMode()` 当前只是 bootstrap 布尔位；remote-session 路径会写它；direct connect 当前不写；多个 consumer 只把它当 behavior branch；`/session` 用双重 gate |
| 条件公开 | 将来更多 remote mode 可写这个开关，但仍不自动成为 presence truth；广泛 consumer 会持续制造误读空间 |
| 内部/灰度层 | 当前没有公开承诺它永远只限 behavior flag；它和 presence ledger 的分层更多是实现事实 |

## 4. 五个检查问题

- 我现在写的是全局行为开关，还是 authoritative presence truth？
- 我是不是把“消费者很多”偷换成了“描述力足够强”？
- 我是不是把 `activeRemote.isRemoteMode` 和 `getIsRemoteMode()` 写成了同一层？
- 我是不是忽略了 `/session` 的双重 gate？
- 我是不是又回到 141 的 ledger 页面，而没真正回答“为什么这个布尔位不是账”？

## 5. 源码锚点

- `claude-code-source-code/src/bootstrap/state.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/notifs/useStartupNotification.ts`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/components/StatusLine.tsx`
- `claude-code-source-code/src/commands/session/index.ts`
- `claude-code-source-code/src/commands/session/session.tsx`
