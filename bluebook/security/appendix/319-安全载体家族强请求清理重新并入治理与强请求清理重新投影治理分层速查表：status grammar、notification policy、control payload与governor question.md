# 安全载体家族强请求清理重新并入治理与强请求清理重新投影治理分层速查表：status grammar、notification policy、control payload与governor question

## 1. 这一页服务于什么

这一页服务于 [335-安全载体家族强请求清理重新并入治理与强请求清理重新投影治理分层：为什么artifact-family cleanup stronger-request cleanup-reintegration-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-reprojection-governor signer](../335-安全载体家族强请求清理重新并入治理与强请求清理重新投影治理分层.md)。

如果 `335` 的长文解释的是：

`为什么“对象已经重新并入当前世界”仍不等于“不同读者已经按正确方式重新看见这份 current truth”，`

那么这一页只做一件事：

`把 status grammar、notification policy、control payload、health glyph 与 reconnect copy 压成一张矩阵。`

## 2. 强请求清理重新并入治理与强请求清理重新投影治理分层矩阵

| positive control / cleanup current gap | reintegration decision | reprojection decision | reader-specific projection mechanism | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| control protocol | decide recovered truth has re-entered current state | decide which structured fields control readers should now receive | `buildMcpServerStatuses()` + `mcp_status` / `reload_plugins` response payload | who decides how much current truth control readers should receive after restored cleanup truth re-enters current world | `print.ts:1612-1698,2957-2960,3127-3128` |
| manager / panel status | decide object is back in current world | decide which UI enum / label best re-tells that truth to panel readers | `getMcpStatus()` + `MCPListPanel statusText` | who decides how reintegrated cleanup truth should be compressed for manager / panel readers | `ManagePlugins.tsx:512-519`; `MCPListPanel.tsx:306-337` |
| selective notifications | decide object has rejoined current world | decide whether this truth should be proactively published or kept silent | `useMcpConnectivityStatus()` only toasts `failed / needs-auth` | who decides which reintegrated cleanup truths deserve publication and which should remain silent | `useMcpConnectivityStatus.tsx:25-63` |
| health surface | decide object is part of current world again | decide which glyph-level health string best reprojects that truth to health readers | `/mcp` health glyph grammar | who decides how current cleanup truth should be summarized for health-only readers | `handlers/mcp.tsx:26-35` |
| reconnect dialog | decide reconnect path has returned object to current world | decide which action-oriented copy should be shown to the operator | `MCPReconnect` success / auth / failure copy | who decides how operation-local readers should hear the new current truth | `MCPReconnect.tsx:40-63` |
| control envelope | decide current truth exists in world state | decide whether reader gets success only, error only, or success plus structured payload | `sendControlResponseSuccess()` / `sendControlResponseError()` envelope discipline | who decides which control reader gets full truth, partial truth, or just operation verdict | `print.ts:2736-2760` |
| stronger-request cleanup current gap | reintegration question is now visible | no explicit reprojection grammar yet | old path / promise / receipt world still lack formal reader-specific retelling governance | who decides how restored cleanup truth should be re-told to different readers once it is back in current world | current cleanup line evidence set |

## 3. 三个最重要的判断问题

判断一句“旧 stronger-request truth 既然已经并回当前世界，所以所有 surface 自然就会正确表达它”有没有越级，先问三句：

1. 这里回答的是 world membership，还是已经回答不同 reader 应该看到哪种版本的 current truth
2. 当前看到的是 raw reintegration state，还是已经有了 panel / health / notification / control 各自的 projection grammar
3. 如果有些 surface 只该重讲 failure / auth，而不该主动重讲 success，那么谁在分配这种 publication policy

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “并回当前世界了，所以所有读者自然都知道了” | reintegration != reprojection |
| “一份 status text 足以代表所有当前真相” | one surface cannot speak for all readers |
| “恢复成功后当然要发 success toast” | publication policy is selective governance |
| “health glyph 就等于 control protocol truth” | glyph projection != structured control truth |
| “reconnect dialog 的文案就是最终真相” | action copy != full reader-facing reprojection |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup reprojection grammar 不是：

`truth rejoined current world -> every reader is assumed to see the right thing`

而是：

`truth rejoined current world -> choose reader -> choose grammar -> choose payload strength -> choose whether to publish at all`

只有中间这些层被补上，
stronger-request cleanup reintegration governance 才不会继续停留在：

`它能说对象已经回到当前世界，却没人正式决定不同读者现在该怎样被告知。`
