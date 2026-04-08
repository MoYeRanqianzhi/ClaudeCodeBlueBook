# McpAuthTool、MCPRemoteServerMenu与print的强请求清理重新担保治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `367` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 线未来谁来决定 current truth 该怎样被不同 reader 重新讲述，`

而是：

`stronger-request cleanup 线一旦已经把 current truth 重新讲给不同 surface，谁来决定这些讲述里哪些现在配承载多强的继续依赖担保。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`reprojection governor 不等于 reassurance governor。`

这句话还不够硬。
所以这里单开一篇，
只盯住：

- `src/tools/McpAuthTool/McpAuthTool.ts`
- `src/components/mcp/MCPRemoteServerMenu.tsx`
- `src/components/mcp/MCPReconnect.tsx`
- `src/cli/print.ts`
- `src/services/mcp/auth.ts`
- `src/cli/handlers/mcp.tsx`
- `src/hooks/notifs/useMcpConnectivityStatus.tsx`

把 graded wording、auth-complete caveat、operation-local success copy、health glyph、success-silence policy 与 proof gate 并排，
直接钉死 stronger-request cleanup 线当前仍缺的不是 retelling culture，
而是 `dependence-bearing reassurance grammar`。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 reprojection，没有 reassurance。`

而是：

`Claude Code 已经在 MCP 线上明确把“怎样把 current truth 讲给不同 readers”与“这些讲述里哪些现在配承载多强的继续依赖担保”拆成两层；stronger-request cleanup 线当前缺的不是文化，而是这套 reassurance governance 还没被正式接到旧 cleanup artifact family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| graded auth wording | `src/tools/McpAuthTool/McpAuthTool.ts:55-60,184-195` | 为什么同一 auth story 的正向 assurance lexicon 仍要分强弱 |
| auth-complete caveat budget | `src/components/mcp/MCPRemoteServerMenu.tsx:95-107,279-288` | 为什么 auth success 还不能自动升级成 stronger all-clear |
| control reassurance strength | `src/cli/print.ts:2736-2760,3358-3366` | 为什么 control readers 只拿到 success/error + `requiresUserAction`，而不是直接拿到更强 reassurance |
| callback proof gate | `src/cli/print.ts:3478-3508` | 为什么 callback path 只有在 proof 过关后才配维持正向 reassurance |
| trust-posture honesty | `src/services/mcp/auth.ts:864-875,1082,1116` | 为什么 repo 宁可 hard-fail with actionable copy，也不愿用 silent degrade 冒充 reassurance |
| narrow reassurance surfaces | `src/components/mcp/MCPReconnect.tsx:45-58`; `src/cli/handlers/mcp.tsx:26-35`; `src/hooks/notifs/useMcpConnectivityStatus.tsx:25-63` | 为什么 operation、health、notification surface 只给局部 reassurance ceiling |

## 4. `McpAuthTool` 先证明：同一 auth story 的正向 assurance lexicon 也不是统一强度

`McpAuthTool.ts:55-60,184-195`
很值钱。

这段代码最值钱的不是它会返回 auth URL，
而是它怎样主动限制正向 wording 的强度。

它先给出较强 guidance：

`the server's real tools will become available automatically`

然后 silent-auth result 又主动降成：

`The server's tools should now be available.`

unsupported / failed-to-start path
则继续退回：

`Ask the user to run /mcp and authenticate manually.`

这说明 repo 明确拒绝让：

`auth story has been retold`

自动等于：

`every positive sentence may bear the same reassurance liability`

也就是说，
在 Claude Code 里，
正向词法强度本身就是被治理的安全对象。

## 5. `MCPRemoteServerMenu` 再证明：`Authentication successful` 仍不自动拥有 all-clear 主权

`MCPRemoteServerMenu.tsx:95-107,279-288`
很硬。

这里最值钱的不是它会说成功，
而是它会在同一上游成功事实上继续追问下游 caveat：

1. `Authentication successful. Connected to ...`
2. `Authentication successful. Reconnected to ...`
3. `Authentication successful, but server still requires authentication. You may need to manually restart Claude Code.`
4. `Authentication successful, but server reconnection failed. You may need to manually restart Claude Code for the changes to take effect.`

这意味着 repo 公开承认：

1. upstream success fact 与 downstream reassurance promise 不是一层
2. local auth completion 并不自动抹去 reconnect uncertainty
3. manual restart / needs-auth caveat 本身就是 reassurance governance 的一部分

换句话说，
`Authentication successful`
只是较弱 current fact，
不是 strongest reassurance verdict。

## 6. `print.ts` 再证明：control protocol 也在治理 reassurance strength，而不是只做传输

`print.ts:2736-2760`
先把 control response 严格拆成：

1. `success`
2. `error`
3. optional `response payload`

然后
`print.ts:3358-3366`
在 `mcp_authenticate`
里又进一步把正向回执压成：

1. `authUrl + requiresUserAction: true`
2. `requiresUserAction: false`

这里最值钱的不是它会给 auth URL，
而是 control plane 明确知道：

`成功开始了一个流程`

和

`当前已经不需要用户动作`

是两层 reassurance 强度。

如果 repo 只关心 reprojection，
它完全可以只回一个 generic success。

但它偏偏还加上：

`requiresUserAction`

这说明 control protocol 不是中立运输管道，
而是在正式治理：

`当前这句 success 允许读者背负多大的继续依赖`

