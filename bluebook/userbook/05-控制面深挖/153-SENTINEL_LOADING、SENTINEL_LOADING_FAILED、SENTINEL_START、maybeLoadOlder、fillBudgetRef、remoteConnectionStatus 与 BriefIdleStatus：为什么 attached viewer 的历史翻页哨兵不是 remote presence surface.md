# `SENTINEL_LOADING`、`SENTINEL_LOADING_FAILED`、`SENTINEL_START`、`maybeLoadOlder`、`fillBudgetRef`、`remoteConnectionStatus` 与 `BriefIdleStatus`：为什么 attached viewer 的历史翻页哨兵不是 remote presence surface

## 用户目标

58 已经拆过：

- attached viewer 的首问加载
- 历史翻页
- title ownership

118 又拆过：

- local echo 去重
- history/live overlap
- replay dedup

121 也拆过：

- history init banner 回放
- live `onInit(...)`
- slash restore

但如果正文停在这里，读者还是很容易把另一组相邻现象压成一句：

- 顶部会出现 `loading older messages…`
- 有时会变成 `failed to load older messages — scroll up to retry`
- 历史到底之后又会出现 `start of session`
- brief mode 里还会出现 `Reconnecting…` / `Disconnected`
- 右边偶尔又会显示 `N in background`

于是正文就会滑成一句看似自然、实际上已经混层的话：

- “这些都只是在 attached viewer 里告诉我远端现在是什么状态。”

这句不稳。

这轮要补的不是：

- “history paging 还怎么加载”

而是：

- “为什么 attached viewer 顶部那组三个历史翻页哨兵，属于 transcript 内部分页状态机；而 `remoteConnectionStatus` / `remoteBackgroundTaskCount` / `BriefIdleStatus` 属于另一张 remote presence 账”

## 第一性原理

比起直接问：

- “attached viewer 的远端状态到底看哪里？”

更稳的提问是先拆五个更底层的问题：

1. 当前提示是在说 transcript 顶部还可不可以继续往旧页翻，还是在说远端 live 连接健不健康？
2. 当前文案的主语是 history page cursor，还是 WebSocket / background task runtime？
3. 当前逻辑处理的是 scroll geometry，还是 remote runtime health？
4. 当前状态机会不会因为再次上滚重试而变化，还是要等远端连接事件改写？
5. 如果一个 surface 不读 `remoteConnectionStatus`，它还能被写成 remote presence 吗？

这五问不先拆开，分页哨兵和 remote presence 很容易被压回：

- “同一种远端状态提示”

## 第一层：`claude assistant` 的 history 从一开始就被设计成 scroll-up lazy load，不是 attach 时的 blocking bootstrap

`main.tsx` 里 assistant attach 分支已经写得很清楚：

- agentic loop 在远端运行
- 当前进程负责 stream live events
- history 在 scroll-up 时由 `useAssistantHistory` lazy-load
- attach 本身不做 blocking fetch

这句话非常关键。

它说明 attached viewer 的 history 这条线从第一性原理上回答的是：

- transcript older pages 什么时候、以什么节奏被补回来

不是：

- 当前远端 session 是否在线

所以顶部哨兵的主语，从入口层开始就不是：

- presence

而是：

- history paging

## 第二层：`useAssistantHistory` 自己就是一条独立的分页状态机

`useAssistantHistory.ts` 把这张账写得非常完整。

几个关键对象分别回答不同问题：

### `cursorRef`

- 记录还有没有 older page
- `undefined` 表示 initial page 还没取
- `null` 表示已经 exhausted

### `fetchLatestEvents(anchor_to_latest)`

- mount 时先拿 newest page

### `fetchOlderEvents(before_id)`

- scroll-up near top 后再拿更旧一页

### `maybeLoadOlder(...)`

- 只根据当前 scrollTop 是否靠近顶部来触发 loading

### `fillBudgetRef`

- 在初次 attach 后，如果内容还没填满 viewport，就继续链式补 older page

这一整套都在回答：

- transcript 顶部还有没有更老内容
- 当前是否正在翻页
- 初次 attach 后是否需要自动把视口填满

它不回答：

- WS 正在 reconnect 吗
- 远端 daemon 断了吗
- 背景任务还剩几个

所以 attached viewer 的 history paging，本来就是一张独立分页状态机。

## 第三层：`SENTINEL_LOADING` / `FAILED` / `START` 是 transcript 顶部哨兵，不是 remote runtime 状态

这三个常量把 153 的核心差异钉得很死：

- `SENTINEL_LOADING`
- `SENTINEL_LOADING_FAILED`
- `SENTINEL_START`

它们都在 `useAssistantHistory.ts` 里被当作：

- `SystemInformationalMessage`
- 以稳定 UUID 方式复用
- 固定插在 transcript 顶部 index 0

它们的具体语义也完全是分页语义：

### `loading older messages…`

- 当前正在 fetch older page

### `failed to load older messages — scroll up to retry`

- 当前 older page fetch 失败
- cursor 保留
- 下次继续上滚可以 retry

### `start of session`

- 已经没有更旧页
- 当前 transcript 顶部到头

这三者共同回答的问题是：

- “还能不能继续往历史更前面翻”

而不是：

- “当前远端 live 连接怎么样”

## 第四层：`anchorRef` / `useLayoutEffect` / `fillBudgetRef` 处理的是滚动几何，不是 presence health

如果只看三个 sentinel 文案，读者还可能误以为：

- 顶部这些提示只是 UI 文案

但 `useAssistantHistory.ts` 后半段的实现说明，它背后其实还有一整条几何/滚动链：

