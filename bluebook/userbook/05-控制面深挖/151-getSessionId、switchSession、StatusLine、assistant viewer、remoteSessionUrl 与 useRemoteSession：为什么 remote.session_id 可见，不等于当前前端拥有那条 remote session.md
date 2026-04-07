# `getSessionId`、`switchSession`、`StatusLine`、`assistant viewer`、`remoteSessionUrl` 与 `useRemoteSession`：为什么 `remote.session_id` 可见，不等于当前前端拥有那条 remote session

## 用户目标

145 已经说明：

- remote bit 为真
- `remoteSessionUrl` 可能缺席

146 又说明：

- `assistant viewer`
- `--remote` TUI

虽然都挂在同一 coarse remote bit 下，但 remote 合同厚度并不一样。

150 刚把 slash 继续拆成了：

- 声明面
- 文本载荷
- runtime 再解释

但正文还差一刀很关键的“可见 session”误读：

- “既然 remote mode 下 `StatusLine` 能拿到 `remote.session_id`，那当前前端应该就拥有那条远端 session。”

这句不稳。

这轮要补的不是：

- “哪里又出现了 `session_id` 字段”

而是：

- “为什么 assistant viewer、remote TUI、footer remote link、`/session` pane 与 `StatusLine.remote.session_id` 分别消费的是不同账本”

## 第一性原理

比起直接问：

- “哪一个 `session_id` 才是真 session？”

更稳的提问是先拆四个更底层的问题：

1. 当前代码读的是本地 bootstrap `sessionId`，还是 remote config `sessionId`？
2. 当前前端关心的是远端会话主权、连接入口 URL，还是状态栏 hook 输入？
3. 当前 remote mode 是 attached viewer，还是本地持有者型的 remote TUI？
4. 如果 assistant viewer 只 `setIsRemoteMode(true)` 而不 `switchSession(...)`，那 `StatusLine` 里的 `remote.session_id` 还能被写成“远端目标 session 的可见证明”吗？

这四问不先拆开，`remote.session_id` 很容易被误写成：

- “当前远端 session 的统一标识”

而源码更接近：

- 不同前端在不同层读到的是不同来源的 session 身份

## 第一层：`StatusLine.remote.session_id` 读的是本地 bootstrap `getSessionId()`

`StatusLine.tsx` 里 remote 块的构造非常直接：

- 只要 `getIsRemoteMode()` 为真
- 就把 `remote.session_id` 设成 `getSessionId()`

这里回答的不是：

- 当前远端 transport config 绑的是哪条 session
- 当前 viewer 实际附着的是哪条 assistant session
- 当前前端是否拥有这条 session 的 title / interrupt / timeout 主权

而只是：

- 本地 bootstrap state 当前的 `sessionId`

所以 `StatusLine.remote.session_id` 首先属于：

- 本地状态栏 hook 输入

不是：

- 远端会话主权证明

而且这层投影在 assistant / Kairos 模式下通常还不会稳定暴露出来。

`StatusLine.tsx` 的 `statusLineShouldDisplay(...)` 会明确因为：

- assistant mode 下 status line 字段反映的是本地 REPL/daemon，而不是远端 agent child

而直接隐藏整条 status line。

所以对 attached viewer 来说，`remote.session_id` 不只是：

- 语义上是 weak local projection

很多时候还会：

- 在可见面上被直接压掉

## 第二层：assistant viewer 只开 remote bit，但不切本地 bootstrap session

`main.tsx` 里的 assistant viewer 分支非常关键。

这里在进入：

- `claude assistant [sessionId]`

这条 attached viewer 路径时，会做三件事：

1. `setKairosActive(true)`
2. `setUserMsgOptIn(true)`
3. `setIsRemoteMode(true)`

然后用：

- `createRemoteSessionConfig(targetSessionId, ..., viewerOnly: true)`

把真正的目标远端 session 放进 `remoteSessionConfig`。

但这里没有做：

- `switchSession(asSessionId(targetSessionId))`

所以 assistant viewer 这条路里同时存在两套 session 身份：

