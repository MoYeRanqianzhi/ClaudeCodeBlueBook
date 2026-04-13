# ensureConnectedClient、useManageMCPConnections、toolExecution与AgentTool的强请求清理用时重验证治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `432` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 线未来谁来决定不同 surface 现在可以把话说多放心，`

而是：

`stronger-request cleanup 线一旦已经给出了 reassurance，谁来决定真正 consumer 在依赖发生这一刻还必须重新验真什么，以及旧 reassurance 在什么时候必须被正式撤销。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`reassurance governor 不等于 use-time revalidation governor。`

这句话还不够硬。

所以这里单开一篇，
只盯住：

- `src/services/mcp/client.ts`
- `src/services/mcp/useManageMCPConnections.ts`
- `src/services/tools/toolExecution.ts`
- `src/tools/ReadMcpResourceTool/ReadMcpResourceTool.ts`
- `src/tools/ListMcpResourcesTool/ListMcpResourcesTool.ts`
- `src/tools/AgentTool/AgentTool.tsx`

把 `connect-or-throw` primitive、session recovery、tool roster freshness、current-tool filter、consumer-edge live gate 与 agent-edge actual-tools gate 并排，
直接钉死 stronger-request cleanup 线当前仍缺的不是 reassurance，
而是 `use-time revalidation governance grammar`。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 reassurance，没有 revalidation。`

而是：

