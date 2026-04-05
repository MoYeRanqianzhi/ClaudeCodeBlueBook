# microCompact、verifyAutoModeGateAccess 与 cleanup 的反漂移验证边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `162` 时，  
真正需要被单独钉住的已经不是：

`cleanup 线有没有运行时符合性问题，`

而是：

`repo 明明已经在别处发明了 anti-drift verifier，为什么 cleanup 线还没有长出同等级的验证面。`

如果这个问题只停在主线长文里，  
最容易被压成一句模糊判断：

`cleanup 缺 verifier。`

这句话不够强。  
所以这里单开一篇，只盯住：

- `src/services/compact/microCompact.ts`
- `src/bootstrap/state.ts`
- `src/utils/permissions/permissionSetup.ts`
- `src/utils/permissions/getNextPermissionMode.ts`
- `src/utils/cleanup.ts`
- `src/utils/backgroundHousekeeping.ts`
- `src/utils/sessionStorage.ts`
- `src/utils/plans.ts`

把 repo 已有的三种 anti-drift 正例，与 cleanup 线当前仍停留在 conformance 之前后的状态，直接对照出来。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 不知道什么叫 drift。`

而是：

`Claude Code 很知道什么叫 drift，而且已经在其他子系统里发明了至少三种 anti-drift pattern；cleanup 线之所以值得被单独追问，不是因为团队缺少 verifier 文化，而是因为这条线还没有把同样的文化正式接上来。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| source-of-truth anti-drift test | `src/services/compact/microCompact.ts:31-36` | 为什么 repo 已承认某些 derived truth 必须被测试拴回 source-of-truth |
| atomic anti-drift structure | `src/bootstrap/state.ts:456-466` | 为什么 repo 已承认某些字段关系必须从结构上防漂移 |
| live re-verification anti-drift | `src/utils/permissions/permissionSetup.ts:1078-1150`; `src/utils/permissions/getNextPermissionMode.ts:7-17` | 为什么 repo 已承认 stale cache 与 live truth 会分叉，因而需要运行时再验证 |
| cleanup conformance cluster | `src/utils/sessionStorage.ts:954-969`; `src/utils/backgroundHousekeeping.ts:24-58`; `src/utils/cleanup.ts:33-44,575-595`; `src/utils/plans.ts:79-110`; `src/utils/cleanup.ts:300-303` | 为什么 cleanup 线当前还缺同等级的 anti-drift verifier 面 |

## 4. `microCompact` 先证明：repo 不只是会写注释，它会把“这里会漂移”直接绑定到测试

`src/services/compact/microCompact.ts:31-36` 明确写道：

`Drift is caught by a test asserting equality with the source-of-truth.`

这行注释为什么这么重要？

因为它不是泛泛提醒“请小心”。  
它已经同时声明：

1. 这里存在一个 source-of-truth
2. 这里还有一个派生值
3. 派生值未来可能会漂移
4. 因而必须有 test 把它拉回去

这说明 repo 的 verifier 文化并不抽象。  
它已经有一种非常明确的 anti-drift pattern：

`derived truth must be tested against source truth`

如果 cleanup 线也已有同等级 verifier，  
我们应该能在当前可见源码里看到相似的：

1. source truth 定义
2. drift threat 自觉
3. 对应测试或验证面

但目前还没有看到 cleanup 线达到这一步。

## 5. `switchSession` 再证明：repo 也知道有些漂移不能靠测试补，而必须靠结构性原子更新直接封死

`src/bootstrap/state.ts:456-466` 写得非常干脆：

`sessionId` 与 `sessionProjectDir` `cannot drift out of sync`

而且它不是事后发现 drift 再补日志，  
而是一开始就把 API 设计成：

`switchSession(sessionId, projectDir)` 统一切换

这里展示的 anti-drift pattern 和 microCompact 不同：

1. microCompact 是  
   `test catches drift`
