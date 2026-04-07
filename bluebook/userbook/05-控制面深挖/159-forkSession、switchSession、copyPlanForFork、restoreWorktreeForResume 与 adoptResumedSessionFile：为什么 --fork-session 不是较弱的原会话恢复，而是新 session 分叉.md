# `forkSession`、`switchSession`、`copyPlanForFork`、`restoreWorktreeForResume` 与 `adoptResumedSessionFile`：为什么 `--fork-session` 不是较弱的原会话恢复，而是新 session 分叉

## 用户目标

158 已经把：

- preview transcript
- formal session restore

拆成了两层。

但如果正文停在这里，读者还是很容易把 `--fork-session` 写成一句：

- “它和普通 resume 是同一条恢复链，只是顺手换了个新 session id。”

这句也不稳。

从当前源码看，`--fork-session` 不是：

- 较弱版 restore

而更接近：

- 共享恢复载荷的新 session 分叉

也就是说，它可以重用旧会话的 transcript、plan、metadata、部分 sidecar state，

但不会接管：

- 原 session identity
- 原 session transcript ownership
- 原 session worktree ownership

## 第一性原理

比起直接问：

- “`--fork-session` 不就是 resume 再生成一个新 ID 吗？”

更稳的问法是先拆五个更底层的问题：

1. 当前路径复用的是原 session id，还是保留 fresh startup session id？
2. 当前路径复用的是原 plan slug，还是拷贝出 fork 自己的新 slug？
3. 当前路径是把 `sessionFile` 重新指回原 transcript，还是让 fork 自己之后再落一份新 transcript？
4. 当前路径会不会恢复原会话的 `worktreeSession`，还是故意把它剥掉？
5. 当前路径是在“拿回原 session 所有权”，还是“拿旧内容作为新 session 的起点”？

这五问不先拆开，`--fork-session` 很容易被误写成：

- “普通 resume 的弱化版”

而当前源码更接近：

- normal resume = 恢复原 session ownership
- fork-session = 基于旧载荷生成新 session lineage

## 第一层：两条路径共享的是恢复载荷，不是 session 所有权

`loadConversationForResume()` 和 `processResumedConversation()` 说明，两条路径前半段确实共享大量恢复材料：

- `messages`
- `fileHistorySnapshots`
- `contentReplacements`
- `agentSetting`
- `worktreeSession`
- `customTitle/tag/mode`

所以如果只看“拿到了什么”，很容易误判成：

- fork 和 resume 只是同一种恢复动作的两个选项

但这层共享回答的只是：

- “新运行时起步时要带哪些旧材料”

不是：

- “这些旧材料之后归谁拥有”

所以当前更稳的写法应该是：

- shared resume payload

不等于：

- shared session ownership

## 第二层：`switchSession()` 的缺席说明 fork 没有接管原 session 身份

`sessionRestore.ts` 和 `print.ts` 里最硬的一条分水岭就是：

- 非 `forkSession` 才会 `switchSession(asSessionId(result.sessionId), ...)`
- `forkSession` 分支明确跳过这一步

`main.tsx` 甚至还把：

- `--session-id`

和：

- `--fork-session`

绑在一起，允许用户为 fork 指定一个新的 session id。

这说明 fork 的主语从一开始就不是：

- “继续使用原 session id”

而是：

- “保留当前新 session 身份，只借用旧会话内容起步”

所以它和普通 resume 的第一条本质差异不是显示层，而是：

- identity ownership

普通 resume 会切回原 id；

fork-session 则拒绝这样做。

## 第三层：`copyPlanForFork()` 说明 fork 继承 plan 内容，但拒绝复用原 plan 身份

`plans.ts` 里的 `copyPlanForFork()` 把第二条分水岭钉得很死。

普通 `copyPlanForResume()` 的语义是：

- 复用原 slug
- 把原计划文件继续挂回原 session

而 `copyPlanForFork()` 的语义是：

- 先读出原 slug 对应的计划文件
- 再为 fork 生成一个新的 slug
- 把原 plan 内容复制到新文件

源码注释写得很直接：

- 这样可以避免原 session 和 fork session 互相覆盖 plan 文件

所以这里继承的是：

- plan content

不是：

- plan identity

这条分叉也说明 `--fork-session` 的本质不是“原计划继续执行”，而更像：

- “把原计划复制成 fork 自己的起点”

## 第四层：`recordContentReplacement()` 说明 fork 要把 sidecar 状态重新绑定到新 session

`sessionRestore.ts` 里，`forkSession` 分支还有一条很容易被漏写的动作：

- `recordContentReplacement(result.contentReplacements)`

这一步只在 fork 路径上做，原因也非常清楚：

- transcript 里的 `tool_use_id` 可以从原会话复制过来
- 但 content-replacement entries 是按当前 session id 建索引的

如果不把 replacement records 重新写到 fork 当前的 session id 下，

后续再 resume fork 自己时就会出现：

- transcript 里能看到旧 `tool_use_id`
- 但新 session 的 replacement store 里找不到对应记录