`Claude Code 已经在 MCP 线上明确把“某个 surface 现在可以说多强的正向 reassurance”和“真正 consumer 在依赖瞬间是否还要 fresh re-check current world”拆成两层；stronger-request cleanup 线当前缺的不是文化，而是这套 use-time revalidation grammar 还没被正式接到旧 cleanup artifact family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| fresh connection primitive | `src/services/mcp/client.ts:1688-1703` | 为什么真正依赖前还要重新 `connectToServer()`，而不是沿用旧 `connected` |
| session recovery retry | `src/services/mcp/client.ts:1858-1922` | 为什么每次真正 tool use 前仍要经过 fresh-proof primitive，并在 session-expired 后重试 |
| runtime contradiction revocation | `src/services/mcp/client.ts:3200-3230` | 为什么 401 / expired session 会即时撤销旧 reassurance |
| tool roster freshness | `src/services/mcp/useManageMCPConnections.ts:620-656` | 为什么 tool list 本身也必须在 runtime 保持 current |
| current-tool hard filter | `src/services/tools/toolExecution.ts:337-390` | 为什么历史 tool 名不拥有继续停留在 current execution world 的资格 |
| consumer/agent edge sovereignty | `src/tools/ReadMcpResourceTool/ReadMcpResourceTool.ts:80-100`; `src/tools/ListMcpResourcesTool/ListMcpResourcesTool.ts:79-89`; `src/services/mcp/client.ts:2073-2080`; `src/tools/AgentTool/AgentTool.tsx:369-408` | 为什么真正 consumer 与 agent edge 都拒绝盲信上游 reassurance |

## 4. `client.ts` 先证明：current-use truth 的 canonical 形态不是旧标签，而是 fresh-proof primitive 加 runtime contradiction discipline

`src/services/mcp/client.ts:1688-1703`
很硬。

`ensureConnectedClient()` 的制度非常简单：

1. SDK client 原样返回
2. 其他 client 一律重新 `connectToServer(client.name, client.config)`
3. 若 fresh 结果不再是 `connected`，直接抛 `MCP server "<name>" is not connected`
4. 只有 fresh 结果成立时，才返回 connected client

这说明 repo 并没有把：

`旧的 connected label`

当成 durable current-use truth。

它真正承认的是：

`当前使用资格只有两种状态：要么 fresh enough，所以继续；要么 fresh proof 不成立，所以立刻失败。`

`src/services/mcp/client.ts:1858-1922`
更值钱。

这里 `MCPTool.call()` 在每次真正 tool use 前都会：

1. 先 `ensureConnectedClient(client)`
2. 再进入真正的 `callMCPToolWithUrlElicitationRetry(...)`
3. 若撞上 `McpSessionExpiredError`，只允许有限次 retry

也就是说，
repo 的 use-time 语义不是：

`前面已经 reassuring 过，所以这次 tool use 可以直接相信旧状态`

而是：

`每次真正 use 都要再次经过 canonical fresh-proof primitive；若 session 过期，则用新的 session recovery 闭环重来一次。`

`src/services/mcp/client.ts:3200-3230`
又进一步把这层写硬了。

这里 `callMCPTool()` 不把 `401` 与 session expired 当成普通失败，
而是：

1. 对 `401` 抛 `McpAuthError`
2. 对 `404/-32001` 或 `Connection closed` 清 `server cache`
3. 再抛 `McpSessionExpiredError`

这说明 use-time revalidation 的职责不只是：

`入场前再查一次`

还包括：

`live contradiction 一出现，就正式撤销旧 reassurance，并把系统切回 recovery plane。`

## 5. `useManageMCPConnections` 与 `toolExecution` 再证明：repo 不只重验连接，还重验“你现在手里这份工具世界还是不是当前世界”

`src/services/mcp/useManageMCPConnections.ts:620-656`
特别值钱。

这里 repo 在收到 `tools/list_changed` 时会：

1. 先取旧 cache promise 作为比较基线
2. 立刻 `fetchToolsForClient.cache.delete(client.name)`
3. 再重新 `fetchToolsForClient(client)`
4. 最后把 new tools 写回 `updateServer(...)`

这说明 repo 已经明确承认：

`tool roster freshness`

本身就是安全事实，
不是纯粹的 UI 同步细节。

如果这一层不存在，
系统就会允许：

`旧 capability roster`

继续冒充：

`current tool world`

`src/services/tools/toolExecution.ts:337-390`
则把这层钉得更死。

这里 `runToolUse()` 的第一件事不是盲跑，
而是：

1. 先在当前 `toolUseContext.options.tools` 里找 tool
2. 若找不到，再看它是否只是 deprecated alias
3. 若仍找不到，就直接报 `No such tool available`

这条边界极其重要。

因为它说明：

`历史上曾经可用的 tool 名`

不自动拥有继续停留在当前执行世界里的资格。

系统继续问的不是：

`它刚才是不是看起来还能用`

而是：

`它现在是不是仍然属于 current executable roster`

这已经不是简单的“工具存在性检查”，
而是对 stale capability illusion 的制度性防线。

## 6. `Read/ListMcpResourcesTool`、prompt path 与 `AgentTool` 最后证明：真正 consumer edge 和 agent edge 都拒绝把 reassurance 当成免检通行证

`src/tools/ReadMcpResourceTool/ReadMcpResourceTool.ts:80-100`
与
`src/tools/ListMcpResourcesTool/ListMcpResourcesTool.ts:79-89`
很值钱。

这两条路径共同说明：

1. read/list consumer 都先看当前 `client.type`
2. 即便当前表面上还是 `connected`
3. 仍继续 `ensureConnectedClient(client)`

与此同时，
`src/services/mcp/client.ts:2073-2080`
里的 prompt path
也在 `getPromptForCommand()` 中继续 `ensureConnectedClient(client)`。

这说明 repo 不是只在最显眼的 tool call 上认真，
而是在真实 consumer edge 上统一坚持：

`reassurance can invite use; only fresh proof can authorize use`

`src/tools/AgentTool/AgentTool.tsx:369-408`
则进一步把边界推进到 agent edge。

这里最硬的话不是：

`server is connected`

而是注释里明写的：

`A server that's connected but not authenticated won't have any tools`

所以它真正收集的是：

`serversWithTools`

而不是：

`serversThatLookConnected`

这说明 agent prerequisite 的世界观与 consumer edge 一样：

`存在连接`

不等于：

`存在当前可用能力`

换句话说，
repo 在 agent edge 上也拒绝让 reassurance 或 connectivity shadow 冒充 actual current-use proof。

## 7. 苏格拉底式自反诘问：我是不是又把“它刚才看起来能用”误认成了“它现在真的仍然属于可依赖的当前世界”

如果对这组代码做更严格的自我审查，
至少要追问六句：

1. 如果 `Authentication successful` 已经出现，为什么 `MCPTool.call()` 还要先 `ensureConnectedClient()`？
   因为 reassuring sentence 不拥有豁免 live-use proof 的资格。
2. 如果某个 tool 刚才还在工具列表里，为什么 `runToolUse()` 现在还会报 `No such tool available`？
   因为历史 roster 不等于当前 roster。
3. 如果 session 只是 runtime 中断一下，为什么 `callMCPTool()` 要把它升级成 cache 清理与 session recovery signal？
   因为 runtime contradiction 不是噪音，而是旧 reassurance 失真的正式证据。
4. 如果 list/read/prompt 只是外围入口，为什么它们也要重新 `ensureConnectedClient()`？
   因为 consumer edge 的主权不该外包给别的 surface。
5. 如果 agent 已经看到 server 配置存在，为什么它还只认当前真的有 tools 的 server？
   因为 configuration presence 不等于 live usable capability。
6. 如果 cleanup 线还没正式长出 use-time revalidation grammar，是不是说明这层只是实现细节？
   恰恰相反。越把它当细节，越容易让 reassuring story 冒充 current-use authorization。

这一串反问最终逼出一句更稳的判断：

`use-time revalidation 的关键，不在系统刚才把话说得多积极，而在真正依赖发生时系统能不能再次裁定你手里的 connection、session、roster 与 capability world 是否仍然属于当前世界。`

## 8. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 线未来只要补出 reassurance grammar，就已经足够成熟。`

而是：

repo 已在 `ensureConnectedClient()` 的 `connect-or-throw` primitive、`MCPTool.call()` 的 bounded retry、`callMCPTool()` 的 runtime contradiction revocation、`useManageMCPConnections()` 的 roster freshness、`toolExecution.ts` 的 current-tool hard filter，以及 `Read/ListMcpResourcesTool`、prompt path 与 `AgentTool` 的 consumer/agent edge live gate 上，明确展示了 use-time revalidation governance 的存在；因此 `artifact-family cleanup stronger-request cleanup-reassurance-governor signer` 仍不能越级冒充 `artifact-family cleanup stronger-request cleanup-use-time revalidation-governor signer`。

因此：

`stronger-request cleanup 线真正缺的，不只是“谁来决定现在可以说多放心”，还包括“谁来决定真正消费这一刻，这份放心话是否仍配被当真、旧工具世界是否仍算当前世界、以及旧 assurance 何时必须被正式撤销”。`
