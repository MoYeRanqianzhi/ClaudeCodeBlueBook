# 安全载体家族强请求清理用时重验证治理与强请求清理step-up重授权治理分层：为什么artifact-family cleanup stronger-request cleanup-use-time revalidation-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer

## 1. 为什么在 `273` 之后还必须继续写 `274`

`273-安全载体家族强请求清理重新担保治理与强请求清理用时重验证治理分层`
已经回答了：

`stronger-request cleanup 线即便已经让某个 surface 给出足够正向的 reassurance，也还要单独回答真正 consumer 在 live use 瞬间是否已经重新拿到 fresh enough 的 current-use proof。`

但如果继续往下追问，
还会碰到另一层同样容易被偷写成
“既然这次 live use 已经 fresh enough，那么任何更强请求当然都应该被允许”
的错觉：

`只要 stronger-request cleanup use-time revalidation governor 已经确认当前 consumer 在使用瞬间 fresh enough to use，它就自动拥有了决定当前 authority level 是否也足够支撑更强请求的主权，不再需要更高等级的 step-up 重授权。`

Claude Code 当前源码同样不能支持这种更强说法。

因为继续看：

1. `src/services/mcp/auth.ts:1345-1370`
   的 `wrapFetchWithStepUpDetection()`
2. `src/services/mcp/auth.ts:1468-1470,1625-1690`
   的 `markStepUpPending()` 与 `tokens()`
3. `src/services/mcp/auth.ts:579-618,909-940,1887-1900`
   的 step-up state 保留、cached step-up scope 复用与 scope persistence
4. `src/services/mcp/client.ts:620-641,820-834`
   的 transport fetch wrapper 挂接
5. `src/services/mcp/auth.ts:1345-1354,1625-1690`
   的 403-upscoping 注释链与 refresh suppression

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

`这次依赖发生前，当前连接/当前对象/当前使用资格已经被 fresh re-check。`

后者才配说：

`这次 fresh current-use proof 对当前请求所需的更高 scope / authority level 也已经足够；如果 scope 不足，就必须进入更强的 step-up reauthorization path。`

所以 `273` 之后必须继续补的一层就是：

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
不是前面的 recovery，也不是 `273` 里的 live-use revalidation。

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
4. cached `stepUpScope` 与 persistence 路径会把 stronger-scope intent 跨 revoke / re-auth 保留下来，说明更强 authority 需要单独的 continuation grammar
5. `client.ts` 在 SSE/HTTP transport 上都把 `wrapFetchWithStepUpDetection(createFetchWithInit(), authProvider)` 挂到真实 transport fetch 上，说明 step-up 不是抽象方针，而是 live transport path 的正式 gate

因此这一章的最短结论是：

`stronger-request cleanup use-time revalidation governor 最多能说这次依赖前 fresh current-use proof 已经成立；stronger-request cleanup step-up reauthorization governor 才能说这份 fresh proof 对当前请求所需的更高 scope / authority level 是否已经足够。`

再压成一句：

`fresh enough to use，不等于 authorized enough to upscope。`

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

如果把这两层压成一句
“既然这次已经 fresh 了”，
系统就会制造五类危险幻觉：

1. `fresh-means-sufficient`
2. `connected-means-upscoped`
3. `refresh-means-elevation`
4. `authorized-once-means-authorized-higher`
5. `live-use-means-no-step-up`

再用苏格拉底式反问压一次：

1. 如果这次 `ensureConnectedClient()` 已经成功，为什么还会出现 `insufficient_scope`？
   因为 fresh connection 只回答“现在还能连”，不回答“现在的 scope 是否足够强”。
2. 如果 token refresh 已经能拿到新 token，为什么源码还要强行跳过 refresh、转 PKCE step-up？
   因为 refresh 只能更新 freshness，不能提升 authority level。
3. 如果 auth flow 最终能得到可用 token，为什么源码仍怕它在 403-upscoping 场景下重复失败？
   因为 nominally usable token 不是无条件等于 requested-scope authorized。

## 5. 技术机制剖面：Claude Code 的多重安全机制为什么能证明“step-up 重授权治理”是一层独立制度

### 5.1 `wrapFetchWithStepUpDetection()` 先证明：真正的 live request path 里，fresh current use 与 stronger-scope use 仍是两层

`src/services/mcp/auth.ts:1345-1370`
很值钱。

这里的注释直接解释了一个很深的语义问题：

