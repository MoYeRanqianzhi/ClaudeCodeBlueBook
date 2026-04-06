# 安全资格承诺上限：为什么每一种中间态都只能说到自己的ceiling，不能把pending说成active

## 1. 为什么在 `96` 之后还必须继续写“资格承诺上限”

`96-安全资格中间态语法` 已经回答了：

`不同资格中间态必须保持不同语义，不能压平。`

但如果继续往下追问，  
还会碰到一个更产品化、也更危险的问题：

`既然语义不同，系统到底最多可以把每一种状态说多满？`

这时问题已经不再只是：

`状态名是什么`

而变成：

`该状态最多允许界面、通知、footer、错误文案承诺到什么程度`

这就是 `96` 之后必须继续补出的下一层：

`安全资格承诺上限`

也就是：

`每一种中间态都只能说到自己的 lexical ceiling，不能把 pending 说成 active，不能把 fresh-session-fallback 说成原 session 已恢复。`

## 2. 最短结论

从源码看，Claude Code 已经在多个子系统里自然形成了不同状态对应的文案 ceiling：

1. bridge 只有在 `sessionActive || connected` 时才允许说 `Remote Control active`，reconnecting 只能说 `Remote Control reconnecting`  
   `src/bridge/bridgeStatusUtil.ts:123-140`
2. bridge env mismatch 时只能说 `Creating a fresh session instead`，而不是“已恢复原 session”  
   `src/bridge/bridgeMain.ts:2473-2489`
3. transient reconnect 只能说 `may still be resumable`，不能说“已恢复”  
   `src/bridge/bridgeMain.ts:2524-2539`
4. plugin `needsRefresh` 只能说 `Plugins changed. Run /reload-plugins to activate.`，也就是变化已发生、激活未完成  
   `src/hooks/useManagePlugins.ts:293-301`
5. MCP `pending` 只能显示 `connecting...` 或 `reconnecting (...)...`，`disabled` 只能显示 `disabled`，`connected` 才能显示 `connected`  
   `src/components/mcp/MCPListPanel.tsx:307-325`

所以这一章的最短结论是：

`Claude Code 的安全文案不是自由描述，而是状态语义决定的承诺 ceiling。`

再压成一句：

`状态一旦没到，语言就不配先到。`

## 3. bridge 子系统已经把承诺 ceiling 写进状态映射

## 3.1 `active` 这个词只有在资格已回到 current 时才配出现

`src/bridge/bridgeStatusUtil.ts:123-140` 是非常直接的证据。

这里状态映射很清楚：

1. `error` -> `Remote Control failed`
2. `reconnecting` -> `Remote Control reconnecting`
3. `sessionActive || connected` -> `Remote Control active`
4. 否则 -> `Remote Control connecting...`

这意味着 `active` 不是一个宽松的鼓励性词汇，  
而是一个有严格前提的高承诺词。

只有在：

`资格已经回到 current`

时，它才允许出现。

这说明 bridge 子系统已经内建了一条语言纪律：

`不要把连通中的、回连中的、失败中的状态说成 active。`

## 3.2 reconnecting 不是弱一点的 active，而是另一种完全不同的语义

很多系统会把 reconnecting 当成“差一点就 active”。  
Claude Code 没这么处理。

在 `bridgeStatusUtil.ts` 里，  
`reconnecting` 有自己的 label、自己的 color：

`Remote Control reconnecting`

这表明它不是 active 的浅色版，  
而是：

`资格暂未回到 current，但路径仍在`

也就是说，  
它有自己的 promise ceiling：

1. 可以承诺正在回连
2. 不可以承诺已经恢复

## 3.3 `failed` 的 ceiling 也不同，它不应偷带 retryable 或 active 暗示

同一段映射里，  
只要 `error` 出现，  
label 就直接是：

`Remote Control failed`

这很重要。  
因为它说明 bridge UI 没有把所有异常都压成“reconnecting”。

换句话说：

1. `reconnecting`
   仍带正向恢复路径
2. `failed`
   至少当前视角下不配继续给出正向 active 承诺

这就是承诺 ceiling 的区分。

## 4. bridge CLI 主线进一步证明：fallback 与 retryable 的 ceiling 不能混用

## 4.1 env mismatch 只能说 fresh-session-fallback，不能说原 session 已恢复

`src/bridge/bridgeMain.ts:2473-2489` 的 warning 文案非常关键：

`Could not resume session ... its environment has expired. Creating a fresh session instead.`

这句文案之所以成熟，  
就在于它把承诺 ceiling 控得很死：

1. 承认原 session 没恢复成功
2. 承认接下来会创建 fresh session
3. 明确避免把新资格包装成旧资格已恢复

这说明 `fresh-session-fallback` 的 ceiling 是：

`新资格即将被签发`

而不是：

`原资格已经回来`

## 4.2 retryable resume 的 ceiling 只能到“仍可恢复”，不能到“已恢复”

`src/bridge/bridgeMain.ts:2524-2539` 里的错误文案同样很克制：

`The session may still be resumable — try running the same command again.`

这里最关键的是 `may still be resumable`。

它不是：

`resumable`

更不是：

`recovered`

作者明显是在控制语言的承诺强度：

1. 允许表达剩余恢复价值
2. 不允许跳过后续验证，提前宣布结果

这说明 `retryable resumable` 的 ceiling 是：

`仍可尝试`

而不是：

`已经恢复`

## 5. plugin 子系统已经把 `needsRefresh` 的 ceiling 写进 notification 文案

## 5.1 `activate` 被绑定在用户动作之后，而不是当前状态本身

