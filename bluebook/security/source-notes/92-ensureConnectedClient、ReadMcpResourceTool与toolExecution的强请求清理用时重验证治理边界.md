# ensureConnectedClient、ReadMcpResourceTool与toolExecution的强请求清理用时重验证治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `241` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 线未来谁来决定不同 surface 现在可以放心到什么程度，`

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

把 consumer hard gate、fresh reconnect primitive、execution-context filter 与 runtime demotion 并排，
直接钉死 stronger-request cleanup 线当前仍缺的不是 reassurance，
而是 `use-time-revalidation governance grammar`。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 reassurance，没有 revalidation。`

而是：

`Claude Code 已经在 MCP 线上明确把“某个 surface 现在可以说多强的正向 reassurance”和“真正 consumer 在依赖瞬间是否还要 fresh re-check”拆成两层；stronger-request cleanup 线当前缺的不是文化，而是这套 use-time-revalidation governance 还没被正式接到旧 cleanup artifact family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| resource read gate | `src/tools/ReadMcpResourceTool/ReadMcpResourceTool.ts:72-100` | 为什么 read consumer 不会把旧 reassurance 直接当成 current-use proof |
| batch list gate | `src/tools/ListMcpResourcesTool/ListMcpResourcesTool.ts:71-92` | 为什么 list consumer 也要在使用前 fresh reconnect |
| fresh proof primitive | `src/services/mcp/client.ts:1688-1705` | 为什么真正依赖前还要重新 `connectToServer()`，而不是沿用旧 `connected` |
| execution-context filter | `src/services/tools/toolExecution.ts:308-335` | 为什么连工具执行的辅助上下文也只承认 current connected truth |
| runtime revocation | `src/services/tools/toolExecution.ts:1599-1624` | 为什么真实 use path 会在 auth failure 上即时撤销旧 reassurance |

## 4. `ReadMcpResourceTool` 与 `ListMcpResourcesTool` 先证明：consumer edge 拒绝把 reassurance 当成免检通行证

`ReadMcpResourceTool.ts:72-100`
很值钱。

这里的顺序非常严格：

1. 找到目标 server
2. 若 `client.type !== 'connected'`，直接失败
3. 即便当前看起来是 `connected`，仍继续 `ensureConnectedClient(client)`
4. 然后才真正发起 `resources/read`

这说明 repo 对 read consumer 的制度不是：

`既然前面某个 surface 刚说可用，现在就先信再说`

而是：

`真正 read 之前，再确认一次它现在是否仍然 connected`

`ListMcpResourcesTool.ts:71-92`
更值钱。

它不仅复用 `ensureConnectedClient(client)`，
还公开写出：

1. healthy 时这是 no-op
2. after `onclose` it returns a fresh connection so the re-fetch succeeds

这条注释直接说明：

`真正 consumer 在使用前重新拿 fresh proof，不是 incidental implementation detail，而是 repo 明确承认的语义边界`

也就是说，
consumer edge 的世界观是：

`positive reassurance can invite use; only fresh revalidation can authorize use`

## 5. `ensureConnectedClient()` 再证明：current-use truth 的 canonical 形态就是 reconnect-or-throw

`client.ts:1688-1705`
很硬。

`ensureConnectedClient()` 的制度非常简单：

1. SDK client 原样返回
2. 其他 client 一律重新 `connectToServer(client.name, client.config)`
3. 若 fresh 结果不再是 `connected`，直接抛
   `MCP server "<name>" is not connected`
4. 只有 fresh 结果成立时，才返回 connected client

这说明 repo 并没有把：

`旧的 connected label`

当成 durable live-use truth。

它真正承认的是：

`当前使用资格只有两种状态：要么 fresh enough，所以继续；要么 fresh proof 不成立，所以立刻失败`

这条证据非常值钱。

因为它把“真正使用时的 current truth”从正向文案、health glyph、dialog success 里彻底抽出来，
单独交给了一个 fresh proof primitive。

## 6. `toolExecution` 再证明：执行平面连辅助上下文都要 current connected truth，而且会在 live failure 上立即撤销旧 reassurance

`toolExecution.ts:308-335`
先给出一组很硬的正例。

这里：

1. `getMcpServerType()` 只有在 `serverConnection?.type === 'connected'` 时才返回 transport type
2. `getMcpServerBaseUrlFromToolName()` 只有在 `serverConnection?.type === 'connected'` 时才返回 base URL

这说明 repo 连“给工具执行补什么 transport / base-url 背景”这类辅助信息，
都不愿意沿用 stale reassurance。

换句话说，
execution plane 不是只在最核心的 tool body 里严格，
它在外围 metadata 上也坚持：

`current connected truth first`

`1599-1624`
更关键。

一旦真实 tool use 遇到 `McpAuthError`，
系统就会：

1. 找到对应 server
2. 只在它当前还是 `connected` 时
3. 立即把它降成 `needs-auth`

这条边界极其重要。

因为它说明 use-time revalidation 的职责不只是：

`入场前再查一次`

还包括：

`使用中一旦发现刚才那句 reassurance 已经失真，立刻把它撤回`

这比“有失败处理”更强。
它是 live-use revocation discipline。

## 7. 这篇源码剖面给主线带来的五条技术启示

### 启示一

repo 已经在 consumer-edge hard gate 上明确展示：

`正向 reassurance 不等于免检消费权`

### 启示二

repo 已经在 `ensureConnectedClient()` 上明确展示：

`fresh reconnect primitive` 应当成为 current-use truth 的 canonical form

### 启示三

repo 已经在 list/read path 上明确展示：

`真正的依赖入口应该共享同一套 live gate，而不是各自相信上游的好消息`

### 启示四

repo 已经在 execution-context filter 上明确展示：

`辅助上下文也应受用时重验证约束`

### 启示五

repo 已经在 runtime demotion 上明确展示：

`一旦 live contradiction 出现，旧 reassurance 必须拥有被即时撤销的路径`

## 8. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 线未来只要补出 reassurance grammar，就已经足够成熟。`

而是：

`repo 已经在 ReadMcpResourceTool 与 ListMcpResourcesTool 的 consumer-edge hard gate、ensureConnectedClient() 的 fresh reconnect primitive，以及 toolExecution.ts 的 current-context filter 与 McpAuthError demotion 上，明确展示了 use-time-revalidation governance 的存在；因此 artifact-family cleanup stronger-request cleanup-reassurance-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-use-time-revalidation-governor signer。`

因此：

`stronger-request cleanup 线真正缺的，不只是“谁来决定现在可以说多放心”，还包括“谁来决定真正消费这一刻，这份放心话是否仍配被当真”。`
