# 多Agent任务对象、Mailbox与后台协作运行时

这一章回答五个问题：

1. Claude Code 的多 Agent runtime 到底由哪些正式对象组成。
2. coordinator、worker、team teammate、background task 之间是什么关系。
3. 为什么 task、mailbox、team context 比“起几个 agent”更关键。
4. 它如何把并行协作做成可恢复、可通知、可治理的运行时。
5. 这套结构的优势与代价分别是什么。

## 1. 先说结论

Claude Code 的多 Agent runtime 至少由五个正式对象组成：

1. coordinator 合同：
   - 定义谁负责综合理解、谁负责下发自包含 prompt。
2. task 对象：
   - 每个后台工作单元都有 `taskId`、`taskType`、`status`、`output file`、事件与通知。
3. task list：
   - 团队共享的 owner / blocks / blockedBy / status 真值表。
4. mailbox / team context：
   - 队友之间通过名字寻址、消息投递和任务清单协作，而不是共享上下文。
5. inherited runtime：
   - 子 worker 继承 permission mode、model、settings、plugin dir 等执行环境。

代表性证据：

- `claude-code-source-code/src/coordinator/coordinatorMode.ts:111-280`
- `claude-code-source-code/src/tools/shared/spawnMultiAgent.ts:200-259`
- `claude-code-source-code/src/tools/shared/spawnMultiAgent.ts:305-337`
- `claude-code-source-code/src/tools/TeamCreateTool/prompt.ts:24-24`
- `claude-code-source-code/src/utils/tasks.ts:76-76`
- `claude-code-source-code/src/utils/tasks.ts:199-199`
- `claude-code-source-code/src/utils/tasks.ts:584-660`
- `claude-code-source-code/src/utils/task/framework.ts:31-117`
- `claude-code-source-code/src/utils/task/framework.ts:158-289`
- `claude-code-source-code/src/utils/attachments.ts:3521-3797`
- `claude-code-source-code/src/utils/messages.ts:3453-3495`

## 2. coordinator 不是 manager 口头禅，而是系统法律

`coordinatorMode.ts` 把多 Agent 规则写得非常硬：

1. worker 看不到你的对话。
2. 收到研究结果后，coordinator 必须先综合，再决定后续 prompt。
3. 不要写“based on your findings”。
4. 读任务可并行，写任务要按写集收束。
5. verification 不能只是 rubber stamp。

证据：

- `claude-code-source-code/src/coordinator/coordinatorMode.ts:120-164`
- `claude-code-source-code/src/coordinator/coordinatorMode.ts:198-237`
- `claude-code-source-code/src/coordinator/coordinatorMode.ts:251-280`

这说明 Claude Code 的多 Agent 设计不是：

- 给模型一个“可以起 agent”按钮

而是：

- 先把协作中的认知职责写成规则

## 3. worker 不是裸进程，而是继承过的运行时分身

`spawnMultiAgent.ts` 里最关键的不是 tmux，而是 `buildInheritedCliFlags()`。

被显式传播的东西包括：

- permission mode
- bypass/auto/acceptEdits 等权限状态
- model override
- settings path
- inline plugin dirs
- chrome flag

证据：

- `claude-code-source-code/src/tools/shared/spawnMultiAgent.ts:200-259`

这意味着 worker 并不是：

- 从零启动的另一个 CLI

而更像：

- 带继承执行环境的 runtime 分身

这解释了为什么 Claude Code 的多 Agent 不是“prompt 技巧”，而是 runtime 复制策略。

## 4. task 对象才是后台协作的真正核心

`task/framework.ts` 把后台工作做成正式任务对象：

- `taskId`
- `taskType`
- `status`
- `description`
- `toolUseId`
- `output file`

并且在注册时就发出 `task_started` SDK event。

证据：

- `claude-code-source-code/src/utils/task/framework.ts:31-39`
- `claude-code-source-code/src/utils/task/framework.ts:77-117`

