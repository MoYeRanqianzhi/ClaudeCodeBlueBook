# Mailbox `permission_request`、`sandbox_permission_request` 与 `plan_approval_request` protocol family 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/80-teammateMailbox、permission_request、sandbox_permission_request 与 plan_approval_request：为什么 swarms 的结构化邮箱消息不是同一种协议族.md`
- `05-控制面深挖/77-swarmWorkerHandler、useInboxPoller、permissionSync、useSwarmPermissionPoller 与 workerBadge：为什么 tmux worker 的 mailbox ask 会在 leader 侧重包成 ToolUseConfirm，却不等于 leader 自己的本地审批.md`
- `05-控制面深挖/78-sendSandboxPermissionRequestViaMailbox、workerSandboxPermissions、pendingSandboxRequest 与 sandbox callback：为什么 worker sandbox ask 不等于 leader 本地 network prompt.md`

边界先说清：

- 这页不是所有 teammate mailbox 消息的总索引。
- 这页不替代 `shutdown_request` / lifecycle 消息族专题。
- 这页只抓 approval-adjacent 的三类结构化 mailbox 协议。

## 1. 三类协议总表

| 协议族 | request 描述对象 | response 语义 | primary consumer | leader 默认行为 |
| --- | --- | --- | --- | --- |
| tool permission | tool use continuation | success/error + `updated_input` / `permission_updates` | queue + callback | 等用户决策 |
| sandbox host approval | host access attempt | `allow: boolean` | host queue + callback | 等用户决策 |
| plan approval | plan artifact / workflow transition | `approved` + `permissionMode` | state transition / task state | 默认 auto-approve |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `permission_request` 和 `sandbox_permission_request` 只是字段多少不同 | 一个镜像 tool control，一个是 host approval 最小协议 |
| `plan_approval_request` 也是 permission ask | 它是 workflow transition family |
| 三族消息都需要 leader 弹交互框 | plan approval 默认 auto-approve |
| 它们都会回到 callback registry | plan approval 更主要回到状态迁移 |
| 同走 mailbox = 同一协议族 | transport 一样不等于 protocol family 一样 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 三族消息共享 mailbox transport，但 payload、response、consumer、leader 行为都不同 |
| 条件公开 | 依赖 swarm / teammate / plan-mode-required 等条件；plan approval 仅接受 `team-lead` 响应；某些族会本地 fallback |
| 内部/实现层 | JSON 字段命名、task state helper、unread 分类/mark-as-read、regular pass-through、shutdown 相邻消息族 |

## 4. 七个检查问题

- request payload 在描述 tool、host，还是 plan artifact？
- response 回的是 continuation 数据，还是 workflow 状态？
- primary consumer 是 queue/callback，还是状态迁移？
- leader 收到后是排队等用户，还是直接 auto-approve？
- 这条线是否镜像 SDK control family？
- 这里讨论的是 approval-adjacent family，还是 lifecycle family？
- 我是不是把 same mailbox transport 写成 same protocol family 了？

## 5. 源码锚点

- `claude-code-source-code/src/utils/teammateMailbox.ts`
- `claude-code-source-code/src/hooks/useInboxPoller.ts`
- `claude-code-source-code/src/tools/ExitPlanModeTool/ExitPlanModeV2Tool.ts`
- `claude-code-source-code/src/utils/swarm/permissionSync.ts`
- `claude-code-source-code/src/hooks/useSwarmPermissionPoller.ts`
