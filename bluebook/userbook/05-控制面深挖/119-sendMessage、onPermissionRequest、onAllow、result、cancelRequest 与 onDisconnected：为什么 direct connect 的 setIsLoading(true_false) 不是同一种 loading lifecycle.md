# `sendMessage`、`onPermissionRequest`、`onAllow`、`result`、`cancelRequest` 与 `onDisconnected`：为什么 direct connect 的 `setIsLoading(true/false)` 不是同一种 loading lifecycle

## 用户目标

118 已经把 viewerOnly replay 里的：

- visibility policy
- local echo dedup
- history/live overlap
- source-blind sink

拆成了四层。

再往下读时，读者又很容易把另一个更贴近交互体感的概念压平：

- `sendMessage(...)` 时 `setIsLoading(true)`
- 收到 permission request 时 `setIsLoading(false)`
- 用户 `onAllow(...)` 后又 `setIsLoading(true)`
- 收到 `result` 时 `setIsLoading(false)`
- 用户 `cancelRequest()` 时 `setIsLoading(false)`
- 断线 `onDisconnected()` 时也 `setIsLoading(false)`

于是正文就会滑成一句非常顺口、但不对的话：

- “loading 就是一条从 true 到 false 的单线生命周期，只是不同位置在改同一个布尔值。”

从当前源码看，这也不成立。

这里至少有五种不同语义：

1. 请求发起后的 active waiting
2. 因远端 ask 而暂停的 approval pause
3. 审批通过后的 resumed waiting
4. 结果到达后的 turn-end release
5. 用户取消或连接断开的 abort/teardown release

它们都落在同一个 `setIsLoading(true/false)` 上，但不是同一种 loading lifecycle。

## 第一性原理

更稳的提问不是：

- “什么时候把 loading 设成 true / false？”

而是先问五个更底层的问题：

1. 这次 `true` 表示 request start，还是 pause 后 resume？
2. 这次 `false` 表示正常收口，还是临时停表，还是异常/中断？
3. 当前 flag 在描述 turn lifecycle，还是仅仅描述 UI 是否还在等待远端继续推进？
4. 当前状态变更有没有新的 transcript / modal / shutdown side effect？
5. 当前路径是 direct connect 专有偶然性，还是 shell-like remote host 的共同模式？

只要这五轴先拆开，后面几次 `setIsLoading(...)` 就不会再被写成同一条单线状态机。

## 第一层：`sendMessage(...) -> setIsLoading(true)` 回答的是 request start

`useDirectConnect.ts` 里的 `sendMessage(...)` 非常直接：

1. 先取 `managerRef.current`
2. 没有 manager 就直接 `return false`
3. 有 manager 才 `setIsLoading(true)`
4. 然后 `return manager.sendMessage(content)`

这说明这里的 `true` 回答的是：

- “本地刚把一个新的远端请求发出去，现在开始等待远端继续推进”

不是：

- “系统处在某种笼统的 loading 总态”

更不是：

- “上一轮审批结束后自动恢复”

这是 request start edge。

## 第二层：`onPermissionRequest(...) -> setIsLoading(false)` 回答的是 approval pause

`onPermissionRequest(...)` 到来时，direct connect 会：

- 包一层 `ToolUseConfirm`
- `setToolUseConfirmQueue(...)`
- 然后立刻 `setIsLoading(false)`

这里的 false 不是：

- turn 完成了

因为远端实际上只是：

- 暂停在一个需要本地审批的 ask 上

这一步在回答的是：

- “当前不再继续等远端自己推进；控制权暂时切回本地审批 UI”

所以这是：

- pause false

不是：

- completion false

更不是：

- transport teardown false

## 第三层：`onAllow(...) -> setIsLoading(true)` 回答的是 resume，不是新的 request start

同样在 permission flow 里，`onAllow(updatedInput)` 会：

- `respondToPermissionRequest(..., { behavior: 'allow' })`
- 清掉 queue 里的 ask
- 然后 `setIsLoading(true)`

这和 `sendMessage(...)` 虽然都把 loading 设成 true，但语义不同。

`sendMessage(true)` 的主语是：

- 新请求启动

`onAllow(true)` 的主语则是：

- 被 approval pause 挂起的远端执行继续跑

所以这一步是：

- resumed waiting

不是：

- initial request dispatch

这也是为什么如果把所有 `true` 都写成“开始 loading”，正文会失真。

## 第四层：`result -> setIsLoading(false)` 回答的是 turn-end release

`onMessage` 一进来就会先做：

- `if (isSessionEndMessage(sdkMessage)) setIsLoading(false)`

而 `isSessionEndMessage(...)` 当前只按：

- `msg.type === 'result'`

判断。

所以这里的 false 回答的是：

- “这一轮已经到 `result` 收口了，当前不再等待远端继续把这次 turn 往前推”

这一步和 permission pause 的 false 不同。

因为 permission pause 是：

- 远端仍未完成，只是等待本地批准

而 result false 是：

- 这一轮已经到达结果边界

这就是：

- turn-end false

不是：

- pause false

## 第五层：`cancelRequest()` 与 `onDisconnected()` 的 false 又不是同一类

`cancelRequest()` 的实现很短：

- `managerRef.current?.sendInterrupt()`
- `setIsLoading(false)`

这里的 false 回答的是：

- 本地用户主动打断，不再等待当前远端继续推进

这是：

- user-abort false

而 `onDisconnected()` 里则是：

- 打日志
- 区分从未连接成功 / 连接后断开
- 输出 stderr 文案
- `gracefulShutdown(1)`
- `setIsLoading(false)`

这里的 false 回答的是：

- transport teardown / session death

不是：

- user-abort

也不是：

