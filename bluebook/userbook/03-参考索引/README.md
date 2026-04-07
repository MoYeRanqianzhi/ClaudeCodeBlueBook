# 参考索引

这一层只继承 [../README.md](../README.md) 的问题分型，负责速查、定位和合同回跳，不再重复 speaking-rights、appeal-chain 或首答来源/申诉链。

## 最短路由

别把这层当问题库存。更稳的默认用法是：

- 想按命令、工具、root/slash、Settings/Doctor/Usage 这类对象速查：
  [01-命令工具/README.md](./01-%E5%91%BD%E4%BB%A4%E5%B7%A5%E5%85%B7/README.md)
- 想判断稳定、条件、内部、影子，以及信任/gate/可见性边界：
  [02-能力边界/README.md](./02-%E8%83%BD%E5%8A%9B%E8%BE%B9%E7%95%8C/README.md)
- 想查 skills、MCP、plugins、hooks 这组扩展入口：
  [03-技能与扩展/README.md](./03-%E6%8A%80%E8%83%BD%E4%B8%8E%E6%89%A9%E5%B1%95/README.md)
- 想用一张总图看全部功能面怎么分层：
  [04-功能面七分法.md](./04-%E5%8A%9F%E8%83%BD%E9%9D%A2%E4%B8%83%E5%88%86%E6%B3%95.md)
- 想从真实任务反查应该先走哪个入口：
  [05-任务到入口速查矩阵.md](./05-%E4%BB%BB%E5%8A%A1%E5%88%B0%E5%85%A5%E5%8F%A3%E9%80%9F%E6%9F%A5%E7%9F%A9%E9%98%B5.md)
- 想看高价值入口背后的运行时合同速查：
  [06-高价值入口运行时合同速查.md](./06-%E9%AB%98%E4%BB%B7%E5%80%BC%E5%85%A5%E5%8F%A3%E8%BF%90%E8%A1%8C%E6%97%B6%E5%90%88%E5%90%8C%E9%80%9F%E6%9F%A5.md)

## 索引层的 first reject signal

看到下面迹象时，应先退出索引层，而不是继续在这里找答案：

1. 你开始期待索引页直接告诉你“哪条 truth 现在成立”。
2. 你开始期待索引页直接给 verdict，而不是把你路由到对应正文。
3. 你把索引里的 projection、可见面或 inventory 当成 signer。
4. 你开始把矩阵、索引或列表里的 continuity consumer 误读成新的独立主题，而不是同一工作对象的时间轴入口。

## 这层到底回答什么

这一层不讲长篇原理，主要回答六类速查问题：