## 7. callback validation 与 `No silent fallback` 再证明：正向 reassurance 必须经过 proof gate

`print.ts:3478-3508`
与
`auth.ts:864-875,1082,1116`
放在一起看特别值钱。

control path 对 callback URL 的要求是：

1. 必须带 `code` 或 `error`
2. 否则直接报
   `Invalid callback URL: missing authorization code`
3. `authPromise` 只有真正完成后才允许返回 success

底层 `performMCPOAuthFlow()`
又继续要求：

1. `state mismatch` 会被当场判成 possible CSRF attack
2. `oauth.xaa` 明确坚持 `No silent fallback`
3. callback proof 没完成前，不允许把 positive reassurance 继续往前推

这说明 reassurance 在 repo 里不是
“看起来像成功就说成功”，
而是：

`positive dependence signal must be proof-gated`

并且：

`trust posture may not be silently downgraded merely to preserve a smooth success story`

## 8. `MCPReconnect`、`/mcp` health 与 `useMcpConnectivityStatus()` 再证明：不同 surface 具备不同 reassurance ceiling 与 success-silence policy

`MCPReconnect.tsx:45-58`
只在局部 reconnect operation 成功时说：

1. `Successfully reconnected to ...`
2. `... requires authentication. Use /mcp to authenticate.`
3. `Failed to reconnect to ...`

这是 operation-local reassurance。

`handlers/mcp.tsx:26-35`
则只给出：

1. `✓ Connected`
2. `! Needs authentication`
3. `✗ Failed to connect`

这是 narrow health reassurance。

`useMcpConnectivityStatus.tsx:25-63`
又进一步表明：

1. 失败要主动讲
2. 鉴权不足要主动讲
3. success 不必对称主动讲

这说明 repo 并没有让所有 positive reprojection 都自动升级成：

`全局 all-clear`

它在不同 surface 上维持着不同 reassurance ceiling，
也维持着 deliberate positive silence。

## 9. 这篇源码剖面给主线带来的五条技术启示

### 启示一

正向 wording 强度本身就是安全设计对象，而不是单纯 UX 文案。

### 启示二

upstream success fact 与 downstream all-clear promise 必须分层，否则系统会对依赖负荷过度签字。

### 启示三

control protocol 也应该治理 reassurance strength，例如 `requiresUserAction` 这种 bit 不只是便利字段，而是风险边界。

### 启示四

callback proof、`authPromise` 与 `state mismatch` 说明 reassurance 必须 proof-gated，而不是凭 optimistic path 直接外放。

### 启示五

成熟系统不怕给出 actionable failure copy，真正危险的是 silent degrade 伪装成 smooth success。

## 10. 用苏格拉底式反问压缩这篇源码剖面的核心

可以得到五个自检问题：

1. 我现在看到的是 current truth 被讲出来，还是继续依赖已经被正式签字？
2. 一句 `Authentication successful` 后面如果还挂着 `requires authentication / manual restart` 这类 caveat，我凭什么把它压成 strongest reassurance？
3. control response 如果仍在返回 `requiresUserAction` 或等待 callback proof，我凭什么说系统已经替后续依赖兜底？
4. 如果 repo 明确坚持 `No silent fallback`，为什么我还要把“更顺滑”误读成“更安全”？
5. 如果这套 reassurance grammar 已经成熟，stronger-request cleanup 线为什么还不能直接借一条 success 文案就宣布 rely-safe？

## 11. 苏格拉底式自反诘问：我是不是又把“current truth 被重新讲出来”误认成了“系统已经替我背书继续依赖”

如果对这组代码做更严格的自我审查，
至少要追问六句：

1. 如果 reprojection grammar 已经足够强，为什么还要再拆 reassurance？
   因为会被重新讲出来，不等于已经被重新担保给你依赖。
2. 如果某个 surface 已经给出正向 copy，是不是就说明所有 surface 都认可这份依赖强度？
   不是。不同 surface 具有不同 reassurance ceiling。
3. 如果没有 success toast，是不是说明系统没有正向结论？
   不是。positive silence 本身就是一种更保守的 reassurance policy。
4. 如果 `/mcp` health 已经是 `✓ Connected`，是不是就能推出 dialog、tool、control 都该给 strongest all-clear？
   不能。narrow probe reassurance 不是 global reassurance。
5. 如果 callback proof 已经通过，是不是就能省掉 caveat？
   仍然不能。proof 过关不自动抹掉 reconnect 与 downstream consumer uncertainty。
6. 如果 cleanup 线现在还没有显式 reassurance 代码，是不是说明这层还不值得写？
   恰恰相反。越是缺这层明确 grammar，越容易把“系统已经把它讲出来”偷写成“系统已经替它担保到可依赖”。`

这一串反问最终逼出一句更稳的判断：

`reassurance 的关键，不在系统会不会把 truth 重新讲出来，而在系统能不能正式决定这句讲述现在允许用户背负多大的继续依赖。`

## 12. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 只要补出 reprojection governance，就已经足够成熟。`

而是：

`Claude Code 在 graded auth wording、auth-complete caveat、operation-local reconnect reassurance、narrow health reassurance ceiling 与 selective positive silence 上已经明确展示了 reassurance governance 的存在；因此 artifact-family cleanup stronger-request cleanup-reprojection-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-reassurance-governor signer。`

再压成一句：

`cleanup 线真正缺的不是“它已经被重新讲给你听”，而是“这句讲述现在到底担保到什么程度”。`
