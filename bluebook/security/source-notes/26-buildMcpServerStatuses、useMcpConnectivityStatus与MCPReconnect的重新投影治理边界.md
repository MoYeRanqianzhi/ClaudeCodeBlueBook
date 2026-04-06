# buildMcpServerStatuses、useMcpConnectivityStatus 与 MCPReconnect 的重新投影治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `175` 时，
真正需要被单独钉住的已经不是：

`cleanup 线未来谁来决定对象何时重新进入当前世界，`

而是：

`cleanup 线一旦已经把对象重新并入当前世界，谁来决定这份 current truth 该怎样被 status、health、notification、dialog 与 control protocol 重新讲述给不同读者。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`reintegration governor 不等于 reprojection governor。`

这句话还不够硬。
所以这里单开一篇，只盯住：

- `src/cli/print.ts`
- `src/hooks/notifs/useMcpConnectivityStatus.tsx`
- `src/commands/plugin/ManagePlugins.tsx`
- `src/components/mcp/MCPListPanel.tsx`
- `src/components/mcp/MCPReconnect.tsx`
- `src/cli/handlers/mcp.tsx`

把 structured status、enum status、notification policy、health glyph 与 reconnect copy 并排，
逼出一句更硬的结论：

`Claude Code 已经在 MCP 线上明确展示：对象重新并回当前世界，并不自动回答不同读者现在该看到什么版本的当前真相；cleanup 线当前缺的不是这种思想，而是这套 reprojection governance 还没被正式接到旧 path、旧 promise 与旧 receipt 世界上。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 reintegration，没有 reprojection。`

而是：

`Claude Code 已经在 MCP 线上明确把“对象重新回到当前世界”和“这份当前真相怎样被不同 reader 重新讲述”拆成两层；cleanup 线当前缺的不是文化，而是这套 reprojection governance 还没被正式接到旧 cleanup artifact family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| control projection | `src/cli/print.ts:1610-1698,2957-2960,3127-3128` | 为什么 control readers 读到的是结构化 current truth，而不是 raw reintegration state |
| manager/panel status grammar | `src/commands/plugin/ManagePlugins.tsx:512-519`; `src/components/mcp/MCPListPanel.tsx:307-337` | 为什么 UI status surface 会重新压缩同一 truth |
| selective notification grammar | `src/hooks/notifs/useMcpConnectivityStatus.tsx:25-63` | 为什么 notification surface 会选择性重讲某些 truth、沉默另一些 truth |
| health projection | `src/cli/handlers/mcp.tsx:26-35` | 为什么 health readers 拿到的是 glyph-level status，而不是 raw state object |
| dialog/action copy | `src/components/mcp/MCPReconnect.tsx:40-63` | 为什么 reconnect dialog 会用另一种 action-oriented 叙事重讲同一 truth |
| control envelope | `src/cli/print.ts:2736-2758,3148-3204,3258-3295` | 为什么 control response 还要对同一 truth 再次选择 success/error payload 形态 |

## 4. `buildMcpServerStatuses()` 先证明：control protocol 看到的是被重新组织过的 current truth

`print.ts:1610-1698` 很值钱。

这里不是把 reintegrated connection 直接原样暴露出去，
而是重新组织成：

1. `status`
2. `serverInfo`
3. `error`
4. `config`
5. `scope`
6. `tools`
7. `capabilities`

随后 `2957-2960` 与 `3127-3128` 又明确把这份结构投影到：

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

`ManagePlugins.tsx:512-519` 的 `getMcpStatus()` 把 truth 压成：

`connected / disabled / pending / needs-auth / failed`

这是一种短枚举、便于上层统一消费的 manager grammar。

`MCPListPanel.tsx:307-337` 又把同一 truth 压成：

1. `connected`
2. `reconnecting (n/m)…`
3. `connecting…`
4. `needs authentication`
5. `failed`

也就是说，
同一份 current truth，
在 UI world 里本来就没有唯一句法。

repo 已经明确让：

`what this reader needs to know`

参与决定如何重新讲 truth。

## 6. `useMcpConnectivityStatus()` 证明：重新投影还包括“沉默治理”

`useMcpConnectivityStatus.tsx:25-63` 特别值钱。

这里只发：

1. `failed`
2. `needs-auth`

两类 notification。

它不会对：

1. `connected`
2. `pending`

发出对称的 success/recovering toast。

从第一性原理看，
这非常先进。

它说明 reprojection governance 的本体不只包含：

`怎么讲`

还包含：

`哪些 truth 此刻根本不该被主动讲`

这正是 reader-facing projection honesty。

## 7. `/mcp` health 与 `MCPReconnect` 再证明：health surface 和 dialog surface 各自拥有不同的重新讲述权

`handlers/mcp.tsx:26-35` 把同一 truth 压成：

1. `✓ Connected`
2. `! Needs authentication`
3. `✗ Failed to connect`

这是一种 health-check reader 的 glyph grammar。

`MCPReconnect.tsx:40-63` 则把同一 truth 压成：

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

`print.ts:2736-2758` 很值钱。

这里 control plane 本身就强制 truth 以：

1. `success`
2. `error`
3. optional `response payload`

的 envelope 重新输出。

再看 `3148-3204` 与 `3258-3295`，
就会发现同一 reintegrated truth 在 control plane 里仍要继续被裁成：

1. success with no payload
2. error with `Server status: ...`
3. structured status payload

这说明即便 control protocol 自己，
也没有把 reintegrated truth 当成“天然可直接发给读者”的东西。

它还要单独决定：

`这个读者现在该拿到多少 truth`

## 9. 这篇源码剖面给主线带来的四条技术启示

### 启示一

repo 已经在 control status builder 上明确展示：

`reintegrated truth != structured control projection`

### 启示二

repo 已经在 notification hook 上明确展示：

`reintegrated truth != mandatory publication`

### 启示三

repo 已经在 health/dialog 双 surface 上明确展示：

`same truth != same lexicon`

### 启示四

repo 已经在 control response envelope 上明确展示：

`same truth != same payload granularity`

这四句合起来，
正好说明为什么 cleanup 线未来不能把 reintegration governance 直接偷写成 complete reprojection。

## 10. 一条硬结论

这组源码真正说明的不是：

`cleanup 线未来只要补出 reintegration governance，就已经足够成熟。`

而是：

`repo 在 buildMcpServerStatuses 的 control projection、ManagePlugins/MCPListPanel 的 status grammar、useMcpConnectivityStatus 的 selective publication policy、handlers/mcp 的 health glyph grammar、MCPReconnect 的 action copy，以及 sendControlResponseSuccess/sendControlResponseError 的 payload shaping 上，已经明确展示了 reprojection governance 的存在；因此 artifact-family cleanup reintegration-governor signer 仍不能越级冒充 artifact-family cleanup reprojection-governor signer。`

因此：

`cleanup 线真正缺的不是“谁来把它接回当前世界”，而是“谁来决定接回之后不同读者现在该看到什么版本的当前真相”。`
