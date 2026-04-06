# `received`、`processing`、`processed`、`lastWrittenIndexRef`、`recentPostedUUIDs`、`recentInboundUUIDs` 与 `sentUUIDsRef`：为什么 remote bridge 的送达回执、增量转发、echo 过滤与重放防重不是同一种去重

## 用户目标

不是只知道 remote bridge / remote session “源码里到处都在防重复消息”，而是先分清七类不同对象：

- 哪些是在给服务端事件账本标记 `received / processing / processed`。
- 哪些是在本地只增量转发“新增消息”，而不是每次重扫整段会话。
- 哪些是在过滤“我自己刚发出去、又从流里弹回来的 echo”。
- 哪些是在 transport swap 或订阅重连后，防已经转发过的 inbound prompt 再次注入。
- 哪些是在 viewer 侧过滤“我本地已经渲染过的 user message”，避免 WS echo 再渲染一遍。
- 哪些只是 UUID ring buffer 的安全网。
- 哪些真正是主防重，而不是次级保险丝。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“去重逻辑”：

- `received / processing / processed`
- `lastWrittenIndexRef`
- `bridgeLastForwardedIndex`
- `recentPostedUUIDs`
- `recentInboundUUIDs`
- `sentUUIDsRef`
- `BoundedUUIDSet`

## 第一性原理

Claude Code 里的“不要重复”至少沿着五条轴线分化：

1. `Delivery Ledger`：当前是在告诉服务端“这条事件收到/处理到哪一步了”。
2. `Forward Cursor`：当前是在本地决定“这次只转发哪些新增消息”。
3. `Outbound Echo Filter`：当前是在丢掉“我刚发出去、又被流弹回来的同 UUID 回声”。
4. `Inbound Replay Guard`：当前是在防 transport 切换或订阅重放时，旧 prompt 再次注入。
5. `Viewer Local Echo Guard`：当前是在 viewer 侧避免“本地已渲染的 user message”被 WS echo 再渲染一次。

因此更稳的提问不是：

- “这里不就是 dedup 吗？”

而是：

- “当前去重是在维护服务端送达账、做本地增量转发、滤掉 outbound echo、拦住 inbound replay，还是在 viewer 侧消除本地回显重复？”

只要这五条轴线没先拆开，正文就会把 delivery ACK、write cursor、echo filter 与 replay guard 写成同一种 dedup。

这里也要主动卡住一个边界：

- 这页讲的是 remote bridge / remote session 的多层防重合同
- 不重复 29 页对 `control_request / control_response` 本体的控制合同
- 不重复 54 页对 transport continuity、initial flush 与 sequence handoff 的主线
- 这页也不是 `BoundedUUIDSet` 或 hook cursor 的实现总表

## 第一层：`received / processing / processed` 是服务端送达账本，不是本地 UI 去重

### 它回答的是“服务端如何判断一条事件是否还该重投”

`CCRClient` 和 `replBridgeTransport.ts` 把 delivery status 说得很清楚：

- `received`
- `processing`
- `processed`

这说明它回答的问题不是：

- 当前 viewer 会不会把一条 user message 重复渲染

而是：

- 服务端是否还应把这条 event 当作未处理对象继续重投

### v2 replBridge 路径甚至会把 `received` 与 `processed` 直接并写

`replBridgeTransport.ts` 的注释写得很硬：

- `remoteIO.ts` 在 in-process query loop 里，本来会通过 `setCommandLifecycleListener` 上报 `processing / processed`
- 但 replBridge / daemonBridge 这条路径没有这层 wiring
- 如果只停在 `received`，重连后服务端会反复 re-queue，出现 phantom prompts

所以这一路径改成：

- 收到 SSE frame 就 `received`
- 随即补 `processed`

更准确的理解应是：

- delivery ACK：服务端 redelivery 账本
- UI dedup：另一层对象

只要这一层没拆开，正文就会把：

- “服务端不再重投”
- “本地一定不会重复显示”

写成同一个保证。

## 第二层：`lastWrittenIndexRef` / `bridgeLastForwardedIndex` 是增量转发游标，不是 UUID echo filter

### 它们回答的是“这次从哪一条消息之后开始扫”

`useReplBridge.tsx` 与 `print.ts` 都保留了一条 index-based cursor：

- `lastWrittenIndexRef`
- `bridgeLastForwardedIndex`

旁边注释写得很直接：

- 只收集自上次写入以来的新消息
- compaction 发生时要 clamp
- 这层是预过滤，避免每次都 O(n) 重扫已转发部分

这说明它回答的问题不是：

- 同一个 UUID 的 echo 要不要丢掉

而是：

- 本地这次应该从消息数组的哪个位置继续向 bridge 转发

### 所以 write cursor 与 UUID dedup 不是同一层

更准确的区分是：

- write cursor：按数组位置做增量转发
- UUID ring：按消息身份做防重安全网

只要这一层没拆开，正文就会把：

- “本地没有重复转发旧消息”
- “流里回弹的同 UUID echo 被过滤”

写成同一个动作。

## 第三层：`recentPostedUUIDs` 是 outbound echo filter，也是次级防重，不是主转发游标

### 它拦的是“我刚 POST / write 过的消息，又从流里弹回来”

`bridgeMessaging.ts` 对 `handleIngressMessage(...)` 写得很清楚：

- 如果 inbound UUID 在 `recentPostedUUIDs`
- 就按 echo 直接忽略

`replBridge.ts` 与 `remoteBridgeCore.ts` 也都把它作为：

- echo filtering
- race-condition secondary dedup

这说明它回答的问题不是：

- 本地这次该从哪条消息开始扫描

