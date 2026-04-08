# 安全载体家族强请求清理用时重验证治理与强请求清理step-up重授权治理分层：为什么artifact-family cleanup stronger-request cleanup-use-time revalidation-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer

## 1. 为什么在 `337` 之后还必须继续写 `338`

`337-安全载体家族强请求清理重新担保治理与强请求清理用时重验证治理分层`
已经回答了：

`stronger-request cleanup 线即便已经让某个 surface 给出足够正向的 reassurance，也还要单独回答真正 consumer 在 live use 瞬间是否已经重新拿到 fresh enough 的 current-use proof。`

但如果继续往下追问，
还会碰到另一层同样容易被偷写成
“既然这次 live use 已经 fresh enough，那么任何更强请求当然都该被允许”
的错觉：

`只要 stronger-request cleanup use-time revalidation governor 已经确认当前 consumer 在使用瞬间 fresh enough to use，它就自动拥有了决定当前 authority level 是否也足够支撑更强请求的主权。`

Claude Code 当前源码同样不能支持这种更强说法。

因为继续看 MCP 线上已经成熟写出的 step-up reauthorization 正对照，
会发现 repo 其实明确拆开了六件事：

1. `insufficient-scope detection`
2. `scope-vs-freshness split`
3. `refresh suppression`
4. `higher-authority pending state`
5. `step-up continuation state`
6. `higher-authority completion semantics`

最硬的证据至少有六组：

1. `src/services/mcp/auth.ts:1345-1368`
   的
   `wrapFetchWithStepUpDetection()`
   与
   `403 insufficient_scope`
2. `src/services/mcp/auth.ts:1468-1469`
   的
   `markStepUpPending(scope)`
3. `src/services/mcp/auth.ts:1625-1690`
   的
   `needsStepUp`
   与
   `refresh_token` suppression
4. `src/services/mcp/auth.ts:582-598,909,1896`
   的
   `preserveStepUpState`、
   cached `stepUpScope`
   与 persisted `stepUpScope`
5. `src/services/mcp/client.ts:633,827`
   把
   `wrapFetchWithStepUpDetection(createFetchWithInit(), authProvider)`
   挂到真实 transport fetch
6. `src/services/mcp/auth.ts:1705`
   在
   `saveTokens()`
   上清掉
   `_pendingStepUpScope`

会发现 repo 已经清楚展示出：

1. `stronger-request cleanup use-time revalidation governance`
   负责决定真正 consumer 在依赖瞬间是否已经 fresh enough to use
2. `stronger-request cleanup step-up reauthorization governance`
   负责决定这份 fresh current-use proof
   对当前更强请求所需的更高 scope / authority level
   是否仍然不够，
   从而必须进入 step-up flow

也就是说：

`artifact-family cleanup stronger-request cleanup-use-time revalidation-governor signer`

和

`artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer`

仍然不是一回事。

前者最多能说：

`这次依赖发生前，当前连接/当前对象/当前使用资格已经被 fresh re-check。`

后者才配说：

`这次 fresh current-use proof 对当前请求所需的更高 scope / authority level 也已经足够；如果 scope 不足，就必须进入更高等级的重授权路径。`

所以 `337` 之后必须继续补的一层就是：

`安全载体家族强请求清理用时重验证治理与强请求清理step-up重授权治理分层`

也就是：

`stronger-request cleanup use-time revalidation governor 决定当前是否 fresh enough to use；stronger-request cleanup step-up reauthorization governor 才决定当前 authority level 是否足够支撑更强请求。`

## 2. 先做五条谨慎声明

第一条：

`Claude Code 当前源码里并没有一个字面存在的类型叫 artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer。`

这里的
`artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer`
仍是研究命名。
它不是在声称 cleanup 线已经有一个未公开的 scope-elevation manager，
而是在说：

1. repo 已经明确把 fresh current-use truth 与 stronger-scope truth 拆开
2. repo 已经明确把 `403 insufficient_scope` 从普通 refresh path 里单独分流出来
3. repo 已经明确承认 refresh 不能完成 scope elevation，因此更强请求必须进入 step-up reauthorization

第二条：

这里的 `step-up reauthorization`
不是 recovery，
也不是 `337` 里的 live-use revalidation。

当前更稳的说法只能是：

`recovery 回答什么新的凭据与新连接足以恢复 usable truth；use-time revalidation 回答当前是否 still fresh enough to use；step-up reauthorization 则回答即便 current-use truth 已 fresh，它对当前更强请求的 authority level 是否仍然不够。`

第三条：

这里也不能过度声称：

`step-up reauthorization governance`

已经等于：

`stronger-request continuation governance`

当前更稳的说法只能是：

`step-up reauthorization 先回答“当前 authority 是否足够强”；continuation 才回答“先前那个被挡下的 stronger request 现在是否仍配以同一请求名义继续”。`

第四条：

这里也不能把：

`fresh enough to use`

误读成：

`authorized enough for any stronger action`

当前更稳的说法只能是：

