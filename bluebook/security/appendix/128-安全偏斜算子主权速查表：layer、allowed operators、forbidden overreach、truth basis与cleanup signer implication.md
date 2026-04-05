# 安全偏斜算子主权速查表：layer、allowed operators、forbidden overreach、truth basis与cleanup signer implication

## 1. 这一页服务于什么

这一页服务于 [144-安全偏斜算子主权：为什么nudge、retag、split-key、no-op、kill-switch、block、reject与fence不能由任意层随意选择](../144-安全偏斜算子主权：为什么nudge、retag、split-key、no-op、kill-switch、block、reject与fence不能由任意层随意选择.md)。

如果 `144` 的长文解释的是：

`为什么 remediation operator 不只要选对，还要由对的层来签发，`

那么这一页只做一件事：

`把 layer、allowed operators、forbidden overreach、truth basis 与 cleanup signer implication 压成一张矩阵。`

## 2. 主权矩阵

| layer | allowed operators | forbidden overreach | truth basis | cleanup signer implication | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| UI / presentation layer | `nudge` | 不应把 cosmetic skew 升级成 `block` / init failure | 用户可见状态与文案带宽 | cleanup visibility 问题未来更像 UI signer 的 nudge，而不是资格撤销 | `useReplBridge.tsx:607-614` |
| compat adapter layer | `retag / translate` | 不应自行判 grammar invalid 或 foreign world | 只掌握 costume/routing equivalence | cleanup carrier mismatch 未来应先走 adapter translate | `createSession.ts:357-360`; `sessionIdCompat.ts:25-57` |
| config-generation layer | `split-key` | 不应伪装成同 key 全代际等价 | 代际客户端读写协议差异 | cleanup knobs 若分代，key 迁移权应留在 config layer | `pollConfigDefaults.ts:77-80` |
| transport adapter layer | `no-op` | 不应把 lower-generation unsupported feature 误报成 global failure | 当前 transport 实际能力面 | cleanup weak surface unsupported action 未来更像 no-op signer | `replBridgeTransport.ts:51-64` |
| bootstrap / rollout gate layer | `kill-switch`, `block` | 不应把路径资格决策下放到 UI 或 decoder | rollout gate、path admission truth | cleanup contract floor / compat shim 未来应由 bootstrap signer 控制 | `initReplBridge.ts:130-134,410-420,456-460`; `bridgeEnabled.ts:132-145` |
| decoder / grammar boundary | `reject` | 不应延迟到上层再做 generic error | object grammar truth | cleanup proof envelope mismatch 未来更像 decoder reject | `workSecret.ts:5-18` |
| runtime pairing boundary | `reject foreign` | 不应把 costume mismatch 误判成 foreign session | env-session pairing truth + underlying UUID identity | cleanup stale/foreign signer ack 未来应先过 pairing guard | `replBridge.ts:1111-1124`; `workSecret.ts:50-72` |
| scheduler / transport orchestration / rebuild layer | `fence`, `flush gate` | 不应把 stale world disposal 交给 UI/adapter 层 | generation truth、write ownership、world-switch timing | stale cleanup ack / stale cleanup world 未来应由 orchestration signer 熔断 | `replBridge.ts:1373-1426`; `jwtUtils.ts:176-183`; `remoteBridgeCore.ts:482-487` |

## 3. 最短判断公式

判断某个 operator 是否由正确层签发，先问四句：

1. 该层掌不掌握触发这个 operator 所需的真相
2. 该层承不承担这个 operator 的后果
3. 相邻更强层是否更适合签发
4. 该层如果越级，会不会制造过度阻断或过度宽容

## 4. 最常见的四类误读

| 误读 | 实际问题 |
| --- | --- |
| “UI 最懂用户感受，所以也能 block” | UI 通常不掌握 path qualification truth |
| “adapter 最懂 tag，所以也能 reject” | adapter 只懂 costume equivalence，不懂 grammar/authorization truth |
| “decoder 看到不认识的东西就能处置所有 skew” | decoder 只配拒绝 object grammar，不配处理 stale world |
| “任何层都能做 fence，只要先 close 一下” | 没有 generation / write-ownership truth 就会误杀 current world |

## 5. 一条硬结论

真正成熟的控制面不是：

`每一层都能调用所有 operator。`

而是：

`每一个 operator 都有最合适的 signer 层，越过那条主权边界，动作再“正确”也会变成错误动作。`
