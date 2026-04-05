# Feature Gate 与可见性索引

这一页专门回答一个容易被混淆的问题：

“源码里看见了”不等于“普通用户稳定可用”。

Claude Code 的公开面至少分四层：

1. 稳定公开面。
2. 条件公开面。
3. ant-only / 内部面。
4. 只剩门控影子的缺失实现面。

## 一、命令层的显式门控

`src/commands.ts` 中能直接看到一组通过 `feature()` 或 `USER_TYPE === 'ant'` 控制的命令。

### 条件公开命令

| 命令 | 门控 |
| --- | --- |
| `chrome` | `availability: ['claude-ai']` + Beta / 平台条件 |
| `proactive` | `PROACTIVE` / `KAIROS` |
| `brief` | `KAIROS` / `KAIROS_BRIEF` |
| `assistant` | `KAIROS` |
| `bridge` / `remote-control` | `BRIDGE_MODE` |
| `remoteControlServer` | `DAEMON` + `BRIDGE_MODE` |
| `voice` | `VOICE_MODE` |
| `feedback` | provider / privacy / policy / `USER_TYPE` 条件 |
| `force-snip` | `HISTORY_SNIP` |
| `workflows` | `WORKFLOW_SCRIPTS` |
| `web-setup` | `CCR_REMOTE_SETUP` |
| `subscribe-pr` | `KAIROS_GITHUB_WEBHOOKS` |
| `ultraplan` | `ULTRAPLAN` |
| `torch` | `TORCH` |
| `peers` | `UDS_INBOX` |
| `fork` | `FORK_SUBAGENT` |
| `buddy` | `BUDDY` |

### ant-only / 内部命令

`INTERNAL_ONLY_COMMANDS` 清楚表明，一批命令本来就不应被当作普通用户稳定面：

- `bughunter`
- `good-claude`
- `bridge-kick`
- `env`
- `oauth-refresh`
- `debug-tool-call`
- `autofix-pr`
- `teleport`
- `summary`
- `backfill-sessions`
- `mock-limits`

此外，`/tag` 虽然不在 `INTERNAL_ONLY_COMMANDS` 常量里，但 `src/commands/tag/index.ts` 直接以 `process.env.USER_TYPE === 'ant'` 控制可见性，也应按内部命令处理。

## 二、工具层的显式门控

`src/tools.ts` 里门控更重，因为很多工具是运行时能力边界。

### 条件公开工具

| 工具 | 门控 |
| --- | --- |
| `SleepTool` | `PROACTIVE` / `KAIROS` |
| `Cron*` | `AGENT_TRIGGERS` |
| `RemoteTriggerTool` | `AGENT_TRIGGERS_REMOTE` |
| `MonitorTool` | `MONITOR_TOOL` |
| `SendUserFileTool` | `KAIROS` |
| `PushNotificationTool` | `KAIROS` / `KAIROS_PUSH_NOTIFICATION` |
| `SubscribePRTool` | `KAIROS_GITHUB_WEBHOOKS` |
| `OverflowTestTool` | `OVERFLOW_TEST_TOOL` |
| `CtxInspectTool` | `CONTEXT_COLLAPSE` |
| `TerminalCaptureTool` | `TERMINAL_PANEL` |
| `WebBrowserTool` | `WEB_BROWSER_TOOL` |
| `ListPeersTool` | `UDS_INBOX` |
| `WorkflowTool` | `WORKFLOW_SCRIPTS` |
| `Team*` | `isAgentSwarmsEnabled()`，仍受实验开关与 killswitch 约束 |

### ant-only / 内部工具

| 工具 | 条件 |
| --- | --- |
| `REPLTool` | `USER_TYPE === 'ant'` |
| `SuggestBackgroundPRTool` | `USER_TYPE === 'ant'` |
| `TungstenTool` | `USER_TYPE === 'ant'` |
| `ConfigTool` | 在工具面主要见于 ant 构建 |

### 额外条件工具

- `VerifyPlanExecutionTool` 受环境变量控制。
- `LSPTool` 受环境/能力条件控制。
- `EnterWorktree` / `ExitWorktree` 当前已进入公开主路径；真正限制更多在 Git/worktree 上下文，而不是 rollout gate。
- `Task*` 工具还取决于 Todo v2 相关条件。
- `RemoteTriggerTool` 不是只有 build gate；还会继续受远程资格、OAuth 与策略条件影响。

## 三、bundled skills 的显式门控

`src/skills/bundled/index.ts` 里可直接看到条件技能：

| 技能 | 门控 |
| --- | --- |
| `dream` | `KAIROS` / `KAIROS_DREAM` |
| `hunter` | `REVIEW_ARTIFACT` |
| `loop` | `AGENT_TRIGGERS` |
| `schedule` | `AGENT_TRIGGERS_REMOTE` |
| `claude-api` | `BUILDING_CLAUDE_APPS` |
| `run-skill-generator` | `RUN_SKILL_GENERATOR` |

## 四、如何保护稳定功能与灰度功能

在 userbook 写作上，至少要继续区分六种判断来源：

- `availability`：决定“谁能看见”。
- `isEnabled()`：决定“现在能不能用”。
- `feature()`：决定“这条能力是否被构建/门控保留”。
- `USER_TYPE === 'ant'`：决定“是不是内部面”。
- DCE / 缺失实现：决定“能不能从事实写成功能”。
- 远程策略 / managed settings：决定“本地公开面会不会被远程改写”。

### `availability`

- 更像静态资格筛选。
- 更适合理解为“面向特定账户类型”。

### `isEnabled()`

- 更像动态运行时资格。
- 更适合理解为“在当前环境/设置下可用”。

### 远程策略与 managed settings

- bridge/remote-control 还会受 entitlement、最小版本、组织策略、远程设置影响。
- 某些远程设置对用户并非纯建议，而会要求接受或导致退出。

### 稳定功能的保护原则

- 只把默认可见、默认可推断、没有明显 feature gate 的能力写进“推荐主线”。
- 稳定主线必须尽量依赖公共命令、基础工具和明确存在的 UI。

### 灰度功能的保护原则

- 单独标注条件，不偷渡进主线。
- 明确它依赖的 gate、账户或环境。
- 明确“源码里可见”与“普通用户实际可用”之间的差距。

### 内部功能的保护原则

- 仅作为演化方向、能力影子或实现证据。
- 不写成普通用户操作建议。

## 五、遗漏风险说明

即便有这份索引，仍有三类遗漏风险：

1. `isEnabled()` 内部再读配置、环境或 GrowthBook，导致“注册了但本次会话不出现”。
2. 某些命令/工具的真正实现被转发到 web、remote 或插件层。
3. 已发布构建有 DCE 缺口，部分模块只有门控引用，没有实现体。

## 源码锚点

- `src/commands.ts`
- `src/tools.ts`
- `src/skills/bundled/index.ts`
- `src/bridge/bridgeEnabled.ts`
- `src/services/remoteManagedSettings/index.ts`
- `src/services/policyLimits/index.ts`
- `docs/en/02-hidden-features-and-codenames.md`
- `docs/en/05-future-roadmap.md`
