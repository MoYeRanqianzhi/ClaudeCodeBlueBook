# Shutdown mailbox routing split 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/83-shutdown_request、shutdown_approved、shutdown_rejected、teammate_terminated、pending 与 processed：为什么 shutdown 生命周期不会走同一条 mailbox routing 通道.md`
- `05-控制面深挖/82-shutdown_request、shutdown_approved、shutdown_rejected、teammate_terminated 与 stopping：为什么 shutdown 生命周期不会完整落在同一可见消息面.md`

边界先说清：

- 这页不是 shutdown visible surface 总论。
- 这页不替代 81 页对 termination lifecycle family 的定义。
- 这页只抓 shutdown family 在 structured file-mailbox、regular file-mailbox、local pending/processed inbox 之间的 routing split。

## 1. 四条通道总表

| 通道 | 代表对象 | 更接近什么 |
| --- | --- | --- |
| structured file-mailbox route | `shutdown_request`、`shutdown_approved` | handler-first lifecycle signal |
| regular file-mailbox route | `shutdown_rejected` | visible reply |
| local pending inbox route | `teammate_terminated`、busy 时延后投递的 regular message | leader 本地待投递队列 |
| local processed cleanup route | attachment 已中途投递过的 pending inbox message | mid-turn delivery cleanup |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 同属 shutdown family，所以都先走同一种 structured handler | request/approved 更偏 handler-first，rejected 更偏 regular reply |
| `teammate_terminated` 是第四种 shutdown mailbox response | 它是 leader 本地 injected cleanup shadow |
| approved 既然也会透传，就等于和 rejected 走同一路 | approved 是 cleanup-first, visible-later |
| `pending/processed` 是所有 shutdown 消息的必经阶段 | 这主要是 interactive leader-side local delivery path |
| attachment 看到的 mailbox 是 file mailbox 原样投影 | attachment 会合并 pending、dedup、过滤并改写 processed 状态 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | shutdown 生命周期不会走单一 mailbox routing 通道；request/approved 更偏 structured handler-first；rejected 更偏 regular visible reply；`teammate_terminated` 更偏本地 injected shadow |
| 条件公开 | `pending/processed` 主要属于 interactive leader-side local delivery；headless 会镜像 cleanup，但不必复用同样的 inbox 状态机；handler-first 对象之后仍可能再透传到 regular stream |
| 内部/实现层 | structured protocol 白名单内容、pending/processed 精确时机、attachment dedup/idle collapse、notification 文案生成 |

## 4. 六个检查问题

- 这条 shutdown 信号最初来自 file mailbox，还是本地 `AppState.inbox`？
- 它应该先交给 handler，还是先交给显示层？
- 这是 lifecycle negotiation，还是 cleanup completion shadow？
- 它现在处于 unread、pending，还是 processed？
- 它是不是在 interactive 和 headless 里复用了完全相同的 routing？
- 我是不是把 lifecycle family sameness 写成 routing channel sameness 了？

## 5. 源码锚点

- `claude-code-source-code/src/utils/teammateMailbox.ts`
- `claude-code-source-code/src/utils/attachments.ts`
- `claude-code-source-code/src/hooks/useInboxPoller.ts`
- `claude-code-source-code/src/components/teams/TeamsDialog.tsx`
- `claude-code-source-code/src/cli/print.ts`
