# 安全载体家族强请求清理免责释放治理与强请求清理归档关闭治理分层速查表：active lifecycle、waiting surface、queue admission与governor question

## 1. 这一页服务于什么

这一页服务于 [407-安全载体家族强请求清理免责释放治理与强请求清理归档关闭治理分层](../407-安全载体家族强请求清理免责释放治理与强请求清理归档关闭治理分层.md)。

如果 `407` 的长文解释的是：

`为什么 old echo 已 no-more-duty 仍不等于它已经退出 active operational surface，`

那么这一页只做一件事：

`把 repo 里现成的 stronger-request liability-release decision / stronger-request archive-close surface 正例，与 stronger-request cleanup 线当前仍缺的 archive-close grammar，压成一张矩阵。`

## 2. 强请求清理免责释放治理与强请求清理归档关闭治理分层矩阵

| line | stronger-request liability-release decision | stronger-request archive-close surface | positive control | cleanup archive gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| duplicate/orphan `control_response` lifecycle | old echo may already be no-more-duty | lifecycle still must be explicitly closed as `completed` | `notifyCommandLifecycle(uuid, 'completed')` | stronger-request cleanup line has no explicit close-out surface for released old cleanup echoes | who decides when a released stronger cleanup echo is also formally closed in the active lifecycle surface | `structuredIO.ts:362-398`; `commandLifecycle.ts:1-20` |
| stale permission prompt | stronger signer may already have released the old duty | stale waiting surface still must be cancelled | `onControlRequestResolved(...)` | stronger-request cleanup line has no explicit stale-waiting teardown after stronger cleanup release | who decides when old stronger cleanup waiting prompts should be actively torn down rather than merely ignored | `structuredIO.ts:402-409` |
| orphan queue admission | release decision can say `no more duty` | active queue admission still needs an explicit yes/no | `orphaned-permission` mode vs `return false` | stronger-request cleanup line has no explicit queue-surface close decision for released stronger cleanup echoes | who decides whether a released stronger cleanup echo still enters active queue world or is archived out of it | `print.ts:1936-1948`; `print.ts:5241-5301` |
| transcript-resolved refusal | stronger transcript truth releases further compensation duty | refusal also keeps the echo out of active re-entry surfaces | `already resolved in transcript -> return false` | stronger-request cleanup line has no explicit stronger-truth-based archive-close rule for old stronger cleanup echoes | who decides when stronger truth not only releases duty but also forbids active re-entry | `print.ts:5279-5284` |
| inline completed observability | release judgment may already be finished elsewhere | operator-facing completion still needs a formal surface signal | `only fire completed` | stronger-request cleanup line has no explicit operator-facing close contract after release | who decides when current world should stop treating a released stronger cleanup echo as an in-flight object | `print.ts:2816-2828`; `commandLifecycle.ts:1-20` |

## 3. 三个最重要的判断问题

判断一句“old stronger echo 已 no-more-duty，所以等于已经 archive-close 了”有没有越级，先问三句：

1. 这里回答的是 no-more-duty，还是 active-surface closure
2. 这里有没有明确关掉 lifecycle / waiting / queue / operator-facing 这些表面，而不是只做语义判断
3. 这里是不是把“不再补偿”偷写成“表面自然自己关闭”

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “已经免责了，所以 active lifecycle 自然就结束了” | liability release != archive close |
| “不再 enqueue 就等于没有关闭动作了” | non-admission still needs explicit surface closure |
| “旧 prompt 不再重要，所以它会自己消失” | stale waiting surfaces need active teardown |
| “duplicate 被忽略，只是因为没价值了” | ignore can still require lifecycle close and archive discipline |
| “已经 no-more-duty，就不必再管 operator-facing active surface” | obligation closure != operator surface closure |

## 5. 一条硬结论

真正成熟的 stronger-request archive-close grammar 不是：

`old echo is released -> therefore it is automatically off all active surfaces`

而是：

`old echo is released -> close lifecycle -> cancel stale waiting surface -> refuse or admit queue re-entry explicitly -> publish operator-facing close signal -> only then treat it as archived out of the active operational world`

只有中间这些层被补上，
stronger-request cleanup liability-release governance 才不会继续停留在：

`它能决定 old echo 已 no-more-duty，却没人正式决定它什么时候已经从活跃操作表面退出。`
