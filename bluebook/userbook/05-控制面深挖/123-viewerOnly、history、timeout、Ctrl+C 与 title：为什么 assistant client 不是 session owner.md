# `viewerOnly`、history、timeout、`Ctrl+C` 与 title：为什么 assistant client 不是 session owner

## 用户目标

118 已经把 viewerOnly 一侧的 replay dedup 拆成：

- 本地 echo 去重
- history attach overlap
- transcript append

122 又把 remote recovery 拆成：

- timeout watchdog
- warning transcript
- reconnecting state
- disconnected terminal release

继续往下读时，读者又很容易把 `viewerOnly` 的几处条件判断压成一句：

- `claude assistant` 走 `viewerOnly`
- `viewerOnly` 还能继续发消息
- 但它会单独开 history
- 又会跳过 timeout
- 还会跳过 `Ctrl+C` interrupt
- 也不会更新 session title

于是正文就会滑成两句都不稳的话：

- “viewerOnly 就是纯只读 viewer。”
- “viewerOnly 只是同一条 remote session 路径上顺手关掉几个按钮。”

从当前源码看，这两句都不成立。

这里至少有四件不同的事：

1. content plane 能不能继续发 prompt
2. history ledger 归谁提供
3. session-control loop 归谁拥有
4. 本地 viewer 是否有权判断 stuck、发 interrupt、改 title

它们都挂在 `viewerOnly` 这个条件上，但不是同一种 viewer 特判。

## 第一性原理

更稳的提问不是：

- “viewerOnly 到底是不是只读？”

而是先问五个更底层的问题：

1. 当前客户端有没有继续往会话里提交 content 的能力？
2. 当前客户端有没有 ownership 去改 session title？
3. 当前客户端有没有 authority 去判断远端 session stuck 了？
4. 当前客户端有没有 authority 去用 `Ctrl+C` interrupt 远端 agent？
5. 当前 history 是本地 transcript 的副本，还是远端 assistant session 的账本？

只要这五轴先拆开，`viewerOnly` 就不会再被写成一个模糊的“弱化版 remote mode”。

## 第一层：`viewerOnly` 在入口层就被决定，不是 adapter 末端补丁

`main.tsx` 里，`claude assistant` 路径会直接：

- `createRemoteSessionConfig(..., /* viewerOnly */ true)`

而普通 `--remote` 创建的 remote TUI 则是：

- `createRemoteSessionConfig(..., hasInitialPrompt)`
- 默认 `viewerOnly = false`

这说明 `viewerOnly` 首先回答的是：

- 当前接入的是哪一种 remote session client contract

不是：

- 后面某个 adapter 临时多塞的显示开关

所以这一页的主语首先应该是：

- entry-level session contract

而不是：

- render-time viewer tweak

## 第二层：`viewerOnly` 仍然能 `sendMessage`，所以它不等于“完全不能交互”

`REPL.tsx` 在 remote mode 下，会统一走：

- `activeRemote.sendMessage(remoteContent, { uuid })`

这里没有把 `viewerOnly` 排除在外。

代码顺序也很直接：

1. 本地先 `createUserMessage(...)`
2. `setMessages(prev => [...prev, userMessage])`
3. 再把同样内容送进 `activeRemote.sendMessage(...)`

这说明 `viewerOnly` 客户端仍然能：

- 在 content plane 继续提交 prompt

所以它不能稳地写成：

- “纯只读 viewer”

更准确地说，从代码行为推断，`viewerOnly` 更像：

- non-owning interactive client

这里要特别小心。

`RemoteSessionConfig` 的注释把它叫做：

- pure viewer

但同一套源码行为又表明：

- 它仍然能继续 send prompt

因此更稳的写法不是机械复述注释，而是明确补一句：

- 这里的 pure viewer，更接近“不拥有 session-control 主权”，而不等于“完全不能输入”

这是从入口配置和 REPL 提交链共同推出来的行为判断。

## 第三层：history 只在 `viewerOnly` 打开，说明它还切换了账本来源

`useAssistantHistory.ts` 的注释写得很直白：

- gated on `viewerOnly`
- non-viewer sessions have no remote history to page

而 `REPL.tsx` 也只在：

- `feature('KAIROS')`
- 且 `config.viewerOnly === true`

