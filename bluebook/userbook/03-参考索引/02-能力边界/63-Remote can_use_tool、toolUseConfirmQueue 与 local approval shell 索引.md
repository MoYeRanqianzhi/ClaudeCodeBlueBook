# Remote `can_use_tool`、`toolUseConfirmQueue` 与 local approval shell 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/74-can_use_tool、ToolUseConfirm、createToolStub、recheckPermission 与 manager.respondToPermissionRequest：为什么 remote session 的远端工具审批会借用本地权限队列 UI，却不会直接接管本地 tool plane.md`
- `05-控制面深挖/73-toolPermissionContext、initialMsg.mode、message.permissionMode、applyPermissionUpdate 与 computeTools：为什么 remote session 的本地 tool plane 主权不等于远端命令面主权.md`
- `05-控制面深挖/60-can_use_tool、interrupt、result、disconnect 与 stderr shutdown：为什么 direct connect 的控制子集、回合结束与连接失败不是同一种收口.md`

边界先说清：

- 这页不是完整权限系统索引。
- 这页不是 remote-control bridge `can_use_tool` 索引。
- 这页只抓 remote session 下远端审批如何借用本地 queue/UI 壳。

## 1. 四类对象总表

| 对象 | 回答的问题 | 典型对象 |
| --- | --- | --- |
| `Remote Ask Envelope` | 远端请求怎样进入本地 | `onPermissionRequest`、`ToolUseConfirm` |
| `UI Shell Reuse` | 本地复用了什么 | `toolUseConfirmQueue`、`PermissionRequest`、synthetic message |
| `Authority Boundary` | 最终决策在哪里闭环 | `manager.respondToPermissionRequest(...)` |
| `Governance Mismatch` | 为什么 queue 不等于本地权限引擎 | `recheckPermission()` no-op vs local queue ops |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 进入本地 queue = 本地权限主权接管 | 只是借用本地 queue/UI 壳 |
| 用户已在本地开始交互 = 本地 classifier / 治理前置链开始接管 | `onUserInteraction()` 对 remote queue item 是 no-op |
| 本地改了 `toolPermissionContext`，remote ask 会自动重判 | remote queue item 的 `recheckPermission()` 是 no-op |
| queue 里的工具对象一定是本地真实 tool | 可能只是 `createToolStub(...)` |
| 点允许/拒绝按钮就等于本地最终决策完成 | 最终只是把响应发回远端容器 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | remote ask 借用本地 queue/UI；最终响应发回远端 |
| 条件公开 | 本地能否找到真实 tool；用户是否交互；远端容器如何继续处理 |
| 内部/实现层 | synthetic message 结构、PermissionRequest 组件细节、本地决策树实现细节 |

## 4. 七个检查问题

- 我现在讨论的是 queue UI，还是权限主权？
- 这个 queue item 是远端 ask 还是本地 `useCanUseTool(...)` ask？
- 它有没有真正的 `recheckPermission()` 意义？
- 这个 tool 是真实对象还是 stub？
- 用户点击后，是本地闭环还是发回远端？
- 我是不是把 `queue reuse` 写成 `governance reuse` 了？
- 我是不是把本地 queue UI 当成本地工具面主权了？

## 5. 源码锚点

- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/hooks/useCanUseTool.tsx`
- `claude-code-source-code/src/hooks/toolPermission/PermissionContext.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
