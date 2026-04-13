# McpAuthTool、MCPRemoteServerMenu与MCPReconnect的强请求清理重新担保治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `431` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 线未来谁来决定 current truth 该怎样被不同 reader 重新讲述，`

而是：

`stronger-request cleanup 线一旦已经把 current truth 重新讲给不同 surface，谁来决定这些讲述里，哪些现在配承载多强的继续依赖担保。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`reprojection governor 不等于 reassurance governor。`

这句话还不够硬。

所以这里单开一篇，
只盯住：

- `src/tools/McpAuthTool/McpAuthTool.ts`
- `src/components/mcp/MCPRemoteServerMenu.tsx`
- `src/components/mcp/MCPReconnect.tsx`
- `src/cli/handlers/mcp.tsx`
- `src/hooks/notifs/useMcpConnectivityStatus.tsx`
- `src/cli/print.ts`

把 auth guidance、auth-complete branching、reconnect dialog、health glyph、notification silence 与 control auth guidance 并排，
直接钉死 stronger-request cleanup 线当前仍缺的不是 reprojection，
而是 `reassurance governance grammar`。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 reprojection，没有 reassurance。`

而是：

`Claude Code 已经在 MCP 线上明确把“怎样重讲 current truth”和“这句重讲允许承载多强的正向担保”拆成两层；stronger-request cleanup 线当前缺的不是文化，而是这套 reassurance governance 还没被正式接到旧 cleanup artifact family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| graded auth guidance | `src/tools/McpAuthTool/McpAuthTool.ts:55-60,182-195` | 为什么同一 auth story 的正向 assurance lexicon 仍要分强弱 |
| auth-complete branching | `src/components/mcp/MCPRemoteServerMenu.tsx:95-107,279-288` | 为什么 auth success 还不能自动升级成 stronger all-clear |
| reconnect operation reassurance | `src/components/mcp/MCPReconnect.tsx:40-63` | 为什么一次 reconnect success 仍只是 operation-local reassurance |
| health reassurance ceiling | `src/cli/handlers/mcp.tsx:26-35` | 为什么 health readers 只能拿到 narrow glyph reassurance |
| selective publication policy | `src/hooks/notifs/useMcpConnectivityStatus.tsx:25-63` | 为什么 repo 会主动拒绝发布对称 success reassurance |
| control auth guidance | `src/cli/print.ts:3359-3367,3491-3505` | 为什么 control plane 也会把 auth fact 与 stronger reassurance ceiling 拆开 |

## 4. `McpAuthTool` 先证明：同一 auth flow 主题也不拥有统一的正向 assurance ceiling

`src/tools/McpAuthTool/McpAuthTool.ts:55-60,182-195`
很值钱。

这段代码最值钱的不是它会返回 auth URL，
而是它怎样分配正向词法强度。

tool description 与 auth-url message 里，
repo 使用的是：

`Once the user completes authorization ... the server's real tools will become available automatically.`

这是带有 automation promise 的 guidance grammar。

但 silent auth path 里，
repo 故意降成：

`The server's tools should now be available.`

这说明 repo 没有把：

`auth topic has been reprojected`

偷写成：

`all positive phrasings are equally safe`

它反而明确承认：

1. 有的 surface 只配给出 path guidance
2. 有的 surface 即便看到更靠后的结果，也仍只配给出 tentative reassurance
3. 正向 lexicon 本身要受 uncertainty budget 约束

这条证据非常硬。

它说明：

`same story`

也不自动等于：

`same reassurance ceiling`

## 5. `MCPRemoteServerMenu` 再证明：`Authentication successful` 不拥有越级签发 all-clear 的资格

`src/components/mcp/MCPRemoteServerMenu.tsx:95-107,279-288`
很硬。

这里 repo 明确把 auth-complete surface 分成三类结果：

1. `Authentication successful. Connected to ...`
2. `Authentication successful, but server still requires authentication. You may need to manually restart Claude Code.`
3. `Authentication successful, but server reconnection failed. You may need to manually restart Claude Code for the changes to take effect.`

最值钱的地方在于：

这三句都承认了同一个上游事实：

`Authentication successful`

但 repo 明确拒绝让这个上游事实自动篡位成 strongest reassurance。

它仍继续问：

1. reconnect result 到底是不是 `connected`
2. 当前 surface 是不是还必须保留 `manual restart` caveat
3. 当前 surface 能不能只说 local success，而不替所有 downstream readers 作保

这等于直接说明：

`auth success retelling != final reassurance signer`

## 6. `MCPReconnect` 再证明：局部 repair verdict 不是 system-wide reassurance verdict

`src/components/mcp/MCPReconnect.tsx:40-63`
特别值钱。

这里 repo 只在局部 reconnect operation 成功时说：

`Successfully reconnected to ...`

否则就转成：

1. `... requires authentication. Use /mcp to authenticate.`
2. `Failed to reconnect to ...`

