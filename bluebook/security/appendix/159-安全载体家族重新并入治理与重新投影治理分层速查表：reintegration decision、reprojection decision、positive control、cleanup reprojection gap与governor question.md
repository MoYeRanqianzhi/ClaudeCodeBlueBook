# 安全载体家族重新并入治理与重新投影治理分层速查表：reintegration decision、reprojection decision、positive control、cleanup reprojection gap与governor question

## 1. 这一页服务于什么

这一页服务于 [175-安全载体家族重新并入治理与重新投影治理分层：为什么artifact-family cleanup reintegration-governor signer不能越级冒充artifact-family cleanup reprojection-governor signer](../175-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E9%87%8D%E6%96%B0%E5%B9%B6%E5%85%A5%E6%B2%BB%E7%90%86%E4%B8%8E%E9%87%8D%E6%96%B0%E6%8A%95%E5%BD%B1%E6%B2%BB%E7%90%86%E5%88%86%E5%B1%82%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88artifact-family%20cleanup%20reintegration-governor%20signer%E4%B8%8D%E8%83%BD%E8%B6%8A%E7%BA%A7%E5%86%92%E5%85%85artifact-family%20cleanup%20reprojection-governor%20signer.md)。

如果 `175` 的长文解释的是：

`为什么决定恢复后的对象何时重新进入当前世界，与决定这份当前真相怎样被不同 reader surface 重新讲述，仍然是两层治理主权，`

那么这一页只做一件事：

`把 repo 里现成的 reintegration decision / reprojection decision 正例，与 cleanup 线当前仍缺的 reprojection grammar，压成一张矩阵。`

## 2. 重新并入治理与重新投影治理分层矩阵

| line | reintegration decision | reprojection decision | positive control | cleanup reprojection gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| control protocol status | decide recovered truth is back inside current state | decide how current truth should be serialized as `McpServerStatus[]` for control readers | `buildMcpServerStatuses()` + `mcp_status` / `reload_plugins` payload | cleanup line has no explicit structured reprojection grammar after reintegration | who decides what structured current-world story control consumers receive after cleanup objects re-enter | `print.ts:1610-1698,2957-2960,3127-3128` |
| plugin manager / panel status | decide object is back in current world | decide which normalized enum/label manager surfaces should display | `getMcpStatus()` + `MCPListPanel` statusText mapping | cleanup line has no explicit UI status grammar for reintegrated artifacts | who decides what short status lexicon manager readers should see after cleanup reintegration | `ManagePlugins.tsx:512-519`; `MCPListPanel.tsx:307-337` |
| notification surface | decide object is back, degraded, or failed | decide which truths deserve toast publication and which stay silent | `useMcpConnectivityStatus()` emits only failed/needs-auth notifications | cleanup line has no explicit selective-publication rule after reintegration | who decides which reintegrated cleanup truths are worth actively surfacing versus staying silent | `useMcpConnectivityStatus.tsx:25-63` |
| health CLI surface | decide current truth exists in world | decide how health readers should see glyph-level status | `/mcp` health maps status to `✓ / ! / ✗` grammar | cleanup line has no explicit health projection grammar for restored artifacts | who decides what health-check readers should see after cleanup truth returns | `handlers/mcp.tsx:26-35` |
| reconnect dialog surface | decide reconnect/reintegration actually succeeded | decide how one-shot operation result should be narrated to the user | `MCPReconnect` success/auth/failure copy | cleanup line has no explicit action-copy grammar for restored artifacts | who decides what immediate operation narrative users receive after a cleanup recovery attempt | `MCPReconnect.tsx:40-63` |
| control success envelope | decide object has been reintegrated enough for control path to proceed | decide whether to return terse success or structured error/result payload | `sendControlResponseSuccess` / `sendControlResponseError` + reconnect control handlers | cleanup line has no explicit distinction between reintegration truth and control-response narration policy | who decides how much of reintegrated cleanup truth to expose in control-plane responses | `print.ts:2736-2758,3148-3204,3258-3295` |

## 3. 三个最重要的判断问题

判断一句“cleanup reintegration 已经完整”有没有越级，先问三句：

1. 这里回答的只是对象是否重新回到当前世界，还是已经回答不同 reader 现在该看到什么版本的当前真相
2. 当前看到的是 reintegrated state，还是已经看到专门为某个 surface 重新压缩过的 projection
3. 如果同一 current truth 在 control/status/notification/dialog surface 上使用不同句法，那么谁配决定这些词法强度与沉默策略

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “既然对象已经并回来了，所有 surface 自然会说同一句话” | reintegration != reprojection |
| “有 status enum 就说明所有 reader 都看到了同样的 truth” | one projection does not speak for all readers |
| “恢复成功后理应有 success toast” | selective silence is part of reprojection governance |
| “health glyph 就等于当前控制协议 truth” | health projection != control projection |
| “dialog copy 就是在签 current truth” | action-oriented narration != authoritative reprojection for every surface |

## 5. 一条硬结论

真正成熟的 reprojection grammar 不是：

`reintegrated truth exists -> all readers implicitly understand it`

而是：

`reintegrated truth exists -> choose reader -> choose granularity -> choose lexicon -> choose silence/publication policy -> then project current truth`

只有中间这些层被补上，
cleanup reintegration governance 才不会继续停留在：

`它能说对象已经回来，却没人正式决定哪些读者现在该看到什么版本的当前真相。`