终态任务还会通过 `<task-notification>` 进入消息队列，带上：

- task id
- task type
- output file path
- status
- summary

证据：

- `claude-code-source-code/src/utils/task/framework.ts:271-289`

这意味着 Claude Code 的后台运行时不是“某个 agent 结束后在 UI 上闪一下”，而是：

- 任务先成为一等对象
- 再被渲染、通知、恢复和消费

## 5. TaskList 说明协作本质上先是调度系统

`TeamCreateTool` 的 prompt 直接把“team”写成：

- `Team = TaskList`

而 `tasks.ts` 中的任务对象又显式带有：

- `owner`
- `blocks`
- `blockedBy`
- `status`

证据：

- `claude-code-source-code/src/tools/TeamCreateTool/prompt.ts:24-24`
- `claude-code-source-code/src/utils/tasks.ts:76-76`
- `claude-code-source-code/src/utils/tasks.ts:199-199`
- `claude-code-source-code/src/utils/tasks.ts:584-660`

这意味着团队协作的共享现实首先不是聊天记录，而是：

- 谁负责
- 谁阻塞谁
- 哪个任务已完成

多 Agent 如果没有这张事实表，就只能退化成：

- 多个 worker 分头说话

## 6. mailbox 和 team context 说明协作本质上还是消息系统

`attachments.ts` 明确把多 Agent 协作看成消息投递问题。

它会为 swarm teammate 注入：

- `teammate_mailbox`
- `team_context`

证据：

- `claude-code-source-code/src/utils/attachments.ts:898-913`
- `claude-code-source-code/src/utils/attachments.ts:3521-3797`

而 `messages.ts` 又把 `team_context` 翻译成清晰的系统提醒：

- 你是谁
- 团队配置文件在哪里
- task list 在哪里
- 应该向谁汇报
- 队友应该按名字寻址，而不是 UUID

证据：

- `claude-code-source-code/src/utils/messages.ts:3467-3495`

因此，Claude Code 的团队协作并不是共享 context window，而是：

- 共享任务和消息协议

## 7. 为什么后台协作一定要和通知/恢复绑在一起

一旦把 worker 放到后台，系统必须回答四个问题：

1. 谁启动了它。
2. 它现在在什么状态。
3. 它输出在哪里。
4. 它结束时如何通知主线程。

Claude Code 的答案是：

- task framework 统一登记
- output file 统一落点
- notification 统一消息格式
- UI / SDK / REPL 再分别消费这个任务真相

这正是它能把 shell、agent、remote session 一起放进 background runtime 的原因。

## 8. 这套设计的优势

### 8.1 优势

1. 并行任务可见：
   - 不需要靠主线程“记住”谁还在跑。
2. 恢复与通知统一：
   - 任务结束后既可通知，也可从 output file 继续消费。
3. 协作协议显式：
   - 队友如何汇报、如何分工、如何收消息都不是隐式习惯。

### 8.2 代价

1. 心智模型更复杂：
   - 你得同时理解 coordinator、task、mailbox、team context。
2. 热点协调文件更重：
   - 协作真相分散在 prompt、attachments、task framework、UI 消费层。
3. 错误用法代价高：
   - 如果 prompt 不自包含，系统再强也会把错误放大。

## 9. 对使用者和设计者的启发

### 9.1 对使用者

正确问法不是：

- 我能同时起几个 agent

而是：

- 我现在应该拆成几个独立 task
- 哪些 task 可以共享环境但不共享写集
- 哪些结论必须先由 coordinator 综合

### 9.2 对设计者

如果想做可靠的多 Agent：

- 先设计 task object model
- 再设计 mailbox / notification
- 最后才是 prompt 话术

因为真正让协作成立的，是：

- 任务真相
- 消息真相
- 恢复真相

## 10. 一句话总结

Claude Code 的多 Agent 强，不在于它能“开分身”，而在于它把分身、任务、消息和后台恢复组织成了同一套协作运行时。
