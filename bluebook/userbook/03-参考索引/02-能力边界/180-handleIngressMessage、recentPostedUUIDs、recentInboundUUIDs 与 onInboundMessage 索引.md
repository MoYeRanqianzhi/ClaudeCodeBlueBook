# `handleIngressMessage`、`recentPostedUUIDs`、`recentInboundUUIDs` 与 `onInboundMessage` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/191-handleIngressMessage、recentPostedUUIDs、recentInboundUUIDs 与 onInboundMessage：为什么 outbound echo drop、inbound replay guard 与 non-user ignore 不是同一种 ingress consumer contract.md`
- `05-控制面深挖/55-received、processing、processed、lastWrittenIndexRef、recentPostedUUIDs、recentInboundUUIDs 与 sentUUIDsRef：为什么 remote bridge 的送达回执、增量转发、echo 过滤与重放防重不是同一种去重.md`
- `05-控制面深挖/142-outboundOnly、useReplBridge、initBridgeCore、handleServerControlRequest、handleIngressMessage 与 createV2ReplTransport：为什么 hook 已经在 mirror，本体运行时却仍可能落成 gray runtime.md`

边界先说清：

- 这页不是 dedup family 总页。
- 这页不是 outboundOnly runtime 总页。
- 这页只抓 shared ingress reader 自身的 consumer contract 分裂。

## 1. 四层对象

| 对象 | 当前更像什么 | 关键位置 |
| --- | --- | --- |
| `control_response` / `control_request` | control side-channel bypass | `handleIngressMessage(...)` |
| `recentPostedUUIDs` | outbound echo drop | `handleIngressMessage(...)` |
| `recentInboundUUIDs` | inbound replay guard | `handleIngressMessage(...)` |
| `onInboundMessage` | user-message consumer domain | `handleIngressMessage(...)` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| ingress reader 只有一套“要不要丢”的判断 | 它先分 side-channel，再分 echo / replay / consumer domain |
| `recentPostedUUIDs` = `recentInboundUUIDs` | 一个管 outbound echo，一个管 inbound replay |
| non-user ignore 是 dedup 特例 | 它是 consumer-domain narrowing |
| control payload 只是另一种 SDK message | 它们根本不进入 `isSDKMessage` consumer 分支 |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | control bypass、echo drop、replay guard、user-only consumer domain |
| 条件公开 | 只有 `parsed.type === 'user'` 才会 `recentInboundUUIDs.add(uuid)` 并触发 `onInboundMessage` |
| 内部/灰度层 | sequence handoff edge cases、outboundOnly wiring 细节、viewer-side parallel consumer |

## 4. 五个检查问题

- 我现在写的是 dedup family，还是 single reader 内部 contract split？
- 我是不是把 non-user ignore 误写成 dedup 特例？
- 我是不是把 control payload 误写进 SDK message consumer 域？
- 我是不是把 `recentPostedUUIDs` / `recentInboundUUIDs` 压成了一张 UUID 去重表？
- 我是不是又回卷到 55 或 142 的主语了？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/bridgeMessaging.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts`
