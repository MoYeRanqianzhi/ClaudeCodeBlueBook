# `writeMessages`、`writeSdkMessages`、`initialMessageUUIDs`、`recentPostedUUIDs` 与 `flushGate` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/190-writeMessages、writeSdkMessages、initialMessageUUIDs、recentPostedUUIDs 与 flushGate：为什么 REPL path 与 daemon path 不是同一种 bridge write contract.md`
- `05-控制面深挖/55-received、processing、processed、lastWrittenIndexRef、recentPostedUUIDs、recentInboundUUIDs 与 sentUUIDsRef：为什么 remote bridge 的送达回执、增量转发、echo 过滤与重放防重不是同一种去重.md`
- `05-控制面深挖/189-reusedPriorSession、previouslyFlushedUUIDs、createCodeSession 与 flushHistory：为什么 v1 continuity ledger 与 v2 fresh-session replay 不是同一种 history contract.md`

边界先说清：

- 这页不是 dedup family 总页。
- 这页不是 continuity ledger 总页。
- 这页只抓 REPL `writeMessages(...)` 与 daemon `writeSdkMessages(...)` 的 write contract 分裂。

## 1. 两条写入合同

| 对象 | 当前更像什么 | 关键位置 |
| --- | --- | --- |
| `writeMessages(...)` | REPL/internal-message write contract | bridge handles |
| `writeSdkMessages(...)` | daemon/direct-SDK write contract | bridge handles |
| `initialMessageUUIDs` / `flushGate` | REPL-only startup-write semantics | REPL path |
| `recentPostedUUIDs` | shared echo suppress layer | both paths |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 两个 write 函数最后都 `writeBatch`，所以本质相同 | 它们共享 sink，但不共享 write contract |
| daemon path 只是少了一步转换 | 它连 `initialMessageUUIDs` filter 和 `flushGate` 语义都没有 |
| 共享 `recentPostedUUIDs` 就说明 contract 相同 | 共享的只是 echo suppress 层 |
| `initialMessageUUIDs` 是 bridge 写入口的通用条件 | 它只属于 REPL path 的 initial-history suppress |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | REPL/internal-message contract != daemon/direct-SDK contract |
| 条件公开 | daemon path 无 `initialMessages`、无 `flushGate`、无转换 |
| 内部/灰度层 | continuity inheritance、inbound edge cases、viewer-side render contract |

## 4. 五个检查问题

- 我现在说的是 write contract，还是 dedup family / continuity contract？
- 我是不是把 shared `recentPostedUUIDs` 误写成 same contract？
- 我是不是把 `writeSdkMessages(...)` 缩成“只是 skip conversion”？
- 我是不是忘了 `flushGate` 只属于 REPL path？
- 我是不是又回卷到 55 或 189 的主语了？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/replBridge.ts`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts`
