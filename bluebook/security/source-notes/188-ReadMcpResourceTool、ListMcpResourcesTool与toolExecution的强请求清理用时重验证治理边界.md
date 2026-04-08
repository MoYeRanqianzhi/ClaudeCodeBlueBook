# ReadMcpResourceTool、ListMcpResourcesTool与toolExecution的强请求清理用时重验证治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `337` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 线未来谁来决定不同 surface 现在最多可以放心到什么程度，`

而是：

`stronger-request cleanup 线一旦已经给出了某种 reassurance，谁来决定真正 consumer 在实际依赖瞬间还必须重新验真什么。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`reassurance governor 不等于 use-time-revalidation governor。`

这句话还不够硬。
所以这里单开一篇，
只盯住：

- `src/tools/ReadMcpResourceTool/ReadMcpResourceTool.ts`
- `src/tools/ListMcpResourcesTool/ListMcpResourcesTool.ts`
- `src/services/mcp/client.ts`
- `src/services/tools/toolExecution.ts`

把 consumer hard gate、fresh reconnect primitive、connected-only helper context 与 runtime demotion 并排，
直接钉死 stronger-request cleanup 线当前仍缺的不是 reassurance，
而是 `current-use proof grammar`。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 reassurance，没有 revalidation。`

而是：

`Claude Code 已经在 MCP 线上明确把“某个 surface 现在可以说多强的正向 reassurance”和“真正 consumer 在依赖瞬间是否还要 fresh re-check”拆成两层；stronger-request cleanup 线当前缺的不是文化，而是这套 use-time-revalidation governance 还没被正式接到旧 cleanup artifact family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| resource read gate | `src/tools/ReadMcpResourceTool/ReadMcpResourceTool.ts:86-97` | 为什么 read consumer 不会把旧 reassurance 直接当成 current-use proof |
| batch list gate | `src/tools/ListMcpResourcesTool/ListMcpResourcesTool.ts:81-88` | 为什么 list consumer 也要在使用前 fresh reconnect |
| fresh proof primitive | `src/services/mcp/client.ts:1688-1699` | 为什么真正依赖前还要重新 `connectToServer()`，而不是沿用旧 `connected` |
| execution-context filter | `src/services/tools/toolExecution.ts:308-326` | 为什么连工具执行的辅助上下文也只承认 current connected truth |
| runtime revocation | `src/services/tools/toolExecution.ts:1599-1618` | 为什么真实 use path 会在 auth failure 上即时撤销旧 reassurance |

## 4. `ReadMcpResourceTool` 先证明：read consumer 明确拒绝把 reassurance 当成免检通行证

`ReadMcpResourceTool.ts:86-97`
很值钱。

这里的顺序非常严格：

1. 找到目标 server
2. 若 `client.type !== 'connected'`，直接失败
3. 即便当前看起来已是 `connected`，仍继续 `ensureConnectedClient(client)`
4. 然后才真正发起 `resources/read`

这说明 repo 对 read consumer 的制度不是：

`既然前面某个 surface 刚说可用，现在就先信再说`

而是：

`真正 read 之前，再确认一次它现在是否仍然 connected`

最值钱的技术启示是：

`current-use truth` 的签字点不在 reassurance surface，
而在 consumer edge。

## 5. `ListMcpResourcesTool` 再证明：即便是看起来较弱的 browse path，也仍需要 live freshness proof

`ListMcpResourcesTool.ts:81-88`
特别值钱。

repo 在注释里直接写出：

1. resource cache 已由 `resources/list_changed` 与 `onclose` 处理
2. healthy 时 `ensureConnectedClient` 是 no-op
3. after `onclose` it returns a fresh connection so the re-fetch succeeds

这说明 list path 的制度不是：

`反正只是列一下资源，旧 reassurance 足够`

而是：

`只要进入真正的 consumer path，就要重新问 current-use proof 现在还在不在`

这条证据尤其有价值，
因为它说明 use-time revalidation 不是只在最危险的 write path 才存在，
而是连 browse/list 这类看似更温和的 consumer path 也同样遵守。

## 6. `ensureConnectedClient()` 再证明：repo 把真正可依赖的 current-use truth 收束成 reconnect-or-throw primitive

`client.ts:1688-1699`
很硬。

这段代码做的事情几乎可以压成一个制度公式：

`old connected label -> reconnect -> connected or throw`

它不接受第三种状态。

尤其值钱的是：

1. SDK path 可以直接复用
2. 其他 transport 一律重新 `connectToServer`
3. fresh 结果不是 `connected` 就立即报错

这说明 repo 真正承认的 current-use truth 不是：

`它之前看起来是 connected`

而是：

`它在真正使用这一刻重新被 fresh enough 地证明为 connected`

这条 primitive 把 use-time revalidation 从抽象哲学直接落成了具体工程语法。

## 7. `toolExecution` 再证明：执行平面连辅助 metadata 都要 obey current connected truth

`toolExecution.ts:308-326`
先给出一组很硬的正例。

这里：

1. `getMcpServerType()` 只有在 `serverConnection?.type === 'connected'` 时才返回 transport type
2. `getMcpServerBaseUrlFromToolName()` 只有在 `serverConnection?.type === 'connected'` 时才返回 base URL

这说明 repo 连“给一次 tool execution 补什么 transport / base-url 背景”这类辅助信息，
都不愿意沿用 stale reassurance。

换句话说，
execution plane 不是只在最核心的 request path 严格，
它在外围 metadata 上也坚持：

`connected now or nothing`

这比“只让 tool body 严格、其余上下文宽松”要先进得多。

因为一旦 helper context 允许 stale truth 残留，
系统就会在真正调用前就被污染。

## 8. `McpAuthError -> needs-auth` 再证明：live contradiction 在 repo 里拥有撤销旧 reassurance 的更高主权

`toolExecution.ts:1599-1618`
更关键。

一旦真实 tool use 遇到 `McpAuthError`，
repo 会立刻：

1. 找到对应 server
2. 只在原状态仍是 `connected` 时执行改写
3. 把 client 降成 `needs-auth`

这里最值钱的不是它会报错，
而是它会主动撤销旧的 connected reassurance，
把 live contradiction 写回 current state。

这说明 use-time revalidation 不是：

`验证失败了就算了，旧 reassurance 还能挂着`

而是：

`验证失败了，旧 reassurance 必须让位于当前矛盾事实`

这是一条非常成熟的安全设计原则：

`运行时反证比既有正向话术更有主权`

## 9. 这篇源码剖面给主线带来的五条技术启示

### 启示一

真正 consumer edge 的 fresh proof 永远不该被 earlier reassurance 冒充。

### 启示二

current-use truth 最好收束成少数 canonical primitives，例如 reconnect-or-throw。

### 启示三

helper metadata 也应 obey current truth，而不只是让核心操作严格。

### 启示四

list / browse 这类较弱 consumer path 同样需要 freshness discipline，不能因为“看起来风险小”就放宽。

### 启示五

runtime contradiction 应该拥有正式的 revocation 主权，而不是只留下日志或局部异常。

## 10. 用苏格拉底式反问压缩这篇源码剖面的核心

可以得到五个自检问题：

1. 如果 earlier reassurance 已经足够，为什么 `ReadMcpResourceTool` 还要继续 `ensureConnectedClient()`？
2. 如果 browse path 不需要 fresh proof，为什么 `ListMcpResourcesTool` 明写 `onclose` 后要拿 fresh connection？
3. 如果旧 `connected` label 已经等于 current-use truth，为什么 repo 还需要 reconnect-or-throw primitive？
4. 如果 helper context 可以复用旧结论，为什么 disconnected path 的 transport/base-url 直接变成 `undefined`？
5. 如果 runtime contradiction 只是局部异常，为什么 `McpAuthError` 会直接把 client 降成 `needs-auth`？

这些反问共同逼出同一个结论：

`Claude Code 不只在治理让你放心多少，也在治理你这一刻是否真的配去用。`