- `anchorRef` 记录 prepend 前高度
- `useLayoutEffect` 在 React commit 后补偿 scrollTop
- `fillBudgetRef` 用于“内容还没填满 viewport 时继续补 older page”

这些对象的存在意义是：

- 保证 prepend older messages 后 viewport 不跳
- 保证 attach 后如果消息太少，继续自动补页直到能够滚动

它们解决的是：

- transcript 内部分页几何

不是：

- 远端 runtime health

所以这张面即使出现：

- loading
- failed
- start of session

也仍然属于：

- paging / scroll surface

不是：

- remote presence surface

## 第五层：remote presence 住在 `remoteConnectionStatus` / `remoteBackgroundTaskCount` 那张账里

另一张账在 `AppStateStore.ts` 和 `useRemoteSession.ts` 里定义得更清楚。

`AppStateStore.ts` 明确把：

- `remoteConnectionStatus`
- `remoteBackgroundTaskCount`

放成 viewer 侧的 runtime state。

`useRemoteSession.ts` 又说明：

- `remoteConnectionStatus` 通过 `setConnStatus(...)` 写入 AppState
- `remoteBackgroundTaskCount` 来自 `task_started` / `task_notification` 的事件流
- 这是 viewer 读到的远端 daemon child 背景任务数，而不是本地 `tasks`

这条链回答的是：

- 当前 live event stream 是否 open / reconnecting / disconnected
- 当前远端子任务还剩多少

它根本不回答：

- transcript older pages 取到哪了
- 顶部 sentinel 现在是 loading / failed / start

所以 presence 账的主语是：

- runtime transport + live remote task count

不是：

- history paging

## 第六层：`BriefIdleStatus` 只是把 presence ledger 投成 brief surface，不会消费 paging sentinel

`Spinner.tsx` 里的 `BriefIdleStatus()` 是最好的 consumer 对照。

它只读：

- `remoteConnectionStatus`
- `remoteBackgroundTaskCount`

然后投成：

- 左边 `Reconnecting…` / `Disconnected`
- 右边 `N in background`

它不读：

- `SENTINEL_LOADING`
- `SENTINEL_LOADING_FAILED`
- `SENTINEL_START`
- `cursorRef`
- `fillBudgetRef`

所以从 consumer 角度也能看清：

- brief presence surface
- attached history paging surface

根本不是同一张面。

## 稳定面与灰度面

### 稳定面

- assistant attach 的 history 是 scroll-up lazy load
- `useAssistantHistory` 自带独立分页状态机
- 三个 sentinel 都属于 transcript 顶部分页哨兵
- `remoteConnectionStatus` / `remoteBackgroundTaskCount` 属于 remote presence 账
- `BriefIdleStatus` 只消费 presence ledger

### 灰度面

- 历史翻页失败后的 retry 文案是否会继续细化
- viewport fill 预算策略是否会继续调参
- brief presence surface 是否会增加更多 runtime 字段

## 为什么这页不是 58、118、121、123、145、146、151

### 不是 58

58 讲的是：

- attached viewer 的 history / loading / title ownership

153 只抓：

- 分页哨兵与 presence surface 的边界

不再重复 ownership。

### 不是 118

118 讲的是：

- replay dedup

153 讲的是：

- 同一 history source 自己的分页状态机

不讲 dedup。

### 不是 121

121 讲的是：

- init banner replay vs live `onInit(...)`

153 讲的是：

- `loading older` / `failed` / `start of session`

不讲 init / restore。

### 不是 123

123 讲的是：

- `viewerOnly` 的 non-owning client 合同

153 只把 `viewerOnly` 当作启用 history paging 的条件，

不再展开 title / timeout / `Ctrl+C`。

### 不是 145、146、151

145、146、151 讲的是：

- remote bit
- URL
- viewerOnly 合同厚度
- session identity / ownership

153 不碰：

- `remoteSessionUrl`
- `switchSession(...)`
- `remote.session_id`

它只讲：

- transcript 顶部分页面

和：

- brief / runtime presence 面

为什么不是同一张账。

## 苏格拉底式自审

### 问：为什么不能把 `loading older messages…` 写成远端正在重连？

答：因为它来自 `useAssistantHistory` 的 older page fetch 状态机，而不是 `remoteConnectionStatus`。

### 问：为什么一定要把 `fillBudgetRef` 和 `anchorRef` 写进来？

答：因为只有把这两个几何对象写出来，读者才会意识到这条线解决的是 transcript paging geometry，而不是 remote runtime health。

### 问：为什么一定要把 `BriefIdleStatus` 拉进来？

答：因为它正好构成最干净的对照 consumer，证明 presence 面只读连接态和背景任务数，不读 paging sentinel。

### 问：这页的一句话 thesis 是什么？

答：`loading older messages… / failed to load older messages / start of session` 是 attached viewer transcript 内部的分页哨兵，不是 `remoteConnectionStatus / remoteBackgroundTaskCount / BriefIdleStatus` 那张 remote presence 账。

## 结论

对当前源码来说，更准确的写法应该是：

1. attached viewer 的 history 从入口层就是 lazy-load transcript paging
2. `useAssistantHistory` 自带独立分页状态机
3. `SENTINEL_LOADING` / `FAILED` / `START` 只回答 older-page paging 问题
4. `anchorRef` / `fillBudgetRef` 处理的是滚动几何，不是 runtime health
5. `remoteConnectionStatus` / `remoteBackgroundTaskCount` 才是 remote presence ledger
6. `BriefIdleStatus` 只是把 presence ledger 投成 brief surface

所以：

- attached viewer 的历史翻页哨兵不是 remote presence surface

## 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/hooks/useAssistantHistory.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/components/Spinner.tsx`
