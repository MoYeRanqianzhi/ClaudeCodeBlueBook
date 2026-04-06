# Remote 运行态、后台任务与 viewerOnly ownership 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/30-remoteConnectionStatus、remoteBackgroundTaskCount、BriefIdleStatus 与 viewerOnly：为什么远端会话的连接告警、后台任务与 bridge 重连不是同一张运行态面.md`
- `05-控制面深挖/29-Bridge Permission Callbacks、Control Request 与 Bridge-safe Commands：为什么远端的权限提示、会话控制与命令白名单不是同一种控制合同.md`
- `05-控制面深挖/28-remote 会话、session 命令、assistant viewer 与 remote-safe commands：为什么远端会话 client、viewer 与 bridge host 不是同一种远程工作流.md`
- `05-控制面深挖/25-Settings、remote-control 命令、Footer 状态 pill 与 Bridge Dialog：为什么 bridge 的默认配置、当前开关与连接展示不是同一个按钮.md`

## 1. 五类运行态对象总表

| 对象 | 回答的问题 | 典型投影 |
| --- | --- | --- |
| `remoteConnectionStatus` | 当前 remote session 订阅流是否连通 / 回连 / 断开 | `BriefSpinner`、`BriefIdleStatus` 左侧告警 |
| `remoteBackgroundTaskCount` | 远端 daemon child 里还有多少后台任务 | brief 右侧 `n in background` |
| `BriefSpinner` / `BriefIdleStatus` | brief / assistant 该如何压缩显示连接与任务摘要 | brief status line |
| `remoteSessionUrl` / `remote` pill | 当前 REPL 是否持有一条可直接打开的 remote session URL | footer 左侧 `remote` pill |
| `viewerOnly` | 本地附着客户端是否拥有 title / interrupt / watchdog 等上层控制动作 | assistant viewer 的 ownership 边界 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `remoteConnectionStatus` = `replBridgeReconnecting` | 一个属于 remote session runtime，一个属于 bridge host runtime |
| `remoteBackgroundTaskCount` = 本地 `AppState.tasks` 长度 | 它来自远端 task lifecycle 事件，不是本地任务列表 |
| `BriefIdleStatus` = generic remote 状态页 | 它只是 brief / assistant 的空闲状态投影 |
| `viewerOnly` = 纯只读 viewer | 它仍可发消息，只是不拥有 interrupt / title / watchdog ownership |
| `viewerOnly` = viewer 完全不会 reconnect | 它改的是 ownership；底层共享 transport 仍可回连 |
| footer 的 `remote` pill = 任意 remote mode 指示灯 | 它只属于 `remoteSessionUrl` 这条 URL surface |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `Reconnecting...` / `Disconnected`、`n in background`、remote pill、assistant attach message、viewerOnly 的用户可见后果 |
| 条件公开 | `isBriefOnly` 挂载条件、`remoteSessionUrl` 只在 `--remote` TUI 链成立、assistant attach path、viewerOnly 配置字段本身 |
| 内部/实现层 | timeout 常量、compaction / close-code retry、重连清理补偿、ping / echo filter 等传输细节 |

## 4. 六个高价值判断问题

- 现在这个状态属于 remote session 运行态，还是 bridge host 运行态？
- 这个计数来自本地任务树，还是来自远端事件流？
- 我看到的是状态对象，还是 brief UI 对状态的投影？
- 当前 surface 依赖 `remoteSessionUrl`，还是只是 attach 提示消息？
- `viewerOnly` 改的是 transport 机制，还是上层控制 ownership？
- 我是不是又把 remote runtime、assistant brief surface 与 bridge 状态写成一张远端状态面？

## 5. 源码锚点

- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/components/Spinner.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
- `claude-code-source-code/src/remote/SessionsWebSocket.ts`