这说明 `MCPReconnect` 拥有的不是：

`替整个系统宣布已经没有后续风险`

的资格，
而只是：

`对这次 reconnect operation 给出局部 reassurance`

所以这里最值钱的技术启示是：

`operation-local reassurance`

和

`global reassurance`

不是同一个签字层。

## 7. `/mcp` health 与 notification silence 再证明：担保不只分强弱，还分“谁可以说”和“谁应保持沉默”

`src/cli/handlers/mcp.tsx:26-35`
与
`src/hooks/notifs/useMcpConnectivityStatus.tsx:25-63`
放在一起看特别值钱。

`/mcp` health 只给：

1. `✓ Connected`
2. `! Needs authentication`
3. `✗ Failed to connect`

这是 narrow probe reassurance。

notification hook 则只在：

1. `failed`
2. `needs-auth`

时主动发通知，
不会发对称的 `connected` success toast。

而且对 `claudeai-proxy`，
它还会结合 `hasClaudeAiMcpEverConnected()`，
只在历史上真正工作过的 connector 退化后才发相应 negative signal。

这说明 repo 不只在分配：

`what to say`

更在分配：

`who gets to say something positive at all`

从第一性原理看，
这就是 reassurance governance 的核心：

1. health reader 只配拿窄范围 reassurance
2. notification reader 甚至可以完全不配拿正向 reassurance
3. absence of warning 不自动等于 explicit all-clear

## 8. `print.ts` 再补一条强证据：control plane 也会把 auth fact 和 reassurance ceiling 拆开

`src/cli/print.ts:3359-3367,3491-3505`
很值钱。

这里 `mcp_authenticate` 只在不同阶段返回：

1. `authUrl` + `requiresUserAction: true`
2. `requiresUserAction: false`

而 `mcp_oauth_callback_url` 又只在 auth promise 真正 resolve 时返回 success，
否则继续返回 error。

这说明 control plane 也不把：

`auth started`

或者

`auth callback accepted`

自动升级成：

`stronger reassurance already granted`

它只签自己的事实，
不替更强的依赖负荷作保。

## 9. 苏格拉底式自反诘问：我是不是又把“它已经被正向重讲”误认成了“它已经被正式担保到可以继续依赖”

如果对这组代码做更严格的自我审查，
至少要追问六句：

1. 如果 auth 已经成功，为什么 repo 仍保留 `may need to manually restart`？
   因为 auth-success 只回答 credential 线，不自动回答 every downstream reader 是否已配拿到 stronger reassurance。
2. 如果 `/mcp` 已经显示 `✓ Connected`，为什么 repo 不顺手发 success toast？
   因为 probe truth、publication duty 与 reassurance liability 不是同一层。
3. 如果 dialog 已经说 `Successfully reconnected`，为什么 `McpAuthTool` 还只敢说 `should now be available`？
   因为 local operation verdict 仍不自动拥有替所有 surface 发布 stronger all-clear 的资格。
4. 如果正向词法只是文案风格，为什么 repo 要在同一主题里刻意分 `will become` 与 `should now`？
   因为 assurance strength 本身就是安全边界。
5. 如果没有看到 warning 就足以说明 all-clear，为什么 notification 层会主动选择 positive silence？
   因为 absence of warning 与 explicit reassurance 根本不是同一句制度。
6. 如果 stronger-request cleanup 线还没正式长出 reassurance grammar，是不是说明这层只是交互修辞？
   恰恰相反。越是把它当修辞，越容易让弱 surface 偷签强担保。

这一串反问最终逼出一句更稳的判断：

`reassurance 的关键，不在 current truth 有没有被重讲，而在系统能不能正式决定这些重讲里哪些现在敢担保到什么程度。`

如果再追问“怎样做得更好”，
更好的方法也不是只增加更多正向文案，
而是继续把四个问题拆开：

1. 谁决定哪句只是在描述 snapshot
2. 谁决定哪句已经可以承载依赖
3. 谁决定哪句必须保留 caveat
4. 谁决定哪些 surface 最诚实的行为反而是保持沉默

## 10. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 线未来只要补出 reprojection governance，就已经足够成熟。`

而是：

repo 在 `McpAuthTool` 的 graded positive lexicon、`MCPRemoteServerMenu` 的 `Authentication successful` branching、`MCPReconnect` 的 operation-local success copy、`handlers/mcp.tsx` 的 narrow health reassurance、`useMcpConnectivityStatus()` 的 selective positive silence，以及 `print.ts` 的 control auth guidance 上，已经明确展示了 reassurance governance 的存在；因此 `artifact-family cleanup stronger-request cleanup-reprojection-governor signer` 仍不能越级冒充 `artifact-family cleanup stronger-request cleanup-reassurance-governor signer`。

因此：

`stronger-request cleanup 线真正缺的不是“truth 该怎样被重讲”，而是“这些重讲里哪些现在配承载多强的正向担保”。`
