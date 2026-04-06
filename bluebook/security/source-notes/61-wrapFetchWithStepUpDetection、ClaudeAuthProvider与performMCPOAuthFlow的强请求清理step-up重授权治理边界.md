# wrapFetchWithStepUpDetection、ClaudeAuthProvider 与 performMCPOAuthFlow 的强请求清理 step-up 重授权治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `210` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 线未来谁来决定真正 consumer 在使用瞬间是否已经 fresh enough to use，`

而是：

`stronger-request cleanup 线一旦已经拿到 fresh current-use proof，谁来决定这份 proof 对当前更强请求的 authority level 是否仍然不够，从而必须进入 step-up reauthorization。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`use-time revalidation governor 不等于 step-up reauthorization governor。`

这句话还不够硬。
所以这里单开一篇，只盯住：

- `src/services/mcp/auth.ts`
- `src/services/mcp/client.ts`

把 `403 insufficient_scope` detection、`markStepUpPending()`、`tokens()` 的 refresh-token suppression、step-up scope persistence 与 transport fetch hook 并排，
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
| insufficient-scope detection | `src/services/mcp/auth.ts:1345-1370` | 为什么 transport fetch 会在最前线把 `403 insufficient_scope` 识别成 authority-level 问题 |
| step-up pending state | `src/services/mcp/auth.ts:1461-1470,1625-1690` | 为什么当前 token fresh 不等于当前 scope 足够 |
| step-up continuation | `src/services/mcp/auth.ts:572-618,900-940,1848-1900` | 为什么更强授权要保留自己的 state across revoke/re-auth |
| transport integration | `src/services/mcp/client.ts:620-641,820-834` | 为什么 step-up detection 是 live transport path 的正式部分 |
| pseudo-authorized trap | `src/services/mcp/auth.ts:1220-1228,1345-1349` | 为什么 nominal `AUTHORIZED` 仍可能不是 stronger-scope authorized |

## 4. `wrapFetchWithStepUpDetection()` 先证明：authority-level 缺口不会被当成 freshness-level 缺口

`auth.ts:1345-1370` 很值钱。

这里的注释直接说明：

1. transport fetch 若看到 `403 insufficient_scope`
2. 就必须先标记 step-up pending
3. 否则 SDK 会看见 `refresh_token`
4. 走 refresh
5. 返回 `AUTHORIZED`
6. retry
7. 再 403
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

## 5. `markStepUpPending()` 与 `tokens()` 再证明：repo 会主动关闭错误的 refresh path，逼系统走更强授权流

`auth.ts:1461-1470,1625-1690` 更硬。

这里 repo 做了三件很关键的事：

1. `markStepUpPending(scope)` 把所需更高 scope 记进 provider
2. `tokens()` 比较 `_pendingStepUpScope` 与当前 token 的实际 scope
3. 若 scope 不覆盖，则设置 `needsStepUp=true`，并在返回 token 时省略 `refresh_token`

这一步极其值钱。

因为它不是“建议去 step-up”，
而是在控制面上直接做出：

`refresh path suppression`

这意味着 repo 公开承认：

`当前 token 可能完全 fresh、当前 use path 也可能完全 live，但如果 authority level 不够，就必须禁止错误路径继续冒充正确路径`

## 6. `performMCPOAuthFlow()` 与 step-up state persistence 再证明：更高授权拥有自己的跨流程连续性

`auth.ts:572-618,900-940,1848-1900` 很值钱。

这里 repo 明确：

1. 在 re-auth 时保留 `stepUpScope` 与 `discoveryState`
2. 在下一次 `performMCPOAuthFlow()` 开始前读取 cached `stepUpScope`
3. 在 `redirectToAuthorization()` 里提取并持久化新的 scope

这说明更强授权不是：

`本次失败后，随手再来一轮普通登录`

而是：

`higher-authority request has its own continuation state`

这条证据非常关键。

因为它说明 repo 并不是在使用一个临时 UI patch。
它是在给更高 authority level 建一条正式的 continuation grammar：

1. 哪个 scope 正在 pending
2. 哪个 metadata/discovery state 要保留
3. 下一次 flow 应该以什么 stronger target 继续

如果 cleanup 线未来没有这种 grammar，
那它就仍然回答不了：

`旧 cleanup 对象当前即便还能用，哪些更强动作还必须重新拿到更高等级授权`

## 7. `client.ts` transport hook 再证明：step-up 不是 auth.ts 自言自语，而是 live transport path 的硬门

`client.ts:620-641,820-834` 很硬。

无论 SSE 还是 StreamableHTTP transport，
repo 都显式把：

`wrapFetchWithStepUpDetection(createFetchWithInit(), authProvider)`

包进真实 transport fetch。

而且注释明确强调：

`Step-up detection wraps innermost so the 403 is seen before the SDK's handler calls auth() -> tokens()`

这条证据很值钱。

因为它说明 step-up 不是留给上层解释层的概念，
而是 transport 层当前 request semantics 的一部分。

也就是说，
repo 已经公开承认：

`更强授权门不是事后故事，而是 live request gate`

## 8. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 线未来只要补出 live-use revalidation grammar，就已经足够成熟。`

而是：

repo 已经在 `wrapFetchWithStepUpDetection()` 的 `403 insufficient_scope` detection、`ClaudeAuthProvider.tokens()` 的 refresh suppression、`performMCPOAuthFlow()` 的 cached step-up scope continuation，以及 `client.ts` transport fetch hook 的 live integration 上，明确展示了 step-up reauthorization governance 的存在；因此 `artifact-family cleanup stronger-request cleanup-use-time revalidation-governor signer` 仍不能越级冒充 `artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer`。

因此：

`stronger-request cleanup 线真正缺的，不只是“谁来决定现在还能不能用”，还包括“谁来决定现在即便能用，是否已经被授权到足以执行更强请求”。`
