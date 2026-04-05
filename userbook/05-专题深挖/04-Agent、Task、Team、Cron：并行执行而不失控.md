# Agent、Task、Team、Cron：并行执行而不失控

## 第一性原理

一旦 Claude Code 不再只是单轮助手，而开始承担长任务和并行任务，系统必须回答两个问题：

1. 如何把工作拆给多个执行体。
2. 如何不让这些执行体彼此干扰、失去可见性或失控。

源码给出的答案是四件套：

- `Agent`
- `Task`
- `Team`
- `Cron`

## Agent：受治理的子执行体

`AgentTool` 暴露了完整的子代理定义面：

- prompt
- description
- agent type
- model
- background
- team name
- permission mode
- isolation，如 worktree
- cwd

关键点不在“能开子代理”，而在“子代理是正式工具对象，因此也纳入权限、工具池、通知、任务输出和 UI 体系”。

## Task：让长执行体变得可见

Task 系统不是待办文本，而是持久化对象：

- 有 ID、高水位 ID、锁文件、目录隔离。
- 在团队模式下，共享 task list ID。
- 多进程并发下通过 lockfile 保持顺序一致。

这说明它解决的是：

- 多执行体并发写任务时如何不冲突。
- 用户如何在 UI 中看到同一任务宇宙。
- 后台执行如何留下输出面。

## Team：把多个执行体组织成协作结构

团队相关工具与 `coordinatorMode.ts` 说明，Claude Code 已经把多代理协作提升到正式模型：

- 可以创建 team。
- 可以给 teammate 发消息。
- 可以把计划审批变成 leader/teammate 协议。

这不是“模型自己幻想出来的协作”，而是运行时结构。

## Cron：把持续性工作制度化

Cron 工具说明一个重要方向：Claude Code 不只等待用户输入，还允许在时间轴上安排未来工作。

其实现里可以看到：

- 标准 cron 表达式校验。
- one-shot 与 recurring 区分。
- durable 与 session-only 区分。
- teammate durable cron 被明确拒绝，避免重启后变成孤儿任务。
- 数量上限与到期策略明确存在。

这意味着 Claude Code 正在走向“可被调度的工作系统”，而不只是即时问答器。

## 这四件套如何组合

### 复杂任务拆分

先用计划模式划边界，再用 Agent 拆执行。

### 长任务后台运行

Agent 背景运行后，通过 Task 与 TaskOutput 维持可见性。

### 多代理协作

先建 Team，再通过消息与任务对象共享工作面。

### 时间驱动工作

用 Cron 把未来触发做成正式对象，而不是寄希望于用户记住。

## 用户注意点

### 不要把并行当成默认答案

如果边界没拆清，多代理只会放大混乱。

### 后台运行不等于不管

Task 与 TaskOutput 存在的意义就是让你稍后回来审计结果。

### durable cron 不是免费自动化

它意味着工作会跨会话存活，应该只在用户明确要求时使用。

## 稳定面与灰度面

### 相对稳定

- AgentTool
- 任务管理与后台输出
- `/tasks` 对话框

### 条件或灰度

- team/swarm 能力
- cron / agent triggers
- 某些 remote trigger、push notification、PR subscription 能力
- auto-background 和 KAIROS 系列自治路径

## 苏格拉底反诘

### 问：为什么不直接让主代理顺序做完

答：因为某些任务天然存在等待、并行或长耗时过程，顺序主线程会让整个交互冻结。

### 问：为什么还需要 Task，不直接看 agent 输出

答：没有 Task，对并行执行体就没有稳定可见面，也无法统一轮询、停止和恢复。

### 问：为什么 Cron 要区分 durable

答：因为跨会话存活不是默认安全语义，尤其在 teammate 或临时上下文里会造成孤儿任务。

## 源码锚点

- `src/tools/AgentTool/AgentTool.tsx`
- `src/tools/TaskCreateTool/TaskCreateTool.ts`
- `src/tools/TaskOutputTool/TaskOutputTool.tsx`
- `src/tools/TaskStopTool/TaskStopTool.ts`
- `src/utils/tasks.ts`
- `src/tools/TeamCreateTool/TeamCreateTool.ts`
- `src/tools/SendMessageTool/SendMessageTool.ts`
- `src/tools/ScheduleCronTool/CronCreateTool.ts`
- `src/coordinator/coordinatorMode.ts`