`src/hooks/useManagePlugins.ts:293-301` 的 notification 文案是：

`Plugins changed. Run /reload-plugins to activate.`

这句话很短，但制度意味非常强。

它明确做了三件事：

1. 承认变化已发生
2. 承认 activation 还没发生
3. 把 activation 绑定到一个未来动作 `/reload-plugins`

所以 `needsRefresh` 的 ceiling 只能到：

`changed`

以及

`可以通过某动作完成 activation`

但它绝不能直接说：

`activated`

## 5.2 为什么这里不用“updated and active”

因为从源码设计看，  
`needsRefresh` 本质上就是：

`materialization 已发生，但 active entitlement 尚未签发`

一旦文案越过这个 ceiling，  
就会把：

`未来动作的结果`

伪装成

`当前状态的事实`

所以 plugin 通知之所以成熟，  
不在于它提醒了用户，  
而在于它没有说过头。

## 6. MCP 子系统已经把不同 state 的文案 ceiling 压成更细的状态词

## 6.1 `connected`、`pending/reconnecting`、`disabled` 各自有不同 ceiling

`src/components/mcp/MCPListPanel.tsx:307-325` 非常有价值。

这里文本映射是：

1. `disabled` -> `disabled`
2. `connected` -> `connected`
3. `pending + reconnectAttempt` -> `reconnecting (x/y)...`
4. `pending` -> `connecting...`
5. `needs-auth` -> `needs authentication`

这说明 MCP 面板没有把这些状态统称成“available soon”。

相反，它给每个状态都设了清晰 ceiling：

1. `connected`
   才能说连接已建立
2. `connecting...`
   只能承诺正在尝试建立
3. `reconnecting (...)...`
   只能承诺重连流程在推进
4. `disabled`
   只能承认策略关闭
5. `needs authentication`
   只能承认资格缺口在 auth 上

## 6.2 为什么 `disabled` 不能被说成“暂时连不上”

因为 `disabled` 的问题不是连通性，  
而是：

`策略层不允许`

如果把它说成“connecting...”或“pending”，  
就会把：

`policy block`

误说成

`eventual success`

这会直接误导用户采取错误动作。  
所以 `disabled` 必须有自己更低的 ceiling。

## 6.3 为什么 `needs-auth` 也不能被压成 `pending`

同理，`needs authentication` 并不是：

`连接还没来得及成功`

而是：

`当前缺的不是时间，而是 auth prerequisite`

它的 ceiling 必须体现这个因果断点。  
否则系统会让用户误等一个根本不会自动成功的状态。

## 7. 这套设计背后的哲学本质

这一章最重要的哲学结论是：

`语言本身也是权限。`

也就是说，  
系统一旦说出：

1. `active`
2. `connected`
3. `activated`
4. `resumable`

这类词，  
就已经在替当前状态签发一种资格承诺。

所以文案不是装饰层，  
而是：

`资格控制面的外层签字`

Claude Code 做得成熟的地方在于，  
它没有让语言脱离状态制度自由生长，  
而是让语言服从状态 ceiling。

这就是它在安全设计上的先进性之一：

`不仅对象要受权限治理，描述对象的语言也要受权限治理。`

## 8. 第一性原理：为什么状态越模糊，语言越危险

如果从第一性原理问：

`为什么一个中间态最危险的往往不是逻辑错，而是文案过满？`

答案是：

`因为文案过满会在对象尚未获得资格时，提前为它发放社会性与交互性的认可。`

一旦用户看到：

1. `active`
2. `connected`
3. `updated`
4. `restored`

他们就会自然推导：

`我现在可以按这个前提行动。`

这时即使底层对象还没完成重签发，  
系统也已经通过语言把用户推进了错误世界模型。

所以安全控制面必须守住一条原则：

`状态越不确定，语言越要克制。`

## 9. 苏格拉底式自我反思

可以继续问六个问题：

1. 如果 `reconnecting` 与 `active` 的差异这么重要，当前所有 surface 都保证了同样的 ceiling 吗？
2. 如果 `needsRefresh` 只能承诺 changed-not-activated，是否还有其他 plugin surface 在偷偷说得过满？
3. 如果 `pending` 与 `disabled` 的 ceiling 不同，是否所有列表、提示、SDK 输出都保持了一致？
4. 如果 `fresh-session-fallback` 本质是新资格签发，是否还应该在 UI 上更显式地告知“这不是原 session”？
5. 如果 `retryable resumable` 只能到 may-still-be，是否还存在某些快捷路径在文案上把它误说成 recoverable？
6. 如果语言也是权限，下一代控制台是否应该把每个状态的 lexical ceiling 编码成统一 schema，而不是散落在各组件里？

这些问题都说明：

Claude Code 已经有很强的语言纪律，  
但仍可以再产品化一步：

`把文案 ceiling 变成显式协议。`


## 11. 给系统设计者的技术启示

最后把这一章压成六条工程启示：

1. 不要让 UI 文案先于状态资格抵达高承诺词
2. 为每一种中间态定义显式 lexical ceiling
3. `active/connected/activated` 这类高承诺词必须只由 high-confidence state 触发
4. `pending/reconnecting/needs-auth/disabled` 这些词不能互相替代
5. 把 future action 和 current fact 在文案里严格分开
6. 语言若不受权限治理，整个安全控制面会在解释层失真

这一章最终要守住的一条硬结论是：

`对 Claude Code 这类安全控制面来说，真正成熟的不是状态够多，而是每一种状态都只被允许说到自己配说的程度。`
