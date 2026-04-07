# 安全载体家族强请求清理用时重验证治理与强请求清理step-up重授权治理分层：为什么artifact-family cleanup stronger-request cleanup-use-time revalidation-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer

## 1. 为什么在 `305` 之后还必须继续写 `306`

`305-安全载体家族强请求清理重新担保治理与强请求清理用时重验证治理分层`
已经回答了：

`stronger-request cleanup 线即便已经让某个 surface 给出足够正向的 reassurance，也还要单独回答真正 consumer 在 live use 瞬间是否已经重新拿到 fresh enough 的 current-use proof。`

但如果继续往下追问，
还会碰到另一层同样容易被偷写成
“既然这次 live use 已经 fresh enough，那么任何更强请求当然都应该被允许”
的错觉：

`只要 stronger-request cleanup use-time revalidation governor 已经确认当前 consumer 在使用瞬间 fresh enough to use，它就自动拥有了决定当前 authority level 是否也足够支撑更强请求的主权，不再需要更高等级的 step-up 重授权。`

Claude Code 当前源码同样不能支持这种更强说法。

因为继续看 MCP 线上已经成熟写出的 step-up reauthorization 正对照，
会发现 repo 其实明确拆开了七件事：

1. `insufficient-scope detection`
2. `refresh-path suppression`
3. `pending higher-scope state`
4. `cached step-up scope reuse`
5. `discovery-state carryover`
6. `live transport gate`
7. `step-up resolution on token save`

最硬的证据至少有七组：

1. `src/services/mcp/auth.ts:1345-1370`
   的 `wrapFetchWithStepUpDetection()`
2. `src/services/mcp/auth.ts:1461-1470`
   的 `markStepUpPending(scope)`
3. `src/services/mcp/auth.ts:1625-1690`
   的 `needsStepUp`
   与 `refresh_token` omission
4. `src/services/mcp/auth.ts:579-617`
   的 preserve-step-up-state path
5. `src/services/mcp/auth.ts:903-935`
   的 cached `stepUpScope` /
   `discoveryState` reuse
6. `src/services/mcp/auth.ts:1884-1898`
   的 persisted step-up scope
7. `src/services/mcp/client.ts:620-633,821-827`
   的 live transport fetch hook

会发现 repo 已经清楚展示出：

1. `stronger-request cleanup use-time revalidation governance`
   负责决定真正 consumer 在 live use 瞬间是否已经 fresh enough to use
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

所以 `305` 之后必须继续补的一层就是：

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

1. repo 已经明确把 fresh use truth 与 stronger-scope truth 拆开
2. repo 已经明确把 `403 insufficient_scope` 从普通 refresh 路径里单独分流出来
3. repo 已经明确承认 refresh 不能完成 scope elevation，因此更强请求必须进入 step-up reauthorization

第二条：

这里的 `step-up reauthorization`
不是前面的 recovery，
也不是 `305` 里的 live-use revalidation。

当前更稳的说法只能是：

`recovery 回答什么 fresh proof 足以恢复 usable truth；use-time revalidation 回答当前是否 still fresh enough to use；step-up reauthorization 则回答即便 current-use truth 已 fresh，它对当前更强请求的 authority level 是否仍然不够。`

第三条：

这里也不是把：

`wrapFetchWithStepUpDetection()`

单独当成全部 step-up grammar。

真正关键的是：

1. `403 insufficient_scope` detection
2. `_pendingStepUpScope`
3. `refresh_token` omission
4. persisted `stepUpScope`
5. cached `discoveryState`
6. transport-level integration

第四条：

这里尤其不能过度声称：

`step-up reauthorization governance`

已经等于：

`same-request continuation governance`

当前更稳的说法只能是：

`step-up reauthorization governance 回答更高 authority 是否已经补齐；continuation governance 才回答那个被挡下的 stronger request 现在是否还配以同一请求身份继续。`

第五条：

这里还不能过度声称：

`现在能用`

就天然等于：

`现在也配做更强动作`

当前更稳的说法只能是：

`freshness-level success 最多解决“现在还能不能用”；authority-level insufficiency 仍可能要求更高授权门。`

## 3. 最短结论

Claude Code 当前源码至少给出了六类

`stronger-request cleanup-use-time revalidation-governor signer 仍不等于 stronger-request cleanup-step-up reauthorization-governor signer`

证据：

1. `wrapFetchWithStepUpDetection()`
   会在 transport fetch 最前线先抓
   `403 insufficient_scope`
2. `markStepUpPending(scope)`
   会把缺的更高 scope 写成明确 pending state
3. `tokens()`
   会在 `needsStepUp` 时故意省略 `refresh_token`
4. preserve-step-up-state 与 cached `stepUpScope`
   会让 higher-authority intent 跨 revoke / re-auth 持续存在
5. transport hook
   说明 step-up 不是 auth.ts 的私有注释，而是 live request gate
6. `saveTokens()`
   在新 token 落盘时清掉 `_pendingStepUpScope`，
   说明 step-up path 本身拥有单独的完成条件

因此这一章的最短结论是：

`stronger-request cleanup use-time revalidation governor 最多能说你这一刻已经 fresh enough to use；stronger-request cleanup step-up reauthorization governor 才能说你这份 use-proof 现在也足够支撑更强请求。`

再压成一句：

`已经被验证到能用，不等于已经被授权到能做更强的事。`

再压成更哲学一点的话：

`制度已经重新证明你此刻还活着，不等于制度已经重新授予你更高等级的行动资格。`

## 4. 第一性原理：use-time revalidation governance 回答“你这一刻还能不能用”，step-up reauthorization governance 回答“你这一刻即便能用，权限等级是否足够”

