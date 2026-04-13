# 安全载体家族强请求清理用时重验证治理与强请求清理step-up重授权治理分层：为什么artifact-family cleanup stronger-request cleanup-use-time revalidation-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer

## 1. 为什么在 `464` 之后还必须继续写 `465`

`464-安全载体家族强请求清理重新担保治理与强请求清理用时重验证治理分层`
已经回答了：

`stronger-request cleanup 线即便已经拿到 reassuring sentence，也还要单独回答真正 consumer 在依赖发生这一刻是否重新拿到 fresh enough 的 current-use proof。`

但如果继续往下追问，
还会碰到另一层同样容易被偷写成
“既然这次 current-use proof 已经 fresh enough，那么更强请求当然也该自动被允许”
的错觉：

`只要 stronger-request cleanup use-time revalidation governor 已经确认当前 consumer 此刻还能用，它就自动拥有决定更高 scope / authority level 是否也已经足够的主权，不再需要额外的 step-up reauthorization。`

Claude Code 当前源码同样不能支持这种更强说法。

因为继续看 MCP 线上已经成熟写出的 step-up 重授权正对照，
会发现 repo 其实明确拆开了七件事：

1. `insufficient-scope detection`
2. `scope-elevation vs refresh discrimination`
3. `refresh suppression`
4. `step-up pending state`
5. `higher-authority continuation state`
6. `transport-level authority gate`
7. `step-up completion semantics`

最硬的证据至少有七组：

1. `src/services/mcp/auth.ts:1345-1370`
   的 `wrapFetchWithStepUpDetection()` 会在真实 transport fetch 上捕获 `403 insufficient_scope` 并标记 step-up pending
2. `src/services/mcp/auth.ts:1461-1470,1625-1692`
   的 `markStepUpPending()` 与 `tokens()` 会在 `needsStepUp` 时故意省略 `refresh_token`
3. `src/services/mcp/auth.ts:1645-1650`
   明确写出 RFC 6749 §6 不允许用 refresh 做 scope elevation，因此 freshness path 不能冒充 higher-authority path
4. `src/services/mcp/auth.ts:578-616,903-935,1884-1899`
   会跨 revoke / re-auth 保留并复用 `stepUpScope` 与 `resourceMetadataUrl`
5. `src/services/mcp/client.ts:620-634,821-828`
   会把 `wrapFetchWithStepUpDetection(createFetchWithInit(), authProvider)` 挂到 SSE / HTTP 的真实 transport fetch 上
6. `src/services/mcp/auth.ts:1220-1228`
   的 `sdkAuth(...)` 仍可能返回 `AUTHORIZED`，说明 nominal authorization 也不自动等于 stronger-scope authorization
7. `src/services/mcp/auth.ts:1704-1705`
   的 `saveTokens()` 会在真正拿到新 tokens 时清空 `_pendingStepUpScope`，说明 step-up 不是永久 pending，而有正式 completion semantics

这说明：

`artifact-family cleanup stronger-request cleanup-use-time revalidation-governor signer`

和

`artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer`

仍然不是一回事。

前者最多能说：

`真正 consumer 在依赖发生这一刻，当前连接 / 当前会话 / 当前使用资格已经 fresh enough to use。`

后者才配说：

`这份 current-use proof 对当前更强请求所需的 scope / authority level 是否已经足够；若仍不足，就必须进入 step-up reauthorization。`

所以 `464` 之后必须继续补的一层就是：

`安全载体家族强请求清理用时重验证治理与强请求清理step-up重授权治理分层`

也就是：

`stronger-request cleanup use-time revalidation governor 决定当前是否还能用；stronger-request cleanup step-up reauthorization governor 才决定当前即便还能用，是否已经配做更强的事。`

## 2. 先做四条谨慎声明

第一条：

`Claude Code 当前源码里并没有一个字面存在的类型叫 artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer。`

这里仍是研究命名。
它不是在声称 cleanup 线已经有一个未公开的 scope-elevation manager，
而是在说：

1. repo 已经明确把 freshness of current use 与 sufficiency of current authority 拆开
2. repo 已经明确把 `403 insufficient_scope` 从普通 refresh path 里单独分流出来
3. repo 已经明确承认 higher-authority request 需要自己的 pending、continuation 与 completion grammar

第二条：

这里说的 `step-up reauthorization`
不是 recovery，
也不是 `464` 里的 use-time revalidation。

当前更稳的说法只能是：

`recovery 回答什么 fresh proof 足以把当前 use path 救回来；use-time revalidation 回答这次依赖前是否仍然 fresh enough；step-up reauthorization 则回答即便这次依赖前 fresh enough，这份 proof 对更强请求的 authority level 是否仍然太弱。`

