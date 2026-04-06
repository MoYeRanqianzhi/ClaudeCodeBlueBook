# Remote approval shell topology：remote session、direct connect、ssh session 与 bridge relay 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/75-useRemoteSession、useDirectConnect、useSSHSession、handleInteractivePermission 与 bridgeCallbacks：为什么 remote session、direct connect、ssh session 都会借本地审批壳，而 bridge 只是把本地 permission prompt 外发竞速.md`
- `05-控制面深挖/74-can_use_tool、ToolUseConfirm、createToolStub、recheckPermission 与 manager.respondToPermissionRequest：为什么 remote session 的远端工具审批会借用本地权限队列 UI，却不会直接接管本地 tool plane.md`
- `05-控制面深挖/60-can_use_tool、interrupt、result、disconnect 与 stderr shutdown：为什么 direct connect 的控制子集、回合结束与连接失败不是同一种收口.md`

边界先说清：

- 这页不是所有 permission prompt 的总索引。
- 这页不替代本地 `PermissionContext` 决策树专题。
- 这页只抓四种“看起来都像本地审批框”的拓扑差异。

## 1. 四条拓扑总表

| 路径 | ask 起点 | 本地复用层 | 答案回流点 | 本地 `recheckPermission()` 意义 |
| --- | --- | --- | --- | --- |
| remote session | 远端 `can_use_tool` | `ToolUseConfirmQueue` 壳 | `RemoteSessionManager.respondToPermissionRequest(...)` | 无，本地只是壳 |
| direct connect | 远端 `can_use_tool` | `ToolUseConfirmQueue` 壳 | `DirectConnectSessionManager.respondToPermissionRequest(...)` | 无，本地只是壳 |
| ssh session | 远端 `can_use_tool` | `ToolUseConfirmQueue` 壳 | `manager.respondToPermissionRequest(...)` | 无，本地只是壳 |
| bridge relay | 本地 `useCanUseTool(...)` ask | 本地真实 `ToolUseConfirm` | 本地 `PermissionContext` 闭环，远端 bridge 只参与 relay/race | 有，本地仍是主权方 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 本地弹出同一种审批框 = 同一种 permission topology | 只是共用 modal shell |
| bridge = 第四种 remote `can_use_tool` | bridge 是本地 ask 外发，不是远端 ask 导入 |
| remote session = direct connect = ssh session | 三者同属 imported remote ask family，但 return contract 厚度不同 |
| queue 在本地 = 主权就在本地 | imported remote ask 只是把壳放在本地 |
| `control_request` / `control_response` 名字相同 = 方向相同 | ask origin、治理点、回流点可能完全相反 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | remote session、direct connect、ssh session 都会借本地审批壳；bridge 先本地生成 ask，再外发 relay |
| 条件公开 | bridge relay 依赖 `bridgeCallbacks`；remote session 有 `control_cancel_request`；direct connect / ssh 的 transport / reconnect 合同各不相同 |
| 内部/实现层 | synthetic assistant、tool stub、`claim()` 竞速、pending handler map、bridge request ID |

## 4. 八个检查问题

- 现在这条 ask 是从远端导入，还是从本地生成？
- 本地复用的是审批壳，还是完整 permission context？
- 用户点击后，答案是回到远端 manager，还是先在本地闭环？
- 本地 `recheckPermission()` 有没有真实重判意义？
- 远端是否还能主动 cancel 当前 ask？
- 这里是 imported remote ask，还是 exported local ask？
- 我是不是把 bridge 误写成 remote ask family 了？
- 我是不是把同一 modal shell 写成同一 authority topology 了？

## 5. 源码锚点

- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/hooks/useSSHSession.ts`
- `claude-code-source-code/src/hooks/useCanUseTool.tsx`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/remote/remotePermissionBridge.ts`
