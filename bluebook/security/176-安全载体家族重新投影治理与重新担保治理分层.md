# 安全载体家族重新投影治理与重新担保治理分层：为什么artifact-family cleanup reprojection-governor signer不能越级冒充artifact-family cleanup reassurance-governor signer

## 1. 为什么在 `175` 之后还必须继续写 `176`

`175-安全载体家族重新并入治理与重新投影治理分层` 已经回答了：

`reintegrated truth` 即便已经重新回到 current world，
也还要单独回答它该怎样被 control、panel、health、notification 与 dialog surface 重新讲述。

但如果继续往下追问，
还会碰到另一层同样容易被偷写的错觉：

`只要 current truth 已经被某个 surface 重新讲述过，系统就自动拥有了把这份 retold truth 升格成“已经可以放心继续依赖”的更强担保主权。`

Claude Code 当前源码同样不能支持这种更强说法。

因为继续看：

1. `src/tools/McpAuthTool/McpAuthTool.ts:55-60,182-196` 的 `will become available automatically` 与 `should now be available`
2. `src/components/mcp/MCPRemoteServerMenu.tsx:95-111,277-289` 的 `Authentication successful` 分叉 grammar
3. `src/components/mcp/MCPReconnect.tsx:40-63` 的 `Successfully reconnected` / `requires authentication` / `Failed to reconnect`
4. `src/cli/handlers/mcp.tsx:26-35` 的 `/mcp` health glyph grammar
5. `src/hooks/notifs/useMcpConnectivityStatus.tsx:25-63` 的 selective negative publication policy

会发现 repo 已经清楚展示出：

1. `reprojection governance` 负责决定 current truth 怎样被不同 reader retell
2. `reassurance governance` 负责决定这些 retelling 里，哪些 surface 配把这份 truth 升格成更强的 rely-safe claim，哪些 surface 只配给出窄范围、暂时性或带保留的 reassurance

也就是说：

`artifact-family cleanup reprojection-governor signer`

和

`artifact-family cleanup reassurance-governor signer`

仍然不是一回事。

前者最多能说：

`这份当前真相该怎样被不同读者重新讲述。`

后者才配说：

`哪一种讲述现在可以承载多强的依赖负荷，哪些讲述仍必须保留“可能还需要人工介入 / 可能只在当前 surface 成立 / 不应对全局做强承诺”的约束。`

所以 `175` 之后必须继续补的一层就是：

`安全载体家族重新投影治理与重新担保治理分层`

也就是：

`reprojection governor 决定怎样重讲 current truth；reassurance governor 才决定哪些重讲现在配承载多强的正向担保。`

## 2. 先做一条谨慎声明：`artifact-family cleanup reassurance-governor signer` 仍是研究命名，不是源码现成类型

这里同样要先讲清楚：

`Claude Code 当前源码里并没有一个字面存在的类型叫 artifact-family cleanup reassurance-governor signer。`

这里的 `artifact-family cleanup reassurance-governor signer` 仍是研究命名。
它不是在声称 cleanup 线已经有一个未公开的 reassurance manager，
而是在说：

1. repo 已经明确使用强弱不同的正向词法，而不是统一的 success 句式
2. repo 已经明确允许某些 surface 只给出局部 reassurance，或干脆保持对称沉默
3. repo 已经明确拒绝让 `auth successful`、`connected`、`reconnected` 与“可以放心继续依赖”自动压成一句话

因此 `176` 不是在虚构已有实现，
而是在给更深的一层缺口命名：

`重新讲述 current truth，不等于已经拿到更强的依赖担保主权。`

## 3. 最短结论

Claude Code 当前源码至少给出了五类“reprojection-governor signer 仍不等于 reassurance-governor signer”证据：

1. `McpAuthTool` 同时使用 `will become available automatically` 与 `should now be available`，说明即便围绕同一 auth/reconnect 主题，正向 assurance lexicon 也会按路径强弱分级
2. `MCPRemoteServerMenu` 明确把 `Authentication successful` 继续分叉成 `Connected`、`still requires authentication` 与 `reconnection failed`，说明 auth-success retelling 仍不自动等于 stronger all-clear
3. `MCPReconnect` 只在局部 reconnect operation 成功时说 `Successfully reconnected`，说明 operation-local reassurance 不是 system-wide reassurance
4. `/mcp` health 只给出 `✓ / ! / ✗` 窄语法，说明 health reader 拿到的是 narrow current probe reassurance，而不是对未来依赖关系的全面担保
5. `useMcpConnectivityStatus()` 只发布失败/鉴权通知，不发布对称的 success toast，说明 repo 明确拒绝让 every positive reprojection 自动升级成全局正向 reassurance

