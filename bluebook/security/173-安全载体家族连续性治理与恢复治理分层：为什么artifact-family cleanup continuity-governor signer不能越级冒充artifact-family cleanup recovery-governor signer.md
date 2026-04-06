# 安全载体家族连续性治理与恢复治理分层：为什么artifact-family cleanup continuity-governor signer不能越级冒充artifact-family cleanup recovery-governor signer

## 1. 为什么在 `172` 之后还必须继续写 `173`

`172-安全载体家族就绪治理与连续性治理分层` 已经回答了：

`现在 ready，不等于这种可用性会在时间里继续成立。`

但如果继续往下追问，
还会碰到另一层同样容易被偷写的错觉：

`只要系统已经开始重试、已经给出 auth URL、已经收到 OAuth callback，或者已经重新跑了一次 reconnect，它就自动拥有了宣布对象“已经恢复”的主权。`

Claude Code 当前源码同样不能支持这种更强说法。

因为继续看：

1. `src/services/mcp/client.ts:1079-1137,2301-2334` 的 `UnauthorizedError -> needs-auth`、auth cache 与 `createMcpAuthTool()` fallback
2. `src/services/mcp/client.ts:2137-2163` 的 `reconnectMcpServerImpl()`：`clearKeychainCache()`、`clearServerCache()` 与 only-`connected` recovery result
3. `src/services/mcp/auth.ts:578-616,930-1040,1581-1614,1755-1778` 的 `performMCPOAuthFlow()`、step-up state 保留、silent re-auth 与 interactive re-auth fallback
4. `src/cli/print.ts:3133-3204,3206-3295` 的 `mcp_reconnect` / `mcp_toggle`
5. `src/cli/print.ts:3310-3455,3463-3505` 的 `mcp_authenticate`、`mcp_oauth_callback_url` 与 “auth done != reconnect done” control flow
6. `src/tools/McpAuthTool/McpAuthTool.ts:37-47,115-165` 与 `src/components/mcp/MCPReconnect.tsx:30-63` 的 pseudo-tool / UI recovery grammar

会发现 repo 已经清楚展示出：

1. `continuity governance` 负责决定断掉之后还要不要继续维持、重试、等待或放弃
2. `recovery governance` 负责决定什么新的凭据、新的回调、新的连接结果与新的工具集，才配重新签出 restored usable truth

也就是说：

`artifact-family cleanup continuity-governor signer`

和

`artifact-family cleanup recovery-governor signer`

仍然不是一回事。

前者最多能说：

`这条可用性时间线现在还要不要继续抢救。`

后者才配说：

`抢救之后，或者 continuity 已断裂之后，现在到底有没有足够新的证据正式宣布对象已经恢复。`

所以 `172` 之后必须继续补的一层就是：

`安全载体家族连续性治理与恢复治理分层`

也就是：

`continuity governor 决定要不要继续维持旧的可用性线；recovery governor 才决定什么新的证据足以重新签出 recovered truth。`

## 2. 先做一条谨慎声明：`artifact-family cleanup recovery-governor signer` 仍是研究命名，不是源码现成类型

这里同样要先讲清楚：

`Claude Code 当前源码里并没有一个字面存在的类型叫 artifact-family cleanup recovery-governor signer。`

这里的 `artifact-family cleanup recovery-governor signer` 仍是研究命名。
它不是在声称 cleanup 线已经有一个未公开的 recovery manager，
而是在说：

1. repo 已经把 `needs-auth`、`failed`、`pending` 与 `connected` 拆开
2. repo 已经把 `auth started`、`callback arrived`、`reconnect returned connected` 与 `tools swapped back in` 拆成不同阶段
3. repo 已经拒绝让 “正在恢复” 自动篡位成 “恢复完成”

因此 `173` 不是在虚构已有实现，
而是在给更深一层缺口命名：

`还在恢复，不等于已经恢复。`

## 3. 最短结论

Claude Code 当前源码至少给出了五类“continuity-governor signer 仍不等于 recovery-governor signer”证据：

