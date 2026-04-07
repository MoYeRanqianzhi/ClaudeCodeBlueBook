# buildMcpServerStatuses、useMcpConnectivityStatus与MCPReconnect的强请求清理重新投影治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `303` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 线未来谁来决定对象何时重新进入当前世界，`

而是：

`stronger-request cleanup 线一旦已经把对象重新并入当前世界，谁来决定这份 current truth 该怎样被 status、health、notification、dialog 与 control protocol 重新讲述给不同读者。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`reintegration governor 不等于 reprojection governor。`

这句话还不够硬。
所以这里单开一篇，
只盯住：

- `src/cli/print.ts`
- `src/hooks/notifs/useMcpConnectivityStatus.tsx`
- `src/commands/plugin/ManagePlugins.tsx`
- `src/components/mcp/MCPListPanel.tsx`
- `src/components/mcp/MCPReconnect.tsx`
- `src/cli/handlers/mcp.tsx`

把 structured status、enum status、notification policy、health glyph 与 reconnect copy 并排，
直接钉死 stronger-request cleanup 线当前仍缺的不是 current-world membership，
而是 `reader-facing reprojection governance grammar`。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 reintegration，没有 reprojection。`

而是：

`Claude Code 已经在 MCP 线上明确把“对象重新回到当前世界”和“这份当前真相怎样被不同 reader 重新讲述”拆成两层；stronger-request cleanup 线当前缺的不是文化，而是这套 reprojection governance 还没被正式接到旧 cleanup artifact family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| control projection | `src/cli/print.ts:1612-1626,2957-2960,3127-3128` | 为什么 control readers 读到的是结构化 current truth，而不是 raw reintegration state |
| manager / panel status grammar | `src/commands/plugin/ManagePlugins.tsx:512-519`; `src/components/mcp/MCPListPanel.tsx:306-337` | 为什么 UI status surface 会重新压缩同一 truth |
| selective notification grammar | `src/hooks/notifs/useMcpConnectivityStatus.tsx:25-63` | 为什么 notification surface 会选择性重讲某些 truth、沉默另一些 truth |
| health projection | `src/cli/handlers/mcp.tsx:26-35` | 为什么 health readers 拿到的是 glyph-level status，而不是 raw state object |
| dialog / action copy | `src/components/mcp/MCPReconnect.tsx:40-63` | 为什么 reconnect dialog 会用另一种 action-oriented 叙事重讲同一 truth |
| control envelope | `src/cli/print.ts:2736-2760` | 为什么 control response 还要对同一 truth 再次选择 success / error payload 形态 |

## 4. `buildMcpServerStatuses()` 先证明：control protocol 看到的是被重新组织过的 current truth

`src/cli/print.ts:1612-1626`
很值钱。

这里不是把 reintegrated connection 直接原样暴露出去，
而是重新组织成：

1. `McpServerStatus[]`
2. 结合 `currentAppState.mcp.clients`
3. 结合 `sdkClients`
4. 结合 `dynamicMcpState.clients`

随后
`src/cli/print.ts:2957-2960`
与
`src/cli/print.ts:3127-3128`
又明确把这份结构投影到：

1. `mcp_status`
2. `reload_plugins`

这说明 control protocol reader 拿到的，
不是 raw reintegration state，
而是专门给 control channel 重新压缩过的 current truth。

这条证据很硬。

它说明：

`reintegrated truth`

并不自动等于：

`control-reader-ready truth`

## 5. `getMcpStatus()` 与 `MCPListPanel` 再证明：UI status surface 会把同一 truth 压成不同语法强度

`src/commands/plugin/ManagePlugins.tsx:512-519`
的 `getMcpStatus()`
把 truth 压成：

`connected / disabled / pending / needs-auth / failed`

这是一种短枚举、便于上层统一消费的 manager grammar。

`src/components/mcp/MCPListPanel.tsx:306-337`
又把同一 truth 压成：

1. `disabled`
2. `connected`
3. `reconnecting (n/m)…`
4. `connecting…`
5. `needs authentication`
6. `failed`

也就是说，
同一份 current truth，
在 UI world 里本来就没有唯一句法。

repo 已经明确让：

`what this reader needs to know`

参与决定如何重新讲 truth。

## 6. `useMcpConnectivityStatus()` 证明：重新投影还包括“沉默治理”

`src/hooks/notifs/useMcpConnectivityStatus.tsx:25-63`
特别值钱。

这里只发：

1. `failed`
2. `needs-auth`

两类 notification。

它不会对：

1. `connected`
2. `pending`

发出对称的 success / recovering toast。

从第一性原理看，
这非常先进。

它说明 reprojection governance 的本体不只包含：

`怎么讲`

还包含：

`哪些 truth 此刻根本不该被主动讲`

这正是 reader-facing projection honesty。

## 7. `/mcp` health 与 `MCPReconnect` 再证明：health surface 和 dialog surface 各自拥有不同的重新讲述权

`src/cli/handlers/mcp.tsx:26-35`
把同一 truth 压成：

1. `✓ Connected`
2. `! Needs authentication`
3. `✗ Failed to connect`

这是 health-check reader 的 glyph grammar。

`src/components/mcp/MCPReconnect.tsx:40-63`
则把同一 truth 压成：

1. `Successfully reconnected to ...`
2. `... requires authentication. Use /mcp to authenticate.`
3. `Failed to reconnect to ...`

这里最值钱的不是“有两套文案”，
而是 repo 公开承认：

1. health reader 需要的是简短状态符号
2. dialog reader 需要的是 action-oriented operation story

这说明 reprojection governance 是对读者类型的正式分配，
不是对同一句 current truth 的机械复制。

## 8. `sendControlResponseSuccess()` / `sendControlResponseError()` 再证明：control plane 还要单独决定投影粒度

`src/cli/print.ts:2736-2760`
很值钱。

这里 control plane 本身就强制 truth 以：

1. `success`
2. `error`
3. optional `response payload`

的 envelope 重新输出。

即便面对同一份已经 reintegrated 的 current truth，
control reader 也未必总是拿到同样厚度的内容。

这说明即便 control protocol 自己，
也没有把 reintegrated truth 当成
“天然可直接发给读者”的东西。

它还要单独决定：

`这个读者现在该拿到多少 truth`

## 9. 更深一层的技术先进性：Claude Code 连“对象重新回到当前世界”和“这份当前真相怎样被重新讲述”都继续拆开

这组源码给出的技术启示至少有四条：

1. machine-readable control payload 是单独的治理层
2. manager/panel/health/dialog 的词法强度本来就不应强行统一
3. selective notification silence 是一种成熟的安全设计，而不是缺省遗漏
4. control envelope 本身也在治理 truth strength，而不是中立管道

用苏格拉底式反问压缩，
可以得到四个自检问题：

1. 如果对象已经并回当前世界，为什么 control reader 还需要单独的 `McpServerStatus[]`？
2. 如果同一份 current truth 适合所有读者，为什么 panel、health 与 dialog 要用不同句法？
3. 如果重投影只是“把真相都发出去”，为什么通知面只发 `failed / needs-auth` 而不发 success toast？
4. 如果 control response 只是运输容器，为什么它还要决定 success/error 以及 payload 是否附带？

## 10. 安全设计的哲学本质：真正被治理的不是“它是否已经回到当前世界”，而是“这份 current truth 该怎样被不同读者重新理解”

如果把这章压到最深处，
Claude Code 在这里展示的并不是普通的 UI 文案技巧，
而是一种更硬的安全哲学：

`membership in the world is not identical to intelligibility across readers.`

这套哲学至少包含四个原则：

1. `reader-specific honesty over one-size-fits-all wording`
2. `publication policy over reflexive broadcasting`
3. `payload strength over raw state dumping`
4. `surface pluralism over single-truth literalism`

所以这一层的哲学本质不是：

`它是不是已经回来`

而是：

`回来之后，不同读者现在应被允许怎样重新理解它。`

## 11. 苏格拉底式自我反思：如果要把这层分析做得更严，最该防什么偷换

第一问：

`我是不是把 current-world membership 误判成了 reader-facing expression 已经完成？`

如果是，
`buildMcpServerStatuses()` 与多 surface grammar 的分层已经直接反驳我。

第二问：

`我是不是把某一个 surface 的 status text 误判成了全部读者的 current truth？`

如果是，
panel、health、notification 与 control payload 的差异已经直接反驳我。

第三问：

`我是不是把选择性沉默误判成了没有完成投影？`

如果是，
`useMcpConnectivityStatus()` 只发 `failed / needs-auth` 的政策已经直接反驳我。

第四问：

`我是不是把 control envelope 误判成了中立管道，而没看到它也在分配真相强度？`

如果是，
`sendControlResponseSuccess()` / `sendControlResponseError()` 的 envelope discipline 已经直接反驳我。

第五问：

`我是不是又在 reprojection 层偷偷带入了 reassurance 的 stronger judgment？`

如果是，
我就需要立刻收手。
因为这一章最硬的纪律就是：

`只证明“并回当前世界后的真相怎样被不同读者重讲”，不越级证明“这些重讲现在配承载多强的继续依赖担保”。`