时调用 `useAssistantHistory(...)`

这意味着 `viewerOnly` 不只是：

- 同一条 live WS 路径上的显示差异

它还切换了：

- history ledger 的来源

`useAssistantHistory(...)` 会：

- `fetchLatestEvents(anchor_to_latest)`
- 再在滚动向上时 `fetchOlderEvents(...)`

所以这一层回答的是：

- 这个 client 附着在一个已有的 assistant session 上，并消费它的远端 history 账本

不是：

- 本地 transcript 只是多开了一个 replay 开关

这也是为什么 118 讲的是 replay dedup，

而 123 讲的是：

- ownership / ledger contract

问题域已经换了。

## 第四层：title update 被跳过，说明 send content 不等于 own session metadata

`useRemoteSession.sendMessage(...)` 在发送成功后，会尝试更新 session title。

但这个分支明确要求：

- `!config.viewerOnly`

注释也直接写了：

- viewerOnly mode 下 remote agent owns the session title

这说明：

- 能继续发 prompt

不等于：

- 有权改 session metadata

也就是说 content plane 和 metadata plane 不是同一张主权图。

如果把这层压平，正文就会变成：

- “既然这个 client 还能发消息，它当然也该拥有 title 更新权。”

这正是源码没有做的事。

## 第五层：timeout watchdog 被跳过，说明 stuck judgement 也不归本地 viewer

`useRemoteSession.sendMessage(...)` 里启动 watchdog 的逻辑同样要求：

- `!config?.viewerOnly`

注释解释得非常具体：

- remote agent may be idle-shut
- respawn can take longer than 60s

这说明本地 viewer 这一层没有资格把：

- `RESPONSE_TIMEOUT_MS = 60000`
- `COMPACTION_TIMEOUT_MS = 180000`

直接当成自己的 liveness contract。

这里还要再补一句，避免把结论写过头。

`viewerOnly` 跳过的是：

- owner-side timeout watchdog
- warning transcript
- timeout 触发后的 repair reconnect

它不是：

- 完全没有 shared transport reconnect

底层 `SessionsWebSocket` 仍然会在 close/backoff 路径里自行 schedule reconnect。

所以更准确的写法应是：

- `viewerOnly` 不共享同一条 host-side timeout repair contract

而不是：

- `viewerOnly` 完全没有 reconnect / recovery

换句话说，122 里那套：

- watchdog armed
- warning transcript
- reconnect attempt
- reconnecting state
- disconnected release

成立的前提之一正是：

- 当前 client 愿意承担 host-side stuck judgement

而 `viewerOnly` 当前显式不承担。

所以这两页的关系不该写成：

- 122 是 remote session 通用规则，123 只是补个例外

更准确的关系是：

- 122 讲的是 owner-side recovery contract
- 123 讲的是为什么 `viewerOnly` client 从一开始就不进入同一条 owner-side liveness contract

## 第六层：`Ctrl+C` interrupt 被跳过，说明 local cancel 不等于 remote cancel

`REPL.tsx` 在 remote mode 下按 `Esc` / `Ctrl+C`，会走：

- `activeRemote.cancelRequest()`

但 `useRemoteSession.cancelRequest()` 里真正发：

- `managerRef.current?.cancelSession()`

同样要求：

- `!config?.viewerOnly`

而 `RemoteSessionConfig` 的注释也已经把这点钉死：

- `Ctrl+C/Escape do NOT send interrupt to the remote agent`

所以 `viewerOnly` 路径里，本地 cancel 更接近：

- viewer 自己结束本地 loading / 交互等待

不是：

- 远端 agent turn 被这个 client 正式 interrupt 掉了

这一步和上面的 title / timeout 一起说明：

- `viewerOnly` 不是没有交互
- 而是没有 session-control 主权

## 第七层：`viewerOnly` 改变的是 control plane，而不是 content plane

如果把前面几层压成一张图，会发现最稳的拆法其实是两层：

### content plane

- 本地可以 `createUserMessage(...)`
- 仍然可以 `activeRemote.sendMessage(...)`
- live WS 仍会回消息
- history 仍会被拉下来补进 transcript

### control plane

- history 账本从远端 assistant session 提供
- session title 归 remote agent 拥有
- stuck timeout 不由本地 viewer 判断
- `Ctrl+C` 不由本地 viewer 向远端发 interrupt

