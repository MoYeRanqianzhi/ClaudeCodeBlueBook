# `handleIngressMessage`、`recentInboundUUIDs`、`onPermissionResponse`、`extractInboundMessageFields`、`resolveAndPrepend` 与 `pendingPermissionHandlers` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/197-handleIngressMessage、recentInboundUUIDs、onPermissionResponse、extractInboundMessageFields、resolveAndPrepend 与 pendingPermissionHandlers：为什么 bridge ingress 的 191-196 不是并列碎页，而是一条六层阅读链.md`
- `05-控制面深挖/191-handleIngressMessage、recentPostedUUIDs、recentInboundUUIDs 与 onInboundMessage：为什么 outbound echo drop、inbound replay guard 与 non-user ignore 不是同一种 ingress consumer contract.md`
- `05-控制面深挖/192-lastTransportSequenceNum、recentInboundUUIDs、tryReconnectInPlace、createSession 与 rebuildTransport：为什么 same-session continuity 与 fresh-session reset 不是同一种 inbound replay contract.md`
- `05-控制面深挖/193-handleIngressMessage、isSDKControlResponse、isSDKControlRequest、onPermissionResponse 与 onControlRequest：为什么 bridge ingress 的 control side-channel 不是对称的通用 control 总线.md`
- `05-控制面深挖/194-handleIngressMessage、control_response-control_request、extractInboundMessageFields 与 enqueue(prompt)：为什么 bridge ingress 只有 control 旁路和 user-only transcript adapter，non-user SDKMessage 没有第二消费面.md`
- `05-控制面深挖/195-extractInboundMessageFields、normalizeImageBlocks、resolveInboundAttachments、prependPathRefs 与 resolveAndPrepend：为什么 image block repair 与 attachment path-ref prepend 不是同一种 inbound normalization contract.md`
- `05-控制面深挖/196-pendingPermissionHandlers、BridgePermissionCallbacks、request_id、handlePermissionResponse 与 isBridgePermissionResponse：为什么 bridge permission race 的 verdict ledger 不是 generic control callback ownership.md`

边界先说清：

- 这页不是新的运行时合同正文。
- 这页不是 `00-阅读路径.md` 的简单复制。
- 这页只抓 191-196 这组 ingress 深挖为什么必须按六层顺序读。

## 1. 六层阅读链

| 层次 | 先问什么 | 对应页 |
| --- | --- | --- |
| 1 | 共享 reader 里到底分哪几条 consumer contract | `191` |
| 2 | reader 外部的 replay continuity 什么时候保留、什么时候归零 | `192` |
| 3 | control side-channel 为什么不是对称总线 | `193` |
| 4 | user leg 为什么只剩 transcript adapter | `194` |
| 5 | transcript adapter 内为什么还要再分 content repair / attachment materialization | `195` |
| 6 | permission leg 为什么还有本地 pending verdict ledger | `196` |

## 2. 最常见的误读顺序

| 误读顺序 | 更稳的顺序 |
| --- | --- |
| 先看 195/196 的局部细节，再补 191 | 先定 reader 边界，再看下游细化 |
| 把 193 和 196 压成同一页 | 先分 callback 腿，再看 permission leg 内部 ownership |
| 直接从 194 跳到 196 | 先分 transcript adapter，再分 adapter 内部 normalization |

## 3. 五个检查问题

- 我现在卡住的是 reader 边界、continuity、control、adapter、normalization，还是 verdict ledger？
- 我是不是把 191-196 当成六篇并列碎页了？
- 我是不是跳过上游边界，直接钻进下游细节？
- 我是不是在用 `00-阅读路径` 替代局部子系统的阅读顺序？
- 我是不是又把结构页写成了一篇重复正文？
