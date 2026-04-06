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
87. 为什么 headless `print` 的 late system tail 不能抢走 result 的 semantic last-message 主位。

- [01-命令工具/README.md](./01-%E5%91%BD%E4%BB%A4%E5%B7%A5%E5%85%B7/README.md)
- [02-能力边界/README.md](./02-%E8%83%BD%E5%8A%9B%E8%BE%B9%E7%95%8C/README.md)
- [03-技能与扩展/README.md](./03-%E6%8A%80%E8%83%BD%E4%B8%8E%E6%89%A9%E5%B1%95/README.md)
- [04-功能面七分法.md](./04-%E5%8A%9F%E8%83%BD%E9%9D%A2%E4%B8%83%E5%88%86%E6%B3%95.md)
- [05-任务到入口速查矩阵.md](./05-%E4%BB%BB%E5%8A%A1%E5%88%B0%E5%85%A5%E5%8F%A3%E9%80%9F%E6%9F%A5%E7%9F%A9%E9%98%B5.md)
- [06-高价值入口运行时合同速查.md](./06-%E9%AB%98%E4%BB%B7%E5%80%BC%E5%85%A5%E5%8F%A3%E8%BF%90%E8%A1%8C%E6%97%B6%E5%90%88%E5%90%8C%E9%80%9F%E6%9F%A5.md)
