# 安全载体家族step-up重授权治理与强请求续打治理分层：为什么artifact-family cleanup step-up reauthorization-governor signer不能越级冒充artifact-family cleanup stronger-request continuation-governor signer

## 1. 为什么在 `178` 之后还必须继续写 `179`

`178-安全载体家族用时重验证治理与step-up重授权治理分层` 已经回答了：

`fresh current-use proof` 即便已经成立，
也还不能自动回答当前更强请求所需的 scope / authority level 是否已经足够。

但如果继续往下追问，
还会碰到另一层同样容易被偷写的错觉：

`只要 step-up 已经成功、连接已经重新建立、工具已经重新可见，先前那个被挡下来的更强请求就自动拥有了合法的续打/重放资格。`

Claude Code 当前源码同样不能支持这种更强说法。

因为继续看：

1. `src/services/mcp/client.ts:2813-3024` 的 `callMCPToolWithUrlElicitationRetry()`
2. `src/services/tools/toolExecution.ts:586-606,1068-1105` 的 `then retry this call` 与 `You may retry it if you would like`
3. `src/tools/McpAuthTool/McpAuthTool.ts:126-205` 的 OAuth 完成后 reconnect / swap real tools path
4. `src/components/mcp/MCPRemoteServerMenu.tsx:258-292` 与 `src/components/mcp/MCPAgentServerMenu.tsx:60-77` 的 auth success copy
5. `src/cli/print.ts:3310-3508` 的 `mcp_authenticate` / `mcp_oauth_callback_url` control choreography

会发现 repo 已经清楚展示出：

1. `step-up reauthorization governance` 负责决定当前 principal 是否已经拿到执行更强请求所需的更高 authority level
2. `stronger-request continuation governance` 负责决定先前那个被挡下来的更强请求，是否仍应被视为“同一个 request”的合法续打，以及应由谁、在什么条件下、以什么预算继续它

也就是说：

`artifact-family cleanup step-up reauthorization-governor signer`

和

`artifact-family cleanup stronger-request continuation-governor signer`

仍然不是一回事。

前者最多能说：

`当前主体现在已经被授权到足以尝试更强动作。`

后者才配说：

`先前那个被挡下来的更强动作，现在仍配以同一请求的名义继续；它的因果链、重试预算、用户/钩子同意与下一步动作都已经被正式签字。`

所以 `178` 之后必须继续补的一层就是：

`安全载体家族step-up重授权治理与强请求续打治理分层`

也就是：

`step-up reauthorization governor 决定 authority level 是否已经升够；stronger-request continuation governor 才决定那个先前被挡下来的 stronger request 是否配被当成同一请求继续。`

## 2. 先做三条谨慎声明

第一条：

`Claude Code 当前源码里并没有一个字面存在的类型叫 artifact-family cleanup stronger-request continuation-governor signer。`

这里的 `artifact-family cleanup stronger-request continuation-governor signer` 仍是研究命名。
它不是在声称 cleanup 线已经有一个未公开的 request replay manager，
而是在说：

1. repo 已经在别的路径里明确展示了 continuation / retry grammar 的存在
2. repo 已经把“auth 成功”与“原请求继续”写成不同强度的语句
3. cleanup 线未来若只补 step-up，而不补 continuation grammar，仍会留下“谁来为旧强请求续打签字”的缺口

第二条：

这里的 `stronger-request continuation`

不是在声称 repo 全局都必须自动 replay。

它回答的只是：

`当一个更强请求先前被挡下后，系统是否显式保留了“还是这个请求”“由谁批准继续”“何时继续”“最多重试几次”“用户/钩子是否还要再同意”的 control grammar。`

换句话说，
`continuation governance` 可以表现成自动 retry、hook-mediated retry、user-mediated retry，
也可以表现成明确拒绝自动继续。
关键不在于“是否自动”，
而在于“是否正式签字 old blocked request 该怎样继续”。

第三条：

这里必须把：

`transport-local retry`

和

`user-visible / policy-rich continuation governance`

分开。

`auth.ts:1345-1349` 的注释已经说明 SDK 在坏路径里会经历

`AUTHORIZED -> retry -> 403 again`

这种局部 retry 现象。

但那只说明某条 transport/auth 实现里存在局部重试，
不等于系统已经明确回答：

`原来那条被挡下的 stronger request 现在是否应该继续、由谁批准继续、以及继续后如何向用户/上层报告。`

`179` 研究的是后者。

## 3. 最短结论

Claude Code 当前源码至少给出了五类“step-up reauthorization-governor signer 仍不等于 stronger-request continuation-governor signer”证据：

