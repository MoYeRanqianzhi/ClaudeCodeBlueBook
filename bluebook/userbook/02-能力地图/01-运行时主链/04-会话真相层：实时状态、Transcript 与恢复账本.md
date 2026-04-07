# 会话真相层：实时状态、Transcript 与恢复账本

## 第一性原理：Claude Code 维护的是两本账，而不是一个“聊天历史”

这一层最容易被误写。

更准确的说法是：

- 一本是实时账，回答“现在是不是在跑、卡在哪里、正在做什么”。
- 一本是恢复账，回答“下次回来时，怎样把这项工作重新拼起来继续做”。

只有把这两本账分开，`pending_action`、`resume`、`compact`、worktree 恢复这些东西才不会混写。

更稳的去魅句还要再多记三条：

1. `protocol transcript != display transcript`
   - 能被滚屏看见的历史，不等于恢复器消费的协议主链。
2. `recovery asset != current-truth signer`
   - metadata、sidecar、compact summary 帮助恢复，但不单独签当前世界。
3. `resume restores worksite, not sovereignty`
   - `/resume` 恢复的是工作现场资格，不是无条件接管旧路径、旧权限或旧 pending state。

display transcript 可以帮助定位问题，但真正决定还能不能继续的仍是 message chain、boundary、required assets 与 session metadata。

## 实时账：`SessionState` + `RequiresActionDetails`

`src/utils/sessionState.ts` 给出了一个很清晰的定义：

- `SessionState = idle | running | requires_action`
- `RequiresActionDetails` 负责描述当前卡住的是哪一个 tool use、在做什么、原始输入是什么

`notifySessionStateChanged()` 是单点推进器：

- 把相位改成 `idle / running / requires_action`
- 在 `requires_action` 时把结构化细节镜像到 `external_metadata.pending_action`
- 在回到非阻塞状态时清掉 `pending_action`
- 在 `idle` 时清掉中途进度用的 `task_summary`

所以真正的实时真相不是 transcript，而是这个相位对象。

## `task_summary` 和 `post_turn_summary` 是观察层，不是主状态

它们的作用是：

- 让外部宿主知道“这一轮大概在做什么”
- 让长任务在还没结束时也能显示进度

但它们不是恢复闭环的主依据。写 userbook 时，应该把它们写成观察面，而不是恢复面。

## progress、duplicate 与 zombie 都不该写回主链

源码里至少有两条很硬的反漂移纪律：

1. `sessionStorage.ts` 明写 progress 不是 transcript participant，旧 progress 只配被 bridge 掉，不能继续留在 parentUuid 主链里。
2. `structuredIO.ts` 明写 duplicate control_response 不能再推第二份 assistant 轨迹，否则会把旧 tool_use 重新写成当前消息链。

这说明 Claude Code 保护的不是“所有历史都回放”，而是“只有仍合法的协议主链才配继续写回现在”。

## 恢复账：transcript JSONL + metadata + sidecar

真正决定 `/resume` 能恢复什么的是另一层：

- transcript JSONL 里的消息主链
- compact boundary 与 summary
- title、tag、agent、mode、worktree、PR 等 session metadata
- content replacement、file history 等恢复资产
- subagent / remote-agent sidecar metadata

`sessionStorage.ts` 是这本账的写入器和读取器。

推论：Claude Code 存的不是“聊过什么”，而是“恢复这个工作对象要用到哪些证据”。

## `reAppendSessionMetadata()` 为什么这么重要

`sessionStorage.ts` 反复强调一个约束：

- `/resume` 的 progressive loading 只看 transcript 尾部的有限窗口

所以系统会在 compaction 和 session exit 时把 title、tag、mode、worktree 等 metadata 重新盖回 transcript 尾部，确保恢复器总能在尾部窗口里找到它们。

这意味着：

- session metadata 不是附属 UI 信息。
- 它们是恢复账的一部分。

## worktree 状态也属于恢复账

`saveWorktreeState()` 会把当前 worktree 状态写进 transcript：

- 进入 worktree 时写当前隔离面
- 退出 worktree 时写 `null`

这样 `/resume` 才能区分：

- 会话本来就不该回到 worktree
- 还是会话在 worktree 里中断了

但这仍然不是绝对恢复承诺。如果 `worktreePath` 已经失效，系统会降级，而不是强行恢复死路径。

## `/resume` 恢复的是工作现场，不只是标题

`resume.tsx` 清楚区分了三种情况：

- 同目录，直接恢复
- 同 repo 其他 worktree，可直接恢复
- 不同目录，只给出应执行的命令而不是直接接管

这再次说明 Claude Code 的恢复单位是“工作现场”，不是“会话名字”。

## `compact` 是在同一本账上继续写，不是丢掉过去

`compact.ts` 的核心动作不是清空，而是：

- 写 boundary
- 写 summary
- 保留必要片段
- 重新注入 plan、skill、async task 等继续工作所需附件
- 再把 session metadata 盖回尾部

所以 compaction 的真实含义是：

- 把恢复账重写成更小但还能继续工作的版本

## 进入这一层前的 first reject signal

1. 你把滚屏 transcript 当成 `/resume` 的主链，而不是把它先分成 display 与 protocol 两层。
2. 你把 `pending_action`、`task_summary` 或 `post_turn_summary` 当成恢复资格，而不是把它们看成观察面。
3. 你把旧 `worktreePath`、title、tag 或 compact summary 当成 current truth signer，而不是恢复资产。

## 稳定主线与条件边界

### 稳定主线

- `/resume` 基于 transcript + metadata 的恢复闭环
- `compact` 的 boundary + summary 模型
- worktree、mode、title、tag 等 session metadata 盖章与恢复
- `memory` 作为长期规则外置层

### 条件或只应写成观察面

- `pending_action`
- `task_summary`
- `post_turn_summary`
- `external_metadata`
- `session_state_changed` 事件流
- 自动 session memory 提取与更细的 compaction 优化路径

这些都重要，但它们更像宿主观察层或条件增强层，不应抢占恢复主线的位置。

## 对用户的使用结论

### 结论 1

把 transcript 当“聊天记录”会误判很多行为。它更接近恢复账本。

### 结论 2

`pending_action` 很有用，但它回答的是“现在卡在哪里”，不是“下次回来如何恢复”。

### 结论 3

`/resume`、`/compact`、`memory`、worktree 恢复应被看成同一连续性系统的不同时间尺度，而不是几条互不相干的命令。

### 结论 4

恢复做得越强，越要警惕恢复资产越权；真正成熟的连续性，不是让旧状态自动回来，而是让旧状态只能在仍合法时回来。

## 源码锚点

- `src/utils/sessionState.ts`
- `src/utils/sessionStorage.ts`
- `src/utils/conversationRecovery.ts`
- `src/utils/sessionRestore.ts`
- `src/commands/resume/resume.tsx`
- `src/services/compact/compact.ts`
- `src/services/compact/sessionMemoryCompact.ts`
- `src/services/SessionMemory/sessionMemory.ts`
- `src/QueryEngine.ts`
