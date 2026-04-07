# `warning`、连接态、force reconnect 与 `viewerOnly`：为什么 recovery signer 不是同一种恢复证明

## 用户目标

122 已经把 remote session recovery lifecycle 拆成：

- timeout watchdog
- warning transcript
- reconnecting state
- disconnected release

123 又把 `viewerOnly` 拆成：

- 仍可 send prompt
- 但不拥有 title / timeout / interrupt 这组三个 session-control 主权

继续往下读时，读者仍然很容易把 recovery 一侧的可见信号压成一句：

- transcript 出现了 warning
- brief 行里出现了 `Reconnecting…`
- 代码里调用了 `reconnect()`
- 某些模式下又没看到 warning

于是正文就会滑成几句都不稳的话：

- “系统已经进入恢复中。”
- “warning 就是 reconnecting。”
- “没看到 warning，就说明没有 recovery。”

从当前源码看，这三句都不成立。

这里至少有五种不同 signer：

1. owner-side watchdog prompt
2. durable connection state
3. transport action edge
4. brief projection surface
5. mode-conditioned absence

它们都和 recovery 有关，但不是同一种恢复证明。

## 第一性原理

更稳的提问不是：

- “系统现在是不是在恢复？”

而是先问五个更底层的问题：

1. 当前这个信号是谁写出来的？
2. 当前它是 durable state、transcript prompt、transport action，还是 UI projection？
3. 当前它能签的结论上限是什么？
4. 当前没看到它，是 signer 缺席，还是状态真的不存在？
5. `viewerOnly` 切掉的是 recovery 本身，还是只切掉某个 signer？

只要这五轴先拆开，`warning == reconnecting == recovering` 这类假等式就不会再成立。

## 第一层：`warning` 只能签 owner-side watchdog fired，不能签 durable reconnecting

`useRemoteSession.sendMessage(...)` 在：

- `sendMessage` 成功之后
- 且 `!config?.viewerOnly`

才会启动 timeout watchdog。

超时回调做的事情也非常具体：

1. `createSystemMessage(..., 'warning')`
2. `setMessages(prev => [...prev, warningMessage])`
3. `manager.reconnect()`

所以这条 warning 最多只能签出一句：

- 当前 owner-side client 认为这一轮 turn 长时间没消息，正在尝试 repair reconnect

它不能签出：

- durable `remoteConnectionStatus='reconnecting'`

更不能签出：

- “恢复已经生效”

因为它首先只是：

- transcript prompt

不是：

- authoritative state

## 第二层：`remoteConnectionStatus` 才是 remote session 这侧的 durable authority

`AppStateStore.ts` 对 `remoteConnectionStatus` 的注释写得很清楚：

- `connected` = live event stream is open
- `reconnecting` = transient WS drop, backoff in progress
- `disconnected` = permanent close or reconnects exhausted

而 `useRemoteSession.ts` 里真正写这个字段的，只有：

- `onConnected()`
- `onReconnecting()`
- `onDisconnected()`

更严格一点说，真正更靠近 raw authority 的，是：

- `SessionsWebSocket` 的 transport state machine

而 `remoteConnectionStatus` 是它写进共享 AppState 之后的：

- shared projection

但在 userbook 这一层，`remoteConnectionStatus` 仍然是比 warning / brief 更接近 authority 的 signer。

它回答的是：

- 当前 remote session WS lifecycle 的 durable authority 是什么

它不是：

- transcript 里最后一条 warning 文案

也不是：

- 某个 UI 组件临时显示出来的红字

所以如果一定要找“哪个 signer 最接近 recovery 真相”，当前源码里更接近的不是 warning，而是：

- `remoteConnectionStatus`

但它签的也只是：

- WS lifecycle

不是：

- 远端 worker / agent 已经彻底恢复好了

## 第三层：`force reconnect` 是 action edge，不是 state signer

122 已经讲过：

- `manager.reconnect()` 不是 `reconnecting` state 本体

这一页再往前压一层，会发现：

- `reconnect()` 甚至也不是 recovery proof

`SessionsWebSocket.ts` 里有两条不同路径：

### `scheduleReconnect(...)`

- 会先 `callbacks.onReconnecting?.()`
- 再进入 backoff reconnect

### `reconnect()`

- 只是 `close()`
- 重置 retry 计数
- 500ms 后重新 `connect()`

这意味着：

- transport action edge

和：

- durable reconnecting state

并不自动同构。

更具体地说，warning timeout 之后走的是：

- `manager.reconnect()`
- `SessionsWebSocket.reconnect()`

而 `onReconnecting()` 对应的却主要是：

- `scheduleReconnect(...)`

那条 close/backoff 路径。

