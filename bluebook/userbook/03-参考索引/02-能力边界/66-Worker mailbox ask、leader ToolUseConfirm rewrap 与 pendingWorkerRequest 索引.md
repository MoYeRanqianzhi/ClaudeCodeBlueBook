# Worker mailbox ask、leader `ToolUseConfirm` rewrap 与 `pendingWorkerRequest` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/77-swarmWorkerHandler、useInboxPoller、permissionSync、useSwarmPermissionPoller 与 workerBadge：为什么 tmux worker 的 mailbox ask 会在 leader 侧重包成 ToolUseConfirm，却不等于 leader 自己的本地审批.md`
- `05-控制面深挖/76-toolUseConfirmQueue、promptQueue、sandbox、worker、elicitation 与 focusedInputDialog：为什么 REPL 的本地阻塞容器不共享同一治理闭环.md`
- `05-控制面深挖/74-can_use_tool、ToolUseConfirm、createToolStub、recheckPermission 与 manager.respondToPermissionRequest：为什么 remote session 的远端工具审批会借用本地权限队列 UI，却不会直接接管本地 tool plane.md`

边界先说清：

- 这页不是所有 swarm 权限同步的总索引。
- 这页不替代 worker sandbox 专题。
- 这页只抓 worker mailbox ask 如何在 leader 侧重包成 `ToolUseConfirm`。

## 1. 五类对象总表

| 对象 | 回答的问题 | 典型对象 |
| --- | --- | --- |
| `Ask Origin` | ask 最初在哪边生成 | `handleSwarmWorkerPermission(...)` |
| `Worker Waiting Surface` | worker 自己看到什么 | `pendingWorkerRequest`、`WorkerPendingPermission` |
| `Leader UI Rewrap` | leader 怎样把 ask 放进同款审批壳 | `useInboxPoller`、`ToolUseConfirmQueue`、`workerBadge` |
| `Mailbox Return Path` | 决策如何回到 worker | `sendPermissionResponseViaMailbox(...)` |
| `Worker Continuation` | 真正继续执行发生在哪边 | `useSwarmPermissionPoller` callback、`ctx.handleUserAllow(...)` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| leader 看到 `ToolUseConfirm` = ask 起点在 leader | ask 起点在 worker，leader 只是 rewrap shell |
| worker 自己也有同款审批卡片 | worker 只有 pending indicator |
| leader-side worker entry = leader 自己的本地 ask | 只是带 `workerBadge` 的 rewrapped mailbox ask |
| leader 批准后就在 leader 本地闭环 | continuation 和 permission updates 回到 worker |
| 这条线和 remote session ask 只是 transport 不同 | ask 起点和 permission state 所在侧都不同 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | worker ask 会先变成 `pendingWorkerRequest`；leader 会显示带 `workerBadge` 的同款审批壳；结果再回流 worker |
| 条件公开 | 仅在 swarms enabled + worker/leader 场景成立；classifier 可能提前截断；mailbox 失败会回退本地处理；leader 未识别 tool 时会跳过 |
| 内部/实现层 | mailbox pending/resolved 文件、lockfile、空 assistant message 载体、callback registry、dedupe/notification 细节 |

## 4. 七个检查问题

- ask 起点在 worker，还是在 leader？
- worker 自己拿到的是决策壳，还是 waiting indicator？
- leader 这边复用的是 UI 壳，还是完整 permission context？
- 点击允许后，结果是回到 worker 还是留在 leader？
- 这条 entry 有没有 `workerBadge` / no-op `recheckPermission()` 特征？
- leader 不认识 tool 时，是 stub 降级，还是直接跳过？
- 我是不是把 leader-visible shell 写成 leader-owned local ask 了？

## 5. 源码锚点

- `claude-code-source-code/src/hooks/toolPermission/handlers/swarmWorkerHandler.ts`
- `claude-code-source-code/src/hooks/useInboxPoller.ts`
- `claude-code-source-code/src/hooks/useSwarmPermissionPoller.ts`
- `claude-code-source-code/src/utils/swarm/permissionSync.ts`
- `claude-code-source-code/src/utils/swarm/leaderPermissionBridge.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
