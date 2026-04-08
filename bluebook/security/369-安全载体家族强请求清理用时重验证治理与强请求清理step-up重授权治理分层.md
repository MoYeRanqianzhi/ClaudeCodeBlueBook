# 安全载体家族强请求清理用时重验证治理与强请求清理step-up重授权治理分层：为什么artifact-family cleanup stronger-request cleanup-use-time revalidation-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer

## 1. 为什么在 `368` 之后还必须继续写 `369`

`368-安全载体家族强请求清理重新担保治理与强请求清理用时重验证治理分层`
已经回答了：

`stronger-request cleanup 线即便已经让某个 surface 给出足够正向的 reassurance，也还要单独回答真正 consumer 在 live use 瞬间是否已经重新拿到 fresh enough 的 current-use proof。`

但如果继续往下追问，
还会碰到另一层同样容易被偷写成
“既然这次 live use 已经 fresh enough，那么任何更强请求当然都应该被允许”
的错觉：

`只要 stronger-request cleanup use-time revalidation governor 已经确认当前 consumer 在使用瞬间 fresh enough to use，它就自动拥有了决定当前 authority level 是否也足够支撑更强请求的主权，不再需要更高等级的 step-up 重授权。`

Claude Code 当前源码同样不能支持这种更强说法。

因为继续看 MCP 线上已经成熟写出的 step-up 重授权正对照，
会发现 repo 其实明确拆开了五件事：

1. insufficient-scope detection
2. step-up pending state
3. refresh-token suppression
4. step-up continuation state
5. transport-level integration

最硬的证据至少有五组：

1. `auth.ts:1345-1372` 的 `wrapFetchWithStepUpDetection()`
2. `auth.ts:1461-1472,1625-1692` 的 `markStepUpPending()` 与 `tokens()`
3. `auth.ts:578-618,900-940,1848-1900` 的 step-up state 保留、cached `stepUpScope` 复用与 `redirectToAuthorization()`
4. `client.ts:620-641,820-834` 的 transport fetch wrapper 挂接
5. `auth.ts:1700-1712` 的 `_pendingStepUpScope` 完成语义

会发现 repo 已经清楚展示出：

1. `stronger-request cleanup use-time revalidation governance`
   负责决定真正 consumer 在依赖瞬间是否已经 fresh enough to use
2. `stronger-request cleanup step-up reauthorization governance`
   负责决定这份 fresh current-use proof 是否已经拥有足够高的 authority level / scope 去执行更强请求

也就是说：

`artifact-family cleanup stronger-request cleanup-use-time revalidation-governor signer`

和

`artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer`

仍然不是一回事。

前者最多能说：

`这次依赖发生前，当前连接 / 当前对象 / 当前使用资格已经被 fresh re-check。`

后者才配说：

`这次 fresh current-use proof 对当前请求所需的更高 scope / authority level 也已经足够；如果 scope 不足，就必须进入更强的 step-up reauthorization path。`

所以 `368` 之后必须继续补的一层就是：

`安全载体家族强请求清理用时重验证治理与强请求清理step-up重授权治理分层`

也就是：

`stronger-request cleanup use-time revalidation governor 决定当前是否 fresh enough to use；stronger-request cleanup step-up reauthorization governor 才决定当前 authority level 是否足够支撑更强请求。`

## 2. 先做三条谨慎声明

第一条：

`Claude Code 当前源码里并没有一个字面存在的类型叫 artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer。`

这里的
`artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer`
仍是研究命名。
它不是在声称 cleanup 线已经有一个未公开的 scope-elevation manager，
而是在说：

1. repo 已经明确把 fresh use-time truth 与 stronger-scope truth 拆开
2. repo 已经明确把 `403 insufficient_scope` 从普通 refresh path 里单独分流出来
3. repo 已经明确承认 refresh 不能完成 scope elevation，因此更强请求必须进入 step-up reauthorization

第二条：

这里的 `step-up reauthorization`

不是前面的 recovery，也不是 `368` 里的 live-use revalidation。

当前更稳的说法只能是：

`recovery 回答什么新的凭据与新连接足以恢复 usable truth；use-time revalidation 回答当前是否 still fresh enough to use；step-up reauthorization 则回答即便 current-use truth 已 fresh，它对当前更强请求的 authority level 是否仍然不够。`

第三条：

这里也不能过度声称：

`step-up reauthorization governance`

已经等于：

`stronger-request continuation governance`

当前更稳的说法只能是：

`step-up reauthorization 先回答“当前 authority 是否足够强”；continuation 才回答“先前那个被挡下的 stronger request 现在是否仍配以同一请求名义继续”。`

## 3. 最短结论

Claude Code 当前源码至少给出了五类

`stronger-request cleanup-use-time revalidation-governor signer 仍不等于 stronger-request cleanup-step-up reauthorization-governor signer`

证据：

1. `wrapFetchWithStepUpDetection()` 会在 transport fetch 上先捕获 `403 insufficient_scope` 并标记 step-up pending，说明 fresh request path 也可能 authority level 不足
2. `auth.ts` 明确写出 RFC 6749 §6 不允许用 refresh 做 scope elevation，说明 fresh token 并不自动等于 stronger-scope token
3. `tokens()` 在 `needsStepUp` 时故意省略 `refresh_token`，迫使 SDK 落入 PKCE step-up flow，说明当前 proof fresh 也不等于 authority sufficient
4. `redirectToAuthorization()`、cached `stepUpScope` 与 `preserveStepUpState` 会把 step-up scope 跨 revoke / re-auth 保留下来，说明 stronger authority 需要单独的 continuation grammar
5. `client.ts` 在 SSE / HTTP transport 上都把 `wrapFetchWithStepUpDetection(createFetchWithInit(), authProvider)` 挂到真实 transport fetch 上，说明 step-up 不是抽象方针，而是 live transport path 的正式 gate

