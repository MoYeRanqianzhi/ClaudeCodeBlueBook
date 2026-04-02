# 安全资格分层验证架构：为什么真正成熟的安全系统必须把schema、guard、transition、ledger与tests做成验证金字塔

## 1. 为什么在 `111` 之后还必须继续写“分层验证架构”

`111-安全资格可机检不变量` 已经回答了：

`transition constitution 若不能被 schema、assertion 与 property-test 自动验证，就仍然太依赖维护者记忆。`

但如果继续往下追问，  
还会碰到一个更系统的问题：

`这些验证到底应该怎样分层？`

因为即便大家都同意要机检，  
如果没有分层架构，  
系统仍然会在两个极端之间摇摆：

1. 什么都堆到运行时 guard
2. 什么都指望测试补救

两者都不够。  
真正成熟的安全验证，  
必须明确回答：

1. 哪些规则应该在 schema 层挡住
2. 哪些规则应该在 runtime guard 层拒绝
3. 哪些规则应该在 centralized transition 层统一裁定
4. 哪些规则应该在 ledger/diff hook 层被记录与传播
5. 哪些规则必须由 automated tests 持续回归验证

所以 `111` 之后必须继续补出的下一层就是：

`安全资格分层验证架构`

也就是：

`真正成熟的安全系统必须把 schema、guard、transition、ledger 与 tests 做成一座验证金字塔，而不是把所有验证责任压给某一层。`

## 2. 最短结论

从源码看，Claude Code 已经天然长出了多层验证雏形，  
但这些层次还没有被完全显式组织成统一验证架构：

1. `bridgePointer` 已经是 schema + freshness 层  
   `src/bridge/bridgePointer.ts:83-109`
2. `notifications` 与 `useReplBridge` 已经是 runtime guard 层  
   `src/context/notifications.tsx:54-68,172-188,193-212`; `src/hooks/useReplBridge.tsx:113-127,341-360,633-642`
3. `transitionPermissionMode()` 已经是 centralized transition 层  
   `src/utils/permissions/permissionSetup.ts:597-645`
4. `onChangeAppState()` 已经是 diff/ledger propagation 层  
   `src/state/onChangeAppState.ts:50-92`
5. 但针对这些高风险模块的本地 `test/spec` 文件检索结果是 `0`，说明 tests 层还没有和前四层形成完整金字塔  
   本地检索：`rg --files ... | rg '(__tests__|\\.test\\.|\\.spec\\.)' | wc -l => 0`

所以这一章的最短结论是：

`Claude Code 已经拥有验证金字塔的前四层雏形，但第五层 automated tests 仍明显偏弱，整座塔还没有完全闭环。`

再压成一句：

`层次已现，塔未封顶。`

## 3. 当前源码已经清楚地分化出五层验证责任

## 3.1 第一层：schema / syntax gate

最清楚的例子依然是 `bridgePointer`。

`src/bridge/bridgePointer.ts:83-109` 做了两件事：

1. `safeParse`
2. `freshness TTL`

这层验证的职责不是理解业务全貌，  
而是先回答：

`这个对象有没有资格进入讨论范围。`

它防的是：

1. invalid shape
2. corrupted data
3. stale artifact pretending to be live

所以 schema 层的哲学是：

`先证明它像个合法候选对象，再允许更高层继续讨论它。`

## 3.2 第二层：runtime guard

`notifications.tsx` 和 `useReplBridge.tsx` 代表这一层。

它们通过：

1. current-key compare
2. duplicate prevention
3. absent-remove no-op
4. fuse threshold
5. error-presence timer guard

在运行时当场拒绝非法跃迁。

这层的职责是：

`一旦进入真实 interleaving / callback / timer 世界，立刻阻断局部非法改口。`

它防的是：

1. stale actor 改写 current
2. duplicate family coexist
3. cleared error 仍触发 disable
4. repeated failure 仍假装可普通 retry

所以 runtime guard 层的哲学是：

`在真实时序里止血。`

## 3.3 第三层：centralized transition

`src/utils/permissions/permissionSetup.ts:597-645` 的 `transitionPermissionMode()`  
已经是一个很清晰的中心化跃迁函数。

而 `src/hooks/useReplBridge.tsx:417-453` 又明确说：

1. policy guards 必须先于 transition 执行
2. 否则会出现 `3-way invariant violation`

这层的职责是：

`让高风险状态变化不再只是 scattered writes，而是收口到同一个跃迁语法里。`

它防的是：

1. 同类状态变化被多处各写各的
2. guard 与 transition 顺序被重构打乱
3. 某些副作用只在部分入口执行

所以 centralized transition 层的哲学是：

`先统一改口语法，再统一裁定改口合法性。`

## 3.4 第四层：ledger / diff propagation

`src/state/onChangeAppState.ts:50-92` 说明 mode 变化不会只停在本地状态里，  
而会通过统一 diff choke point：

1. `notifySessionMetadataChanged`
2. `notifyPermissionModeChanged`

把结果传播出去。

这层的职责不是第一次挡错，  
而是：

`让已经合法发生的变化被正确记录、外化与同步。`

它防的是：

1. 本地变了，外部不知道
2. 状态成立了，但没有被审计链记录
3. 一个 subsystem 的合法变化没有被其他系统面知晓

所以 ledger/diff 层的哲学是：

`合法变化必须可追溯、可传播、可解释。`

## 3.5 第五层：automated tests / machine-checked regression

