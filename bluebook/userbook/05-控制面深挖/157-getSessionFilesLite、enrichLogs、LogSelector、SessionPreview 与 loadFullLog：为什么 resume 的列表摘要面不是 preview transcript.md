# `getSessionFilesLite`、`enrichLogs`、`LogSelector`、`SessionPreview` 与 `loadFullLog`：为什么 `/resume` 的列表摘要面不是 preview transcript

## 用户目标

152 已经把：

- `system/init`
- `external_metadata`
- durable session metadata

拆成了三张不同账。

156 又继续把：

- `/resume` preview 的本地 transcript 快照
- attached viewer 的 remote history

拆成了两种不同的 history provenance。

但如果正文停在这里，读者还是很容易把 `/resume` 自己内部的两层面压成一句：

- 列表里看到一条会话摘要
- 按 `Ctrl+V` / preview 后看到一条 transcript

于是正文就会滑成：

- “列表和 preview 只是同一条本地 transcript 的薄厚两种显示。”

这句不稳。

从当前源码看，`/resume` 至少有两层不同 surface：

1. 列表摘要面
2. preview transcript 面

它们都读本地 durable log，但不是同一种 transcript surface。

## 第一性原理

比起直接问：

- “列表和 preview 不都是读本地会话文件吗？”

更稳的提问是先拆五个更底层的问题：

1. 当前读的是 stat+lite metadata，还是完整 transcript chain？
2. 当前面要解决的是“先把可 resume 的会话列出来”，还是“把某条会话的正文真正展开”？
3. 当前结果值里 `messages` 是空的，还是已经完成 `loadTranscriptFile() + buildConversationChain()`？
4. 当前失败语义是 log 被 enrich 过滤掉，还是 preview 阶段 full log hydrate 失败？
5. 如果列表行根本不需要完整 `messages`，它还能被写成“只是 preview 的缩略版”吗？

这五问不先拆开，`/resume` 的列表和 preview 很容易被压回：

- “同一 transcript 的薄厚两层”

而当前源码更接近：

- 同一 durable source 上的两种不同 consumer contract

## 第一层：`getSessionFilesLite()` 先回答“哪些 session 值得进列表”

`sessionStorage.ts` 里 `getSessionFilesLite(...)` 的注释已经写得非常明确：

- pure filesystem metadata
- stat only
- no file reads

它返回的 `LogOption` 甚至直接带着：

- `messages: []`
- `isLite: true`
- `sessionId`
- `fullPath`
- `modified`

也就是说这一步回答的问题不是：

- “把 transcript 正文读出来”

而是：

- “有哪些 session files 值得先进入 resume picker”

所以 `getSessionFilesLite(...)` 从一开始就属于：

- list candidate surface

不是：

- transcript preview surface

## 第二层：`enrichLogs()` 只是把列表摘要面补到可用，不会把它升级成 full transcript

`sessionStorage.ts` 里 `enrichLog(...)` / `enrichLogs(...)` 又把这层钉死。

这里 enrichment 读的是：

- `readLiteMetadata(...)`

然后把 lite log 补成：

- `firstPrompt`
- `gitBranch`
- `customTitle`
- `summary`
- `tag`
- `agentSetting`
- PR 信息

它的目标也很明确：

- 如果没有 `firstPrompt` 和 `customTitle`，给 fallback `(session)`
- 过滤 `isSidechain`
- 过滤 `teamName`

也就是说 enrichment 回答的是：

- 列表里该显示什么摘要信息
- 哪些 session 该被筛掉

而不是：

- 现在就把 transcript 正文读全

所以被 `enrichLogs()` 补过的 log 仍然更像：

- enriched list row data

不是：

- preview-ready transcript

## 第三层：`LogSelector` 列表消费的是 title/metadata/snippet，而不是 full messages

`LogSelector.tsx` 里列表项的构造逻辑也很克制。

在普通 list mode 下，它会为每条 log 组装：

- `label: summary`
- `description: baseDescription [+ projectSuffix/snippet]`

这里的输入是：

- `getLogDisplayTitle(log)`
- `formatLogMetadata(log)`
- 可选 snippet

而不是：

- `displayLog.messages`

也就是说列表面真正消费的是：

- 标题
- 摘要
- metadata
- 搜索 snippet

这层回答的问题是：

- “这条会话值不值得我点进去”

不是：

- “这条会话正文长什么样”

所以就算列表和 preview 共享同一条 durable source，

列表面仍然不等于 preview transcript 的缩略版。

## 第四层：`SessionPreview` 才真正进入 full log hydrate 和 transcript chain

`LogSelector.tsx` 在：

- `viewMode === "preview"`

时会切到：

- `<SessionPreview log={previewLog} ... />`

而 `SessionPreview.tsx` 又明确分两步：