第三条：

这里也不能过度声称：

`step-up reauthorization`
已经等于：

`stronger-request continuation governance`

当前更稳的说法只能是：

`step-up reauthorization 先回答“当前 authority 是否足够强”；continuation 才回答“原先那个被挡下的 stronger request 现在是否仍配以同一请求名义继续”。`

第四条：

这里同样不能把：

`step-up`

偷窄成：

`另一种 auth UI 体验。`

当前更稳的说法只能是：

`step-up` 是 `insufficient_scope` detection、refresh suppression law、higher-scope continuation state、transport gate 与 completion semantics 共同组成的 authority governance，而不只是一次更复杂的登录页。`

## 3. 最短结论

Claude Code 当前源码至少给出了七类

`stronger-request cleanup-use-time revalidation-governor signer 仍不等于 stronger-request cleanup-step-up reauthorization-governor signer`

证据：

1. `wrapFetchWithStepUpDetection()` 会在 transport fetch 上先捕获 `403 insufficient_scope` 并标记 step-up pending，说明 current use 成立也可能 authority level 不足
2. `markStepUpPending()` 与 `tokens()` 会在 `needsStepUp` 时故意省略 `refresh_token`，说明 fresh token 不自动等于 stronger-scope token
3. `tokens()` 还会在 `needsStepUp` 时跳过 proactive refresh，并明确引用 RFC 6749 §6，说明 refresh path 只能更新 freshness，不能提升 authority
4. `preserveStepUpState`、cached `stepUpScope` 与 `redirectToAuthorization()` 的持久化，会把更高授权请求跨 revoke / re-auth 保留下来，说明更高 authority 拥有自己的 continuation grammar
5. `client.ts` 在 SSE / HTTP transport 上都把 step-up detection 挂到真实 fetch 最内层，说明 step-up 不是抽象口号，而是 live authority gate
6. `sdkAuth(...)` 即便返回 `AUTHORIZED`，源码注释仍明确担心 upscoping failure loop，说明 nominal authorization 不自动等于 requested-scope authorization
7. `saveTokens()` 会在真实新 token 到达时清空 `_pendingStepUpScope`，说明 step-up 还有自己的完成条件，而不是永久模糊等待

因此这一章的最短结论是：

`stronger-request cleanup use-time revalidation governor 最多能说这次依赖前 current-use proof 仍然成立；stronger-request cleanup step-up reauthorization governor 才能说这份 proof 对当前更强请求是否已经足够。`

再压成一句：

`fresh enough to use，不等于 authorized enough to upscope。`

再压成更硬的一句：

`会重验能不能用，不等于会重签能不能升权。`

再压成更哲学一点的话：

`制度知道你现在还能用，不等于制度已经知道你现在配做更强的事。`

## 4. 第一性原理：use-time revalidation 回答“此刻还能不能用”，step-up reauthorization 回答“此刻即便能用，是否配执行更强请求”

从第一性原理看，
强请求清理用时重验证治理与强请求清理 step-up 重授权治理处理的是两个不同主权问题。

`stronger-request cleanup use-time revalidation governor`
回答的是：

1. 当前连接是否仍然 alive
2. 当前会话是否仍然 current
3. 当前 consumer edge 是否仍可继续依赖
4. runtime contradiction 出现时谁有权立刻撤销旧 reassurance
5. stale current-use label 是否必须在 live path 上被 fresh proof primitive 替换

`stronger-request cleanup step-up reauthorization governor`
回答的则是：

1. 当前这份 current-use proof 的 scope 是否覆盖请求所需 authority level
2. 当前问题是 freshness 问题，还是 authority-level 问题
3. refresh path 是否还有意义，还是必须进入 higher-authority flow
4. 哪些 stronger-scope intent 要在 revoke / re-auth 中继续保留
5. step-up pending 在什么条件下才算正式完成

如果把这两层压成一句：

`既然它现在还能用`

系统就会制造七类危险幻觉：

1. `fresh-means-sufficient`
2. `connected-means-upscoped`
3. `refresh-means-elevation`
4. `authorized-once-means-authorized-higher`
5. `live-use-means-no-step-up`
6. `current-proof-means-stronger-proof`
7. `nominally-authorized-means-request-fully-authorized`

所以从第一性原理看：

`use-time revalidation governance`
管的是 freshness of current use；

`step-up reauthorization governance`
管的是 sufficiency of current authority level。

## 5. Claude Code 多重安全技术的先进性：它把“还能用”和“配不配做更强动作”拆成两套互相制衡的门

从技术角度看，
Claude Code 在这里最先进的地方，
不是它“也支持 step-up”，
而是它把多重安全技术收束成两套彼此制衡的 live gate：

1. `freshness gate`
   先确认 current-use proof 仍然 fresh enough
2. `authority gate`
   再确认 current-use proof 的 scope 是否足够强
3. `refresh suppression as safety control`
   直接禁止错误路径拿 refresh 冒充 scope elevation
4. `higher-scope continuation state`
   把更高授权请求本身做成可跨 revoke / re-auth 延续的正式状态
5. `transport-level detection`
   把 `insufficient_scope` detection 挂到真实 transport fetch 最内层
6. `completion semantics`
   用 `_pendingStepUpScope` 的清空把“已经完成 step-up”做成制度可确认的结束条件
7. `pseudo-authorized trap awareness`
   明确承认 `AUTHORIZED` 也可能只是 nominally authorized，而不是 requested-scope authorized

这些设计背后的源码思路也很清楚：

1. 不让 fresh current-use truth 越级冒充 higher-authority truth
2. 不让 refresh path 越级冒充 scope elevation path
3. 不让 nominal authorization 掩盖 requested authority gap
4. 不让 higher-scope intent 在 revoke / re-auth 中丢失
5. 不让 step-up 只在 UI 层存在，而不在 transport / token / persistence / completion 四层闭环

对 stronger-request cleanup 线最有价值的技术启示至少有六条：

1. cleanup use-time revalidation 之外，还必须单列 `higher-authority gate`
2. 一旦问题是 authority-level shortfall，就要有正式的 refresh suppression law
3. stronger request 的 target scope 需要独立保存，不能只活在一次失败响应里
4. step-up detection 应该尽量贴近真实 request edge，而不是只留在高层故事文案里
5. nominal `AUTHORIZED` 不应成为更强请求已经安全的终点判断
6. higher-authority flow 也要有 completion semantics，否则系统只会知道“现在不够”，却不知道“什么时候才算已经补齐”

## 6. 苏格拉底式自反诘问：我是不是又把“它现在还能用”误认成了“它现在也配做更强的事”

如果对这组代码做更严格的自我审查，
至少要追问七句：

1. 如果 `ensureConnectedClient()` 已经证明当前 consumer 此刻还能用，为什么 transport fetch 仍会单独捕获 `403 insufficient_scope`？
   因为 freshness of current use 不回答 sufficiency of current authority。
2. 如果 refresh token 还能拿到新 token，为什么源码还要故意省略 `refresh_token`？
   因为 refresh 只能更新 freshness，不能提升 authority level。
3. 如果 `sdkAuth(...)` 已经返回 `AUTHORIZED`，为什么源码注释仍怕它 retry 后再次 `403`？
   因为 nominal authorization 不等于 requested-scope authorization。
4. 如果 re-auth 开始时会清掉旧 tokens，为什么源码还要先缓存 `stepUpScope` 与 `resourceMetadataUrl`？
   因为 higher-authority intent 本身拥有自己的 continuation grammar。
5. 如果 step-up 只是 UI 体验，为什么 `client.ts` 要把 detection wrapper 放在 transport fetch 最内层？
   因为 step-up 不是界面故事，而是 live authority gate。
6. 如果 step-up 只要 pending 就够了，为什么 `saveTokens()` 还要主动清空 `_pendingStepUpScope`？
   因为制度不仅要知道 authority shortfall 存在，还要知道 authority shortfall 何时正式被补齐。
7. 如果 cleanup 线还没长出这套 grammar，是不是说明这层只是 scope 细节？
   恰恰相反。越把它当细节，越容易让“现在还能用”偷签“现在也有权做更强动作”。

这一串反问最终逼出一句更稳的判断：

`step-up reauthorization 的关键，不在当前 proof 是否 fresh enough，而在系统能不能正式决定这份 current-use proof 对更强请求是否仍然太弱，以及何时才算已经补齐这份 authority shortfall。`

## 7. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 线未来只要补出 live-use revalidation grammar，就已经足够成熟。`

而是：

repo 已经在 `wrapFetchWithStepUpDetection()` 的 `insufficient_scope` detection、`ClaudeAuthProvider.tokens()` 的 refresh suppression、`performMCPOAuthFlow()` 的 cached step-up scope continuation、`client.ts` transport fetch hook 的 authority gate，以及 `saveTokens()` 的 completion semantics 上，明确展示了 step-up reauthorization governance 的存在；因此 `artifact-family cleanup stronger-request cleanup-use-time revalidation-governor signer` 仍不能越级冒充 `artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer`。

因此：

`stronger-request cleanup 线真正缺的，不只是“谁来决定现在还能不能用”，还包括“谁来决定现在即便能用，是否已经被授权到足以执行更强请求，以及何时正式承认这份更强授权已经完成”。`