因此这一章的最短结论是：

`reprojection governor 最多能说 current truth 该怎样被不同 reader retell；reassurance governor 才能说这些 retelling 里，哪一些现在配承载多强的继续依赖担保。`

再压成一句：

`reprojected，不等于 already reassured enough to carry reliance load。`

## 4. 第一性原理：reprojection governance 回答“怎样重讲”，reassurance governance 回答“这句重讲允许用户背负多大的继续依赖”

从第一性原理看，
重新投影治理与重新担保治理处理的是两个不同主权问题。

reprojection governor 回答的是：

1. 哪个 reader 该看到这份 truth
2. 这份 truth 该被压成什么粒度
3. 该用 status enum、glyph、dialog copy 还是 structured payload
4. 该主动发布还是保持沉默
5. 同一 truth 在不同 surface 上该怎样重讲

reassurance governor 回答的则是：

1. 这句重讲只是在描述 current snapshot，还是已经允许用户继续依赖
2. 这句重讲是否仍必须保留“可能还需要人工重启/人工鉴权”的 caveat
3. 这句重讲是否只在当前 operation scope 成立，而不配外推到所有 consumer
4. 这句重讲是否已经强到足以替代后续更强的 readback
5. 沉默是否更安全，因为发出对称 success 会制造过强承诺

如果把这两层压成一句“反正都已经讲出来了”，
系统就会制造五类危险幻觉：

1. retold-means-safe-to-rely illusion
   只要 current truth 已被某个 surface 讲出来，就误以为已经可以放心继续依赖
2. auth-success-means-all-clear illusion
   只要 auth 成功，就误以为所有后续 reconnection / tool visibility 问题都已解决
3. connected-glyph-means-global-reassurance illusion
   只要 health surface 说 `Connected`，就误以为其他 surface 也已具备同等级 assurance
4. operation-success-means-system-success illusion
   只要某次 reconnect operation 成功，就误以为全系统已经拿到 durable reassurance
5. no-negative-toast-means-explicit-success illusion
   只要当前没有 warning/error notification，就误以为系统已经正式发布正向 all-clear

所以从第一性原理看：

`reprojection governance` 管的是 reader-facing retelling；
`reassurance governance` 管的是 retelling 允许承载多强的依赖负荷。

把这层差异再用苏格拉底式反问压一次：

1. 如果 auth 已经成功，为什么 repo 仍保留 “may need to manually restart”？
   因为 auth-success 只回答 credential 线，不自动回答 every downstream reader 是否已配拿到 stronger reassurance。
2. 如果 `/mcp` 已经显示 `✓ Connected`，为什么 repo 不顺手发 success toast？
   因为 probe truth、publication duty 与 reassurance liability 不是同一层。
3. 如果 dialog 已经说 `Successfully reconnected`，为什么 `McpAuthTool` 还只敢说 `should now be available`？
   因为 local operation verdict 仍不自动拥有替所有 surface 发布 stronger all-clear 的资格。

## 5. `McpAuthTool` 先证明：同一 auth/reconnect 主题的正向词法，仍要经过单独的 reassurance ceiling 治理

`McpAuthTool.ts:55-60,182-196` 很值钱。

这里最容易被忽略的不是它会发 auth URL，
而是它对正向 assurance 的强弱控制。

在 tool description 与 auth-url path 上，
repo 使用的是：

`Once the user completes authorization ... the server's real tools will become available automatically.`

它回答的是：

`这条 repair path 在设计上会自动把你送往下一步。`

但在 silent auth 完成的 path 上，
repo 又故意降成：

`The server's tools should now be available.`

这句非常关键。
因为它没有偷写成：

`The server is now connected.`
`The server is definitely available.`
`You can safely rely on all tools again.`

它只给出一个更窄、更谨慎的 reassurance：

`should now`

这说明 repo 并没有把“同一主题已被重讲”偷写成“所有正向词法都该等强”。

这条证据非常先进。
因为它把正向语言本身当成安全边界：

`路径说明可以更乐观，当前结论却仍要保留不确定性余量。`

换句话说，
`McpAuthTool` 证明了：

`auth story 已经被 reproject，不等于这个 tool-facing story 自动拥有 strongest reassurance ceiling。`

## 6. `MCPRemoteServerMenu` 再证明：`Authentication successful` 只是上游事实，不是最终的 all-clear signer

