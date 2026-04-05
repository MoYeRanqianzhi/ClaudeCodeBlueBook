# 安全资格可机检不变量：为什么transition constitution若不能被schema、assertion与property-test自动验证，就仍然太依赖维护者记忆

## 1. 为什么在 `110` 之后还必须继续写“可机检不变量”

`110-安全资格合法跃迁宪法` 已经回答了：

`统一状态机不仅要会调度，还必须显式拒绝那些不合法的状态跃迁。`

但如果继续往下追问，  
还会碰到一个更严格的问题：

`这些宪法条文如何被证明真的还在生效？`

如果答案只是：

`靠维护者记得这些 guard 不能删`

那宪法仍然只是：

`写给人看的制度`

而不是：

`能被机器持续执行的制度`

这会留下三个根本风险：

1. 未来重构时 guard 被删除但没人察觉
2. 新增路径绕过旧宪法，但 review 没有拼出全局图
3. 系统明明已经有“正确直觉”，却无法持续自动证明自己没退化

所以 `110` 之后必须继续补出的下一层就是：

`安全资格可机检不变量`

也就是：

`transition constitution 若不能被 schema、runtime assertion 与 property-test 自动验证，就仍然太依赖维护者记忆。`

## 2. 最短结论

从源码看，Claude Code 已经拥有不少“接近不变量”的运行时守卫，  
但它们目前大多仍是局部 guard，而不是统一的 machine-checkable invariant system：

1. `notifications` 用 current-key 比对、duplicate prevention 与 absent-remove guard 防止非法改口  
   `src/context/notifications.tsx:54-68,172-188,193-212`
2. `bridgePointer` 用 `safeParse + TTL` 防止 invalid/stale pointer 继续代表 current  
   `src/bridge/bridgePointer.ts:83-109`
3. `useReplBridge` 用 error-presence guard、防重写 guard 和 fuse guard 防止 bridge 状态机越级跳转  
   `src/hooks/useReplBridge.tsx:113-127,341-360,633-642`
4. `transitionPermissionMode` 已经被明确描述成“centralized transition”，并且在外围 guard 不先执行时会导致 “3-way invariant violation”  
   `src/hooks/useReplBridge.tsx:417-453`; `src/utils/permissions/permissionSetup.ts:597-645`
5. 底层 `store.ts` 只做 `Object.is(next, prev)` 这类最薄的通用约束，说明更强的不变量并未被统一下沉到状态容器  
   `src/state/store.ts:20-27`

所以这一章的最短结论是：

`Claude Code 现在已经有很多不变量的原材料，但还缺把这些 guard 提炼成可自动验证的统一不变量体系。`

再压成一句：

`守卫已在，机检未成。`

## 3. 当前源码里已经存在三种“半成品不变量”

## 3.1 schema invariant

最清楚的例子是 `bridgePointer`。

`src/bridge/bridgePointer.ts:83-109` 当前强制：

1. pointer 必须过 `safeParse`
2. pointer 必须没有 stale 超时
3. 否则直接 clear + return null

这其实已经是在执行一条 machine-checkable invariant：

`只有 schema-valid 且 freshness-valid 的 pointer 才配进入 current resumability universe。`

也就是说，  
这里已经不是“注释说应该这样”，  
而是机器真的在每次读取时执行这一规则。

## 3.2 runtime assertion / guard invariant

`notifications` 是这类的典型：

1. 旧 timeout 清 current 前先比对 `current.key`
2. duplicate key 不允许重复入队
3. absent 对象不允许被 remove 成“已删除”

见：
`src/context/notifications.tsx:54-68,172-188,193-212`

这些 guard 的本质是：

`如果 invariant 前提不成立，就 return prev，拒绝非法跃迁。`

这已经很接近 assertion 语义。  
只不过它们现在还分散在局部更新路径里。

## 3.3 centralized transition invariant

最值得注意的是 `permission mode` 这一条。

`src/hooks/useReplBridge.tsx:417-453` 明确写出：

1. Policy guards 必须先于 `transitionPermissionMode`
2. 否则会造成 `3-way invariant violation`

而 `src/utils/permissions/permissionSetup.ts:597-645` 又提供了统一的：

`transitionPermissionMode(fromMode, toMode, context)`

这其实已经是一个非常强的信号：

`作者已经知道，有些高风险状态变化必须走集中 transition 函数，并且外围 guard 是状态不变量的一部分。`

这说明可机检不变量并不是异想天开，  
而是：

`源码里已经长出半套范式。`

## 4. 但当前这些不变量还存在三个结构问题

## 4.1 它们大多还是局部 guard，不是统一 invariant catalog

现在的问题不是系统没有 guard，  
而是：

1. notifications 有自己的 guard
2. bridge 有自己的 guard
3. pointer 有自己的 schema gate
4. permission mode 有自己的 centralized transition

这些加起来当然很强，  
但它们还没有被统一提升成：

`一张明确列出 candidate invariants 的 catalog`

于是 review 时仍然容易变成：

`读很多实现，猜哪些 guard 实际上是宪法条文。`

## 4.2 它们多数只能在运行中“碰到才拒绝”，还没有被离线系统性验证

例如：

1. duplicate notification 只有在真的入队时才被挡
2. stale pointer 只有在真的 read 时才被清
3. bridge timeout 只有在 timer 触发时才会检查 error 仍是否存在

这说明当前系统更偏向：

`runtime defensive guard`

而不是：

`offline machine-checkable property`

两者的差别在于：

1. 前者能在事发当场止损
2. 后者能在重构前/测试时提前发现退化

## 4.3 很多 guard 还没有被抽象成跨模块复用的不变量模板

