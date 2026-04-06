# Workspace Trust、Bridge Eligibility 与 Trusted Device 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/23-Workspace Trust、Bridge Eligibility 与 Trusted Device：为什么 remote-control 的 trust、auth、policy 不是同一把钥匙.md`
- `05-控制面深挖/21-Host、Viewer 与 Health Check：为什么 server、remote-control、assistant、doctor 不能写成同一类会外入口.md`
- `05-控制面深挖/22-Trust Dialog、项目级 .mcp.json 批准与 Health Check：为什么 skip trust dialog 不等于 project MCP 已被批准.md`
- `05-控制面深挖/14-来源信任、Trust Dialog 与 Plugin-only Policy：扩展面为何分级信任.md`

## 1. 三层对象总表

| 层 | 回答的问题 | 典型证据 | 正文语气 |
| --- | --- | --- | --- |
| `Workspace Trust` | 这个目录能不能成为受信任的 bridge host 工作区 | Trust Dialog、`checkHasTrustDialogAccepted()` | 写成工作区信任边界 |
| `Bridge Eligibility` | 当前账号/版本/组织策略能不能进入 remote-control | OAuth、feature gate、subscriber、`allow_remote_control` | 写成资格门/条件公开 |
| `Trusted Device` | 这台设备在 bridge/code-session API 上是否带 elevated auth 材料 | `X-Trusted-Device-Token`、`/login` enrollment | 写成设备认证层 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| trust 通过 = remote-control 一定可用 | bridge 还要过 login、gate、版本、组织策略 |
| `/login` = 接受 workspace trust | `/login` 处理账号态，trust 处理目录态 |
| trusted-device = trusted workspace | 一个是设备认证，一个是工作区信任 |
| `allow_remote_control` = trust 开关 | 它是组织策略，不是目录信任 |
| standalone bridge 不弹 trust = 已自动 trust | 它要求 prior trust，而不是替你跑 trust UI |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定公开 | Trust Dialog、workspace trust、`/login`、组织策略效果 |
| 条件公开 | `remote-control`、`/remote-control`、bridge entitlement、trusted-device header |
| 内部/实现层 | headless bridge worker、SDK 预授权路径、rollout gate 细节 |

## 4. 五个高价值判断问题

- 我现在卡的是目录 trust、bridge 资格门，还是 trusted-device 认证层？
- 这里说的是 prior trust，还是当前交互 trust UI？
- 当前失败是没登录、没订阅/没开 gate、版本过低，还是组织策略禁用？
- 这里的 `trusted` 指的是 workspace，还是 device？
- 我是不是把 trust、login、policy、header 混写成了一个“remote-control 已被信任”的状态？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/entrypoints/cli.tsx`
- `claude-code-source-code/src/commands/bridge/bridge.tsx`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts`
- `claude-code-source-code/src/commands/login/login.tsx`
- `claude-code-source-code/src/bridge/trustedDevice.ts`
- `claude-code-source-code/src/bridge/bridgeApi.ts`
- `claude-code-source-code/src/bridge/codeSessionApi.ts`
- `claude-code-source-code/src/utils/config.ts`
