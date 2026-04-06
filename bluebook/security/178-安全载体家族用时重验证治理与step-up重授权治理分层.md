# 安全载体家族用时重验证治理与step-up重授权治理分层：为什么artifact-family cleanup use-time revalidation-governor signer不能越级冒充artifact-family cleanup step-up reauthorization-governor signer

## 1. 为什么在 `177` 之后还必须继续写 `178`

`177-安全载体家族重新担保治理与用时重验证治理分层` 已经回答了：

`positive reassurance` 即便已经存在，
真正的 consumer 在实际依赖前仍要重新拿 fresh current-use proof。

但如果继续往下追问，
还会碰到另一层同样容易被偷写的错觉：

`只要真正 consumer 已经 fresh reconnect、已在 use-time 重新验证为 connected，它就自动拥有了执行任何更强请求的资格，不再需要更高等级的 reauthorization。`

Claude Code 当前源码同样不能支持这种更强说法。

因为继续看：

1. `src/services/mcp/auth.ts:1345-1370` 的 `wrapFetchWithStepUpDetection()`
2. `src/services/mcp/auth.ts:1461-1470,1625-1690` 的 `markStepUpPending()` 与 `tokens()`
3. `src/services/mcp/auth.ts:572-618,900-940,1848-1900` 的 step-up state 保留、cached step-up scope 复用与 `redirectToAuthorization()`
4. `src/services/mcp/client.ts:620-641,820-834` 的 transport fetch wrapper 挂接
5. `src/services/mcp/auth.ts:1220-1228,1345-1349` 的 `AUTHORIZED` / 403-upscoping 注释链

会发现 repo 已经清楚展示出：

1. `use-time revalidation governance` 负责决定真正 consumer 在依赖瞬间是否已经 fresh enough to use
2. `step-up reauthorization governance` 负责决定这份 fresh current-use proof 是否已经拥有足够高的 authority level / scope 去执行更强请求

也就是说：

`artifact-family cleanup use-time revalidation-governor signer`

和

`artifact-family cleanup step-up reauthorization-governor signer`

仍然不是一回事。

前者最多能说：

`这次依赖发生前，当前连接/当前对象/当前使用资格已经被 fresh re-check。`

后者才配说：

`这次 fresh current-use proof 对当前请求所需的 scope 也已经足够；如果 scope 不足，就必须进入更强的 step-up reauthorization path。`

所以 `177` 之后必须继续补的一层就是：

`安全载体家族用时重验证治理与step-up重授权治理分层`

也就是：

`use-time revalidation governor 决定当前是否 fresh enough to use；step-up reauthorization governor 才决定当前 authority level 是否足够支撑更强请求。`

## 2. 先做两条谨慎声明

第一条：

`Claude Code 当前源码里并没有一个字面存在的类型叫 artifact-family cleanup step-up reauthorization-governor signer。`

这里的 `artifact-family cleanup step-up reauthorization-governor signer` 仍是研究命名。
它不是在声称 cleanup 线已经有一个未公开的 scope-elevation manager，
而是在说：

1. repo 已经明确把 fresh use-time truth 与 stronger-scope truth 拆开
2. repo 已经明确把 `403 insufficient_scope` 从普通 refresh path 里单独分流出来
3. repo 已经明确承认 refresh 不能完成 scope elevation，因此更强请求必须进入 step-up reauthorization

第二条：

这里的 `step-up reauthorization`

不是 `173-安全载体家族连续性治理与恢复治理分层` 里的 recovery，
也不是 `177` 里的 live-use revalidation。

`173` 回答的是：

`旧线断裂后，什么新的凭据与新连接足以恢复 usable truth。`

`177` 回答的是：

`真正 consumer 在这次依赖发生时，是否已经重新拿到 fresh enough 的 current-use proof。`

而 `178` 回答的是：

`即便 current-use proof 已 fresh，它对当前请求所需的更高 authority level / scope 是否仍然不够，从而必须 step-up。`

因此 `178` 不是在重复前两层，
而是在更靠近“能力等级”与“授权强度”的位置，
继续把：

`fresh current use`

和

`scope-sufficient authority`

拆开。

## 3. 最短结论

Claude Code 当前源码至少给出了五类“use-time revalidation-governor signer 仍不等于 step-up reauthorization-governor signer”证据：

1. `wrapFetchWithStepUpDetection()` 会在 transport fetch 上先捕获 `403 insufficient_scope` 并标记 step-up pending，说明 fresh request path 也可能 authority level 不足
2. `auth.ts` 明确写出 RFC 6749 §6 不允许用 refresh 做 scope elevation，说明 fresh token 并不自动等于 stronger-scope token
3. `tokens()` 在 `needsStepUp` 时故意省略 `refresh_token`，迫使 SDK 落入 PKCE step-up flow，说明当前 proof fresh 也不等于 authority sufficient
4. `redirectToAuthorization()`、cached `stepUpScope` 与 `preserveStepUpState` 会把 step-up scope 跨 revoke / re-auth 保留下来，说明 stronger authority 需要单独的 continuation grammar
5. `client.ts` 在 SSE/HTTP transport 上都把 `wrapFetchWithStepUpDetection(createFetchWithInit(), authProvider)` 挂到真实 transport fetch 上，说明 step-up 不是抽象方针，而是 live transport path 的正式 gate