而是：

- 我自己刚发出的事件被 server / worker 弹回时，是否应该再次注入

### 它还是次级保险丝，不是唯一真相

源码注释还强调：

- `lastWrittenIndexRef` 才是主增量转发
- `recentPostedUUIDs` 是 safety net

更准确的理解应是：

- primary：cursor-based incremental forwarding
- secondary：UUID echo filter / race-condition dedup

只要这一层没拆开，正文就会把所有“防重复发送”都压成一个 UUID Set。

## 第四层：`sentUUIDsRef` 是 viewer 侧本地回显过滤，不是 history replay dedup

### 它回答的是“我已经本地渲染过的 user message，不要再被 WS echo 渲染一次”

`useRemoteSession.ts` 的注释写得很具体：

- 本地先创建了 UserMessage
- 之后 POST 到远端 session
- WS 可能把同一 UUID 回弹多次
- 若不拦，viewer 会看到自己输入的消息重复出现

所以它会：

- 在 POST 前先把 UUID 加进 `sentUUIDsRef`
- 收到同 UUID 的 user message echo 时直接丢掉

这说明它回答的问题不是：

- attach 时的 history-vs-live overlap

而是：

- 当前 viewer 本地已经渲染过的 user message，是否还该让 WS echo 再渲染一遍

### 它和 bridge 侧 `recentPostedUUIDs` 语义相似，但作用域不同

更准确的区分是：

- `recentPostedUUIDs`：bridge transport 层的 echo filtering
- `sentUUIDsRef`：viewer 本地渲染层的 echo filtering

只要这一层没拆开，正文就会把 bridge write path 与 viewer render path 的防重写成同一层对象。

## 第五层：`recentInboundUUIDs` 是 inbound replay 安全网，不是 sequence handoff 本身

### 它拦的是“服务端重放或 transport swap 失手后，再次送来的旧 prompt”

`bridgeMessaging.ts` 直接写出：

- `recentInboundUUIDs` 用来丢弃已经 forward 过的 inbound prompt
- 场景包括 seq-num negotiation failure、server replayed history、transport swap races

这说明它回答的问题不是：

- 新 transport 应该从哪个 sequence 继续读

而是：

- 如果 sequence handoff 已经失败或 edge case 发生，旧 prompt 再送来时要不要再注入一次

### 所以它是第 54 页主修复之外的 safety net

更准确的理解应是：

- 第 54 页的 `sequence resume`：主连续性修复
- 这页的 `recentInboundUUIDs`：主修复失手时的防重安全网

只要这一层没拆开，正文就会把：

- “从旧 sequence 继续读”
- “读重了以后再挡一次”

写成同一个机制。

## 第六层：同样叫 `BoundedUUIDSet`，也不代表同一种防重合同

### 它只是一个 FIFO-bounded ring-backed set

`bridgeMessaging.ts` 对 `BoundedUUIDSet` 的定义很朴素：

- FIFO bounded
- circular buffer
- O(capacity) 内存

这说明它回答的问题不是：

- 当前到底在做 echo filter、replay guard，还是 viewer 本地回显过滤

而是：

- 这些不同防重面可以共用哪一种 bounded ring 容器

### 所以容器复用不等于语义相同

更准确的区分是：

- `BoundedUUIDSet`：容器
- `recentPostedUUIDs` / `recentInboundUUIDs` / `sentUUIDsRef`：不同语义面的使用者

只要这一层没拆开，正文就会把“都用了同一个 Set 类”误写成“都在做同一种 dedup”。

## 第七层：stable、conditional 与 internal 三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | bridge / viewer 会同时使用 delivery ACK、增量转发游标、outbound echo filter 与 inbound replay guard 这几层不同防重面 |
| 条件公开 | v2 replBridge 路径会把 `processed` 立即并写以避免 phantom prompts；`sentUUIDsRef` 只处理本地 POST echo，不处理 attach 时的 history-vs-live overlap；`recentInboundUUIDs` 是 sequence handoff 失手时的安全网 |
| 内部/实现层 | ring buffer 容量、`BoundedUUIDSet` 的具体实现、`lastWrittenIndexRef` / `bridgeLastForwardedIndex` 的细节命名与 compaction clamp 细节 |

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `received / processed` = UI 已经不会重复 | 这是服务端 delivery 账本，不是渲染层去重 |
| `lastWrittenIndexRef` = UUID echo filter | 一个是增量转发游标，一个是身份防重 |
| `recentPostedUUIDs` = `recentInboundUUIDs` | 一个防 outbound echo，一个防 inbound replay |
| `sentUUIDsRef` = bridge transport dedup | 它是 viewer 本地回显过滤 |
| `recentInboundUUIDs` = `sequence resume` | 一个是 safety net，一个是主连续性修复 |
| `BoundedUUIDSet` 相同 = 防重语义相同 | 共用容器不代表共用合同 |

## 七个检查问题

- 当前在维护的是服务端 delivery 账本，还是本地渲染/转发防重？
- 这里的“不重复”依赖的是 index cursor，还是 UUID identity？
- 这次要过滤的是 outbound echo，还是 inbound replay？
- 当前 viewer 已经本地渲染过消息了吗，还是还没进入本地显示面？
- 这里讲的是第 54 页的主连续性修复，还是连续性失手后的 safety net？
- `processed` 现在是真正的生命周期推进，还是这条路径里的立即补写策略？
- 我是不是又把不同层面的 anti-dup 容器写成同一种 dedup 合同了？

## 源码锚点

- `claude-code-source-code/src/bridge/replBridgeTransport.ts`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/utils/teleport/api.ts`
