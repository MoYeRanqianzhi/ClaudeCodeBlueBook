# 安全载体家族强请求清理重新担保治理与强请求清理用时重验证治理分层速查表：fresh gate、runtime revocation、current-use proof与governor question

## 1. 这一页服务于什么

这一页服务于
[305-安全载体家族强请求清理重新担保治理与强请求清理用时重验证治理分层](../305-安全载体家族强请求清理重新担保治理与强请求清理用时重验证治理分层.md)。

如果 `305` 的长文解释的是：

`为什么某个 surface 即便已经给出了足够正向的 reassurance，也还不能自动把真正 consumer 的 current-use 资格一并签掉，`

那么这一页只做一件事：

`把 fresh gate、runtime revocation、current-use proof 与 stronger-request cleanup current gap 压成一张矩阵。`

## 2. 强请求清理重新担保治理与强请求清理用时重验证治理分层矩阵

| positive control / cleanup current gap | reassurance decision | use-time revalidation decision | fresh proof / revocation mechanism | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| resource read gate | decide some surface may already speak positively about availability | decide whether read consumer must re-check `connected` before actual use | `client.type === 'connected'` hard gate + `ensureConnectedClient(client)` | who decides whether restored cleanup truth may be consumed right now rather than merely described positively | `ReadMcpResourceTool.ts:75-100` |
| batch list gate | decide current truth sounds positive enough to invite browsing | decide whether list consumer still needs fresh reconnect after `onclose` | cache invalidation + `ensureConnectedClient()` fresh reconnect discipline | who decides whether listing restored cleanup truth still requires live freshness proof | `ListMcpResourcesTool.ts:79-89` |
| fresh proof primitive | decide old reassurance can stay on surface | decide whether actual reliance must use reconnect-or-throw instead of stale labels | `ensureConnectedClient()` reconnects or throws | who decides what canonical current-use proof replaces old reassurance at dependency time | `client.ts:1688-1703` |
| execution-context filter | decide some surface may already say `connected` / `available` | decide whether helper execution metadata may be derived only from current connected truth | `getMcpServerType()` / `getMcpServerBaseUrlFromToolName()` connected-only filters | who decides whether helper execution context may trust old reassurance | `toolExecution.ts:308-335` |
| runtime contradiction | decide current positive wording may still stand for now | decide whether live contradiction must immediately revoke old reassurance | `McpAuthError -> needs-auth` demotion | who decides when a once-reassured cleanup truth must stop being trusted during actual use | `toolExecution.ts:1599-1627` |
| stronger-request cleanup current gap | reassurance question is now visible | no explicit use-time revalidation grammar yet | old path / promise / receipt world still lack formal fresh-at-use proof, current-use truth primitive, and runtime revocation governance | who decides whether restored cleanup truth is merely reassuring or actually consumable right now | current cleanup line evidence set |

## 3. 三个最重要的判断问题

判断一句
“既然当前某个 surface 已经说它能用了，所以真正 consumer 当然也能直接用”
有没有越级，
先问三句：

1. 这里回答的是 positive reassurance ceiling，还是已经回答真正依赖前还要重新验真什么
2. 当前看到的是 static `connected` / success copy，还是已经拿到了 fresh-at-use proof
3. 如果 live contradiction 出现，谁会在使用瞬间立即撤销刚才那句正向 reassurance

## 4. 最常见的六类误读

| 误读 | 实际问题 |
| --- | --- |
| “既然刚才已经说能用了，现在真实 consumer 也一定能用” | reassurance != live-use authorization |
| “某次 reconnect 成功就说明读资源、列资源都不必再重查” | operation reassurance != fresh consumer proof |
| “只要还显示 connected，旧结论就继续有效” | stale label != current-use truth |
| “正向 surface 能说话，执行上下文自然也能复用” | execution metadata also needs current connected truth |
| “真实使用失败只是局部异常，不影响旧 reassurance” | runtime contradiction should revoke reassurance immediately |
| “fresh proof 只是实现细节，不是治理层” | reconnect-or-throw is the current-use governance primitive |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup use-time-revalidation grammar 不是：

`positive reassurance exists -> live consumer may rely immediately`

而是：

`positive reassurance exists -> ask for fresh proof at use-time -> derive only current context -> revoke immediately on contradiction`

只有中间这些层被补上，
stronger-request cleanup reassurance governance 才不会继续停留在：

`它能说现在可以多放心，却没人正式决定真正消费这一刻这份放心话是否仍配被当真。`