1. 如果 `isLiteLog(log)` 为真，就 `loadFullLog(log)`
2. 用 `displayLog.messages` 喂给 `<Messages ... screen="transcript" showAllInTranscript={true} />`

这里回答的问题已经完全变了：

- 不是列表摘要要显示什么
- 而是这条 durable session transcript 要怎样被完整展开、预览、再进一步 resume

所以 preview 面的主语是：

- full transcript preview

不是：

- enriched list row

## 第五层：`loadFullLog()` 的工作是从 durable file 重建 conversation chain，不是给列表补几个字段

`loadFullLog(...)` 的实现进一步说明 preview 面和列表面不是同一层。

这里做的事情包括：

- `loadTranscriptFile(sessionFile)`
- 读取 `messages`
- 读取 `summaries`
- 读取 `customTitles`
- 找 `mostRecentLeaf`
- `buildConversationChain(messages, mostRecentLeaf)`

这不是：

- metadata enrichment

而是：

- transcript reconstruction

所以更稳的写法应该是：

### 列表面

- `getSessionFilesLite` + `enrichLogs`
- 解决的是列表摘要与过滤

### preview 面

- `loadFullLog`
- 解决的是 full transcript hydration 与 chain reconstruction

这两层虽然都从同一 durable log 来，

但它们的 contract 明显不同。

## 第六层：因此 `/resume` 里“看见一条会话”和“看见它的正文”不是同一种 surface

把前面几层合起来，最小结论就很稳定了。

### 列表摘要面

它回答：

- 哪些 session 应该进列表
- 用什么标题/摘要/metadata 展示
- 什么时候 progressive enrich
- 哪些 session 应该被过滤掉

### preview transcript 面

它回答：

- 这条 session 的正文怎么被 hydrate 出来
- 以什么 conversation chain 被送进 `Messages`
- 让用户在 resume 前看到什么完整内容

所以当前源码支持的更准确写法不是：

- 列表和 preview 只是同一 transcript 的薄厚两层

而是：

- `/resume` 内部自己就至少有列表摘要面和 preview transcript 面两种不同 consumer contract

## 稳定面与灰度面

### 稳定面

- `getSessionFilesLite()` 是 stat-only 列表候选面
- `enrichLogs()` 补的是摘要字段与过滤，不是 full transcript
- `LogSelector` 列表项消费的是 title/metadata/snippet
- `SessionPreview` 才真正触发 `loadFullLog()`
- `loadFullLog()` 的核心工作是 transcript chain reconstruction

### 灰度面

- 列表摘要未来是否会继续增补更多 lightweight enrichment 字段
- preview 是否会继续加入更多 transcript-side metadata 辅助信息
- snippet/search 策略是否还会继续调整

## 为什么这页不是 152、156

### 不是 152

152 讲的是：

- durable metadata ledger

157 讲的是：

- 在同一 durable source 上，列表摘要 consumer 和 preview transcript consumer 不是同一层

### 不是 156

156 讲的是：

- local preview vs attached viewer remote history

157 完全留在本地 durable 一侧，

只继续往里拆：

- resume list row vs preview transcript

## 苏格拉底式自审

### 问：为什么不能把列表行写成 preview 的摘要版？

答：因为列表行的 contract 是 `getSessionFilesLite + enrichLogs + metadata/snippet`，而 preview 的 contract 是 `loadFullLog + buildConversationChain + Messages`。

### 问：为什么一定要把 `enrichLogs()` 单独写出来？

答：因为如果没有这层，读者很容易误以为列表行要么只靠 stat，要么已经把 transcript 读全；实际上它走的是中间层：lite metadata enrichment。

### 问：为什么一定要把 `Messages` 写进来？

答：因为 preview 和 attached viewer 共享 renderer 壳，列表却不共享；这能帮助读者看清三层面之间的边界。

### 问：这页的一句话 thesis 是什么？

答：`/resume` 的列表摘要面消费的是 `getSessionFilesLite + enrichLogs` 产出的轻量 durable metadata，而 `SessionPreview` 才会通过 `loadFullLog()` 重建完整 transcript；两者同属本地 durable 侧，却不是同一种 transcript surface。

## 结论

对当前源码来说，更准确的写法应该是：

1. `getSessionFilesLite()` 负责把 session file 先变成列表候选
2. `enrichLogs()` 负责把它补成可展示的摘要面
3. `LogSelector` 列表消费的是 title/metadata/snippet
4. `SessionPreview` 才真正进入 `loadFullLog()` 和 `Messages`
5. `loadFullLog()` 做的是 transcript reconstruction，不是列表补字段

所以：

- `/resume` 的列表摘要面不是 preview transcript

## 源码锚点

- `claude-code-source-code/src/utils/sessionStorage.ts`
- `claude-code-source-code/src/components/LogSelector.tsx`
- `claude-code-source-code/src/components/SessionPreview.tsx`
- `claude-code-source-code/src/commands/resume/resume.tsx`