因此这一章的最短结论是：

`stronger-request cleanup use-time revalidation governor 最多能说这次依赖前 fresh current-use proof 已经成立；stronger-request cleanup step-up reauthorization governor 才能说这份 fresh proof 对当前请求所需的更高 scope / authority level 是否已经足够。`

再压成一句：

`fresh enough to use，不等于 authorized enough to upscope。`

再压成更哲学一点的话：

`制度知道你现在还能用，不等于制度已经知道你现在配升级动作等级。`

## 4. 第一性原理：use-time revalidation 回答“此刻还能不能用”，step-up reauthorization 回答“此刻即便能用，是否有资格执行更强请求”

从第一性原理看，
强请求清理用时重验证治理与强请求清理 step-up 重授权治理处理的是两个不同主权问题。

`stronger-request cleanup use-time revalidation governor`
回答的是：

1. 当前连接是否仍然 alive
2. 当前 capability 是否仍然 current
3. 当前 read / list / tool execution 是否仍可启动
4. stale reassurance 是否应在第一时间撤销
5. 真实 consumer 在依赖前是否已拿到 fresh proof

`stronger-request cleanup step-up reauthorization governor`
回答的则是：

1. 当前 fresh proof 的 scope 是否覆盖请求所需 authority level
2. 当前 token 问题是 freshness 问题，还是 authorization-level 问题
3. refresh path 是否仍有意义，还是必须进入 step-up flow
4. 哪些 scope 信息要在 step-up 过程中跨 revoke / re-auth 保留
5. 什么时候才配从 fresh current-use truth 升格到 stronger-scope truth

如果把这两层压成一句：

`既然这次已经 fresh 了`

系统就会制造五类危险幻觉：

1. `fresh-means-sufficient`
2. `connected-means-upscoped`
3. `refresh-means-elevation`
4. `authorized-once-means-authorized-higher`
5. `live-use-means-no-step-up`

所以从第一性原理看：

`use-time revalidation governance` 管的是 freshness of current use；
`step-up reauthorization governance` 管的是 sufficiency of current authority level。

再用苏格拉底式反问压一次：

1. 如果这次 `ensureConnectedClient()` 已经成功，为什么还会出现 `insufficient_scope`？
   因为 fresh connection 只回答“现在还能连”，不回答“现在的 scope 是否足够强”。
2. 如果 token refresh 已经能拿到新 token，为什么源码还要强行跳过 refresh、转 PKCE step-up？
   因为 refresh 只能更新 freshness，不能提升 authority level。
3. 如果 auth flow 最终能得到 `AUTHORIZED`，为什么源码仍怕它在 403-upscoping 场景下重复失败？
   因为 nominal `AUTHORIZED` 不是无条件等于 requested-scope authorized。

## 5. `wrapFetchWithStepUpDetection()` 先证明：真正的 live request path 里，fresh current use 与 stronger-scope use 仍是两层

`auth.ts:1345-1372`
很值钱。

这里的注释直接解释了一个很深的语义问题：

1. 当 transport fetch 收到 `403 insufficient_scope`
2. 如果不先标记 step-up pending
3. SDK 的 authInternal 会看见 `refresh_token`
4. 然后走 refresh
5. 返回 `AUTHORIZED`
6. 再 retry
7. 再 403
8. 最终以“upscoping 后仍失败”终止

这条链非常关键。

因为它说明源码作者明确承认：

`fresh token path`

和

`stronger scope path`

不是同一条路。

也就是说，
当前 live request 即便已经到达“需要 auth 层再处理”这一步，
系统仍要继续分辨：

1. 这是 freshness 缺口
2. 还是 authority-level 缺口

`wrapFetchWithStepUpDetection()` 的真正价值，
就在于它拒绝让第二种问题被第一种路径假装解决。

## 6. `markStepUpPending()` 与 `tokens()` 再证明：源码明确拒绝把 refresh 冒充成 scope elevation

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

## 7. `performMCPOAuthFlow()`、`redirectToAuthorization()` 与 step-up state persistence 再证明：更强授权拥有自己的 continuation grammar

`auth.ts:578-618,900-940,1848-1900`
一起看非常值钱。

这里 repo 做了三件很成熟的事：

1. 在 revoke / re-auth 时保留 `stepUpScope` 与 `discoveryState`
2. 在下一次 `performMCPOAuthFlow()` 开始前先读 cached `stepUpScope`
3. 在 `redirectToAuthorization()` 里把新的 scope 从 URL 或 metadata 里提取出来，并持久化 step-up scope

这说明更强授权并不是：

`fresh use path 失败了，临时弹个浏览器，再碰碰运气`

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

## 8. `client.ts` transport hook 与 `_pendingStepUpScope` completion semantics 再证明：step-up 不是方针，而是 live transport path 的正式 gate

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

## 9. 更深一层的技术先进性：Claude Code 不只在治理你这一刻还能不能用，也在治理你这一刻即便能用，是否已经配升级动作等级

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

## 10. 苏格拉底式自反诘问：我是不是又把“这一刻 fresh enough to use”误认成了“这一刻也已经有资格执行更强请求”

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

## 11. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 只要补出 use-time revalidation governance，就已经足够成熟。`

而是：

`Claude Code 在 insufficient-scope detection、step-up pending state、refresh-token suppression、step-up continuation state、transport-level integration 与 completion semantics 上已经明确展示了 step-up reauthorization governance 的存在；因此 artifact-family cleanup stronger-request cleanup-use-time revalidation-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer。`

再压成一句：

`cleanup 线真正缺的不是“它这一刻还能不能用”，而是“它这一刻即便能用，是否已经配去做更强的事”。`
