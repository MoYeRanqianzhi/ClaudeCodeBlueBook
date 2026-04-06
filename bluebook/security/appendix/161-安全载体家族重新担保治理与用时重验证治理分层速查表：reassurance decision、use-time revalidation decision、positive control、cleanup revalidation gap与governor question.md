# 安全载体家族重新担保治理与用时重验证治理分层速查表：reassurance decision、use-time revalidation decision、positive control、cleanup revalidation gap与governor question

## 1. 这一页服务于什么

这一页服务于 [177-安全载体家族重新担保治理与用时重验证治理分层：为什么artifact-family cleanup reassurance-governor signer不能越级冒充artifact-family cleanup use-time revalidation-governor signer](../177-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E9%87%8D%E6%96%B0%E6%8B%85%E4%BF%9D%E6%B2%BB%E7%90%86%E4%B8%8E%E7%94%A8%E6%97%B6%E9%87%8D%E9%AA%8C%E8%AF%81%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88artifact-family%20cleanup%20reassurance-governor%20signer%E4%B8%8D%E8%83%BD%E8%B6%8A%E7%BA%A7%E5%86%92%E5%85%85artifact-family%20cleanup%20use-time%20revalidation-governor%20signer.md)。

如果 `177` 的长文解释的是：

`为什么正向 reassurance 即便已经存在，也还不能自动豁免真正 consumer 在依赖发生瞬间做 fresh revalidation，`

那么这一页只做一件事：

`把 repo 里现成的 reassurance decision / use-time revalidation decision 正例，与 cleanup 线当前仍缺的 live-use gate grammar，压成一张矩阵。`

## 2. 重新担保治理与用时重验证治理分层矩阵

| line | reassurance decision | use-time revalidation decision | positive control | cleanup revalidation gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| resource read entry | decide whether some surface may say server/tools should now be available | decide whether resource reader must still reject non-connected state and re-check fresh connection before actual read | `ReadMcpResourceTool` connected hard gate + `ensureConnectedClient` | cleanup line has no explicit “positive reassurance still needs live-use gate” rule before actual consume | who decides whether a positive cleanup story must still be revalidated before real read/use | `ReadMcpResourceTool.ts:80-100`; `client.ts:1688-1705` |
| resource list batch | decide whether current surface can sound healthy enough to invite use | decide whether batch consumer must revalidate each connected client at use time and degrade to empty result on failure | `ListMcpResourcesTool` + `ensureConnectedClient` + per-server failure isolation | cleanup line has no explicit batch-use revalidation grammar after reassurance | who decides how to turn reassuring status into per-consumer fresh proof at use time | `ListMcpResourcesTool.ts:79-92`; `client.ts:1688-1705` |
| fresh connection primitive | decide whether earlier surfaces may keep saying connected/reconnected/available | decide whether actual use must obtain a fresh connection or fail closed | `ensureConnectedClient()` reconnect-or-throw discipline | cleanup line has no single primitive that converts reassurance into fresh-at-use proof | who owns the fresh-proof primitive before consumers may rely on cleanup truth | `client.ts:1688-1705` |
| execution metadata context | decide whether some UI/control surface may keep a positive picture of the server | decide whether execution plane may derive transport/base URL only from current connected truth | `getMcpServerType()` / `getMcpServerBaseUrlFromToolName()` | cleanup line has no explicit rule that even auxiliary execution context must pass live gate | who decides whether execution context may be derived from stale reassurance versus current connected truth | `toolExecution.ts:308-335` |
| runtime revocation on use | decide whether some surface previously gave a positive reassurance | decide whether live use may immediately revoke that reassurance and demote state on auth failure | `McpAuthError -> needs-auth` demotion in `toolExecution` | cleanup line has no explicit runtime revocation path when real use disproves reassuring copy | who decides how stale cleanup reassurance is revoked when actual use disproves it | `toolExecution.ts:1599-1624` |

## 3. 三个最重要的判断问题

判断一句“cleanup reassurance 已经足够，可以直接依赖”有没有越级，先问三句：

1. 这里回答的只是某个 surface 现在可以放心到什么程度，还是已经回答真正 consumer 在使用瞬间是否还要 fresh re-check
2. 当前依赖的是 positive copy，还是已经依赖了 live current truth
3. 如果真实 use path 失败，系统是否会立即撤销旧 reassurance，而不是继续沿用 stale positive picture

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “既然刚才已经说 connected/available 了，就不用再检查了” | reassurance != use-time revalidation |
| “dialog 成功就说明 read/list/tool execution 都可以直接依赖” | local success copy != consumer-side live gate |
| “health 上还是 connected，真实使用就不该再失败” | probe reassurance != current-use proof |
| “只要当前没有 warning，就可以把旧正向话术继续当真” | absence of warning != fresh-at-use authorization |
| “运行时报 auth 错只是局部异常，不应撤销刚才的放心话” | live-use failure is exactly where stale reassurance should be revoked |

## 5. 一条硬结论

真正成熟的 live-use grammar 不是：

`some surface already reassured the user -> every real consumer may now rely without re-check`

而是：

`some surface already reassured the user -> choose actual consumer -> fresh re-check current connection -> derive execution context from live truth -> revoke on first contradictory runtime evidence`

只有中间这些层被补上，
cleanup reassurance governance 才不会继续停留在：

`它能决定现在可以放心到什么程度，却没人正式决定真正消费这一刻这份放心话是否仍配被当真。`