所以 fork 在这里做的不是：

- 沿用原 sidecar state ownership

而是：

- 把可迁移 sidecar state 重新刻到新 session 名下

这再次证明 fork 共享的是载荷，不是 ownership。

## 第五层：`restoreSessionMetadata(...worktreeSession: undefined)` 说明 fork 故意拒绝接管原 worktree

`sessionRestore.ts` 和 `ResumeConversation.tsx` 里都把同一条保护规则写得很明确：

- `forkSession ? { ...result, worktreeSession: undefined } : result`

源码注释甚至直接解释了原因：

- fork 不应该拿走原 session 的 worktree ownership
- 否则 fork 退出时的 “Remove” 可能会删掉原 session 仍然引用的 worktree

这条规则非常关键，因为它说明 fork 不是：

- “把原 session 的 cwd / worktree 一起恢复回来”

而是：

- “在新 session 里选择性继承 metadata，但把 worktree 主权显式剥离”

普通 resume 的写法则相反：

- `restoreWorktreeForResume(result.worktreeSession)`

也就是说，普通 resume 会尝试把目录上下文一起接回去；

fork-session 则明确不这么做。

## 第六层：`adoptResumedSessionFile()` 的缺席说明 fork 不会把后续写入重新绑定到原 transcript

158 已经证明：

- `adoptResumedSessionFile()` 是 formal restore 接管原 transcript ownership 的关键动作

这一页要继续往下拆的是：

- fork-session 正是刻意跳过这一步

`sessionRestore.ts` 对非 fork 路径会：

- `resetSessionFilePointer()`
- `restoreSessionMetadata(...)`
- `restoreWorktreeForResume(...)`
- `adoptResumedSessionFile()`

这样后续写入和 exit cleanup 都会重新回到原 transcript。

但 fork 路径不会 adopt 原 transcript。

源码注释给出的语义非常明确：

- fork 应该在 REPL mount 后通过正常 lazy materialize / `recordTranscript` 流程生成自己的新文件

这意味着 fork 继承的是：

- 旧 transcript 的内容

而不是：

- 旧 transcript 的写回责任

所以如果把 `--fork-session` 写成：

- “先恢复原 session，再从它分叉”

其实会误导读者。

更准确的写法是：

- 它从一开始就没有重新 adopt 原 transcript

## 第七层：fork 的 worktree 持久化策略也不是 restore，而是当前会话自保

`REPL.tsx` 里 `entrypoint === "fork"` 的分支还补了一条很细的动作：

- 如果当前仍在 worktree 中，就 `saveWorktreeState(ws)`

这不是：

- 恢复原 worktreeSession

而是：

- 让 fork 把“自己当前所在的 worktree”重新记成自己的状态

也就是说，fork 对 worktree 的策略不是 takeover，而是：

- keep current safe state

这和普通 resume 的：

- `exitRestoredWorktree() -> restoreWorktreeForResume(...)`

完全不是同一类动作。

## 第八层：因此 `--fork-session` 和普通 resume 应该被写成两条不同的恢复合同

把前面几层合起来，更稳的写法可以压成两条：

### 普通 resume

- 复用原 session id
- 复用原 plan slug
- 恢复原 worktreeSession
- adopt 原 transcript
- 让后续写入继续落到原 session

### `--fork-session`

- 保留 fresh session id
- 复制 plan 内容到新 slug
- 迁移可复用 sidecar state 到新 session 名下
- 剥离原 worktree ownership
- 不 adopt 原 transcript
- 让后续写入落到 fork 自己的新 transcript

所以更准确的结论不是：

- `--fork-session` 是较弱的原会话恢复

而是：

- `--fork-session` 是“基于旧恢复载荷启动的新 session 分叉”

## 苏格拉底式自审

### 问：为什么这页不是 158 的附录？

答：因为 158 只拆到 preview vs formal restore。

159 继续往后拆的是：

- formal restore 内部的 normal ownership path
- fork-session 的 new-lineage path

这已经不是同一层边界。

### 问：为什么一定要写 `copyPlanForFork()`？

答：因为 plan slug 的分叉是最直观的证据之一，能证明 fork 继承的是内容，不是身份。

### 问：为什么一定要写 `worktreeSession: undefined`？

答：因为这条规则直接暴露了 fork 对原 worktree ownership 的拒绝，不写它，fork 很容易被误画成“只是不 adopt transcript 的 restore”。

### 问：为什么一定要写 `recordContentReplacement()`？

答：因为这能说明 fork 不是简单跳过 sidecar state，而是把可迁移状态重新绑定到新 session 身份。

## 边界收束

这页只回答：

- `--fork-session` 为什么不是较弱的原 session restore，而是新 session 分叉

它不重复：

- 152 的 durable metadata ledger
- 157 的 list summary vs preview transcript
- 158 的 preview transcript vs formal restore

更稳的三段写法应该是：

- preview 不是 restore
- restore 不等于 fork
- fork 共享载荷，但不共享原 session ownership
