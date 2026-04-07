# 安全源码剖面索引

`source-notes/` 当前包含 75 篇源码剖面。它专门承接单机制、单协议、单文件群的长证据拆解，不与主线论证层和附录速查层混写。
源码剖面层也继续继承 `问题分型 -> 工作对象 -> 控制面 -> 入口`；它只负责把单机制证据拆开，不额外替主目录签治理 verdict。

## 这一子目录放什么

`security/` 主目录继续保留“主线论证链”。  
`security/appendix/` 继续保留“压缩速查层”。  
这里的 `source-notes/` 专门放：

- 单机制源码剖面
- 单协议边界拆解
- 单文件群技术启示

它比 `appendix/` 更长，  
但比主线章节更贴近源码证据，  
目的不是重复结论，  
而是把“这条结论到底踩着哪些代码长出来”单独留下。

这里还应再多记一句：

- `continuity` 相关剖面在这里也不是独立第四簇，而只是 `continuation pricing / cleanup / re-entry` 这些治理时间轴机制的源码证据束。

## 当前内容

- `01-15` receipt / finality / retention / cleanup carrier 机制簇：先看回执签收、session restore、不可逆销毁、保留期与 cleanup 家族元数据/反漂移。
  代表入口：[01-StructuredIO回执账本与签收边界](01-StructuredIO%E5%9B%9E%E6%89%A7%E8%B4%A6%E6%9C%AC%E4%B8%8E%E7%AD%BE%E6%94%B6%E8%BE%B9%E7%95%8C.md)、[03-bridgePointer、sessionRestore与conversationRecovery的续作责任边界](03-bridgePointer%E3%80%81sessionRestore%E4%B8%8EconversationRecovery%E7%9A%84%E7%BB%AD%E4%BD%9C%E8%B4%A3%E4%BB%BB%E8%BE%B9%E7%95%8C.md)、[09-task outputs、tool-results、transcripts与plans的清理家族宪法](09-task%20outputs%E3%80%81tool-results%E3%80%81transcripts%E4%B8%8Eplans%E7%9A%84%E6%B8%85%E7%90%86%E5%AE%B6%E6%97%8F%E5%AE%AA%E6%B3%95.md)、[13-microCompact、verifyAutoModeGateAccess与cleanup的反漂移验证边界](13-microCompact%E3%80%81verifyAutoModeGateAccess%E4%B8%8Ecleanup%E7%9A%84%E5%8F%8D%E6%BC%82%E7%A7%BB%E9%AA%8C%E8%AF%81%E8%BE%B9%E7%95%8C.md)、[15-model migrations、plugin orphan cleanup与plans continuity的迁移治理边界](15-model%20migrations%E3%80%81plugin%20orphan%20cleanup%E4%B8%8Eplans%20continuity%E7%9A%84%E8%BF%81%E7%A7%BB%E6%B2%BB%E7%90%86%E8%BE%B9%E7%95%8C.md)。
- `16-29` plugin / MCP capability lifecycle 机制簇：先看墓碑、复活、再赋权、重配置、就绪、reconnect、reprojection、revalidation 与 step-up。
  代表入口：[16-model deprecation、migration notifications与plugin orphan grace window的退役治理边界](16-model%20deprecation%E3%80%81migration%20notifications%E4%B8%8Eplugin%20orphan%20grace%20window%E7%9A%84%E9%80%80%E5%BD%B9%E6%B2%BB%E7%90%86%E8%BE%B9%E7%95%8C.md)、[21-refreshActivePlugins、reload-plugins与refreshPluginState的重新激活治理边界](21-refreshActivePlugins%E3%80%81reload-plugins%E4%B8%8ErefreshPluginState%E7%9A%84%E9%87%8D%E6%96%B0%E6%BF%80%E6%B4%BB%E6%B2%BB%E7%90%86%E8%BE%B9%E7%95%8C.md)、[24-handleRemoteAuthFailure、reconnectMcpServerImpl与performMCPOAuthFlow的恢复治理边界](24-handleRemoteAuthFailure%E3%80%81reconnectMcpServerImpl%E4%B8%8EperformMCPOAuthFlow%E7%9A%84%E6%81%A2%E5%A4%8D%E6%B2%BB%E7%90%86%E8%BE%B9%E7%95%8C.md)、[26-buildMcpServerStatuses、useMcpConnectivityStatus与MCPReconnect的重新投影治理边界](26-buildMcpServerStatuses%E3%80%81useMcpConnectivityStatus%E4%B8%8EMCPReconnect%E7%9A%84%E9%87%8D%E6%96%B0%E6%8A%95%E5%BD%B1%E6%B2%BB%E7%90%86%E8%BE%B9%E7%95%8C.md)、[29-wrapFetchWithStepUpDetection、ClaudeAuthProvider与performMCPOAuthFlow的step-up重授权治理边界](29-wrapFetchWithStepUpDetection%E3%80%81ClaudeAuthProvider%E4%B8%8EperformMCPOAuthFlow%E7%9A%84step-up%E9%87%8D%E6%8E%88%E6%9D%83%E6%B2%BB%E7%90%86%E8%BE%B9%E7%95%8C.md)。
