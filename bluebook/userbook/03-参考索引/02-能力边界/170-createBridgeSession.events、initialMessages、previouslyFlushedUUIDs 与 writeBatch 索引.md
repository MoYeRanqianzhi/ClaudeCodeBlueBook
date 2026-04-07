# `createBridgeSession.events`、`initialMessages`、`previouslyFlushedUUIDs` 与 `writeBatch` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/181-createBridgeSession.events、initialMessages、previouslyFlushedUUIDs 与 writeBatch：为什么 session-create events 不是 remote-control 历史回放机制.md`
- `05-控制面深挖/54-transport rebuild、initial flush、flush gate 与 sequence resume：为什么 CCR v2 remote bridge 的重建 transport、历史续接与 connected 不是同一步.md`
- `05-控制面深挖/37-single-session、same-dir、worktree、capacity、create-session-in-dir 与 w：为什么 standalone remote-control 的 spawn topology、并发上限与前台 cwd 会话不是同一种调度.md`

边界先说清：

- 这页不是完整 bridge reconnect / flush 状态机图。
- 这页不是 initial session title / cwd anchor 页。
- 这页只抓 create-time `events` 与 post-connect history flush 的合同分裂。

## 1. 两种 contract

| 对象 | 当前更像什么 | 关键消费面 |
| --- | --- | --- |
| `createBridgeSession.events` | session birth payload slot | `POST /v1/sessions` |
| `initialMessages` + `writeBatch(...)` | history hydrate path | ingress transport `onConnect` flush |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| REPL 有 `initialMessages`，所以建会话时自然会把它们转成 `events` | 当前 wrapper 明确传 `events: []` |
| create request 的 `events` 就是 bridge 历史回放机制 | 历史回放走 post-connect ingress flush |
| `previouslyFlushedUUIDs` 记录的是 create-time event 成功发送 | 它记录的是 later flush 已落库的历史消息 |
| empty initial session 只是没有历史的同一种 create-with-history | empty session seed 与 history hydrate 是两段合同 |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | bridge caller 现在都传 `events: []`；历史通过 ingress `writeBatch(...)` flush；`connected` 延后到 history persisted 之后 |
| 条件公开 | `initialHistoryCap` 收窄、`previouslyFlushedUUIDs` 过滤、perpetual prior session 的跳过逻辑 |
| 内部/灰度层 | batch dropped 细节、retry / reconnect 细节、recentPostedUUIDs 的具体实现 |

## 4. 五个检查问题

- 当前逻辑是在让 session object 出生，还是在补写既有历史？
- 当前写入走的是 create request `events`，还是 ingress transport `writeBatch(...)`？
- 当前 dedup ledger 记录的是 create-time birth，还是 later history hydrate？
- 我是不是把 37 / 39 的 initial empty session 误写成 history replay 机制？
- 我是不是又把这页写回 54 的 transport continuity，而没保留 create-vs-hydrate 主语？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/createSession.ts`
- `claude-code-source-code/src/bridge/initReplBridge.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
