# commandLifecycle 与 orphaned-permission 队列的强请求归档关闭治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `184` 时，
真正需要被单独钉住的已经不是：

`cleanup 线未来谁来决定 old echo 是否 no-more-duty，`

而是：

`cleanup 线如果未来已经宣布 no-more-duty，谁来决定这条 old echo 什么时候已经从 active lifecycle / waiting / queue 表面正式关闭。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`liability-release governor 不等于 archive-close governor。`

这句话还不够硬。
所以这里单开一篇，只盯住：

- `src/cli/structuredIO.ts`
- `src/cli/print.ts`
- `src/utils/commandLifecycle.ts`

把 lifecycle completed、stale prompt cancellation 与 `orphaned-permission` queue non-admission 并排，
逼出一句更硬的结论：

`Claude Code 已经在 old echo world 里明确展示：no-more-duty 只是责任判断；真正的 archive close 还要回答这条 echo 是否已经退出 active lifecycle、waiting surface 与 queue world。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 在一些地方会调用 completed。`

而是：

`Claude Code 明确把 old echo 的 no-more-duty judgment 与 active-surface closure 写成了不同动作：生命周期要单独关，旧等待面要单独撤，队列是否准入也要单独判断。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| lifecycle close on every control_response | `src/cli/structuredIO.ts:360-409` | 为什么 duplicates / orphans 即使已 no-more-duty 也要被正式 completed |
| lifecycle surface contract | `src/utils/commandLifecycle.ts:1-18` | 为什么 started/completed 本身是一条独立 active surface |
| stale prompt teardown | `src/cli/structuredIO.ts:401-409` | 为什么 stronger signer 还要主动撤掉旧 waiting prompt |
| orphan queue mode | `src/cli/print.ts:1936-1955` | 为什么 orphaned echo 是否进入 active queue 是单独问题 |
| compensate-or-refuse branch | `src/cli/print.ts:5238-5305` | 为什么 release 之后仍要继续回答 active re-entry surface 该怎么关 |

## 4. `notifyCommandLifecycle(uuid, 'completed')` 先证明：archive-close 的第一层是 lifecycle close，不是语义比喻

`structuredIO.ts:360-409` 很硬。

源码注释直接写：

`Close lifecycle for every control_response, including duplicates and orphans`

这条证据非常关键。

因为它说明 repo 不满足于：

`这条 old echo 已经 no-more-duty`

它还坚持：

`即便如此，这条 old echo 的 lifecycle surface 也必须被正式关账`

而 `commandLifecycle.ts:1-18` 又把这个 surface 明确抽成独立 listener contract。

这意味着 archive-close 在这里不是一个哲学修辞，
而是：

`independent technical surface closure`

## 5. stale prompt cancellation 再证明：release 之后仍要单独撤掉旧 waiting surface

`structuredIO.ts:401-409` 很值钱。

当 `can_use_tool` 终于 resolved，
系统还要进一步：

`onControlRequestResolved(message.response.request_id)`

去 cancel claude.ai 侧 stale permission prompt。

这说明 no-more-duty judgment 之后，
repo 仍然认为自己还欠一件事：

`把旧等待表面正式撤场`

这显然不是 release judgment 自己会完成的事，
而是 archive-close 主权的一部分。

## 6. `orphaned-permission` queue 再证明：是否进入 active queue world 是 archive-close 的另一张票

`print.ts:1936-1955` 很硬。

源码明确把：

`orphaned-permission`

建成单独 queue mode，
并强调这类命令因为 carry side effects / orphanedPermission state，
必须 singly process。

这条线说明：

orphan echo 不只是“要不要补偿”的抽象对象，
它还是：

`是否被允许重新进入 active queue world`

的问题。

而 `handleOrphanedPermissionResponse()` 又给出对应分流：

1. still owe compensation -> enqueue
2. already handled / already resolved -> return false

这说明 archive-close 的关键不是“以后再也看不见”，
而是：

`不再 admission into active operational queue`

## 7. 为什么这层不等于 `183` 的 liability-release gate

这里必须单独讲清楚，
否则容易把 `184` 误读成 `183` 的尾注。

`183` 问的是：

`old echo 什么时候已经 no-more-duty。`

`184` 问的是：

`即便 no-more-duty 已成立，这条 old echo 什么时候已经正式退出 active lifecycle / waiting / queue 表面。`

所以：

1. `183` 的典型形态是 duplicate ignore、unknown-response ignore、transcript-resolved amnesty
2. `184` 的典型形态是 lifecycle completed、stale prompt teardown、queue non-admission

前者 guarding obligation closure，
后者 guarding active-surface closure。

两者都很重要，
但不是同一个 signer。

## 8. 这篇源码剖面给主线带来的四条技术启示

### 启示一

repo 已经明确展示：

`no-more-duty can exist before active-surface closure is fully executed`

### 启示二

repo 已经明确展示：

`lifecycle surface is independent from responsibility judgment`

### 启示三

repo 已经明确展示：

`stale waiting surfaces require active teardown, not passive neglect`

### 启示四

repo 已经明确展示：

`queue admission is a separate archive-close question, not a footnote to release`

这四句合起来，
正好说明为什么 cleanup 线未来不能把 stronger-request liability release 直接偷写成 stronger-request archive close。

## 9. 一条硬结论

这组源码真正说明的不是：

`只要补出 old echo 的 no-more-duty grammar，cleanup 线就已经知道如何让它退出所有活跃表面。`

而是：

`repo 已经在 StructuredIO 的 lifecycle completed、stale permission prompt cancellation、print.ts 的 orphaned-permission queue mode 与 compensate-or-refuse admission 分流，以及 commandLifecycle 的独立 listener contract 上，清楚展示了 stronger-request archive-close governance 的独立存在；因此 artifact-family cleanup stronger-request liability-release-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request archive-close-governor signer。`

因此：

`cleanup 线真正缺的，不只是“谁来宣布 old echo 现在已 no-more-duty”，还包括“谁来宣布它现在已经从活跃操作表面正式关闭”。`
