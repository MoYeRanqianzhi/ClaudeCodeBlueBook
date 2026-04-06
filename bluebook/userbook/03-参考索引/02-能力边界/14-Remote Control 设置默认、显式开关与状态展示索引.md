# Remote Control 设置默认、显式开关与状态展示索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/25-Settings、remote-control 命令、Footer 状态 pill 与 Bridge Dialog：为什么 bridge 的默认配置、当前开关与连接展示不是同一个按钮.md`
- `05-控制面深挖/24-remoteControlAtStartup、CCR Mirror、Perpetual Session 与 --continue：为什么 bridge 的 auto、mirror、resume 不是同一种重连.md`
- `05-控制面深挖/23-Workspace Trust、Bridge Eligibility 与 Trusted Device：为什么 remote-control 的 trust、auth、policy 不是同一把钥匙.md`

## 1. 四张面总表

| 面 | 回答的问题 | 典型对象 |
| --- | --- | --- |
| `Configuration Surface` | 以后默认怎么启动 remote-control | Settings `remoteControlAtStartup`、`ConfigTool` |
| `Control Surface` | 当前 session 现在要不要显式变成 full remote-control | `remote-control` 命令 |
| `Status Surface` | 系统现在愿不愿意把 bridge 状态展示给用户看 | Footer pill、`Remote Control active` |
| `Inspect / Disconnect Surface` | 当前桥连到哪里、这次断开要不要顺便持久化改默认 | Bridge Dialog |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `remoteControlAtStartup` = 我刚刚手动开了远控 | 一个是默认策略，一个是显式控制动作 |
| `ConfigTool` = `/remote-control` | 前者改配置面，后者改当前 session 控制面 |
| `ConfigTool` GET = 原始 tri-state 配置 | 它返回的可能是 effective value，`default` 只是 SET 特殊 token |
| 看见 footer pill = bridge 才存在 | 隐式 bridge 可能存在但不显示 pill |
| `Remote Control active` = `sessionActive` | `connected` 与 `sessionActive` 会被压成同一标签 |
| Dialog 里的 disconnect = 一定会持久化改默认 | 只有 `explicit` 时才顺便写 `remoteControlAtStartup=false` |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | Settings `remoteControlAtStartup`、`ConfigTool`、`remote-control` 命令、footer pill、Bridge Dialog |
| 条件公开 | Settings 项显示前提、Settings 与 `ConfigTool` 的可见性差异、`default` 回退到 CCR auto-connect、隐式 bridge 的 pill 可见性 |
| 内部/实现层 | `replBridgeEnabled`、`replBridgeExplicit`、`replBridgeConnected`、`replBridgeSessionActive`、状态压缩逻辑 |

## 4. 六个高价值判断问题

- 我现在改的是默认策略，还是当前 session 的显式动作？
- 这个入口写的是配置，还是只改当前 `AppState`？
- 这个入口读给我的，是 raw config 还是 effective value？
- 我看到的是状态展示，还是控制动作？
- 这个标签是 coarse status，还是完整内部状态机？
- 这次断开只影响当前桥，还是顺便改掉默认？
- 我是不是把设置面、控制面、状态面和查看面重新写成了一个“远控按钮”？

## 5. 源码锚点

- `claude-code-source-code/src/utils/config.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/commands/bridge/bridge.tsx`
- `claude-code-source-code/src/components/Settings/Config.tsx`
- `claude-code-source-code/src/tools/ConfigTool/ConfigTool.ts`
- `claude-code-source-code/src/tools/ConfigTool/supportedSettings.ts`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooter.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx`
- `claude-code-source-code/src/components/BridgeDialog.tsx`
- `claude-code-source-code/src/bridge/bridgeStatusUtil.ts`
