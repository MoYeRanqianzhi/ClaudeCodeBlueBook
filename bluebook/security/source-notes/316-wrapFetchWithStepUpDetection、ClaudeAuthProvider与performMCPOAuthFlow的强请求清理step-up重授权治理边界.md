# wrapFetchWithStepUpDetection、ClaudeAuthProvider与performMCPOAuthFlow的强请求清理step-up重授权治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `465` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 线未来谁来决定真正 consumer 在使用瞬间是否已经 fresh enough to use，`

而是：

`stronger-request cleanup 线一旦已经拿到 fresh current-use proof，谁来决定这份 proof 对当前更强请求的 authority level 是否仍然不够，从而必须进入 step-up reauthorization。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`use-time revalidation governor 不等于 step-up reauthorization governor。`

这句话还不够硬。

所以这里单开一篇，
只盯住：

- `src/services/mcp/auth.ts`
- `src/services/mcp/client.ts`

把 `403 insufficient_scope` detection、`markStepUpPending()`、`tokens()` 的 refresh suppression、cached stronger-scope continuation、transport fetch hook、nominal `AUTHORIZED` trap 与 completion clear 并排，
直接钉死 stronger-request cleanup 线当前仍缺的不是 live-use truth，
而是 `higher-authority step-up governance grammar`。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 use-time revalidation，没有 step-up reauthorization。`

而是：

`Claude Code 已经在 MCP 线上明确把“当前还能不能用”和“当前即便能用，scope 是否足够支撑更强请求”拆成两层；stronger-request cleanup 线当前缺的不是文化，而是这套 step-up reauthorization governance 还没被正式接到旧 cleanup artifact family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| insufficient-scope detection | `src/services/mcp/auth.ts:1345-1370` | 为什么 transport fetch 会把 `403 insufficient_scope` 识别成 authority-level 问题，而不是普通 freshness 问题 |
| step-up pending state | `src/services/mcp/auth.ts:1461-1470,1625-1692` | 为什么当前 token fresh 不等于当前 scope 足够 |
| higher-authority continuation | `src/services/mcp/auth.ts:578-616,903-935,1884-1899` | 为什么更强授权要保留自己的 state across revoke / re-auth |
| transport integration | `src/services/mcp/client.ts:620-634,821-828` | 为什么 step-up detection 是真实 transport path 的正式部分 |
| pseudo-authorized trap | `src/services/mcp/auth.ts:1220-1228,1345-1352,1645-1650` | 为什么 nominally `AUTHORIZED` 仍可能不是 requested-scope authorized |
| completion semantics | `src/services/mcp/auth.ts:1704-1705` | 为什么 step-up pending 不是永久状态，而有正式完成条件 |

## 4. `wrapFetchWithStepUpDetection()` 先证明：authority-level 缺口不会被偷压成 freshness-level 缺口

`src/services/mcp/auth.ts:1345-1370`
很值钱。

这里的注释直接说明：

1. transport fetch 若看到 `403 insufficient_scope`
2. 就必须先标记 step-up pending
3. 否则 SDK 会看见 `refresh_token`
4. 走 refresh
5. 返回 `AUTHORIZED`
6. retry
7. 再 `403`
8. 最终以 upscoping failure 终止

这条证据非常硬。

因为它明确把两类问题拆开了：

1. freshness 不足
2. authority level 不足

源码作者公开承认：

如果不先把第二类问题单独抓出来，
系统就会让第一类路径假装自己已经解决了第二类问题。

这正是 step-up reauthorization governance 的本体：

`scope insufficiency must not be flattened into plain refresh`

而 `src/services/mcp/client.ts:620-634,821-828`
又把这层写得更硬。

无论 SSE 还是 StreamableHTTP transport，
repo 都显式把：

`wrapFetchWithStepUpDetection(createFetchWithInit(), authProvider)`

挂进真实 transport fetch，
并强调它必须比 SDK 的 `auth() -> tokens()` 更早看见 `403`。

这说明 step-up 不是 auth.ts 的自言自语，
而是 live request path 上的正式 authority gate。

## 5. `markStepUpPending()` 与 `tokens()` 再证明：repo 会主动关闭错误的 refresh path，逼系统走更强授权流

`src/services/mcp/auth.ts:1461-1470,1625-1692`
更硬。

这里 repo 做了四件很关键的事：

1. `markStepUpPending(scope)` 把所需更高 scope 记进 provider
2. `tokens()` 比较 `_pendingStepUpScope` 与当前 token 的实际 scope
3. 若 scope 不覆盖，则设置 `needsStepUp = true`
4. 在返回 token 时故意省略 `refresh_token`

这一步极其值钱。

因为它不是“建议去 step-up”，
而是在控制面上直接做出：

`refresh path suppression`

更重要的是，
`src/services/mcp/auth.ts:1645-1650`
还公开写出：

`Skip when step-up is pending — refreshing can't elevate scope (RFC 6749 §6).`

这意味着 repo 明确承认：

`当前 token 可能完全 fresh、当前 use path 也可能完全 live，但如果 authority level 不够，就必须禁止错误路径继续冒充正确路径`

## 6. `performMCPOAuthFlow()` 与 step-up state persistence 再证明：更强授权拥有自己的跨流程连续性

`src/services/mcp/auth.ts:578-616,903-935,1884-1899`
很值钱。

这里 repo 明确：

