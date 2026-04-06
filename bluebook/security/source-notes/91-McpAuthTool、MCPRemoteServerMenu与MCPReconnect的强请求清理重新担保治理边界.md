# McpAuthTool、MCPRemoteServerMenu与MCPReconnect的强请求清理重新担保治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `240` 时，
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

把 auth guidance、auth-complete branching、reconnect dialog、health glyph 与 notification silence 并排，
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
| graded auth guidance | `src/tools/McpAuthTool/McpAuthTool.ts:55-60,182-196` | 为什么同一 auth story 的正向 assurance lexicon 仍要分强弱 |
| auth-complete branching | `src/components/mcp/MCPRemoteServerMenu.tsx:95-111,277-289` | 为什么 auth success 还不能自动升级成 stronger all-clear |
| reconnect operation reassurance | `src/components/mcp/MCPReconnect.tsx:40-63` | 为什么一次 reconnect success 仍只是 operation-local reassurance |
| health reassurance ceiling | `src/cli/handlers/mcp.tsx:26-35` | 为什么 health readers 只能拿到 narrow glyph reassurance |
| selective publication policy | `src/hooks/notifs/useMcpConnectivityStatus.tsx:25-63` | 为什么 repo 会主动拒绝发布对称 success reassurance |

## 4. `McpAuthTool` 先证明：同一 auth flow 主题也不拥有统一的正向 assurance ceiling

`McpAuthTool.ts:55-60,182-196`
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

`MCPRemoteServerMenu.tsx:95-111,277-289`
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

`MCPReconnect.tsx:40-63`
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

`handlers/mcp.tsx:26-35`
与
`useMcpConnectivityStatus.tsx:25-63`
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

这说明 repo 不只在分配：

`what to say`

更在分配：

`who gets to say something positive at all`

从第一性原理看，
这就是 reassurance governance 的核心：

1. health reader 只配拿窄范围 reassurance
2. notification reader 甚至可以完全不配拿正向 reassurance
3. absence of warning 不自动等于 explicit all-clear

## 8. 这篇源码剖面给主线带来的五条技术启示

### 启示一

repo 已经在 `McpAuthTool` 上明确展示：

`同一主题的正向文案也应允许分级，而不是统一写成最大胆保`

### 启示二

repo 已经在 `MCPRemoteServerMenu` 上明确展示：

`上游成功事实和下游 all-clear 承诺必须分开`

### 启示三

repo 已经在 `MCPReconnect` 上明确展示：

`局部操作成功不应自动外推成系统级 reassurance`

### 启示四

repo 已经在 `/mcp` health 上明确展示：

`窄语法是有价值的，因为它能压住过强承诺`

### 启示五

repo 已经在 notification silence 上明确展示：

`不发 success 本身可以是一种更诚实的 assurance policy`

## 9. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 线未来只要补出 reprojection governance，就已经足够成熟。`

而是：

`repo 在 McpAuthTool 的 graded positive lexicon、MCPRemoteServerMenu 的 Authentication successful branching、MCPReconnect 的 operation-local success copy、handlers/mcp.tsx 的 narrow health reassurance，以及 useMcpConnectivityStatus() 的 selective positive silence 上，已经明确展示了 reassurance governance 的存在；因此 artifact-family cleanup stronger-request cleanup-reprojection-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-reassurance-governor signer。`

因此：

`stronger-request cleanup 线真正缺的不是“truth 该怎样被重讲”，而是“这些重讲里哪些现在配承载多强的正向担保”。`
