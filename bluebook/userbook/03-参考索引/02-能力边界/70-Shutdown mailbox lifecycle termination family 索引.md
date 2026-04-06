# Shutdown mailbox lifecycle termination family 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/81-shutdown_request、shutdown_approved、shutdown_rejected、terminate 与 kill：为什么 swarms 的 shutdown mailbox 消息属于 lifecycle termination family.md`
- `05-控制面深挖/80-teammateMailbox、permission_request、sandbox_permission_request 与 plan_approval_request：为什么 swarms 的结构化邮箱消息不是同一种协议族.md`

边界先说清：

- 这页不是所有 teammate mailbox 消息的总索引。
- 这页不替代 approval-adjacent mailbox protocol family。
- 这页只抓 `shutdown_request`、`shutdown_approved`、`shutdown_rejected` 这组 termination lifecycle 消息。

## 1. 终止生命周期总表

| 阶段 | 消息 | primary consumer | 主要后果 |
| --- | --- | --- | --- |
| 请求终止 | `shutdown_request` | teammate poller / model decision loop | 请求 teammate 结束当前生命周期 |
| 同意终止 | `shutdown_approved` | leader cleanup path / backend | 退出、kill pane、移除 teammate |
| 拒绝终止 | `shutdown_rejected` | leader 可见消息层 | 保持存活，继续工作 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `shutdown_request` 就是另一种 permission ask | 它请求的是 teammate 生命周期终止，不是某次 continuation |
| `shutdown_approved` 只是同意文本 | 它会触发 cleanup 和 topology mutation |
| `shutdown_rejected` 和 approved 会被同样消费 | approved 更偏 side effect，rejected 更偏可见回复 |
| `terminate()` 等于 `kill()` | 前者先发 graceful shutdown request，后者直接强制结束 |
| 同走 mailbox = 同属 approval protocol | transport 相同，不等于 lifecycle family 相同 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | shutdown family 属于 lifecycle termination family；`terminate()` 与 `kill()` 不是同一路径；`shutdown_approved` 会触发真实 cleanup |
| 条件公开 | pane teammate 才稳定有 `paneId/backendType -> killPane(...)`；in-process teammate 主要走 abort/graceful shutdown；approved 是否显示取决于渲染面 |
| 内部/实现层 | `requestId` 生成、schema helper、unread 分类、mark-read 顺序、fallback abort/graceful shutdown 细节 |

## 4. 六个检查问题

- request payload 在描述 tool / host / plan，还是 teammate 存活与退出？
- 这条 response 回的是 continuation 数据，还是终止判决？
- primary consumer 是 queue/callback，还是 cleanup/topology mutation？
- 这里说的是 graceful terminate，还是 force kill？
- 这条消息在当前显示面是对话内容，还是控制后果？
- 我是不是把 same mailbox transport 写成 same approval family 了？

## 5. 源码锚点

- `claude-code-source-code/src/utils/teammateMailbox.ts`
- `claude-code-source-code/src/hooks/useInboxPoller.ts`
- `claude-code-source-code/src/utils/swarm/inProcessRunner.ts`
- `claude-code-source-code/src/utils/swarm/backends/PaneBackendExecutor.ts`
- `claude-code-source-code/src/utils/swarm/backends/InProcessBackend.ts`
- `claude-code-source-code/src/tools/SendMessageTool/SendMessageTool.ts`
- `claude-code-source-code/src/components/messages/ShutdownMessage.tsx`
- `claude-code-source-code/src/cli/print.ts`