1. 到底有哪些命令、工具和高价值入口。
2. 哪些入口是 root plane，哪些是 session plane。
3. 哪些入口是 Settings tab、独立 screen、调参命令、预算分流或受控 prompt 工作流。
4. 哪些能力是稳定、条件、内部或影子。
5. 哪些扩展对象是 `/skills`、SkillTool、MCP、plugins、hooks、remote skills 的不同投影。
6. 面对真实任务时，应先走哪个入口。
7. `assistant viewer`、`--remote` TUI、`viewerOnly`、`remoteSessionUrl` 与 coarse remote bit 看起来相近时，应该先去哪个入口分辨合同厚度。
8. `REMOTE_SAFE_COMMANDS`、`filterCommandsForRemoteMode`、`handleRemoteInit`、`session` 与 `mobile` 看起来都在 remote 模式附近时，应该先去哪个入口分辨 remote-safe 命令面与 runtime readiness proof。
9. `CLAUDE_CODE_REMOTE`、`getIsRemoteMode()`、`print`、`reload-plugins` 与 `settingsSync` 看起来都指向 remote 环境时，应该先去哪个入口分辨 headless remote 分支与 interactive remote bit。
10. `CLAUDE_CODE_REMOTE_MEMORY_DIR`、`memdir`、`SessionMemory`、`extractMemories` 与 `print` 看起来都在 remote 记忆附近时，应该先去哪个入口分辨 auto-memory 根与 session 账本的双轨体系。
11. `system/init.slash_commands`、`REMOTE_SAFE_COMMANDS`、`PromptInput`、`REPL`、`processUserInput` 与 `print` 看起来都在 slash 附近时，应该先去哪个入口分辨声明面、文本载荷与 runtime 再解释的三段合同。
12. `getSessionId`、`switchSession`、`StatusLine`、`assistant viewer`、`remoteSessionUrl` 与 `useRemoteSession` 看起来都在 remote session 身份附近时，应该先去哪个入口分辨 `remote.session_id` 可见性与当前前端拥有权。
13. `sessionStorage`、`hydrateFromCCRv2InternalEvents`、`sessionRestore`、`listSessionsImpl`、`SessionPreview` 与 `sessionTitle` 看起来都在 session 元数据附近时，应该先去哪个入口分辨 durable metadata、live `system/init` 与 foreground `external_metadata`。
14. `SENTINEL_LOADING`、`SENTINEL_LOADING_FAILED`、`SENTINEL_START`、`useAssistantHistory`、`remoteConnectionStatus` 与 `BriefIdleStatus` 看起来都在历史翻页附近时，应该先去哪个入口分辨 attached viewer 哨兵与 remote presence surface。
15. `discoverAssistantSessions`、`launchAssistantInstallWizard`、`launchAssistantSessionChooser`、`createRemoteSessionConfig` 与 attach banner 看起来都在 assistant 入口附近时，应该先去哪个入口分辨发现、安装、选择与附着不是同一种 connect flow。
16. `showSetupDialog`、`renderAndRun`、`launchResumeChooser`、`launchRepl`、`AppStateProvider` 与 `KeybindingSetup` 看起来都在 interactive 入口附近时，应该先去哪个入口分辨 setup-dialog host 与 attached REPL host。
17. `getSessionFilesLite`、`loadFullLog`、`SessionPreview`、`useAssistantHistory` 与 `fetchLatestEvents` 看起来都在 `/resume` 历史附近时，应该先去哪个入口分辨本地 preview transcript 与 attached viewer remote history。
18. `getSessionFilesLite`、`enrichLogs`、`LogSelector`、`SessionPreview` 与 `loadFullLog` 看起来都在 `/resume` 本地 durable surface 附近时，应该先去哪个入口分辨列表摘要面与 preview transcript。
19. `SessionPreview`、`loadFullLog`、`loadConversationForResume`、`switchSession` 与 `adoptResumedSessionFile` 看起来都在 `/resume` 恢复附近时，应该先去哪个入口分辨 preview transcript 与正式 session restore。
20. `forkSession`、`switchSession`、`copyPlanForFork`、`restoreWorktreeForResume` 与 `adoptResumedSessionFile` 看起来都在会话分叉附近时，应该先去哪个入口分辨 `--fork-session` 与原会话恢复的边界。
21. `loadConversationForResume`、`deserializeMessagesWithInterruptDetection`、`copyPlanForResume`、`fileHistoryRestoreStateFromLog` 与 `processSessionStartHooks` 看起来都在 resume 恢复包附近时，应该先去哪个入口分辨内容载荷与恢复流程的边界。
22. `main.tsx`、`launchResumeChooser`、`ResumeConversation`、`resume.tsx` 与 `REPL.resume` 看起来都在 resume 入口附近时，应该先去哪个入口分辨 `--continue`、startup picker 与会内 `resume` 共享恢复合同，却不是同一种入口宿主。
23. `main.tsx`、`print.ts`、`loadInitialMessages`、`ResumeConversation` 与 `REPL.resume` 看起来都在恢复入口附近时，应该先去哪个入口分辨 interactive resume host 与 headless print host 共享恢复语义，却不是同一种宿主族。
24. `print.ts`、`parseSessionIdentifier`、`hydrateRemoteSession` 与 `loadConversationForResume` 看起来都在 print resume 附近时，应该先去哪个入口分辨 parse、hydrate、restore 不是同一种前置阶段。
25. `deserializeMessages`、`SessionEnd`、`SessionStart` 与 `interrupted-resume` 看起来都在恢复时序附近时，应该先去哪个入口分辨合法化、修复与 hook 注入不是同一种 runtime stage。
26. `hydrateFromCCRv2InternalEvents`、`externalMetadataToAppState`、`hydrateRemoteSession` 与 `startup fallback` 看起来都在 print resume 的 remote recovery 附近时，应该先去哪个入口分辨它们不是同一种 stage。
27. `print.ts`、`externalMetadataToAppState`、`setMainLoopModelOverride` 与 `startup fallback` 看起来都在 print remote recovery 附近时，应该先去哪个入口分辨 transcript、metadata 与 emptiness 不是同一种 stage。
28. `restoredWorkerState`、`externalMetadataToAppState`、`SessionExternalMetadata` 与 `RemoteIO` 看起来都在 metadata readback 附近时，应该先去哪个入口分辨 CCR v2 的 readback 不是 observer metadata 的同一种本地消费合同。
29. `StructuredIO`、`RemoteIO`、`setInternalEventReader`、`setInternalEventWriter` 与 `flushInternalEvents` 看起来都在 headless transport 附近时，应该先去哪个入口分辨协议宿主不等于同一种恢复厚度。
30. `/resume`、`--continue`、`print --resume` 与 `remote-control --continue` 看起来都在接续入口附近时，应该先去哪个入口分辨 stable conversation resume、headless remote hydrate 与 bridge continuity 不是同一种接续来源。
31. `print --continue`、`print --resume session-id`、`print --resume url` 与 `loadConversationForResume` 看起来都在 headless resume 附近时，应该先去哪个入口分辨同属 headless resume，也不是同一种 source certainty。
32. `loadMessagesFromJsonlPath`、`parseSessionIdentifier`、`loadConversationForResume` 与 `sessionId` 看起来都在 local resume artifact 附近时，应该先去哪个入口分辨 `print --resume .jsonl` 与 `print --resume session-id` 不是同一种 local artifact provenance。
33. `readBridgePointerAcrossWorktrees`、`getBridgeSession`、`reconnectSession` 与 `environment_id` 看起来都在 bridge reconnect 附近时，应该先去哪个入口分辨 `remote-control --continue` 与 `remote-control --session-id` 不是同一种 bridge authority。
34. `BridgePointer.environmentId`、`getBridgeSession.environment_id`、`reuseEnvironmentId` 与 `registerBridgeEnvironment` 看起来都在环境恢复附近时，应该先去哪个入口分辨 pointer 里的 env hint、server session env 与 registered env 不是同一种 truth。
35. `BridgeConfig.environmentId`、`reuseEnvironmentId`、`registerBridgeEnvironment.environment_id` 与 `createBridgeSession` 看起来都在环境 attach 附近时，应该先去哪个入口分辨本地 env key、reuse claim、live env 与 session attach target 不是同一种环境主权。
36. `BridgeWorkerType`、`metadata.worker_type`、`BridgePointer.source` 与 `environment_id` 看起来都在来源标记附近时，应该先去哪个入口分辨环境来源标签、prior-state 域与环境身份不是同一种 provenance。
37. `createBridgeSession.environment_id`、`source`、`session_context` 与 `permission_mode` 看起来都在 session attach 附近时，应该先去哪个入口分辨 session attach target、来源声明、上下文载荷与默认策略不是同一种会话归属。
38. `createBridgeSession.source`、`metadata.worker_type`、`BridgeWorkerType` 与 `claude_code_assistant` 看起来都在 remote provenance 附近时，应该先去哪个入口分辨 session origin declaration 与 environment origin label 不是同一种 remote provenance。
39. `session_context.sources`、`session_context.outcomes`、`session_context.model` 与 `getBranchFromSession` 看起来都在 session context 附近时，应该先去哪个入口分辨 repo source、branch outcome 与 model stamp 不是同一种上下文主语。
40. `session_context.sources`、`session_context.outcomes`、`parseGitRemote`、`parseGitHubRepository` 与 `getBranchFromSession` 看起来都在 repo 上下文附近时，应该先去哪个入口分辨 repo declaration 与 branch projection 不是同一种 git context。
41. `validateSessionRepository`、`getBranchFromSession`、`checkOutTeleportedSessionBranch` 与 `teleportToRemote` 看起来都在 teleport 附近时，应该先去哪个入口分辨 repo admission 与 branch replay 不是同一种 teleport contract。
42. `createBridgeSession.events`、`initialMessages`、`previouslyFlushedUUIDs` 与 `writeBatch` 看起来都在 session birth/hydrate 附近时，应该先去哪个入口分辨 session-create events 不是 remote-control 历史回放机制。
43. `session_context.model`、`metadata.model`、`lastModelUsage`、`modelUsage` 与 `restoreAgentFromSession` 看起来都在模型恢复附近时，应该先去哪个入口分辨 create-time model stamp、live override shadow、durable usage ledger 与 resumed-agent fallback 不是同一种 model ledger。
44. `initialMessageUUIDs`、`previouslyFlushedUUIDs`、`createBridgeSession.events` 与 `writeBatch` 看起来都在初始消息账本附近时，应该先去哪个入口分辨注释里的 session creation events 不等于 bridge 的真实历史账。
45. `getUserSpecifiedModelSetting`、`settings.model`、`getMainLoopModelOverride`、`currentAgentDefinition` 与 `restoreAgentFromSession` 看起来都在模型选择附近时，应该先去哪个入口分辨 persisted model preference、live override 与 resumed-agent fallback 不是同一种 model authority。
46. `getUserSpecifiedModelSetting`、`ANTHROPIC_MODEL`、`settings.model`、`mainThreadAgentDefinition.model` 与 `setMainLoopModelOverride` 看起来都在模型来源附近时，应该先去哪个入口分辨 ambient env preference、saved setting、agent bootstrap 与 live launch override 不是同一种 model source。
47. `initialHistoryCap`、`isEligibleBridgeMessage`、`toSDKMessages` 与 `local_command` 看起来都在 bridge 历史附近时，应该先去哪个入口分辨 bridge 的 eligible history replay 不是 model prompt authority。
48. `getUserSpecifiedModelSetting`、`isModelAllowed`、`ANTHROPIC_MODEL`、`settings.model` 与 `getMainLoopModel` 看起来都在模型准入附近时，应该先去哪个入口分辨 source selection 之后的 allowlist veto 不会回退到更低优先级来源。
49. `model.tsx`、`validateModel`、`getModelOptions` 与 `getUserSpecifiedModelSetting` 看起来都在 allowlist 可见面附近时，应该先去哪个入口分辨显式拒绝、选项隐藏与 silent veto 不是同一种 allowlist contract。
50. `reusedPriorSession`、`previouslyFlushedUUIDs`、`createCodeSession` 与 `flushHistory` 看起来都在 continuity 历史附近时，应该先去哪个入口分辨 v1 continuity ledger 与 v2 fresh-session replay 不是同一种 history contract。
51. `writeMessages`、`writeSdkMessages`、`initialMessageUUIDs`、`recentPostedUUIDs` 与 `flushGate` 看起来都在 bridge 写入附近时，应该先去哪个入口分辨 REPL path 与 daemon path 不是同一种 bridge write contract。
52. `handleIngressMessage`、`recentPostedUUIDs`、`recentInboundUUIDs` 与 `onInboundMessage` 看起来都在 ingress 读取附近时，应该先去哪个入口分辨 outbound echo drop、inbound replay guard 与 non-user ignore 不是同一种 ingress consumer contract。
53. `lastTransportSequenceNum`、`recentInboundUUIDs`、`tryReconnectInPlace`、`createSession` 与 `rebuildTransport` 看起来都在重连回放附近时，应该先去哪个入口分辨 same-session continuity 与 fresh-session reset 不是同一种 inbound replay contract。
54. `handleIngressMessage`、`isSDKControlResponse`、`isSDKControlRequest`、`onPermissionResponse` 与 `onControlRequest` 看起来都在 bridge control 附近时，应该先去哪个入口分辨 bridge ingress 的 control side-channel 不是对称的通用 control 总线。
55. `handleIngressMessage`、`control_response/control_request`、`extractInboundMessageFields` 与 `enqueue(prompt)` 看起来都在 ingress transcript 适配附近时，应该先去哪个入口分辨 bridge ingress 只有 control 旁路和 user-only transcript adapter。
56. `extractInboundMessageFields`、`normalizeImageBlocks`、`resolveInboundAttachments`、`prependPathRefs` 与 `resolveAndPrepend` 看起来都在入站标准化附近时，应该先去哪个入口分辨 image block repair 与 attachment path-ref prepend 不是同一种 inbound normalization contract。
57. `pendingPermissionHandlers`、`BridgePermissionCallbacks`、`request_id`、`handlePermissionResponse` 与 `isBridgePermissionResponse` 看起来都在权限回包附近时，应该先去哪个入口分辨 bridge permission race 的 verdict ledger 不是 generic control callback ownership。
58. `handleIngressMessage`、`recentInboundUUIDs`、`onPermissionResponse`、`extractInboundMessageFields`、`resolveAndPrepend` 与 `pendingPermissionHandlers` 看起来都在 bridge ingress 附近时，应该先去哪个入口分辨 191-196 不是并列碎页，而是一条六层阅读链。
59. `cancelRequest`、`onResponse unsubscribe`、`pendingPermissionHandlers.delete` 与 `leader queue recheck` 看起来都在权限收口附近时，应该先去哪个入口分辨 prompt 撤场、订阅退役、响应消费与策略重判不是同一种收口合同。
60. `onSetPermissionMode`、`getLeaderToolUseConfirmQueue`、`recheckPermission`、`useRemoteSession` 与 `useInboxPoller` 看起来都在权限重判附近时，应该先去哪个入口分辨 permission context 变更后的本地重判广播不是同一种 permission re-evaluation surface。

更细的问题库存统一下沉到各子目录 README 和对应索引页，不再在根 README 里重写一长串 one-off 问句。

## 使用边界

- 需要判断“为什么必须如此设计”，退回 `../../philosophy/README.md`
- 需要判断“哪条真相被正式承认”，退回 `../../api/README.md`
- 需要判断“现场现在该判哪一个 verdict”，退回 `../../playbooks/README.md`
- 需要判断“哪种伪证最像成功”，退回 `../../casebooks/README.md`
