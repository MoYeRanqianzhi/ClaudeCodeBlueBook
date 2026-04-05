# 安全状态句柄化：为什么下一代控制面不该继续用裸key编辑状态，而应把family scope升级为opaque handle

## 1. 为什么在 `79` 之后还要继续写“状态句柄化”

`79-安全状态家族作用域` 已经回答了：

`真正的长期边界不该只是全局 key 名，而应是被正式承认的 family scope。`

但如果继续往下追问，  
还会碰到一个更接近接口设计终局的问题：

`如果 family scope 不该继续藏在命名里，那它下一步该放到哪里？`

仅仅说：

`请大家按 family 命名`

并不能真正解决问题。  
因为命名只能提示作用域，  
不能授予作用域。

所以在 `79` 之后，  
安全专题必须再补一条更偏接口工程、也更接近下一代产品化的原则：

`状态句柄化。`

也就是：

`当系统已经知道状态编辑需要主语、需要家族、需要作用域时，下一步就不该继续传裸 key，而应把这些边界收进一个带主权的 opaque handle。`

## 2. 最短结论

从源码看，Claude Code 在通知状态子系统和 bridge 子系统之间，已经形成了非常鲜明的对照：

1. notifications 协议把状态身份压成 `key: string`，编辑动作也只接受裸字符串  
   `src/context/notifications.tsx:6-23,31-40,193-213`
2. notifications 的 store 也只存 `current: Notification | null` 与 `queue: Notification[]`，没有 family scope、owner 或 handle metadata  
   `src/state/AppStateStore.ts:222-225,532-535`
3. 但 bridge 子系统已经明确使用 `ReplBridgeHandle` 这种 handle，把可执行能力绑在受限方法集上  
   `src/bridge/replBridge.ts:70-80,1779-1834`
4. `replBridgeHandle.ts` 的注释还明确说明：handle 的闭包捕获了创建该 session 的 `sessionId` 与 token 语义，重新独立推导会引入 staging/prod token divergence 风险  
   `src/bridge/replBridgeHandle.ts:5-13,16-27`
5. 这说明 Claude Code 并不是不知道什么叫 capability handle；它已经在高风险远程控制面里采用了 handle 模式，只是通知状态面还停留在 pre-handle 阶段

所以这一章的最短结论是：

`对于下一代统一安全控制台，通知状态也应像 bridge 一样从“名字寻址”升级到“句柄寻址”。`

我把它再压成一句：

`名字只能指向状态，句柄才能承载状态主权。`

## 3. 源码已经说明：Claude Code 已经同时存在“裸key模式”和“句柄模式”两种世界

## 3.1 通知状态当前仍是典型的裸key编辑模型

`src/context/notifications.tsx:6-23` 里，  
`Notification` 的身份核心仍然是：

`key: string`

而接口层 `31-40` 又进一步把编辑动作定义成：

1. `addNotification(content: Notification)`
2. `removeNotification(key: string)`

再看 `193-213`，  
删除逻辑完全按 key 运作：

1. current 命中则删
2. queue 命中则删

这说明 notifications 子系统的基本编辑模型仍是：

`用名字找状态，再按名字改状态。`

这就是典型的 pre-handle 设计。

## 3.2 store 结构也证明：系统当前没有把作用域和主权作为状态对象的一部分存下来

`src/state/AppStateStore.ts:222-225,532-535` 很关键。

notifications 在全局状态里的形态只有：

1. `current: Notification | null`
2. `queue: Notification[]`

这里没有：

1. family
2. owner
3. handle id
4. scope token
5. allowed editor set

这意味着即便上层业务逻辑已经知道：

`这条状态属于 IDE family`

进入 store 后，  
它仍会退化成一个普通 `Notification` 对象。

也就是说：

`作用域知识并没有被状态对象自己携带。`

## 3.3 但 bridge 子系统已经在用 handle 承载能力边界

`src/bridge/replBridge.ts:70-80` 定义的 `ReplBridgeHandle` 很有代表性。

它不是一个裸 id，  
而是一个带方法集的能力对象：

1. `writeMessages`
2. `writeSdkMessages`
3. `sendControlRequest`
4. `sendControlResponse`
5. `sendControlCancelRequest`
6. `sendResult`
7. `teardown`

`1779-1834` 又说明这些能力都不是随便拼出来的。  
它们都依赖：