1. `handleRemoteAuthFailure()` 与 auth cache 会把 401 落成 `needs-auth`，并改为暴露 `McpAuthTool`；这说明 continuity 中断后，系统不会假装 recovered truth 仍在
2. `reconnectMcpServerImpl()` 会先清 keychain cache 和 connection cache，再重新 `connectToServer()`；只有 `client.type === 'connected'` 才继续抓 tools/commands/resources，这说明 recovery 需要 fresh evidence，而不是旧 continuity 的延长
3. `mcp_reconnect` / `mcp_toggle` 只有在 reconnect result 真的是 `connected` 时才返回 success；这说明手工重试不等于恢复 verdict
4. `mcp_authenticate` 与 `mcp_oauth_callback_url` 把 `auth url ready`、`auth promise done` 与 `reconnect complete` 拆开；这说明 auth 完成不等于 recovery 完成
5. `McpAuthTool` 与 `MCPReconnect` 只在 reconnect 真正返回 `connected` 后才把 real tools 或 success message 交还给用户；这说明 consumer surface 也拒绝偷签 recovery truth

因此这一章的最短结论是：

`continuity governor 最多能说旧的可用性线还要不要继续维持；recovery governor 才能说新的凭据与新的连接结果是否已经足以重新建立 usable truth。`

再压成一句：

`trying to recover，不等于 recovered。`

## 4. 第一性原理：continuity governance 回答“旧线还要不要继续”，recovery governance 回答“什么新的证据足以重新成立”

从第一性原理看，
连续性治理与恢复治理处理的是两个不同主权问题。

continuity governor 回答的是：

1. transport 断掉之后还要不要继续重连
2. `pending` 还要维持多久
3. 什么时候从 retry 转成 give-up
4. `needs-auth` 或 `failed` 之后还要不要继续等待旧线自己恢复
5. 哪些 stale continuity attempt 必须被停掉

recovery governor 回答的则是：

1. 什么新的 credential proof 算足够
2. 什么新的 callback / code / token exchange 算完成
3. 什么新的 `connectToServer()` 结果算恢复成立
4. 什么时候 real tools、commands、resources 才能重新回到 current world
5. 哪些 surface 配宣布 “recovered”，哪些只配说 “still needs auth / still failed”

如果把这两层压成一句“反正系统已经开始恢复”，
系统就会制造五类危险幻觉：

1. retry-means-recovered illusion
   只要系统还在试，就误以为恢复已经成立
2. auth-url-means-recovered illusion
   只要已经拿到 auth URL，就误以为对象马上算 recovered
3. callback-means-recovered illusion
   只要 callback 已送达，就误以为 tools 已恢复
4. fresh-attempt-means-recovered illusion
   只要重新连过一次，就误以为新 truth 已闭环
5. auth-done-means-usable illusion
   只要 token exchange 完成，就误以为 current usable world 已恢复

所以从第一性原理看：

`continuity governance` 管的是旧线是否继续；
`recovery governance` 管的是新证据是否足够重新成立。

## 5. `handleRemoteAuthFailure()` 与 auth cache 先证明：continuity 断裂之后，repo 会转入 recovery grammar，而不是假装旧线自然痊愈

`client.ts:1079-1137` 很硬。

这里在 SSE、HTTP 和 `claudeai-proxy` transport 上，
一旦碰到 `UnauthorizedError` 或 401，
系统做的不是：

`继续把它当成旧的 continuity line 上的暂时波动`

而是直接调用：

`handleRemoteAuthFailure()`

把结果落成：

`type: 'needs-auth'`

`client.ts:340-360` 又把这条路径做成正式制度：

1. 记录 `tengu_mcp_server_needs_auth`
2. `setMcpAuthCacheEntry(name)`
3. 返回 `needs-auth`

更关键的是 `2301-2334`。

这里如果对象近期已经走过 401 path，
或者已经有 discovery 但没有 token，
系统会直接：

1. `Skipping connection (cached needs-auth)`
2. 返回 `needs-auth`
3. 给出 `createMcpAuthTool(name, config)`

这说明 repo 公开承认：

`continuity can stop here; recovery now needs a different kind of proof.`

一旦转入 `needs-auth` grammar，
系统就不再允许旧 continuity line 冒充 restored truth。

## 6. `reconnectMcpServerImpl()` 再证明：恢复 verdict 需要 fresh source-of-truth，而不是旧尝试线的自然延长

`client.ts:2137-2163` 特别值钱。

