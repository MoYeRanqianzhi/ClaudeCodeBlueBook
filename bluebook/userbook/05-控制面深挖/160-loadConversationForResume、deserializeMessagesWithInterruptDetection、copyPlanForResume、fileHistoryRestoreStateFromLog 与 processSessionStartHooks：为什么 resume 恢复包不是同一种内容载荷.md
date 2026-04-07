# `loadConversationForResume`、`deserializeMessagesWithInterruptDetection`、`copyPlanForResume`、`fileHistoryRestoreStateFromLog` 与 `processSessionStartHooks`：为什么 resume 恢复包不是同一种内容载荷

## 用户目标

159 已经把：

- 普通 resume
- `--fork-session`

拆成了两条不同 ownership 合同。

但如果正文停在这里，读者还是很容易把 resume 恢复包写成一句：

- “恢复时就是把旧 transcript 整个塞回来。”

这句还不稳。

从当前源码看，resume 恢复包至少包含四种不同载荷：

1. transcript 合法化载荷
2. plan 文件载荷
3. file-history / 前台状态载荷
4. hook 追加载荷

它们都在“resume 时被带回来”，但不是同一种内容。

## 第一性原理

比起直接问：

- “resume 不就是把旧消息重新读进来吗？”

更稳的问法是先拆五个更底层的问题：

1. 当前带回来的，是给模型继续对话用的 message chain，还是给外部文件系统恢复用的 plan/file-history？
2. 当前带回来的，是从 transcript 里清洗出来的内容，还是在 resume 当下额外执行 hooks 之后新增的内容？
3. 当前内容会不会直接落进 `messages`，还是只会更新 `AppState.fileHistory` / plan slug cache？
4. 当前动作是在修正旧 transcript 的可用性，还是在补一个 resume 时刻才存在的 sidecar 载荷？
5. 如果这些层被混写成“同一种恢复内容”，读者还能解释为什么 plan、file-history 和 hook message 的生命周期都不同吗？

这五问不先拆开，resume 很容易被误写成：

- “把 transcript 原样搬回来”

而当前源码更接近：

- transcript 是主干
- plan / file-history / hook message 是并列 sidecar 载荷

## 第一层：`deserializeMessagesWithInterruptDetection()` 处理的是 transcript 合法化，不是 plan/file-history/hook

`conversationRecovery.ts` 里，`deserializeMessagesWithInterruptDetection()` 做的是纯 transcript 侧的清洗：

- legacy attachment type 迁移
- 非法 `permissionMode` 清除
- unresolved tool use 过滤
- orphaned thinking 过滤
- 空白 assistant 过滤
- interrupted turn 检测与 continuation message 注入
- assistant sentinel 注入

这层回答的问题是：

- “旧 transcript 现在还能不能作为 API-valid 对话继续下去”

不是：

- “plan 文件是否存在”
- “file-history snapshot 是否恢复”
- “resume hooks 是否追加了新消息”

所以它属于：

- transcript sanitation / normalization payload

不是：

- 全部恢复载荷的总代名词

## 第二层：`copyPlanForResume()` 处理的是 plan 文件主权，不是 message chain

`plans.ts` 里的 `copyPlanForResume()` 做的事情和 transcript 主干完全不是一类。

它的主语是：

- 从 log 里恢复 plan slug
- 把 slug 重新绑定到 target session
- 直接读 plan 文件
- 如果文件缺失，再从 file snapshot 或 message history 里回收 plan 内容并写回磁盘

这层回答的问题是：

- “当前 session 的 plan file 身份和内容怎么继续成立”

不是：

- “模型下一轮应该读到哪条 message chain”

所以 plan 在 resume 包里是：

- file-backed sidecar payload

不是：

- transcript body

这也是为什么 159 要继续把：

- `copyPlanForResume()`
- `copyPlanForFork()`

拆开看，因为它们处理的是 plan 文件主权，而不是聊天正文。

## 第三层：`fileHistoryRestoreStateFromLog()` 与 `copyFileHistoryForResume()` 处理的是前台状态和备份链，不是 transcript 正文

`sessionRestore.ts` 里的 `restoreSessionStateFromLog()` 会调用：

- `fileHistoryRestoreStateFromLog(result.fileHistorySnapshots, ...)`

它做的是：

- 重新构造 `FileHistoryState`
- rebuild `trackedFiles`
- 把快照恢复进 `AppState.fileHistory`

这层回答的问题是：

- “前台现在怎么看待已追踪文件和历史快照”

而 `fileHistory.ts` 里的 `copyFileHistoryForResume(log)` 又是另一层：

- 如果 session id 变了，就把旧 session 的 file-history backups 复制到当前 session 名下

它回答的问题则是：

- “当前 session 对应的备份目录怎么继续可用”

这说明 file-history 在恢复包里至少有两种面：

1. 前台状态恢复面
2. 备份文件复制面

它们都不是：

- transcript message payload

所以如果把 file-history 写成“消息的一部分”，就会直接丢掉它的：

- AppState consumer contract
- backup directory contract