1. 当前 transport
2. 当前 session id
3. 当前 teardown lifecycle

这说明在 bridge 子系统里，  
作者已经明确接受一个原则：

`高风险边界不该靠裸字符串重新推导，而应靠句柄携带受限能力。`

## 3.4 `replBridgeHandle.ts` 的注释几乎已经把“为什么要 handle”说透了

`src/bridge/replBridgeHandle.ts:5-13,16-27` 是本章最强的证据。

注释直接说：

1. 全局指针保存 active REPL bridge handle
2. 这样 React 树外的调用者也能安全调用 handle methods
3. 之所以这么做，是因为 handle 的闭包捕获了创建 session 的 `sessionId` 和 `getAccessToken`
4. 如果独立重新推导这些值，会带来 token divergence 风险

这其实已经把句柄哲学说得非常清楚：

`handle 的价值不是方便访问，而是把正确的上下文、能力和生命周期绑在一起。`

把这条哲学映射回 notifications，  
就会得到一个很自然的推论：

`通知状态的 family、owner 与 allowed operator 也不该靠调用方自己重新推导。`

## 3.5 第一性原理：名字回答“它是谁”，句柄回答“你能拿它做什么”

如果从第一性原理追问：

`为什么 family scope 的下一步一定会走向 handle，而不是更多命名规则？`

因为名字和句柄回答的是两类不同问题：

1. 名字回答：它是谁
2. 句柄回答：你能拿它做什么

对安全控制面来说，  
真正危险的从来不是认错对象名字，  
而是：

`没有被授权的主体，却拿对象做了不该做的编辑。`

所以只要系统已经开始区分：

1. owner remove
2. family invalidate
3. family fold
4. coexist boundary

它迟早就会走到一句更硬的话：

`这些能力不该继续由任意拿到 key 字符串的人自由组合。`

## 3.6 下一代统一安全控制台如果继续成长，最自然的演化就是“状态句柄化”

基于现有源码，  
下一代通知/状态控制面最自然的升级方向不是“更多状态”，  
而是“更强的状态对象”。

至少可以想象一个 handle 应携带：

1. `family`
2. `member`
3. `owner`
4. `allowedOperators`
5. `relation metadata`
6. `lifecycle hooks`

那样的话：

1. owner 只能 remove 自己家族里的成员
2. family editor 才能 invalidate sibling
3. fold 只能在同一聚合族内发生
4. outsider 即便知道名字，也拿不到真正可编辑能力

这正是 bridge handle 已经在别处证明可行的思路。

## 3.7 技术先进性与启示：Claude Code 已经证明自己知道 handle 值得放在哪里

从技术角度看，  
这套设计最有意思的地方不是“notifications 还不够好”，  
而是：

`Claude Code 并没有停留在不知道 handle 的阶段。`

它已经在 bridge / remote control 这种高风险控制面里采用了：

1. 受限方法集
2. 闭包捕获关键上下文
3. teardown 生命周期
4. 全局指针只保存 handle，不重建能力

这意味着对通知状态面来说，  
真正缺的不是认知，  
而只是：

`把已经在别处成立的 handle 哲学迁移过来。`

## 4. 状态句柄化的最短规则

把这一章压成最短规则，就是下面六句：

1. 裸 key 只适合做轻量身份，不适合承载长期主权边界
2. family scope 一旦变重要，就应进入对象模型
3. owner / family editor 的可编辑能力应挂在 handle 上，而不是散落在调用方脑中
4. store 中的状态对象最好携带作用域信息，而不是只保留名字
5. 高风险控制面已证明 handle 模式可行，通知状态面没有理由永远停留在裸 key
6. 下一代统一安全控制台的真正升级，不是更多卡片，而是更强的状态能力对象

## 5. 苏格拉底式追问：这套系统还能怎样再向前推进

如果继续自问，  
最值得做的三项升级会是：

1. 把 `Notification.key` 升级成 `NotificationHandle` 或 `ScopedNotificationId`
2. 让 `remove`、`fold`、`invalidate` 的接口都接受 scoped handle，而不是裸字符串
3. 把 bridge handle 的设计经验迁移到统一安全控制台，让状态编辑真正具备 capability boundary

所以这一章最终沉淀出的设计启示是：

`一旦系统开始认真对待状态主权，它最终就会从命名纪律走向句柄纪律。`