`MCPRemoteServerMenu.tsx:95-111,277-289` 更硬。

这里 repo 公开承认：

1. `Authentication successful. Connected to ...`
2. `Authentication successful, but server still requires authentication. You may need to manually restart Claude Code.`
3. `Authentication successful, but server reconnection failed. You may need to manually restart Claude Code for the changes to take effect.`

这三句共同说明一件事：

`authentication successful`

不是 strongest reassurance，
它只是一个上游事实。

真正更强的 reassurance 仍要继续看：

1. reconnect result 是不是 `connected`
2. 当前 reader surface 是否配把这份结果讲成 `Connected` / `Reconnected`
3. repo 是否还必须保留 `manual restart` 这样的 caveat

这里最值钱的不是“有错误分支”，
而是 repo 拒绝把：

`auth complete`

偷写成：

`all clear`

它甚至在正向前缀已经成立的情况下，
仍保留：

`still requires authentication`
`reconnection failed`
`may need to manually restart`

这说明 reassurance governance 的本体并不是“会不会说好消息”，
而是：

`正向消息允许强到什么程度。`

从安全设计看，
这是一种非常成熟的语义克制：
让本地可见成功不越级冒充全局可依赖成功。

## 7. `/mcp` health、`MCPReconnect` 与 `useMcpConnectivityStatus()` 共同证明：正向担保是分 reader、分 scope、分发布义务的

`handlers/mcp.tsx:26-35` 的 `/mcp` health 用的是：

1. `✓ Connected`
2. `! Needs authentication`
3. `✗ Failed to connect`

这是 probe-scope reassurance。
它只回答：

`当前检查结果如何。`

`MCPReconnect.tsx:40-63` 用的是：

1. `Successfully reconnected to ...`
2. `... requires authentication. Use /mcp to authenticate.`
3. `Failed to reconnect to ...`

这是 operation-scope reassurance。
它只回答：

`这次 reconnect operation 的结果如何。`

`useMcpConnectivityStatus.tsx:25-63` 则更进一步。
它只在：

1. `failed`
2. `needs-auth`

时主动发 notification，
不会发对称的 `connected` success toast。

这说明 repo 已经公开接受一条更深的边界：

1. health reader 只拿 probe reassurance
2. dialog reader 只拿 operation reassurance
3. notification surface 甚至可以故意拒绝发布正向 reassurance

这三条一起看，
就会发现：

`positive lexicon`

在 Claude Code 里根本不是免费的。

它受到至少三种约束：

1. reader scope
2. operation scope
3. publication duty

也就是说，
同一份已经 reprojected 的 current truth，
在 reassurance world 里仍然不是一个统一强度的对象。

## 8. 这层分化为什么先进：Claude Code 把“正向语言预算”本身做成了安全机制

这组源码真正先进的地方，
不是“文案写得细”，
而是它把正向 reassurance 当作一类要被治理的危险能力。

至少有四条技术启示：

### 启示一

repo 拒绝让 `one positive bit` 扇出到所有 surface。

也就是说，
它不接受：

`connected once -> every reader gets the same all-clear`

### 启示二

repo 把 caveat 保留能力当成正向诚实性的一部分。

`may need to manually restart`

不是 UX 噪音，
而是本地 success surface 拒绝替更大世界撒谎。

### 启示三

repo 把“沉默”也当成 reassurance governance 的正式动作。

notification 不发 success toast，
不是遗漏，
而是在避免制造过强承诺。

### 启示四

repo 把“依赖负荷”与“当前叙述”拆开了。

这意味着：

`能描述 current truth`

并不自动等于：

`能签发 stronger reliance permission`

从哲学上看，
这恰好回应了安全设计里最难的一件事：

`系统真正危险的往往不是负向拒绝说错，而是正向放心说早。`

## 9. 一条硬结论

这组源码真正说明的不是：

`cleanup 线未来只要补出 reprojection governance，就已经足够成熟。`

而是：

`repo 已经在 McpAuthTool 的 graded positive lexicon、MCPRemoteServerMenu 的 auth-success branching、MCPReconnect 的 operation-local success copy、/mcp health 的 narrow glyph reassurance，以及 useMcpConnectivityStatus 的 selective silence 上，明确展示了 reassurance governance 的存在；因此 artifact-family cleanup reprojection-governor signer 仍不能越级冒充 artifact-family cleanup reassurance-governor signer。`

因此：

`cleanup 线真正缺的，不只是“谁来重讲 current truth”，还包括“谁来决定这些讲述里，哪一些现在配承载多强的继续依赖担保”。`
