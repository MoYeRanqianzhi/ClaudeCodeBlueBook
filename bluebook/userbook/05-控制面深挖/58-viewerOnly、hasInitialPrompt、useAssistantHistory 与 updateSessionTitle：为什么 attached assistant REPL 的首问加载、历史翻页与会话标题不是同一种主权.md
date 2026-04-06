# `viewerOnly`、`hasInitialPrompt`、`useAssistantHistory` 与 `updateSessionTitle`：为什么 attached assistant REPL 的首问加载、历史翻页与会话标题不是同一种主权

## 用户目标

不是只知道 attached assistant REPL 里“会显示 Attached to assistant session、有时一进来就在 loading、滚到顶部还能继续翻历史”，而是先分清六类不同对象：

- 哪些是在说这条本地 REPL 是否拥有远端 session 的上层主权。
- 哪些是在说远端首问其实已经在跑，所以本地一进来就带着 loading。
- 哪些是在说 attached viewer 会额外从 Session Events API 补历史，而不是只等 live stream。
- 哪些是在说历史分页怎样从 newest page 往 older page 继续拉。
- 哪些是在说本地 viewer 不拥有 title rewrite。
- 哪些只是在 transcript 里用 sentinel 提示“loading older messages…”或“start of session”。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“attached remote session 体验”：

- `viewerOnly`
- `hasInitialPrompt`
- `isExternalLoading`
- `useAssistantHistory`
- `anchor_to_latest`
- `before_id`
- `updateSessionTitle(...)`
- `loading older messages…`

## 第一性原理

attached assistant REPL 的“我现在看到这条远端 session 的什么”至少沿着五条轴线分化：

1. `Ownership`：当前本地客户端是否拥有 title、interrupt、watchdog 这些上层控制权。
2. `Initial Work State`：当前首问是不是已经在远端启动，导致本地刚进入就该显示 loading。
3. `Transcript Source`：当前消息来自 live stream，还是附着后额外拉回来的历史页。
4. `Paging Direction`：当前是在拿最新页，还是继续向更旧的 `before_id` 游走。
5. `UI Marker`：当前是“这条 session 还在跑”、还是“我正在补历史”、还是“我已经触底到 start of session”。

因此更稳的提问不是：

- “attached viewer 看到的，不就是远端会话本身吗？”

而是：

- “当前这条信息是在说 ownership、首问运行态、历史分页、还是 UI sentinel；本地客户端现在到底是在拥有这条 session，还是只是在补看它的 transcript？”

只要这五条轴线没先拆开，正文就会把 `viewerOnly`、`hasInitialPrompt`、history paging 与 title ownership 写成同一种 attached 体验。

这里也要主动卡住一个边界：

- 这页讲的是 attached assistant REPL 的 transcript / loading / title ownership 合同
- 不重复 21 页对 host / viewer / health check 的会外入口总览
- 不重复 28 页对 remote session client、viewer 与 bridge host 的高层工作流划分
- 不重复 30 页对 `viewerOnly` ownership 与 remote 运行态面的总览
- 不重复 57 页对三种 remote hook 的 transport / reconnect / exit 合同差异

## 第一层：`hasInitialPrompt` 讲的是“远端首问已经在跑”，不是“attached viewer 自己发起了这轮工作”

### 只有创建远端 session 的那条线，才会把首问运行态带进本地 REPL

`main.tsx` 在 `--remote` 分支里会先计算：

- `hasInitialPrompt = remote.length > 0`

随后把它带进：

- `createRemoteSessionConfig(createdSession.id, ..., hasInitialPrompt)`

而 `REPL.tsx` 又会把：

- `remoteSessionConfig?.hasInitialPrompt ?? false`

作为 `isExternalLoading` 的初值。

这说明它回答的问题不是：

- “attached viewer 一进入就天然要 loading”

而是：

- “这条 REPL 进入时，远端是否已经因为首问在忙”

### `assistant [sessionId]` 则显式把它设成 `false`

`main.tsx` 的 assistant attach 分支很直接：

- `createRemoteSessionConfig(targetSessionId, ..., /* hasInitialPrompt */ false, /* viewerOnly */ true)`

这说明 attached viewer 的第一性原理不是：

- “我继承这条 session 现在的全部 owner 工作态”

而是：

- “我附着到一条已有 session；是否 loading，要靠 live stream / state，而不是把首问标志硬继承过来”

只要这一层没拆开，正文就会把“创建者带着首问进入”和“附着者补看一条已有 session”写成同一种 loading。

## 第二层：`useAssistantHistory` 补的是 attached viewer 的 transcript 历史，不是 live stream 的另一种名字

### 它只在 `viewerOnly` 下启用

`useAssistantHistory.ts` 顶部写得很清楚：

- No-op unless `config.viewerOnly`
- on mount 先拿 latest page
- scroll-up near top 再拿 older page

`REPL.tsx` 里也只会在：

- `feature('KAIROS')`
- `remoteSessionConfig`

这条 viewer 路径上把它接进去。

这说明它回答的问题不是：

- 当前 live stream 里又来了一条新消息没有

而是：

- attached viewer 要不要额外把这条 session 之前的 transcript 补回来

### 所以 attached transcript = live stream + history paging，不是单一来源

更准确的理解应是：

- live stream：附着后新来的事件
- assistant history：附着时或向上滚动时补回旧事件

只要这一层没拆开，正文就会把“我现在看到的 transcript”误写成只来自当前 WebSocket。

