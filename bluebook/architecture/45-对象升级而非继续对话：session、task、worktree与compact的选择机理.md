# 对象升级而非继续对话：session、task、worktree与compact的选择机理

这一章回答五个问题：

1. 为什么 Claude Code 的长任务不该继续被理解成“多轮聊天”，而该理解成对象升级。
2. `compact`、`task`、`session`、`worktree` 分别吸收哪一种系统压力。
3. 为什么这四种对象互补，而不是谁都可以替代谁。
4. `checkTokenBudget(...)`、`TaskCreateTool`、`EnterWorktreeTool` 与 `sessionStorage` 怎样共同构成升级路径。
5. 对 Agent runtime 构建者来说，这条对象升级链最值得迁移的是什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/query/tokenBudget.ts:1-75`
- `claude-code-source-code/src/utils/analyzeContext.ts:1000-1098`
- `claude-code-source-code/src/utils/contextSuggestions.ts:31-233`
- `claude-code-source-code/src/Task.ts:6-121`
- `claude-code-source-code/src/utils/task/framework.ts:31-117`
- `claude-code-source-code/src/tools/TaskCreateTool/prompt.ts:7-49`
- `claude-code-source-code/src/tools/EnterWorktreeTool/prompt.ts:1-36`
- `claude-code-source-code/src/tools/EnterWorktreeTool/EnterWorktreeTool.ts:68-116`
- `claude-code-source-code/src/utils/worktree.ts:702-770`
- `claude-code-source-code/src/utils/sessionStorage.ts:247-285`
- `claude-code-source-code/src/utils/sessionStorage.ts:804-822`
- `claude-code-source-code/src/utils/sessionStorage.ts:2884-2917`

## 1. 先说结论

Claude Code 对复杂任务的成熟处理方式，不是：

- 一直 `continue`

而是：

- 在不同瓶颈出现时升级对象

这里至少有四种常见对象：

1. `compact`
2. `task`
3. `worktree`
4. `session`

它们分别吸收四种不同压力：

- 上下文压力
- 生命周期与协作压力
- 文件系统隔离压力
- 持续恢复压力

所以真正的 runtime 问题往往不是：

- 再不要继续一轮

而是：

- 当前应该把问题升级到哪个对象层

## 2. `compact`：预算器动作，不是项目管理动作

`analyzeContextUsage(...)` 与 `ContextSuggestions` 说明 `compact` 的职责是：

- 回收上下文
- 控制噪音工作集
- 让 autocompact 或手动压缩在同一预算逻辑下工作

它真正解决的是：

- 消息层太吵
- read / bash / grep / fetch 结果过大
- memory 太胖
- 距离上下文阈值太近

它不解决：

- 多步骤任务如何跟踪
- 谁负责哪个子目标
- 哪个目录应该被隔离
- 哪个恢复入口应被保留

所以 `compact` 应被理解成：

- budget operation

而不是：

- long-task strategy

## 3. `task`：生命周期对象，不是更正式的备忘录

`Task.ts`、`task/framework.ts`、`TaskCreateTool` 的 prompt 共同说明：

- task 是正式对象

它至少带：

- `taskId`
- `taskType`
- `status`
- `description`
- `outputFile`
- `task_started` 事件

而 `TaskCreateTool` 又把适用条件写得很明白：

- 3 步以上
- complex multi-step
- non-trivial
- multiple tasks from user

这意味着 task 解决的不是“记一下待办”，而是：

- 给复杂工作一个可跟踪生命周期

所以当任务已经跨多个动作、多个阶段、多个验收点时，继续把它放在单轮聊天里，本质上是在拒绝使用源码已经提供的生命周期对象。

## 4. `worktree`：隔离对象，不是 branch 语法糖

`EnterWorktreeTool` 的 prompt 非常关键：

- 只有用户明确要求 worktree 时才使用

这表明 Claude Code 在产品层面对 worktree 很克制，但这种克制恰恰说明作者把它当成：

- 强隔离对象

而不是随便换个 branch 的便利操作。

源码里 worktree 创建后不仅切换 cwd，还会：

- 保存 worktree state
- 清空 system prompt section cache
- 清理 memory file caches
- 让后续 `--resume` 回到同一 worktree 现场

所以它解决的核心问题是：

- 把高风险写入放进独立现场

这远比“新建一个分支”更强，因为它同时隔离了：

- 工作目录
- 恢复入口
- 当前 session 现场

## 5. `session`：连续性对象，不是聊天容器

`sessionStorage.ts` 的设计说明 `session` 在 Claude Code 里远不止 transcript。

它还持续保存：

- agent transcript path
- worktree-state
- tag / title / metadata
- resume 所需的附加真相

这意味着 `session` 的真正职责是：

- continuity surface

也就是：

- 让未来还能回到同一个工作对象宇宙

如果任务已经明显跨阶段、跨天、跨多轮验证，而你仍把它只当当前消息历史的一部分，那实际是在放弃源码已经提供的恢复对象。

## 6. `checkTokenBudget(...)`：继续语义的停止信号，也是对象升级信号

`checkTokenBudget(...)` 很重要，因为它没有把“继续”理解成无限制默认动作。

它会判断：

- 是否逼近 completion threshold
- 是否已经出现 diminishing returns

这说明作者很清楚：

- turn 继续不是天经地义

一旦收益开始递减，系统更合理的做法往往不是再塞一句“继续干”，而是：

- 停当前 turn
- 把剩余工作交给 task / session / worktree 等更合适对象

所以 token budget 在这里不只是预算器，它还是：

- 对象升级触发器

## 7. 一条更抽象的升级链

把这些源码放在一起看，可以得到一条很清晰的运行时升级链：

1. 如果问题只是当前工作集太吵，用 `compact`
2. 如果问题已经变成多步骤和进度管理，用 `task`
3. 如果问题已经变成高风险修改现场，用 `worktree`
4. 如果问题已经变成长期连续性与恢复，用 `session`

这条链路说明 Claude Code 的正确使用方式不是：

- 对话永远是一等对象

而是：

- 对话只是入口，对象才是一等承载体

## 8. 为什么这些对象不能互相替代

如果用 `compact` 代替 task，会发生：

- 上下文干净了，但任务仍然没有生命周期

如果用 task 代替 worktree，会发生：

- 任务被跟踪了，但高风险写入仍在同一目录现场中进行

如果用 worktree 代替 session，会发生：

- 目录隔离了，但恢复真相和对象关系未必被保住

如果只保留 session，不做 task / compact / worktree，会发生：

- 有连续性，却没有足够好的协作、预算与隔离结构

所以这四者的关系不是“谁更高级”，而是：

- 谁吸收哪一种压力

## 9. 苏格拉底式追问

### 9.1 当前问题真的是需要再解释一次，还是需要换承载对象

如果是后者，继续聊天只会放大混乱。

### 9.2 当前任务为什么还没有 task，是因为真的 trivial，还是因为在逃避生命周期管理

如果是后者，迟早会付出更高协调成本。

### 9.3 当前改动为什么还没隔离，是因为风险真的很低，还是因为在拿主现场承受实验性修改

如果是后者，worktree 才是该升级的对象。

### 9.4 当前上下文为什么越来越脏，是因为系统太弱，还是因为该 compact 的问题一直被拿继续对话硬撑

很多时候答案是后者。

## 10. 一句话总结

Claude Code 的复杂任务处理之所以更稳，不是因为它更会续聊，而是因为它给了 `compact`、`task`、`worktree`、`session` 四种不同对象去吸收不同类型的系统压力。
