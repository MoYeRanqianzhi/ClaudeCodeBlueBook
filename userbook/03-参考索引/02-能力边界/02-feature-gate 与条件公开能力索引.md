# feature-gate 与条件公开能力索引

这份索引回答的不是“功能是什么”，而是“为什么源码里看到了，但当前用户未必能直接用到”。

## 一、命令层 gate

`src/commands.ts` 中能直接看到一批被 `feature()` 包裹的命令：

- `PROACTIVE` / `KAIROS`
- `KAIROS_BRIEF`
- `BRIDGE_MODE`
- `DAEMON`
- `VOICE_MODE`
- `HISTORY_SNIP`
- `WORKFLOW_SCRIPTS`
- `CCR_REMOTE_SETUP`
- `EXPERIMENTAL_SKILL_SEARCH`
- `KAIROS_GITHUB_WEBHOOKS`
- `ULTRAPLAN`
- `TORCH`
- `UDS_INBOX`
- `FORK_SUBAGENT`
- `BUDDY`

这些命令即使出现在源码里，也不应直接写成普通用户稳定能力。

## 二、工具层 gate

`src/tools.ts` 中的条件工具更密集，典型包括：

- `SleepTool`
- `Cron*`
- `RemoteTriggerTool`
- `MonitorTool`
- `SendUserFileTool`
- `PushNotificationTool`
- `SubscribePRTool`
- `OverflowTestTool`
- `CtxInspectTool`
- `TerminalCaptureTool`
- `WebBrowserTool`
- `SnipTool`
- `ListPeersTool`
- `WorkflowTool`

另有一批 `USER_TYPE === 'ant'` 条件工具：

- `TungstenTool`
- `REPLTool`
- `SuggestBackgroundPRTool`

## 三、入口层 gate

`src/entrypoints/cli.tsx` 还定义了很多快路径入口，但大多带 feature gate，例如：

- `remote-control`
- `daemon`
- `ps/logs/attach/kill`
- `new/list/reply`
- `environment-runner`
- `self-hosted-runner`
- `--dump-system-prompt`
- `--computer-use-mcp`

这说明“CLI 看起来像有入口”不等于“这是普通用户主线”。

## 四、bundled skill 层 gate

`src/skills/bundled/index.ts` 里有条件注册的 bundled skills：

- `dream`
- `hunter`
- `loop`
- `scheduleRemoteAgents`
- `claudeApi`
- `runSkillGenerator`

这些比内部工具更接近公开面，但依然不应默认写成全量稳定能力。

## 五、文档写法建议

### 看到 gate

应先问：

1. 这能力是否在当前构建里实际注册。
2. 即便注册，是否还有 `isEnabled()`、平台、账户或策略条件。
3. 它更适合被写成“条件公开能力”还是“灰度/内部能力”。

### 推荐写法

- “源码中存在，受 feature gate 控制。”
- “在特定环境或构建下公开。”
- “不应默认纳入普通用户稳定工作流。”

## 核心依据文件

- `src/commands.ts`
- `src/tools.ts`
- `src/skills/bundled/index.ts`
- `src/entrypoints/cli.tsx`
