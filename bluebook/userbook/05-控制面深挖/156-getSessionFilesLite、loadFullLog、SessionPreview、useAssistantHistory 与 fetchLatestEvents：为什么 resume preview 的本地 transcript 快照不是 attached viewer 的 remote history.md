# `getSessionFilesLite`、`loadFullLog`、`SessionPreview`、`useAssistantHistory` 与 `fetchLatestEvents`：为什么 `/resume` preview 的本地 transcript 快照不是 attached viewer 的 remote history

## 用户目标

58 已经拆过：

- attached viewer 的首问加载
- history paging
- title ownership

118 又拆过：

- local echo
- history/live overlap
- replay dedup

153 刚刚把：

- `loading older messages…`
- `failed to load older messages`
- `start of session`

拆成了 attached viewer 内部的分页哨兵，而不是 remote presence surface。

但如果正文停在这里，读者还是很容易把另一组相似表面压成一句：

- `/resume` 里能 preview 一条 transcript
- `claude assistant` attach 后也能往上翻 transcript
- 两边最后都喂给了 `Messages`

于是正文就会滑成一句：

- “attached viewer 的 history 基本上就是 `/resume` preview 的联网版。”

这句不稳。

这轮要补的不是：

- “history 还会不会分页”

而是：

- “为什么 `/resume` preview 读的是本地 durable JSONL 快照，而 attached viewer 追的是远端 session events API；两边都长得像 transcript，但不是同一种 history surface”

## 第一性原理

比起直接问：

- “这两边都能看历史，有什么区别？”

更稳的提问是先拆五个更底层的问题：

1. 当前 transcript 来自本地 durable log，还是远端 live/history API？
2. 当前 consumer 是一次性 preview 某份本地快照，还是 attach 后增量补 older page？
3. 当前失败语义是本地 log 读不出来，还是远端 page fetch 失败？
4. 当前延迟模型是 lite->full log hydration，还是 latest->older remote paging？
5. 如果两边只是共享 `Messages` 壳，它们还能被写成同一种 history 面吗？

这五问不先拆开，`/resume` preview 和 attached viewer 很容易被误写成：

- “一个本地版，一个联网版”

而当前源码更接近：

- 两张不同的历史账，只是最后共享同一个 transcript renderer

## 第一层：`/resume` preview 的主语是本地 durable session log

`commands/resume/resume.tsx` 和 `LogSelector.tsx` 把 `/resume` preview 的宿主写得很清楚。

流程是：

1. `/resume` 入口拿到 `logs`
2. 交给 `LogSelector`
3. `viewMode === "preview"` 时渲染 `SessionPreview`

这条线从入口开始回答的就不是：

- “当前远端 session 还能不能继续流出历史”

而是：

- “本地已有的 resumable session log，我要不要在 picker 里先预览它”

所以 `/resume` preview 的第一性原理是：

- local durable snapshot preview

不是：

- remote session history attach

## 第二层：`SessionPreview` 的历史来源是 lite log -> full JSONL transcript hydration

`SessionPreview.tsx` 又把这一点钉死了一层。

它先看：

- `isLiteLog(log)`

如果是 lite log，就：

- `loadFullLog(log).then(setFullLog)`

也就是说 preview 的加载模型是：

### 第一步

- 先拿一个 `messages: []` 的 lite log 作为索引条目

### 第二步

- 用户进入 preview 时，再从本地 session file 补齐完整 transcript

而 `SessionPreview` 最终喂给 `Messages` 的是：

- `displayLog.messages`
- `screen="transcript"`
- `showAllInTranscript={true}`

所以 preview 的数据源非常明确：

- durable JSONL transcript file

它不是：

- 一条联网 attach 的远端事件流

## 第三层：`getSessionFilesLite()` / `loadFullLog()` 证明 `/resume` preview 先是“文件系统快照”，后才是“完整会话”

`sessionStorage.ts` 再把这套两阶段模型拆得更细。

### `getSessionFilesLite(...)`

这里注释写得很直接：

- pure filesystem metadata
- stat only
- no file reads
- `messages: []`

它回答的是：

- 哪些 session file 值得先进入 resume picker

### `loadFullLog(...)`

这里再通过：

- `loadTranscriptFile()`
- `buildConversationChain()`

把本地 JSONL 真正回填成完整 `messages`

这意味着 `/resume` preview 的历史来源模型是：

1. 本地文件系统索引
2. 本地 transcript hydration

这与 attached viewer 的 latest/older remote paging 是两套完全不同的 history provenance。

## 第四层：attached viewer 的 history 来源是远端 session events API，不读本地 transcript 文件

attached viewer 这边的主语从 `main.tsx` 一开始就不同。

assistant attach 分支明确写：

- process streams live events and POSTs messages
- history is lazy-loaded on scroll-up

而真正的历史读取在：

- `useAssistantHistory(...)`

这条 hook 里。

`useAssistantHistory.ts` 会：

- mount 时 `fetchLatestEvents(anchor_to_latest)`
- scroll-up 时 `fetchOlderEvents(before_id)`

而 `assistant/sessionHistory.ts` 又把来源写死了：

- `/v1/sessions/${sessionId}/events`
- `anchor_to_latest`
- `before_id`

