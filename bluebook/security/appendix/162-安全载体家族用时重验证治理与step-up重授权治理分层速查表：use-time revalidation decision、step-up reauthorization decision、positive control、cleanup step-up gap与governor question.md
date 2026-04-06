# 安全载体家族用时重验证治理与step-up重授权治理分层速查表：use-time revalidation decision、step-up reauthorization decision、positive control、cleanup step-up gap与governor question

## 1. 这一页服务于什么

这一页服务于 [178-安全载体家族用时重验证治理与step-up重授权治理分层：为什么artifact-family cleanup use-time revalidation-governor signer不能越级冒充artifact-family cleanup step-up reauthorization-governor signer](../178-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E7%94%A8%E6%97%B6%E9%87%8D%E9%AA%8C%E8%AF%81%E6%B2%BB%E7%90%86%E4%B8%8Estep-up%E9%87%8D%E6%8E%88%E6%9D%83%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88artifact-family%20cleanup%20use-time%20revalidation-governor%20signer%E4%B8%8D%E8%83%BD%E8%B6%8A%E7%BA%A7%E5%86%92%E5%85%85artifact-family%20cleanup%20step-up%20reauthorization-governor%20signer.md)。

如果 `178` 的长文解释的是：

`为什么 fresh current-use proof 即便已经存在，也还不能自动回答 stronger requested scope 是否已经被授权，`

那么这一页只做一件事：

`把 repo 里现成的 use-time revalidation decision / step-up reauthorization decision 正例，与 cleanup 线当前仍缺的 higher-authority gate grammar，压成一张矩阵。`

## 2. 用时重验证治理与 step-up 重授权治理分层矩阵

| line | use-time revalidation decision | step-up reauthorization decision | positive control | cleanup step-up gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| transport fetch | decide whether current request is still live enough to proceed to auth handling | decide whether `403 insufficient_scope` must bypass refresh and enter step-up pending | `wrapFetchWithStepUpDetection()` | cleanup line has no explicit split between fresh-use repair and stronger-scope elevation | who decides a fresh cleanup use still lacks sufficient authority level for the stronger request | `auth.ts:1345-1370`; `client.ts:620-641,820-834` |
| token issuance path | decide whether current tokens are still fresh enough to use | decide whether refresh token must be suppressed because current scope is insufficient | `tokens()` + `needsStepUp` + refresh-token omission | cleanup line has no explicit rule that freshness refresh cannot impersonate stronger authorization | who decides when refresh is forbidden because the problem is authority level, not freshness | `auth.ts:1625-1690` |
| step-up state continuation | decide current use path needs a fresh re-auth run | decide which stronger-scope state must persist across revoke/re-auth so next flow requests the right authority | preserve step-up state + cached scope reuse + `redirectToAuthorization()` persistence | cleanup line has no explicit continuation grammar for higher-authority requests | who decides how stronger cleanup authorization survives intermediate revocation and resumes on the next flow | `auth.ts:572-618,900-940,1848-1900` |
| auth result semantics | decide auth flow has produced a fresh usable auth result | decide whether `AUTHORIZED` is still insufficient when requested scope has not actually been elevated | `sdkAuth()` + comment on 403-after-upscoping loop | cleanup line has no explicit distinction between fresh authorization and stronger-scope authorization | who decides when a nominally authorized cleanup state still lacks requested higher authority | `auth.ts:1220-1228,1345-1349` |
| runtime request authority | decide current consumer has a fresh enough current-use proof | decide whether the request still needs stronger reauthorization rather than plain reconnect/refresh | step-up pending + PKCE fallthrough | cleanup line has no explicit “current use ok, stronger action still forbidden” control grammar | who decides which stronger cleanup requests need elevation even after live-use revalidation succeeded | `auth.ts:1461-1470,1625-1690` |

## 3. 三个最重要的判断问题

判断一句“cleanup current-use proof 已成立，所以更强请求也可以执行”有没有越级，先问三句：

1. 这里回答的只是当前连接/当前使用资格是否 fresh enough，还是已经回答请求所需的更高 authority level 是否足够
2. 当前问题是 freshness 问题，还是 `insufficient_scope` 这类 authority-level 问题
3. 当前系统是在 refresh 一个已有等级的 token，还是在为更高等级请求进入 step-up reauthorization

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “只要现在 fresh connected，就说明 scope 也够了” | use-time revalidation != scope-sufficient authorization |
| “refresh token 能拿新 token，就说明更强请求也该能过” | refresh != scope elevation |
| “`AUTHORIZED` 就代表 requested authority level 全都满足了” | nominal authorization != stronger-scope authorization |
| “真实 use path 已经通过，就不该再 step-up” | live use success != higher-authority success |
| “step-up 只是另一种 auth UI，不是单独主权” | step-up has its own state, trigger, continuation, and authority semantics |

## 5. 一条硬结论

真正成熟的 higher-authority grammar 不是：

`current use has been freshly revalidated -> any stronger request may now proceed`

而是：

`current use has been freshly revalidated -> inspect requested authority level -> detect insufficient_scope -> suppress refresh path -> persist step-up state -> run stronger reauthorization flow`

只有中间这些层被补上，
cleanup use-time revalidation governance 才不会继续停留在：

`它能决定现在还能不能用，却没人正式决定现在即便能用，是否已经配执行更强请求。`
