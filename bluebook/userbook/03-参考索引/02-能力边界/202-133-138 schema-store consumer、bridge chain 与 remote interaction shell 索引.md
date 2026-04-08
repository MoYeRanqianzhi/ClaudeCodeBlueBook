# 133-138 schema/store consumer、bridge chain 与 remote interaction shell 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/215-schema-store consumer path、bridge chain split 与 remote interaction shell：为什么 133、134、135、136、137、138 不是线性六连，而是从 132 分出去的三条两步后继线.md`
- `05-控制面深挖/133-pending_action、post_turn_summary、task_summary 与 externalMetadataToAppState：为什么 schema-store 里有账，不等于当前前台已经消费.md`
- `05-控制面深挖/134-createV1ReplTransport、createV2ReplTransport、reportState、reportMetadata 与 reportDelivery：为什么 bridge v1-v2 不是同一种 front-state consumer chain.md`
- `05-控制面深挖/135-createDirectConnectSession、DirectConnectSessionManager、useDirectConnect、remoteSessionUrl 与 replBridgeConnected：为什么 direct connect 更像 foreground remote runtime，而不是 remote presence store.md`
- `05-控制面深挖/136-ccrMirrorEnabled、outboundOnly、system-init、replBridgeConnected 与 sessionUrl-connectUrl：为什么同属 v2 的 bridge 也不是同一种活跃 front-state surface.md`
- `05-控制面深挖/137-pending_action.input、task_summary、post_turn_summary、externalMetadataToAppState、print.ts 与 directConnectManager：为什么“frontend 会读”更像跨前端 consumer path，而不是当前 CLI foreground contract.md`
- `05-控制面深挖/138-activeRemote、useDirectConnect、useSSHSession、useRemoteSession、remoteSessionUrl 与 directConnectServerUrl：为什么共用交互壳，不等于共用 remote presence ledger.md`

边界先说清：

- 这页不是 `133-138` 的细节证明总集。
- 这页不替代 215 的结构长文。
- 这页只抓“`133->137`、`134->136`、`135->138`”这三条两步后继线。
- 这页保护的是 consumer boundary、bridge chain split 与 shared interaction shell 的主语分裂，不把某条注释、某个 render condition 或某个 helper 名直接升级成稳定公共合同。

## 1. 三条后继线总表

| 节点 | 作用 | 在图上的位置 |
| --- | --- | --- |
| 215 | 解释 `133-138` 的三条两步后继线 | 结构收束页 |
| 133 | 先分 schema/store 有账，不等于当前 foreground 已消费 | consumer boundary 根页 |
| 137 | 继续分 “frontend 会读” 为什么更像跨前端 consumer path | consumer boundary zoom |
| 134 | 先分 bridge v1/v2 为什么不是同一种 consumer chain | bridge chain 根页 |
| 136 | 继续分同属 v2 为什么也不是同一种 active front-state surface | bridge active-surface zoom |
| 135 | 先分 direct connect 为什么更像 foreground runtime | runtime 根页 |
| 138 | 继续分 `activeRemote` 为什么只是 shared interaction shell | shared-shell zoom / `204` 交接点 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `133-138` 都在讲 remote consumer，所以顺着编号一路读就行 | 更稳的是三条两步后继线，而不是线性六连 |
| schema/store 里有字段，当前 CLI 只是还没把 UI 做完 | `133/137` 先问的是 current foreground consumer 是否存在 |
| bridge v1/v2 只是协议不同 | `134` 先问的是 consumer chain depth，而不是协议名字 |
| mirror / outboundOnly 只是 full bridge 少几个控件 | `136` 在问同属 v2 为什么也不是同一种 active surface |
| direct connect 只是 `--remote` 少一个 URL | `135` 先问的是 foreground runtime，而不是 presence store |
| 既然有 `activeRemote`，REPL 已经有统一 remote presence ledger | `138` 更稳的是 shared interaction shell，不是 presence truth |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | schema/store existence 不等于 current foreground consumer；`externalMetadataToAppState()` 当前只恢复极少子集；bridge v1 的 `report*` 当前是 no-op；v2 才接上 worker-side state / delivery；direct connect 当前更像 foreground runtime；`activeRemote` 统一的是 interaction API |
| 条件公开 | `pending_action.input/task_summary/post_turn_summary` 的实际 consumer 更像跨前端；bridge v2 还要再分 full / outboundOnly / mirror；direct connect / ssh 将来若写 authoritative state，才可能并入同一 presence ledger |
| 内部/灰度层 | delivery `received/processed` 细节；`getLastSequenceNum/flush` 恢复细节；direct connect filter 列表；display hint 的具体挂载时机与未来演化 |

## 4. 六个检查问题

- 我现在写的是 consumer boundary、bridge chain，还是 shared interaction shell？
- 我是不是把 `133/137` 的 frontend consumer 问题，偷换成了 `134/136` 的 bridge chain 问题？
- 我是不是把 bridge v2 的 capability 写成了整个 bridge 的统一合同？
- 我是不是把 direct connect 自身的 runtime 身份和 REPL 顶层 `activeRemote` 混成同一层？
- 我是不是把 `138` 忘成普通 leaf，而没看到它会继续把问题交给 `204` 那条更大分叉图？
- 我有没有把 `133-138` 又写回成“六篇 remote 细节页”？

## 5. 源码锚点

- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/state/onChangeAppState.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/server/createDirectConnectSession.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/hooks/useSSHSession.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/bootstrap/state.ts`
