# 安全资格生命周期调度与状态机：为什么有了ledger仍不够，还必须把裸setState升级为typed transition dispatch

## 1. 为什么在 `108` 之后还必须继续写“生命周期调度与状态机”

`108-安全资格生命周期账本` 已经回答了：

`统一控制台不能只保存当前结果，还必须保存字段为何升级、为何留场、为何退场的时间性依据。`

但如果继续往下追问，  
还会碰到一个更关键的问题：

`这些 transition 到底该如何发生？`

即便系统已经有了 ledger，  
如果任何调用方仍然可以直接：

`setState(prev => next)`

那账本最多只是：

`事后记录`

而不是：

`事前约束`

这会带来一个非常深的结构问题：

1. ledger 能解释已经发生了什么
2. 但不能阻止“不该这样发生”的 transition 被直接写进状态

所以 `108` 之后必须继续补出的下一层就是：

`安全资格生命周期调度与状态机`

也就是：

`有了 ledger 仍不够，系统还必须把裸 setState 升级为 typed transition dispatch，让高风险字段的变化先经过合法性调度，再进入账本和快照。`

## 2. 最短结论

从源码看，Claude Code 当前的安全字段变化主要还是通过泛型状态写口发生，  
而不是通过显式生命周期调度器发生：

1. 底层 store 只提供泛型 `setState(updater)`，并不区分 upgrade/renew/invalidate/retire  
   `src/state/store.ts:4-33`
2. `useSetAppState()` 直接把这个裸写口暴露给调用方  
   `src/state/AppState.tsx:165-178`
3. notifications 的 add/remove 全靠局部逻辑直接写 `current/queue` 结果  
   `src/context/notifications.tsx:45-212`
4. bridge failure / fuse / dismiss 也都是局部 `setAppState(prev => ...)` 直接改结果位  
   `src/hooks/useReplBridge.tsx:102-127,339-362,623-644`
5. plugin refresh likewise 直接把 `needsRefresh=false` 与 `pluginReconnectKey+1` 写回状态树  
   `src/utils/plugins/refresh.ts:72-138`
6. `onChangeAppState()` 已经证明“统一 diff choke point”能显著减少模式同步分叉，但这条思路还没推广到安全生命周期 transition 本身  
   `src/state/onChangeAppState.ts:43-120`

所以这一章的最短结论是：

`Claude Code 现在离“统一安全生命周期状态机”只差一步：它已经有了规则、协议和账本方向，但 transition 入口仍主要是裸写口。`

再压成一句：

`有账本说明系统会记， 有调度器才说明系统会管。`

## 3. 当前架构的核心事实：transition 仍主要是“谁拿到写口谁来改”

## 3.1 store 根本不知道自己承载的是哪一类变化

`src/state/store.ts:4-33` 的接口非常直接：

1. `getState`
2. `setState(updater)`
3. `subscribe`

这里的 `setState` 只关心：

1. `prev`
2. `next`
3. 引用是否变化

它并不知道：

1. 当前这次改动是 `upgrade`
2. 还是 `retire`
3. 是 `timeout`
4. 还是 `completion`
5. 是 `fatal revocation`
6. 还是 `soft renewal`

这意味着底层 store 当前只负责：

`承载状态变化`

而不负责：

`裁定状态变化是否合法`

## 3.2 `useSetAppState()` 把这种中性写口直接交给所有调用方

`src/state/AppState.tsx:165-178` 明确说明：

1. 组件可以拿到 stable `setState`
2. 不订阅状态也能直接写状态

这对性能与工程便利当然很好，  
但它也意味着：

`任何拥有写口的模块都可以直接落最终结果。`

于是高风险字段的 transition 约束就只能继续依赖：

1. 调用方自觉
2. 局部注释
3. reviewer 读代码推理

而不是：

`dispatch 层统一检查`

## 3.3 这解释了为什么前几章反复看到“规则在实现里”

不是因为作者不懂规则，  
恰恰相反，  
规则很多而且很成熟。  
问题只是：

`这些规则还没有被收口成统一 transition gateway。`

