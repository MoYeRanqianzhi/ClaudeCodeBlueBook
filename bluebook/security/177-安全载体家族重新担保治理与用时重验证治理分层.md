# 安全载体家族重新担保治理与用时重验证治理分层：为什么artifact-family cleanup reassurance-governor signer不能越级冒充artifact-family cleanup use-time revalidation-governor signer

## 1. 为什么在 `176` 之后还必须继续写 `177`

`176-安全载体家族重新投影治理与重新担保治理分层` 已经回答了：

`current truth` 即便已经被不同 surface 重新讲述，
也还要单独回答这些讲述里哪些现在配承载多强的正向 reassurance。

但如果继续往下追问，
还会碰到另一层同样容易被偷写的错觉：

`只要某个 surface 已经给出了足够正向的 reassurance，真正的 consumer 在实际使用那一刻就自动拥有了继续依赖这份 truth 的资格，不再需要 fresh re-check。`

Claude Code 当前源码同样不能支持这种更强说法。

因为继续看：

1. `src/tools/ReadMcpResourceTool/ReadMcpResourceTool.ts:80-100` 的 `client.type !== 'connected'` hard gate 与 `ensureConnectedClient(client)`
2. `src/tools/ListMcpResourcesTool/ListMcpResourcesTool.ts:79-92` 关于 `ensureConnectedClient` 的 fresh reconnect 注释与调用
3. `src/services/mcp/client.ts:1688-1705` 的 `ensureConnectedClient()`
4. `src/services/tools/toolExecution.ts:308-335` 的 `getMcpServerType()` / `getMcpServerBaseUrlFromToolName()`
5. `src/services/tools/toolExecution.ts:1599-1624` 的 `McpAuthError -> needs-auth` demotion

会发现 repo 已经清楚展示出：

1. `reassurance governance` 负责决定不同 surface 配说多强的正向话术
2. `use-time revalidation governance` 负责决定真正 consumer 在实际依赖之前，还必须重新拿到什么 fresh proof，才能把这份 reassurance 转成实际可用资格

也就是说：

`artifact-family cleanup reassurance-governor signer`

和

`artifact-family cleanup use-time revalidation-governor signer`

仍然不是一回事。

前者最多能说：

`当前有某种 surface 配给出多强的正向 reassurance。`

后者才配说：

`真正的 consumer 在实际调用这一刻，已经重新完成 fresh connection check / current capability check / current authorization check，可以把这份 reassurance 转成可依赖的 current-use truth。`

所以 `176` 之后必须继续补的一层就是：

`安全载体家族重新担保治理与用时重验证治理分层`

也就是：

`reassurance governor 决定正向话术强度；use-time revalidation governor 才决定真正使用时是否已经 fresh enough to rely。`

## 2. 先做两条谨慎声明

第一条：

`Claude Code 当前源码里并没有一个字面存在的类型叫 artifact-family cleanup use-time revalidation-governor signer。`

这里的 `artifact-family cleanup use-time revalidation-governor signer` 仍是研究命名。
它不是在声称 cleanup 线已经有一个未公开的 live gate manager，
而是在说：

1. repo 已经明确把 positive surface reassurance 与 real consumer use path 拆开
2. repo 已经明确要求 consumer 在真正依赖前重新检查 `connected` / current truth
3. repo 已经明确允许 runtime 把旧的 `connected` 立即降回 `needs-auth`

第二条：

这里的 `use-time revalidation`

不是 `162-安全载体家族运行时符合性与反漂移验证分层` 里的

`anti-drift verification`。

`162` 回答的是：

`系统未来若再分叉，谁会主动发现。`

而 `177` 回答的是：

`真正 consumer 在这次依赖发生的瞬间，谁会要求重新验真，而不是盲信刚才那句 reassurance。`

因此 `177` 不是在重复 `162`，
而是在更靠近 consumer edge 的位置，
继续把：

`positive current reassurance`

和

`fresh-at-use proof`

拆开。

## 3. 最短结论

Claude Code 当前源码至少给出了五类“reassurance-governor signer 仍不等于 use-time revalidation-governor signer”证据：

