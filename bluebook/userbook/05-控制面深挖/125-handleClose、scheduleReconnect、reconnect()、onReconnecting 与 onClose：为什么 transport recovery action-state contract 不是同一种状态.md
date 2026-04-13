# `handleClose`、`scheduleReconnect`、`reconnect()`、`onReconnecting` 与 `onClose`：为什么 transport recovery action-state contract 不是同一种状态

## 用户目标

122 已经拆过：

- timeout watchdog
- warning transcript
- reconnecting state
- disconnected release

124 又把 recovery signer 拆成：

- prompt
- authority projection
- action edge
- UI projection
- absence semantics

继续往下读时，读者还是很容易把 transport 层再压成一句：

- WS 掉线会 reconnect
- timeout 也会 reconnect
- UI 会变成 `reconnecting`
- 失败了再进 `disconnected`

于是正文就会滑成一句似是而非的话：

- “无论是 close-driven backoff 还是 timeout 触发的 force reconnect，本质都是同一条 reconnecting 状态机。”

从当前源码看，这也不成立。

这里至少有五个不同的 action-state edge：

1. close event enters `handleClose(...)`
2. `handleClose(...)` decides reconnect vs close
3. `scheduleReconnect(...)` emits `onReconnecting`
4. `reconnect()` force-closes and directly re-connects
5. `onClose` / `onDisconnected` 才是 terminal close projection

它们都与 recovery 有关，但不是同一种 transport recovery action-state contract。

## 第一性原理

更稳的提问不是：

- “它会不会重连？”

而是先问五个更底层的问题：

1. 当前是被动 close-driven recovery，还是主动 force reconnect？
2. 当前 transport 有没有真的进入 backoff reconnect path？
3. 当前会不会触发 `onReconnecting`？
4. 当前会不会触发 `onClose`？
5. 当前共享状态面会不会因此真的穿过 `reconnecting` / `disconnected`？

只要这五轴先拆开，`reconnect()`、`onReconnecting()`、`onClose()`、`disconnected` 就不会再被写成一条单线流程。

## 第一层：真正的 authority 在 `SessionsWebSocket.handleClose(...)`

如果把 transport 层压缩到一句，最接近 raw authority 的不是：

- warning transcript
- `remoteConnectionStatus`
- `manager.reconnect()`

而是：

- `SessionsWebSocket.handleClose(closeCode)`

因为真正决定：

- 还要不要 reconnect
- 走哪一种 reconnect
- 什么时候算彻底不再 reconnect

的是它。

这说明 transport 层的主语首先不是：

- “UI 现在显示什么”

而是：

- “close event 进入后，state machine 选择哪条后续边”

## 第二层：`onClose` 只属于 terminal path，不是任何 close 都会触发

`SessionsWebSocket` 对 callback 的注释写得很直接：

- `onReconnecting` fires when transient close is detected and a reconnect is scheduled
- `onClose` fires only for permanent close

也就是说，`onClose` 回答的不是：

- “socket 刚刚关了一下”

而是：

- “当前 transport 已经不再进入 reconnect path，或者预算耗尽”

所以只要正文把：

- close happened

和：

- `onClose` fired

写成同义句，就已经把 transport contract 写错了。

## 第三层：`scheduleReconnect(...)` 才是 `onReconnecting` 的 authority edge

`handleClose(...)` 里真正会发：

- `callbacks.onReconnecting?.()`

的不是 `handleClose(...)` 本身，

而是它选择进入：

- `scheduleReconnect(delay, label)`

之后。

而 `scheduleReconnect(...)` 做了两件紧密绑定的事：

1. 先发 `onReconnecting`
2. 再启动 backoff timer，稍后 `connect()`

所以这里的核心结论是：

- `onReconnecting` 不是“任何 reconnect 动作都会有的通用提示”

它更具体地属于：

- close-driven backoff reconnect path

这一步非常关键，因为它直接限制了 `onReconnecting` 的结论上限。

## 第四层：`handleClose(...)` 里至少有三种不同 close 后续，不是统一 reconnect

`handleClose(closeCode)` 并不是“收到 close 就 scheduleReconnect”。

它至少拆成三类：

### 永久 close code

- 如果命中 `PERMANENT_CLOSE_CODES`
- 直接 `callbacks.onClose?.()`