`freshness 只回答此刻还能不能用，authority sufficiency 才回答能不能做更强的事。`

第五条：

这里最后不能把：

`refresh_token`
的存在

误读成：

`scope elevation path 的存在`

当前更稳的说法只能是：

`refresh 能修 freshness，不能偷偷冒充 authority upgrade。`

## 3. 最短结论

Claude Code 当前源码至少给出了六类

`stronger-request cleanup-use-time revalidation-governor signer 仍不等于 stronger-request cleanup-step-up reauthorization-governor signer`

证据：

1. `wrapFetchWithStepUpDetection()`
   会在 transport fetch 上先捕获 `403 insufficient_scope`
   并标记 step-up pending，
   说明 fresh request path 也可能 authority level 不足
2. `auth.ts`
   明确把 RFC 6749 §6 的限制写进注释链，
   说明 fresh token 并不自动等于 stronger-scope token
3. `tokens()`
   在 `needsStepUp` 时故意省略 `refresh_token`，
   迫使 SDK 落入 PKCE step-up flow，
   说明当前 proof fresh 也不等于 authority sufficient
4. `preserveStepUpState`
   与 cached/persisted `stepUpScope`
   会把 stronger-scope intent 跨 revoke / re-auth 保留下来，
   说明 higher authority 需要单独的 continuation grammar
5. `client.ts`
   在 SSE/HTTP transport 上都把 detection wrapper 挂到真实 fetch，
   说明 step-up 不是抽象方针，而是 live transport path 的正式 gate
6. `saveTokens()`
   以清空 `_pendingStepUpScope`
   作为独立完成点，
   说明 higher-authority repair 有自己的 completion semantics

因此这一章的最短结论是：

`stronger-request cleanup use-time revalidation governor 最多能说这次依赖前 fresh current-use proof 已经成立；stronger-request cleanup step-up reauthorization governor 才能说这份 fresh proof 对当前请求所需的更高 scope / authority level 是否已经足够。`

再压成一句：

`fresh enough to use，不等于 authorized enough to upscope。`

再压成更硬的一句：

`current-use truth，不等于 stronger-scope truth。`

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
4. 哪些 higher-scope state 要在 revoke / re-auth 中被保留
5. 什么时候才配从 fresh current-use truth 升格到 stronger-scope truth

如果把这两层压成一句
`既然这次已经 fresh 了`
，
系统就会制造五类危险幻觉：

1. `fresh-means-sufficient`
2. `connected-means-upscoped`
3. `refresh-means-elevation`
4. `authorized-once-means-authorized-higher`
5. `live-use-means-no-step-up`

所以从第一性原理看：

`use-time revalidation governance` 管的是 freshness of current use；
`step-up reauthorization governance` 管的是 sufficiency of current authority level。

## 5. `wrapFetchWithStepUpDetection()` 先证明：真正的 live request path 里，fresh current use 与 stronger-scope use 仍是两层

`src/services/mcp/auth.ts:1345-1368`
很值钱。

这里的注释直接解释了一个很深的语义问题：

1. 当 transport fetch 收到 `403 insufficient_scope`
2. 如果不先标记 step-up pending
3. SDK 的 authInternal 会看见 `refresh_token`
4. 然后走 refresh
5. 返回 `AUTHORIZED`
6. 再 retry
7. 再 403
8. 最终以 upscoping failure 终止

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

从安全设计哲学看，
这非常先进：

`系统不只要知道你现在还能不能用，还要知道你此刻“不能做更强的事”的原因究竟是什么。`

## 6. `markStepUpPending()` 与 `tokens()` 再证明：源码明确拒绝把 refresh 冒充成 scope elevation

`src/services/mcp/auth.ts:1468-1469,1625-1690`
更硬。

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

更进一步压成一句就是：

`安全系统真正先进的地方，不是有更多 fallback，而是知道哪条 fallback 从制度上就不配出现。`

## 7. `preserveStepUpState`、cached `stepUpScope` 与 persisted `stepUpScope` 再证明：更高授权拥有自己的跨流程连续性

`src/services/mcp/auth.ts:582-598,909,1896`
一起看非常值钱。

这里 repo 做了三件很成熟的事：

1. 在 revoke / re-auth 时保留 `stepUpScope` 与相关 discovery state
2. 在下一次 flow 开始前先读 cached `stepUpScope`
3. 在成功获得更高 scope 后再把 `stepUpScope` 写回 token data

这说明更强授权并不是：

`fresh use path 失败了，临时再开一轮普通登录`

而是：

`higher-authority request has its own continuation state`

这条证据非常关键。

因为它说明 repo 并不是在使用一个临时 UI patch。
它是在给更高 authority level 建一条正式 grammar：

1. 哪个 scope 正在 pending
2. 哪个 metadata/discovery state 要保留
3. 下一次 flow 应该以什么 stronger target 继续

如果 cleanup 线未来没有这种 grammar，
那它就仍然回答不了：

