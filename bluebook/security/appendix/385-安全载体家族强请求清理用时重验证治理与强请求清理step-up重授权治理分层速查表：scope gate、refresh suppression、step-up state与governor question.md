# 安全载体家族强请求清理用时重验证治理与强请求清理step-up重授权治理分层速查表：scope gate、refresh suppression、step-up state与governor question

## 1. 这一页服务于什么

这一页服务于 [401-安全载体家族强请求清理用时重验证治理与强请求清理step-up重授权治理分层](../401-安全载体家族强请求清理用时重验证治理与强请求清理step-up重授权治理分层.md)。

如果 `401` 的长文解释的是：

`为什么 fresh current-use proof 即便已经存在，也还不能自动回答 stronger requested scope 是否已经被授权，`

那么这一页只做一件事：

`把 scope gate、refresh suppression、step-up state 与 stronger-request cleanup current gap 压成一张矩阵。`

## 2. 强请求清理用时重验证治理与 step-up 重授权治理分层矩阵

| positive control / cleanup current gap | use-time revalidation decision | step-up reauthorization decision | higher-authority mechanism | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| transport fetch | decide whether current request is still live enough to proceed to auth handling | decide whether `403 insufficient_scope` must bypass refresh and enter step-up pending | `wrapFetchWithStepUpDetection()` + live transport hook | who decides a fresh cleanup use still lacks sufficient authority level for the stronger request | `services/mcp/auth.ts:1345-1370`; `services/mcp/client.ts:620-641,820-834` |
| token issuance path | decide whether current tokens are still fresh enough to use | decide whether refresh token must be suppressed because current scope is insufficient | `tokens()` + `needsStepUp` + refresh-token omission | who decides when refresh is forbidden because the problem is authority level, not freshness | `services/mcp/auth.ts:1625-1690` |
| step-up pending state | decide current use path needs a fresh re-auth run | decide what stronger-scope intent must persist across revoke / re-auth | `markStepUpPending(scope)` + preserved step-up scope | who decides how stronger cleanup authorization survives intermediate revocation and resumes on the next flow | `services/mcp/auth.ts:1461-1470,572-618,900-940,1848-1900` |
| auth result semantics | decide auth flow has produced a fresh usable auth result | decide whether nominal `AUTHORIZED` is still insufficient when requested scope has not actually been elevated | RFC 6749 §6 note + 403-upscoping loop commentary | who decides when a nominally authorized cleanup state still lacks requested higher authority | `services/mcp/auth.ts:1220-1228,1345-1349` |
| runtime request authority | decide current consumer has a fresh enough current-use proof | decide whether the request still needs stronger reauthorization rather than plain reconnect/refresh | step-up pending + PKCE fallthrough | who decides which stronger cleanup requests need elevation even after live-use revalidation succeeded | `services/mcp/auth.ts:1461-1470,1625-1690` |
| stronger-request cleanup current gap | live-use question is now visible | no explicit step-up grammar yet | old path / promise / receipt world still lack formal insufficient-scope, refresh-suppression, higher-authority continuation governance | who decides when restored cleanup truth is still too weak for a stronger request even though it is fresh enough for ordinary use | current cleanup line evidence set |

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

真正成熟的 stronger-request cleanup higher-authority grammar 不是：

`current use has been freshly revalidated -> any stronger request may now proceed`

而是：

`current use has been freshly revalidated -> inspect requested authority level -> detect insufficient_scope -> suppress refresh path -> persist step-up state -> run stronger reauthorization flow`

只有中间这些层被补上，
stronger-request cleanup use-time revalidation governance 才不会继续停留在：

`它能决定现在还能不能用，却没人正式决定现在即便能用，是否已经配执行更强请求。`