- `30-46` stronger-request settlement / cleanup 机制簇：先看续打、完成、终局、遗忘、免责释放、归档/审计/擦除，再看 retention、隔离、反漂移与修复。
  代表入口：[30-callMCPToolWithUrlElicitationRetry、toolExecution与MCP认证路径的强请求续打治理边界](30-callMCPToolWithUrlElicitationRetry%E3%80%81toolExecution%E4%B8%8EMCP%E8%AE%A4%E8%AF%81%E8%B7%AF%E5%BE%84%E7%9A%84%E5%BC%BA%E8%AF%B7%E6%B1%82%E7%BB%AD%E6%89%93%E6%B2%BB%E7%90%86%E8%BE%B9%E7%95%8C.md)、[32-addToolResult、print与CCRClient的强请求终局治理边界](32-addToolResult%E3%80%81print%E4%B8%8ECCRClient%E7%9A%84%E5%BC%BA%E8%AF%B7%E6%B1%82%E7%BB%88%E5%B1%80%E6%B2%BB%E7%90%86%E8%BE%B9%E7%95%8C.md)、[37-debug.ts、diagLogs、cleanup、sessionStorage与fileHistory的强请求不可逆擦除治理边界](37-debug.ts%E3%80%81diagLogs%E3%80%81cleanup%E3%80%81sessionStorage%E4%B8%8EfileHistory%E7%9A%84%E5%BC%BA%E8%AF%B7%E6%B1%82%E4%B8%8D%E5%8F%AF%E9%80%86%E6%93%A6%E9%99%A4%E6%B2%BB%E7%90%86%E8%BE%B9%E7%95%8C.md)、[40-TaskOutput、diskOutput、toolResultStorage、concurrentSessions与cronTasksLock中的强请求清理隔离边界](40-TaskOutput%E3%80%81diskOutput%E3%80%81toolResultStorage%E3%80%81concurrentSessions%E4%B8%8EcronTasksLock%E4%B8%AD%E7%9A%84%E5%BC%BA%E8%AF%B7%E6%B1%82%E6%B8%85%E7%90%86%E9%9A%94%E7%A6%BB%E8%BE%B9%E7%95%8C.md)、[46-verifyAutoModeGateAccess、verifyAndDemote与强请求清理修复治理缺口](46-verifyAutoModeGateAccess%E3%80%81verifyAndDemote%E4%B8%8E%E5%BC%BA%E8%AF%B7%E6%B1%82%E6%B8%85%E7%90%86%E4%BF%AE%E5%A4%8D%E6%B2%BB%E7%90%86%E7%BC%BA%E5%8F%A3.md)。
- `47-60` stronger-request migration 与 plugin/MCP re-entry 机制簇：先看迁移、退役、墓碑、复活、再赋权，再看 continuity、recovery、reintegration、reprojection 与 reassurance。
  代表入口：[47-main迁移链、orphan宽限期与plans continuity的强请求清理迁移治理边界](47-main%E8%BF%81%E7%A7%BB%E9%93%BE%E3%80%81orphan%E5%AE%BD%E9%99%90%E6%9C%9F%E4%B8%8Eplans%20continuity%E7%9A%84%E5%BC%BA%E8%AF%B7%E6%B1%82%E6%B8%85%E7%90%86%E8%BF%81%E7%A7%BB%E6%B2%BB%E7%90%86%E8%BE%B9%E7%95%8C.md)、[50-removeOrphanedAtMarker、refreshActivePlugins与copyPlanForResume的强请求清理复活治理边界](50-removeOrphanedAtMarker%E3%80%81refreshActivePlugins%E4%B8%8EcopyPlanForResume%E7%9A%84%E5%BC%BA%E8%AF%B7%E6%B1%82%E6%B8%85%E7%90%86%E5%A4%8D%E6%B4%BB%E6%B2%BB%E7%90%86%E8%BE%B9%E7%95%8C.md)、[55-useManageMCPConnections、toolExecution与print的强请求清理连续性治理边界](55-useManageMCPConnections%E3%80%81toolExecution%E4%B8%8Eprint%E7%9A%84%E5%BC%BA%E8%AF%B7%E6%B1%82%E6%B8%85%E7%90%86%E8%BF%9E%E7%BB%AD%E6%80%A7%E6%B2%BB%E7%90%86%E8%BE%B9%E7%95%8C.md)、[56-handleRemoteAuthFailure、reconnectMcpServerImpl与McpAuthTool的强请求清理恢复治理边界](56-handleRemoteAuthFailure%E3%80%81reconnectMcpServerImpl%E4%B8%8EMcpAuthTool%E7%9A%84%E5%BC%BA%E8%AF%B7%E6%B1%82%E6%B8%85%E7%90%86%E6%81%A2%E5%A4%8D%E6%B2%BB%E7%90%86%E8%BE%B9%E7%95%8C.md)、[58-buildMcpServerStatuses、useMcpConnectivityStatus与MCPReconnect的强请求清理重新投影治理边界](58-buildMcpServerStatuses%E3%80%81useMcpConnectivityStatus%E4%B8%8EMCPReconnect%E7%9A%84%E5%BC%BA%E8%AF%B7%E6%B1%82%E6%B8%85%E7%90%86%E9%87%8D%E6%96%B0%E6%8A%95%E5%BD%B1%E6%B2%BB%E7%90%86%E8%BE%B9%E7%95%8C.md)、[60-ensureConnectedClient、ReadMcpResourceTool与toolExecution的强请求清理用时重验证治理边界](60-ensureConnectedClient%E3%80%81ReadMcpResourceTool%E4%B8%8EtoolExecution%E7%9A%84%E5%BC%BA%E8%AF%B7%E6%B1%82%E6%B8%85%E7%90%86%E7%94%A8%E6%97%B6%E9%87%8D%E9%AA%8C%E8%AF%81%E6%B2%BB%E7%90%86%E8%BE%B9%E7%95%8C.md)。
