# wrapFetchWithStepUpDetection、ClaudeAuthProvider与performMCPOAuthFlow的强请求清理step-up重授权治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `369` 时，
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

把 `403 insufficient_scope` detection、`markStepUpPending()`、`tokens()` 的 refresh-token suppression、step-up scope persistence、cached discovery reuse 与 transport fetch hook 并排，
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
| insufficient-scope detection | `src/services/mcp/auth.ts:1345-1372` | 为什么 transport fetch 会在最前线把 `403 insufficient_scope` 识别成 authority-level 问题 |
| step-up pending state | `src/services/mcp/auth.ts:1461-1472,1625-1692` | 为什么当前 token fresh 不等于当前 scope 足够 |
| step-up continuation | `src/services/mcp/auth.ts:578-618,900-940,1848-1900` | 为什么更高授权要保留自己的 state across revoke / re-auth |
| transport integration | `src/services/mcp/client.ts:620-641,820-834` | 为什么 step-up detection 是 live transport path 的正式部分 |
| completion semantics | `src/services/mcp/auth.ts:1700-1712` | 为什么 higher-authority pending state 拥有单独的完成条件 |

## 4. `wrapFetchWithStepUpDetection()` 先证明：authority-level 缺口不会被当成 freshness-level 缺口

`auth.ts:1345-1372`
很值钱。

注释已经把整个失败链说透：

1. transport fetch 若看到 `403 insufficient_scope`
2. 就必须先标记 step-up pending
3. 否则 SDK 的 authInternal 会看到 `refresh_token`
4. 走 refresh
5. 由于 RFC 6749 §6 不允许通过 refresh 提升 scope，最终只会拿回同等级 token
6. retry
7. 再 403
8. 最后以 upscoping failure 终止

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

`auth.ts:1461-1472,1625-1692`
更硬。

这里 repo 做了四件很关键的事：

1. `markStepUpPending(scope)` 把所需更高 scope 记进 provider
2. `tokens()` 比较 `_pendingStepUpScope` 与当前 token 的实际 scope
3. 若 scope 不覆盖，则设置 `needsStepUp=true`
4. 在返回 token 时故意省略 `refresh_token`

这一步极其值钱。

因为它不是“建议去 step-up”，
而是在控制面上直接做出：

`refresh path suppression`

这意味着 repo 公开承认：

`当前 token 可能完全 fresh、当前 use path 也可能完全 live，但如果 authority level 不够，就必须禁止错误路径继续冒充正确路径`

## 6. `performMCPOAuthFlow()` 与 step-up state persistence 再证明：更高授权拥有自己的跨流程连续性

`auth.ts:578-618,900-940,1848-1900`
很值钱。

这里 repo 明确：

1. re-auth 时可以保留 `stepUpScope` 与相关 state
2. 下一次 `performMCPOAuthFlow()` 开始前先读取 cached `stepUpScope`
3. transport-attached provider 在收到更高 scope 后会把 `stepUpScope` 持久化

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

## 7. `client.ts` transport hook 与 `_pendingStepUpScope` completion semantics 再证明：step-up 不是方针，而是 live transport path 的正式 gate

`client.ts:620-641,820-834`
很硬。

无论 SSE 还是 StreamableHTTP transport，
repo 都把：

`wrapFetchWithStepUpDetection(createFetchWithInit(), authProvider)`

挂在真实 fetch 最前线。

这说明 step-up 不是 auth.ts 的私有注释，
而是 live request semantics 的正式部分。

`auth.ts:1700-1712`
又补上完成语义：

1. `saveTokens()` 一开始就清掉 `_pendingStepUpScope`
2. 只有新的 higher-authority token 真正落盘，pending scope 才被清空

从第一性原理看，
这非常先进。

因为它让：

1. detection
2. suppression
3. persistence
4. completion

形成了闭环，
而不是只留下一个“需要更高权限”的 UI 影子。

## 8. 更深一层的技术先进性：Claude Code 不只在治理你这一刻还能不能用，也在治理你这一刻即便能用，是否已经配升级动作等级

这组源码给出的技术启示至少有五条：

1. `403 insufficient_scope` 必须在 transport 前线被看作 authority-level signal，而不是普通 freshness failure
2. refresh 只能修 freshness，不能偷偷冒充 scope elevation
3. higher-authority intent 应该拥有跨 revoke / re-auth 的持续状态，否则系统会反复忘记自己真正缺的是什么
4. live transport integration 比事后 UI 提示更接近真正的安全边界
5. higher-authority flow 也应该有明确的完成条件，而不是只留下 pending 影子

用苏格拉底式反问压缩，
可以得到五个自检问题：

1. 如果 fresh enough to use 已经足够，为什么 repo 还要在 transport 前线单独抓 `403 insufficient_scope`？
2. 如果 refresh 足够，为什么 `tokens()` 要在 `needsStepUp` 时故意省略 `refresh_token`？
3. 如果更高授权不需要单独连续性，为什么要跨 revoke / re-auth 保留 `stepUpScope` 与相关 state？
4. 如果 step-up 只是 auth.ts 的内部实现，为什么 SSE / HTTP transport 都要统一挂接 detection wrapper？
5. 如果 higher-authority 已经自动成立，为什么 `saveTokens()` 还需要以清空 `_pendingStepUpScope` 作为独立完成点？

## 9. 苏格拉底式自反诘问：我是不是又把“这一刻 fresh enough to use”误认成了“这一刻也已经有资格执行更强请求”

如果对这组代码做更严格的自我审查，
至少要追问六句：

1. 如果 use-time revalidation 已经足够强，为什么还要再拆 step-up reauthorization？
   因为 fresh enough to use，不等于 authorized enough to upscope。
2. 如果某个 consumer path 已经通过了 `ensureConnectedClient()`，是不是就说明任何更强动作也都该被允许？
   不是。freshness 证明不替代 authority-level proof。
3. 如果 refresh token 还能用，为什么系统还要故意 suppress refresh path？
   因为 refresh 解决的是 freshness，而不是 scope elevation。
4. 如果当前请求已经走到 live transport 边界，为什么仍要对 `403 insufficient_scope` 单独分流？
   因为 transport success / liveness 与 stronger-scope sufficiency 不是一回事。
5. 如果 step-up scope 已经被记录下来，是不是就说明 higher-authority 已经完成？
   不是。pending state 只是 continuation grammar，不是完成态。
6. 如果 cleanup 线现在还没有显式 step-up 代码，是不是说明这层还不值得写？
   恰恰相反。越是缺这层明确 grammar，越容易把“这一刻还能用”偷写成“这一刻也已经配做更强的事”。`

这一串反问最终逼出一句更稳的判断：

`step-up reauthorization 的关键，不在系统这一刻还能不能让你继续用，而在系统能不能正式决定你这一刻是否也已经有资格把动作等级继续往上提。`

## 10. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 只要补出 use-time revalidation governance，就已经足够成熟。`

而是：

`Claude Code 在 insufficient-scope detection、step-up pending state、refresh-token suppression、step-up continuation state、transport-level integration 与 completion semantics 上已经明确展示了 step-up reauthorization governance 的存在；因此 artifact-family cleanup stronger-request cleanup-use-time revalidation-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer。`

再压成一句：

`cleanup 线真正缺的不是“它这一刻还能不能用”，而是“它这一刻即便能用，是否已经配去做更强的事”。`
