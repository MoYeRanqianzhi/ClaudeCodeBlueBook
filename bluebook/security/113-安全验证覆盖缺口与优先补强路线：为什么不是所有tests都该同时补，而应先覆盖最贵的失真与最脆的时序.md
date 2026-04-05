# 安全验证覆盖缺口与优先补强路线：为什么不是所有tests都该同时补，而应先覆盖最贵的失真与最脆的时序

## 1. 为什么在 `112` 之后还必须继续写“覆盖缺口与优先补强路线”

`112-安全资格分层验证架构` 已经回答了：

`成熟的安全系统必须把 schema、guard、transition、ledger 与 tests 组织成验证金字塔。`

但如果继续往下追问，  
还会碰到一个现实问题：

`既然 tests 层是当前最弱的一层，那到底该先补哪里？`

如果答案只是：

`把所有地方都补一遍`

那在工程上通常是不可执行的。  
真正有效的安全补强，  
必须回答：

1. 哪些模块的回归成本最高
2. 哪些路径的时序最脆
3. 哪些 bug 已经在注释里留下前科
4. 哪些规则最适合先变成 property/table/integration tests

所以 `112` 之后必须继续补出的下一层就是：

`安全验证覆盖缺口与优先补强路线`

也就是：

`不是所有 tests 都该同时补，而应先覆盖那些一旦退化就最贵、最隐蔽、最容易再次发生的失真与时序缺口。`

## 2. 最短结论

从源码看，Claude Code 当前最值得优先补强的并不是“所有业务功能”，  
而是那些已经显露出历史 bug、race 或高代价回归迹象的安全生命周期路径：

1. `useManagePlugins` 已明确记录 previous auto-refresh 存在 stale-cache bug  
   `src/hooks/useManagePlugins.ts:289-302`
2. `refresh.ts` 已明确记录 race / stale memoized result / issue #15521  
   `src/utils/plugins/refresh.ts:81-88,140-145`
3. `useReplBridge` 已明确记录 repeated failures 会制造 OAuth 401 风暴，以及 cancelled throws 曾导致 spurious setAppState / stale error  
   `src/hooks/useReplBridge.tsx:31-40,616-644`
4. permission mode 路径已明确写出 “3-way invariant violation” 风险  
   `src/hooks/useReplBridge.tsx:417-453`
5. `onChangeAppState` 已明确记录 mode sync 曾在 8+ mutation paths 中分叉，导致 external_metadata stale、web UI out of sync  
   `src/state/onChangeAppState.ts:50-64`
6. 本地源码检索下，相关高风险模块未发现常规 `__tests__/.test./.spec.` 文件，说明这些最脆弱路径至少在当前源码快照里没有就近测试护栏  
   本地检索：`rg --files ... | rg '(__tests__|\\.test\\.|\\.spec\\.)' => 0`

所以这一章的最短结论是：

`测试优先级不应按功能多少排序，而应按“历史回归证据 + 时序脆弱度 + 失真成本”排序。`

再压成一句：

`先补最贵的错，不先补最容易写的测。`

## 3. 为什么“覆盖缺口”本身就是安全问题

很多团队把测试缺口理解成：

`开发效率问题`

但在 Claude Code 这类安全控制面里，  
测试缺口其实更接近：

`制度防线问题`

因为前面我们已经看到：

1. 很多安全规则靠局部 guard 维持
2. 很多 guard 背后其实是宪法条文
3. 很多宪法又依赖时序与顺序

一旦这些地方缺测试，  
就不是“功能坏一点”，  
而是：

1. stale actor 重新获得改口权
2. false completion 再次出现
3. transient/fatal 被重新压扁
4. local truth 和 external truth 再次分叉

所以：

`安全测试缺口，不是质量尾巴，而是制度空洞。`

## 4. 当前最该优先补强的第一类：跨系统同步与中心化跃迁

## 4.1 permission mode / metadata sync 是 Tier 0

`src/state/onChangeAppState.ts:50-64` 明确写出：