1. `ReadMcpResourceTool` 在真正读取资源前，既要求 `client.type === 'connected'`，又继续调用 `ensureConnectedClient(client)`；这说明 positive reassurance 不自动等于 read path can rely now
2. `ListMcpResourcesTool` 明确把 `ensureConnectedClient` 注释成 healthy 时 no-op、onclose 后 fresh reconnect；这说明 list path 也拒绝盲信旧 reassurance
3. `ensureConnectedClient()` 本身会 fresh `connectToServer()`，若结果不再是 `connected` 就直接抛出 `MCP server not connected`；这说明真正依赖前仍要重新验真
4. `toolExecution.ts` 的 `getMcpServerType()` / `getMcpServerBaseUrlFromToolName()` 只有在 current connection 仍是 `connected` 时才继续派生 execution context；这说明连辅助执行上下文也不盲信旧 reassurance
5. `toolExecution.ts` 在 `McpAuthError` 上会把原本 `connected` 的 client 即时降成 `needs-auth`；这说明 stale reassurance 会在真实使用的第一时间被撤销

因此这一章的最短结论是：

`reassurance governor 最多能说当前有某个 surface 配给出多强的正向 reassurance；use-time revalidation governor 才能说真正 consumer 在使用瞬间是否已经重新拿到 fresh enough 的 current-use proof。`

再压成一句：

`reassured，不等于 already revalidated for live use。`

## 4. 第一性原理：reassurance 回答“能放心到什么程度”，use-time revalidation 回答“真正依赖这一刻还能不能把刚才那句放心话继续当真”

从第一性原理看，
重新担保治理与用时重验证治理处理的是两个不同主权问题。

reassurance governor 回答的是：

1. 哪个 surface 现在配说正向话术
2. 这句正向话术允许多强
3. 是否必须保留 caveat
4. 是否宁可沉默也不发布正向信息
5. 当前 surface 的 reassurance ceiling 是什么

use-time revalidation governor 回答的则是：

1. 真正 consumer 在调用前是否还要 fresh reconnect
2. 当前 `connected` truth 是否要在 use-time 重新检查
3. capability / resources / transport 是否仍然 current
4. 如果刚才的 reassurance 已经过时，谁会在使用瞬间把它撤销
5. 哪些 positive surface 只是 local confidence，哪些能够通过 live gate 转成 actual reliance

如果把这两层压成一句“既然刚才已经说能用了”，
系统就会制造五类危险幻觉：

1. reassurance-means-usable-now illusion
   只要某个 surface 刚才说了正向话，就误以为真实 consumer 现在一定还能用
2. dialog-success-means-resource-readable illusion
   只要 reconnect dialog 成功，就误以为读资源、列资源和真实 tool execution 不必再做 fresh gate
3. connected-copy-means-fresh-proof illusion
   只要 health/menu 里还写着 `connected`，就误以为 current-use proof 仍然有效
4. positive-surface-speaks-for-consumer illusion
   只要某个 positive surface 成立，就误以为真正 consumer path 也会照单全收
5. reassurance-once-means-revalidation-forever illusion
   只要某次 reassurance 说得足够积极，就误以为后续使用都不需要再次验真

所以从第一性原理看：

`reassurance governance` 管的是正向信号强度；
`use-time revalidation governance` 管的是实际依赖发生前，旧 reassurance 是否仍配被当真。

用苏格拉底式反问再压一次：

1. 如果 `MCPReconnect` 已经说 `Successfully reconnected`，为什么 `ReadMcpResourceTool` 还要再次 `ensureConnectedClient(client)`？
   因为 operation-local reassurance 不拥有替真实 read path 免除 fresh proof 的资格。
2. 如果 `/mcp` 已经显示 `✓ Connected`，为什么 `toolExecution` 仍会在 `McpAuthError` 上立刻把它降回 `needs-auth`？
   因为 health reassurance 不是 immutable use authorization。
3. 如果 `McpAuthTool` 刚说 `should now be available`，为什么 list/read tool 仍会在真正调用时拒绝 non-connected client？
   因为 positive wording 只配描述 current expectation，不配越级免除 consumer-side live gate。

## 5. `ReadMcpResourceTool` 与 `ListMcpResourcesTool` 先证明：真实 consumer path 不信任刚才那句 reassurance，而信任此刻的 fresh truth

`ReadMcpResourceTool.ts:80-100` 很硬。

这里的逻辑是：

1. 先找到目标 server
2. 如果 `client.type !== 'connected'`，直接报错
3. 即便已经是 `connected`，仍继续 `ensureConnectedClient(client)`
4. 然后才真正发 `resources/read`

这说明 resource read consumer 明确拒绝把：

`surface 上一个正向 reassurance`

偷写成：

`actual read authorization right now`

`ListMcpResourcesTool.ts:79-92` 更值钱。

它不仅也调用 `ensureConnectedClient(client)`，
还在注释里写得非常直白：

1. healthy 时 `ensureConnectedClient` 是 no-op
2. after `onclose` it returns a fresh connection so the re-fetch succeeds

这条注释把 use-time revalidation 的本体直接说出来了：

