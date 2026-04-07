# `parseSessionIdentifier`、`hydrateFromCCRv2InternalEvents`、`hydrateRemoteSession`、`loadConversationForResume`、`resumeSessionAt` 与 `processSessionStartHooks`：为什么 `print` resume 的标识符解析、远端回灌与正式恢复不是同一种前置阶段

## 用户目标

162 已经把：

- interactive TUI resume host
- `print.ts` / headless print host

拆成了两种不同宿主族。

但如果正文停在这里，读者还是很容易把 `print.ts` 里的 resume 前置动作压成一句：

- “先把远端历史拉下来，再恢复一下就行。”

这句还不稳。

从当前源码看，`print.ts` 的 `--resume` 前面至少还有五个不同阶段：

1. 标识符解析
2. 远端到本地 transcript 回灌
3. formal restore load
4. 空会话 fallback
5. message-level rewind

它们都发生在“print resume 前后”，但不是同一种前置阶段。

## 第一性原理

比起直接问：

- “print 模式 resume 之前到底做了什么？”

更稳的问法是先拆五个更底层的问题：

1. 当前是在识别输入是 session id、URL 还是 `.jsonl` 文件，还是已经真正开始恢复 transcript？
2. 当前是在把远端日志写回本地 transcript 文件，还是已经读取本地 transcript 并生成恢复包？
3. 当前是在判断“其实没有旧会话可恢复，应退回 startup hook”，还是已经拿到了可恢复消息？
4. 当前是在把恢复结果缩到某个 message uuid 截点，还是在决定是否恢复成功？
5. 如果这些动作的输入、输出和失败语义都不同，为什么还要把它们写成同一个“resume 前置步骤”？

这五问不先拆开，`print` resume 很容易被误写成：

- “parse -> hydrate -> resume” 三段糊成一团

而当前源码更接近：

- parse identifies
- hydrate materializes
- restore loads
- fallback decides absence semantics
- rewind trims recovered history

## 第一层：`parseSessionIdentifier()` 先回答“你给我的到底是什么”

`sessionUrl.ts` 的 `parseSessionIdentifier(...)` 不是恢复器，它只是入口解释器。

它会把输入分成三类：

- `.jsonl` 文件路径
- 纯 UUID
- URL

而且 URL 和 `.jsonl` 这两类还会生成新的随机 `sessionId` 载体。

这层回答的问题是：

- “这个 `--resume` 参数应该走哪一条解释路径”

不是：

- “现在就可以把旧会话恢复到运行时”

所以它属于：

- identifier classification stage

不是：

- restore stage

## 第二层：`hydrateFromCCRv2InternalEvents()` / `hydrateRemoteSession()` 处理的是远端回灌，不是 formal restore

`print.ts` 在识别出 URL / remote resume 之后，还可能先走：

- `hydrateFromCCRv2InternalEvents(sessionId)`
- 或 `hydrateRemoteSession(sessionId, ingressUrl)`

`sessionStorage.ts` 里的这两个函数做的事情非常具体：

- `switchSession(asSessionId(sessionId))`
- 拉远端事件 / 日志
- 在本地 project dir 下写出 transcript 文件

这层回答的问题是：

- “本地现在有没有一份可供后续 restore 读取的 transcript 文件”

不是：

- “恢复包已经生成完毕”

所以 remote hydrate 的主语是：

- remote-to-local transcript materialization

不是：

- formal restore

## 第三层：`loadConversationForResume()` 才是 formal restore load

无论前面是：

- UUID
- `.jsonl`
- URL + hydrate
- CCR v2 internal events + hydrate

最后真正把 transcript 读进恢复包的，仍然是：

- `loadConversationForResume(parsedSessionId.sessionId, parsedSessionId.jsonlFile || undefined)`

这时系统才会真正做：

- full log load
- transcript 合法化
- plan / file-history / hook payload 组装

也就是说，formal restore load 的问题是：

- “现在能不能从当前本地 transcript 状态中构出恢复包”

而不是：

- “resume 参数是什么”
- “远端内容有没有回灌下来”

所以在 print host 里：

- parse
- hydrate
- restore load