因此这一章的最短结论是：

`use-time revalidation governor 最多能说这次依赖前 fresh current-use proof 已经成立；step-up reauthorization governor 才能说这份 fresh proof 对当前请求所需的更高 scope / authority level 是否已经足够。`

再压成一句：

`fresh enough to use，不等于 authorized enough to upscope。`

## 4. 第一性原理：use-time revalidation 回答“此刻还能不能用”，step-up reauthorization 回答“此刻即便能用，是否有资格执行更强请求”

从第一性原理看，
用时重验证治理与 step-up 重授权治理处理的是两个不同主权问题。

use-time revalidation governor 回答的是：

1. 当前连接是否仍然 alive
2. 当前 capability 是否仍然 current
3. 当前 read/list/tool execution 是否仍可启动
4. stale reassurance 是否应在第一时间撤销
5. 真实 consumer 在依赖前是否已拿到 fresh proof

step-up reauthorization governor 回答的则是：

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
   因为 `AUTHORIZED` 不是无条件等于 requested-scope authorized。

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

`refresh path must be disabled when the problem is insufficient_scope.`

从源码注释可知，
原因并不暧昧：

scope elevation 不是 refresh 能解决的事。

所以这里最值钱的技术启示是：

`freshness repair should never impersonate authority elevation.`

换句话说，
`use-time revalidation` 至多把系统拉回：

`still connected / still current`

而 `step-up reauthorization` 才回答：

`now sufficiently authorized for this stronger request`

## 7. `performMCPOAuthFlow()`、`redirectToAuthorization()` 与 step-up state persistence 再证明：更强授权拥有自己的 continuation grammar

`auth.ts:572-618,900-940,1848-1900` 一起看非常值钱。

这里 repo 做了三件很成熟的事：

1. 在 revoke / re-auth 时保留 `stepUpScope` 与 `discoveryState`
2. 在下一次 `performMCPOAuthFlow()` 开始前先读 cached `stepUpScope`
3. 在 `redirectToAuthorization()` 里把新的 scope 从 URL 或 metadata 里提取出来，并持久化 step-up scope

这说明更强授权并不是：

`fresh use path 失败了，临时弹个浏览器，再碰碰运气`

而是：

`higher-authority request has its own stateful continuation protocol`

这条证据很硬。

因为它说明 repo 公开接受：

`step-up` 不是普通错误恢复，
而是高一级 authority negotiation。

如果 cleanup 线未来没有这类 grammar，
那它就仍然回答不了：

`真正 consumer 已经 fresh enough 之后，哪些更强请求还必须重新拿更高等级的授权。`

## 8. `client.ts` transport hook 再证明：step-up 不是原则口号，而是 live transport path 上的正式 gate

`client.ts:620-641,820-834` 很值钱。

这里无论 SSE 还是 StreamableHTTP transport，
repo 都不是简单把 `authProvider` 丢给 transport，
而是明确包了一层：

`wrapFetchWithStepUpDetection(createFetchWithInit(), authProvider)`

再交给 timeout wrapper。

这说明：

1. step-up detection 不是边缘补丁
2. 它在 transport fetch 的 innermost path 上运行
3. 它必须早于 SDK 的 auth handler
4. 它是 current request semantics 的正式组成部分

从设计思路看，
这很先进。

因为它把：

`scope insufficiency`

的识别放在了最接近 real server response 的地方，
避免上层 later-stage abstraction 把它误压成 generic auth refresh。

## 9. 这层分化为什么先进：Claude Code 把“还能用”和“配不配更强地用”拆成两套不同控制语法

这组源码真正先进的地方，
不是“它支持 step-up”，
而是它拒绝把：

`fresh current use`

和

`stronger authority level`

混成一层。

至少有四条技术启示：

### 启示一

repo 拒绝让 refresh path 越级冒充 scope elevation path。

### 启示二

repo 把 `insufficient_scope` 当成 authority-level truth，
而不是 freshness-level truth。

### 启示三

repo 给更强授权单独建立了 stateful continuation grammar，
包括 pending scope、cached discovery state 与 next-flow reuse。

### 启示四

repo 把 step-up detection 放进真实 transport path，
让 higher-authority negotiation 成为 live request control plane 的一部分。

从哲学上看，
这回应了一个非常深的安全原则：

`系统真正危险的，不只是把过期能力当成还活着，更是把低等级能力当成足够高等级。`

Claude Code 在 MCP 线上公开拒绝了这件事。

## 10. 一条硬结论

这组源码真正说明的不是：

`cleanup 线未来只要补出 use-time revalidation grammar，就已经足够成熟。`

而是：

`repo 已经在 wrapFetchWithStepUpDetection 的 403 insufficient_scope detection、tokens() 的 refresh-token suppression、performMCPOAuthFlow 的 cached step-up scope continuation，以及 client transport 的 live fetch hook 上，明确展示了 step-up reauthorization governance 的存在；因此 artifact-family cleanup use-time revalidation-governor signer 仍不能越级冒充 artifact-family cleanup step-up reauthorization-governor signer。`

因此：

`cleanup 线真正缺的，不只是“谁来决定现在还能不能用”，还包括“谁来决定现在即便能用，是否已经拥有足够高的 authority level 去执行更强请求”。`
