# Remote Control `received`、`processed`、write cursor、echo dedup 与 replay dedup 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/55-received、processing、processed、lastWrittenIndexRef、recentPostedUUIDs、recentInboundUUIDs 与 sentUUIDsRef：为什么 remote bridge 的送达回执、增量转发、echo 过滤与重放防重不是同一种去重.md`
- `05-控制面深挖/54-transport rebuild、initial flush、flush gate 与 sequence resume：为什么 CCR v2 remote bridge 的重建 transport、历史续接与 connected 不是同一步.md`
- `05-控制面深挖/29-Bridge Permission Callbacks、Control Request 与 Bridge-safe Commands：为什么远端的权限提示、会话控制与命令白名单不是同一种控制合同.md`

边界先说清：

- 这页不是 `BoundedUUIDSet` 实现笔记
- 这页只抓 delivery ACK、增量转发、outbound echo filter 与 inbound replay guard 的消费语义

## 1. 六类对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Delivery Ledger` | 服务端是否还该把一条 event 当作未处理对象重投 | `received / processing / processed` |
| `Write Cursor` | 本地这次只该从哪一条消息之后继续转发 | `lastWrittenIndexRef` / `bridgeLastForwardedIndex` |
| `Outbound Echo Filter` | 我刚发出去的消息被回弹后还该不该再注入 | `recentPostedUUIDs` |
| `Viewer Local Echo Guard` | 本地已渲染的 user message 是否还该让 WS echo 再渲染一次 | `sentUUIDsRef` |
| `Inbound Replay Guard` | transport swap / replay 后的旧 prompt 是否还该再注入 | `recentInboundUUIDs` |
| `Bounded Container` | 这些不同防重面共用哪一种 ring-backed set 容器 | `BoundedUUIDSet` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `received / processed` = UI 已经不会重复 | 这是服务端 delivery 账本，不是渲染层去重 |
| `lastWrittenIndexRef` = UUID dedup | 一个是增量转发游标，一个是身份防重 |
| `recentPostedUUIDs` = `recentInboundUUIDs` | 一个防 outbound echo，一个防 inbound replay |
| `sentUUIDsRef` = bridge transport dedup | 它是 viewer 本地回显过滤 |
| `recentInboundUUIDs` = `sequence resume` | 一个 safety net，一个主连续性修复 |
| 共用 `BoundedUUIDSet` = 共用同一种 dedup 合同 | 共用容器不代表共用语义 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | bridge / viewer 会同时使用 delivery ACK、增量转发游标、outbound echo filter 与 inbound replay guard 这几层不同防重面 |
| 条件公开 | v2 replBridge 路径会立即补 `processed` 以避免 phantom prompts；`sentUUIDsRef` 只处理本地 POST echo；`recentInboundUUIDs` 是 sequence handoff 失手时的 safety net |
| 内部/实现层 | ring buffer 容量、`BoundedUUIDSet` 实现细节、cursor 命名与 compaction clamp 细节 |

## 4. 七个检查问题

- 当前在维护的是服务端 delivery 账本，还是本地渲染/转发防重？
- 这里依赖的是 index cursor，还是 UUID identity？
- 这次要过滤的是 outbound echo，还是 inbound replay？
- 当前 viewer 已经本地渲染过这条消息了吗？
- 这里讲的是第 54 页的主连续性修复，还是连续性失手后的 safety net？
- `processed` 在这条路径里是真生命周期推进，还是立即补写策略？
- 我是不是又把共用容器写成了共用语义？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/replBridgeTransport.ts`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/utils/teleport/api.ts`