- `61-75` stronger-request 续打、终局、retention 与制度元数据机制簇：先看 step-up、续打、终局/遗忘，再看 archive/audit、不可逆擦除、保留期执行诚实性、隔离、cleanup family constitution 与制度元数据。
  代表入口：[61-wrapFetchWithStepUpDetection、ClaudeAuthProvider与performMCPOAuthFlow的强请求清理step-up重授权治理边界](61-wrapFetchWithStepUpDetection%E3%80%81ClaudeAuthProvider%E4%B8%8EperformMCPOAuthFlow%E7%9A%84%E5%BC%BA%E8%AF%B7%E6%B1%82%E6%B8%85%E7%90%86step-up%E9%87%8D%E6%8E%88%E6%9D%83%E6%B2%BB%E7%90%86%E8%BE%B9%E7%95%8C.md)、[64-addToolResult、print与CCRClient的强请求清理终局治理边界](64-addToolResult%E3%80%81print%E4%B8%8ECCRClient%E7%9A%84%E5%BC%BA%E8%AF%B7%E6%B1%82%E6%B8%85%E7%90%86%E7%BB%88%E5%B1%80%E6%B2%BB%E7%90%86%E8%BE%B9%E7%95%8C.md)、[68-control_response回放与日志面的强请求清理审计关闭治理边界](68-control_response%E5%9B%9E%E6%94%BE%E4%B8%8E%E6%97%A5%E5%BF%97%E9%9D%A2%E7%9A%84%E5%BC%BA%E8%AF%B7%E6%B1%82%E6%B8%85%E7%90%86%E5%AE%A1%E8%AE%A1%E5%85%B3%E9%97%AD%E6%B2%BB%E7%90%86%E8%BE%B9%E7%95%8C.md)、[72-TaskOutput、diskOutput、toolResultStorage、concurrentSessions与cronTasksLock中的强请求清理隔离边界](72-TaskOutput%E3%80%81diskOutput%E3%80%81toolResultStorage%E3%80%81concurrentSessions%E4%B8%8EcronTasksLock%E4%B8%AD%E7%9A%84%E5%BC%BA%E8%AF%B7%E6%B1%82%E6%B8%85%E7%90%86%E9%9A%94%E7%A6%BB%E8%BE%B9%E7%95%8C.md)、[73-diskOutput、sessionStorage、toolResultStorage、plans、debug与diagLogs中的强请求清理家族宪法边界](73-diskOutput%E3%80%81sessionStorage%E3%80%81toolResultStorage%E3%80%81plans%E3%80%81debug%E4%B8%8EdiagLogs%E4%B8%AD%E7%9A%84%E5%BC%BA%E8%AF%B7%E6%B1%82%E6%B8%85%E7%90%86%E5%AE%B6%E6%97%8F%E5%AE%AA%E6%B3%95%E8%BE%B9%E7%95%8C.md)、[75-cleanup、settings、path helpers、permissions与env contract中的强请求清理制度元数据边界](75-cleanup%E3%80%81settings%E3%80%81path%20helpers%E3%80%81permissions%E4%B8%8Eenv%20contract%E4%B8%AD%E7%9A%84%E5%BC%BA%E8%AF%B7%E6%B1%82%E6%B8%85%E7%90%86%E5%88%B6%E5%BA%A6%E5%85%83%E6%95%B0%E6%8D%AE%E8%BE%B9%E7%95%8C.md)。

如果需要逐篇平铺查找，直接进编号页或使用文件名搜索；本 README 不再复写 75 条库存。

## 和其他目录的分工

- 与 `security/` 主目录的关系：`source-notes/` 负责贴近源码拆机制，主目录负责把这些机制压成更高阶判断。
- 与 `appendix/` 的关系：`appendix/` 负责短表、矩阵和索引；`source-notes/` 负责长一点的证据剖面，不把速查卡撑成半篇长文。
- 与 `docs/development/research-log.md` 的关系：research log 负责记录研究推进；`source-notes/` 负责留下可以长期复用的源码剖面资产。
- 与 [../../docs/development/security/README.md](../../docs/development/security/README.md) 的关系：安全专题的后续候选、章节推进和写作边界放到隔离记忆层，不再混回 `source-notes/`。
