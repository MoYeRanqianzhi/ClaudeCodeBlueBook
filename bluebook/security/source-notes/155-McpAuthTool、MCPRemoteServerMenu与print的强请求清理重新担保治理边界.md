# McpAuthTool、MCPRemoteServerMenu与print的强请求清理重新担保治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `304` 时，
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
- `src/cli/print.ts`
- `src/services/mcp/auth.ts`

把 graded wording、auth-complete branching、control `requiresUserAction`、
manual callback validation 与 no-silent-fallback 并排，
直接钉死 stronger-request cleanup 线当前仍缺的不是 current truth retelling，
而是 `dependence-bearing reassurance grammar`。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 reprojection，没有 reassurance。`

而是：

`Claude Code 已经在 MCP 线上明确把“怎样把 current truth 讲给不同 readers”与“这些讲述里哪些现在配承载多强的继续依赖担保”拆成两层；stronger-request cleanup 线当前缺的不是文化，而是这套 reassurance governance 还没被正式接到旧 cleanup artifact family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| graded auth wording | `src/tools/McpAuthTool/McpAuthTool.ts:57-60,182-202` | 为什么同一 auth story 的正向 assurance lexicon 仍要分强弱 |
| auth-complete branching | `src/components/mcp/MCPRemoteServerMenu.tsx:92-117,270-289` | 为什么 auth success 还不能自动升级成 stronger all-clear |
| control reassurance strength | `src/cli/print.ts:2736-2760,3339-3367` | 为什么 control readers 只拿到 success/error + `requiresUserAction`，而不是直接拿到更强 all-clear |
| callback proof gate | `src/cli/print.ts:3480-3505`; `src/services/mcp/auth.ts:1054-1092,1109-1139` | 为什么 callback path 只有在 proof 过关后才配维持正向 reassurance |
| reassurance honesty | `src/services/mcp/auth.ts:864-875` | 为什么 repo 宁可 hard-fail with actionable copy，也不愿用 silent degrade 冒充 reassurance |

## 4. `McpAuthTool` 先证明：同一 auth story 的正向 assurance lexicon 也不是统一强度

`McpAuthTool.ts:57-60,182-202`
很值钱。

这段代码最值钱的不是它会返回 auth URL，
而是它怎样明确限制正向 wording 的强度。

description 与 auth-url path 使用的是：

`Once the user completes authorization ... the server's real tools will become available automatically.`

这是带有较强 automation promise 的 guidance grammar。

但 silent-auth path 却故意降成：

`The server's tools should now be available.`

与此同时，
unsupported / failed-to-start path
又退回：

`Ask the user to run /mcp and authenticate manually.`

这说明 repo 明确拒绝让：

`auth story has been retold`

自动等于：

`every positive sentence may bear the same reassurance liability`

也就是说，
在 Claude Code 里，
正向词法强度本身就是被治理的安全对象。

## 5. `MCPRemoteServerMenu` 再证明：`Authentication successful` 仍不自动拥有 all-clear 主权

`MCPRemoteServerMenu.tsx:92-117,270-289`
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
3. manual restart caveat 本身就是 reassurance governance 的一部分

换句话说，
`Authentication successful`
只是 current fact，
不是 strongest reassurance verdict。

## 6. `print.ts` 再证明：control protocol 也在治理 reassurance strength，而不是只做传输

`print.ts:2736-2760`
先把 control response 严格拆成：

1. `success`
2. `error`
3. optional `response payload`

然后
`print.ts:3339-3367`
在 `mcp_authenticate`
里又进一步把正向回执压成：

1. `authUrl + requiresUserAction: true`
2. `requiresUserAction: false`

这里最值钱的不是它会给 authUrl，
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

## 7. callback validation 再证明：正向 reassurance 必须经过 proof gate

`print.ts:3480-3505`
与
`auth.ts:1054-1092,1109-1139`
放在一起看特别值钱。

control path 对 callback URL 的要求是：

1. 必须带 `code` 或 `error`
2. 否则直接报
   `Invalid callback URL: missing authorization code`
3. `authPromise` 只有真正完成后才允许返回 success

底层 `performMCPOAuthFlow()`
又继续要求：

1. manual callback URL 必须通过 `code/state/error` 检查
2. `state mismatch` 会被当场判成可能的 CSRF attack
3. OAuth provider error 会被显式转成 error surface
4. callback proof 没完成前，不允许把 positive reassurance 继续往前推

这说明 reassurance 在 repo 里不是“看起来像成功就说成功”，
而是：

`positive dependence signal must be proof-gated`

这条技术边界非常关键。

因为一旦 proof gate 被拿掉，
系统就会把：

`正在走向成功`

偷写成：

`已经值得继续依赖`

## 8. `performMCPOAuthFlow()` 再补一层：成熟 reassurance 还必须防止 silent degrade 冒充 all-clear

`auth.ts:864-875`
直接写出了最值钱的一句注释：

`No silent fallback`

并且在 `oauth.xaa` 已配置但 XAA 未启用时，
宁可 hard-fail with actionable copy，
也不愿 silently degrade 到 consent flow。

从安全设计角度看，
这非常先进。

它说明 repo 很清楚：

1. reassurance 一旦跨路径 silent degrade，就会污染 trust posture
2. 用户显式请求的 auth posture 不应被系统偷偷改写
3. actionable copy 往往比貌似“更顺”的 silent fallback 更诚实

这条证据把 reassurance governance 从
`文案分级`
进一步推进到
`trust posture honesty`

## 9. 这篇源码剖面给主线带来的五条技术启示

### 启示一

正向 wording 强度本身就是安全设计对象，而不是单纯 UX 文案。

### 启示二

上游 success fact 与下游 all-clear promise 必须分层，否则系统会对依赖负荷过度签字。

### 启示三

control protocol 也应该治理 reassurance strength，例如 `requiresUserAction` 这种 bit 不只是便利字段，而是风险边界。

### 启示四

manual callback acceptance、state validation 与 OAuth error mapping 说明 reassurance 必须 proof-gated，而不是凭 optimistic path 直接外放。

### 启示五

成熟系统不怕给出 actionable failure copy，真正危险的是 silent degrade 伪装成 smooth success。

## 10. 用苏格拉底式反问压缩这篇源码剖面的核心

可以得到五个自检问题：

1. 如果 auth success 已经等于 strongest reassurance，为什么 menu 还要保留 manual restart caveat？
2. 如果 control success 已经够强，为什么还要单独返回 `requiresUserAction`？
3. 如果 callback proof 不重要，为什么 invalid URL、state mismatch 和 OAuth error 会阻断 success？
4. 如果 positive wording 只是 UI 修辞，为什么 `will become available automatically` 和 `should now be available` 要被刻意分开？
5. 如果 silent degrade 没问题，为什么 `performMCPOAuthFlow()` 要明确坚持 `No silent fallback`？

这些反问共同逼出同一个结论：

`Claude Code 不只在治理 truth grammar，也在治理 reassurance liability。`