1. `callMCPToolWithUrlElicitationRetry()` 只有在 specific error、specific user/hook result 与 bounded retry budget 同时成立时，才会显式 `retrying tool call`；这说明 continuation grammar 需要单独签字
2. `toolExecution.ts` 明确把 continuation 说成 `then retry this call` 与 `You may retry it if you would like`；这说明“谁来继续原调用”不是被别的 success 语义自动涵盖
3. `McpAuthTool` 在 OAuth 成功后做的是 reconnect 与 real tools/resources 回填，话术是 `will become available automatically` / `should now be available`；这说明 auth success 主要签 availability，不签 old blocked stronger request replay
4. `MCPRemoteServerMenu` 与 `print.ts` 在 auth success 后主要签 connected / reconnected / auth completed / requiresUserAction=false 等状态更新；这仍不是“原 stronger request 现在已被当作同一请求继续”
5. `MCPAgentServerMenu` 甚至直接写 `The server will connect when the agent runs.`；这说明 auth success 也可以只签 future readiness，而完全不签 immediate continuation

因此这一章的最短结论是：

`step-up reauthorization governor 最多能说当前主体现在已经配尝试更强动作；stronger-request continuation governor 才能说先前那个被挡下来的 stronger request 是否仍配被当成同一请求继续，以及这次继续的 trigger / budget / consent / causal linkage 是什么。`

再压成一句：

`authorized enough for a stronger action，不等于 the original stronger request has now been legitimately continued。`

## 4. 第一性原理：step-up reauthorization 回答“你现在够不够格”，stronger-request continuation 回答“刚才那条被挡下的强请求现在还该不该继续算同一条”

从第一性原理看，
step-up 重授权治理与强请求续打治理处理的是两个不同主权问题。

step-up reauthorization governor 回答的是：

1. 当前 token / principal 的 authority level 是否足够高
2. 当前问题是 freshness 还是 insufficient scope
3. refresh path 是否必须被禁止
4. 哪些 stronger scope state 要跨 revoke / re-auth 保留
5. 什么时候才配说“现在已经 upscoped enough to attempt”

stronger-request continuation governor 回答的则是：

1. 先前那个被挡下的 stronger request 现在还是否应被视为同一请求
2. 它的原 args / meta / intent / context 是否仍有效
3. 这次继续是自动、hook-mediated、user-mediated，还是必须重新发起
4. retry budget / attempt count / abort semantics 是什么
5. 继续后应该报告“已续打”“可续打”还是“只是在 future run 中重新可用”

如果把这两层压成一句“既然 auth 已经成功”，
系统就会制造五类危险幻觉：

1. reauthorized-means-replayed illusion
   只要更高 authority 已取得，就误以为原 stronger request 已自动续打
2. tools-available-means-old-call-completed illusion
   只要工具重新可见，就误以为先前被挡下的调用已经被代表性完成
3. reconnect-success-means-causal-link-preserved illusion
   只要 reconnect 成功，就误以为旧 request 的因果链仍然完好无损
4. higher-authority-means-retry-budget-approved illusion
   只要 scope 已升够，就误以为 retry 次数、重试方式与 consent 也一并被批准
5. auth-done-means-same-request-done illusion
   只要 auth flow 结束，就误以为“同一请求继续/完成”的问题已经自然消失

所以从第一性原理看：

`step-up reauthorization governance` 管的是 authority sufficiency；
`stronger-request continuation governance` 管的是 interrupted stronger request 的 causal continuity。

再用苏格拉底式反问压一次：

1. 如果 step-up success 已经等于原 stronger request 合法续打，为什么 `callMCPToolWithUrlElicitationRetry()` 还要单独维护 retry loop、retry budget 与 `retrying tool call` 文案？
   因为 authority success 不自动回答“是不是这同一条调用继续”。
2. 如果工具 `should now be available` 已经等于原请求继续成功，为什么 `toolExecution.ts` 还要再明确说 `then retry this call` 或 `You may retry it if you would like`？
   因为 availability truth 不拥有替 old call continuation 签字的资格。
3. 如果 auth 完成已经自动恢复原 stronger request，为什么 `MCPAgentServerMenu` 还会说 `The server will connect when the agent runs`？
   因为 auth success 可以只签 future readiness，而不签 immediate same-request continuation。

## 5. `callMCPToolWithUrlElicitationRetry()` 与 `toolExecution.ts` 先证明：真正的 continuation grammar 必须显式写出谁、何时、以什么预算继续原调用

`client.ts:2813-3024` 很硬。

`callMCPToolWithUrlElicitationRetry()` 做的不是泛泛地说：

`条件好了以后可以再试试。`

它做的是一套相当正式的 continuation grammar：

1. 只在 `ErrorCode.UrlElicitationRequired` 上进入续打路径
2. 只允许最多 `3` 次 retry
3. 先跑 hooks，再决定是否需要 UI / structuredIO / queue
4. 只有 `accept` / `retry` 语义成立时，才进入下一轮 tool call
5. 日志里明确写 `Elicitation ... completed, retrying tool call`

这条路径很值钱。

因为它公开展示了 continuation governor 真正要回答的东西：

1. 这是哪一类中断
2. 谁能解除这类中断
3. 解除后是否还是同一条调用继续
4. 最多允许继续几次
5. 用户/钩子拒绝时要怎样优雅落地

`toolExecution.ts:586-606,1068-1105` 再给出第二组强证据。

这里 repo 明确出现了两类 continuation 话术：