1. 在 re-auth 场景里保留 `stepUpScope` 与 `discoveryState`
2. 在 `performMCPOAuthFlow()` 开始前先读取 `cachedStepUpScope` 与 `cachedResourceMetadataUrl`
3. 即便随后清掉旧 tokens，也会把 cached stronger scope 重新灌回 `wwwAuthParams`
4. 在 `redirectToAuthorization()` 中继续把新的 scope 持久化回存储

这说明更强授权不是：

`本次失败后，随手再来一轮普通登录`

而是：

`higher-authority request has its own continuation state`

这条证据非常关键。

因为它说明 repo 并不是在使用一个临时 UI patch。
它是在给更高 authority level 建一条正式的 continuation grammar：

1. 哪个 scope 正在 pending
2. 哪个 metadata / discovery state 要保留
3. 下一次 flow 应该以什么 stronger target 继续

如果 cleanup 线未来没有这种 grammar，
那它就仍然回答不了：

`旧 cleanup 对象当前即便还能用，哪些更强动作还必须重新拿到更高等级授权`

## 7. `sdkAuth(...)` 与 `saveTokens()` 最后证明：step-up 不只知道缺口存在，还知道缺口何时算被补齐

`src/services/mcp/auth.ts:1220-1228`
很值钱。

这里 `sdkAuth(...)` 可以返回：

`AUTHORIZED`

但配合 `1345-1352` 的注释可以看得很清楚，
repo 公开承认：

`AUTHORIZED`

也可能只是 nominally authorized，
并不自动代表 requested higher scope 已经真正拿到。

这条证据非常关键。

因为它把一个常见误判钉死了：

`auth flow succeeded`

不等于：

`higher-authority request succeeded`

而 `src/services/mcp/auth.ts:1704-1705`
又补上了另一半：

`saveTokens()` 在真正保存新 tokens 时会清空 `_pendingStepUpScope`。

这说明 repo 不只知道：

`authority shortfall has started`

还知道：

`authority shortfall has been discharged`

没有这层 completion semantics，
系统只能知道：

`现在不够权`

却回答不了：

`什么时候才算已经够权`

## 8. 更深一层的技术先进性：Claude Code 把“更强授权债务”做成了可检测、可持续、可完结的正式对象

这组源码给出的技术启示至少有六条：

1. `insufficient_scope` 应该在 request edge 被正式识别，而不是等高层故事兜底
2. 当问题是 authority shortfall 时，refresh path 必须被制度性禁用
3. stronger-scope intent 应该是可持久化对象，而不是一次性错误消息
4. nominal `AUTHORIZED` 不能越级冒充 requested-authority satisfied
5. live transport gate 与 token issuance path 必须共同参与 step-up governance
6. step-up 也必须拥有明确 completion semantics，否则更强授权永远只剩“正在缺权”的故事

## 9. 苏格拉底式自反诘问：我是不是又把“它现在还能用”误认成了“它现在也配执行更强请求”

如果对这组代码做更严格的自我审查，
至少要追问七句：

1. 如果这次 current-use proof 已经 fresh enough，为什么 transport fetch 仍会单独抓 `insufficient_scope`？
   因为 fresh current-use truth 不回答 requested authority truth。
2. 如果 refresh token 还能拿到新 token，为什么源码还要强行省略 `refresh_token`？
   因为 refresh 只能更新 freshness，不能提升 scope。
3. 如果 `sdkAuth(...)` 最终能返回 `AUTHORIZED`，为什么注释还担心 upscoping retry loop？
   因为 nominal authorization 不是 stronger-scope authorization。
4. 如果 re-auth 之前会清掉旧 tokens，为什么源码还要先缓存 `stepUpScope` 与 `resourceMetadataUrl`？
   因为 higher-authority intent 本身拥有自己的待满足条件。
5. 如果 step-up 只是另一种 UI 体验，为什么 `client.ts` 要把 detection wrapper 放在 transport fetch 最内层？
   因为 step-up 不是界面故事，而是 live authority gate。
6. 如果 step-up 真的只是 pending state，为什么 `saveTokens()` 还要主动清空 `_pendingStepUpScope`？
   因为制度不仅要知道缺口存在，还要知道缺口何时正式被补齐。
7. 如果 cleanup 线还没正式长出这套 grammar，是不是说明这层只是 scope 细节？
   恰恰相反。越把 scope 当细节，越容易让“现在还能用”偷签“现在也有权做更强动作”。

这一串反问最终逼出一句更稳的判断：

`step-up reauthorization 的关键，不在当前 proof 是否 fresh enough，而在系统能不能正式决定这份 current proof 对更强请求是否仍然太弱，以及何时才算已经补齐这份 authority shortfall。`

## 10. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 线未来只要补出 live-use revalidation grammar，就已经足够成熟。`

而是：

repo 已经在 `wrapFetchWithStepUpDetection()` 的 `403 insufficient_scope` detection、`ClaudeAuthProvider.tokens()` 的 refresh suppression、`performMCPOAuthFlow()` 的 cached step-up scope continuation、`sdkAuth(...)` 的 pseudo-authorized trap、`client.ts` transport fetch hook 的 live integration，以及 `saveTokens()` 的 completion semantics 上，明确展示了 step-up reauthorization governance 的存在；因此 `artifact-family cleanup stronger-request cleanup-use-time revalidation-governor signer` 仍不能越级冒充 `artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer`。

因此：

`stronger-request cleanup 线真正缺的，不只是“谁来决定现在还能不能用”，还包括“谁来决定现在即便能用，是否已经被授权到足以执行更强请求，以及何时正式承认这份更强授权已经完成”。`