也就是说 attached viewer 的 history provenance 是：

- remote session events API

不是：

- 本地 session JSONL

这一步就把“联网版 preview”这种轻写法直接拆掉了。

## 第五层：两边共享 `Messages` 壳，但 authoritative source、延迟模型、失败语义完全不同

最容易误导人的地方就在这里：

- `SessionPreview` 最后也会 render `Messages`
- attached viewer 最后也会 render `Messages`

但共享 renderer 壳，不等于共享历史来源。

### `/resume` preview

authoritative source：

- 本地 durable log

延迟模型：

- lite -> full hydration

失败语义：

- full log 读不到 / session file 不存在 / 本地读取失败

### attached viewer

authoritative source：

- remote session events API

延迟模型：

- latest page first
- older pages on scroll-up

失败语义：

- page fetch 失败
- 顶部 sentinel retry
- live remote attach 仍可能继续工作

所以“都进 `Messages`”这一层只能说明：

- 最后的 transcript renderer 共用

不能说明：

- 历史 surface 本质相同

## 第六层：`SessionPreview` 不能证明 remote session 还活着，attached viewer 也不是 `/resume` preview 的联网版

把前面几层合起来，最稳的结论应该是：

### `/resume` preview

- 证明的是：本地 durable transcript 还能被读回、预览、恢复

### attached viewer history

- 证明的是：远端 session events API 当前还能提供 latest/older pages

这两者在“看起来像 transcript”这件事上会非常相似，

但它们回答的问题不同：

- 一个在看 durable local past
- 一个在 attach remote session 并继续追它的 event history

所以：

- `SessionPreview` 不能证明远端 session 还活着
- attached viewer 也不是 `/resume` preview 的联网版

## 稳定面与灰度面

### 稳定面

- `/resume` preview 走本地 durable log -> full hydration
- attached viewer history 走 remote session events API
- 两边共享 `Messages` 壳，但不共享 history provenance
- preview 的索引模型是 lite log；attached viewer 的索引模型是 latest/older page

### 灰度面

- 远端 events API 后续是否会暴露更厚的 paging metadata
- preview 未来是否会增加更多 lightweight enrichment 字段
- attached viewer 是否会补更强的离线 fallback

## 为什么这页不是 58、118、121、123、145、146、151、153、154

### 不是 58

58 讲的是 attached viewer 的：

- loading
- history
- title ownership

156 只抓：

- history 来源面

不再讲 ownership。

### 不是 118

118 讲的是：

- replay dedup

156 不讲 dedup，只讲两边 transcript 的 authoritative source 不同。

### 不是 121

121 讲的是：

- init banner replay vs live `onInit(...)`

156 不讲 init，只讲 history surface provenance。

### 不是 123

123 讲的是：

- viewerOnly non-owning client

156 只把 attached viewer 当作 remote history pager，不复述 title/timeout/interrupt。

### 不是 145、146、151

这些页讲的是：

- remote bit
- URL
- contract thickness
- session identity

156 不碰 URL、identity、ownership，只讲 transcript history 来源。

### 不是 153

153 讲的是：

- attached viewer 内部 paging sentinel vs remote presence

156 讲的是：

- attached viewer remote history vs `/resume` local preview

是另一层对照。

### 不是 154

154 讲的是：

- assistant discovery / install / chooser / attach 入口链

156 讲的是：

- attach 之后的 remote history 与 `/resume` preview 的分叉

## 苏格拉底式自审

### 问：为什么不能把 attached viewer 写成 `/resume` preview 的联网版？

答：因为前者的 authoritative source 是 `/v1/sessions/{id}/events`，后者的 authoritative source 是本地 durable JSONL transcript。

### 问：为什么一定要把 `getSessionFilesLite()` 和 `loadFullLog()` 拉进来？

答：因为这能证明 preview 自己就有一套“stat 索引 -> 全量 hydrate”的历史加载模型，而不是简单一次性读完整文件。

### 问：为什么一定要把 `Messages` 壳写进来？

答：因为正是共享同一个 transcript renderer，最容易诱发“它们是同一种 history 面”的错觉。

### 问：这页的一句话 thesis 是什么？

答：`claude assistant` attached viewer 的历史面是 `viewerOnly` remote session 的增量补页，而 `/resume` 的 `SessionPreview` 是本地 durable JSONL 的只读快照重建；两者都长得像 transcript，但不是同一种 history surface。

## 结论

对当前源码来说，更准确的写法应该是：

1. `/resume` preview 读的是本地 durable log
2. 它通过 lite log -> full hydration 重建 transcript
3. attached viewer 读的是 remote session events API
4. 它通过 latest page + older page scroll-up 逐步补 history
5. 两边共享 `Messages` renderer，但不共享 authoritative history source

所以：

- `/resume` preview 的本地 transcript 快照不是 attached viewer 的 remote history

## 源码锚点

- `claude-code-source-code/src/commands/resume/resume.tsx`
- `claude-code-source-code/src/components/LogSelector.tsx`
- `claude-code-source-code/src/components/SessionPreview.tsx`
- `claude-code-source-code/src/utils/sessionStorage.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/useAssistantHistory.ts`
- `claude-code-source-code/src/assistant/sessionHistory.ts`