1. deferred tool discovery 路径上的  
   `Load the tool first ... then retry this call.`
2. PermissionDenied hook 解封后的  
   `You may retry it if you would like.`

这两句的共同点非常关键：

它们都没有把“前一个阻塞条件已经解除”偷写成“原请求已经自然继续”，
而是继续保留：

`retry this call`

这层单独语义。

所以这组正对照说明：

当 repo 真要为 old request continuation 签字时，
它会把：

`same call`

`retry trigger`

`retry actor`

`retry wording`

写得很清楚。

## 6. `McpAuthTool`、`MCPRemoteServerMenu`、`MCPAgentServerMenu` 与 `print.ts` 再证明：auth success 主要签恢复可用，不签旧 stronger request 的同一请求续打

`McpAuthTool.ts:126-205` 很值钱。

这里 OAuth 成功后的 background continuation 做了三件事：

1. `clearMcpAuthCache()`
2. `reconnectMcpServerImpl()`
3. 把 real tools / commands / resources swap 回 app state

而它对外说的话是：

1. `the server's tools will become available automatically`
2. `The server's tools should now be available`

这说明它签的是：

`capability availability after auth`

而不是：

`the original blocked stronger request has now been replayed as the same request`

`MCPRemoteServerMenu.tsx:258-292` 同样很值钱。

这里成功文案是：

1. `Authentication successful. Connected ...`
2. `Authentication successful. Reconnected ...`
3. 失败时则保留 `may need to manually restart Claude Code`

这说明这条 path 在语义上回答的是：

`auth/reconnect result`

而不是：

`old blocked request continuation result`

`print.ts:3310-3508` 更能说明问题。

`mcp_authenticate` 与 `mcp_oauth_callback_url` 做的是：

1. 返回 auth URL / `requiresUserAction`
2. 等待 callback / auth promise
3. auth 完成后 reconnect server
4. 更新 `appState` / `dynamicMcpState`

这里有 auth completion、
也有 reconnect、
也有工具重新注册，
但仍没有任何一句在正式签：

`the previously blocked stronger request is now resumed as the same request`

`MCPAgentServerMenu.tsx:60-77` 最硬。

它在 auth success 后直接说：

`Authentication successful for <server>. The server will connect when the agent runs.`

这句话几乎是反向证据。

因为它公开承认：

`auth success`

甚至可以只意味着：

`future run readiness`

而不是任何当前请求级 continuation。

所以这几条 auth path 一起说明：

`step-up success` 最多把世界推进到
`now stronger capability can become available / can reconnect / can be used later`，

但它并不自动签出

`the old blocked stronger request is now legitimately continued as the same request`。

## 7. 为什么这层比 `178` 更强：`178` 只拆开“够不够格”，`179` 继续拆开“旧请求还算不算同一条合法续打”

`178` 已经回答：

`fresh enough to use`

不等于

`authorized enough to upscope`

但 `179` 继续追问的是：

`即便现在已经 authorized enough to upscope，先前那个被挡下的 stronger request 是否仍然配被当作同一请求继续？`

这是更强的一层，
因为它要求的不只是 authority semantics，
还要求：

1. request identity semantics
2. retry budget semantics
3. user/hook consent semantics
4. causal-link preservation semantics
5. same-call / future-run distinction

repo 当前的技术启示非常明确：

1. 更高授权成功，不应 silently auto-replay 一个旧强请求，尤其当这个请求可能带副作用时
2. 如果系统真想支持 stronger-request continuation，就应像 `callMCPToolWithUrlElicitationRetry()` 那样显式记录 trigger、attempt、consent 与 retry wording
3. auth/reconnect/restoration path 应继续只签“能力现在是否回来”，不要越级替 old request continuation 签字

这也是 cleanup 线很值得学的一点：

未来即便补出了更强清理授权，
也不能因此偷偷推导出：

`旧 destructive cleanup request 现在就该自动续打`

它还必须单独回答：

1. 还是不是原来那条 request
2. 原参数、原对象、原时间条件是否仍有效
3. 需不需要重新征求 consent
4. 需不需要新的 retry budget / receipt / continuation record

## 8. 一条硬结论

这组源码真正说明的不是：

`只要 repo 已经有 step-up reauthorization，就等于它也已经解决了原 stronger request 的 continuation question。`

而是：

`repo 已经在 callMCPToolWithUrlElicitationRetry() 的 bounded retry grammar、toolExecution.ts 的 retry wording、以及 McpAuthTool / MCPRemoteServerMenu / MCPAgentServerMenu / print.ts 的 auth-success restoration wording 之间，清楚展示了 step-up reauthorization governance 与 stronger-request continuation governance 的分层；因此 artifact-family cleanup step-up reauthorization-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request continuation-governor signer。`

因此：

`cleanup 线真正缺的，不只是“谁来决定现在是否已经被授权到可以做更强动作”，还包括“谁来决定先前那条被挡下的更强动作现在是否仍配以同一请求的名义继续，以及这次继续到底该怎样被正式签字”。`