### 本地 bootstrap session

- `getSessionId()`
- 也就是 `StatusLine.remote.session_id` 最终会读到的值

### 远端 target session

- `targetSessionId`
- 也就是 `useRemoteSession` / `RemoteSessionManager` 真正附着和订阅的对象

这就说明在 assistant viewer 里：

- remote bit 为真
- 远端目标 session 也真实存在

但：

- `StatusLine.remote.session_id` 仍不等于 attached 的远端 target session

## 第三层：remote TUI 会显式 `switchSession(...)`，所以它和 viewer 的 session 账本不同

再看 `main.tsx` 里的 `--remote` / CCR 本地 TUI 分支，结构就不一样了。

这里在创建远端 session 后会显式：

- `setIsRemoteMode(true)`
- `switchSession(asSessionId(createdSession.id))`

然后再把：

- `remoteSessionUrl`

写进 `remoteInitialState`。

这意味着 remote TUI 这一支里，本地 bootstrap session 被对齐到了：

- `createdSession.id`

所以在这条路径里：

- `getSessionId()`
- remote config `sessionId`
- 某些 UI 里看到的 remote session 身份

会更接近同一张账。

而 assistant viewer 则不是这样：

- 它远端 attach 了 `targetSessionId`
- 但没有切换本地 bootstrap session

所以 remote TUI 和 viewer 的差异不只是“viewerOnly 更薄”，还包括：

- 两者对 session identity 的本地对齐策略不同

## 第四层：`remoteSessionUrl` 与 `/session` pane 又是另一张连接账

`commands/session/session.tsx` 和 `PromptInputFooterLeftSide.tsx` 再把第三张账本露了出来。

这两处关心的不是：

- `getSessionId()`

而是：

- `remoteSessionUrl`

具体表现很稳定：

### footer remote pill

`PromptInputFooterLeftSide.tsx` 会在 mount 时捕获：

- `remoteSessionUrl`

只有它存在时，footer 才显示：

- `remote` link

### `/session` pane

`commands/session/session.tsx` 也是：

- 没有 `remoteSessionUrl` 就直接提示 “Not in remote mode. Start with `claude --remote`...”

换句话说，`/session` 和 footer remote link 共同消费的是：

- 可打开 / 可分享 / 可二维码化的连接入口账

它们不消费：

- attached viewer 的 `targetSessionId`

所以 assistant viewer 里会出现一种很典型的错位：

- 你确实 attached 到远端 session
- 但本地没有 `remoteSessionUrl`
- `/session` 和 remote pill 也不会给你那套 link / QR affordance

这说明：

- “有远端 session”
- “有本地 remote link / QR 入口”

不是同一张账。

## 第五层：`useRemoteSession` / `RemoteSessionManager` 还握着 viewerOnly 的远端主权账

`useRemoteSession.ts` 把第四张账也拆出来了。

在这个 hook 里，真正的远端主权跟：

- `config.sessionId`
- `config.viewerOnly`

绑得更紧。

几个关键点非常说明问题：

### 远端目标 session

hook 初始化日志、发送消息、标题更新都围绕：

- `config.sessionId`

而不是：

- `getSessionId()`

### viewerOnly 行为收窄

在 viewerOnly 模式下，hook 会显式：

- 不更新 session title
- 不起本地 timeout watchdog
- 不发送 Ctrl+C interrupt

也就是说 assistant viewer 的远端会话虽然存在，

但当前前端并不拥有：

- title ownership
- timeout ownership
- interrupt ownership

这再次说明：

- “我当前附着着一条远端 session”

和：

- “我当前拥有这条 session 的本地主权”

不是同一件事。

## 第六层：因此当前前端至少存在四张 session 身份账

把前面几层合起来，当前源码里至少可以稳定拆出四张账：

### 1. 本地 bootstrap session 账

- `getSessionId()`
- `switchSession(...)`
- `StatusLine.remote.session_id`

### 2. 远端 attach / transport 账

