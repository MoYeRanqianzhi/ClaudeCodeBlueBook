# `initialMessageUUIDs`、`previouslyFlushedUUIDs`、`createBridgeSession.events` 与 `writeBatch` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/183-initialMessageUUIDs、previouslyFlushedUUIDs、createBridgeSession.events 与 writeBatch：为什么注释里的 session creation events 不等于 bridge 的真实历史账.md`
- `05-控制面深挖/181-createBridgeSession.events、initialMessages、previouslyFlushedUUIDs 与 writeBatch：为什么 session-create events 不是 remote-control 历史回放机制.md`
- `05-控制面深挖/55-received、processing、processed、lastWrittenIndexRef、recentPostedUUIDs、recentInboundUUIDs 与 sentUUIDsRef：为什么 remote bridge 的送达回执、增量转发、echo 过滤与重放防重不是同一种去重.md`

边界先说清：

- 这页不是 bridge anti-dup 全景图。
- 这页不是 birth-vs-hydrate 总页。
- 这页只抓 `initialMessageUUIDs` 注释语义与真实 history delivery ledger 的错位。

## 1. 三种对象

| 对象 | 当前更像什么 | 关键消费面 |
| --- | --- | --- |
| `createBridgeSession.events` | create-time wire slot | `POST /v1/sessions` |
| `initialMessageUUIDs` | startup local dedup seed | `writeMessages()` / `recentPostedUUIDs` seeding |
| `previouslyFlushedUUIDs` | real history delivery ledger | post-`writeBatch(...)` success |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `initialMessageUUIDs` 就是建会话时已送达的历史集合 | 它只是从 `initialMessages` 派生的 local seed |
| 旧注释里的 session creation events 可以作为当前实现证据 | 那句注释已经落后于现在的 flush path |
| `initialMessageUUIDs` 与 `previouslyFlushedUUIDs` 只是同一张账的不同副本 | 一个是 startup seed，一个是 flush-success ledger |
| 只要 `writeMessages()` 检查了它，就说明 server 早已吃进这些消息 | `writeMessages()` 的本地防重不等于 remote delivery truth |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | `events` 不承担当前 bridge 初始历史；`initialMessageUUIDs` = local seed；`previouslyFlushedUUIDs` = success ledger |
| 条件公开 | `droppedBatchCount` 不增加时才标记 flushed；eligible / capped initial history |
| 内部/灰度层 | `recentPostedUUIDs` 容量、reconnect 重跑细节、viewer 侧并行 dedup |

## 4. 五个检查问题

- 当前集合是在描述本地已知初始历史，还是描述已成功送达的历史？
- 当前逻辑发生在 startup seed 阶段，还是在 `writeBatch(...)` 成功之后？
- 我是不是把旧注释当成当前 delivery path 的证据？
- 我是不是又把这页写回 55 的 anti-dup 总论？
- 我是不是又把这页写回 181 的 create-vs-hydrate 总论？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/replBridge.ts`
- `claude-code-source-code/src/bridge/createSession.ts`
- `claude-code-source-code/src/bridge/initReplBridge.ts`
