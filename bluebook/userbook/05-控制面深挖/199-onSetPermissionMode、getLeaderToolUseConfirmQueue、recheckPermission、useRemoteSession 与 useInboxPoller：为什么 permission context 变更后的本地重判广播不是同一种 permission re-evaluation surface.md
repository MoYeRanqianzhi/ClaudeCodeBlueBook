# `onSetPermissionMode`、`getLeaderToolUseConfirmQueue`、`recheckPermission`、`useRemoteSession` 与 `useInboxPoller`：为什么 permission context 变更后的本地重判广播不是同一种 permission re-evaluation surface

## 用户目标

198 已经说明：

- `cancelRequest(...)`
- unsubscribe
- `pendingPermissionHandlers.delete(...)`
- leader queue recheck

不是同一种 closeout contract。

但这不表示 `199` 是 `198` 的线性下一步。

按 permission tail 的 canonical 拓扑，

- `198`
- `199`

都应回挂到 `196` 之后的不同后继问题；

这里只是先借 `198` 的 request-level closeout 当反例，

再继续追问：

- permission context change 下的 leader-local re-evaluation

到底为什么不能被写成 closeout 延长线。

但如果正文停在这里，读者还是很容易把 `recheckPermission()` 这条线继续写平：

- 既然 `set_permission_mode` 会触发 queue recheck，那是不是所有 pending permission ask 都会跟着本地 mode 变化一起重判？
- `recheckPermission()` 不就是 permission 系统的统一重判入口吗？
- remote session 和 inbox poller 那两条 ask 面也都有 `recheckPermission()`，为什么不能视为同一种 re-evaluation surface？
- 既然 mode 变化后会重判，那它是不是其实也在顺手完成 closeout？

这句还不稳。

从当前源码看，还得继续拆开两种不同 surface：

1. leader queue 上的本地重判广播
2. remote / inbox ask 上显式 no-op 的重判占位

如果这两层不先拆开，后面就会把：

- `onSetPermissionMode(...)`
- `getLeaderToolUseConfirmQueue()`
- `item.recheckPermission()`
- `useRemoteSession` 的 no-op
- `useInboxPoller` 的 no-op

重新压成一句模糊的“mode 变化后 permission 会重判”。

## 第一性原理

更稳的提问不是：

- “为什么有的 ask 会重判，有的不会？”

而是先问六个更底层的问题：

1. 当前 mode 变化是在改本地 leader 的 permission context，还是在改 remote/container/worker 侧的权限状态？
2. 当前 recheck 触达的是通过 leader queue 挂起的 ask，还是所有 pending ask surface？
3. 当前 `recheckPermission()` 是真实会读取本地规则再判一次，还是只是接口占位？
4. 当前变化会不会直接替某个 pending ask 出 verdict，还是只是在广播“你们自己按本地上下文再看一遍”？
5. 当前分析的是 198 的 closeout，还是更上游的 re-evaluation surface？
6. 我是不是把“有这个方法”误读成“它在所有 surface 上语义都相同”？

只要这六轴不先拆开，后面就会把：

- mode change
- queue fanout
- local recheck
- remote no-op

混成一张“permission 重判表”。

## 第一层：`onSetPermissionMode(...)` 回答的是“本地 permission context 改了”，不是“所有 pending ask 自动改判了”

`useReplBridge.tsx` 的 `onSetPermissionMode(mode)` 先做的是：

- 通过 `transitionPermissionMode(...)` 改本地 `toolPermissionContext`

这一步的主语很明确：

- 本地 leader 当前的 permission context

它先回答的问题不是：

- 哪些 pending ask 现在已经被判成 allow/deny

而是：

- 本地规则集已经换了，后续如果有人依赖这套本地规则，应该重新看一遍

所以更准确地理解不是：

- CCR 改 mode = 所有 pending ask 当场被统一重判并关闭

而是：

- CCR 改 mode 只是改了本地 permission context

## 第二层：`getLeaderToolUseConfirmQueue()` + `item.recheckPermission()` 是 leader queue 的本地 fanout，不是 generic permission API

同一个 `onSetPermissionMode(...)` 之后，代码才继续：

- `setImmediate(...)`
- `getLeaderToolUseConfirmQueue()?.(currentQueue => { currentQueue.forEach(item => void item.recheckPermission()) })`

这里的主语非常窄：

- 只有 leader queue 上当前挂着的 `ToolUseConfirm` 项

