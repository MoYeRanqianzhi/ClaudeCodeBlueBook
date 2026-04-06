# Local modal shell family、`toolUseConfirmQueue`、`promptQueue` 与 worker、sandbox、elicitation 容器索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/76-toolUseConfirmQueue、promptQueue、sandbox、worker、elicitation 与 focusedInputDialog：为什么 REPL 的本地阻塞容器不共享同一治理闭环.md`
- `05-控制面深挖/75-useRemoteSession、useDirectConnect、useSSHSession、handleInteractivePermission 与 bridgeCallbacks：为什么 remote session、direct connect、ssh session 都会借本地审批壳，而 bridge 只是把本地 permission prompt 外发竞速.md`
- `05-控制面深挖/74-can_use_tool、ToolUseConfirm、createToolStub、recheckPermission 与 manager.respondToPermissionRequest：为什么 remote session 的远端工具审批会借用本地权限队列 UI，却不会直接接管本地 tool plane.md`

边界先说清：

- 这页不是所有 modal 组件的 UI 索引。
- 这页不替代 `PermissionContext` 决策树专题。
- 这页只抓 REPL 本地阻塞式输入与审批容器家族的差异。

## 1. 六类对象总表

| 对象 | 回答的问题 | 典型对象 |
| --- | --- | --- |
| `Governance Queue` | 真正装着 allow/reject/recheck 协议的是什么 | `toolUseConfirmQueue` |
| `Prompt Queue` | 只做 prompt 协议问答的是什么 | `promptQueue` |
| `Host Approval Queue` | 按 host 决策网络访问的是什么 | `sandboxPermissionRequestQueue` |
| `Proxy Approval Queue` | 代表 worker / 远端别人决策的是什么 | `workerSandboxPermissions.queue` |
| `Waiting Indicator` | 只是显示“我在等别人批”的是什么 | `pendingWorkerRequest`、`pendingSandboxRequest` |
| `Server-driven Interactive Queue` | 带 waiting/completed 两阶段协议的是什么 | `elicitation.queue` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 会让 REPL waiting 的都属于同一审批队列 | 只是共享宿主 waiting family |
| `PromptDialog` = `PermissionRequest` | 只是共享 `PermissionDialog` 壳 |
| worker pending = worker 本地可决策 | 只是等待态指示 |
| sandbox queue = 另一种 `ToolUseConfirmQueue` | 一个按 host 决策，一个按 tool protocol 决策 |
| elicitation = MCP 版 hook prompt | 它是 server-driven interactive queue |
| 同族容器都在同一 modal slot 渲染 | `tool-permission` 走 overlay，其余很多走 bottom/modal |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | REPL 维护统一的阻塞式容器家族；这些容器会共同影响 waiting/focus；它们不共享同一主权闭环 |
| 条件公开 | `requestPrompt(...)` 只在交互式 REPL 可用；bridge 可能参与 sandbox ask 竞速；worker/elicitation 容器取决于对应运行场景 |
| 内部/实现层 | `focusedInputDialog` 的优先级细节、overlay/bottom 槽位分配、sibling cleanup、spinner/survey 抑制协同 |

## 4. 八个检查问题

- 这个容器装的是决策协议，还是只装 promise / waiting state？
- 它会不会改写 `toolPermissionContext`？
- 它有没有 `recheckPermission()` 的真实意义？
- 它是当前线程自己的 ask，还是替 worker / 远端别人处理的 ask？
- 它是 host-based、tool-based，还是 server-driven interactive protocol？
- 它走 overlay，还是走 bottom/modal？
- 我是不是把 shared modal shell 写成 shared governance loop 了？
- 我是不是把 pending indicator 写成 decision container 了？

## 5. 源码锚点

- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/components/permissions/PermissionRequest.tsx`
- `claude-code-source-code/src/components/hooks/PromptDialog.tsx`
- `claude-code-source-code/src/Tool.ts`
- `claude-code-source-code/src/types/hooks.ts`
- `claude-code-source-code/src/hooks/toolPermission/handlers/swarmWorkerHandler.ts`
- `claude-code-source-code/src/hooks/useInboxPoller.ts`
- `claude-code-source-code/src/services/mcp/client.ts`
- `claude-code-source-code/src/services/mcp/elicitationHandler.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
