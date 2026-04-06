# 安全载体家族强请求清理用时重验证治理与强请求清理step-up重授权治理分层：为什么artifact-family cleanup stronger-request cleanup-use-time revalidation-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer

## 1. 为什么在 `241` 之后还必须继续写 `242`

`241-安全载体家族强请求清理重新担保治理与强请求清理用时重验证治理分层`
已经回答了：

`stronger-request cleanup 线即便已经让某个 surface 给出足够正向的 reassurance，也还要单独回答真正 consumer 在 live use 瞬间是否已经重新拿到 fresh enough 的 current-use proof。`

但如果继续往下追问，
还会碰到另一层同样容易被偷写成
“既然这次 live use 已经 fresh enough，那么任何更强请求当然都应该被允许”
的错觉：

`只要 stronger-request cleanup use-time revalidation governor 已经确认当前 consumer 在使用瞬间 fresh enough to use，它就自动拥有了决定当前 authority level 是否也足够支撑更强请求的主权，不再需要更高等级的 step-up 重授权。`

Claude Code 当前源码同样不能支持这种更强说法。

因为继续看：

1. `src/services/mcp/auth.ts:1345-1370` 的 `wrapFetchWithStepUpDetection()`
2. `src/services/mcp/auth.ts:1461-1470,1625-1690` 的 `markStepUpPending()` 与 `tokens()`
3. `src/services/mcp/auth.ts:572-618,900-940,1848-1900` 的 step-up state 保留、cached step-up scope 复用与 `redirectToAuthorization()`
4. `src/services/mcp/client.ts:620-641,820-834` 的 transport fetch wrapper 挂接
5. `src/services/mcp/auth.ts:1220-1228,1345-1349` 的 `AUTHORIZED` / 403-upscoping 注释链

会发现 repo 已经清楚展示出：

1. `stronger-request cleanup use-time revalidation governance` 负责决定真正 consumer 在依赖瞬间是否已经 fresh enough to use
2. `stronger-request cleanup step-up reauthorization governance` 负责决定这份 fresh current-use proof 是否已经拥有足够高的 authority level / scope 去执行更强请求

也就是说：

`artifact-family cleanup stronger-request cleanup-use-time revalidation-governor signer`

和

`artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer`

仍然不是一回事。

前者最多能说：

`这次依赖发生前，当前连接/当前对象/当前使用资格已经被 fresh re-check。`

后者才配说：

`这次 fresh current-use proof 对当前请求所需的更高 scope / authority level 也已经足够；如果 scope 不足，就必须进入更强的 step-up reauthorization path。`

所以 `241` 之后必须继续补的一层就是：

`安全载体家族强请求清理用时重验证治理与强请求清理step-up重授权治理分层`

也就是：

`stronger-request cleanup use-time revalidation governor 决定当前是否 fresh enough to use；stronger-request cleanup step-up reauthorization governor 才决定当前 authority level 是否足够支撑更强请求。`

## 2. 先做三条谨慎声明

第一条：

`Claude Code 当前源码里并没有一个字面存在的类型叫 artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer。`

这里的 `artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer`
仍是研究命名。
它不是在声称 cleanup 线已经有一个未公开的 scope-elevation manager，
而是在说：

1. repo 已经明确把 fresh use-time truth 与 stronger-scope truth 拆开
2. repo 已经明确把 `403 insufficient_scope` 从普通 refresh path 里单独分流出来
3. repo 已经明确承认 refresh 不能完成 scope elevation，因此更强请求必须进入 step-up reauthorization

第二条：

这里的 `step-up reauthorization`

不是前面的 recovery，也不是 `241` 里的 live-use revalidation。

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

Claude Code 当前源码至少给出了五类“stronger-request cleanup-use-time revalidation-governor signer 仍不等于 stronger-request cleanup-step-up reauthorization-governor signer”证据：

1. `wrapFetchWithStepUpDetection()` 会在 transport fetch 上先捕获 `403 insufficient_scope` 并标记 step-up pending，说明 fresh request path 也可能 authority level 不足
2. `auth.ts` 明确写出 RFC 6749 §6 不允许用 refresh 做 scope elevation，说明 fresh token 并不自动等于 stronger-scope token
3. `tokens()` 在 `needsStepUp` 时故意省略 `refresh_token`，迫使 SDK 落入 PKCE step-up flow，说明当前 proof fresh 也不等于 authority sufficient
4. `redirectToAuthorization()`、cached `stepUpScope` 与 `preserveStepUpState` 会把 step-up scope 跨 revoke / re-auth 保留下来，说明 stronger authority 需要单独的 continuation grammar
5. `client.ts` 在 SSE/HTTP transport 上都把 `wrapFetchWithStepUpDetection(createFetchWithInit(), authProvider)` 挂到真实 transport fetch 上，说明 step-up 不是抽象方针，而是 live transport path 的正式 gate

因此这一章的最短结论是：

`stronger-request cleanup use-time revalidation governor 最多能说这次依赖前 fresh current-use proof 已经成立；stronger-request cleanup step-up reauthorization governor 才能说这份 fresh proof 对当前请求所需的更高 scope / authority level 是否已经足够。`

再压成一句：

`fresh enough to use，不等于 authorized enough to upscope。`