其实前面几章已经反复看见同一类原则在不同模块里重现：

1. stale actor 不得改写新 current
2. duplicate family 不得并存
3. completion 不得绕过 gate
4. transient failure 不得被误杀成 permanent retire
5. stronger positive state 不得无 bundle 直升

这说明 Claude Code 当前不是缺规则，  
而是缺：

`把相似 guard 提炼成 invariant family 的最后一步。`

## 5. 从第一性原理看，为什么 security constitution 最终必须落到 machine-checkable invariant

因为安全系统真正要抵抗的，不只是攻击者，  
还有：

`未来的自己。`

也就是：

1. 后来的重构
2. 新路径接入
3. 多模块协同中的局部最优
4. 维护者对旧制度的遗忘

如果一条安全宪法只能靠维护者记忆，  
那它迟早会退化成：

`好像大家都知道，但没人能证明它还在。`

而 machine-checkable invariant 恰好解决的是这个问题：

`把“大家都知道不能这样”升级成“机器会持续证明不能这样”。`

## 6. 哪些不变量最值得先机检化

结合当前源码，最值得优先提炼成 machine-checkable invariant 的至少有五类。

## 6.1 stale actor cannot mutate current truth

候选规则：

1. 旧 timeout 不得清掉新 current
2. 旧 failure timer 不得在 error 已清时再 disable bridge

对应证据：

`notifications.tsx:54-68`
`useReplBridge.tsx:354-360,636-642`

这是最适合做 property test 的一类：  
模拟 old timer / new current / reordered callbacks，  
验证 final state 不会被 stale actor 破坏。

## 6.2 duplicate family cannot coexist

候选规则：

1. 同 key notification 不能重复入队
2. 同一状态槽位不能被分裂成并存对象

对应证据：

`notifications.tsx:172-188`

这同样非常适合 property test：  
任意顺序重复 add，相同 key 的最终 family cardinality 必须为 1。

## 6.3 strong positive state requires evidence bundle

候选规则：

1. bridge `connected/ready/active` 不得无 handle/url/id bundle 成立
2. completion 型布尔恢复不得绕过 verifier

对应证据：

`useReplBridge.tsx:230-245,252-258,525-535,592-605`
`refresh.ts:59-67,123-138`

这类不变量适合做 transition-table tests：  
给定缺 bundle / 缺 verifier 的输入，  
系统不应进入强正向状态。

## 6.4 transient != fatal

候选规则：

1. transient reconnect failure 不能 clear pointer
2. fatal reconnect failure 不能 keep resumable pointer

对应证据：

`bridgeMain.ts:2524-2534`

这类不变量适合做 table-driven tests：  
不同 failure class 输入，  
必须得到不同 retire policy。

## 6.5 policy guards must precede centralized transitions

候选规则：

1. `transitionPermissionMode` 不能在 bypass/auto gate 未通过时裸执行
2. 否则会制造 “3-way invariant violation”

对应证据：

`useReplBridge.tsx:417-453`
`permissionSetup.ts:597-645`

这类最适合做 integration invariant tests：  
验证 guard-before-transition 的顺序不能被重构打乱。

## 7. 当前架构最自然的三层机检方案

如果沿着现有源码最自然地演化，  
我会建议三层并行：

## 7.1 schema-level checks

适用于：

1. pointer
2. serialized state artifacts
3. external metadata bundles

作用：

`证明对象在语法和基本形态上可被承认为候选真相。`

## 7.2 runtime assertions / transition guards

适用于：

1. notifications queue
2. bridge failure timers
3. plugin refresh completion

作用：

`在运行时立刻拒绝局部非法跃迁。`

## 7.3 property tests / transition-table tests

适用于：

1. duplicate prevention
2. stale actor isolation
3. transient-vs-fatal branch separation
4. guard-before-transition ordering

作用：

`在重构前系统性证明这些宪法条文没有退化。`

## 8. 技术先进性：Claude Code 已经具备从“guard-rich system”升级到“machine-checked system”的条件

Claude Code 当前的先进性，不只在它 guard 多，  
更在于它的 guard 已经满足三个升级前提：

1. 很多 guard 明确绑定在关键状态跃迁上
2. 很多 guard 已经带有清晰的哲学语义，而不是纯技术偶然
3. 至少在 permission mode 这里，作者已经接受“centralized transition + guard ordering”这种模式

这意味着它距离 machine-checked system 并不远。  
真正缺的不是理念，  
而是：

`把这些 guard family 提炼成显式 invariants，再交给测试与运行时机制持续验证。`

## 9. 苏格拉底式反思：如果要把这一层做得更好，还应继续追问什么

可以继续追问七个问题：

1. 当前哪些 guard 已经足够稳定，适合提炼成 property tests
2. 当前哪些 guard 只是运行时补丁，还没抽象到 invariant level
3. 当前哪些 invariants 最容易在重构中被不小心删除
4. 当前哪些 invariants 若失效，后果最严重
5. 当前哪些 invariants 应写成 schema check，哪些应写成 state-machine test
6. 当前 repo 是否应该为这些高风险模块单独建立 transition-table tests
7. 当前统一安全控制台若要向用户解释“为什么这里不能这样跳”，是否已经有可复用的不变量定义

这些问题共同追问的是：

`系统是否已经从“作者知道规则”升级到“机器也知道规则”。`

## 10. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的下一步不是：

`把 transition constitution 停留在注释、文档和局部 guard，`

而是：

`把它继续提升成可机检不变量，让 schema、assertion 与 property-test 持续证明这些非法跃迁真的还在被拒绝。`

因为只有这样，  
系统才能从：

`拥有安全原则`

进一步升级到：

`持续证明自己仍然遵守这些安全原则。`