### `4001`

- 先走 `sessionNotFoundRetries`
- 在预算内时 `scheduleReconnect(...)`
- 预算耗尽后才 `onClose`

### 普通 transient close

- 只有 `previousState === 'connected'`
- 且 `reconnectAttempts < MAX_RECONNECT_ATTEMPTS`
- 才 `scheduleReconnect(...)`

否则：

- `Not reconnecting`
- `onClose`

这说明 transport 层首先回答的是：

- “当前 close 属于哪一类 policy bucket”

而不是：

- “反正都会先 reconnecting 再说”

## 第五层：`reconnect()` 不是 `scheduleReconnect()` 的别名

这是这页最核心的一刀。

`SessionsWebSocket.reconnect()` 做的事情是：

1. reset retry counters
2. `close()`
3. 500ms 后直接 `connect()`

它并没有：

- 调 `scheduleReconnect(...)`

这意味着：

- force reconnect

和：

- close-driven backoff reconnect

不是同一条 action path。

更具体地说：

- 前者是主动 repair action
- 后者是 transport close 之后的 state-machine backoff

如果把二者写成“只是 delay 不同”，正文就会把 action contract 压平。

## 第六层：为什么 timeout warning 后不保证出现 `Reconnecting…`

`useRemoteSession` timeout 路径里做的是：

- `manager.reconnect()`

再往下就是：

- `SessionsWebSocket.reconnect()`

而不是：

- `scheduleReconnect(...)`

当前实现里，`reconnect()` 会先：

- `close()`
- 把 `state = 'closed'`

后续 close event 再进 `handleClose(...)` 时，

第一句就是：

- `if (this.state === 'closed') return`

这意味着在当前实现里，更稳的判断是：

- timeout warning 后发生了 force reconnect action

但这条路径并不自然穿过：

- `scheduleReconnect(...)`
- `onReconnecting()`
- `RemoteSessionManager.onReconnecting`
- `useRemoteSession.setConnStatus('reconnecting')`

所以更稳的写法应是：

- timeout warning 不等于共享状态面一定会先显示 `reconnecting`

再往 UI 侧推一步就是：

- timeout warning 之后，brief 行也不保证一定马上出现 `Reconnecting…`

这里要明确说明：

- 这是对当前实现路径的源码推断

不是：

- 注释里直接写死的稳定用户合同

## 第七层：`onDisconnected()` 也不是任何 close 的直接同义词

`RemoteSessionManager` 会把 websocket 的：

- `onClose`

映射成：

- `callbacks.onDisconnected?.()`

而 `useRemoteSession.onDisconnected()` 又会：

- `setConnStatus('disconnected')`
- `setIsLoading(false)`
- 清 task / tool IDs

所以 `disconnected` 这一层的前提其实是：

- transport 已经走到 terminal close projection

而不是：

- 某次 reconnect action 已经发起了

这也说明：

- `onDisconnected`

和：

- `reconnect()`

根本不在同一层。

一个是：

- terminal state projection

一个是：

- repair action

## 第八层：`reconnecting` 与 `disconnected` 不是 action 的自然前后，而是两类投影结果

如果把前面几层合在一起，会得到一个更稳的图：

### path A: close-driven backoff

- close event
- `handleClose(...)`
- `scheduleReconnect(...)`
- `onReconnecting`
- 共享状态投成 `reconnecting`

### path B: terminal close

- close event
- `handleClose(...)`
- 不再 reconnect
- `onClose`
- 共享状态投成 `disconnected`

### path C: force reconnect

- owner-side code 调 `reconnect()`
- `close()`
- 延时 `connect()`
- 当前实现下不天然经过 `scheduleReconnect(...)`

所以：

- `reconnecting`
- `disconnected`

不是 action path 本身，

而是某些 action / state-machine path 最后投出来的共享状态结果。

如果把这两者写成：

- “先 reconnecting，再不行 disconnected”

就又把 path A/B/C 压回了单线叙事。

## 第九层：为什么它不是 122、124 的重复页

### 它不是 122

122 讲的是：

- warning、reconnecting、disconnected 不同层

125 则更底层：

- 哪些 transport path 会触发 `onReconnecting`
- 哪些会触发 `onClose`
- 哪些只是 force reconnect action

