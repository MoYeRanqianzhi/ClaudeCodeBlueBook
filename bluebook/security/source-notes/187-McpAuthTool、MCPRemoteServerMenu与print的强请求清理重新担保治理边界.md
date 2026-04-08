# McpAuthTool、MCPRemoteServerMenu与print的强请求清理重新担保治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `336` 时，
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
- `src/cli/print.ts`
- `src/services/mcp/auth.ts`

把 graded wording、auth-complete caveat、control `requiresUserAction`、
callback proof gate 与 `No silent fallback` 并排，
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
| graded auth wording | `src/tools/McpAuthTool/McpAuthTool.ts:60,105,187,195,202` | 为什么同一 auth story 的正向 assurance lexicon 仍要分强弱 |
| auth-complete caveat budget | `src/components/mcp/MCPRemoteServerMenu.tsx:103-107,281-288` | 为什么 auth success 还不能自动升级成 stronger all-clear |
| control reassurance strength | `src/cli/print.ts:2736-2760,3360-3366` | 为什么 control readers 只拿到 success/error + `requiresUserAction`，而不是直接拿到更强 reassurance |
| callback proof gate | `src/cli/print.ts:3481-3505` | 为什么 callback path 只有在 proof 过关后才配维持正向 reassurance |
| trust-posture honesty | `src/services/mcp/auth.ts:864-875,1082,1116` | 为什么 repo 宁可 hard-fail with actionable copy，也不愿用 silent degrade 冒充 reassurance |

## 4. `McpAuthTool` 先证明：同一 auth story 的正向 assurance lexicon 也不是统一强度

`McpAuthTool.ts:60,105,187,195,202`
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

`MCPRemoteServerMenu.tsx:103-107,281-288`
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
`print.ts:3360-3366`
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

`print.ts:3481-3505`
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

1. `state mismatch`
   会被当场判成 possible CSRF attack
2. `oauth.xaa`
   明确坚持
   `No silent fallback`
3. callback proof 没完成前，
   不允许把 positive reassurance 继续往前推

这说明 reassurance 在 repo 里不是
“看起来像成功就说成功”，
而是：

`positive dependence signal must be proof-gated`

并且：

`trust posture may not be silently downgraded merely to preserve a smooth success story`

## 8. 这篇源码剖面给主线带来的五条技术启示

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

## 9. 用苏格拉底式反问压缩这篇源码剖面的核心

可以得到五个自检问题：

1. 我现在看到的是 current truth 被讲出来，还是继续依赖已经被正式签字？
2. 一句 `Authentication successful`
   后面如果还挂着
   `requires authentication / manual restart`
   这类 caveat，
   我凭什么把它压成 strongest reassurance？
3. control response
   如果仍在返回
   `requiresUserAction`
   或等待 callback proof，
   我凭什么说系统已经替后续依赖兜底？
4. 如果 repo 明确坚持 `No silent fallback`，
   为什么我还要把“更顺滑”误读成“更安全”？
5. 如果这套 reassurance grammar 已经成熟，
   stronger-request cleanup 线为什么还不能直接借一条 success 文案就宣布 rely-safe？

这五句反问合起来逼出的结论只有一句：

`会被重新讲给你听，不等于已经被重新担保给你依赖。`