2. switchSession 是  
   `structure forbids drift`

这说明 repo 的 verifier 文化至少已经有两种成熟形态：

1. test-based anti-drift
2. structure-based anti-drift

cleanup 线今天最值得追问的地方，  
就在于它显然已经复杂到足以需要这两种能力中的至少一种，  
却仍没有看到同等级的显式接入。

## 6. `verifyAutoModeGateAccess` 再证明：repo 甚至还知道第三种更难的 anti-drift 形态，即 stale state 与 live truth 的运行时再验证

`src/utils/permissions/getNextPermissionMode.ts:7-17` 直接写出：

`cached isAutoModeAvailable` 与 live `isAutoModeGateEnabled()` `can diverge`

于是 `src/utils/permissions/permissionSetup.ts:1078-1150` 真的给出：

`verifyAutoModeGateAccess(...)`

它做的事情不是“事后解释为什么出错”，  
而是：

1. 重新读取 fresh config
2. 对比 stale cache 与 live gate
3. 在当前 runtime 中修正可用性 truth

这里的 anti-drift pattern 比前两个更高级：

1. 不是静态 test
2. 不是纯结构性原子更新
3. 而是运行时主动复核 stale-vs-live divergence

也就是说，repo 已经拥有第三种 verifier 文化：

`live re-verification against possible divergence`

而 cleanup 线今天仍没有看到等价的：

`verifyCleanupPolicyAlignment()`  
`reverifyCleanupFamilyConformance()`  
或任何 dual-read verifier

## 7. 与这三种正例对照，cleanup 线暴露出的不是“偶发 bug”，而是 verifier grammar 还没接上

cleanup 线今天已经展示出：

1. temporal gap  
   `cleanupPeriodDays=0` 的强文案与 delayed housekeeping 之间的时间差
2. propagation gap  
   `plansDirectory` 被 path / permission 平面消费，但未被 cleanup executor 消费
3. receipt gap  
   `CleanupResult` 存在，却没有被提升成正式回执

这三种 gap 本身当然重要，  
但更重要的是：

`当前没有哪一种显式 anti-drift pattern 正式接管它们。`

既没有：

1. 像 microCompact 那样的 source-of-truth drift test
2. 也没有像 switchSession 那样的结构性原子约束
3. 也没有像 auto-mode gate 那样的 runtime re-verifier

所以 cleanup 线当前真正缺的不是“更多解释”，  
而是：

`哪一种 verifier pattern 应被正式引入，以及由谁持有。`

## 8. 这篇源码剖面给主线带来的四条技术启示

### 启示一

anti-drift verifier 不是抽象概念。  
repo 当前至少已经有三种成熟形态：

1. source-of-truth test
2. atomic structure
3. live re-verification

### 启示二

cleanup 线当前的问题，不只是 drift risk 可见，  
而是 drift risk 可见之后还没有明确挂接到上面三种 verifier grammar 的任一种。

### 启示三

plans family 是最好的报警器。  
它说明一条 policy 一旦跨越 settings、path helper、permission、cleanup 多个平面，  
没有 anti-drift verifier 几乎迟早会暴露传播不一致。

### 启示四

真正成熟的做法不只是再加 receipt。  
receipt 只能回答：

`this run happened`

verifier 还必须回答：

`future drift will fail loudly`

## 9. 一条硬结论

这组源码真正说明的不是：

`cleanup 线暂时没有 verifier，只是因为团队还没意识到 drift 风险。`

而是：

`repo 明明已经在其他系统里展示了成熟的 anti-drift verifier 文化，但 cleanup 线仍未正式接上同等级的 verifier grammar；因此 artifact-family cleanup runtime-conformance signer 仍不能越级冒充 artifact-family cleanup anti-drift verifier signer。`

因此：

`cleanup 线真正缺的不是风险意识，而是把风险意识升级成显式 verifier 的最后一道工程动作。`
