# Remote 权限响应、控制请求与命令白名单索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/29-Bridge Permission Callbacks、Control Request 与 Bridge-safe Commands：为什么远端的权限提示、会话控制与命令白名单不是同一种控制合同.md`
- `05-控制面深挖/28-remote 会话、session 命令、assistant viewer 与 remote-safe commands：为什么远端会话 client、viewer 与 bridge host 不是同一种远程工作流.md`
- `05-控制面深挖/27-remote-control 命令、--remote-control、claude remote-control 与 Remote Callout：为什么 remote-control 的会内开桥、启动带桥与 standalone host 不是同一种入口.md`

## 1. 四类控制对象总表

| 对象 | 回答的问题 | 典型机制 |
| --- | --- | --- |
| `Permission Response` | 某一次工具调用能不能继续 | `can_use_tool`、bridge/channel/local UI race |
| `Session Control Request` | 整条 session 的运行参数要不要改 | `set_permission_mode`、`set_model`、`set_max_thinking_tokens` |
| `Bridge Inbound Command Contract` | bridge 从 mobile/web 打进来的命令哪些能跑 | `BRIDGE_SAFE_COMMANDS` |
| `Remote Client Command Contract` | 当前 REPL 在 remote session 模式下还保留哪些本地命令 | `REMOTE_SAFE_COMMANDS` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `can_use_tool` = 远端拥有完整控制权 | 它只回答一次工具调用的权限问题 |
| `set_permission_mode` = 点一次权限提示 | 一个改 session mode，一个答单次 prompt |
| `BRIDGE_SAFE_COMMANDS` = `REMOTE_SAFE_COMMANDS` | 一个约束 bridge inbound 命令，一个约束 remote client 本地命令 |
| viewerOnly = 弱化版 bridge controller | viewerOnly 是 remote session attach role，不是 bridge 权限 transport |
| “远端能点权限” = 只有 mobile/web bridge 这一条路 | 还可能有 channel callbacks 与本地 UI / hook / classifier 竞态 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 远端可以参与权限提示、session control request 的存在、两张命令白名单的对象差异 |
| 条件公开 | channel callbacks、permission mode gate / policy、viewerOnly 的受限控制后果 |
| 内部/实现层 | control message 具体格式、auth recovery / WS timeout 细节、所有竞态实现细枝末节 |

## 4. 七个高价值判断问题

- 现在是在回答一次 `can_use_tool`，还是在改整条 session 参数？
- 这个决策来自本地 UI、bridge、channel，还是别的 racer？
- 这里约束的是 bridge inbound 命令，还是 remote client 本地命令？
- 当前远端侧是 bridge controller，还是 viewerOnly client？
- 我看到的是 permission response，还是 session control request？
- 我是不是把 `BRIDGE_SAFE_COMMANDS` 与 `REMOTE_SAFE_COMMANDS` 混成了一张表？
- 我是不是又把权限提示、会话控制与命令白名单压成了一种“远端控制”？

## 5. 源码锚点

- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/hooks/useCanUseTool.tsx`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts`
- `claude-code-source-code/src/hooks/toolPermission/PermissionContext.ts`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/commands.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/services/mcp/channelPermissions.ts`
