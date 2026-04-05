# workflow engine、LocalWorkflowTask 与可见边界

这一章回答五个问题：

1. Claude Code 当前公开源码里，到底能看到多少 workflow engine。
2. `LocalWorkflowTask`、workflow command、workflow progress 之间怎样接成一条线。
3. 哪些地方已经是正式对象模型，哪些地方仍然只是 gate 后的边界痕迹。
4. workflow 的归档、恢复、worktree 和 SDK 事件面现在能保守地确认到什么程度。
5. 为什么这一层最适合用“可见边界”而不是“完整揭秘”的写法。

## 0. 代表性源码锚点

- `claude-code-source-code/src/commands.ts:86-88`
- `claude-code-source-code/src/commands.ts:341-341`
- `claude-code-source-code/src/commands.ts:446-464`
- `claude-code-source-code/src/types/command.ts:198-198`
- `claude-code-source-code/src/tasks/types.ts:8-27`
- `claude-code-source-code/src/Task.ts:6-84`
- `claude-code-source-code/src/components/tasks/BackgroundTasksDialog.tsx:18-18`
- `claude-code-source-code/src/components/tasks/BackgroundTasksDialog.tsx:109-113`
- `claude-code-source-code/src/utils/task/framework.ts:111-128`
- `claude-code-source-code/src/utils/task/sdkProgress.ts:1-34`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1714-1731`
- `claude-code-source-code/src/utils/sessionStorage.ts:232-258`
- `claude-code-source-code/src/utils/worktree.ts:1021-1052`
- `claude-code-source-code/src/utils/markdownConfigLoader.ts:28-36`

## 1. 先说结论

当前公开源码已经足以证明三件事：

1. workflow 不是文案概念，而是正式 task type。
2. workflow 有独立的 UI、事件、归档路径和清理语义。
3. workflow engine 的核心实现仍被 `WORKFLOW_SCRIPTS` gate 和缺失模块遮住，所以蓝皮书必须按“对象模型已可见、执行内核尚未完全展开”来写。

更准确地说，公开源码现在给我们的不是完整 workflow engine，而是：

- 一份清晰的宿主边界图
- 一套正式的状态对象
- 一些足以支撑保守推断的运行时挂点

## 2. workflow 从哪里进入系统

workflow 至少从四个入口进入 Claude Code：

1. 配置语言入口：
   - `markdownConfigLoader.ts` 已把 `workflows` 列为正式 Claude 配置目录。
2. 命令入口：
   - `commands.ts` 会按 `feature('WORKFLOW_SCRIPTS')` 条件挂载 `workflowsCmd`，并把 workflow commands 混入统一命令装配。
3. 命令元数据入口：
   - `types/command.ts` 用 `kind?: 'workflow'` 把 workflow-backed commands 明确标成一类对象。
4. 任务对象入口：
   - `Task.ts` 与 `tasks/types.ts` 把 `local_workflow` 列为正式 task type。

这意味着 workflow 不是独立子系统，而是：

- 共享 Claude 配置语言
- 共享命令装配面
- 共享任务运行时

## 3. 当前公开源码里能确认的 workflow 对象模型

### 3.1 它是后台任务，不是 prompt 展示技巧

`Task.ts` 把 `local_workflow` 放进正式 `TaskType`，并给它分配单独前缀 `w`。  
`tasks/types.ts` 又把 `LocalWorkflowTaskState` 放进：

- `TaskState`
- `BackgroundTaskState`

这意味着 workflow 至少和：

- local bash
- local agent
- remote agent
- in-process teammate

处于同一层级的后台任务对象模型。

### 3.2 它有独立 UI 和控制动作

`BackgroundTasksDialog.tsx` 明确为 workflow 预留了：

- `WorkflowDetailDialog`
- `killWorkflowTask`
- `skipWorkflowAgent`
- `retryWorkflowAgent`

这说明 workflow 不是“一次跑完就结束的黑箱脚本”，而是：

- 有可视 detail dialog
- 有可终止动作
- 有 agent 级 skip / retry 语义

### 3.3 它有独立事件面

`sdkProgress.ts` 和 `coreSchemas.ts` 说明 SDK 已把 workflow 作为事件对象对外暴露：

- `task_started` 里有 `task_type === 'local_workflow'`
- 同时允许附带 `workflow_name`
- `task_progress` 允许携带 `workflow_progress`

这意味着宿主并不只是知道“有个后台任务”，而是能知道：

- 这是 workflow
- 它叫什么
- 它是否有阶段性进展

## 4. workflow 的归档、恢复与 worktree 痕迹

### 4.1 归档路径已经暴露

`sessionStorage.ts` 明确写道：

- workflow runs 会写到 `subagents/workflows/<runId>/`

这句话非常关键，因为它说明 workflow 并没有被塞进主 transcript，而是：

- 有独立的 subagents/workflows 命名空间

这和普通 agent transcript 的隔离设计是一致的。

### 4.2 worktree 生命周期也留下了明显痕迹

`worktree.ts` 中存在：

- `wf_<runId>-<idx>` 模式
- 旧版 `wf-<idx>` 模式
- 针对 agent/workflow 泄露 worktree 的 stale cleanup 逻辑

这说明 workflow execution 至少在某些路径下会生成：

- throwaway worktree
- 独立 runId
- 可被扫尾回收的执行现场

所以 workflow 不是纯内存编排，而是可能涉及真实文件系统隔离。

## 5. 当前真正缺失的是什么

最重要的缺失不是“完全没有 workflow”，而是：

1. `src/tasks/LocalWorkflowTask/LocalWorkflowTask.js` 当前公开镜像未见。
2. `src/commands/workflows/index.js` 当前公开镜像未见。
3. `WorkflowDetailDialog.js` 当前公开镜像未见。

换句话说，缺的是：

- 具体执行器
- 具体命令入口实现
- 具体 workflow 细粒度 UI

但并不缺：

- task type
- state slot
- SDK event shape
- transcript/worktree 命名语义

所以这里最稳的写法不是“workflow engine 未知”，而是：

- workflow engine 的壳层与边界非常清晰，核心内核仍未在公开镜像中完全展开

## 6. 从第一性原理看，workflow 在解决什么问题

如果从第一性原理看，workflow 解决的不是“多一个自动化脚本入口”，而是：

1. 如何把可复用多步流程提升成正式 runtime object。
2. 如何让流程拥有自己的 task id、progress、transcript、worktree 和清理语义。
3. 如何把“一个复杂流程正在运行”这件事暴露给宿主和 UI，而不是只留在模型脑内。

所以 workflow 的本质更接近：

- 编排对象

而不是：

- prompt 模板

## 7. 苏格拉底式追问

### 7.1 为什么这里不能装作自己看到了完整 engine

因为没看到。

`LocalWorkflowTask` 和 `commands/workflows` 的核心实现当前公开镜像里并不在场。继续把缺失部分写成确定事实，只会把蓝皮书的可信边界打穿。

### 7.2 为什么又不能把它写成“几乎什么都不知道”

因为可见边界已经足够厚：

- 有 task type
- 有 UI
- 有 progress schema
- 有 transcript/worktree 路径
- 有 cleanup 语义

这已经足以说明 workflow 在 Claude Code 里是正式的一等对象。

### 7.3 最稳妥的结论是什么

最稳妥的结论是：

- 当前公开源码已暴露 workflow engine 的宿主接口、对象模型和运行时外壳；真正缺失的是执行内核与具体脚本装配层。

## 8. 对蓝皮书接下来的启发

后续如果继续写 workflow：

1. 先写“可见边界”和“对象模型”。
2. 再写“哪些地方是缺失模块导致的空洞”。
3. 绝不能把缺失的执行器细节脑补成已证实事实。
4. 但也不能因为缺少内核，就忽略已经清楚可见的 task / transcript / worktree / SDK 语义。

## 9. 一句话总结

当前公开源码里的 workflow，不是完整 engine 揭秘，而是一张已经很清楚的对象模型与宿主边界图：`local_workflow` 已经是一等 task，内核实现则仍在 gate 后面。