## 第三层：`anchor_to_latest` 与 `before_id` 是两种不同的历史读取方向

### 初次进入拿的是 newest page，不是从头开始 replay

`sessionHistory.ts` 对 `fetchLatestEvents(...)` 的注释很直白：

- newest page
- via `anchor_to_latest`

也就是说 attached viewer 初次补历史时回答的问题是：

- “先把最近一段对话给我”

而不是：

- “从 session 最开头开始一页页回放”

### 继续向上滚时，才通过 `before_id` 去拿更旧的一页

同一文件里：

- `fetchOlderEvents(ctx, beforeId)`
- 参数语义就是紧挨着 `before_id` 再往前翻

这说明历史分页至少有两层对象：

- 初始 latest anchor
- 继续往旧处翻页的 cursor

只要这一层没拆开，正文就会把“初次补历史”和“继续向上翻页”写成同一种加载。

## 第四层：历史分页的 UI sentinel 不是 ownership signal，也不是运行态 signal

### `loading older messages…` 和 `start of session` 只是在标注 transcript paging 的边界

`useAssistantHistory.ts` 里有三个很明确的 sentinel：

- `loading older messages…`
- `failed to load older messages — scroll up to retry`
- `start of session`

它们回答的问题不是：

- 远端 agent 现在是不是 still running
- 本地 viewer 现在是不是 owner

而是：

- 当前历史分页正在加载、失败，还是已经到会话起点

### 所以滚动提示不应和 loading spinner 混成一种“会话正在忙”

更准确的区分是：

- `isExternalLoading`：远端工作态 / 外部工作还在跑
- history sentinel：旧 transcript 正在补，或已经补到底

只要这一层没拆开，正文就会把“会话在跑”和“我在翻历史”写成同一种 loading。

## 第五层：`updateSessionTitle(...)` 只属于 owner 线，attached viewer 看到标题不等于拥有标题

### 非 `viewerOnly` 且无初始 prompt 时，本地才会接管标题生成

`useRemoteSession.ts` 的条件非常硬：

- `!config.hasInitialPrompt`
- `!config.viewerOnly`

满足时才会：

- `generateSessionTitle(...)`
- `updateSessionTitle(...)`

旁边注释也直接写：

- skip in `viewerOnly` mode
- the remote agent owns the session title

这说明它回答的问题不是：

- attached viewer 当前看见的会话标题是什么

而是：

- 当前本地客户端是否拥有改写这条 session title 的权力

### 所以“能看见标题”与“拥有标题主权”是两件事

更准确的理解应是：

- attached viewer：消费 title
- owner remote session client：在特定条件下重写 title

只要这一层没拆开，正文就会把 title display 和 title ownership 写成同一个能力。

## 第六层：`viewerOnly` 是这页的边界条件，不是这页的主角

### 这页只借它说明 transcript / loading / title ownership 的分叉

`viewerOnly` 在 28/30/57 已经被写过：

- 不接管 title
- 不发 interrupt
- 不启 watchdog reconnect

这页需要保留的只是：

- 为什么 history paging gated on `viewerOnly`
- 为什么 title rewrite skipped in `viewerOnly`
- 为什么 attached viewer 的 loading 不能按 owner 首问逻辑硬继承

这说明本页回答的问题不是：

- `viewerOnly` 究竟是什么模式

而是：

- transcript、loading、title ownership 在 `viewerOnly` 下各自怎样分叉

只要这一层没拆开，正文就会重回 `viewerOnly` 总论，失去新增量。

## 第七层：stable、conditional 与 internal 三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | attached viewer 的 transcript 不是只靠 live stream；初始 latest history、向上翻页历史、title ownership 与首问 loading 是不同对象 |
| 条件公开 | `useAssistantHistory` gated on `viewerOnly` 与 KAIROS；`hasInitialPrompt` 只属于创建远端 session 的 owner 线；`updateSessionTitle(...)` 只在非 viewerOnly 且无初始 prompt 时触发 |
| 内部/实现层 | sentinel UUID、fill-viewport budget、scroll-anchor compensation、具体 sentinel 文本与 paging loop 预算 |

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| attached viewer 一进来 loading = 它自己发起了当前首问 | `hasInitialPrompt` 只描述 owner 创建线的初始工作态 |
| attached transcript = 当前 live stream | attached viewer 还会额外 paging 历史 |
| 初次补历史 = 从会话起点开始 replay | 初始页先走 `anchor_to_latest` |
| 向上滚一次 = 继续等 live stream | 那是在走 `before_id` 的 older page |
| 看见会话标题 = 本地拥有 title rewrite | attached viewer 消费 title，不拥有 title 主权 |
| `loading older messages…` = 远端 agent 仍在忙 | 这是历史分页 sentinel，不是运行态 signal |

## 七个检查问题

- 当前说的是 owner 首问工作态，还是 attached viewer 的补看体验？
- 当前 transcript 来自 live stream，还是 history API？
- 这是 newest page，还是继续往旧处翻页？
- 当前 UI signal 是远端仍在跑，还是历史正在补？
- 本地现在拥有 title rewrite，还是只在消费远端已有标题？
- 我是不是又把 `viewerOnly` 总论带回来了？
- 我是不是又把 attached transcript 写成单一来源了？

## 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/hooks/useAssistantHistory.ts`
- `claude-code-source-code/src/assistant/sessionHistory.ts`
