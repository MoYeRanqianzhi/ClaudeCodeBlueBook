# 安全载体家族反漂移验证与修复治理分层速查表：detector、governance consequence、positive control、cleanup repair gap与next control question

## 1. 这一页服务于什么

这一页服务于 [163-安全载体家族反漂移验证与修复治理分层：为什么artifact-family cleanup anti-drift verifier signer不能越级冒充artifact-family cleanup repair-governor signer](../163-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E5%8F%8D%E6%BC%82%E7%A7%BB%E9%AA%8C%E8%AF%81%E4%B8%8E%E4%BF%AE%E5%A4%8D%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88artifact-family%20cleanup%20anti-drift%20verifier%20signer%E4%B8%8D%E8%83%BD%E8%B6%8A%E7%BA%A7%E5%86%92%E5%85%85artifact-family%20cleanup%20repair-governor%20signer.md)。

如果 `163` 的长文解释的是：

`为什么发现 drift 与决定如何修复 drift 仍然是两层主权，`

那么这一页只做一件事：

`把 repo 里现成的 detector / governance consequence 正例，与 cleanup 线当前仍缺的 repair-governor grammar，压成一张矩阵。`

## 2. 反漂移验证与修复治理分层矩阵

| line | detector | governance consequence | positive control | cleanup repair gap | next control question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| auto-mode gate | `verifyAutoModeGateAccess()` detects stale-vs-live divergence | `checkAndDisableAutoModeIfNeeded()` applies state change and user notification | verifier and governor already split | cleanup line lacks equivalent post-verification governor | who decides cleanup promise downgrade vs executor fix | `permissionSetup.ts:1078-1150`; `bypassPermissionsKillswitch.ts:74-107` |
| permission mode cycling | `getNextPermissionMode()` checks cached/live divergence before cycling | transition / kick-out authority remains elsewhere | detection before state transition | cleanup has no dedicated “do not transition into stronger claim” governor | who blocks stronger cleanup claims when conformance is uncertain | `getNextPermissionMode.ts:7-17`; `permissionSetup.ts` cluster |
| plugin dependency safety | `verifyAndDemote(...)` exposes dependency inconsistency | plugin enabled state is demoted | verify + demote pattern is explicit | cleanup line has no matching “verify + demote promise/capability” pair | should cleanup drift demote capability, promise, or path override | `dependencyResolver.ts:177-233`; `pluginLoader.ts:3192-3194` |
| cleanup temporal / propagation / receipt gaps | current research can detect them | no explicit cleanup repair governor visible | repo shows repair layering elsewhere | no formal owner decides whether to fix scheduler, executor, metadata, or language | who owns cleanup repair governance | cleanup source cluster + positive controls above |

## 3. 三个最重要的判断问题

判断一句“cleanup 线已经具备完整治理”有没有越级，先问三句：

1. 当前机制只是发现 drift，还是已经给出治理后果
2. 治理后果是修执行、降承诺、禁 feature，还是要求迁移
3. 如果多种修复路径都可能成立，当前到底由哪一层主权来裁决

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “verifier 够强就等于 governor 也有了” | detection != repair authority |
| “报错了就该修 executor” | maybe promise/metadata/scheduler should change instead |
| “plugin 线有 demote，所以 cleanup 也会自然有” | positive control elsewhere != cleanup governance here |
| “发现 drift 就说明修法很显然” | verifier result does not uniquely determine remediation path |
| “治理后果总是代码改动” | sometimes the right repair is narrowing claims or adding migration guards |

## 5. 一条硬结论

真正成熟的 repair grammar 不是：

`detect drift -> patch something`

而是：

`detect drift -> assign repair authority -> choose remediation layer -> update claims and execution together`

只有中间两层被补上，  
cleanup anti-drift verification 才不会继续停留在“能报警但没人正式负责纠偏”的半治理状态。