`consumer surface 不是拿旧 reassurance 直接去用，而是在真正依赖前确认连接仍然 fresh。`

所以这两条 tool path 一起说明：

`reassurance can open expectation; it cannot waive live-use revalidation.`

## 6. `ensureConnectedClient()` 再证明：真正的 current-use proof 不是沿用旧 `connected`，而是 fresh connect 或失败

`client.ts:1688-1705` 特别值钱。

这里 `ensureConnectedClient()` 做的事情非常干净：

1. SDK client 直接返回
2. 非 SDK client 重新 `connectToServer(client.name, client.config)`
3. 若 fresh result 不再是 `connected`，直接抛出  
   `MCP server "<name>" is not connected`
4. 只有 fresh result 仍然成立时，才返回 connected client

这条证据很硬。

因为它说明 repo 对 current-use truth 的哲学不是：

`上一次看起来 connected，所以这次先信`

而是：

`真正依赖前，再问一次当前是否仍然 connected；如果不是，宁可失败，也不沿用旧 reassurance。`

这就是一条标准的 use-time revalidation grammar。

从技术角度看，
它比单纯的 surface caution 更先进。
因为它把：

`don't overpromise`

进一步推进成了：

`don't overconsume stale promises`

## 7. `toolExecution.ts` 再证明：执行平面不只在入场前重验证，还会在运行时即时撤销过期 reassurance

`services/tools/toolExecution.ts` 至少给出两组很硬的证据。

第一组是 `308-335`。

这里：

1. `getMcpServerType()` 只有在 `serverConnection?.type === 'connected'` 时才返回 transport type
2. `getMcpServerBaseUrlFromToolName()` 只有在 `serverConnection?.type === 'connected'` 时才返回 base URL

这说明连 execution metadata 都不接受 stale positive picture。

也就是说，
repo 连“给工具执行打上什么 transport / url 背景”这类辅助上下文，
都仍然要求 current connected truth。

第二组是 `1599-1624`。

这里一旦真正的 tool use 碰到 `McpAuthError`，
系统会：

1. 找到对应 client
2. 仅在它当前还是 `connected` 时
3. 立刻把它降成 `needs-auth`

这条证据非常关键。
因为它说明 use-time revalidation 不是一次 static gate，
而是：

`真正使用的那一刻，一旦旧 reassurance 被 live error 否定，系统会立即撤销它。`

换句话说，
`toolExecution` 公开承认：

`connected reassurance`

不是一个稳态王位，
而是一个随时可能被实际 usage proof 推翻的暂时结论。

## 8. 这层分化为什么先进：Claude Code 把“真正消费的资格”从“正向表述的资格”里单独剥出来了

这组源码真正先进的地方，
不是“它又多做了一次检查”，
而是它把：

`who may say a positive thing`

和

`who may actually spend that positive thing`

分开了。

至少有四条技术启示：

### 启示一

repo 拒绝让 positive surface 直接豁免 live gate。

也就是说，
它不接受：

`said usable once -> usable everywhere until disproved`

### 启示二

repo 把真正 consumer 设计成怀疑者，而不是文案的被动信徒。

真实 read/list/tool execution path 会再次确认 current truth，
而不是沿用上一个 surface 的安心话。

### 启示三

repo 把 runtime revocation 当成 consumer honesty 的一部分。

`McpAuthError -> needs-auth`

不是补救措施，
而是拒绝让 stale reassurance 继续冒充 live-use authorization。

### 启示四

repo 把“当前能描述”为“当前能花费”之前，
故意插入 fresh proof。

从安全哲学看，
这很重要。

因为系统真正危险的常常不是：

`有人说早了一句放心话`

而是：

`后续真实 consumer 把这句放心话当成免检通行证。`

Claude Code 在 MCP 线上公开拒绝了这一点。

## 9. 一条硬结论

这组源码真正说明的不是：

`cleanup 线未来只要补出 reassurance grammar，就已经足够成熟。`

而是：

`repo 已经在 ReadMcpResourceTool 与 ListMcpResourcesTool 的 consumer-side hard gate、ensureConnectedClient 的 fresh connection check，以及 toolExecution 的 current-context filter 与 McpAuthError demotion 上，明确展示了 use-time revalidation governance 的存在；因此 artifact-family cleanup reassurance-governor signer 仍不能越级冒充 artifact-family cleanup use-time revalidation-governor signer。`

因此：

`cleanup 线真正缺的，不只是“谁来决定现在可以放心到什么程度”，还包括“谁来决定真正消费这一刻，这份放心话是否仍配被当成可依赖的 current-use truth”。`