所以这一页最核心的一句应是：

- `viewerOnly` client 仍然可以交互，但不拥有 session-control loop

而不是：

- `viewerOnly` client 什么都不能做

也不是：

- 它只是 UI 上少了几个按钮

## 第八层：为什么它不是 118、119、122 的重复页

### 它不是 118

118 讲的是：

- replay dedup

也就是：

- 本地 echo
- history/live overlap
- transcript append

谁和谁会重复、重复后怎么掉。

123 讲的是：

- 谁拥有 history、timeout、interrupt 与 title 的主权

问题已经从 dedup policy 换成 ownership contract。

### 它不是 119

119 讲的是 direct connect 里：

- `setIsLoading(true/false)`

为什么不是同一种 loading lifecycle。

123 里虽然会碰到：

- local cancel / local loading false

但主语不是 loading bool，

而是：

- 这个 client 有没有 remote session owner 权限

### 它不是 122

122 讲的是 owner-side recovery lifecycle 内部的分层：

- warning 不是 state
- reconnecting 不是 disconnected

123 则更靠前一步：

- 为什么 `viewerOnly` client 根本不共享同一条 owner-side liveness contract

一个讲：

- 同一条 owner contract 内部别混写

一个讲：

- 哪些 client 一开始就不在这条 owner contract 里

## 第九层：最常见的假等式

### 误判一：`viewerOnly` 就等于完全不能发消息

错在漏掉：

- `activeRemote.sendMessage(...)` 仍然可走

### 误判二：能发消息就说明它拥有同样的 session control 权

错在漏掉：

- title update、timeout watchdog、`Ctrl+C` interrupt 都显式跳过

### 误判三：history gate、timeout skip、interrupt skip、title skip 只是四个松散 viewer 特判

错在漏掉：

- 它们更像同一条 ownership contract 的不同投影

### 误判四：既然还是同一个 remote session / WS，就该共享同一条 liveness contract

错在漏掉：

- `viewerOnly` 明确不承担 stuck judgement

### 误判五：skip timeout 就说明 `viewerOnly` 完全没有 reconnect

错在漏掉：

- 被切掉的是 owner-side watchdog repair
- shared transport reconnect 仍可能独立发生

## 第十层：stable / conditional / internal

### 稳定可见

- `claude assistant` 入口会创建 `viewerOnly = true` 的 remote session config
- `viewerOnly` client 仍然能走 remote `sendMessage(...)`
- `viewerOnly` client 当前不会更新 session title
- `viewerOnly` client 当前不会启动本地 timeout watchdog
- `viewerOnly` client 当前不会向远端发送 `Ctrl+C` interrupt
- `viewerOnly` client 当前独占 assistant history paging 路径
- `viewerOnly` client 不共享 owner-side timeout repair，但不等于 shared transport reconnect 消失

### 条件公开

- history paging 还受 `feature('KAIROS')` gating
- 122 那套 warning / reconnecting / disconnected 的 recovery UX 主要属于 non-viewer owner 路径
- assistant path 同时还会带上 `isBriefOnly`、`replBridgeEnabled: false` 等初始状态，但这不是本页主语

### 内部 / 灰度层

- remote daemon 的 idle-shut / respawn 策略
- 为什么它可能超过 60s 才恢复
- 未来 viewerOnly 是否会被赋予更多 session-control 权限
- `pure viewer` 这句注释未来是否会继续维持，而不去细分成更精确的 non-owning client 术语

## 第十一层：苏格拉底式自审

### 问：我是不是把 no-input 和 no-ownership 混成一件事了？

答：如果我写成“viewerOnly 不能发消息”，就把 content plane 写错了。

### 问：我是不是把能 send prompt 错写成也能改 title、发 interrupt、判定 timeout？

答：如果是，就把 content plane 和 control plane 混写了。

### 问：我是不是把 122 的 watchdog/recovery 直接推广到所有 remote client？

答：如果是，就漏掉了 `viewerOnly` 的 skip timeout 条件。

### 问：我是不是把 history gate 当成 transcript 小细节，而不是 entry-level session contract？

答：如果是，就没看到 `useAssistantHistory` 对 `viewerOnly` 的硬门槛。

## 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/useAssistantHistory.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
