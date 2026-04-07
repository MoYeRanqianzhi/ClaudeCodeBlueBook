# 参考索引

这一部分不讲长篇原理，直接回答四个问题：

1. 到底有哪些命令。
2. 到底有哪些工具。
3. 哪些能力是稳定的，哪些是灰度的，哪些是内部的。
4. 当前版本自带哪些 bundled skills。
5. 从用户视角看，全部功能面应怎样分层。
6. 面对真实任务时，应该先走哪个入口。
7. 高价值入口背后到底有哪些运行时合同。
8. 名字相近的 root command 和 slash command 到底是不是一回事。
9. Settings tab、独立 screen、调参命令和预算分流到底分别属于什么对象。
10. 同样都是 slash command，为什么它们在对象类型、执行语义和可见性边界上并不是同一类按钮。
11. 技能为什么不是一张表，为什么 `/skills`、SkillTool、dynamic skills 看到的是不同投影。
12. Claude 与 remote client 到底通过哪些链看到可用能力，为什么 UI 菜单、system/init、skill 提醒不是同一张表。
13. 为什么同样是扩展来源，workspace trust、plugin-only policy、hooks 总闸和 admin-trusted source 不是同一层限制。
14. 为什么 `relevant skills`、static listing、remote skills 与 `shortId` 反馈回路不是同一条公开主线。
15. 为什么 `/hooks` 菜单、已配置 hooks、已注册 hooks 和实际会执行的 hooks 不是同一对象。
16. 为什么 `/mcp` 菜单、全局配置总览、按名解析与 Agent `mcpServers` 不是同一类 server。
17. 为什么插件“装好了、改好了、提示待刷新了、当前会话已吃到”不是同一状态。
18. 为什么插件有时会自己出现、有时只提示 `/reload-plugins`，而 startup trust、background install、headless refresh 又不是同一条自动链。
19. 为什么 `print` 不是没有 UI 的 REPL，为什么 headless 的首问就绪、StructuredIO 与 `--sdk-url` 又不是同一层对象。
20. 为什么 `server`、`remote-control`、`assistant`、`doctor` 与 `mcp list|get` 虽然都在会外层，却不是同一类 host、viewer 或 health-check 对象。
21. 为什么 `skip trust dialog`、项目级 `.mcp.json` 批准、`doctor` 与 `mcp list|get` 不属于同一层安全或运行时状态。
22. 为什么 remote-control 的 workspace trust、bridge eligibility、trusted-device、policy 与 OAuth 前提不是同一把钥匙。
23. 为什么 remote-control 的 auto-connect、mirror、perpetual continuity 与 `--continue` 不是同一种 bridge 重连。
24. 为什么 remote-control 的设置默认、显式开关、状态展示与当前断开语义不是同一个按钮。
25. 为什么 remote-control 的链接、二维码与 ID 不是同一种定位符。
26. 为什么 remote-control 的会内开桥、启动带桥与 standalone host 不是同一种入口。
27. 为什么 remote session client、viewer 与 bridge host 不是同一种远程工作流。
28. 为什么远端的权限提示、会话控制与命令白名单不是同一种控制合同。
29. 为什么远端会话的连接告警、后台任务、viewer ownership 与 bridge reconnect 不是同一张运行态面。
30. 为什么 bridge 的状态词、恢复厚度与动作上限不是同一个“已恢复”。
31. 为什么 bridge 的故障提示、当前会话停机与默认回退不是同一种关闭。
32. 为什么 bridge 的断开、退出与恢复轨迹不是同一种收口。
33. 为什么 bridge 的 stale pointer、过期环境与瞬态重试不是同一种恢复失败。
34. 为什么 bridge 的 trust、`/login`、restart、fresh fallback 与 retry 不是同一种补救动作。
35. 为什么 remote-control 的 build 不可用、资格不可用、组织拒绝与权限噪音不是同一种“不能用”。
36. 为什么 standalone remote-control 的 spawn topology、并发上限与 cwd 初始会话不是同一种调度。
37. 为什么 standalone remote-control 的 banner、状态行、QR 与会话列表不是同一种显示面。
38. 为什么 standalone remote-control 的 `--name`、`--permission-mode`、`--sandbox` 与 title 回填不是同一种继承。
39. 为什么 remote-control 的工具审批、网络放行、自动批准与提示撤销不是同一种批准。
40. 为什么 standalone remote-control 的 `sdk-url`、ingress、secret、token 与 worker epoch 不是同一种连接凭证。
41. 为什么 standalone remote-control 的 environment 注册、work 租约、session 归档与环境销毁不是同一种生命周期操作。
42. 为什么 bridge 的 compat session ID、infra session ID 与 retag / compare helper 不是同一种标识。
43. 为什么 standalone remote-control 的 child refresh、heartbeat 认证与 v2 reconnect 不是同一种 token refresh。
44. 为什么 standalone remote-control 的 work secret、ack 时机、existing session refresh 与 unknown work 不是同一种领取。
45. 为什么 bridge 的 session timeout、watchdog、kill 与 failed remap 不是同一种 timeout。
46. 为什么 bridge 的 seek-work poll、at-capacity heartbeat、reconnecting 预算、sleep reset 与 give up 不是同一种重试。
47. 为什么 headless remote-control 的 startup preflight、permanent error 与 transient retry 不是同一种开桥失败。
48. 为什么 standalone remote-control 的一次性说明、账号资格、项目偏好与当前 effective mode 不是同一个默认。
49. 为什么 CCR v2 worker 的初始化、状态恢复、保活与代际退场不是同一种存活合同。
50. 为什么远端看到的 `worker_status`、`pending_action`、`task_summary` 与 `session_state_changed` 不是同一张运行态面。
- 为什么 `task_summary` 与 `post_turn_summary` 的 carrier、clear、union visibility 与 forwarding suppression 不是同一条 summary contract。
- 为什么 `lastMessage`、最终输出语义与 raw stream tail 不是同一个“最后一个消息”。
- 为什么已交付 suggestion 在 `interrupt`、`end_session` 与 output close 之后不一定留下 accepted / ignored telemetry。
- 为什么 `pending_action`、`task_summary` 在 CCR startup 会被 scrub stale，却不会被本地恢复回填。
- 为什么 deferred suggestion cleanup 里残留的 `pendingLastEmittedEntry` 更像 inert stale slot，而不是外部协议 bug。
- 为什么 `post_turn_summary` 不是 core SDK-visible，却不等于完全不可见。
- 为什么 `stream-json --verbose` 的 raw wire 输出不是普通 core SDK message surface。
- 为什么 metadata 里的 `model` 在恢复时要走 separate override sink，而不是普通 `AppState` mapper。
- 为什么 direct connect 对 `post_turn_summary` 的过滤不是消息不存在，而是 callback consumer-path narrowing。
- 为什么 headless print 的 streamlined output 不是 terminal semantics 后处理，而是 pre-wire rewrite。
- 为什么 `streamlined_*` 与 `post_turn_summary` 虽然同样在 direct connect 的过滤名单里，却不是同一种 suppress reason。
- 为什么 builder/control transport、public SDK、direct-connect callback 与 UI consumer 不是同一张可见性表。
- 为什么 `shouldIncludeInStreamlined(...)`、assistant/result 双入口与 `null` suppression 不是同一种消息简化。
- 为什么 streamlined path 里的 result passthrough 不是 terminal semantic 主位保留。
- 为什么 UI consumer 的 `message` / `stream_event` / `ignored` 三分法不是 callback surface 的镜像映射。
51. 为什么 `permission_mode`、`is_ultraplan_mode` 与 `model` 不是同一种远端可恢复会话参数。
52. 为什么 `task_started`、`task_progress`、`task_notification` 与 `session_state_changed` 不是同一种远端事件流。
53. 为什么 CCR v2 remote bridge 的 `transport rebuild`、initial flush、`flush gate` 与 `sequence resume` 不是同一步。
54. 为什么 remote bridge 的 `received`、`processed`、write cursor、echo dedup 与 replay dedup 不是同一种去重。
55. 为什么 remote bridge 的 `can_use_tool`、`control_response`、`control_cancel_request` 与 `result` 不是同一种状态交接。
56. 为什么 `useRemoteSession`、`useDirectConnect` 与 `useSSHSession` 不是同一种远端会话合同。
57. 为什么 attached assistant REPL 的 `hasInitialPrompt`、history paging 与 title ownership 不是同一种主权。
58. 为什么 `cc://`、`open`、`createDirectConnectSession`、`ws_url` 与 fail-fast disconnect 不是同一种 direct connect 合同。
59. 为什么 direct connect 的 `can_use_tool`、`interrupt`、`result`、disconnect 与 stderr shutdown 不是同一种收口。
60. 为什么 direct connect 的 `init`、`status`、`tool_result`、`tool_progress` 与 ignored families 不是同一种 transcript surface。
61. 为什么 direct connect 的 `Connected to server`、`Remote session initialized`、`busy/waiting/idle`、`PermissionRequest` 与 stderr disconnect 不是同一张状态板。
62. 为什么 direct connect 的 `Ctrl+O transcript`、`verbose`、`showAllInTranscript` 与 `tool_result` 不是同一种可见性层。
63. 为什么 remote session 的 `remoteConnectionStatus` / `remoteBackgroundTaskCount` 与 direct connect 的 `busy/waiting/idle` 不是同一种状态来源。
64. 为什么 remote session 的 `stream_event` / `task_started` / `task_notification` 与 direct connect 的 `transcript/overlay/stderr` 不是同一种消费合同。
65. 为什么同一 remote session 事件不会以同样厚度出现在 transcript、streaming、footer 和 brief idle 里。
66. 为什么 remote session 的 `slash_commands`、`stream_event`、`task_*` 与 `status=compacting` 不是同一种消费者。
67. 为什么 remote session 的远端发布命令面、本地保留命令面、输入框候选面与实际执行路由不是同一张命令表。
68. 为什么同一 REPL 审批外观背后其实是五张不同的主权图，而不是同一种本地 approval shell。
69. 为什么 `permission_request`、`sandbox_permission_request` 与 `plan_approval_request` 虽然都走 teammate mailbox，却不是同一种协议族。
70. 为什么 `shutdown_request`、`shutdown_approved` 与 `shutdown_rejected` 也走 teammate mailbox，却属于 termination lifecycle，而不是 approval protocol。
71. 为什么 `shutdown_request`、`shutdown_rejected`、`shutdown_approved`、`teammate_terminated` 与 `stopping` 不会完整落在同一可见消息面。
72. 为什么 `shutdown_request`、`shutdown_approved`、`shutdown_rejected`、`teammate_terminated` 在 routing 层就已经分道扬镳，而不会共用同一条 mailbox 通道。
73. 为什么 `useInboxPoller`、`attachments.ts` 与 `print.ts` 虽然都在处理 shutdown 收口，却不共享同一条宿主路径。
74. 为什么同一个 in-process teammate 明明仍是 `running`，却会在 `stopping`、`awaiting approval`、`idle` 与 working 之间投影成不同状态面。
75. 为什么 headless `print` 在 `inputClosed` 之后不会直接结束，而会进入一条先等 idle、再 shutdown team 的 drain 协议。
76. 为什么 headless `print` 在 teammates 仍 active 时会持续 poll unread mailbox，并把 teammate 输出折返进主 run loop，而不是像被动 inbox reader 那样工作。
77. 为什么 headless `print` 的主线程队列更像 single-consumer pump，而不是一个普通事件订阅器。
78. 为什么 headless `print` 的 prompt batching 不是普通批量出队，而是 workload/meta/uuid 受约束的单 turn 合批。
79. 为什么 headless `print` 的 `task-notification` 不是普通进度提示，而是 SDK consumer 和模型双重消费的结果 envelope。
80. 为什么 headless `print` 的 terminal XML、statusless ping 与 direct SDK emit 不是同一种关单信号。
81. 为什么 headless `print` 的任务结果会同时落在 task bookend、command lifecycle 与 attachment 内容三套账本上。
82. 为什么 headless `print` 的 `task_started/task_progress/task_notification` 三段式 SDK 事件不是 queue lifecycle 那一层。
83. 为什么 headless `print` 的 `task_progress/workflow_progress` 进展流属于宿主投影，而不是模型图层。
84. 为什么 headless `print` 的 task result 会在 XML re-entry 路和 direct SDK close 路之间分叉，而不是统一回流。
85. 为什么 headless `print` 的 `drainSdkEvents()` 不是一次普通 drain，而是一组时序护栏。
86. 为什么 headless `print` 的 `idle` 不是 finally 里的普通状态回写，而是 authoritative turn-over signal。
87. 为什么 headless `print` 的 suggestion 不是生成即交付，而是要等真实交付后才进入 acceptance tracking。
88. 为什么 headless `print` 的 late system tail 不能抢走 result 的 semantic last-message 主位。
89. 为什么 `convertToolResults`、`convertUserTextMessages` 与 success `result` ignored 虽然同在 adapter，却不是同一种 UI consumer policy。
90. 为什么 success `result` ignored、error `result` visible、turn-end 判定与 busy state 不是同一种 completion signal。
91. 为什么 callback-visible init、transcript init 提示与 slash bootstrap 不是同一种初始化可见性。
92. 为什么 viewerOnly 的本地 echo 去重、history attach overlap 与 transcript 追加不是同一种 replay dedup。
93. 为什么 direct connect 的 `setIsLoading(true/false)` 不是同一种 loading lifecycle。
94. 为什么 full init payload、bridge redacted init 与 transcript model-only banner 不是同一种 init payload thickness。
95. 为什么 history init banner 回放与 live slash 恢复不是同一种 attach 恢复语义。
96. 为什么 timeout watchdog、warning、reconnecting 与 disconnected 不是同一种 remote recovery 状态。
97. 为什么 `viewerOnly`、history、timeout、`Ctrl+C` 与 title 不是同一种 assistant viewer 特判。
98. 为什么 `warning`、连接态、force reconnect 与 `viewerOnly` 不是同一种 recovery signer。
99. 为什么 `handleClose`、`scheduleReconnect`、force reconnect、`onReconnecting` 与 `onClose` 不是同一种 transport recovery 状态。
100. 为什么 `PERMANENT_CLOSE_CODES`、`4001` 与 reconnect budget 不是同一种 terminality 规则。
101. 为什么 `compacting`、boundary、timeout、`4001` 与 keep-alive 不是同一种 compaction 恢复信号。
102. 为什么 `SessionsWebSocket 4001`、`WebSocketTransport 4001` 与 `session not found` 不是同一种合同。
103. 为什么 `headersRefreshed`、`autoReconnect`、sleep detection 与 `4003` refresh path 不是同一种恢复主权。
104. 为什么 `remoteSessionUrl`、brief line、bridge pill、bridge dialog 与 attached viewer 不是同一种 surface presence。
105. 为什么 `warning` transcript、`remoteConnectionStatus`、`remoteBackgroundTaskCount` 与 brief line 不是同一张 remote status table。
106. 为什么 `worker_status`、`external_metadata`、`AppState shadow` 与 SDK event projection 不是同一种前台状态消费链。
107. 为什么 `pending_action`、`post_turn_summary`、`task_summary` 与 `externalMetadataToAppState` 不是同一种“前台已消费”。
108. 为什么 `createV1ReplTransport`、`createV2ReplTransport`、`reportState`、`reportMetadata` 与 `reportDelivery` 不是同一种 bridge 状态消费链。
109. 为什么 `createDirectConnectSession`、`DirectConnectSessionManager`、`useDirectConnect`、`remoteSessionUrl` 与 `replBridgeConnected` 说明 direct connect 更像 foreground remote runtime，而不是 remote presence store。
110. 为什么 `ccrMirrorEnabled`、`outboundOnly`、`system/init`、`replBridgeConnected` 与 `sessionUrl/connectUrl` 说明同属 v2 的 bridge 也不是同一种活跃 front-state surface。
111. 为什么 `pending_action.input`、`task_summary`、`post_turn_summary`、`externalMetadataToAppState`、`print.ts` 与 `directConnectManager` 说明“frontend 会读”更像跨前端 consumer path，而不是当前 CLI foreground contract。
112. 为什么 `activeRemote`、`useDirectConnect`、`useSSHSession`、`useRemoteSession`、`remoteSessionUrl` 与 `directConnectServerUrl` 说明共用交互壳，不等于共用 remote presence ledger。
113. 为什么 `ccrMirrorEnabled`、`isEnvLessBridgeEnabled`、`initReplBridge`、`outboundOnly`、`replBridge` 与 `createV2ReplTransport` 说明启动意图、实现选路与实际 runtime topology 不是同一层 mirror 合同。
114. 为什么 `SDKPostTurnSummaryMessageSchema`、`StdoutMessageSchema`、`SDKMessageSchema`、`print.ts` 与 `directConnectManager` 说明 `post_turn_summary` 的 wide-wire、`@internal` 与 foreground narrowing 不是同一种可见性。
115. 为什么 `remoteSessionUrl`、`remoteConnectionStatus`、`remoteBackgroundTaskCount`、`useRemoteSession`、`activeRemote` 与 `getIsRemoteMode` 说明 remote-session presence ledger 不会自动被 direct connect、ssh remote 复用。
116. 为什么 `outboundOnly`、`useReplBridge`、`initBridgeCore`、`handleServerControlRequest`、`handleIngressMessage` 与 `createV2ReplTransport` 说明 hook 已经在 mirror，本体运行时却仍可能落成 gray runtime。
117. 为什么 `getIsRemoteMode`、`setIsRemoteMode`、`activeRemote`、`remoteSessionUrl`、`commands/session` 与 `StatusLine` 说明全局 remote behavior 开关，不等于 remote presence truth。
118. 为什么 `getIsRemoteMode`、`commands/session`、`remoteSessionUrl`、`SessionInfo`、`PromptInputFooterLeftSide` 与 `StatusLine` 说明 `/session` 的命令显隐与 pane 内容不是同一种 remote mode。
119. 为什么 `getIsRemoteMode`、`remoteSessionUrl`、`useRemoteSession`、`StatusLine`、`PromptInputFooterLeftSide`、`SessionInfo` 与 `assistantInitialState` 说明 remote bit 为真但 URL 缺席时，CCR 本体仍可继续，而 link 与 QR affordance 会停摆。
120. 为什么 `assistant viewer`、`--remote` TUI、`viewerOnly`、`remoteSessionUrl` 与 `filterCommandsForRemoteMode` 说明同一 coarse remote bit 不等于同样厚度的 remote 合同。
121. 为什么 `REMOTE_SAFE_COMMANDS`、`filterCommandsForRemoteMode`、`handleRemoteInit`、`session` 与 `mobile` 说明 remote-safe 命令面不是 runtime readiness proof。
122. 为什么 `CLAUDE_CODE_REMOTE`、`getIsRemoteMode()`、`print`、`reload-plugins` 与 `settingsSync` 说明 headless remote 分支不是 interactive remote bit 的镜像。
123. 为什么 `CLAUDE_CODE_REMOTE_MEMORY_DIR`、`memdir`、`SessionMemory`、`extractMemories` 与 `print` 说明 remote 记忆持久化不是单根目录，而是 auto-memory 根与 session 账本的双轨体系。
124. 为什么 `system/init.slash_commands`、`REMOTE_SAFE_COMMANDS`、`PromptInput`、`REPL`、`processUserInput` 与 `print` 说明 slash 不是一张命令表，而是声明面、文本载荷与 runtime 再解释的三段合同。
125. 为什么 `getSessionId`、`switchSession`、`StatusLine`、`assistant viewer`、`remoteSessionUrl` 与 `useRemoteSession` 说明 `remote.session_id` 可见，不等于当前前端拥有那条 remote session。
126. 为什么 `sessionStorage`、`hydrateFromCCRv2InternalEvents`、`sessionRestore`、`listSessionsImpl`、`SessionPreview` 与 `sessionTitle` 说明 durable session metadata 不是 live `system/init`，也不是 foreground `external_metadata`。
127. 为什么 `SENTINEL_LOADING`、`SENTINEL_LOADING_FAILED`、`SENTINEL_START`、`useAssistantHistory`、`remoteConnectionStatus` 与 `BriefIdleStatus` 说明 attached viewer 的历史翻页哨兵不是 remote presence surface。
128. 为什么 `discoverAssistantSessions`、`launchAssistantInstallWizard`、`launchAssistantSessionChooser`、`createRemoteSessionConfig` 与 attach banner 说明 `claude assistant` 的发现、安装、选择与附着不是同一种 connect flow。
129. 为什么 `showSetupDialog`、`renderAndRun`、`launchResumeChooser`、`launchRepl`、`AppStateProvider` 与 `KeybindingSetup` 说明 setup-dialog host 与 attached REPL host 不是同一种 interactive host。
130. 为什么 `getSessionFilesLite`、`loadFullLog`、`SessionPreview`、`useAssistantHistory` 与 `fetchLatestEvents` 说明 `/resume` preview 的本地 transcript 快照不是 attached viewer 的 remote history。
131. 为什么 `getSessionFilesLite`、`enrichLogs`、`LogSelector`、`SessionPreview` 与 `loadFullLog` 说明 `/resume` 的列表摘要面不是 preview transcript。
132. 为什么 `SessionPreview`、`loadFullLog`、`loadConversationForResume`、`switchSession` 与 `adoptResumedSessionFile` 说明 `/resume` 的 preview transcript 不是正式 session restore。
133. 为什么 `forkSession`、`switchSession`、`copyPlanForFork`、`restoreWorktreeForResume` 与 `adoptResumedSessionFile` 说明 `--fork-session` 不是较弱的原会话恢复，而是新 session 分叉。
134. 为什么 `loadConversationForResume`、`deserializeMessagesWithInterruptDetection`、`copyPlanForResume`、`fileHistoryRestoreStateFromLog` 与 `processSessionStartHooks` 说明 resume 恢复包不是同一种内容载荷。
135. 为什么 `main.tsx`、`launchResumeChooser`、`ResumeConversation`、`resume.tsx` 与 `REPL.resume` 说明 `--continue`、startup picker 与会内 `resume` 共享恢复合同，却不是同一种入口宿主。
136. 为什么 `main.tsx`、`print.ts`、`loadInitialMessages`、`ResumeConversation` 与 `REPL.resume` 说明 interactive resume host 与 headless print host 共享恢复语义，却不是同一种宿主族。
137. 为什么 `print.ts`、`parseSessionIdentifier`、`hydrateRemoteSession` 与 `loadConversationForResume` 说明 print resume 的 parse、hydrate、restore 不是同一种前置阶段。
138. 为什么 `deserializeMessages`、`SessionEnd`、`SessionStart` 与 `interrupted-resume` 说明恢复前后的合法化、修复与 hook 注入不是同一种 runtime stage。
139. 为什么 `hydrateFromCCRv2InternalEvents`、`externalMetadataToAppState`、`hydrateRemoteSession` 与 `startup fallback` 说明 print resume 的 remote recovery 不是同一种 stage。
140. 为什么 `print.ts`、`externalMetadataToAppState`、`setMainLoopModelOverride` 与 `startup fallback` 说明 print remote recovery 的 transcript、metadata 与 emptiness 不是同一种 stage。
141. 为什么 `restoredWorkerState`、`externalMetadataToAppState`、`SessionExternalMetadata` 与 `RemoteIO` 说明 CCR v2 的 metadata readback 不是 observer metadata 的同一种本地消费合同。
142. 为什么 `StructuredIO`、`RemoteIO`、`setInternalEventReader`、`setInternalEventWriter` 与 `flushInternalEvents` 说明 headless transport 的协议宿主不等于同一种恢复厚度。
143. 为什么 `/resume`、`--continue`、`print --resume` 与 `remote-control --continue` 说明 stable conversation resume、headless remote hydrate 与 bridge continuity 不是同一种接续来源。
144. 为什么 `print --continue`、`print --resume session-id`、`print --resume url` 与 `loadConversationForResume` 说明同属 headless resume，也不是同一种 source certainty。
145. 为什么 `loadMessagesFromJsonlPath`、`parseSessionIdentifier`、`loadConversationForResume` 与 `sessionId` 说明 `print --resume .jsonl` 与 `print --resume session-id` 不是同一种 local artifact provenance。
146. 为什么 `readBridgePointerAcrossWorktrees`、`getBridgeSession`、`reconnectSession` 与 `environment_id` 说明 `remote-control --continue` 与 `remote-control --session-id` 不是同一种 bridge authority。

- [01-命令工具/README.md](./01-%E5%91%BD%E4%BB%A4%E5%B7%A5%E5%85%B7/README.md)
- [02-能力边界/README.md](./02-%E8%83%BD%E5%8A%9B%E8%BE%B9%E7%95%8C/README.md)
- [03-技能与扩展/README.md](./03-%E6%8A%80%E8%83%BD%E4%B8%8E%E6%89%A9%E5%B1%95/README.md)
- [04-功能面七分法.md](./04-%E5%8A%9F%E8%83%BD%E9%9D%A2%E4%B8%83%E5%88%86%E6%B3%95.md)
- [05-任务到入口速查矩阵.md](./05-%E4%BB%BB%E5%8A%A1%E5%88%B0%E5%85%A5%E5%8F%A3%E9%80%9F%E6%9F%A5%E7%9F%A9%E9%98%B5.md)
- [06-高价值入口运行时合同速查.md](./06-%E9%AB%98%E4%BB%B7%E5%80%BC%E5%85%A5%E5%8F%A3%E8%BF%90%E8%A1%8C%E6%97%B6%E5%90%88%E5%90%8C%E9%80%9F%E6%9F%A5.md)