## 4. 第一性原理：use-time revalidation 回答“此刻还能不能用”，step-up reauthorization 回答“此刻即便能用，是否有资格执行更强请求”

从第一性原理看，
强请求清理用时重验证治理与强请求清理 step-up 重授权治理处理的是两个不同主权问题。

stronger-request cleanup use-time revalidation governor 回答的是：

1. 当前连接是否仍然 alive
2. 当前 capability 是否仍然 current
3. 当前 read/list/tool execution 是否仍可启动
4. stale reassurance 是否应在第一时间撤销
5. 真实 consumer 在依赖前是否已拿到 fresh proof

stronger-request cleanup step-up reauthorization governor 回答的则是：

1. 当前 fresh proof 的 scope 是否覆盖请求所需 authority level
2. 当前 token 问题是 freshness 问题，还是 authorization-level 问题
3. refresh path 是否仍有意义，还是必须进入 step-up flow
4. 哪些 scope 信息要在 step-up 过程中跨 revoke / re-auth 保留
5. 什么时候才配从 fresh current-use truth 升格到 stronger-scope truth

如果把这两层压成一句“既然这次已经 fresh 了”，
系统就会制造五类危险幻觉：

1. fresh-means-sufficient illusion
   只要当前连接 fresh，就误以为当前 authority level 也足够
2. connected-means-upscoped illusion
   只要当前仍然 connected，就误以为可以执行任何更强请求
3. refresh-means-elevation illusion
   只要能 refresh token，就误以为可以顺便提升 scope
4. authorized-once-means-authorized-higher illusion
   只要当前 proof 对某个基础请求成立，就误以为对更强请求也成立
5. live-use-means-no-step-up illusion
   只要 real use path 没断，就误以为不需要更高等级的 reauthorization

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

`auth.ts:1345-1370` 很值钱。

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

## 6. `tokens()` 与 `markStepUpPending()` 再证明：源码明确拒绝把 refresh 冒充成 scope elevation

`auth.ts:1461-1470,1625-1690` 更硬。

这里 repo 明确写出：

1. `markStepUpPending(scope)` 会记录更强请求所需的 scope
2. `tokens()` 会检查 `_pendingStepUpScope`
3. 若当前 token scope 不覆盖所需 scope，
4. 就把 `needsStepUp=true`
5. 并故意在返回 token 时省略 `refresh_token`

这一步非常值钱。

因为它不是在说：

`refresh 不太合适`

而是在制度上强制：

`refresh path must be disabled when the problem is insufficient_scope`

从源码注释可知，
原因并不暧昧：

scope elevation 不是 refresh 能解决的事。

所以这里最值钱的技术启示是：

`freshness repair should never impersonate authority elevation`

## 7. `performMCPOAuthFlow()`、`redirectToAuthorization()` 与 step-up state persistence 再证明：更强授权拥有自己的 continuation grammar

`auth.ts:572-618,900-940,1848-1900` 一起看非常值钱。

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
2. 哪个 metadata/discovery state 要保留
3. 下一次 flow 应该以什么 stronger target 继续

如果 cleanup 线未来没有这种 grammar，
那它就仍然回答不了：

`旧 cleanup 对象当前即便还能用，哪些更强动作还必须重新拿到更高等级授权`

## 8. `client.ts` transport hook 再证明：step-up 不是 auth.ts 自言自语，而是 live transport path 的硬门

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

## 9. 从技术先进性看：Claude Code 把“还能用”和“配不配执行更强动作”拆成两套门

从技术角度看，
Claude Code 在这里最先进的地方，不是它“能做 step-up”，
而是它把多重安全技术收束成两套彼此制约的 live gate：

1. `freshness gate`
   先确认 current-use proof 仍然 fresh enough
2. `authority gate`
   再确认 current-use proof 的 scope 是否足够强
3. `refresh suppression as safety control`
   直接禁止错误路径拿 refresh 冒充 scope elevation
4. `higher-scope continuation state`
   把更高授权请求本身做成可延续、可恢复、可跨流程保留的正式状态

这套设计的哲学本质是：

`安全不只问“你现在还能不能做事”，还问“你现在即便还能做事，是否已经被授权到足以做这件更强的事”。`

对 stronger-request cleanup 线的技术启示也因此非常清楚：

如果未来只补出 “真正消费这一刻还要 fresh re-check 什么”，
却没有补出 “哪个 stronger request 还必须 step-up、refresh 何时必须被禁止、scope continuation state 怎样被保留”，
那么这条线依然只是 live-use truth grammar，
还不是 higher-authority grammar。

## 10. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 线只要补出 live-use revalidation grammar，就已经足够成熟。`

而是：

repo 已经在 `wrapFetchWithStepUpDetection()` 的 `403 insufficient_scope` detection、`ClaudeAuthProvider.tokens()` 的 refresh suppression、`performMCPOAuthFlow()` 的 cached step-up scope continuation，以及 `client.ts` transport fetch hook 的 live integration 上，明确展示了 step-up reauthorization governance 的存在；因此 `artifact-family cleanup stronger-request cleanup-use-time revalidation-governor signer` 仍不能越级冒充 `artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer`。

因此：

`stronger-request cleanup use-time revalidation governance 能回答“现在还能不能用”；stronger-request cleanup step-up reauthorization governance 才能回答“现在即便能用，是否已经被授权到足以执行更强请求”。`