这里最关键的一点是：

- `scheduleReconnect(...)` 是当前源码里唯一会显式触发 `onReconnecting()` 的路径

而 timeout warning 后走的：

- `manager.reconnect()`
- `SessionsWebSocket.reconnect()`

当前实现会先 `close()` 把内部状态设成 `closed`，

后续 close event 再进 `handleClose(...)` 时会直接 early-return。

所以更稳的表述应是：

- timeout warning 之后发生了 force reconnect action

但这并不自动保证：

- durable `remoteConnectionStatus` 已经被写成 `reconnecting`
- brief UI 一定马上出现 `Reconnecting…`

所以最危险的误判之一就是：

- “既然 warning 之后调用了 reconnect()，那当前 durable state 一定已经是 reconnecting。”

源码并没有给你这个结论上限。

## 第四层：`BriefSpinner` / `BriefIdleStatus` 是 projection，不是 authority

`Spinner.tsx` 里 brief 相关 UI 很直白：

- 左侧红字只消费 `remoteConnectionStatus`
- 右侧又拼上 `remoteBackgroundTaskCount`

所以 `BriefSpinner` 和 `BriefIdleStatus` 更像：

- 对 durable state 的摘要投影

不是：

- 自己在生成 recovery 真相

它们最多只能签出一句：

- 当前 brief surface 正在把 `remoteConnectionStatus` 和 background count 组合显示出来

它们不能签出：

- warning 是否出现过
- reconnect 动作是不是由 timeout 触发的
- 这次 reconnect 到底是 owner-side repair，还是 shared transport close/backoff

也就是说：

- projection surface

不等于：

- authority surface

## 第五层：`viewerOnly` 切掉的是 signer，不是把 recovery 整条链删掉

123 已经讲过：

- `viewerOnly` 不共享 title / timeout / interrupt 这组 owner-side control

这里再进一步，就要防止另一个过度推论：

- “既然 `viewerOnly` 没有 timeout warning，那它就没有 reconnect / recovery。”

这同样不成立。

`viewerOnly` 切掉的是：

- owner-side timeout watchdog
- owner-side warning transcript
- owner-side timeout 触发后的 repair reconnect

它切掉的不是：

- shared transport reconnect 本身

底层 `SessionsWebSocket` 仍然会在 close/backoff 路径里：

- `scheduleReconnect(...)`
- 触发 `onReconnecting()`

所以更准确的写法应是：

- `viewerOnly` 切掉的是一个 signer

不是：

- recovery 这个问题域整体消失

这也意味着：

- 没看到 warning

最多只能说明：

- 当前没有 owner-side watchdog signer 发声

不能直接说明：

- 当前没有 reconnect / recovery

## 第六层：absence 不是 opposite，尤其在 attached viewer 和 remote pill 上

这一步最容易被忽略。

因为系统里还有另一类很像“证明”的东西：

- footer 左侧 `remote` pill

`PromptInputFooterLeftSide.tsx` 明确写了：

- `remoteSessionUrl` 是从 initialState 一次性读出来的
- 只有它存在时才显示 `remote` link

而 `main.tsx` 里：

- `--remote` owner path 会设置 `remoteSessionUrl`
- `claude assistant` attached viewer 路径不会设置它

所以你会得到一个很反直觉、但很关键的事实：

- attached viewer 可能真的有 remote session
- 真的有 `remoteConnectionStatus`
- 甚至真的出现 `Reconnecting…`

但：

- 没有 `remote` pill

这说明 absence 的语义要再拆一层：

- 有时是 signer 没挂上
- 有时是当前模式不暴露这张面
- 并不总是“状态不存在”

所以这页不能只讲 recovery 出现时的语义，

还必须补一句：

- lack of surface is not opposite proof

## 第七层：brief 挂载条件也说明 projection 的缺席不等于 authority 消失

`REPL.tsx` 里 `BriefIdleStatus` 的挂载条件非常强：

- `!showSpinner`
- `!isLoading`
- `!userInputOnProcessing`
- `!hasRunningTeammates`
- `isBriefOnly`
- `!viewedAgentTask`

这意味着即便 `remoteConnectionStatus` 已经是：

- `reconnecting`
- 或 `disconnected`

brief 投影也并不保证一定在当前帧出现。

所以：

- 没看到 brief 行

不能直接签出：

- 当前没有 reconnecting / disconnected durable state

这一层继续证明：

- projection absence

不等于：

- authority absence

## 第八层：bridge surface 不是 remote recovery signer 家族的一员

这页虽然主语是 remote session recovery signer，

但必须顺手把 bridge 排除出去。

原因很简单：