`旧 cleanup 对象当前即便还能用，哪些更强动作还必须重新拿到更高等级授权`

## 8. `client.ts` transport hook 与 `saveTokens()` completion semantics 再证明：step-up 不是注释，而是 live gate 加闭环 completion

`src/services/mcp/client.ts:633,827`
很硬。

无论 SSE 还是 StreamableHTTP transport，
repo 都把：

`wrapFetchWithStepUpDetection(createFetchWithInit(), authProvider)`

挂在真实 fetch 最前线。

这说明 step-up 不是 auth.ts 的私有解释，
而是 live request semantics 的正式部分。

`src/services/mcp/auth.ts:1705`
则再补上更关键的一层：

`saveTokens()` 一开始就清掉 `_pendingStepUpScope`

这说明 step-up 不是无限 pending 的提醒旗帜。
它拥有自己的 completion semantics：

`只有新的 higher-authority token 真正落盘，pending scope 才被清空`

从第一性原理看，
这非常先进。

因为它让：

1. detection
2. suppression
3. persistence
4. completion

形成了闭环，
而不是只留下一个“需要更高权限”的 UI 影子。

## 9. Claude Code 在这一层的先进性与技术启示

这组源码至少给出六条值得单独记住的技术启示：

1. `403 insufficient_scope`
   必须在 transport 前线被看作 authority-level signal，
   而不是普通 freshness failure
2. refresh
   只能修 freshness，
   不能偷偷冒充 scope elevation
3. higher-authority intent
   应该拥有跨 revoke / re-auth 的持续状态，
   否则系统会反复忘记自己真正缺的是什么
4. live transport integration
   比事后 UI 提示更接近真正的安全边界
5. higher-authority flow
   也应该有明确的完成条件，
   而不是只留下 pending 影子
6. 真正成熟的安全系统
   不会把“现在还能用”
   误写成
   “现在已经有权做更强的事”

把这些启示压成更高一层的技术哲学，
就是：

`Claude Code 不只治理 use，还治理 upscope。`

更具体地说：

`它不只管理你此刻还能不能继续行动，还管理你此刻即便还能行动，是否已经被授权到足以升级动作等级。`

## 10. 回到 stronger-request cleanup 线当前仍缺的制度缝

与这套成熟 step-up reauthorization grammar 对照，
stronger-request cleanup 线当前虽然已经有了 use-time revalidation grammar，
却还没有谁正式决定：

1. 旧 startup wording
   在 fresh enough to use 之后，
   哪些更强 cleanup 动作仍必须重新拿更高 authority
2. 旧 home-root cleanup law
   在 ordinary use 仍成立时，
   哪些 stronger request 仍应触发更高等级 scope gate
3. 旧 promise vocabulary
   哪些只回答 ordinary current-use truth，
   哪些又要求 stronger-scope proof
4. 旧 `CleanupResult`
   与其他 local receipt objects
   哪些只够支撑普通依赖，
   哪些绝不配越级支撑更强请求
5. uncovered diagnostics / coverage gap
   出现时 refresh 何时必须让位于更高等级的重授权路径

这些证据共同说明：

`stronger-request cleanup-use-time-revalidation-governance`
仍不能越级冒充
`stronger-request cleanup-step-up-reauthorization-governance`

因为 cleanup 线现在最缺的，
已经不是
`真正使用这一刻要拿什么 fresh proof`
，
而是
`即便这次 fresh enough to use，当前 authority level 是否仍然不够支撑更强请求。`

## 11. 用苏格拉底式反问强迫自己不把 fresh proof 偷写成 stronger-scope proof

如果我想继续把这一层做得更硬，
至少要反复问自己五句：

1. 我现在说的是
   `这次还能不能用`
   还是
   `这次能不能做更强的事`？
   如果这两句混了，
   我就在偷把 current-use truth 写成 stronger-scope truth。
2. `ensureConnectedClient()`
   已经成功之后，
   为什么 repo 仍然可能在 transport 前线抓到 `403 insufficient_scope`？
   因为 fresh connection 只回答“现在还能连”，不回答“现在的 authority level 是否足够强”。
3. token refresh
   如果已经能拿到新 token，
   为什么源码还要强行跳过 refresh、转 PKCE step-up？
   因为 refresh 只能更新 freshness，不能提升 authority level。
4. `stepUpScope`
   如果不是单独主权，
   为什么要跨 revoke / re-auth 保留它，
   又在 `saveTokens()` 时清掉它？
   因为 higher-authority flow 有自己的 pending state 和 completion semantics。
5. 就算 step-up reauthorization 已经成立，
   我能否因此直接跳过下一层“旧 blocked stronger request 是否仍配以同一请求名义继续”？
   不能。
   因为
   `authorized enough to upscope`
   仍不等于
   `same blocked request is now formally resumed`

所以这一章最后必须把自己压回一句最朴素的话：

`fresh enough to use，不等于 authorized enough to upscope；authorized enough to upscope，也不等于旧 blocked request 已经被正式续打。`