1. 过去只有 2 of 8+ 路径会正确同步 mode
2. 其余路径会让 external metadata stale
3. web UI 会和 CLI 真相不同步

这类问题的危险在于：

1. 它不是单点 bug
2. 它是多入口一致性 bug
3. 它影响 external truth projection

所以这类路径最适合优先补：

1. centralized transition tests
2. diff propagation tests
3. integration ordering tests

换句话说，  
Tier 0 的标准不是“看起来最危险”，  
而是：

`一旦退化，会让多个 surface 一起撒谎。`

## 4.2 guard-before-transition ordering 同样应归入 Tier 0

`src/hooks/useReplBridge.tsx:417-453` 已经直接写出：

1. Policy guards MUST fire before `transitionPermissionMode`
2. 否则会造成 `3-way invariant violation`

这说明这条路径不是普通分支逻辑，  
而是一条：

`顺序型制度不变量`

最适合它的不是普通 happy-path unit test，  
而是：

`integration ordering test`

因为真正要证明的是：

`以后重构时 guard 顺序仍不会被打乱。`

## 5. 当前最该优先补强的第二类：时序竞争与 stale actor

## 5.1 notifications 是典型的 Tier 1

`src/context/notifications.tsx:172-188,193-212` 已经说明：

1. duplicate key 要拒绝
2. absent remove 要 no-op
3. invalidates / timeout 共同构成时序约束

这类路径之所以优先级高，  
不是因为业务大，  
而是因为：

`它们最容易在“看起来无害的重构”中退化。`

例如：

1. 把 key compare 改掉
2. 把 shouldAdd 简化错
3. 把 invalidates / timeout 处理顺序改乱

这些都很适合 property/table tests。  
因为这里真正该补的是：

`时序空间覆盖`

而不是仅仅一两个样例。

## 5.2 bridge failure timers 同样属于 Tier 1

`src/hooks/useReplBridge.tsx:31-40,616-644` 暗示两类高代价前科：

1. repeated failures 会造成 401 storm
2. cancelled throws 曾造成 stale error / spurious setAppState

这说明 bridge timer / cancellation / retry 路径的代价非常高：

1. 会打真实网络
2. 会污染真实错误态
3. 会放大重试风暴

所以这类最该优先补的是：

1. failure-count threshold table tests
2. timer interleaving property tests
3. cancelled-path integration tests

## 6. 当前最该优先补强的第三类：completion gate 与 stale-cache 路径

## 6.1 plugin refresh 是典型的 Tier 2

`src/hooks/useManagePlugins.ts:289-302` 已经明确写出：

1. previous auto-refresh had a stale-cache bug
2. `/reload-plugins` 是正确消费路径
3. 不允许 auto-refresh / reset `needsRefresh`

`src/utils/plugins/refresh.ts:81-88,140-145` 又明确说明：

1. 这里曾有 no-op race
2. 曾有 stale memoized result
3. 明确标出 `Fixes issue #15521`

这意味着 plugin refresh 路径不是抽象担忧，  
而是已经有：

`真实前科 + 明确注释 + 结构性 race 风险`

因此它最适合补：

1. transition-table tests
2. stale-cache regression tests
3. completion gate tests

之所以把它列为 Tier 2，  
不是因为它不重要，  
而是因为它对“外部真相分叉”的系统性破坏通常略低于 Tier 0/Tier 1 的跨系统同步和时序风暴。

## 7. 当前最该优先补强的第四类：恢复资产的分支歧义

pointer / resume 系列应列为 Tier 2.5 或 Tier 3。

理由不是它不重要，  
而是：

1. 逻辑较集中
2. schema/freshness guard 已较强
3. 但 transient-vs-fatal / resumable-vs-retired 的分支成本依然很高

一旦退化，  
会直接造成：

1. 用户丢失恢复资格
2. 旧 pointer 继续冒充 current
3. 系统过度悲观或过度乐观

所以它最适合补：

1. branch matrix tests
2. TTL boundary tests
3. resumable clean shutdown vs fatal teardown tests

