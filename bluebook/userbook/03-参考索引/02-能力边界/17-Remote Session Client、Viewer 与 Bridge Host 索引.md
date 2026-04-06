# Remote Session Client、Viewer 与 Bridge Host 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/28-remote 会话、session 命令、assistant viewer 与 remote-safe commands：为什么远端会话 client、viewer 与 bridge host 不是同一种远程工作流.md`
- `05-控制面深挖/27-remote-control 命令、--remote-control、claude remote-control 与 Remote Callout：为什么 remote-control 的会内开桥、启动带桥与 standalone host 不是同一种入口.md`
- `05-控制面深挖/21-Host、Viewer 与 Health Check：为什么 server、remote-control、assistant、doctor 不能写成同一类会外入口.md`

## 1. 三类对象总表

| 对象 | 回答的问题 | 典型入口 |
| --- | --- | --- |
| `Remote Session Client` | 我要不要创建远端 session 并让当前 REPL 接上去 | `claude --remote` |
| `Viewer Client` | 我要不要把当前 REPL 附着到已有远端 session | `claude assistant [sessionId]` |
| `Bridge Host` | 我要不要把本机暴露成可附着的 bridge environment | `/remote-control`、`claude remote-control` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `--remote` = `claude assistant [sessionId]` | 一个创建并进入新远端 session，一个附着已有 session 做 viewer |
| `/session` = 任何 remote mode 都能用 | 它只依赖 `remoteSessionUrl` 这条链 |
| `remoteSessionUrl` = generic remote-mode 标记 | 它更窄，是 `--remote` 会话 URL surface |
| `REMOTE_SAFE_COMMANDS` = `BRIDGE_SAFE_COMMANDS` | 一个约束 remote client REPL，本地命令；一个约束 bridge inbound 命令 |
| `remoteConnectionStatus` = `replBridgeConnected` | 两者属于不同状态树 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `--remote`、`/session`、footer `remote` pill、`claude assistant [sessionId]` |
| 条件公开 | `--remote` 的 TUI gate、assistant 的 feature gate、viewerOnly 的用户可见后果 |
| 内部/实现层 | `remoteSessionConfig.viewerOnly`、消息转换细节、完整 WS/reconnect 逻辑 |

## 4. 七个高价值判断问题

- 这次是创建远端 session，还是附着已有 session？
- 当前 REPL 是 remote session client，还是 viewer client？
- 当前 surface 依赖的是 `remoteSessionUrl`，还是更宽的 remote-mode 状态？
- 现在看的状态属于 remote session 运行面，还是 bridge host 运行面？
- 这里约束的是 remote-safe commands，还是 bridge inbound commands？
- 我看的到底是 `--remote` 链，还是 `assistant [sessionId]` 链？
- 我是不是把 remote client、viewer 与 bridge host 又写成了一条远程主线？

## 5. 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/commands/session/session.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/commands.ts`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/components/Spinner.tsx`
