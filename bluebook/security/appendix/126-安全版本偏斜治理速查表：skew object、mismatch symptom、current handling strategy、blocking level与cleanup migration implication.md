# 安全版本偏斜治理速查表：skew object、mismatch symptom、current handling strategy、blocking level与cleanup migration implication

## 1. 这一页服务于什么

这一页服务于 [142-安全版本偏斜治理：为什么Claude Code不把CLI过旧、App过旧、session tag错位、secret grammar错版与transport代际竞争混成同一种版本问题](../142-安全版本偏斜治理：为什么Claude Code不把CLI过旧、App过旧、session tag错位、secret grammar错版与transport代际竞争混成同一种版本问题.md)。

如果 `142` 的长文解释的是：

`为什么 Claude Code 把不同代际错位拆成不同治理对象，`

那么这一页只做一件事：

`把不同 skew object 的 mismatch symptom、current handling strategy、blocking level 与 cleanup migration implication 压成一张矩阵。`

## 2. 偏斜治理矩阵

| skew object | mismatch symptom | current handling strategy | blocking level | cleanup migration implication | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| CLI version floor | 当前 CLI 太旧，不能安全进入 v1/v2 remote-control path | 直接 skip path + failed state + upgrade message | hard block | 高风险 cleanup semantic 未来可能也要有 admission floor | `initReplBridge.ts:410-420,456-460`; `bridgeEnabled.ts:150-173`; `envLessBridgeConfig.ts:139-153` |
| claude.ai app visibility skew | v2 session 已建立，但前台 app 可能看不见 | 会话照常启动，只追加 upgrade nudge | soft nudge | cleanup truth 也可能需要区分“已生效”与“前台可见” | `envLessBridgeConfig.ts:38-41,156-164`; `useReplBridge.tsx:607-614` |
| compat session tag skew | `session_*` / `cse_*` 同 UUID 不同 costume | retag / translate / sameSessionId compare | translate, not block | cleanup object carrier 若换壳，也应先解决 identity equivalence | `sessionIdCompat.ts:25-57`; `workSecret.ts:50-72`; `replBridge.ts:1111-1125` |
| compat shim lifecycle skew | frontend / server 是否已接受 `cse_*` 直接路由 | kill-switch controlled shim，默认保留直至明确可退场 | staged rollout | cleanup future shim 也应有明确退场开关，而不是永久历史包袱 | `bridgeEnabled.ts:132-145` |
| in-memory key consistency skew | mid-session gate flip 导致 key 变化 | spawn 时缓存 compat ID，保证 status/cleanup ticks 用同一 key | freeze within stateful scope | cleanup ledger key 若跨代变化，stateful scope 内应固定，不应漂移 | `bridgeMain.ts:166-169`; `bridgeMain.ts:1021-1024`; `bridgeMain.ts:1430-1433` |
| stateless route skew | compat gateway 当前接受哪种 tag 可能变化 | 每次 fresh compute compatId 再发请求 | fresh recompute | cleanup stateless API 更适合按当前 server truth 现算路由 | `remoteBridgeCore.ts:971-982` |
| secret grammar skew | work secret version 不匹配 | 直接抛 `Unsupported work secret version` | hard reject | cleanup signer / audit grammar 若错版，不应 best-effort 兼容 | `workSecret.ts:5-18` |
| config key generation skew | pre-v2 / v2 clients 读取不同 keepalive key | 旧客户端读旧 key，新客户端忽略 `_v2` key | split by generation | cleanup metrics/knobs 未来可能也要显式代际分键 | `pollConfigDefaults.ts:77-80` |
| transport generation skew | 旧 v2 handshake 晚到，可能抢赢新 epoch | generation bump + stale handshake discard | stale world rejected | cleanup ack / replacement 未来也应考虑 generation fencing | `replBridge.ts:1373-1426` |

## 3. 最短判断公式

判断一类“版本问题”是否被成熟治理，先问四句：

1. 这到底是哪种 skew object
2. 它更像 visibility、routing、grammar、capability 还是 generation 问题
3. 它该被提示、翻译、阻断还是拒绝
4. 它是否会让旧世界误改当前真相

## 4. 最常见的四类误读

| 误读 | 实际问题 |
| --- | --- |
| “版本不对都该提示升级” | 有些 skew 该 retag，有些该 hard reject |
| “能看到 session 就说明 app 没问题” | app 也可能只是看不见 v2 session-list |
| “session_* 和 cse_* 不是同一对象” | 在 compat 语义里它们可能只是同 UUID 的不同 costume |
| “race condition 和版本问题无关” | generation skew 本质上就是时间代际偏斜 |

## 5. 一条硬结论

成熟系统治理版本偏斜时，  
最危险的不是组件不在同一代际，  
而是：

`把不同类型的错位压成同一种“旧版本”，从而在该提示时误阻断、该拒绝时误放行、该翻译时误判成 foreign object。`
