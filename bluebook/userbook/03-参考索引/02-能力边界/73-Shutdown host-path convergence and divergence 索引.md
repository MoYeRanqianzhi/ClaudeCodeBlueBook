# Shutdown host-path convergence and divergence 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/84-useInboxPoller、attachments、print、shutdown_approved、teammate_terminated 与 pending-processing：为什么 interactive、attachment bridge 与 headless print 不共享同一条 shutdown 收口宿主路径.md`
- `05-控制面深挖/83-shutdown_request、shutdown_approved、shutdown_rejected、teammate_terminated、pending 与 processed：为什么 shutdown 生命周期不会走同一条 mailbox routing 通道.md`

边界先说清：

- 这页不是 shutdown routing split 总论。
- 这页不替代 81-83 对 family、visible surfaces、routing split 的拆分。
- 这页只抓 interactive poller、attachment bridge 与 headless print 三条 shutdown 收口宿主路径的 convergence / divergence。

## 1. 三条宿主路径总表

| 宿主路径 | 主要对象 | 最优先目标 |
| --- | --- | --- |
| interactive poller | `useInboxPoller.ts` | cleanup + 本地 inbox/消息继续投递 |
| attachment bridge | `attachments.ts` | mid-turn mailbox/pending bridge |
| headless print | `print.ts` | headless enqueue/run 收口 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `attachments.ts` 只是轻量版 poller | 它是当前回合的 bridge，不是主宿主 |
| `print.ts` 就是没有 UI 的 poller | 它服务 headless run loop，并不复刻同一套本地 inbox 状态机 |
| 三条路径都处理 approved，所以都会注入 `teammate_terminated` | 这更接近 interactive host 的本地一致性影子 |
| `pending/processed` 是 shutdown cleanup 的普遍阶段 | 这主要属于 interactive host 的 local inbox 生命周期 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 三条宿主路径共享部分 shutdown cleanup contract，但不共享同一条 host path；interactive 更重、本地 inbox 更完整；attachment 更像 bridge；print 更像 headless run loop |
| 条件公开 | attachment 只在特定 viewing context 下消费 leader pending inbox；print 只在 headless run loop 下显式注入 shutdown prompt；某些 cleanup 依赖 pane backend / teamContext 仍存在 |
| 内部/实现层 | processed 清理时机、pending dedup key、`SHUTDOWN_TEAM_PROMPT` 注入细节、approved 透传后的具体显示厚度 |

## 4. 六个检查问题

- 当前讨论的是 interactive host、attachment bridge，还是 headless run loop？
- 这条路径自己拥有本地 inbox 状态机吗？
- 它的首要职责是 cleanup、mid-turn bridge，还是 prompt queue 推进？
- 这里是否会注入 `teammate_terminated` shadow？
- 这里是否需要 `pending/processed` 双阶段？
- 我是不是把 shared cleanup contract 写成 shared host path 了？

## 5. 源码锚点

- `claude-code-source-code/src/hooks/useInboxPoller.ts`
- `claude-code-source-code/src/utils/attachments.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/components/teams/TeamsDialog.tsx`
