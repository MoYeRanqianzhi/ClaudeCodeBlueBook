# `SessionPreview`、`loadFullLog`、`loadConversationForResume`、`switchSession` 与 `adoptResumedSessionFile`：为什么 `/resume` 的 preview transcript 不是正式 session restore

## 用户目标

157 已经把：

- 列表摘要面
- preview transcript 面

拆成了两层。

但如果正文停在这里，读者还是很容易把按 `Ctrl+V` 看到 preview、再按 `Enter` 进入恢复写成一句：

- “preview 都已经把 transcript 读全了，所以正式 resume 只是沿着同一条内容继续聊。”

这句还不稳。

从当前源码看，`/resume` 至少还存在另一道边界：

1. preview transcript inspection
2. formal session restore / runtime ownership handoff

前者回答的是：

- “这条 session 里到底写了什么”

后者回答的是：

- “当前 runtime 现在是不是已经接管这条 session，后续写入是不是会重新落回这条 transcript”

## 第一性原理

比起直接问：

- “preview 和 resume 不都读同一条 transcript 吗？”

更稳的问法是先拆五个更底层的问题：

1. 当前动作只是把 durable transcript hydrate 出来，还是已经切换当前 session ownership？
2. 当前只是把 `messages` 喂给 `Messages`，还是已经把 skill state、file history、hook message、worktree、metadata cache 一并恢复？
3. 当前拿到的只是一个 full `LogOption`，还是一份准备交给 REPL 接管的 resume package？
4. 当前只是读取旧 transcript，还是已经让当前 project 的 `sessionFile` 指向那条 resumed transcript？
5. 如果当前路径没有 `switchSession()`、`restoreSessionMetadata()`、`restoreWorktreeForResume()`、`adoptResumedSessionFile()`，它还能被写成正式 restore 吗？

这五问不先拆开，preview 很容易被误写成 restore 的“预热阶段”。

而当前源码更接近：

- preview = transcript inspection
- restore = runtime takeover

## 第一层：`LogOption` 本来就不是单一厚度对象

`src/types/logs.ts` 里的 `LogOption` 从一开始就同时容纳：

- `messages`
- `sessionId`
- `agentSetting`
- `worktreeSession`
- `contentReplacements`
- `contextCollapseCommits`
- 以及其他恢复附属状态

也就是说它本来就不是一句：

- “只要拿到一个 `LogOption`，session 就算恢复完成了”

157 已经证明：

- lite `LogOption` 只够做列表摘要面
- full `LogOption` 才够做 preview transcript 面

但即使 `loadFullLog()` 已经把 `messages` 补全，它返回的也仍然只是：

- full durable log object

不是：

- 当前 runtime 已经接管这条 session 的证明

所以 `LogOption` 更像：

- 恢复载体

而不是：

- 恢复完成态

## 第二层：`SessionPreview` 只把 transcript 展开给人看

`LogSelector.tsx` 进入 preview mode 后，会切到：

- `<SessionPreview log={previewLog} />`

`SessionPreview.tsx` 做的核心动作其实很克制：

1. 如果传进来的是 lite log，就先 `loadFullLog(log)`
2. 再把 `displayLog.messages` 交给 `<Messages screen="transcript" showAllInTranscript />`

这层回答的问题是：

- “这条 durable transcript 长什么样，值不值得 resume”

不是：

- “现在就让当前 REPL 的 session 主权切到它身上”

所以 preview 即使已经 full hydrate，也仍然只是：

- transcript inspection surface

不是：

- runtime restore surface

## 第三层：`loadConversationForResume()` 才把 preview transcript 变成可恢复的 session 包

`conversationRecovery.ts` 里的 `loadConversationForResume()` 说明正式恢复前还有一层比 preview 更厚的准备动作。

如果输入还是 lite log，它当然也会先 `loadFullLog(log)`。

但真正新增的厚度在后半段：

- 用 `getSessionIdFromLog()` 确认恢复目标
- `copyPlanForResume(log, sessionId)`
- `copyFileHistoryForResume(log)`
- `restoreSkillStateFromMessages(messages)`
- `deserializeMessagesWithInterruptDetection(messages)`
- `processSessionStartHooks("resume", { sessionId })`
- 把 hook messages 追加回消息链
- 连同 `fileHistorySnapshots`、`contentReplacements`、`contextCollapseCommits`、`worktreeSession`、`agentSetting`、`mode` 等一起返回

所以 `loadConversationForResume()` 的产物已经不再是：

- 一条“能预览”的 transcript

而是：

- 一份“可以交给 runtime 接管”的恢复包

换句话说，preview 只负责看到正文；

`loadConversationForResume()` 已经开始负责：

- 让这条正文重新带上它的附属状态
- 让 resume 时需要的 hook 和中断修正进入可执行态

## 第四层：`resume.tsx` / `REPL.tsx` 和 `ResumeConversation.tsx` 才真正完成 runtime ownership handoff

formal resume 实际有两条入口：

1. 已经在 REPL 中执行 `/resume`
2. 启动时进入 `ResumeConversation.tsx` picker

