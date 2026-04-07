# `cancelRequest`、`onResponse` unsubscribe、`pendingPermissionHandlers.delete` 与 leader queue recheck：为什么 bridge permission race 的 prompt 撤场、订阅退役、响应消费与策略重判不是同一种收口合同

## 用户目标

196 已经把 permission leg 收成一句：

- `pendingPermissionHandlers` 是本地 pending verdict ledger

但如果正文停在这里，读者还是很容易把“判完以后怎么收”继续写平：

- 既然 `claim()` 已经赢了，permission race 不就结束了吗？
- 本地一旦决定 allow/deny，`cancelRequest(...)`、unsubscribe、`pendingPermissionHandlers.delete(...)` 不就都该算同一个 cleanup？
- `handlePermissionResponse(...)` 里已经会 `delete`，那本地赢的时候是不是也会同步把这张账清掉？
- `set_permission_mode` 之后的 queue recheck 不也只是把旧的等待清一清，为什么不能当 callback cleanup 的一部分？

这句还不稳。

从当前源码看，还得继续拆开四种不同收口：

1. prompt 撤场
2. subscription 退役
3. late response 消费
4. 策略变化后的旧等待窗重判

如果这四层不先拆开，后面就会把：

- `cancelRequest(...)`
- unsubscribe
- `pendingPermissionHandlers.delete(...)`
- leader queue recheck

重新压成一句模糊的“permission race cleanup”。

## 第一性原理

更稳的提问不是：

- “permission race 判完后为什么还会剩这么多尾巴？”

而是先问六个更底层的问题：

1. 当前动作是在关闭“谁还能给 verdict”，还是在关闭 verdict 之后遗留的其他表面？
2. 当前关闭的是远端 web prompt，可本地 subscription，还是本地 pending ledger entry？
3. 当前这个关闭动作是本地胜出时主动做，还是晚到 response 到场时被动做？
4. 当前动作和 transport frame 有关，还是和本地 queue/policy 状态有关？
5. 当前 `recheckPermission()` 关的是 callback 订阅，还是旧策略等待窗？
6. 我现在分析的是 196 的 ledger ownership，还是 verdict 之后的 closeout contract？

只要这六轴不先拆开，后面就会把：

- verdict 主权
- prompt dismiss
- subscription retirement
- queue re-evaluation

混成一张“cleanup 表”。

## 第一层：`claim()` / `resolveOnce` 只关 verdict 主权，不自动收其他表面

`PermissionContext.ts` 里的 `claim()` 非常明确：

- 它只做 atomic check-and-mark
- 回答“还有没有人能赢这次 verdict race”

这层作用很窄：

- 只封谁还能写最终 allow/deny

它并不自动做：

- `cancelRequest(...)`
- unsubscribe
- `pendingPermissionHandlers.delete(...)`
- queue recheck

所以更准确的理解不是：

- 一旦 `claim()` 赢了，permission race 的全部 closeout 就结束了

而是：

- verdict 主权只是一层，判完以后还有别的表面要分别退休

## 第二层：`cancelRequest(...)` 关的是远端 stale prompt，不是本地 subscription

`interactiveHandler.ts` 的 `recheckPermission()` 里，最硬的一段就是：

- 先 `claim()`
- 然后如果有 `bridgeCallbacks` 和 `bridgeRequestId`
- 只调用 `bridgeCallbacks.cancelRequest(bridgeRequestId)`

注释还直接写明：

- CCR response 可能正在飞来
- `cancelRequest` 的作用是让 CCR dismiss stale prompt

这说明这里回答的问题不是：

- “本地 handler 要不要注销”

而是：

- “远端 web UI 上那张已经过时的 prompt 要不要撤掉”

`REPL.tsx` 的 sandbox network bridge 路径更是给出了最强对照：

- cleanup 里显式同时做 `unsubscribe()`
- 再做 `bridgeCallbacks.cancelRequest(bridgeRequestId)`

如果这两件事本来是一层，

就不需要在这里显式并列写两步。