## 第四层：`processSessionStartHooks()` 与 `executeSessionEndHooks()` 处理的是 resume 当下的新增注入，不是旧 transcript 的回放

`REPL.tsx` 的 resume 路径里，系统在真正接管前后还会显式执行：

- `executeSessionEndHooks("resume", ...)`
- `processSessionStartHooks("resume", { sessionId, agentType, model })`

`sessionStart.ts` 里 `processSessionStartHooks()` 做的事情包括：

- 加载 plugin hooks
- 执行 `SessionStart` hooks
- 收集 hook messages
- 收集 additional contexts
- 收集 initialUserMessage side channel
- 更新 watch paths
- 把 hook_additional_context 包装成 attachment message

这层回答的问题不是：

- “旧 transcript 里当年写过什么”

而是：

- “当前这次 resume 发生时，系统还需要额外注入什么上下文和 hook 产物”

所以 hook 载荷属于：

- runtime-time appended payload

不是：

- persisted transcript replay

它甚至和 plan / file-history 一样，也不是单纯“消息回放”，而是：

- 在 resume 这一刻重新计算、重新生成的附加层

## 第五层：`loadConversationForResume()` 返回的是多层恢复包，不是单一 transcript blob

`loadConversationForResume()` 的返回结构本身就说明它不是“只回一串消息”。

它会把：

- `messages`
- `turnInterruptionState`
- `fileHistorySnapshots`
- `contentReplacements`
- `contextCollapseCommits`
- `contextCollapseSnapshot`
- `agentName/agentColor/agentSetting`
- `customTitle/tag/mode/worktreeSession`
- `prNumber/prUrl/prRepository`
- `fullPath`

一起返回。

也就是说，从类型层面它已经把恢复包拆成了：

- message payload
- state payload
- metadata payload
- file-path / project payload

所以更准确的写法不是：

- “resume 拿到一条 transcript，然后剩下都是顺手恢复”

而是：

- transcript 只是恢复包里的一个主干分量

## 第六层：REPL 真正消费这些载荷时，也是按不同 consumer 分发的

`REPL.tsx` 对恢复包的消费也不是单通道，而是分发到不同 consumer：

### transcript consumer

- `messages.push(...hookMessages)`
- `setMessages(() => messages)`

### plan consumer

- `copyPlanForResume(...)` 或 `copyPlanForFork(...)`

### file-history consumer

- `restoreSessionStateFromLog(log, setAppState)`
- `copyFileHistoryForResume(log)`

### hook consumer

- `executeSessionEndHooks(...)`
- `processSessionStartHooks(...)`

### session ownership consumer

- `switchSession(...)`
- `restoreSessionMetadata(...)`
- `restoreWorktreeForResume(...)`
- `adoptResumedSessionFile()`

这说明 resume 根本不是“一条恢复流水线只搬一种东西”，而是：

- 多种载荷被分发给不同 consumer contract

## 第七层：因此 resume 的恢复包至少要拆成“四张账”

把前面几层合起来，更稳的四段写法是：

1. transcript 合法化账  
   `deserializeMessagesWithInterruptDetection()` 负责让旧消息重新可继续
2. plan 文件账  
   `copyPlanForResume()` 负责让当前 session 的 plan slug / file 主权继续成立
3. file-history 账  
   `fileHistoryRestoreStateFromLog()` 与 `copyFileHistoryForResume()` 分别恢复前台状态和备份目录
4. hook 注入账  
   `executeSessionEndHooks()` / `processSessionStartHooks()` 负责 resume 时刻新增的运行时上下文

所以更准确的结论不是：

- resume 恢复包就是“旧 transcript 本体”

而是：

- resume 恢复包是一组并列载荷，其中 transcript 只是主干，不是全部

## 苏格拉底式自审

### 问：为什么这页不是 152 的附录？

答：因为 152 讲的是 durable metadata ledger。

160 讲的是恢复包内部的 payload taxonomy，主语已经从 metadata ledger 变成了 payload contract。

### 问：为什么这页不是 158 的附录？

答：因为 158 只拆 preview transcript 和 formal restore。

160 继续往内拆的是 formal restore 里面“到底带回了哪些不同类型的内容”。

### 问：为什么一定要把 `executeSessionEndHooks()` 也写进来？

答：因为如果只写 session-start hooks，读者会把 hook 层误当成“恢复后附送的消息”；其实 resume 前后的 hook 边界本身就是运行时载荷的一部分。

### 问：为什么一定要写 `fileHistoryRestoreStateFromLog()` 和 `copyFileHistoryForResume()` 两层？

答：因为一个恢复的是前台状态，一个复制的是备份文件目录；不拆，file-history 会再次被误写成“只是 transcript 附件”。

## 边界收束

这页只回答：

- resume 恢复包为什么不是同一种内容载荷

它不重复：

- 152 的 durable metadata ledger
- 158 的 preview transcript vs formal restore
- 159 的 fork vs non-fork ownership

更稳的连续写法应该是：

- preview 不是 restore
- restore 不等于 fork
- restore 自己内部也不是同一种 payload
