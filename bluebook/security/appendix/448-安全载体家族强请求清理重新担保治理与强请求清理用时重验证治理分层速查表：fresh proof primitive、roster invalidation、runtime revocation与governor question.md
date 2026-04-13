# 安全载体家族强请求清理重新担保治理与强请求清理用时重验证治理分层速查表：fresh proof primitive、roster invalidation、runtime revocation与governor question

## 1. 这一页服务于什么

这一页服务于 [464-安全载体家族强请求清理重新担保治理与强请求清理用时重验证治理分层](../464-安全载体家族强请求清理重新担保治理与强请求清理用时重验证治理分层.md)。

如果 `464` 的长文解释的是：

`为什么某个 surface 即便已经给出了足够正向的 reassurance，也还不能自动替真正 consumer 的 live use 资格签字，`

那么这一页只做一件事：

`把 fresh proof primitive、roster invalidation、runtime revocation 与 agent/consumer edge 的 current-use 约束压成一张矩阵。`

## 2. 强请求清理重新担保治理与强请求清理用时重验证治理分层矩阵

| positive control / cleanup current gap | reassurance decision | use-time revalidation decision | fresh proof / roster / revocation mechanism | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| fresh connection primitive | decide some surface may already speak positively about availability | decide whether actual use must still prove current connection truth | `ensureConnectedClient()` reconnects or throws | who decides whether restored cleanup truth is actually connected right now rather than merely described positively | `src/services/mcp/client.ts:1688-1703` |
| live tool call | decide previous reassurance may invite another attempt | decide whether each real tool call must re-enter the fresh-proof primitive and recover from session expiry | `MCPTool.call()` uses `ensureConnectedClient()` + bounded retry on `McpSessionExpiredError` | who decides whether tool use may proceed on stale connection labels | `src/services/mcp/client.ts:1858-1922` |
| runtime contradiction | decide old positive wording may still stand for now | decide whether 401 / expired session must immediately revoke old reassurance | `McpAuthError` / `clearServerCache()` / `McpSessionExpiredError` | who decides when live use has disproved the last reassuring sentence | `src/services/mcp/client.ts:3196-3230` |
| tool roster freshness | decide some tool list once looked good enough to reassure | decide whether current roster must be refreshed when the server says tools changed | `tools/list_changed` invalidates `fetchToolsForClient` cache and re-fetches tools | who decides whether old capability rosters may keep standing in for current world | `src/services/mcp/useManageMCPConnections.ts:618-656` |
| current-tool hard filter | decide historical tool availability may still sound positive | decide whether actual execution may only use tools that remain in the current tool pool | `runToolUse()` rejects `No such tool available` when tool is absent from current tools | who decides whether a once-available tool name still belongs to the current executable world | `src/services/tools/toolExecution.ts:337-394` |
| consumer-edge list/read/prompt gate | decide reassurance may invite read/list/prompt use | decide whether resource/prompt consumers still need fresh connected proof | `ReadMcpResourceTool` / `ListMcpResourcesTool` / `getPromptForCommand()` call `ensureConnectedClient()` | who decides whether real consumers may trust reassurance without live proof | `src/tools/ReadMcpResourceTool/ReadMcpResourceTool.ts:80-100`; `src/tools/ListMcpResourcesTool/ListMcpResourcesTool.ts:79-89`; `src/services/mcp/client.ts:2073-2080` |
| agent-edge actual-tools gate | decide server existence or prior success may sound reassuring enough | decide whether agent prerequisites should only count servers that currently expose tools | `AgentTool` derives `serversWithTools`, not just connected servers | who decides whether agent execution may trust connectivity without current usable capability | `src/tools/AgentTool/AgentTool.tsx:369-408` |
| stronger-request cleanup current gap | reassurance question is now visible | no explicit use-time revalidation grammar yet | old path / promise / receipt world still lack formal fresh-at-use proof, roster freshness and live revocation governance | who decides whether restored cleanup truth is merely reassuring or actually consumable right now | current cleanup line evidence set |

## 3. 三个最重要的判断问题

判断一句

`既然它刚才已经被正向担保，所以真正 consumer 现在当然可以直接继续依赖`

有没有越级，先问三句：

1. 这里回答的是 reassurance ceiling，还是已经回答真正 use path 的 fresh-at-use proof
2. 当前看到的是旧 roster / 旧 connected label，还是已经重新确认 current tool world 与 current session truth
3. 如果 live contradiction 现在出现，谁会正式撤销刚才那句 reassuring sentence

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| `既然刚才已经说能用了，现在真正 consumer 也一定能用` | reassurance != live-use authorization |
| `旧 tool 名还在记忆里，所以它现在当然还算 current tool` | historical tool name != current roster truth |
| `健康时通常不重连，所以 use-time revalidation 只是性能实现细节` | memoized no-op still depends on canonical fresh-proof primitive |
| `runtime 出错只是局部失败，不影响刚才那句正向 reassurance` | live contradiction should revoke stale reassurance |
| `agent 只要看到 server 配置存在就算 prerequisite 满足` | server existence != current usable tools |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup use-time revalidation grammar 不是：

`positive reassurance exists -> consumer may rely immediately`

而是：

`positive reassurance exists -> re-enter fresh proof primitive -> confirm current roster and current consumer edge -> revoke immediately on contradiction`

只有中间这些层被补上，
stronger-request cleanup reassurance governance 才不会继续停留在：

`它能说现在可以多放心，却没人正式决定真正使用这一刻这句放心话是否仍配被当真。`