所以更准确地说：

- `cancelRequest(...)` 是 prompt dismiss
- 不是 subscription retirement

## 第三层：unsubscribe 关的是本地 subscription 退役，不等于远端 prompt 已撤，也不等于 ledger 已出账

`bridgePermissionCallbacks.ts` 里，`onResponse(...)` 的类型签名已经写死了：

- 返回值就是 unsubscribe

`interactiveHandler.ts` 里这层也很清楚：

- `const unsubscribe = bridgeCallbacks.onResponse(...)`
- 默认只把它绑到 abort signal 上

也就是说，在普通 bridge permission race 里：

- 本地胜出并不会自动调用 unsubscribe

最常见的本地胜出路径反而只是：

- `claim()`
- `cancelRequest(...)`
- `channelUnsubscribe?.()`
- `ctx.removeFromQueue()`

所以更准确的理解不是：

- 本地一旦判完，subscription 自然就退休了

而是：

- 本地 subscription 的退役是单独一层合同
- 有的路径显式退订
- 有的路径要等 abort 或别的清理器触发

## 第四层：`pendingPermissionHandlers.delete(...)` 经常不是本地赢时发生，而是晚到 response 到场时才出账

`useReplBridge.tsx` 的 `handlePermissionResponse(...)` 里：

- 先按 `request_id` 找 handler
- 命中后立刻 `pendingPermissionHandlers.delete(requestId)`
- 然后才继续验证 payload 并调用 handler

这说明这层回答的问题不是：

- “本地一赢，这张账就自动清了”

而是：

- “当晚到 `control_response` 真到达本地 dispatcher 时，这个 pending entry 要怎么被 arrival-side consume 掉”

这正是为什么 agent 结论里那句最硬：

- 本地赢时常常只发 `cancelRequest(...)`
- `pendingPermissionHandlers.delete(...)` 往往要等晚到 `control_response` 真到场才发生

所以这层也不是：

- prompt dismiss

更不是：

- unsubscribe

它是：

- arrival-side ledger consume

## 第五层：leader queue recheck 关的是旧策略等待窗，不是 callback cleanup

`useReplBridge.tsx` 在 `set_permission_mode` 成功后，

会：

- `setImmediate(...)`
- `getLeaderToolUseConfirmQueue()?.(...)`
- 对当前队列每个 item 调 `item.recheckPermission()`

这一步回答的问题不是：

- 某个 `request_id` 的 subscription 要不要注销

而是：

- 既然 permission mode 变了，当前队列里那些旧策略下挂起的 prompt 要不要重新判

而且别的上下文还专门证明了这层不通用：

- `useRemoteSession.ts` 的 `recheckPermission()` 是 no-op
- `useInboxPoller.ts` 的 `recheckPermission()` 也是 no-op

这说明 queue recheck 的主语是：

- leader queue 的本地策略等待窗

不是：

- generic bridge callback cleanup

## 第六层：这页不是 196 的重复，而是 196 之后的 closeout map

196 的主语是：

- `pendingPermissionHandlers` 是什么账

198 的主语继续往后走一步：

- verdict 已经判完以后，还有哪些表面没退休，而且各自由谁来退

196 回答：

- 谁还在账上

198 回答：

- 账上之外的 prompt、subscription、late response、queue 等待窗，各自怎么收

这也是为什么它不该和 196 合成一页。

一旦合成，

就会把：

- ownership
- closeout

重新压成一句含糊的：

- “permission race 的本地状态管理”

## 结论

更稳的一句应该是：

- `claim()` 只关闭“谁还能改 verdict”的 race
- `cancelRequest(...)` 关闭的是远端 stale prompt
- unsubscribe 退役的是本地 response subscription
- `pendingPermissionHandlers.delete(...)` 经常要等晚到 response 到场才出账
- leader queue recheck 关的是策略变化后的旧等待窗

一旦这句成立，

就不会再把：

- prompt 撤场
- 订阅退役
- 响应消费
- 策略重判

写成同一种 permission race closeout contract。