- `remoteConnectionStatus` / `remoteBackgroundTaskCount` 属于 remote session family
- `replBridgeConnected` / `replBridgeSessionActive` / `replBridgeReconnecting` / `replBridgeError` 属于 bridge family

`PromptInputFooter.tsx` 里的 bridge indicator 也很明确：

- failed state 不走 footer pill
- implicit bridge 只在 reconnecting 时才显示

所以 bridge pill / dialog / notification 的缺席与出现，

不能拿来给 remote session recovery 签字。

如果把它们混在一起，正文就会把：

- remote session authority

和：

- bridge host authority

重新压平。

## 第九层：为什么它不是 122、123 的重复页

### 它不是 122

122 讲的是：

- 同一条 owner-side recovery lifecycle 内部，warning、reconnecting、disconnected 不是同一种状态

124 则是：

- 哪些 surface 有资格给 recovery 签字
- 哪些 surface 只是 prompt / action / projection / absence

一个讲：

- lifecycle 内部分层

一个讲：

- signer 的签字权边界

### 它不是 123

123 讲的是：

- `viewerOnly` 为什么是 non-owning client

124 里虽然仍会用到 `viewerOnly`，

但主语已经换成：

- `viewerOnly` 的缺席语义会怎样影响 recovery signer

一个讲：

- ownership contract

一个讲：

- proof contract

## 第十层：最常见的假等式

### 误判一：warning 出现就说明已经 reconnecting

错在漏掉：

- warning 是 prompt signer
- `remoteConnectionStatus` 才是 durable authority

### 误判二：调用了 `reconnect()` 就说明 recovery 状态已经成立

错在漏掉：

- `reconnect()` 是 transport action edge
- 它不等于 durable state signer

### 误判三：brief 里看到 `Reconnecting…` 就说明 recovery 的全部真相都在这一行里

错在漏掉：

- brief 只是 projection
- 它吃的是 `remoteConnectionStatus` + background count

### 误判四：没看到 warning，就说明当前没有 recovery

错在漏掉：

- `viewerOnly` 会让 owner-side watchdog signer 缺席
- shared transport reconnect 仍可能存在

### 误判五：没看到 `remote` pill，就说明没有 remote session

错在漏掉：

- attached viewer 路径本来就不设置 `remoteSessionUrl`

### 误判六：bridge 的 reconnecting / failed surface 能直接给 remote session recovery 签字

错在漏掉：

- 它们属于不同状态家族

## 第十一层：stable / conditional / internal

### 稳定可见

- `warning` 当前是 owner-side timeout prompt，不是 durable state
- `remoteConnectionStatus` 当前是 remote session WS lifecycle 的 shared authority projection
- `BriefSpinner` / `BriefIdleStatus` 当前是投影层，不是 authority
- `viewerOnly` 当前会切掉 owner-side warning signer，但不等于 shared transport reconnect 消失
- bridge surface 与 remote session surface 当前是两套独立 family

### 条件公开

- warning 只在 `sendMessage()` 成功后且 `!viewerOnly` 的 timeout 路径出现
- `onReconnecting()` 当前由 close/backoff 的 `scheduleReconnect(...)` 路径触发，不由每一次 force reconnect 自动作保
- `BriefIdleStatus` 只在 brief-only / idle / 无 teammate 等条件同时满足时挂载
- `remote` pill 只在 `remoteSessionUrl` 被设置的 owner path 出现
- bridge pill 还受 explicit / reconnecting 等条件影响

### 内部 / 灰度层

- `60s / 180s` timeout 常量
- `4001` retry budget
- `reconnect()` 的 500ms delay
- warning 文案本身
- timeout warning 后 UI 是否同步投成 `Reconnecting…`
- 哪些 projection 当前恰好在同一帧可见

这些都更适合当：

- 合同解释证据

而不是：

- 给读者承诺的稳定证明

## 第十二层：苏格拉底式自审

### 问：我现在写的是 authority、prompt、action，还是 projection？

答：如果答不出来，就说明又把 signer 压平了。

### 问：我是不是把某个 UI surface 的出现，当成了 recovery 真相本身？

答：如果是，就把 signer ceiling 写过头了。

### 问：我是不是把 “没看到它” 直接写成 “状态不存在”？

答：如果是，就把 absence 和 opposite 混成了一件事。

### 问：我是不是把 `viewerOnly` 的 skip timeout 写成了“没有 reconnect”？

答：如果是，就漏掉了 shared transport reconnect。

### 问：我是不是把 bridge surface 拿来给 remote session 签字了？

答：如果是，就混了两套状态家族。

## 源码锚点

- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/remote/SessionsWebSocket.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/components/Spinner.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooter.tsx`
- `claude-code-source-code/src/main.tsx`
