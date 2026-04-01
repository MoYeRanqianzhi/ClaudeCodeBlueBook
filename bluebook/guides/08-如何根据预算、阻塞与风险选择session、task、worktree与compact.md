# 如何根据预算、阻塞与风险选择session、task、worktree与compact

这一章回答五个问题：

1. 为什么复杂任务里最常见的错误不是 prompt 不够长，而是对象选错了。
2. 什么时候应该继续当前 session，什么时候应该 compact，什么时候应该升级成 task，什么时候应该进入 worktree。
3. 为什么 token 问题、审批阻塞、协作复杂度和写入风险不能用同一个动作处理。
4. 怎样把 `context usage`、`session state`、`pending_action`、token budget 读成对象选择信号。
5. 怎样用苏格拉底式追问避免把“该升级对象”误判成“继续聊一轮”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/query/tokenBudget.ts:1-75`
- `claude-code-source-code/src/utils/analyzeContext.ts:1000-1098`
- `claude-code-source-code/src/utils/contextSuggestions.ts:31-233`
- `claude-code-source-code/src/utils/sessionState.ts:1-146`
- `claude-code-source-code/src/Task.ts:6-121`
- `claude-code-source-code/src/utils/task/framework.ts:31-117`
- `claude-code-source-code/src/tools/TaskCreateTool/prompt.ts:7-49`
- `claude-code-source-code/src/tools/EnterWorktreeTool/prompt.ts:1-36`
- `claude-code-source-code/src/tools/EnterWorktreeTool/EnterWorktreeTool.ts:68-116`
- `claude-code-source-code/src/utils/sessionStorage.ts:247-285`
- `claude-code-source-code/src/utils/sessionStorage.ts:804-822`
- `claude-code-source-code/src/utils/sessionStorage.ts:2884-2917`
- `claude-code-source-code/src/utils/worktree.ts:702-770`

## 1. 先说结论

更稳的选择方法不是：

- 先问这轮 prompt 还要不要再补一句

而是：

- 先问当前最紧的预算是哪一种
- 再问应该升级哪个对象

在 Claude Code 里，至少有四类经常被混淆的压力：

1. 上下文压力：
   - 该用 `compact`、收输出、延迟工具、修 memory
2. 协作压力：
   - 该用 `task`、task list、subagent、明确 owner / blocks
3. 隔离压力：
   - 该用 `worktree` 或至少独立修改现场
4. 连续性压力：
   - 该保留 / 恢复 `session`，而不是把一切塞进单轮

所以真正的问题通常不是：

- 继续不继续

而是：

- 当前瓶颈需要哪一种对象来吸收

## 2. 先判断当前压力属于哪一类

### 2.1 上下文压力

如果 `context usage` 提示：

- `toolResultTokens` 很大
- `attachmentTokens` 很大
- read / grep / bash 输出在膨胀
- context 接近 autocompact 阈值

这说明当前问题主要是：

- 工作集太吵

优先动作应是：

- `compact`
- 限制 read / grep / bash 结果
- 修剪 memory
- 保留 deferred tools，而不是把所有能力都预付进当前上下文

### 2.2 阻塞压力

如果 `session_state` 是：

- `requires_action`

或者 `pending_action` 已经给出：

- 等批准
- 等计划确认
- 等用户回答问题

这说明当前问题不是“上下文爆了”，而是：

- 系统被 block 住了

这时优先动作不是 `compact`，而是：

- 先解决 block

### 2.3 协作压力

如果任务已经：

- 3 步以上
- 有多个子目标
- 需要并行研究
- 需要进度面和依赖关系

那问题主要不是 token，而是：

- 生命周期管理

这时更适合：

- 建 task
- 维护 task list
- 明确 owner / blockedBy / status

### 2.4 隔离压力

如果当前工作会：

- 大规模改文件
- 污染主目录现场
- 需要独立 branch / cwd / sparse checkout
- 用户明确要求在 worktree 中进行

那问题主要不是协作，而是：

- 文件系统隔离

这时更适合：

- `worktree`

### 2.5 连续性压力

如果任务已经跨阶段、跨回合、跨天，且后续必须恢复上下文、标签、worktree state 或子代理 transcript，那真正需要保护的是：

- 可恢复入口

这时应该优先：

- 保持或恢复 `session`

而不是指望当前聊天历史永远足够。

## 3. 四种对象分别解决什么问题

### 3.1 `compact`：解决上下文压力，不解决协作和风险

`ContextSuggestions` 与 `analyzeContextUsage(...)` 已经说明，`compact` 解决的是：

- 近满载上下文
- 噪音结果过多
- memory 或 read 结果膨胀

它不解决：

- 多步骤生命周期
- 文件写入隔离
- 审批阻塞

所以当问题是“结果太吵”时，用 `compact` 很对；
当问题是“任务太大”或“改动太危险”时，只 `compact` 只是在原对象上继续硬撑。

### 3.2 `task`：解决生命周期与协作压力，不解决隔离

`TaskType`、`task_started`、`TaskCreateTool` 的 prompt 都在强调同一件事：

- 非 trivial、3 步以上、需要跟踪的工作，应当进入任务对象

`task` 真正带来的不是“多一个列表”，而是：

- subject / description
- status
- output file
- 进度事件
- 后续依赖和 owner 关系

所以当任务已经需要：

- 跟踪
- 分解
- 验证
- 并行研究

就不该继续假装它只是一次普通对话。

### 3.3 `worktree`：解决隔离压力，不是 branch 的别名

`EnterWorktreeTool` 的 prompt 很明确：

- 只有用户明确要求 worktree 时才使用

这代表 Claude Code 产品面把 worktree 当成：

- 强隔离对象

而不是默认分支切换。

源码里它会：

- 创建或恢复独立 worktree
- 切换当前 session cwd
- 清理 system prompt section cache
- 清理 memory file cache
- 把 worktree state 写回 session persistence

所以它解决的是：

- 独立现场
- 恢复时回到同一隔离空间

而不只是：

- git branch 名字不同

### 3.4 `session`：解决连续性与恢复压力，不是聊天历史容器

`sessionStorage.ts` 不只保存 transcript，还保存：

- subagent transcript path
- worktree-state
- title / tag / agent metadata

这说明 `session` 在 Claude Code 里真正承担的是：

- 恢复入口
- 持久化真相
- 多对象汇合点

所以长任务真正需要的不是“还记得前文”，而是：

- 还能恢复同一个工作对象宇宙

## 4. 读信号，再做对象升级

### 4.1 看到 `near capacity`，先问是不是仍在同一目标里

如果目标没变、只是消息层太吵：

- `compact`

如果目标已经变成第二阶段、第三阶段，或已经开始跨回合做验证、返工、收尾：

- 不要只 compact
- 考虑 task / session 切分

### 4.2 看到 `requires_action`，不要先做 budget 动作

如果现在是：

- 审批阻塞
- 计划确认
- 用户问题待答

先解 block。

因为此时最稀缺的不是 token，而是：

- 下一步许可

### 4.3 看到 `checkTokenBudget(...)` 已经逼近阈值或递减收益，问自己是不是该停这一轮

`checkTokenBudget(...)` 的判断不只是“还剩多少 token”，而是：

- 继续是否还有明显收益

如果已经连续几次增长很小，就不该机械地继续推进同一轮。

更稳的做法可能是：

- 停止当前 turn
- 把剩余工作下沉为 task
- 或把下一阶段放到新 session / 新 worktree

### 4.4 看到任务已经进入“多目标 + 多写集”，优先对象升级

`TaskCreateTool` 的 prompt 已经给了产品级暗示：

- 3 个以上 distinct steps
- non-trivial and complex tasks
- multiple tasks from the user

这些都意味着：

- 该上 task 了

### 4.5 看到高风险修改，先问隔离，不要先问摘要

如果你担心的是：

- 主目录被污染
- 改动难以回退
- 需要独立分支和现场

那正确动作是：

- worktree

而不是：

- 先 compact 一下再继续改

## 5. 一份最小决策表

如果主要问题是：

- 结果太吵、上下文太满

优先：

- `compact`

如果主要问题是：

- 工作分成多个可跟踪步骤

优先：

- `task`

如果主要问题是：

- 需要独立 git / cwd / 恢复现场，且用户明确要求 worktree

优先：

- `worktree`

如果主要问题是：

- 任务需要跨阶段恢复、保留对象关系、后续继续

优先：

- `session`

如果主要问题是：

- 当前在等批准、等回答、等确认

优先：

- 先处理 `pending_action`

## 6. 苏格拉底式检查清单

在继续下一轮前先问自己：

1. 我现在缺的是上下文空间，还是缺一个更合适的对象。
2. 当前卡住是 token 问题，还是 `requires_action` 问题。
3. 我是在做一个多步骤任务，还是只是在逃避创建 task。
4. 我需要的是隔离现场，还是只是想换个 branch 名字。
5. 这一阶段完成后，未来需要恢复的是一段聊天，还是一个包含 worktree / task / transcript 的工作对象。

只要这些问题没有先答清，很容易把：

- 应该升级对象的问题

误判成：

- 再聊一轮的问题

## 7. 一句话总结

Claude Code 更稳的使用方式，不是一直续聊，而是先看当前压力属于上下文、阻塞、协作还是隔离，再选择 `compact`、`task`、`session` 或 `worktree` 去承载它。
