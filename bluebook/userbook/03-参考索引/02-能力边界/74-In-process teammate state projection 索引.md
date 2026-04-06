# In-process teammate state projection 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/85-status、shutdownRequested、awaitingPlanApproval、isIdle、recentActivities 与 [stopping]：为什么 in-process teammate 的状态投影不是同一层状态.md`
- `05-控制面深挖/84-useInboxPoller、attachments、print、shutdown_approved、teammate_terminated 与 pending-processing：为什么 interactive、attachment bridge 与 headless print 不共享同一条 shutdown 收口宿主路径.md`

边界先说清：

- 这页不是 shutdown mailbox family 总论。
- 这页不替代 81-84 对 lifecycle、visible surface、routing、host path 的拆分。
- 这页只抓 in-process teammate 的 `status + flags` 为什么会被不同消费者压成不同厚度的状态面。

## 1. 两层状态总表

| 层 | 代表对象 | 更接近什么 |
| --- | --- | --- |
| lifecycle 层 | `status` | running / completed / failed / killed |
| projection 层 | `shutdownRequested`、`awaitingPlanApproval`、`isIdle`、`recentActivities` | 当前运行态投影 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `status === running` 就足够解释 UI | 还要叠加 shutdown / approval / idle / activity flags |
| `idle` 等于已完成 | `isIdle` 可以和 `status === running` 同时成立 |
| `[stopping]` 等于 terminal | 它是 `shutdownRequested` 的投影，不是 finished verdict |
| 所有消费者都在看同一层状态 | footer/detail、spinner、pill strip、waiter 读的层不同 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | in-process teammate 不是单一状态枚举；`shutdownRequested` / `awaitingPlanApproval` / `isIdle` 会稳定重写用户看到的运行态；`idle/stopping/awaiting approval` 属于 running task 的内部投影 |
| 条件公开 | headless wait/drain 主要依赖 `status === running && !isIdle`；spinner/detail 还会叠加 recent activity、highlight/select 等展示条件；某些 generic helper 的优先级不必等于具体组件优先级 |
| 内部/实现层 | 各消费者的具体优先级、`onIdleCallbacks` 时机、recent-activity summary 算法、spinner verb 与 preview 细节 |

## 4. 六个检查问题

- 我现在讨论的是 lifecycle verdict，还是 activity projection？
- 这个消费者主要看 `status`，还是主要看某个 flag？
- 这里的 `idle` 是 finished，还是 running-but-idle？
- 这里的 `stopping` 是 terminal，还是 shutdownRequested 投影？
- 这个判断是为了排序/等待，还是为了给人读？
- 我是不是把 layered state 写成 single enum 了？

## 5. 源码锚点

- `claude-code-source-code/src/tasks/InProcessTeammateTask/types.ts`
- `claude-code-source-code/src/utils/swarm/spawnInProcess.ts`
- `claude-code-source-code/src/tasks/InProcessTeammateTask/InProcessTeammateTask.tsx`
- `claude-code-source-code/src/tools/ExitPlanModeTool/ExitPlanModeV2Tool.ts`
- `claude-code-source-code/src/utils/inProcessTeammateHelpers.ts`
- `claude-code-source-code/src/utils/swarm/inProcessRunner.ts`
- `claude-code-source-code/src/utils/teammate.ts`
- `claude-code-source-code/src/components/tasks/taskStatusUtils.tsx`
- `claude-code-source-code/src/components/Spinner/TeammateSpinnerLine.tsx`