## 8. 覆盖优先级应如何排序

综合当前证据，  
我会建议按以下优先级补：

## 8.1 Priority 0

1. permission mode guard-before-transition ordering
2. `onChangeAppState` metadata sync consistency

标准：

`一旦退化，多个 surface 同时分叉。`

## 8.2 Priority 1

1. notification stale-timeout / duplicate-family properties
2. bridge failure timer / cancelled-throw / retry-threshold properties

标准：

`一旦退化，最容易产生时序型假真相或放大系统性错误。`

## 8.3 Priority 2

1. plugin refresh stale-cache / completion gate regressions
2. pointer transient-vs-fatal / stale-vs-resumable branch matrix

标准：

`一旦退化，会制造高成本错判，但主要集中在单个子系统边界。`

## 8.4 Priority 3

1. 低层 `Object.is(next, prev)` 这类通用容器不变量
2. 其他尚未 catalog 化的局部 no-op guards

标准：

`重要，但其回归破坏通常更局部，且更容易被上层发现。`

## 9. 为什么“最容易写的测试”往往不是最应该先写的测试

这是最容易被低估的一点。

最容易写的通常是：

1. 单函数 pure logic tests
2. obvious happy-path tests
3. 静态 schema parsing tests

但 Claude Code 当前最危险的回归往往是：

1. 多入口一致性
2. timer / cancellation interleaving
3. completion gate 被绕过
4. transient/fatal branch 被压扁
5. guard-before-transition 顺序被打乱

也就是说：

`真正优先级高的测试，往往是更难写的测试。`

这正是安全工程和普通功能测试的区别：

`安全上最值得先补的，通常不是最省事的。`

## 10. 从第一性原理看，优先补强路线到底在优化什么

它优化的不是测试数量，  
而是：

`每一份新增测试能替系统守住多少最贵的真相边界。`

所以优先级公式其实可以压成：

`priority = 历史前科 × 时序脆弱度 × 跨面失真成本 × 重构易损性`

用这套公式看：

1. mode sync / guard ordering
   很高
2. bridge timers / notifications stale actor
   很高
3. plugin refresh stale-cache
   高
4. pointer branch matrix
   中高
5. 低层 store no-op
   中

## 11. 技术启示：成熟安全团队不按模块平均补测试，而按失真经济学补测试

Claude Code 源码给出的最大启示之一是：

`注释里的 bug 前科、race 说明、stale/fatal 区分、以及 invariant violation 线索，本身就是测试优先级信号。`

这意味着成熟团队不该简单按：

1. 模块覆盖率
2. 行数
3. 业务热度

来分配测试预算，  
而应按：

`哪类失真一旦重现，最容易让系统在真相层撒谎`

来排序。

## 12. 苏格拉底式反思：如果要把这一层做得更好，还应继续追问什么

可以继续追问八个问题：

1. 当前哪些注释已经明确暴露“这里曾经出过错”，却还没有对应回归测试
2. 当前哪些路径的 failure mode 成本最高，却还只靠注释提醒未来维护者
3. 当前哪些 test 类型最被低估，其实最值得优先引入
4. 当前哪些 guard 若删掉，CI 是否能立刻发现
5. 当前是否应把“有历史前科的路径必须补回归测试”写进开发准则
6. 当前哪几类 property tests 能以最小成本覆盖最多时序空间
7. 当前哪几类 integration ordering tests 能最直接保护 centralized transition
8. 当前是否应把“覆盖优先级”本身也写成公开的验证路线图

这些问题共同逼问的是：

`系统到底是在随手补测试，还是在有意识地为最贵的真相失真修建护城河。`

## 13. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的下一步不是：

`平均地补一些测试，`

而是：

`按历史前科、时序脆弱度、跨面失真成本与重构易损性，优先补上最贵失真的 property / table / integration 护栏。`

因为只有这样，  
测试层才不会只是：

`看起来更完整，`

而会真正变成：

`最值得先补的安全资本配置。`