一个讲：

- recovery lifecycle 的语义层

一个讲：

- transport action-state contract

### 它不是 124

124 讲的是：

- 哪些 surface 有资格给 recovery 签字

125 则讲：

- authority path 自己内部的状态机分叉

一个讲：

- signer ceiling

一个讲：

- authority machine

## 第十层：最常见的假等式

### 误判一：调用了 `reconnect()` 就等于进入 `onReconnecting()`

错在漏掉：

- `reconnect()` 不是 `scheduleReconnect()`

### 误判二：socket close 了就一定会进 `reconnecting`

错在漏掉：

- `handleClose(...)` 可能直接 `onClose`

### 误判三：`onClose` 只是 “reconnect 最后失败” 的别名

错在漏掉：

- 永久 close code 也会直接走它
- 某些 non-connected close 也会直接走它

### 误判四：timeout warning 之后 UI 一定会先显示 `Reconnecting…`

错在漏掉：

- timeout 走的是 force reconnect path
- 当前实现不保证经过 `onReconnecting`

### 误判五：`disconnected` 就是 reconnect action 的最后一步

错在漏掉：

- 它是 terminal close projection
- 不是 action path 本身

## 第十一层：stable / conditional / internal

### 稳定可见

- `onReconnecting` 当前只属于 close-driven backoff reconnect path
- `onClose` 当前只属于 terminal close path
- `RemoteSessionManager` 会把 `onClose` 映射成 `onDisconnected`
- `useRemoteSession` 会把 `onReconnecting` / `onDisconnected` 投成共享状态面

### 条件公开

- `4001` 有单独 retry budget
- 普通 transient close 还要求 `previousState === 'connected'`
- timeout warning 走 force reconnect，但当前实现不保证自然投成 `reconnecting`

### 内部 / 灰度层

- `MAX_RECONNECT_ATTEMPTS`
- `MAX_SESSION_NOT_FOUND_RETRIES`
- `RECONNECT_DELAY_MS`
- force reconnect 的 `500ms`
- `handleClose(...)` 的 early-return 顺序

这些属于：

- 当前实现细节

而不是：

- 适合直接对读者承诺的稳定产品语义

所以这页最稳的结论必须停在：

- `scheduleReconnect(...)`、`reconnect()`、`onReconnecting`、`onClose`、`onDisconnected` 当前不是同一种 action-state contract
- timeout warning 之后最多只能稳说 force reconnect action 已发起，不能稳说共享状态面一定已经先投成 `reconnecting`
- `125` 到这里为止；recovery lifecycle 语义层应回到 `122`，recovery signer / projection ceiling 应回到 `124`

而不能滑到：

- 只要 transport 想恢复，所有 path 最终都会先统一走一遍 `reconnecting`
- `disconnected` 只是 reconnect action 的最后一步

## 第十二层：苏格拉底式自审

### 问：我现在写的是 close-driven backoff，还是 force reconnect？

答：如果答不出来，就说明又把 path 混了。

### 问：我是不是把 `onReconnecting` 当成所有 reconnect 的通用事件？

答：如果是，就把 authority path 写错了。

### 问：我是不是把 `onClose` 写成了“所有 close 的直译”？

答：如果是，就把 terminal projection 和 raw close event 混了。

### 问：我是不是把 timeout warning 后的 UI 变化写成了必然共享状态？

答：如果是，就把当前实现路径推断误写成了稳定用户合同。

## 结论

所以这页能安全落下的结论应停在：

- `scheduleReconnect(...)` 才是 `onReconnecting()` 的 authority path，`reconnect()` 不是它的别名
- `onClose` / `onDisconnected` 属于 terminal projection，不是任何 reconnect action 的自然下一步
- timeout warning 之后当前更稳的判断只是 force reconnect action 已发起，而不是 `reconnecting` 必然已经成立
- `125` 因而只裁定 transport close-path 分叉，不裁定一般 recovery 真相

一旦这句成立，

就不会再把：

- close-driven backoff
- force reconnect
- `reconnecting`
- `disconnected`

写成同一种 transport 状态机。

## 源码锚点

- `claude-code-source-code/src/remote/SessionsWebSocket.ts`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
