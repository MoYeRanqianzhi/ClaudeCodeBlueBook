# 多 Agent、任务、团队、计划模式与 Worktree

## Claude Code 已经把“放大行动范围”产品化了

很多人把子代理、任务、计划模式、worktree 当成分散功能看，但从源码看，它们是一套完整治理链：

- 计划模式控制“什么时候可以开始实施”。
- 子代理控制“谁来实施”。
- 任务系统控制“长期工作如何可见、可回收、可中断”。
- team/swarm 控制“多个执行体如何协作”。
- worktree 控制“并行执行时如何隔离代码面”。

## 子代理不是魔法，是正式工具

`src/tools/AgentTool/AgentTool.tsx` 直接把子代理定义成正式工具。它能声明：

- 任务描述。
- prompt。
- agent 类型。
- 模型。
- 背景运行。
- team 名称。
- permission mode。
- 隔离方式，如 `worktree` 或某些构建里的 `remote`。

这说明子代理从设计上就不是“偷偷开个线程”，而是可治理、可寻址、可报告进度的执行对象。

## 任务系统解决的是长时间可见性

`TaskCreate`、`TaskGet`、`TaskUpdate`、`TaskList`、`TaskStop`、`TaskOutput` 共同构成任务面。

它们解决的不是“列个 todo”，而是：

- 长任务如何在主线程之外继续。
- 用户如何稍后回来检查结果。
- 代理之间如何不踩同一块工作面。

## 团队系统解决的是代理间协作

`SendMessage`、`TeamCreate`、`TeamDelete` 加上 `coordinatorMode.ts`，说明 Claude Code 已经在源码层面考虑：

- 代理之间通信。
- 领导者与执行者角色分工。
- 协作时的权限与可见面控制。

这套设计的真实含义是：Claude Code 不再只优化“一个模型如何写代码”，而在优化“多个执行单元如何安全协作”。

## worktree 是多代理安全边界

`EnterWorktreeTool` 和 `AgentTool` 都会与 worktree 逻辑发生关系，说明 worktree 不只是用户手工 Git 技巧，而是系统官方隔离手段。

最典型用途：

- 同一大任务拆成多个分支面并行推进。
- 把高风险实现从主工作面剥离。
- 让批量代理在不互相踩文件的前提下并行工作。

## 计划模式放在这一章，而不是权限章的原因

因为计划模式除了是权限模式外，还是“多执行体协作前的设计闸门”。

当任务需要：

- 并行拆分。
- worktree 隔离。
- 多个代理分工。
- 远程或后台运行。

先计划再执行，收益远高于直接让模型开跑。

## 用户实践

### 先单代理

除非任务天然可并行，否则先在主线程把问题定义清楚。

### 再计划

当任务规模到达“多人协作也合理”的程度时，先进入计划模式。

### 再拆执行体

把明确边界的子任务交给子代理或团队，而不是把模糊问题同时丢给多个代理。

### 需要隔离就上 worktree

尤其是并行改同一仓库时。

## 源码锚点

- `src/tools/AgentTool/AgentTool.tsx`
- `src/tools/SendMessageTool/SendMessageTool.ts`
- `src/tools/TeamCreateTool/TeamCreateTool.ts`
- `src/tools/TeamDeleteTool/TeamDeleteTool.ts`
- `src/tools/TaskCreateTool/TaskCreateTool.ts`
- `src/tools/TaskListTool/TaskListTool.ts`
- `src/tools/TaskOutputTool/TaskOutputTool.tsx`
- `src/tools/TaskStopTool/TaskStopTool.ts`
- `src/tools/EnterPlanModeTool/EnterPlanModeTool.ts`
- `src/tools/EnterWorktreeTool/EnterWorktreeTool.ts`
- `src/coordinator/coordinatorMode.ts`
