# 安全载体家族强请求清理恢复治理与强请求清理重新并入治理分层速查表：writeback、dynamic state、handler rebind与governor question

## 1. 这一页服务于什么

这一页服务于
[270-安全载体家族强请求清理恢复治理与强请求清理重新并入治理分层](../270-安全载体家族强请求清理恢复治理与强请求清理重新并入治理分层.md)。

如果 `270` 的长文解释的是：

`为什么“对象已经 recovered”仍不等于“对象已经重新并回当前 consumer world”，`

那么这一页只做一件事：

`把 writeback、dynamic state、handler rebind、pseudo-tool replacement 与 stronger-request cleanup current gap 压成一张矩阵。`

## 2. 强请求清理恢复治理与强请求清理重新并入治理分层矩阵

| positive control / cleanup current gap | recovery decision | reintegration decision | current-world choreography | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| raw reconnect result | decide whether fresh reconnect has actually returned usable connection truth | decide whether that result has been inserted into current consumer surfaces | `reconnectMcpServerImpl()` returns raw `client/tools/commands/resources` only | who decides a restored cleanup truth stops being merely recovered and starts being part of current world again | `client.ts:2137-2175` |
| standard hook path | decide whether connection attempt has recovered to `connected` | decide whether state updates and real elicitation handlers are now reattached | `onConnectionAttempt()` + `updateServer()` + `registerElicitationHandler()` | who decides a restored cleanup object is not only back, but reattached to the live event/state plane | `useManageMCPConnections.ts:293-332` |
| control reconnect path | decide whether operator-triggered reconnect recovered successfully | decide whether recovered result is now written back into `appState` / `dynamicMcpState` and rebound into handlers | `mcp_reconnect` writes state, updates dynamic tools, then re-registers handlers | who decides a restored cleanup object is visible to the next-turn consumer world after manual recovery | `print.ts:3153-3204` |
| control enable path | decide whether re-enabled server has recovered | decide whether recovered server is reinserted into current tool / status / event planes | `mcp_toggle` enable path + connected-only success + handler re-registration | who decides when a re-enabled cleanup object becomes current-world-visible again | `print.ts:3255-3288` |
| auth-complete background path | decide whether auth + reconnect produced recovered truth | decide whether pseudo-tool is replaced and dynamic state is updated for next-turn use | auth-complete reconnect + `setAppState` + `dynamicMcpState` writeback | who decides when recovery placeholders are removed and real cleanup artifacts are reinserted | `print.ts:3391-3445`; `McpAuthTool.ts:134-168` |
| consumer read model | decide whether recovered truth exists | decide whether tool / status consumers can actually see it now | `buildAllTools()` + `buildMcpServerStatuses()` read `dynamicMcpState` and `appState` | who decides whether restored cleanup truth is only true in recovery logic or already visible to downstream consumers | `print.ts:1474-1490,1612-1630` |
| event / channel plane | decide whether recovery has reached `connected` | decide whether event handlers and channel notifications are actually back on the live connection | `registerElicitationHandlers()` + `reregisterChannelHandlerAfterReconnect()` | who decides when restored cleanup truth is once again allowed to participate in live interactive current world | `print.ts:1263-1285,4786-4835` |
| stronger-request cleanup current gap | recovery question is now visible | no explicit reintegration grammar yet | old path / promise / receipt world still lack formal writeback, dynamic-state, live-handler re-entry governance | who decides when restored cleanup truth has truly rejoined current world rather than merely becoming recovered | current cleanup line evidence set |

## 3. 三个最重要的判断问题

判断一句
“旧 stronger-request truth 既然已经恢复，所以它当然已经回到当前世界了”
有没有越级，
先问三句：

1. 这里回答的只是恢复是否成立，还是已经回答恢复后的真相是否重新进入 tool / status / event plane
2. 当前看到的是 reconnect / auth result，还是已经有了 `appState` / `dynamicMcpState` / handler rebind 的 reintegration proof
3. 如果 consumer 读的是 reintegrated state 而不是 raw recovery result，那么谁来决定什么时刻才配说“已经重新并入当前世界”

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “已经 connected，所以当然已经重新并入” | recovery != reintegration |
| “auth 完成了，所以真实工具肯定回来了” | auth done != tool-plane reintegration |
| “写回状态了，所以 event plane 也回来了” | state reinsertion != handler rebind |
| “函数返回了恢复结果，所以下一轮模型已经看见它” | raw result != next-turn visibility |
| “成功提示已经发出，所以当前世界一定重新接回它了” | control success must still be checked against actual reintegration choreography |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup reintegration grammar 不是：

`recovery proof exists -> current world reintegration is assumed`

而是：

`recovery proof exists -> write current state -> reinsert tools/status -> rebind handlers -> next-turn consumers can finally see restored truth`

只有中间这些层被补上，
stronger-request cleanup recovery governance 才不会继续停留在：

`它能说对象已经恢复，却没人正式决定它现在是否已经重新成为当前世界的一部分。`