是三张不同账。

## 第四层：empty-session fallback 不是恢复成功，而是“承认没有旧内容可恢复”

`print.ts` 里最容易被漏写的一条分水岭是：

- `if (!result || result.messages.length === 0)`

这之后分两类语义：

### URL / CCR v2 路径

- 如果是 URL 或 `CLAUDE_CODE_USE_CCR_V2`
- 即使 `loadConversationForResume()` 返回空消息
- 也不会直接报错
- 而是回退到 `processSessionStartHooks("startup")`

### 普通 session id 路径

- 如果既不是 URL 也不是 CCR v2
- 空结果就报错并退出

这说明这层回答的问题不是：

- “消息恢复成功了吗”

而是：

- “当前空结果应该被解释为新会话 startup，还是解释为 resume 失败”

所以 empty-session fallback 属于：

- absence semantics stage

不是：

- hydrate stage

也不是：

- restore payload stage

## 第五层：`resumeSessionAt` 是 message-level rewind，不是恢复前置也不是 hydrate

`print.ts` 里 `resumeSessionAt` 发生在：

- 已经拿到 `result.messages`

之后。

它会：

- 按 `message.uuid` 查找目标消息
- 找不到就报错退出
- 找到就 `slice(0, index + 1)`

这层回答的问题是：

- “恢复出来的消息链要不要只保留到某个截点”

不是：

- “如何识别输入”
- “是否需要从远端回灌”
- “是否能构出恢复包”

所以它属于：

- post-restore message trimming stage

不是：

- formal restore

## 第六层：print resume 的前置链至少是“五段”，不是一段

把前面几层合起来，`print.ts` 的 resume 更稳的写法应该是：

1. identifier classification
   `parseSessionIdentifier(...)`
2. remote transcript materialization
   `hydrateFromCCRv2InternalEvents(...)` / `hydrateRemoteSession(...)`
3. formal restore load
   `loadConversationForResume(...)`
4. absence semantics decision
   empty result -> startup hooks or hard error
5. message-level rewind
   `resumeSessionAt`

所以更准确的结论不是：

- print resume 只是“先 hydrate，再恢复”

而是：

- print resume 的前置阶段本身就已经是多层合同

## 第七层：这也解释了为什么 `print` 路径和 interactive 路径不能直接互译

interactive 路径通常不会先显式做：

- `parseSessionIdentifier()` 这类 URL / `.jsonl` 解释
- `hydrateFromCCRv2InternalEvents()` 的 headless transcript 回灌
- 空消息时退回 `processSessionStartHooks("startup")`
- `resumeSessionAt` 这种消息级裁剪

这说明 `print.ts` 并不是把 interactive resume 简化掉，而是：

- 它拥有自己的一整套前置阶段

而 interactive 路径更像：

- 已经站在一个本地可交互宿主里，直接进入 restore contract

## 苏格拉底式自审

### 问：为什么这页不是 162 的附录？

答：因为 162 只拆了 host family。

163 继续往 `print.ts` 宿主内部拆它自己的 pre-restore stage taxonomy。

### 问：为什么一定要把 `parseSessionIdentifier()` 单独拿出来？

答：因为输入解释是整个链的最前层，不把它拆开，`.jsonl` / URL / UUID 三类路径会被误写成“都是 session id”。

### 问：为什么一定要写 empty-session fallback？

答：因为它直接决定“空 transcript”在 print host 里到底是 startup 还是失败，这不是 payload 也不是 host family 能替代解释的。

### 问：为什么一定要写 `resumeSessionAt`？

答：因为它证明 print resume 在 formal restore 之后还可能继续做 message-level 裁剪；不写它，读者会把恢复结果误当成天然终态。

## 边界收束

这页只回答：

- 为什么 `print` resume 的标识符解析、远端回灌与正式恢复不是同一种前置阶段

它不重复：

- 160 的 payload taxonomy
- 161 的 interactive entry hosts
- 162 的 host family split
- CLI 根入口总论或 remote metadata sink

更稳的连续写法应该是：

- shared host family 不等于 shared pre-stage chain
- print host 自己内部也不等于同一种 pre-restore stage
