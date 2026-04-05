# 安全偏斜处置算子速查表：skew object、preferred operator、why not adjacent operator、current source与cleanup extrapolation

## 1. 这一页服务于什么

这一页服务于 [143-安全偏斜处置算子：为什么Claude Code不把所有版本问题都交给升级，而是按nudge、retag、split-key、no-op、kill-switch、block、reject与fence分层治理](../143-安全偏斜处置算子：为什么Claude%20Code不把所有版本问题都交给升级，而是按nudge、retag、split-key、no-op、kill-switch、block、reject与fence分层治理.md)。

如果 `143` 的长文解释的是：

`为什么不同 skew object 最终要落到不同 remediation operator，`

那么这一页只做一件事：

`把 skew object、preferred operator、why not adjacent operator、current source 与 cleanup extrapolation 压成一张矩阵。`

## 2. 处置算子矩阵

| skew object | preferred operator | why not adjacent operator | current source | cleanup extrapolation | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| app visibility skew | `nudge` | 不是资格失败，`block` 会误伤已成立的底层路径 | bridge status transcript message | cleanup truth 已生效但前台未投影时，也应优先补认知而非断能力 | `useReplBridge.tsx:607-614`; `envLessBridgeConfig.ts:156-164` |
| compat session costume skew | `retag / translate` | 不是 foreign object，`reject` 会把同 UUID 的对象误判成不同会话 | `toCompatSessionId()` / `toInfraSessionId()` | cleanup carrier 换壳时，应先保持 identity continuity | `sessionIdCompat.ts:25-57`; `replBridge.ts:392-401` |
| generation-diverged config family | `split-key` | 强行共用单 key 会让新旧代际互相误读 | `_v2` config key | cleanup knobs / metrics 未来可能也要按代际分键 | `pollConfigDefaults.ts:77-80` |
| lower-generation missing feature | `no-op` | 不支持不等于失败；硬报错会把“缺能力”误说成“系统坏了” | v2-only state/metadata/delivery reporting | cleanup weak surface 未来也可能需要正式 no-op 而不是伪成功 | `replBridgeTransport.ts:51-66` |
| transitional compat shim | `kill-switch` | 永久保留会让过渡协议变成历史负债 | cse shim gate | cleanup compat shim 也应从一开始就设计退场条件 | `bridgeEnabled.ts:132-145` |
| path qualification failure | `block` | 当前 actor/path 不配进入，不是对象 grammar 错误 | bridge min-version gate | cleanup contract floor mismatch 未来更像 block | `initReplBridge.ts:410-420,456-460` |
| input grammar mismatch | `reject` | 输入本身不合法，不能退化成“先跑再看” | work secret version check | cleanup signer/audit envelope 错版时更像 reject | `workSecret.ts:5-18` |
| stale async world still alive | `fence` | 只记录日志不够，旧世界会继续回写当前真相 | generation bump + stale handshake discard + stale refresh skip | cleanup stale ack / stale signer 未来也应代际熔断 | `replBridge.ts:1373-1426`; `jwtUtils.ts:121-123,176-183` |
| stale writer with silent-loss risk | `fence + flush gate` | 单纯 close old transport 仍可能留下 silent no-op / lost write | rebuild gate before transport swap | cleanup world切换时应先关闸，避免旧世界最后再清一次 | `remoteBridgeCore.ts:482-487` |

## 3. 最短判断公式

判断一类 skew 到底该落到哪个 operator，先问四句：

1. 它错的是 visibility、identity、generation、grammar 还是 admission
2. 当前对象是不配进入，还是只是穿错 costume
3. 若放任旧世界继续写，会不会误改当前真相
4. 相邻 operator 会不会造成过度阻断或过度宽容

## 4. 最常见的四类误读

| 误读 | 实际问题 |
| --- | --- |
| “提示升级最稳妥” | 对 grammar / stale-world 问题这会过度宽容 |
| “看到不同 tag 就是不同对象” | compat 层经常只是同 UUID 的不同 costume |
| “不支持就一定要报错” | lower-generation surface 有时更适合正式 no-op |
| “只要旧世界不再被引用就安全” | 没有 fencing/flush gate，旧世界仍可能留下 silent loss |

## 5. 一条硬结论

真正成熟的 skew 治理不是：

`发现偏斜，再临时决定怎么办。`

而是：

`在设计阶段就明确：每一类偏斜对象该优先落到哪一个 operator，以及为什么不能误落到相邻 operator。`