这里最关键的证据反而是“缺失”：

本地检索显示，
针对这些高风险模块的 `test/spec` 文件数量为 `0`。

这说明：

1. 前四层很多已经存在
2. 但把这些规则持续证明下去的 automated tests 还没有显式跟上

于是系统当前更像：

`guard-rich architecture`

而不是：

`fully machine-checked verification pyramid`

## 4. 为什么这五层不能互相替代

这是这一章最关键的技术判断。

## 4.1 schema 不能替代 runtime guard

因为 schema 只能回答：

`对象长得像不像`

却无法回答：

`这个旧 timer 现在还能不能清 current`

它不理解真实时序。

## 4.2 runtime guard 不能替代 centralized transition

因为 guard 再多，  
如果没有统一 transition 入口，  
同类规则仍会分散在各模块里。

它能止血，  
但不一定能统一语法。

## 4.3 centralized transition 不能替代 ledger

因为 transition 再统一，  
如果没有账本与 diff propagation，  
系统仍然可能：

1. 只在本地知道
2. 不能解释给其他 surface
3. 不能对外同步

## 4.4 ledger 不能替代 tests

因为 ledger 只能记录已经发生的变化，  
却不能在未来重构前证明：

`这些 guard 还没被删，这些顺序还没被打乱。`

## 4.5 tests 也不能替代前四层

因为测试不能代替运行时保护。  
没有 schema / guard / transition / ledger，  
系统在生产环境里仍然会直接暴露。

所以真正成熟的回答不是“哪一层最重要”，  
而是：

`每一层都只负责自己最擅长的那一类验证。`

## 5. 从第一性原理看，安全验证为什么必须是金字塔而不是平面

因为安全错误本身就分布在不同抽象层：

1. 有些错是对象格式错
2. 有些错是局部时序错
3. 有些错是跃迁语法错
4. 有些错是跨系统传播错
5. 有些错是未来重构退化错

如果你试图用单一层去解决所有错误，  
就会出现失衡：

1. 全靠 schema，会漏掉时序与语义
2. 全靠 runtime guard，会变成 scattered patches
3. 全靠 transition 函数，会漏掉外部同步
4. 全靠 tests，会让生产时仍然脆弱

所以验证必须是一座塔，  
因为错误本来就发生在不同高度。

## 6. Claude Code 在这方面的先进性与当前缺口

它先进的地方在于：

1. schema 层已经存在
2. runtime guard 很丰富
3. permission mode 已经有 centralized transition 范式
4. diff propagation 也有统一 choke point 雏形

这说明它并不是从零开始。  
它已经具备了验证金字塔的大部分骨架。

但当前缺口也很明确：

1. 高风险 lifecycle invariants 还没形成统一 catalog
2. 很多 centralized transition 还没从局部子系统抽出来
3. tests 层明显偏薄，至少在本地可见源码中没有对应 `test/spec` 文件

所以它的真实状态更准确地说是：

`一个已经长出验证金字塔骨架、但还没把塔顶封起来的系统。`

## 7. 下一代分层验证架构应该怎样组织

如果沿着当前实现自然演化，我会建议：

## 7.1 Layer A: schema validation

适用对象：

1. pointer
2. serialized resumability objects
3. external metadata bundles

职责：

`语法与基本资格入场验证`

## 7.2 Layer B: runtime guard

适用对象：

1. timeout callbacks
2. duplicate family writes
3. stale actor mutations
4. retry/fuse timers

职责：

`时序现场的局部非法跃迁阻断`

## 7.3 Layer C: centralized transition

适用对象：

1. permission mode
2. bridge lifecycle
3. plugin refresh lifecycle
4. pointer keep/clear decisions

职责：

`统一 state machine grammar 与 gate evaluation`

## 7.4 Layer D: ledger / propagation

适用对象：

1. session metadata sync
2. UI explanation surfaces
3. audit trail

职责：

`合法变化的记账、传播与解释`

## 7.5 Layer E: automated tests

适用对象：

1. invariant tables
2. property tests for timers/interleavings
3. transition-table tests
4. integration tests for guard-before-transition ordering

职责：

`持续证明前四层没有在重构中退化`

## 8. 苏格拉底式反思：如果要把这一层做得更好，还应继续追问什么

可以继续追问八个问题：

1. 当前哪些规则被错放在了 schema 层，实际上应放到 transition 层
2. 当前哪些规则被错放在了 runtime guard 层，实际上应抽成 invariant catalog
3. 当前哪些规则已经适合 centralize，却仍留在局部 hook
4. 当前哪些 ledger record 若缺失，会让合法变化无法被解释
5. 当前 tests 层最该先补哪一类：property、table、integration
6. 当前是否存在一些 guard 同时承担了两三层责任，导致代码难以维护
7. 当前统一安全控制台若要向用户解释“为什么这里被拒绝”，需要调用哪一层的结果
8. 当前 repo 是否应把“验证金字塔”本身写成开发准则

这些问题共同逼问的是：

`系统到底是在零散地防御，还是已经开始自觉地组织自己的验证层级。`

## 9. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的目标不是：

`多写几个 guard，`

而是：

`把 schema、runtime guard、centralized transition、ledger 与 automated tests 组织成一座职责清晰、彼此衔接的分层验证金字塔。`

因为只有这样，  
系统才能从：

`局部看起来很安全`

进一步升级到：

`整体上可证明地持续安全。`
