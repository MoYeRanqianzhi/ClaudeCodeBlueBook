# 安全载体家族强请求清理用时重验证治理与强请求清理step-up重授权治理分层：为什么artifact-family cleanup stronger-request cleanup-use-time revalidation-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer

## 1. 为什么在 `400` 之后还必须继续写 `401`

`400-安全载体家族强请求清理重新担保治理与强请求清理用时重验证治理分层`
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

1. `insufficient-scope detection`
2. `refresh suppression`
3. `step-up pending state`
4. `higher-authority continuation state`
5. `live transport scope gate`

最硬的证据至少有五组：

1. `services/mcp/auth.ts:1345-1370` 的 `wrapFetchWithStepUpDetection()` 会在 transport fetch 上捕获 `403 insufficient_scope` 并标记 step-up pending
2. `services/mcp/auth.ts:1461-1470,1625-1690` 的 `markStepUpPending()` 与 `tokens()` 会在 `needsStepUp` 时故意省略 `refresh_token`
3. `services/mcp/auth.ts:572-618,900-940,1848-1900` 会跨 revoke / re-auth 保留 `stepUpScope` 与 `discoveryState`，并在 `performMCPOAuthFlow()` 开始前复用 cached stronger scope
4. `services/mcp/client.ts:620-641,820-834` 会把 `wrapFetchWithStepUpDetection(createFetchWithInit(), authProvider)` 挂到真实 SSE/HTTP transport fetch 上
5. `services/mcp/auth.ts:1220-1228,1345-1349` 明确写出 RFC 6749 §6 不允许用 refresh 做 scope elevation，且 nominal `AUTHORIZED` 仍可能落入 403-upscoping 死循环

这说明：

`artifact-family cleanup stronger-request cleanup-use-time revalidation-governor signer`

和

`artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer`

仍然不是一回事。

前者最多能说：

`这次依赖发生前，当前连接/当前对象/当前使用资格已经被 fresh re-check。`

后者才配说：

`这次 fresh current-use proof 对当前请求所需的更高 scope / authority level 也已经足够；如果 scope 不足，就必须进入更强的 step-up reauthorization path。`

所以 `400` 之后必须继续补的一层就是：

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

不是前面的 recovery，也不是 `400` 里的 live-use revalidation。

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
5. `client.ts` 在 SSE/HTTP transport 上都把 `wrapFetchWithStepUpDetection(createFetchWithInit(), authProvider)` 挂到真实 transport fetch 上，说明 step-up 不是抽象方针，而是 live transport path 的正式 gate

因此这一章的最短结论是：

`stronger-request cleanup use-time revalidation governor 最多能说这次依赖前 fresh current-use proof 已经成立；stronger-request cleanup step-up reauthorization governor 才能说这份 fresh proof 对当前请求所需的更高 scope / authority level 是否已经足够。`

再压成一句：

`fresh enough to use，不等于 authorized enough to upscope。`

再压成更哲学一点的话：

`制度知道你现在还能用，不等于制度已经知道你现在配做更强的事。`

## 4. 第一性原理：use-time revalidation 回答“此刻还能不能用”，step-up reauthorization 回答“此刻即便能用，是否有资格执行更强请求”

从第一性原理看，
强请求清理用时重验证治理与强请求清理 step-up 重授权治理处理的是两个不同主权问题。

`stronger-request cleanup use-time revalidation governor`
回答的是：

1. 当前连接是否仍然 alive
2. 当前 capability 是否仍然 current
3. 当前 read/list/tool execution 是否仍可启动
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

系统就会制造六类危险幻觉：

1. `fresh-means-sufficient`
2. `connected-means-upscoped`
3. `refresh-means-elevation`
4. `authorized-once-means-authorized-higher`
5. `live-use-means-no-step-up`
6. `current-proof-means-stronger-proof`

所以从第一性原理看：

`use-time revalidation governance` 管的是 freshness of current use；
`step-up reauthorization governance` 管的是 sufficiency of current authority level。

## 5. Claude Code 多重安全技术的先进性：它把“还能用”和“配不配执行更强动作”拆成两套门

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
5. `transport-level detection`
   把 insufficient-scope detection 挂在 live fetch 最内层，而不是留给上层故事解释
6. `nominal authorization skepticism`
   明确承认 nominal `AUTHORIZED` 仍可能不是 stronger-scope authorized

这些设计背后的源码思路也很清楚：

1. 不让 `fresh current-use truth` 越级冒充 `higher-authority truth`
2. 不让 refresh path 冒充 scope elevation path
3. 不让 nominal authorization 掩盖 requested authority gap
4. 不让 stronger-scope state 在 revoke / re-auth 中丢失
5. 不让 live request gate 退化成事后注释

对 stronger-request cleanup 线最有价值的技术启示至少有六条：

1. live-use revalidation 之外，还必须单列 higher-authority grammar。
2. freshness repair 与 authority elevation 必须有不同 primitive。
3. `403 insufficient_scope` 这种 authority-level contradiction 必须被 transport 层尽早识别。
4. refresh suppression 不是兼容性细节，而是安全边界。
5. stronger-scope intent 必须拥有跨流程 continuation state。
6. “当前还能用”与“当前配做更强动作”必须是两层不同 signer。

## 6. 苏格拉底式自反诘问：我是不是又把“它现在还能用”误认成了“它现在也配做更强的事”

如果对这组代码做更严格的自我审查，
至少要追问六句：

1. 如果这次 `ensureConnectedClient()` 已经成功，为什么还会出现 `insufficient_scope`？
   因为 fresh connection 只回答“现在还能连”，不回答“现在的 scope 是否足够强”。
2. 如果 token refresh 已经能拿到新 token，为什么源码还要强行跳过 refresh、转 PKCE step-up？
   因为 refresh 只能更新 freshness，不能提升 authority level。
3. 如果 auth flow 最终能得到 `AUTHORIZED`，为什么源码仍怕它在 403-upscoping 场景下重复失败？
   因为 nominal `AUTHORIZED` 不是无条件等于 requested-scope authorized。
4. 如果当前 proof 已经对基础使用成立，为什么更强请求还要单独记录 `stepUpScope`？
   因为 higher-authority intent 本身拥有自己的待满足条件。
5. 如果 step-up 只是另一种 UI 体验，为什么 transport fetch 要最内层包 `wrapFetchWithStepUpDetection()`？
   因为 step-up 不是界面故事，而是 live request gate。
6. 如果 cleanup 线还没正式长出 step-up grammar，是不是说明这层只是 scope 细节？
   恰恰相反。越是把 scope 当细节，越容易让“现在还能用”偷签“现在也有权做更强动作”。

这一串反问最终逼出一句更稳的判断：

`step-up reauthorization 的关键，不在当前 proof 是否 fresh enough，而在系统能不能正式决定这份 current proof 对更强请求是否仍然太弱。`

## 7. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 未来只要补出 live-use revalidation grammar，就已经足够成熟。`

而是：

`Claude Code 在 wrapFetchWithStepUpDetection() 的 403 insufficient_scope detection、ClaudeAuthProvider.tokens() 的 refresh suppression、performMCPOAuthFlow() 的 cached step-up scope continuation，以及 client.ts transport fetch hook 的 live integration 上，已经明确展示了 step-up reauthorization governance 的存在；因此 artifact-family cleanup stronger-request cleanup-use-time revalidation-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer。`

再压成一句：

`stronger-request cleanup use-time revalidation governance 能回答“现在还能不能用”；stronger-request cleanup step-up reauthorization governance 才能回答“现在即便能用，是否已经被授权到足以执行更强请求”。`