- turn-end success/error close

所以 even within false:

- cancel false
- disconnect false

也不是同一种 lifecycle event。

## 第六层：`onAbort()` / `onReject()` 不再写 loading，恰好说明 pause 已经先发生

permission flow 里最容易被忽略的一点是：

- `onAbort()` 不会再 `setIsLoading(false)`
- `onReject()` 也不会再 `setIsLoading(false)`

这不是漏写。

恰恰相反，这说明设计者默认：

- `onPermissionRequest(...)` 到来时 loading 已经先被关掉

也就是说：

- “进入 ask 态” 这个 pause edge

被定位在：

- request 到达时

而不是：

- 用户后来点拒绝/中止时

这进一步证明 loading false 不是单线终点，而是不同 edge 的语义选择。

## 第七层：SSH sibling 里同样的形状再次出现，说明这不是 direct connect 偶然

`useSSHSession.ts` 基本复刻了同样的 loading edges：

- `sendMessage(...) -> setIsLoading(true)`
- `onPermissionRequest(...) -> setIsLoading(false)`
- `onAllow(...) -> setIsLoading(true)`
- `result -> setIsLoading(false)`
- `cancelRequest() -> setIsLoading(false)`
- `onDisconnected() -> setIsLoading(false)`

而且 SSH 还多了一条：

- `onReconnecting(...) -> setIsLoading(false)`，同时往 transcript 里塞 warning

这说明当前模式并不是 direct connect 的偶发写法，而更像：

- shell-like remote host family 的 loading lifecycle pattern

也正因为 SSH 还能“掉线后重连”，它更进一步说明：

- loading false

并不自动等于：

- session final death

有时它只是：

- 当前等待结束，接下来进入另一段 reconnect lifecycle

所以这页虽然以 direct connect 为主，但同构 sibling 证据说明：

- same bool write

在相邻 remote shell host 里也承载着多种不同语义。

## 第八层：所以 `loading` 至少有六种 edge

把上面几层压实之后，更稳的总表是：

| edge | 当前回答什么 | 典型位置 |
| --- | --- | --- |
| request start | 新请求已发出，开始等待远端推进 | `sendMessage(...) -> true` |
| approval pause | 远端 ask 到达，当前停表等待本地审批 | `onPermissionRequest(...) -> false` |
| approval resume | ask 已放行，远端执行恢复 | `onAllow(...) -> true` |
| turn-end release | 本轮收到了 `result` | `onMessage(result) -> false` |
| user-abort release | 本地主动 interrupt 当前请求 | `cancelRequest() -> false` |
| transport teardown release | 连接丢失或会话死亡 | `onDisconnected() -> false` |

所以真正该写成一句话的是：

- `loading=true` 本身至少分成 start / resume 两类
- `loading=false` 本身至少分成 pause / turn-end / abort / teardown 四类

这些都不是同一种 loading lifecycle。

## 第九层：当前源码能稳定证明什么，不能稳定证明什么

从当前源码可以稳定证明的是：

- direct connect 里的 `setIsLoading(true/false)` 至少对应多种不同 edge
- permission flow 明确把 pause 放在 request 到达时，而不是 reject/abort 按钮回调里
- SSH sibling 上存在同构 loading edge family

从当前源码不能在这页稳定证明的是：

- 所有 remote host 都严格共用这套 lifecycle
- `loading` 是否在更高层还会被别的 source 合并覆写
- 将来 direct connect 是否会引入 timeout/reconnect 这样的额外 edge

所以这页最稳的结论必须停在：

- same loading flag write != same lifecycle meaning

而不能滑到：

- direct connect has one authoritative loading state machine

## 第十层：为什么 119 不能并回 116

116 的主语是：

- visible result、turn-end 判定与 busy state 不是同一种 completion signal

119 的主语则更窄：

- 就算只看 busy state 这个 flag，本身的 true/false 写入也不是同一种 lifecycle edge

116 讲的是：

- completion-related semantics across layers

119 讲的是：

- loading flag semantics inside one host lifecycle

不是一页。

## 第十一层：为什么 119 也不能并回 118

118 的主语是：

- replay sources 与 dedup surfaces

119 的主语已经换成：

- request / approval / result / abort / disconnect 如何改写 loading

前者讲：

- provenance and dedup

后者讲：

- execution lifecycle and waiting state

问题域已经变了。

## 第十二层：最常见的假等式

### 误判一：所有 `setIsLoading(true)` 都只是“开始请求”

错在漏掉：

- `onAllow(true)` 是 pause 后 resume，不是 initial start

### 误判二：所有 `setIsLoading(false)` 都只是“完成了”

错在漏掉：

- permission pause、cancel、disconnect 也都会 false

### 误判三：拒绝审批时没写 `false`，说明 reject 不影响 loading

错在漏掉：

- loading 在 request 到达时已经先被关掉了

### 误判四：disconnect false 和 result false 没区别，反正都停了

错在漏掉：

- 一个是 turn-end release，一个是 transport teardown

### 误判五：direct connect 的 loading 只是它自己这样写，说明不了什么

错在漏掉：

- SSH sibling 上也复现了同样的 edge family

## 第十三层：苏格拉底式自审

### 问：我现在写的是 start、resume、pause，还是 end/abort/teardown？

答：如果答不出来，就说明又把 loading lifecycle 写平了。

### 问：我是不是把 permission request 的 false 写成了 turn completion？

答：如果是，就漏掉了 approval pause 这层。

### 问：我是不是把 `onAllow(true)` 当成了新的 request start？

答：如果是，就没把 resume 从 start 里拆出来。

### 问：我是不是把 disconnect false 写成了普通完成？

答：如果是，就混淆了 transport death 和 turn-end release。
