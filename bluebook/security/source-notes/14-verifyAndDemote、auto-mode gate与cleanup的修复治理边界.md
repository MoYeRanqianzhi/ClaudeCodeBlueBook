# verifyAndDemote、auto-mode gate 与 cleanup 的修复治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `163` 时，  
真正需要被单独钉住的已经不是：

`cleanup 线有没有 verifier，`

而是：

`cleanup 线一旦有 verifier，谁来决定如何修。`

如果这个问题只停在主线长文里，  
最容易被压成一句空话：

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

把 repo 里“发现问题”与“施加治理后果”如何被拆开，和 cleanup 线当前尚未长出的 repair governance grammar，直接对照出来。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 不会在发现 drift 后采取行动。`

而是：

`Claude Code 在别处已经很清楚地区分 detection 与 governance consequence；cleanup 线当前缺的不是风险意识，而是同等级的 repair authority 分配。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| auto-mode verification | `src/utils/permissions/permissionSetup.ts:1078-1150` | 谁负责把 stale-vs-live divergence 识别出来 |
| auto-mode governance consequence | `src/utils/permissions/bypassPermissionsKillswitch.ts:74-107` | 谁负责把 verifier 结果真正施加到 app state 与 notification |
| local cycle precheck | `src/utils/permissions/getNextPermissionMode.ts:7-17` | 为什么 detection 可先行，但仍不等于治理主权 |
| plugin verify / demote split | `src/utils/plugins/dependencyResolver.ts:177-233`; `src/utils/plugins/pluginLoader.ts:3192-3194` | 为什么 repo 已显式拥有 verify + demote grammar |
| cleanup repair gap | `src/utils/cleanup.ts:300-303,575-595`; `src/utils/plans.ts:79-110` | 为什么 cleanup 线当前还没有对等 repair-governor plane |

## 4. auto-mode 先证明：repo 已经知道 verifier 只配“发现问题”，不配自己偷偷改世界

`src/utils/permissions/permissionSetup.ts:1078-1150` 的 `verifyAutoModeGateAccess()` 负责：

1. 读 fresh config
2. 对比 stale cache 与 live state
3. 返回 `updateContext` 与 `notification`

它当然已经足够“聪明”，  
但它仍然没有直接去：

1. 改 app state
2. 发 notification
3. 强制把用户踢出模式

这些治理后果被放到了：

`src/utils/permissions/bypassPermissionsKillswitch.ts:74-107`

的 `checkAndDisableAutoModeIfNeeded()`。

这说明 repo 在这里的治理哲学非常清楚：

`先验证，再治理；先暴露 truth，再决定 consequence。`

## 5. `getNextPermissionMode` 再说明：就算 detection 和 UX 流非常近，它也仍然不自动拥有 repair authority

`src/utils/permissions/getNextPermissionMode.ts:7-17` 只是在本地 mode cycling 前做一件事：

`cached truth` 和 `live gate truth` 可能会 diverge，所以先别假装可以安全切换。

这条逻辑很接近用户动作，  
但它仍然只承担：

`preflight detection`

而不承担：

`full repair governance`

它不会决定：

1. GrowthBook config 要不要改
2. circuit breaker 是否应该保持激活
3. 用户承诺语句是否应降级

这进一步说明：

`检测离动作再近，也不等于自动拥有治理主权。`

## 6. plugin 线给出最清晰的命名正例：`verifyAndDemote`

`src/utils/plugins/dependencyResolver.ts:177-233` 的命名极其关键：

`verifyAndDemote`

它说明两步已经被工程上明确承认：

1. verify  
   发现 dependency 结构不成立
2. demote  
   对不再满足约束的 plugin 施加治理后果

`src/utils/plugins/pluginLoader.ts:3192-3194` 也真的消费了这个后果：

`if (demoted.has(p.source)) p.enabled = false`

这条正例非常值钱，  
因为它说明 repo 并不回避：

`verification result can require a capability downgrade`

cleanup 线今天最缺的，  
恰恰就是这种：

`verify + governance consequence`

grammar。

## 7. 对照这些正例，cleanup 线当前尚未回答的其实不是“哪里 drift”，而是“应由哪一层付费修复 drift”

cleanup 线当前已知的 drift 有至少三类：

1. temporal gap  
   文案写得比 scheduler 强
2. propagation gap  
   `plansDirectory` 没有传播到 executor
3. receipt gap  
   `CleanupResult` 没被提升成正式 conformance surface

但就算 verifier 现在能把这三类 gap 全部暴露，  
系统仍然还没有回答：

1. 应该改文案，还是改 runtime
2. 应该让 `cleanupOldPlanFiles()` 跟随 override，还是限制 `plansDirectory`
3. 应该补 conformance receipt，还是缩小“已经符合”的宣称

这些问题都不是 verifier 本身能决定的。  
它们已经进入：

`repair governance`

层。

## 8. 这篇源码剖面给主线带来的四条技术启示

### 启示一

repo 已经在其他子系统里证明：

`verification` 与 `governance consequence` 可以、而且应该被显式拆层。

### 启示二

cleanup 线未来就算补出了 verifier，  
也仍然需要再决定：

1. 谁能降级承诺
2. 谁能调整 executor
3. 谁能修改 metadata 语法

### 启示三

plugin 的 `verifyAndDemote` 是 cleanup 线极好的设计镜子。  
cleanup 线未必照抄 demote 语义，  
但必须同样回答 “发现 drift 后谁配改变 capability / promise state”。

### 启示四

真正成熟的修复治理不只是 patch code。  
它也可能是：

1. 缩窄承诺语言
2. 增加迁移守卫
3. 暂时禁用某条路径
4. 把某个 override 改成需更强 receipt 才能生效

## 9. 一条硬结论

这组源码真正说明的不是：

`cleanup 线只要把 verifier 补出来，剩下的治理问题就会自然解决。`

而是：

`repo 在 auto-mode 与 plugin 线已经明确把 verification 与 governance consequence 分层；cleanup 线当前缺的正是同等级的 repair-governor plane。`

因此：

`artifact-family cleanup anti-drift verifier signer` 仍不能越级冒充 `artifact-family cleanup repair-governor signer`。
