# Workflow 不是脚本而是编排对象

这一章回答四个问题：

1. 为什么 Claude Code 里的 workflow 不该被理解成 prompt 宏或脚本集合。
2. `local_workflow`、`workflow_progress`、独立 transcript / worktree 路径说明了什么。
3. 为什么 workflow 的真正价值在对象化，而不在步骤数量。
4. 这对 agent runtime 设计有什么第一性原理启发。

## 1. 先说结论

Claude Code 的 workflow 更像正式编排对象，而不是可复用脚本文本。

原因有三：

1. 它有独立 task type
2. 它有独立 progress / transcript / worktree 语义
3. 它被纳入统一 task framework 与宿主事件流

所以 workflow 的本体不是“怎么写一串步骤”，而是：

- 如何让长流程拥有自己的生命周期、状态面和恢复边界

## 2. 为什么它不是 prompt 宏

如果 workflow 只是 prompt 宏，我们通常只会看到：

- 一段命令模板
- 一组 skill 入口
- 若干固定提示词

但在 Claude Code 里，可见边界已经超过这个层级：

- `Task.ts` 里有 `local_workflow`
- `tasks/types.ts` 里有 `LocalWorkflowTaskState`
- `sdkProgress.ts` 里允许 `workflow_progress`
- `sessionStorage.ts` 里出现 `subagents/workflows/<runId>/`
- `worktree.ts` 里有 workflow run 对应的清理与 slug

这些都表明 workflow 已经不是文本拼装，而是运行时对象。

## 3. workflow 对象化解决了什么

它至少解决了三类长期问题：

1. 长流程可观察
2. 长流程可归档
3. 长流程可清理

所以 workflow 的关键不是自动化本身，而是：

- 自动化被纳入统一 runtime contract

## 4. 为什么对象化比“更多步骤”更重要

因为在 agent 系统里，真正昂贵的不是“步骤多”，而是：

- 步骤之间是否有清晰状态
- 失败后如何恢复
- 宿主怎样观察它
- 用户怎样知道它仍然可信

如果这些都没有，workflow 就只是更长的 prompt。

## 5. 苏格拉底式追问

### 问：如果 workflow 本体还没在公开镜像里完全展开，为什么还能谈它的哲学

答：因为对象化边界已经非常清楚。哲学层关心的不是具体 DSL 细节，而是作者把哪类长期问题提升成正式对象。

### 问：为什么这比“支持 workflow”更重要

答：因为很多系统也“支持 workflow”，但只是支持脚本化调用。Claude Code 更进一步做的是把 workflow 接进 task / event / transcript / worktree / cleanup 的统一语义。

## 6. 一句话总结

Claude Code 的 workflow 最值得迁移的，不是脚本形式，而是把长流程做成正式编排对象的设计选择。
