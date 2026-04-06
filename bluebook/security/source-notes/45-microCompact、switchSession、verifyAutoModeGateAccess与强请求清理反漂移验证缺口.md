# microCompact、switchSession、verifyAutoModeGateAccess与强请求清理反漂移验证缺口

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `194` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 当前这次有没有 conform，`

而是：

`如果它将来再漂移，谁会第一时间把这种漂移抓出来。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`cleanup 缺 verifier。`

这句话不够硬。
所以这里单开一篇，只盯住：

- `src/services/compact/microCompact.ts`
- `src/bootstrap/state.ts`
- `src/utils/permissions/getNextPermissionMode.ts`
- `src/utils/permissions/permissionSetup.ts`
- `src/utils/sessionStorage.ts`
- `src/utils/backgroundHousekeeping.ts`
- `src/utils/cleanup.ts`
- `src/utils/plans.ts`

把 repo 已有的三种 anti-drift 正例，与 stronger-request cleanup 当前仍停留在 conformance 层的状态，直接对照出来。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 不知道什么叫 drift。`

而是：

`Claude Code 很知道什么叫 drift，而且已经在别处做出了至少三种 anti-drift verifier；stronger-request cleanup 线今天真正缺的，不是风险意识，而是把同等级 verifier grammar 正式接上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| source-of-truth test verifier | `src/services/compact/microCompact.ts:31-36` | 为什么 repo 已承认 derived truth 必须被测试拉回 source truth |
| atomic anti-drift structure | `src/bootstrap/state.ts:456-466` | 为什么 repo 已承认有些字段关系必须从结构上防漂移 |
| live re-verification | `src/utils/permissions/getNextPermissionMode.ts:7-17`; `src/utils/permissions/permissionSetup.ts:1078-1152` | 为什么 repo 已承认 stale cache 与 live truth 会分叉，因而需要运行时主动复核 |
| stronger-request cleanup conformance cluster | `src/utils/sessionStorage.ts:954-969`; `src/utils/backgroundHousekeeping.ts:24-58`; `src/utils/cleanup.ts:33-44,575-595`; `src/utils/plans.ts:79-106`; `src/utils/cleanup.ts:300-303` | 为什么 cleanup 线当前还只有 conformance 症状，而没有对等 verifier 面 |

## 4. `microCompact` 先证明：真正的 anti-drift verifier 会把 drift 风险直接绑到 source-of-truth test 上

`microCompact.ts:31-36` 明确写道：

`Drift is caught by a test asserting equality with the source-of-truth.`

这句话的关键价值在于，
它同时承认了四件事：

1. 有 source truth
2. 有 derived truth
3. drift 是预期风险
4. verifier 必须被显式做出来

这说明 repo 的 verifier 文化不是模糊口号，
而是非常具体的 engineering pattern：

`drift is expected -> verifier is explicit`

而 stronger-request cleanup 线目前仍停在：

`drift is visible -> verifier still absent`

## 5. `switchSession` 再证明：有些 drift 不该留给测试补，而应被 atomic structure 直接封死

`bootstrap/state.ts:456-466` 把 `sessionId` 与 `sessionProjectDir` 的关系写得很绝：

`cannot drift out of sync`

而且它不是事后报警，
而是一开始就通过 `switchSession(sessionId, projectDir)` 这种 atomic API 让分叉不再有表达机会。

这说明 repo 至少已经掌握了第二种 anti-drift grammar：

`structure forbids drift`

强请求 cleanup 今天的问题就在于：

1. metadata
2. scheduler
3. executor
4. permission
5. resume

这些 plane 仍可以各自变化，
因此 drift 仍有表达机会。

## 6. `verifyAutoModeGateAccess` 再证明：更高阶的 verifier 会主动复核 stale-vs-live divergence，而不是等症状自己暴露

`getNextPermissionMode.ts:7-17` 已经明说：

`cached isAutoModeAvailable` 与 live `isAutoModeGateEnabled()` `can diverge`

于是 `permissionSetup.ts:1078-1152` 真的给出：

`verifyAutoModeGateAccess(...)`

它做的不是注释解释，
而是：

1. fresh read dynamic config
2. compare stale cache and live gate
3. repair runtime truth now

这说明 repo 还掌握了第三种 anti-drift grammar：

`live re-verification against divergence`

而 stronger-request cleanup 线今天仍没有看到对等的：

`verifyCleanupPolicyAlignment()`  
`reverifyCleanupFamilyConformance()`  
或任何 dual-read verifier

## 7. 与这三种正例对照，stronger-request cleanup 当前暴露出的不是“偶发 bug”，而是 verifier grammar 还没接线

stronger-request cleanup 当前已经暴露出：

1. temporal gap  
   startup wording 与 delayed housekeeping 之间的时间差
2. propagation gap  
   `plansDirectory` 被某些 plane 消费，但未被 executor 消费
3. receipt gap  
   `CleanupResult` 存在，却没有 family surfaced receipt

这三类 gap 当前仍主要是：

`阅读源码才能看见`

而不是：

`系统自己会报警`

所以 stronger-request cleanup 今天真正缺的不是再补一句解释，
而是：

`哪一种 anti-drift verifier pattern 应该正式接管这些 gap。`

## 8. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 暂时没有 verifier，只是因为团队没意识到 drift 风险。`

而是：

`repo 明明已经在 microCompact、switchSession 与 verifyAutoModeGateAccess 上展示了成熟的 anti-drift verifier 文化，但 stronger-request cleanup 线仍未正式接上同等级的 verifier grammar；因此 artifact-family cleanup stronger-request cleanup-runtime-conformance-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-anti-drift-verifier signer。`

因此：

`cleanup 线真正缺的不是风险意识，而是把风险意识升级成显式 verifier 的最后一道工程动作。`
