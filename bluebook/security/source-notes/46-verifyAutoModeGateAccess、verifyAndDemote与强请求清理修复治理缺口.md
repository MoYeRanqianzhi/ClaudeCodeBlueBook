# verifyAutoModeGateAccess、verifyAndDemote与强请求清理修复治理缺口

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `195` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 有没有 verifier，`

而是：

`verifier 一旦抓到 drift，谁来决定修什么、怎么修、由哪一层承担代价。`

如果这个问题只停在主线长文里，
最容易又被压成一句空话：

`verifier 不等于 governor。`

这句话还不够具体。
所以这里单开一篇，只盯住：

- `src/utils/permissions/permissionSetup.ts`
- `src/utils/permissions/bypassPermissionsKillswitch.ts`
- `src/utils/permissions/getNextPermissionMode.ts`
- `src/utils/plugins/dependencyResolver.ts`
- `src/utils/plugins/pluginLoader.ts`
- `src/utils/cleanup.ts`
- `src/utils/plans.ts`

把 repo 里“发现问题”和“施加治理后果”如何被拆开，和 stronger-request cleanup 线当前尚未长出的 repair grammar，直接对照出来。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 不会在发现 drift 后采取行动。`

而是：

`Claude Code 在别的子系统里已经清楚地区分 detection 与 governance consequence；stronger-request cleanup 线当前缺的不是风险意识，而是同等级的 repair authority 分配。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| auto-mode verification | `src/utils/permissions/permissionSetup.ts:1078-1152` | 谁负责把 stale-vs-live divergence 识别出来 |
| auto-mode governance consequence | `src/utils/permissions/bypassPermissionsKillswitch.ts:74-116` | 谁负责把 verifier 结果真正施加到 app state 与 notification |
| local cycle precheck | `src/utils/permissions/getNextPermissionMode.ts:7-17` | 为什么 detection 可先行，但仍不等于治理主权 |
| plugin verify / demote split | `src/utils/plugins/dependencyResolver.ts:157-233`; `src/utils/plugins/pluginLoader.ts:3188-3198` | 为什么 repo 已显式拥有 verify + governance consequence grammar |
| cleanup repair gap | `src/utils/cleanup.ts:575-595`; `src/utils/plans.ts:79-106`; `src/utils/cleanup.ts:300-303` | 为什么 stronger-request cleanup 线当前还没有对等 repair-governor plane |

## 4. auto-mode 先证明：repo 已经知道 verifier 只配“发现问题”，不配自己偷偷改世界

`permissionSetup.ts:1078-1152` 的 `verifyAutoModeGateAccess()` 负责：

1. fresh read config
2. compare stale cache and live gate
3. return `updateContext` and `notification`

它当然已经足够“聪明”，
但它仍然没有直接去：

1. 改 app state
2. 发 notification
3. 强制把用户踢出 mode world

这些治理后果被放到了：

`bypassPermissionsKillswitch.ts:74-116`

的 `checkAndDisableAutoModeIfNeeded()`。

这说明 repo 在这里的治理哲学非常清楚：

`先验证，再治理；先暴露 truth，再决定 consequence。`

## 5. `getNextPermissionMode` 再说明：就算 detection 和用户动作非常近，它也仍然不自动拥有 repair authority

`getNextPermissionMode.ts:7-17` 只是在本地 mode cycling 前做一件事：

`cached truth` 和 live gate truth 可能 diverge，所以先别假装可以安全切换。

它不会决定：

1. dynamic config 要不要改
2. circuit breaker 是否该保持激活
3. 用户承诺语言是否该降级

这进一步说明：

`检测离动作再近，也不等于自动拥有治理主权。`

## 6. plugin 线给出更硬正例：`verifyAndDemote` 已经把 verification 与 governance consequence 明确并列写进命名

`dependencyResolver.ts:157-233` 最值钱的地方，
就在于命名：

`verifyAndDemote`

它显式承认：

1. verify  
   发现 dependency truth 是否成立
2. demote  
   对不再满足约束的 plugin 施加 capability consequence

`pluginLoader.ts:3188-3198` 还会真正消费这个结果：

1. `if (demoted.has(p.source)) p.enabled = false`
2. 注释明确写出  
   `Demotion is session-local: does NOT write settings (user fixes intent via /doctor).`

这说明 repo 不只知道“修复需要后果”，
还知道 repair governance 至少要回答：

1. 后果是什么
2. 作用域是什么
3. 不该碰哪层真相

## 7. 对照这些正例，stronger-request cleanup 线当前尚未回答的不是“哪里 drift”，而是“谁来决定修哪一层”

stronger-request cleanup 当前已知至少有三类 drift：

1. temporal gap  
   startup wording 强于 runtime scheduler
2. propagation gap  
   `plansDirectory` 被部分 plane 消费、未被 executor plane 跟随
3. receipt gap  
   `CleanupResult` 未升格成 family surfaced receipt

但当前仍没有一处可见代码正式决定：

1. temporal gap 该修 scheduler，还是改 wording
2. propagation gap 该修 executor，还是限制 override semantics
3. receipt gap 该补 surfaced receipt，还是缩小 conformance promise

这些问题都不是 verifier 自己能回答的。
它们已经进入：

`repair governance`

层。

## 8. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 只要把 verifier 补出来，剩下的治理问题就会自然解决。`

而是：

`repo 在 auto-mode 与 plugin 线已经明确把 verification 与 governance consequence 分层；stronger-request cleanup 线当前缺的正是同等级的 repair-governor plane。`

因此：

`artifact-family cleanup stronger-request cleanup-anti-drift-verifier signer` 仍不能越级冒充 `artifact-family cleanup stronger-request cleanup-repair-governor signer`。