这里的 `reconnectMcpServerImpl()` 一上来就先做两件事：

1. `clearKeychainCache()`
2. `clearServerCache(name, config)`

然后才重新：

`connectToServer(name, config)`

而且如果 reconnect result 不是 `connected`，
函数就直接返回：

1. 当前 client result
2. `tools: []`
3. `commands: []`

只有在真的 `connected` 之后，
它才继续抓：

1. `fetchToolsForClient(client)`
2. `fetchCommandsForClient(client)`
3. `fetchResourcesForClient(client)`

这条证据非常硬。

它说明 recovery verdict 的制度不是：

`旧线还在试，所以恢复已经成立`

而是：

`先清掉旧 credential/cache truth -> 再拿新的 connect result -> 再重新抓一遍 current tools/resources -> 只有这样才配说恢复成立`

从技术角度看，这非常先进。
它把恢复从“再次尝试”提升成了“fresh proof re-establishment”。

## 7. `auth.ts` 再证明：恢复可以是 silent 的，也可以是 interactive 的，但无论哪条路都必须拿到新的 credential evidence

`auth.ts:930-1040` 的 `performMCPOAuthFlow()` 很值钱。

这里不是只说“去网页登录一下”，
而是显式做出一条 recovery evidence pipeline：

1. 发现/读取 auth metadata
2. 建立新的 callback server
3. 生成和校验新的 OAuth state
4. 收到新的 authorization code
5. 完成新的 token exchange

`578-616` 又说明即便是 re-auth，
repo 也只保留 step-up scope / discovery state，
并不把旧 token 当成恢复完成的证据本身。

`1548-1614` 与 `1755-1778` 更进一步给出两条恢复路径：

1. 若 XAA 的 cached `id_token` 还有效，可走 silent re-auth
2. 若 `id_token` 不在缓存里，就明确落回 `needs-auth`，要求 interactive re-auth

这说明 recovery governance 的关键不是：

`一定要人工恢复`

而是：

`无论 silent 还是 interactive，恢复都必须有新的凭据证据闭环。`

所以对 cleanup 线最关键的启示不是：

`继续等一等，也许旧线会自己回来`

而是：

`一旦 continuity 已经失真，必须回答什么新的 proof 才配重新成立。`

## 8. `print.ts` 的 control flow 再证明：auth done、callback done 与 recovery done 被明确拆成三层事实

`print.ts:3133-3204` 的 `mcp_reconnect` 很硬。

这里不是 “只要发起 reconnect control message 就返回 success”，
而是只有在：

`result.client.type === 'connected'`

时才：

1. `registerElicitationHandlers([result.client])`
2. `reregisterChannelHandlerAfterReconnect(result.client)`
3. `sendControlResponseSuccess(message)`

否则就明确 `sendControlResponseError(...)`。

`3206-3295` 的 `mcp_toggle` 也是同样制度：
re-enable 之后只有 reconnect result 真是 `connected` 才算成功。

`3310-3455` 的 `mcp_authenticate` 更值钱。

这里先返回的只是：

1. `authUrl`
2. `requiresUserAction`

然后把：

1. `oauthAuthPromises`
2. background reconnect
3. appState tool swap

拆成后续阶段。

`3463-3505` 的 `mcp_oauth_callback_url` 又进一步说明：

1. 它等待的是 auth promise
2. manual callback path 里的 reconnect 由别的 handler 负责

这等于明确写出：

`callback accepted`

并不自动等于：

`service recovered`

它最多只说明：

`auth phase has completed`

真正的 recovery verdict 还要再过 reconnect result。

## 9. `McpAuthTool` 与 `MCPReconnect` 给出最强 consumer-side 正例：surface 也拒绝把“正在恢复”冒充成“已经恢复”

`McpAuthTool.ts:37-47` 直接把自己的定位写明了：

1. 它只是一个 pseudo-tool
2. 真正的 tools 要等 OAuth callback 完成后再回来

`115-165` 更硬。

这里在 `oauthPromise` resolve 之后，
才会：

1. `clearMcpAuthCache()`
2. `reconnectMcpServerImpl(serverName, config)`
3. 把 real tools / commands / resources swap 回 `appState`

这说明 auth tool 的制度不是：

`我发出了 auth URL，所以恢复已经成立`

而是：