1. 当 transport fetch 收到 `403 insufficient_scope`
2. 如果不先标记 step-up pending
3. SDK 的 authInternal 会看见 `refresh_token`
4. 然后走 refresh
5. 返回“可继续”的 auth 状态
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

### 5.2 `tokens()` 与 `markStepUpPending()` 再证明：源码明确拒绝把 refresh 冒充成 scope elevation

`src/services/mcp/auth.ts:1468-1470,1625-1690`
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

所以这里最值钱的技术启示是：

`freshness repair should never impersonate authority elevation`

### 5.3 `performMCPOAuthFlow()` 与 step-up state persistence 再证明：更强授权拥有自己的 continuation grammar

`src/services/mcp/auth.ts:579-618,909-940,1887-1900`
一起看非常值钱。

这里 repo 做了三件很成熟的事：

1. 在 revoke / re-auth 时保留 `stepUpScope` 与 `discoveryState`
2. 在下一次 `performMCPOAuthFlow()` 开始前先读 cached `stepUpScope`
3. 在更高权限 flow 完成后继续把 stronger scope 写回持久状态

这说明更强授权并不是：

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

### 5.4 `client.ts` transport hook 再证明：step-up 不是 auth.ts 自言自语，而是 live transport path 的硬门

`src/services/mcp/client.ts:620-641,820-834`
很硬。

无论 SSE 还是 StreamableHTTP transport，
repo 都显式把：

`wrapFetchWithStepUpDetection(createFetchWithInit(), authProvider)`

包进真实 transport fetch。

而且注释明确强调：

`Step-up detection wraps innermost so the 403 is seen before the SDK's handler calls auth() -> tokens().`

这条证据很值钱。

因为它说明 step-up 不是留给上层解释层的概念，
而是 transport 层当前 request semantics 的一部分。

也就是说，
repo 已经公开承认：

`更强授权门不是事后故事，而是 live request gate`

## 6. 安全设计的哲学本质：Claude Code 在这里保护的不是“能不能继续用”，而是“能不能以更强资格继续用”

这组源码在哲学上最值钱的地方，
不是它能检测 `insufficient_scope`，
而是它拒绝把：

`当前还能用`

偷写成：

`当前也配执行更强动作`

从第一性原理看，
它保护的是四件更根本的东西：

1. freshness 不等于 authority
2. refresh 不等于 elevation
3. usable 不等于 upscoped
4. 更高权限请求拥有自己的独立门槛

这意味着 Claude Code 的先进性不只在于
“它会在 live use 前做重验证”，
而在于
“它知道通过重验证之后，仍然可能不配执行更强请求”。

真正成熟的安全系统，
不只问：

`它现在能不能继续用`

还问：

`它现在即便能继续用，配不配以更高等级继续用`

## 7. 苏格拉底式自校：如果把 step-up 说早了，会在哪些地方立即露馅

可以用五个问题反过来检查自己有没有把 step-up 说早：

1. 如果 fresh current-use proof 已经等于 stronger authorization，
   那么 `wrapFetchWithStepUpDetection()` 为什么还要单独抓 `403 insufficient_scope`？
2. 如果 refresh 已经足够，
   那么 `tokens()` 为什么要故意省略 `refresh_token`？
3. 如果上一次的 auth state 已经够强，
   那么 `stepUpScope` 为什么还要被单独保留并跨流程传播？
4. 如果 transport 只需要 live use truth，
   那么 SSE/HTTP fetch 为什么还要显式挂接 step-up detection wrapper？
5. 如果“能用”已经等于“有资格更强地用”，
   那么源码为什么还要把 freshness path 与 higher-authority path 分成两套门？

只要这五个问题里任何一个答不上来，
就说明自己已经把：

`use-time-revalidated truth`

越级偷写成了：

`step-up-authorized truth`

## 8. 一条硬结论

这一层真正说明的不是：

`cleanup 线未来只要补出 live-use revalidation grammar，就已经足够成熟。`

而是：

`repo 已经在 wrapFetchWithStepUpDetection() 的 `403 insufficient_scope` detection、tokens() 的 refresh suppression、step-up scope 的跨流程 persistence，以及 transport fetch hook 的 live integration 上，明确展示了 step-up reauthorization governance 的存在；因此 artifact-family cleanup stronger-request cleanup-use-time revalidation-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-step-up reauthorization-governor signer。`

因此：

`stronger-request cleanup 线真正缺的，不只是“谁来决定现在还能不能用”，还包括“谁来决定现在即便能用，是否已经被授权到足以执行更强请求”。`