这说明这一步回答的问题不是：

- “permission 系统里所有 pending ask 都统一重判”

而是：

- “leader queue 上这些本地 ask，你们自己按新 context 再判一次”

也就是说：

- `getLeaderToolUseConfirmQueue()` 是 fanout bridge
- `item.recheckPermission()` 是本地 ask 自己实现的重判 hook

这不是 generic API。

它是一条很具体的：

- leader-local re-evaluation surface

## 第三层：`interactiveHandler.ts` 的 `recheckPermission()` 真正会读取本地规则再判一次

`interactiveHandler.ts` 里这条 hook 是真的会工作的：

- 先 `hasPermissionsToUseTool(...)`
- 再看 `freshResult.behavior`
- 如果现在变成 `allow`
- 就 `claim()`
- `cancelRequest(...)`
- `channelUnsubscribe?.()`
- `ctx.removeFromQueue()`
- 最后 `resolveOnce(...)`

这说明 leader queue 上的 `recheckPermission()` 不是装饰方法，

而是：

- 一条真实的 local re-evaluation path

它依赖的前提也非常明确：

- 当前 ask 仍挂在本地 leader queue 上
- 当前 permission state 就在本地可读

所以更准确的理解不是：

- 任何地方叫 `recheckPermission()` 都等价

而是：

- 只有这一类 local ask，`recheckPermission()` 才真的是“读新规则后再判一次”

## 第四层：`useRemoteSession` 与 `useInboxPoller` 故意把 `recheckPermission()` 做成 no-op，证明它不是统一 surface

`useRemoteSession.ts` 明确写了：

- `async recheckPermission() { // No-op for remote — permission state is on the container }`

`useInboxPoller.ts` 也明确写了：

- `async recheckPermission() { // No-op for tmux workers — permission state is on the worker side }`

这两段是最硬的反证。

它们说明 `recheckPermission()` 这个方法名本身并不保证：

- 这里一定存在本地重判 surface

相反，

它只是一种统一接口下的能力占位：

- leader-local ask 会真正重判
- remote ask / worker ask 明确不会

所以更准确的理解不是：

- 这些 ask 只是暂时还没实现重判

而是：

- 这些 ask 的 permission state 根本不在 leader 本地
- 因此 mode-change fanout 对它们没有主权

## 第五层：`REPL.tsx` 的本地 permission context 更新也会 fanout recheck，再次证明主语是“本地 leader 上下文”

`REPL.tsx` 里本地 permission context 变化后，也会：

- `setImmediate(...)`
- 遍历当前 queue
- `void item.recheckPermission()`

而且注释写得很清楚：

- approving item1 with "don't ask again"
- 可能让其他 queued items 自动匹配新规则

这进一步说明：

- 真正决定会不会 recheck 的不是“谁发来了 mode change”
- 而是“本地 leader 的 permission context 是否改了，且当前 ask 是否挂在这条本地 queue 上”

所以 199 的主句也不该写成：

- CCR mode change 的一个特殊副作用

而应该写成：

- leader-local permission context change 的 fanout surface

CCR 只不过是其中一个触发源。

## 第六层：这页不是 198 的重复，而是 closeout 之前的 re-evaluation surface map

198 的主语是：

- verdict 已经判完以后，还有哪些表面要分别收口

199 的主语更靠前：

- 在某些场景里，pending ask 连 closeout 还没进入，就会先收到一轮本地 re-evaluation 广播

198 里的 leader queue recheck 只是作为四层收口之一的对照项出现，

而 199 要把它完整写实：

- 谁会被 fanout 到
- 谁明确不会
- 为什么不会

所以：

- 198 讲 closeout
- 199 讲 re-evaluation surface

如果把两页压成一页，

就会把：

- mode-change 后的本地重判
- verdict 之后的 closeout

写成同一张 permission lifecycle 表。

## 结论

更稳的一句应该是：

- `onSetPermissionMode(...)` 改的是本地 leader 的 permission context
- `getLeaderToolUseConfirmQueue()` fanout 到的，只是 leader queue 上那些真正实现了本地 `recheckPermission()` 的 ask
- `interactiveHandler.ts` 的 `recheckPermission()` 是真实重判路径
- `useRemoteSession` 和 `useInboxPoller` 的 `recheckPermission()` 则明确是 no-op

一旦这句成立，

就不会再把：

- leader queue fanout
- local recheck
- remote/worker no-op

写成同一种 permission re-evaluation surface。