`只有 auth 完成并且 reconnect 也闭环，我才把真实工具世界交回来`

`MCPReconnect.tsx:30-63` 也保持了同样纪律：

1. `connected` 才显示成功
2. `needs-auth` 明确提示去 `/mcp` authenticate
3. `pending / failed / disabled` 都不算 recovered

这说明 consumer surface 也在帮系统守 recovery boundary。

## 10. 技术先进性与哲学本质：Claude Code 真正先进的地方，是它拒绝让“恢复动作已经开始”自动篡位成“恢复真相已经成立”

从技术角度看，Claude Code 在这条线上的先进性，
不只是因为它有 OAuth flow 或 reconnect function。

更值钱的是它已经在多个点上同时承认：

1. continuity 断裂后，系统会先降到 `needs-auth` 或 `failed`
2. 恢复需要新的 credential evidence
3. 新的 credential evidence 还不等于新的 usable truth
4. 只有新的 `connected` result 才配继续抓 tools/resources
5. tools 真正回到 current world 之后，surface 才能说 recovered

这背后的哲学本质是：

`真正成熟的系统，不会让“我们正在修复”自动冒充“真相已经修复”。`

也就是说，
它不只追问时间诚实性，
还追问恢复诚实性。

对 cleanup 线最关键的技术启示因此不是：

`只要补一套 retry loop，再补一个 auth 按钮，就算恢复层完整了。`

而是：

`必须同时补出降级、auth proof、fresh reconnect、tool/world reinsertion 这整套 recovery evidence grammar。`

否则系统仍会停在另一种危险的半治理状态：

`它能说对象正在恢复，却没人正式决定它到底什么时候已经恢复。`

## 11. 苏格拉底式自诘：我的判断有没有再次越级

为了避免把 “源码里有 OAuth 和 reconnect” 直接写成 “cleanup 线只差照抄一个恢复按钮”，
这里必须主动追问自己五个问题。

### 第一问

`我是不是把 recovery 简化成了 reconnect 成功一次？`

不能这样写。
recovery 不只要新的连接结果，
还要 fresh credential source、fresh cache invalidation 与 real tools/resources 的重新建立。

### 第二问

`只要 auth flow 成功，是否就能直接说 recovered？`

也不能。
源码已经把 auth promise 与 reconnect result 拆开，
manual callback path 更明确把 reconnect 交给后续 handler。

### 第三问

`continuity give-up 之后，recovery 一定只能人工触发吗？`

也不能这么绝对。
`auth.ts` 已经说明 XAA recovery 可以是 silent 的。
关键不是人工还是自动，
而是有没有新的 proof。

### 第四问

`McpAuthTool` 返回 auth URL 时，是否已经在签 recovery truth？`

不能。
它签的只是：

`recovery procedure started`

真正的 recovered truth 要等 background reconnect 和 tool swap。

### 第五问

`我是不是把 recovery 和 reintegration 混成一个 verdict 了？`

也要警惕。
恢复成功与 tools/world 重新回到 current consumer plane 很接近，
但源码已经暗示二者仍可继续拆层：`reconnectMcpServerImpl()` 只返回结果，真正的 appState / dynamicMcpState reinsertion 还在别处。

所以这一章最该继续约束自己的，
就是始终把：

`retrying`
`auth completed`
`reconnected`
`recovered`

当成四个不同强度的事实。

## 12. 一条硬结论

这组源码真正说明的不是：

`Claude Code 只要还在 continuity path 上继续尝试，或者已经拿到新的 auth callback，就已经自动拥有宣布旧 cleanup 对象恢复成立的主权。`

而是：

`repo 在 handleRemoteAuthFailure 的 needs-auth demotion、reconnectMcpServerImpl 的 fresh cache/credential reconnect、performMCPOAuthFlow 的新凭据闭环、print 的 auth-vs-reconnect control choreography，以及 McpAuthTool / MCPReconnect 的 consumer-side result discipline 上，已经明确展示了 recovery governance 的存在；因此 artifact-family cleanup continuity-governor signer 仍不能越级冒充 artifact-family cleanup recovery-governor signer。`

再压成最后一句：

`连续性负责决定旧线还要不要继续；恢复，才负责决定什么新的证据足以重新宣布它已经回来。`
