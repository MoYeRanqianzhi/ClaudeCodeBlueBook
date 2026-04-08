# 安全载体家族强请求清理用时重验证治理与强请求清理step-up重授权治理分层速查表：scope gap、step-up proof、fallback surface与governor question

## 1. 这一页服务于什么

这一页服务于
[369-安全载体家族强请求清理用时重验证治理与强请求清理step-up重授权治理分层](../369-安全载体家族强请求清理用时重验证治理与强请求清理step-up重授权治理分层.md)。

如果 `369` 的长文解释的是：

`为什么某次 live use 即便已经 fresh enough，也还不能自动签出更强请求所需的 authority level，`

那么这一页只做一件事：

`把 scope gap、step-up proof、fallback surface 与 stronger-request cleanup current gap 压成一张矩阵。`

## 2. 强请求清理用时重验证治理与强请求清理 step-up 重授权治理分层矩阵

| positive control / cleanup current gap | use-time revalidation decision | step-up reauthorization decision | scope / authority mechanism | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| insufficient-scope detection | decide current live request is fresh enough to reach the server | decide whether the failure is authority-level and must trigger step-up | `403 insufficient_scope` detection in `wrapFetchWithStepUpDetection()` | who decides that a live request failed not because it is stale, but because its scope is too weak | `auth.ts:1345-1372` |
| pending step-up state | decide current token is usable for baseline actions | decide whether current scope still fails the stronger request and must suppress refresh | `markStepUpPending()` + `needsStepUp` + omit `refresh_token` | who decides when freshness repair must stop and stronger reauthorization must start | `auth.ts:1461-1472,1625-1692` |
| preserved stronger-scope intent | decide use-time proof exists for current action | decide what stronger scope must survive revoke / re-auth and continue across flows | `preserveStepUpState` + cached `stepUpScope` + `redirectToAuthorization()` persistence | who decides how higher-authority intent survives across auth churn | `auth.ts:578-618,900-940,1848-1900` |
| transport integration | decide live fetch is still the current use path | decide whether stronger-scope detection happens at the real request edge | transport fetch wrapped with `wrapFetchWithStepUpDetection(...)` | who decides whether scope insufficiency is caught where the request actually happens | `client.ts:620-641,820-834` |
| completion semantics | decide current-use proof may continue to exist | decide when step-up pending state is truly resolved and may be cleared | `_pendingStepUpScope = undefined` on `saveTokens()` | who decides when higher-authority proof has actually completed rather than merely been requested | `auth.ts:1700-1712` |
| stronger-request cleanup current gap | revalidation question is now visible | no explicit step-up grammar yet | old path / promise / receipt world still lack formal scope-elevation detection and continuation governance | who decides whether fresh cleanup truth is merely usable or already strong enough for stronger requests | current cleanup line evidence set |

## 3. 三个最重要的判断问题

判断一句
“既然这次 live use 已经 fresh enough，所以更强请求当然也该被允许”
有没有越级，
先问三句：

1. 这里回答的是 current use 是否 still fresh，还是已经回答 current authority 是否覆盖更强 scope
2. 当前看到的是连接仍活着，还是已经拿到了 stronger-scope proof
3. 如果 refresh 不能提升 scope，谁在阻止系统把 freshness 修复误写成 authority elevation

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “这次请求已经 fresh，所以 scope 肯定也够了” | freshness != authority sufficiency |
| “还能 refresh token，就说明更强请求也能做” | refresh != scope elevation |
| “当前还是 connected，所以 upscope 不该再被拦” | connected != authorized-for-higher-scope |
| “403 只是普通 auth 问题，走一轮 refresh 就好” | insufficient_scope needs step-up, not plain refresh |
| “既然 higher scope 已经 pending，就说明 stronger auth 已完成” | pending intent != stronger proof completion |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup step-up reauthorization grammar 不是：

`fresh current-use proof exists -> stronger request is assumed authorized`

而是：

`fresh current-use proof exists -> detect scope gap -> suppress wrong refresh path -> carry stronger-scope intent across flow -> clear pending only on real stronger proof`

只有中间这些层被补上，
stronger-request cleanup use-time revalidation governance 才不会继续停留在：

`它能说对象这一刻还能用，却没人正式决定它这一刻是否也已经配做更强的事。`
