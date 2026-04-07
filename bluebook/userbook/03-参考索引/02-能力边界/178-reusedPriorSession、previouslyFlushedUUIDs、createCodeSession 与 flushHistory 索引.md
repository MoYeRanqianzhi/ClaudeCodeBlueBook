# `reusedPriorSession`、`previouslyFlushedUUIDs`、`createCodeSession` 与 `flushHistory` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/189-reusedPriorSession、previouslyFlushedUUIDs、createCodeSession 与 flushHistory：为什么 v1 continuity ledger 与 v2 fresh-session replay 不是同一种 history contract.md`
- `05-控制面深挖/183-initialMessageUUIDs、previouslyFlushedUUIDs、createBridgeSession.events 与 writeBatch：为什么注释里的 session creation events 不等于 bridge 的真实历史账.md`
- `05-控制面深挖/186-initialHistoryCap、isEligibleBridgeMessage、toSDKMessages 与 local_command：为什么 bridge 的 eligible history replay 不是 model prompt authority.md`

边界先说清：

- 这页不是 bridge replay object 总页。
- 这页不是 history ledger 身份总页。
- 这页只抓 continuity ledger 的继承条件，与 fresh-session replay 的合同分裂。

## 1. 四层对象

| 对象 | 当前更像什么 | 关键位置 |
| --- | --- | --- |
| `reusedPriorSession` | real session continuity proof | `replBridge.ts` |
| `previouslyFlushedUUIDs` in v1 | continuity ledger | `replBridge.ts` |
| `clear()` on fresh fallback | continuity break marker | `replBridge.ts` |
| unconditional `createCodeSession()` / `flushHistory()` in v2 | fresh-session replay contract | `remoteBridgeCore.ts` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `previouslyFlushedUUIDs` 是 bridge 通用 suppress 表 | 它只在 continuity contract 下成立 |
| v2 不用这张账只是实现偏好不同 | v2 的 fresh-session contract 明确拒绝它 |
| 只要某 UUID 成功 flush 过，以后就都不该再发 | 新 server session 下旧 ledger 必须失效 |
| v1/v2 差异只是 dedup 技法不同 | 真正差异是 suppress 的真理基础不同 |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | v1 continuity 才继承 ledger；fresh session 必须清空或拒绝 ledger |
| 条件公开 | v1 reconnect-in-place preserve，fresh fallback clear，v2 unconditional create refuses |
| 内部/灰度层 | replay cap、其他 UUID 集合家族、完整 reconnect state machine |

## 4. 五个检查问题

- 我现在说的是 replay object，还是 continuity contract？
- 我是不是把 183 的 ledger identity 和 189 的 inheritance condition 混成一页？
- 我是不是把 v2 的拒绝误写成“忘了 dedup”？
- 我是不是把 fresh-session create 后的 reflush 安全性漏掉了？
- 我是不是又回卷到 186 的 projection 主语了？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/replBridge.ts`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts`