- `createRemoteSessionConfig(...sessionId...)`
- `useRemoteSession`
- `RemoteSessionManager`

### 3. 连接入口账

- `remoteSessionUrl`
- footer remote pill
- `/session` pane

### 4. 远端主权账

- `viewerOnly`
- title update
- timeout
- interrupt

只有在某些路径里，这几张账才会部分对齐。

例如 remote TUI：

- 本地 session 会被 `switchSession(createdSession.id)` 对齐到远端

而 assistant viewer：

- remote bit 为真
- 远端 attach 为真
- 但本地 `getSessionId()`、`remoteSessionUrl`、远端主权仍不会一起对齐

## 稳定面与灰度面

### 稳定面

- `StatusLine.remote.session_id` 直接读 `getSessionId()`
- assistant / Kairos 模式通常会隐藏 `StatusLine`
- assistant viewer 只 `setIsRemoteMode(true)`，不 `switchSession(targetSessionId)`
- remote TUI 会显式 `switchSession(createdSession.id)`
- footer remote pill 与 `/session` pane 依赖 `remoteSessionUrl`
- viewerOnly 会收窄 title / timeout / interrupt 主权

### 灰度面

- 将来 assistant viewer 是否会补某种只读 session identity 对齐
- `StatusLine` hook 输入未来是否会引入单独的 remote target session 字段
- footer / `/session` 是否会为 viewer 路径补独立入口 affordance

## 为什么这页不是 145、146、149

### 不是 145

145 讲的是：

- remote bit 为真但 URL 缺席

150 这页更进一步讲：

- 就算 remote bit 为真，`StatusLine.remote.session_id` 也不一定等于 attached 的远端 target session

焦点已经从：

- link / QR affordance

变成：

- session identity ledger

### 不是 146

146 讲的是：

- assistant viewer 与 remote TUI 的 remote 合同厚度不同

151 只抓其中更窄的一刀：

- session 身份、连接入口与主权不在同一张账上

### 不是 149

149 讲的是：

- remote memory persistence 的双轨账本

151 讲的是：

- remote session identity / ownership 的多账本

两者都在拆“remote 不是一根轴”，但一个是 storage ledger，一个是 session presence ledger。

## 苏格拉底式自审

### 问：为什么不能把 `remote.session_id` 直接写成“远端 session id”？

答：因为 `StatusLine` 里它直接读的是本地 `getSessionId()`，而 assistant viewer 并不会把这个本地 session 切到 `targetSessionId`。

### 问：为什么一定要把 `remoteSessionUrl` 单独拉出来？

答：因为 link / QR / `/session` 这三者共同消费的是连接入口账，不是 transport config `sessionId`。

### 问：为什么一定要把 viewerOnly 写进去？

答：因为不写 viewerOnly，就看不见“附着远端 session”与“拥有远端主权”之间的差别。

### 问：这页的一句话 thesis 是什么？

答：`remote.session_id` 的关键不是有没有这个字段，而是它在不同前端里可能只代表本地 bootstrap session；assistant viewer、remote TUI、footer link 与 `useRemoteSession` 分别消费的是不同的 session 身份账。

## 结论

对当前源码来说，更准确的写法应该是：

1. `StatusLine.remote.session_id` 读的是本地 `getSessionId()`
2. assistant viewer 里这层投影通常还会被 Kairos/assistant mode 隐掉
3. assistant viewer 只开 remote bit，不把本地 session 切到 `targetSessionId`
4. remote TUI 会 `switchSession(createdSession.id)`，所以本地与远端身份更接近对齐
5. footer remote pill 和 `/session` pane 读的是 `remoteSessionUrl`
6. `useRemoteSession` / `viewerOnly` 体现的是远端 transport 与主权账

所以：

- `remote.session_id` 可见，不等于当前前端拥有那条 remote session

## 源码锚点

- `claude-code-source-code/src/components/StatusLine.tsx`
- `claude-code-source-code/src/bootstrap/state.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/commands/session/session.tsx`
- `claude-code-source-code/src/utils/messages/systemInit.ts`