## 4. notifications 子系统已经在暗示“dispatch”应该存在，只是目前还是局部版本

## 4.1 `addNotification/removeNotification/processQueue` 实际上已经构成了一个微型 dispatch 层

`src/context/notifications.tsx:45-212` 仔细看会发现：

1. `addNotification()` 并不只是 append
2. `processQueue()` 并不只是 pop
3. `removeNotification()` 并不只是删 key

它们其实已经在做：

1. transition kind 分流
2. current/queue 仲裁
3. timeout 驱动 retirement
4. invalidation 驱动 replacement
5. fold 驱动 family-level merge

这其实已经很接近一个局部状态机：

`enqueue -> promote -> fold/invalidate -> retire`

## 4.2 但它的问题恰恰在于“只在 notifications 里成立”

notification 这套 dispatch 很成熟，  
但它目前：

1. 不能被 bridge status 直接复用
2. 不能被 plugin pending 直接复用
3. 不能被 pointer lifecycle 直接复用
4. 也不会给外界输出统一的 transition record

所以当前 notifications 更像：

`局部生命周期调度器`

而不是：

`统一安全生命周期调度器`

## 5. bridge failure 进一步证明：没有 typed dispatch，生命周期状态机会散落在业务逻辑里

`src/hooks/useReplBridge.tsx:102-127,339-362,623-644` 里，bridge failure 至少隐含了这些 transition：

1. `bridge_failure_detected`
2. `bridge_failure_promoted_to_notification`
3. `bridge_error_snapshot_written`
4. `bridge_retry_window_started`
5. `bridge_fuse_blown`
6. `bridge_retry_window_expired`
7. `bridge_disabled_after_failure`

但这些 transition 当前并没有以 typed event 存在。  
它们只是：

1. 几个 `setAppState` 调用
2. 几个 timeout callback
3. 一些局部分支

换句话说：

`状态机存在，但状态机没有名字。`

而一旦状态机没有名字，  
它就很难：

1. 被统一审计
2. 被其他 surface 理解
3. 被统一重构
4. 被抽象为 protocol + ledger + dispatcher 三层结构

## 6. plugin refresh 则说明：没有 dispatch，completion 仍然只能靠“正确路径”隐式成立

`src/utils/plugins/refresh.ts:72-138` 当前做的是：

1. refresh 流程跑完
2. 直接 `setAppState`
3. 写 `needsRefresh=false`
4. bump `pluginReconnectKey`

这当然能工作，  
但如果从统一状态机角度看，  
这里其实应该至少对应一个显式 transition：

1. `plugin_refresh_started`
2. `plugin_refresh_materialized`
3. `plugin_refresh_completed`
4. `plugin_refresh_committed`

当前它们都被压缩进：

`一次成功路径里的最终 setState`

这意味着未来别的入口如果也想“完成 refresh”，  
它们只能靠约定知道：

`什么时候才配把 needsRefresh=false 写回去`

而不是调用一个统一的：

`dispatchPluginRefreshCompleted(...)`

## 7. `onChangeAppState` 已经给出了统一 dispatch choke point 的原型

`src/state/onChangeAppState.ts:43-120` 的意义非常大。  
它展示了作者已经在某些高价值对象上接受这样一种架构：

1. 各处可以改 mode
2. 但 mode 变化的跨系统副作用必须统一从 diff choke point 触发

这说明作者已经意识到：

`重要状态变化不能让每个调用方自己处理所有后果。`

安全生命周期 transition 其实更应该遵守同样原则。  
只不过现在这条原则还没有从：

`mode sync`

扩展到：

`security lifecycle governance`

## 8. 从第一性原理看，为什么 ledger 之后必须接 state machine / dispatch

原因其实只有一句：

`安全控制面治理的不是状态，而是被允许发生的状态变化。`

再拆开讲，就是三层：

1. snapshot
   回答“现在是什么”
2. ledger
   回答“为什么会变成这样”
3. dispatch/state machine
   回答“什么变化被允许发生、什么变化必须被拒绝”

如果只有前两层，  
系统就像一个很会记账的历史学家；  
但安全系统真正需要的，  
是一个会在入口处说“不可以这样转”的守门人。