从第一性原理看，
强请求清理用时重验证治理与强请求清理step-up重授权治理处理的是两个不同主权问题。

`stronger-request cleanup use-time revalidation governor`
回答的是：

1. 当前连接是否仍 fresh enough
2. 当前 consumer edge 是否仍 connected
3. 当前 helper context 是否仍建立在 current truth 上
4. live contradiction 是否已撤销旧 reassurance
5. 这一次 use 是否 still allowed

`stronger-request cleanup step-up reauthorization governor`
回答的则是：

1. 当前 scope 是否覆盖 stronger request 所需 authority
2. 当前 token refresh 是否根本不该继续走
3. 当前 higher-scope intent 是否需要被持久化
4. 当前 re-auth 是否应带着 cached scope / discovery 继续
5. 这一次 stronger request 是否仍需额外授权门

换句话说：

`use-time revalidation governance` 处理的是
`freshness-level truth`

而
`step-up reauthorization governance` 处理的是
`authority-level sufficiency`

这两层如果不拆开，
系统最容易犯的错就是：

`把“现在还能用”偷写成“现在也配执行更强请求”。`

## 5. `wrapFetchWithStepUpDetection()` 先证明：authority-level 缺口不会被当成 freshness-level 缺口

`src/services/mcp/auth.ts:1345-1370`
很值钱。

注释已经把整个失败链说透：

1. transport fetch 若看到 `403 insufficient_scope`
2. 就必须先标记 step-up pending
3. 否则 SDK 的 403 handler 会看到 `refresh_token`
4. 走 refresh
5. 返回看似还可继续的 auth 结果
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

## 6. `markStepUpPending()` 与 `tokens()` 再证明：repo 会主动关闭错误的 refresh path，逼系统走更强授权流

`src/services/mcp/auth.ts:1461-1470,1625-1690`
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

## 7. `performMCPOAuthFlow()` 与 step-up state persistence 再证明：更高授权拥有自己的跨流程连续性

`src/services/mcp/auth.ts:579-617,903-935,1884-1898`
很值钱。

这里 repo 明确：

1. re-auth 时可以保留 `stepUpScope` 与 `discoveryState`
2. 下一次 `performMCPOAuthFlow()` 开始前先读取 cached `stepUpScope`
3. 还会把 cached `resourceMetadataUrl` 一并带回
4. transport-attached provider 在收到更高 scope 后会把 `stepUpScope` 持久化

这说明更强授权不是：

`本次失败后，随手再来一轮普通登录`

而是：

`higher-authority request has its own continuation state`

这条证据非常关键。

因为它说明 repo 并不是在使用一个临时 UI patch。
它是在给更高 authority level 建一条正式的 continuation grammar：

1. 哪个 scope 正在 pending
2. 哪个 discovery / metadata state 要保留
3. 下一次 flow 应该以什么 stronger target 继续

如果 cleanup 线未来没有这种 grammar，
那它就仍然回答不了：

`旧 cleanup 对象当前即便还能用，哪些更强动作还必须重新拿到更高等级授权`

## 8. `client.ts` transport hook 与 `saveTokens()` 再证明：step-up 既是 live request gate，也是单独的完成路径

`src/services/mcp/client.ts:620-633,821-827`
很硬。

无论 SSE 还是 StreamableHTTP transport，
repo 都把：

`wrapFetchWithStepUpDetection(createFetchWithInit(), authProvider)`

挂在真实 fetch 最前线。

这说明 step-up 不是 auth.ts 自言自语，
而是 live transport semantics 的正式部分。

更值钱的是
`src/services/mcp/auth.ts:1704-1705`
在 `saveTokens()` 一开始就清掉：

`this._pendingStepUpScope = undefined`

这说明 step-up 不是无限 pending 的解释性标记。
它拥有自己的 completion condition：

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

## 9. 技术启示：Claude Code 连“fresh enough to use”和“authorized enough to escalate”都继续拆开

这组源码给出的技术启示至少有五条：

1. `403 insufficient_scope` 必须在 transport 前线被看作 authority-level signal，而不是普通失败
2. refresh 只能修 freshness，不能偷偷冒充 scope elevation
3. higher-authority intent 应该拥有跨 revoke / re-auth 的持续状态
4. live transport integration 比事后 UI 提示更接近真正的安全边界
5. higher-authority flow 也应该有明确的完成条件，而不是只留下 pending 影子

从源码设计思路看，
Claude Code 的先进性不在于“它会要求更多登录”，
而在于：

`它知道什么时候该阻止错误的低阶修复路径继续前进，并把系统逼向真正的更高授权门。`

## 10. 苏格拉底式自我反思：如果我把 `306` 写得更强，我会在哪些地方越级

可以先问五个问题：

1. 如果 fresh enough to use 已经足够，为什么 repo 还要在 transport 前线单独抓 `403 insufficient_scope`？
2. 如果 refresh 足够，为什么 `tokens()` 要在 `needsStepUp` 时故意省略 `refresh_token`？
3. 如果更高授权不需要单独连续性，为什么要跨 revocation 保留 `stepUpScope` 与 `discoveryState`？
4. 如果 step-up 只是 auth.ts 的内部实现，为什么 SSE / HTTP transport 都要统一挂接 detection wrapper？
5. 如果 higher-authority 已经自动成立，为什么 `saveTokens()` 还需要以清空 `_pendingStepUpScope` 作为独立完成点？

这些反问逼着我们承认：

`use-time revalidation`
只回答
`你现在还能不能用`

而
`step-up reauthorization`
真正回答的是：

`你现在即便能用，是否已经被授予足够高的 authority level 去做更强的事`

这也是本章最应该记住的压缩句：

`制度已经重新证明你能用，不等于制度已经重新证明你配升级动作等级。`
