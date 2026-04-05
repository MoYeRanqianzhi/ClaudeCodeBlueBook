# 安全资格生命周期调度速查表：subsystem、current writer、implicit transition与recommended dispatch event

## 1. 这一页服务于什么

这一页服务于 [109-安全资格生命周期调度与状态机：为什么有了ledger仍不够，还必须把裸setState升级为typed transition dispatch](../109-%E5%AE%89%E5%85%A8%E8%B5%84%E6%A0%BC%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F%E8%B0%83%E5%BA%A6%E4%B8%8E%E7%8A%B6%E6%80%81%E6%9C%BA%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E6%9C%89%E4%BA%86ledger%E4%BB%8D%E4%B8%8D%E5%A4%9F%EF%BC%8C%E8%BF%98%E5%BF%85%E9%A1%BB%E6%8A%8A%E8%A3%B8setState%E5%8D%87%E7%BA%A7%E4%B8%BAtyped%20transition%20dispatch.md)。

如果 `109` 的长文解释的是：

`ledger 之后必须再补统一 transition dispatch，`

那么这一页只做一件事：

`把各 subsystem 当前是谁在写结果、它实际上隐含了什么 transition、以及最该收口成什么 dispatch event 压成一张矩阵。`

## 2. 生命周期调度矩阵

| subsystem | current writer | implicit transition | current risk | recommended dispatch event | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| store foundation | generic `setState(prev=>next)` | 任意结果写入 | 无法在入口区分 upgrade/retire/timeout | `dispatchLifecycleTransition(envelope)` | `store.ts:4-33`; `AppState.tsx:165-178` |
| notifications | `addNotification/processQueue/removeNotification` | enqueue、promote、fold、invalidate、timeout-retire | 规则只在 notification 子系统成立 | `dispatchNotificationTransition(kind=enqueue/promote/fold/invalidate/retire)` | `notifications.tsx:45-212` |
| bridge failure | `useReplBridge` 局部 `setAppState` + timeout | failure-detected、fuse-blown、retry-window-expired、disabled | 状态机存在但没有统一名字与入口 | `dispatchBridgeLifecycle(kind=failure_detected/fuse_blown/retry_expired/disabled)` | `useReplBridge.tsx:102-127,339-362,623-644` |
| plugin refresh | `refreshActivePlugins()` 直接写 snapshot | refresh-completed、stale-consumed、reconnect-bumped | completion 只能靠正确路径隐式成立 | `dispatchPluginRefreshTransition(kind=completed)` | `refresh.ts:72-138` |
| cross-system metadata sync | `onChangeAppState` diff choke point | mode-changed side effects | 安全 lifecycle 还没接入这条统一审计链 | `dispatchAuditedSecurityTransition(...)` + middleware | `onChangeAppState.ts:43-120` |

## 3. 最短判断公式

当某个安全字段仍在通过裸结果写入变化时，先问五句：

1. 当前是谁在写这个结果
2. 这次写入实际隐含的是哪类 transition
3. 这类 transition 有没有统一名字
4. 这类 transition 有没有统一入口校验
5. 它是否已经值得被收口成 typed dispatch

## 4. 最常见的五类无调度风险

| 风险方式 | 会造成什么问题 |
| --- | --- |
| 直接写结果，不声明 transition kind | 状态机只能靠阅读实现猜 |
| 不校验 `from_state` | 非法跃迁可能被直接写入 |
| 不校验 `transition_owner` | 错主语也能触发高风险变化 |
| 各 subsystem 各自命名 transition | 无法统一审计与复用 |
| ledger 记录存在但 dispatch 不强制 | 账本退化成事后记述 |

## 5. 一条硬结论

对安全控制面来说，  
真正统一的不是：

`所有地方都用同一个 store，`

而是：

`所有高风险生命周期变化都必须通过同一套被命名、被校验、被记账的 transition dispatch 发生。`