所以：

`账本负责可追溯，状态机负责可约束。`

## 9. 下一代统一安全生命周期调度器至少应长什么样

如果沿着当前源码自然进化，  
我会建议在 `setState` 之上增加一层 typed dispatch：

## 9.1 统一 transition envelope

例如：

1. `transition_family`
2. `transition_kind`
3. `target_field_family`
4. `evidence_bundle_id`
5. `transition_owner`
6. `expected_from_state`
7. `intended_to_state`
8. `emitted_at`

## 9.2 dispatch 层职责

dispatch 层至少负责：

1. 校验 `from -> to` 是否合法
2. 校验该 owner 是否配触发这类 transition
3. 写入 lifecycle ledger
4. 再落最终 snapshot
5. 最后触发 `onChange` 这类横切副作用

## 9.3 对不同 subsystem 的落位方式

1. notifications：
   把 `add/remove/fold/invalidate/timeout-retire` 提升为 typed event
2. bridge：
   把 `failed/reconnecting/fuse/disabled/completed` 提升为 typed event
3. plugins：
   把 `stale-detected/refresh-started/refresh-completed` 提升为 typed event
4. pointer：
   把 `freshened/staled/kept-for-resume/cleared-for-fatal` 提升为 typed event

这样一来，  
系统就不只是“很多模块各自会改状态”，  
而是：

`很多模块都在通过同一套 transition grammar 改状态。`

## 10. 这套设计的哲学本质：安全不是描述世界，而是规定世界允许怎样变化

这是这一章最核心的哲学结论。

很多系统把安全理解成：

`遇到危险时显示红色，遇到正常时显示绿色。`

但 Claude Code 源码反复证明，  
真正成熟的安全性不是颜色学，  
而是：

`变迁法学`

也就是：

1. 什么情况下允许从 `pending` 升到 `active`
2. 什么情况下必须从 `active` 降到 `failed`
3. 什么情况下 `failed` 只能 timeout 隐去而不能宣布完成
4. 什么情况下 pointer 可以保留而不能清掉

所以控制面的本质，不是对静态世界贴标签，  
而是：

`对状态变化建立宪法。`

## 11. 技术先进性：Claude Code 已经有了很多“宪法条文”，现在缺的是“统一法院”

Claude Code 现在最先进的地方在于：

1. 很多高风险 transition 的合法性标准已经非常清楚
2. 很多 subsystem 都已经写出了自己局部的严肃状态机
3. 很多错误路径已经被显式封死

它现在最缺的不是规则，  
而是：

`一个统一裁定这些规则的场所`

也就是：

`typed lifecycle dispatch / global transition state machine`

这也是对其他平台最值得借鉴的一点：

`当系统已经在多个模块里反复写出相似的合法 transition 约束时，就说明该进入统一状态机阶段了。`

## 12. 苏格拉底式反思：如果要把这一层做得更好，还应继续追问什么

可以继续追问七个问题：

1. 当前哪些安全字段最适合率先从裸 `setState` 迁移到 typed dispatch
2. 当前哪些 transition 最常被多个 subsystem 重复实现
3. 当前哪些错误最可能来自“from_state 没校验”
4. 当前哪些错误最可能来自“owner 没校验”
5. 当前 ledger 如果记录了 transition，但 dispatch 没有强制使用它，会不会退化成事后美化
6. 当前 `onChangeAppState` 是否应进一步演化成 security transition middleware
7. 当前哪些看似简单的布尔切换，实际上已经是高风险状态机跃迁

这些问题共同逼问的是：

`系统到底是在被动记录状态变化，还是在主动治理状态变化。`

## 13. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的下一步不是：

`在 ledger 旁边继续堆更多说明字段，`

而是：

`把裸 setState 升级为 typed transition dispatch，让高风险字段的 upgrade、renew、invalidate、timeout 与 retire 都先经过统一状态机裁定，再写入账本和快照。`

因为只有这样，  
系统才能从：

`会记住发生了什么`

真正升级到：

`会规定什么才允许发生。`
