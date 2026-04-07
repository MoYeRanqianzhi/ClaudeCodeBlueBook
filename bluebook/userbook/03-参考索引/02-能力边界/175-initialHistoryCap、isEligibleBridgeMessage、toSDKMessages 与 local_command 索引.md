# `initialHistoryCap`、`isEligibleBridgeMessage`、`toSDKMessages` 与 `local_command` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/186-initialHistoryCap、isEligibleBridgeMessage、toSDKMessages 与 local_command：为什么 bridge 的 eligible history replay 不是 model prompt authority.md`
- `05-控制面深挖/181-createBridgeSession.events、initialMessages、previouslyFlushedUUIDs 与 writeBatch：为什么 session-create events 不是 remote-control 历史回放机制.md`
- `05-控制面深挖/183-initialMessageUUIDs、previouslyFlushedUUIDs、createBridgeSession.events 与 writeBatch：为什么注释里的 session creation events 不等于 bridge 的真实历史账.md`

边界先说清：

- 这页不是 bridge birth / hydrate 总页。
- 这页不是 delivery ledger 总页。
- 这页只抓 eligible history replay、remote consumer projection 与 model prompt authority 的错位。

## 1. 四层对象

| 对象 | 当前更像什么 | 关键位置 |
| --- | --- | --- |
| `isEligibleBridgeMessage(...)` | bridgeable source-family gate | `bridgeMessaging.ts` |
| `toSDKMessages(...)` | remote consumer projection | `mappers.ts` |
| `initialHistoryCap` | UI replay persistence budget | `replBridge.ts` / `remoteBridgeCore.ts` |
| `local_command` in prompt assembly | model-context source contrast | `utils/messages.ts` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| bridge initial flush 就是 prompt replay | 它是 capped eligible remote replay |
| `initialHistoryCap` 是上下文裁剪 | 它是 remote persistence / UI budget |
| `isEligibleBridgeMessage(...)` 就决定模型看到什么 | 它只决定 bridge replay 的 source family |
| `toSDKMessages(...)` 只是重复过滤 | 它在把 eligible history 改写成 consumer payload |
| `local_command` 要么永远 UI-only，要么永远 model-visible | 它在 bridge 与 prompt 两条 pipeline 中角色不同 |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | eligible gate、consumer projection、UI-only replay、prompt assembly 分属不同层 |
| 条件公开 | `local_command` 只有 stdout / stderr output 才进 RC UI |
| 内部/灰度层 | cap 具体数值、v1/v2 dedup 细节、storage 压力调参 |

## 4. 五个检查问题

- 我现在说的是 bridge replay、remote consumer payload，还是 model prompt authority？
- 我是不是把 `initialHistoryCap` 写成了 token / context budget？
- 我是不是把 `isEligibleBridgeMessage(...)` 和 `toSDKMessages(...)` 压成了一层？
- 我是不是把 `local_command` 在 bridge 和 prompt 两条链中的角色写成了同一种？
- 我是不是又回卷到 181 / 183 的 birth / ledger 主语了？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/replBridge.ts`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts`
- `claude-code-source-code/src/utils/messages/mappers.ts`
- `claude-code-source-code/src/utils/messages.ts`