两条入口的前半段都可能经过 preview，但真正的 restore boundary 一样都不在 preview 里。

### `/resume` slash 路径

`resume.tsx` 在 picker 里选中某条 log 之后，会：

- 校验 session id
- 必要时先 `loadFullLog(log)`
- 处理 cross-project gate
- 再把目标交给 `onResume(..., "slash_command_picker")`

后面的正式恢复由 `REPL.tsx` 的 resume 路径接管。

这条路径除了会反序列化 transcript、处理 interrupted turn、跑 session-end / session-start hooks 之外，真正的 ownership handoff 还包括：

- `switchSession(...)`
- `renameRecordingForSession()`
- `resetSessionFilePointer()`
- `restoreSessionMetadata(...)`
- `restoreWorktreeForResume(...)`
- `adoptResumedSessionFile()`
- 重建 remote agent tasks / content-replacement / live REPL state

### 启动 picker 路径

`ResumeConversation.tsx` 的 `onSelect()` 走的是另一条外观不同、边界相同的恢复链。

在 `loadConversationForResume()` 成功之后，非 `forkSession` 的正式恢复还会继续执行：

- `switchSession(asSessionId(result.sessionId), dirname(fullPath)?)`
- `renameRecordingForSession()`
- `resetSessionFilePointer()`
- `restoreCostStateForSession(sessionId)`
- `restoreAgentFromSession(...)`
- `restoreSessionMetadata(result)`
- `restoreWorktreeForResume(result.worktreeSession)`
- `adoptResumedSessionFile()`
- `restoreFromEntries(result.contextCollapseCommits, result.contextCollapseSnapshot)`
- 最后把 `initialMessages`、`initialFileHistorySnapshots`、`initialContentReplacements` 等一起塞进 `<REPL />`

所以这里做的已经不是：

- “把 transcript 画出来”

而是：

- 切当前 session id
- 切当前 project dir / worktree 归属
- 切当前 transcript 归属
- 切 cost / agent / mode / context-collapse 缓存
- 让后续对话继续写回同一条 resumed session

这才是 formal session restore。

## 第五层：`adoptResumedSessionFile()` 是 preview 从没跨过去的分水岭

`sessionStorage.ts` 里 `adoptResumedSessionFile()` 的注释非常关键。

它不是简单再读一次 metadata，而是：

- 把当前 project 的 `sessionFile` 指向 resumed transcript path
- 立刻 `reAppendSessionMetadata(true)`

这意味着正式 restore 在磁盘层真正接管了：

- 后续写入落到哪条 transcript
- 退出清理时 re-append metadata 写回哪条 transcript

preview 没有这一步。

preview 只是在：

- 读取旧文件
- 还原可阅读的 message chain

它不会改当前 runtime 的 file pointer，也不会把 exit cleanup、后续写入、metadata re-append 重新绑定到那条旧 session 上。

所以 preview 再完整，也只是 inspection；

只有 adopt 之后，才是 ownership handoff。

## 第六层：因此 `/resume` 实际至少有四段本地流水线

把 157 和本页合起来，`/resume` 至少可以拆成四段：

1. stat-only discover
   `getSessionFilesLite()` 先找出候选 session
2. lite enrich list
   `enrichLogs()` / `LogSelector` 形成列表摘要面
3. preview hydrate / inspect
   `SessionPreview` / `loadFullLog()` 把正文展开给人看
4. resume package / runtime takeover
   `loadConversationForResume()` + `ResumeConversation` + `switchSession()` + `adoptResumedSessionFile()` 完成正式恢复

因此更准确的写法不是：

- preview 已经是 restore，只差按一下 `Enter`

而是：

- preview 只证明“这条 transcript 值得恢复”
- formal restore 才证明“当前 runtime 已经接管这条 session”

## 苏格拉底式自审

### 问：为什么这页不是 157 的附录？

答：因为 157 停在“列表摘要面 vs preview transcript 面”。

158 继续往后拆的是：

- preview transcript 面
- runtime restore 面

这已经不是同一层 consumer contract。

### 问：为什么一定要写 `loadConversationForResume()`？

答：因为只有把 skill restore、hook append、file history / context-collapse 一起写出来，读者才不会把 full transcript hydrate 误写成完整恢复。

### 问：为什么一定要写 `switchSession()` 和 `adoptResumedSessionFile()`？

答：因为 formal restore 的本质不是“把旧内容读回来”，而是“让当前 runtime 与后续写入重新归属那条旧 session”。

### 问：为什么一定要写 `restoreWorktreeForResume()`？

答：因为正式恢复甚至可能把 cwd 和 worktree state 一并接回去；preview 从头到尾都不拥有这种目录主权。

## 边界收束

这页只回答：

- `/resume` 的 preview transcript 为什么不是 formal session restore

它不重复：

- 152 的 durable metadata sovereignty
- 156 的 local preview vs remote history provenance
- 157 的 list summary vs preview transcript thickness

更稳的四段写法应该是：

- list candidate
- list summary
- preview transcript
- formal restore / runtime ownership handoff
