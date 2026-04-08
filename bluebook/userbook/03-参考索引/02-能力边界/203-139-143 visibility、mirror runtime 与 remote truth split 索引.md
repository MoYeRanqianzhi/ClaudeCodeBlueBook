# 139-143 visibility、mirror runtime 与 remote truth split 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/216-post_turn_summary visibility、mirror gray runtime、remote-session ledger 与 global remote bit：为什么 139、140、141、142、143 不是线性五连，而是接在三条后继线上的三组问题.md`
- `05-控制面深挖/139-ccrMirrorEnabled、isEnvLessBridgeEnabled、initReplBridge、outboundOnly、replBridge 与 createV2ReplTransport：为什么启动意图、实现选路与实际 runtime topology 不是同一层 mirror 合同.md`
- `05-控制面深挖/140-SDKPostTurnSummaryMessageSchema、StdoutMessageSchema、SDKMessageSchema、print.ts 与 directConnectManager：为什么 post_turn_summary 的 wide-wire、@internal 与 foreground narrowing 不是同一种可见性.md`
- `05-控制面深挖/141-remoteSessionUrl、remoteConnectionStatus、remoteBackgroundTaskCount、useRemoteSession、activeRemote 与 getIsRemoteMode：为什么 remote-session presence ledger 不会自动被 direct connect、ssh remote 复用.md`
- `05-控制面深挖/142-outboundOnly、useReplBridge、initBridgeCore、handleServerControlRequest、handleIngressMessage 与 createV2ReplTransport：为什么 hook 已经在 mirror，本体运行时却仍可能落成 gray runtime.md`
- `05-控制面深挖/143-getIsRemoteMode、setIsRemoteMode、activeRemote、remoteSessionUrl、commands-session 与 StatusLine：为什么全局 remote behavior 开关，不等于 remote presence truth.md`

边界先说清：

- 这页不是 `139-143` 的细节证明总集。
- 这页不替代 216 的结构长文。
- 这页只抓 `140`、`139->142`、`141/143` 这三组后继问题。
- 这页保护的是 visibility ladder、mirror gray runtime 与 remote truth split 的主语分裂，不把某个 gate、某条文案或某个 helper 名直接升级成稳定公共合同。

## 1. 三组问题总表

| 节点 | 作用 | 在图上的位置 |
| --- | --- | --- |
| 216 | 解释 `139-143` 的三组后继问题 | 结构收束页 |
| 140 | 继续分 `post_turn_summary` 的 visibility ladder | `137` 的后继 zoom |
| 139 | 继续分 mirror 的 startup intent / implementation route / runtime topology | `136` 的后继 zoom |
| 142 | 继续分 hook-mirror 与 core-gray runtime | `139` 的 zoom |
| 141 | 继续分 remote-session presence ledger 为什么不通用 | `138/204` 的 ledger 分叉 |
| 143 | 继续分 global remote behavior bit 为什么不等于 presence truth | `138/204` 的 behavior-bit 分叉 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `139-143` 顺着编号就是一条 remote 五连 | 更稳的是三组后继问题，而不是线性五连 |
| `140` 只是 remote truth 线上的补丁页 | `140` 更稳是 `137` 那条 consumer-boundary 线上的 visibility zoom |
| mirror gate 开了，就等于 outboundOnly runtime 已兑现 | `139` 先问 intent / routing / topology；`142` 再问 gray runtime |
| `142` 只是 `139` 的重复版 | `142` 更稳是 hook-mirror 与 core-gray runtime 的具体 zoom |
| `143` 只是 `141` 的布尔简化版 | `141` 守 ledger truth，`143` 守 behavior bit |
| `getIsRemoteMode()` 被很多地方看，所以它就是 remote truth | 它更像 global behavior switch，不是 presence ledger |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `post_turn_summary` 同时存在多层可见性；mirror intent / route / topology 当前确实分层；hook-side mirror 与 core-side runtime 可能分叉；remote-session ledger 当前只属于 `remoteSessionUrl/remoteConnectionStatus/remoteBackgroundTaskCount`；`getIsRemoteMode()` 当前更像 behavior bit |
| 条件公开 | `140` 的 raw wire 可见性受上游 emit 与 output/consumer 选择影响；`139/142` 的 gray runtime 受 env-less / env-based 选路影响；`141/143` 的 surface 仍受命令显隐与 UI gate 影响 |
| 内部/灰度层 | `post_turn_summary` 是否会进入 core SDK contract；env-based core 是否未来真正吃到 `outboundOnly`；`getIsRemoteMode()` 是否未来仍只保留 behavior 语义 |

## 4. 六个检查问题

- 我现在写的是 visibility ladder、mirror runtime，还是 remote truth split？
- 我是不是把 `140` 拖进了 ledger / behavior bit 那条线？
- 我是不是把 `139` 的 contract-layers 偷换成了 `142` 的 gray-runtime 结论？
- 我是不是把 `141` 和 `143` 又压回成同一张 remote truth 表？
- 我是不是把广泛 consumer 偷换成了足够强的 truth source？
- 我有没有把 `139-143` 又写回成“编号挨着所以线性”的阅读顺序？

## 5. 源码锚点

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts`
- `claude-code-source-code/src/bridge/initReplBridge.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/bootstrap/state.ts`
- `claude-code-source-code/src/commands/session/index.ts`
