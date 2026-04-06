# 安全载体家族恢复治理与重新并入治理分层速查表：recovery decision、reintegration decision、positive control、cleanup reintegration gap与governor question

## 1. 这一页服务于什么

这一页服务于 [174-安全载体家族恢复治理与重新并入治理分层：为什么artifact-family cleanup recovery-governor signer不能越级冒充artifact-family cleanup reintegration-governor signer](../174-安全载体家族恢复治理与重新并入治理分层：为什么artifact-family%20cleanup%20recovery-governor%20signer不能越级冒充artifact-family%20cleanup%20reintegration-governor%20signer.md)。

如果 `174` 的长文解释的是：

`为什么决定恢复是否成立，与决定恢复后的真相何时真正重新并入当前 consumer world，仍然是两层治理主权，`

那么这一页只做一件事：

`把 repo 里现成的 recovery decision / reintegration decision 正例，与 cleanup 线当前仍缺的 reintegration grammar，压成一张矩阵。`

## 2. 恢复治理与重新并入治理分层矩阵

| line | recovery decision | reintegration decision | positive control | cleanup reintegration gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| raw reconnect result | decide whether fresh reconnect has actually returned usable connection truth | decide whether that result has been inserted into current consumer surfaces | `reconnectMcpServerImpl()` returns raw `client/tools/commands/resources` only | cleanup line has no explicit rule for turning recovered proof into current-world membership | who decides a restored cleanup truth stops being merely recovered and starts being part of current world again | `client.ts:2137-2163` |
| standard hook path | decide whether connection attempt has recovered to `connected` | decide whether state updates and real elicitation handlers are now reattached | `onConnectionAttempt()` + `updateServer()` + `registerElicitationHandler()` | cleanup line has no explicit event-plane reintegration grammar after recovery | who decides a restored cleanup object is not only back, but reattached to the live event/state plane | `useManageMCPConnections.ts:293-332` |
| control reconnect path | decide whether operator-triggered reconnect recovered successfully | decide whether recovered result is now written back into `appState` / `dynamicMcpState` and re-bound into handlers | `mcp_reconnect` writes state, updates dynamic tools, then re-registers handlers | cleanup line has no explicit operator-facing reintegration choreography for restored artifacts | who decides a restored cleanup object is visible to the next-turn consumer world after manual recovery | `print.ts:3148-3204` |
| control enable path | decide whether re-enabled server has recovered | decide whether recovered server is reinserted into current tool/status/event planes | `mcp_toggle` enable path + connected-only success + handler re-registration | cleanup line has no explicit “re-enabled but not yet reinserted” grammar | who decides when a re-enabled cleanup object becomes current-world-visible again | `print.ts:3255-3288` |
| auth-complete background path | decide whether auth+reconnect produced recovered truth | decide whether pseudo-tool is replaced and dynamic state is updated for next-turn use | auth-complete reconnect + `setAppState` + `dynamicMcpState` writeback | cleanup line has no explicit rule for replacing recovery placeholders with real restored artifacts | who decides when recovery placeholders are removed and real cleanup artifacts are reinserted | `print.ts:3391-3441`; `McpAuthTool.ts:134-165` |
| consumer read model | decide whether recovered truth exists | decide whether tool/status consumers can actually see it now | `buildAllTools()` + `buildMcpServerStatuses()` read `dynamicMcpState` and `appState` | cleanup line has no explicit distinction between recovered truth and consumer-visible reintegrated truth | who decides whether restored cleanup truth is only true in recovery logic or already visible to downstream consumers | `print.ts:1471-1485,1610-1627` |
| event/channel plane | decide whether recovery has reached `connected` | decide whether event handlers and channel notifications are actually back on the live connection | `registerElicitationHandlers()` + `reregisterChannelHandlerAfterReconnect()` | cleanup line has no explicit grammar for reattaching live interaction surfaces after recovery | who decides when restored cleanup truth is once again allowed to participate in live interactive current world | `print.ts:1253-1280,4786-4835` |

## 3. 三个最重要的判断问题

判断一句“cleanup recovery 已经完整”有没有越级，先问三句：

1. 这里回答的只是恢复是否成立，还是已经回答恢复后的真相是否重新进入 tool/status/event plane
2. 当前看到的是 reconnect/auth result，还是已经有了 `appState` / `dynamicMcpState` / handler rebind 的 reintegration proof
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

真正成熟的 reintegration grammar 不是：

`recovery proof exists -> current world reintegration is assumed`

而是：

`recovery proof exists -> write current state -> reinsert tools/status -> rebind handlers -> next-turn consumers can finally see restored truth`

只有中间这些层被补上，
cleanup recovery governance 才不会继续停留在：

`它能说对象已经恢复，却没人正式决定它现在是否已经重新成为当前世界的一部分。`
