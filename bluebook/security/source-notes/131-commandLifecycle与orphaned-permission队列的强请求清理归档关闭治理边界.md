# commandLifecycle 与 orphaned-permission 队列的强请求清理归档关闭治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `280` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 线未来谁来决定 old echo 是否 no-more-duty，`

而是：

`stronger-request cleanup 线如果未来已经宣布 no-more-duty，谁来决定这条 old echo 什么时候已经从 active lifecycle / waiting / queue / observability 表面正式关闭。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`liability-release governor 不等于 archive-close governor。`

这句话还不够硬。
所以这里单开一篇，只盯住：

- `src/cli/structuredIO.ts`
- `src/cli/print.ts`
- `src/utils/commandLifecycle.ts`

把 lifecycle `completed`、stale prompt cancellation、`orphaned-permission` queue non-admission 与 inline completed observability 并排，
逼出一句更硬的结论：

`Claude Code 已经在 old echo world 里明确展示：no-more-duty 只是责任判断；真正的 archive close 还要回答这条 echo 是否已经退出 active lifecycle、waiting surface、queue world 与 operator-facing observability surface。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 在一些地方会调用 completed。`

而是：

`Claude Code 明确把 old echo 的 no-more-duty judgment 与 active-surface closure 写成了不同动作：生命周期要单独关，旧等待面要单独撤，队列是否准入也要单独判断，operator-facing completed 还要按独立 contract 发布。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| lifecycle close on every `control_response` | `src/cli/structuredIO.ts:360-409` | 为什么 duplicates / orphans 即使已 no-more-duty 也要被正式 completed |
| lifecycle surface contract | `src/utils/commandLifecycle.ts:1-18` | 为什么 started / completed 本身是一条独立 active surface |
| stale prompt teardown | `src/cli/structuredIO.ts:401-409` | 为什么 stronger signer 还要主动撤掉旧 waiting prompt |
| orphan queue mode | `src/cli/print.ts:1936-1955` | 为什么 orphaned echo 是否进入 active queue 是单独问题 |
| compensate-or-refuse branch | `src/cli/print.ts:5241-5305` | 为什么 release 之后仍要继续回答 active re-entry surface 该怎么关 |
| inline completed observability | `src/cli/print.ts:2808-2824` | 为什么 operator-facing close 不是 release judgement 的附带物 |

## 4. `notifyCommandLifecycle(uuid, 'completed')` 先证明：archive-close 的第一层是 lifecycle close，不是语义比喻

`structuredIO.ts:360-409`
很硬。

源码注释直接写：

`Close lifecycle for every control_response, including duplicates and orphans`

这条证据非常关键。

因为它说明 repo 不满足于：

`这条 old echo 已经 no-more-duty`

它还坚持：

`即便如此，这条 old echo 的 lifecycle surface 也必须被正式关账`

而 `commandLifecycle.ts:1-18`
又把这个 surface 明确抽成独立 listener contract。

这意味着 archive-close 在这里不是一个修辞，
而是：

`independent technical surface closure`

## 5. stale prompt cancellation 再证明：release 之后仍要单独撤掉旧 waiting surface

`structuredIO.ts:401-409`
很值钱。

当 `can_use_tool` resolved，
系统还要进一步：

`onControlRequestResolved(message.response.request_id)`

去 cancel claude.ai 侧 stale permission prompt。

这说明 no-more-duty judgment 之后，
repo 仍然认为自己还欠一件事：

`把旧等待表面正式撤场`

这显然不是 release judgment 自己会完成的事，
而是 archive-close 主权的一部分。

## 6. `orphaned-permission` queue 再证明：是否进入 active queue world 是 archive-close 的另一张票

`print.ts:1936-1955`
很硬。

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

而 `handleOrphanedPermissionResponse()`
又给出对应分流：

1. still owe compensation -> enqueue
2. already handled / already resolved -> return false

这说明 archive-close 的关键不是“以后再也看不见”，
而是：

`不再 admission into active operational queue`

## 7. inline completed observability 再证明：operator-facing close 是独立 contract

`print.ts:2808-2824`
与 `commandLifecycle.ts:1-18`
合起来也很硬。

这里源码明确把：

1. non-user / non-control_response event inline handled
2. `started -> completed` in the same tick carries no information
3. therefore only fire `completed`

写成独立 observability discipline。

这条证据值钱的地方在于：

它说明：

`completed`

不是“差不多结束”的随手文案，
而是 current operator world 真的会接收的一条 surface signal。

既然如此，
就更不能把：

`我已不再欠旧 echo 责任`

偷写成：

`active surface 当然也会自动完成`

## 8. 为什么这层不等于 `130` 的 liability-release gate

这里必须单独讲清楚，
否则容易把 `131` 误读成 `130` 的尾注。

`130` 问的是：

`old echo 什么时候已经 no-more-duty。`

`131` 问的是：

`即便 no-more-duty 已成立，这条 old echo 什么时候已经正式退出 active lifecycle / waiting / queue / observability 表面。`

所以：

1. `130` 的典型形态是 duplicate ignore、unknown-response no-op、transcript-resolved amnesty、compensate-or-refuse
2. `131` 的典型形态是 lifecycle completed、stale prompt teardown、queue non-admission、inline completed contract

前者 guarding obligation closure，
后者 guarding active-surface closure。

两者都很重要，
但不是同一个 signer。

## 9. 技术启示：成熟安全系统为什么要把“责任关闭”与“表面关闭”拆开

这组源码给出的设计启示至少有四条。

第一条：

`duty closed` 与 `surface closed` 必须是两个独立 verdict。

第二条：

duplicates / orphans 也应走显式 close path，
否则最旧的对象最容易长期滞留在当前世界。

第三条：

waiting teardown 与 queue non-admission 都必须被单独编码，
不能当作 refusal 语义的自然阴影。

第四条：

operator-facing `completed` 必须是 contract，
不能只是“实现顺手打的一条日志”。

## 10. 一条硬结论

这组源码真正说明的不是：

`只要补出 old echo 的 no-more-duty grammar，stronger-request cleanup 线就已经知道如何让它退出所有活跃表面。`

而是：

repo 已经在 `StructuredIO` 的 lifecycle completed、stale permission prompt cancellation、`print.ts` 的 `orphaned-permission` queue mode 与 compensate-or-refuse admission 分流，以及 `commandLifecycle` 的独立 listener contract 上，清楚展示了 stronger-request archive-close governance 的独立存在；因此 `artifact-family cleanup stronger-request liability-release-governor signer` 仍不能越级冒充 `artifact-family cleanup stronger-request archive-close-governor signer`。

因此：

`stronger-request liability-release governance`

能回答：

`old echo 现在已 no-more-duty`

而

`stronger-request archive-close governance`

才真正回答：

`它现在已经从活跃操作表面正式关闭`
