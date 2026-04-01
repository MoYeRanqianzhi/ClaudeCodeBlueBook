# QueryGuard：本地查询生命周期的authoritative state machine

这一章回答五个问题：

1. 为什么 `QueryGuard` 不是普通 util，而是 REPL 本地查询的权威状态机。
2. 为什么 `dispatching` 这个中间态比很多人直觉中的 `running` 更关键。
3. 它怎样切断 queue、submit、cancel、finally 之间的双状态竞争。
4. 为什么 generation 机制是 stale finally 熔断器，而不是普通计数器。
5. 这对 Claude Code 源码先进性的判断意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-104`
- `claude-code-source-code/src/screens/REPL.tsx:897-918`
- `claude-code-source-code/src/screens/REPL.tsx:2113-2135`
- `claude-code-source-code/src/screens/REPL.tsx:2866-2928`
- `claude-code-source-code/src/utils/handlePromptSubmit.ts:426-607`
- `claude-code-source-code/src/hooks/useQueueProcessor.ts:1-59`

## 1. 先说结论

`QueryGuard` 真正先进的地方，不是它把 loading 管得更整洁，而是它把：

- 本地查询是否正在进行

升级成了一个：

- 同步
- 可订阅
- 可代际校验

的 authoritative runtime fact。

也就是说，Claude Code 在这里已经不再相信：

- React loading state
- 零散 ref
- UI 层“看起来正在转”的表象

能够稳定代表本地查询真相。

它选择的是另一条路：

- 用一个小而硬的状态机把 query lifecycle 本身收口成控制平面

## 2. 为什么要从双状态拼接退回到单一权威状态

`REPL.tsx` 的注释已经把旧问题说得很清楚：

- `isLoading` 是 React state，异步 batched
- `isQueryRunning` 是 ref，同步更新

这类双状态模式最危险的地方不是“代码不优雅”，而是：

- 不同消费者会在同一时刻读到不同真相

例如：

- queue processor 以为当前空闲
- submit path 以为当前忙碌
- cancel path 已经结束
- stale finally 又想把系统清回 idle

所以 `QueryGuard` 解决的不是显示问题，而是：

- 运行时认知分裂

`REPL.tsx` 甚至直接把它定义为：

- local query in flight 的 single source of truth

## 3. `dispatching` 比 `running` 更关键

很多人设计本地查询状态机时，只会建：

- idle
- running

Claude Code 多加了一个非常关键的状态：

- `dispatching`

这是整份设计里最值得学的点之一。

因为真正危险的竞态常常不发生在 query 已经运行之后，而发生在：

- 队列刚出队
- 异步链刚开始
- 还没真正到 `onQuery`

这段空窗里。

如果这时系统还把自己视为 idle，就会发生：

- 第二次 submit 直接穿透
- queue processor 再次 dequeue
- teammate / task notification 插队

`reserve()` 的价值就在于：

- 先把系统标成 busy

哪怕真正 query 还没开始。

这说明作者处理的不是“并发执行”问题，而是：

- 异步启动空窗里的真相滞后问题

## 4. generation 机制：为什么 stale finally 必须被明确熔断

`tryStart()` 不只是返回成功或失败，它还会递增 generation。

而 `end(generation)` 只允许：

- 当前这一代 query

结束当前状态。

这意味着如果发生：

- cancel
- forceEnd
- resubmit
- 旧 promise 的 finally 晚到

旧 finally 并不能把系统错误清回 idle。

这是非常成熟的写法，因为很多系统到这里会默认：

- finally 总会安全清理

Claude Code 则明确接受：

- finally 也可能是 stale writer

所以 `forceEnd()` 会主动递增 generation，让被取消查询的尾部清理逻辑自动失效。

这不是普通 loading helper 会考虑的层次，而是：

- race-aware runtime

## 5. 它已经不是一个类，而是一段局部控制协议

`QueryGuard` 之所以重要，不在类本身，而在它已经成为 REPL 局部协议。

### 5.1 submit 路径

`handlePromptSubmit.ts` 会在 `processUserInput(...)` 之前先 `reserve()`。

这意味着系统要求：

- 真正进入 async 处理链之前，就必须先占住运行权

### 5.2 queue 路径

`useQueueProcessor` 不再自己管理 reservation，而是改成：

- 订阅 `queryGuard`
- 只在 authoritative idle 时 dequeue

这让 queue 不再自己猜本地 query 是否结束。

### 5.3 onQuery 路径

`onQuery` 里用 `tryStart()` 原子切换到 `running`，并在 finally 中用 `end(generation)` 收尾。

这意味着 query lifecycle 的开始与结束都服从同一 authority。

### 5.4 cancel 路径

`onCancel()` 里直接 `forceEnd()`。

这里系统并没有等 UI 或 promise 链自然收敛，而是：

- 抢回 authoritative ownership

所以 `QueryGuard` 已经不是 util，而是：

- local-query control plane

## 6. 为什么这体现了 Claude Code 的源码先进性

如果只看功能表面，`QueryGuard` 很小。

但它恰恰体现出 Claude Code 很强的一种工程习惯：

- 先把竞态收口成显式状态机
- 再让 UI 订阅状态机
- 而不是让状态机从 UI 推导出来

这和很多“先有 spinner，再在边角补防抖”的系统完全不同。

它表明作者在本地交互层也坚持：

1. authoritative truth first
2. race awareness first
3. render second

所以判断源码先进性时，真正该看的不是“大文件多少”，而是这种：

- 小而硬的运行时收口点

## 7. 苏格拉底式追问

### 7.1 如果 loading 只是 UI 表象，为什么要让 queue、submit、cancel 都依赖它

不应该。
所以 Claude Code 让它们依赖的是 `QueryGuard`，不是 spinner。

### 7.2 如果系统没有 `dispatching`，异步空窗里谁负责说“现在已经不能再进来了”

没人负责。
竞态就会在这里自然长出来。

### 7.3 如果 finally 也可能是 stale writer，为什么还假设它一定安全

不应该假设。
所以需要 generation。

### 7.4 为什么这比“再补几个 if 防重入”更值得学

因为 if 只能补某条路径。
状态机才能统一定义所有路径共享的本地查询真相。

## 8. 一句话总结

`QueryGuard` 的真正价值，不是管理 loading，而是把本地查询生命周期收口成一个同步、可订阅、可代际校验的 authoritative state machine。
