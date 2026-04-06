# 安全偏斜处置移交速查表：weak observer、allowed local action、handoff target、forbidden overreach与cleanup handoff implication

## 1. 这一页服务于什么

这一页服务于 [145-安全偏斜处置移交协议：为什么弱层发现问题后不应越级执行，而应把算子权交给更强的signer层](../145-安全偏斜处置移交协议：为什么弱层发现问题后不应越级执行，而应把算子权交给更强的signer层.md)。

如果 `145` 的长文解释的是：

`为什么弱层看到 skew 后应移交而不是越权，`

那么这一页只做一件事：

`把 weak observer、allowed local action、handoff target、forbidden overreach 与 cleanup handoff implication 压成一张矩阵。`

## 2. 移交矩阵

| weak observer | allowed local action | handoff target | forbidden overreach | cleanup handoff implication | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| UI / bridge status surface | `nudge` + failure isolation | outer init-failure signer 保持独立 | 不得把 cosmetic hiccup 升级成 init failure | cleanup disclosure UI 失败不应污染 cleanup signer failure | `useReplBridge.tsx:607-620` |
| compat adapter | internalize `retag / translate` | 让 callers 继续持有原对象 | 不得要求所有上游先学会 compat costume | cleanup carrier skew 未来应由 adapter 吃掉 costume debt | `createSession.ts:357-360`; `remoteBridgeCore.ts:971-982` |
| local hook / weak local actor | 先试 local resolution | SDK consumer / control protocol stronger signer | 不得在未闭环时自称已正式解决 | cleanup local hint / autofix 未来也应先试后 forward | `print.ts:1256-1262` |
| weak prefilter / passthrough layer | 预过滤、避免 dead button | full handler gate / policy callback | 不得把预过滤结果当最终 security verdict | cleanup weak pre-check 未来应在 stronger boundary 重跑 full gate | `print.ts:1666-1670`; `bridgeMessaging.ts:328-340` |
| route-mismatched layer | abstain | 正确 transport / control route | 不得因为“也许我能处理”就接管 чужд route | cleanup route 不归当前层时应显式 abstain，而不是 fallback 接手 | `print.ts:1258-1273` |

## 3. 最短判断公式

判断 weak layer 看到 skew 后是否 handoff 正确，先问四句：

1. 它本地最多配做什么弱动作
2. 真正签字权在谁手里
3. 它失败后是否会污染更强 verdict
4. 它有没有把“我先看见了”误当成“我配处理了”

## 4. 最常见的四类误读

| 误读 | 实际问题 |
| --- | --- |
| “弱层先试试总没坏处” | 未闭环时自称已解决会制造假成功 |
| “prefilter 已经过了，handler 不用再跑” | 这会把弱 gate 误当成正式 gate |
| “adapter 最懂路由，所以也能最终裁决” | adapter 通常只懂 costume，不懂完整 policy truth |
| “路由不确定时谁接都行” | 错 route 接手本身就是一种 overreach |

## 5. 一条硬结论

真正成熟的 handoff protocol 不是：

`我看到问题，就先替系统做决定。`

而是：

`我看到问题后，只做自己这一层配做的最弱动作，然后把正式处置权交给更强 signer。`
