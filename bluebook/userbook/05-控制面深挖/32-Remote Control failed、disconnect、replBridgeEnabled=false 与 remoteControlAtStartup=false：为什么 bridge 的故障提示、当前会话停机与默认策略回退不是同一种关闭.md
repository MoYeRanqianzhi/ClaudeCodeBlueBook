# `Remote Control failed`、`disconnect`、`replBridgeEnabled=false` 与 `remoteControlAtStartup=false`：为什么 bridge 的故障提示、当前会话停机与默认策略回退不是同一种关闭

## 用户目标

不是只知道 Claude Code 里“有时会提示 `Remote Control failed`、有时会看到 `Remote Control disconnected.`、有时桥又会自己停掉、设置里还能把 `Enable Remote Control for all sessions` 关掉”，而是先分清四类不同对象：

- 哪些只是 bridge 的故障提示信号。
- 哪些是在停掉当前会话里的 bridge。
- 哪些是在把当前 bridge 自动熔断停机。
- 哪些是在修改以后新会话的默认 remote-control 策略。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“关闭 bridge”：

- `Remote Control failed`
- `Remote Control failed to connect: ...`
- `Remote Control disconnected.`
- `replBridgeEnabled = false`
- `/remote-control` 的 disconnect
- Bridge Dialog 里的 `d`
- `remoteControlAtStartup = false`

## 第一性原理

bridge 的“关闭”至少沿着四条轴线分化：

1. `Failure Signal`：系统是在告诉你出错了，还是在告诉你已经按你的要求停掉了。
2. `Current Session Stop`：当前这一条 session 里的 bridge 现在要不要继续跑。
3. `Auto-disable Fuse`：系统是不是因为持续失败而短暂熔断，停止继续重试。
4. `Future Default Policy`：以后新会话默认还要不要自动带起 remote-control。

因此更稳的提问不是：

- “bridge 现在是不是被关了？”

而是：

- “我现在看到的是故障提示、当前会话停机、自动熔断，还是默认策略回退；它影响的是当前这条 session，还是未来所有 session？”

只要这四条轴线没先拆开，正文就会把 failed、disconnect、auto-disable 和设置回退写成同一种关闭。

## 第一层：`Remote Control failed` 是故障提示，不是手动断开结果

### `useReplBridge` 会先发出失败通知，而不是先宣布“已断开”

`useReplBridge.tsx` 里有一条专门的：

- `notifyBridgeFailed(detail?)`

它会立即发出：

- `Remote Control failed`

并带可选 detail。

这说明系统先回答的问题不是：

- “用户刚刚是不是要求断开了 bridge”

而是：

- “bridge 当前遇到了失败条件，用户需要知道”

### init 失败还会额外写一条 transcript warning

同一个 hook 在 init 失败路径上，还会向消息流里追加：

- `Remote Control failed to connect: ...`

这说明产品把“失败信号”至少拆成了两层：

- notification
- transcript warning

而不是：

- 一个统一的“已关闭”结果文案

### 所以 failed 的对象首先是“异常”，不是“已按要求停机”

更稳的理解是：

- `Remote Control failed`：系统在告警
- `Remote Control disconnected.`：系统在确认一次手动停机动作

二者不能互相替代。

## 第二层：failed 后的 `replBridgeEnabled=false` 是自动熔断，不是用户显式断开

### 失败路径会在短暂窗口后自动清掉 `replBridgeEnabled`

`useReplBridge.tsx` 在 `failed` 与 init 失败路径上，都会：

- 先写 `replBridgeError`
- 再在短暂 dismiss 窗口后把 `replBridgeEnabled` 清成 `false`
- 同时清掉 `replBridgeError`

这说明这里解决的问题不是：

- “用户现在想不想主动断开”

而是：

- “既然桥反复失败，就不要继续无止境重试”

### auto-disable 是保护性刹车，不是成功完成的关闭动作

更准确的理解应是：

- failure signal 先告诉你“出了问题”
- auto-disable 再告诉系统“先停一下，不要继续重试”

它的语义不是：

- `disconnect` 已成功完成

而是：

- 因故障而被动停止继续运行

### 因而 `replBridgeEnabled=false` 这个结果本身并不说明是谁触发了停机

只看最后状态，下面这些路径都可能让它变成 `false`：

- 手动断开
- 失败后自动熔断
- 设置面把默认 remote-control 关掉并同步当前会话

所以正文不能把：

- `enabled = false`

直接翻译成：

- “用户刚刚断开了 bridge”

## 第三层：`/remote-control` 的 disconnect 是当前会话停机，不是故障提示

### `/remote-control` 在已连接时会进入 disconnect dialog

`commands/bridge/bridge.tsx` 里：

- 当前已经 `replBridgeConnected || replBridgeEnabled`
- 且不是 outbound-only

时，会进入：

- `BridgeDisconnectDialog`

这说明 `/remote-control` 的第二次进入，解决的问题不是：

- “bridge 有没有失败”

而是：

- “当前这条 session 要不要继续保持 remote-control”

### 这个手动 disconnect 会显式重写当前会话状态

同一文件的 disconnect handler 会把当前状态重写成：

- `replBridgeEnabled = false`
- `replBridgeExplicit = false`
- `replBridgeOutboundOnly = false`

并返回：

- `Remote Control disconnected.`

这说明它是非常标准的：

- current-session stop

而不是：

- failure recovery signal

### 因而 `/remote-control` 的 disconnect 应理解为“我现在要停”

更稳的区分是：

- failed：系统告诉你桥出错了
- `/remote-control` disconnect：你告诉系统现在停掉这一条 session 的 bridge

## 第四层：Bridge Dialog 里的 `d` 还可能顺便改掉未来默认，不只是停当前会话

### Bridge Dialog 的 `d` 先停当前桥

`BridgeDialog.tsx` 里，按 `d` 会先把：

- `replBridgeEnabled = false`

写回当前 `AppState`。

所以它至少也属于：

- current-session stop

### 但在 explicit 路径下，它还会持久化 `remoteControlAtStartup=false`

同一处逻辑里，如果当前 bridge 是：

- `explicit`

它还会：

- `saveGlobalConfig(...)`
- 把 `remoteControlAtStartup` 写成 `false`

这说明 Bridge Dialog 的 `d` 回答的问题，实际上比普通 disconnect 更厚一层：

- 当前这条 session 先停
- 以后新 session 默认也别再自动带起

### 所以“Bridge Dialog 断开”与“只断当前 session”不是同一句话

更稳的区分是：

- `/remote-control` disconnect：当前会话停机语义更强
- Bridge Dialog `d`：可能同时触发当前停机与未来默认回退

只要这一层没拆开，正文就会把：

- 当前会话 stop
- future default policy rollback

压成一个动作。

## 第五层：`remoteControlAtStartup=false` 是未来默认策略，不是对失败原因的解释

### Settings 里的 `Enable Remote Control for all sessions` 管的是未来默认

`Settings/Config.tsx` 里，这个选项的对象一直是：

- `remoteControlAtStartup`

并支持：

- `true`
- `false`
- `default`

它回答的问题是：

- 以后新 session 默认怎么带起 remote-control

而不是：

- 当前这一条 bridge 为什么失败

### 设置面虽然会同步当前 `AppState`，但对象仍然是策略面

同一处代码在写完设置后，还会：

- 重新求 `resolved = getRemoteControlAtStartup()`
- 让当前 `AppState` 立即跟上

这会让读者很容易误判成：

- “设置 false 就是在给当前失败做解释”

但更准确的理解应是：

- 这是策略面写入
- 顺便让当前会话尽快跟随新策略

而不是：

- 把 failed / disconnected 重新命名成了 settings change

### 因而 `remoteControlAtStartup=false` 不应被写成关闭结果

更稳的表述是：

- 它是 future default policy
- 可能影响当前
- 但不等于当前失败信号，也不等于手动断开结果

## 第六层：footer、notification、dialog、system message 不是同一种停机展示面

### failed 主走 notification，不走 footer 成功词

`PromptInputFooter.tsx` 里已经明确写出：

- failed state 走 notification
- 不走 footer pill

这说明系统自己就不愿把：

- 故障

继续压在：

- footer 的低占位状态词

里。

### disconnect 则主要通过 system message 和 dialog 结果表达

`commands/bridge/bridge.tsx` 的手动 disconnect 会返回：

- `Remote Control disconnected.`

而 Bridge Dialog 则更像：

- inspect / disconnect / policy rollback 的交互面

这说明产品从展示面就承认：

- failed
- disconnected
- policy rollback

本来就不该用同一种表述。

### 因而“桥没亮了”并不足以说明是哪一种关闭

更稳的判断仍要看：

- 是 notification 先出现
- 还是 system message 在确认手动动作
- 还是 settings / dialog 在改未来默认

## 第七层：稳定主线、条件面与内部面要继续保护

### 稳定可见或相对稳定可见的

- `Remote Control failed`
- `Remote Control failed to connect: ...`
- `Remote Control disconnected.`
- 手动 disconnect、自动熔断、默认策略回退是不同对象
- Bridge Dialog 的 `d` 可能同时影响当前与未来

这些都适合进入 reader-facing 正文。

### 条件公开或应降权写入边界说明的

- Bridge Dialog 的默认回退只在 explicit 路径下触发
- settings 改动会同步当前 `AppState`
- outbound-only / implicit 路径下关闭语义可能更薄

### 更应留在实现边界说明的

- failure fuse 的具体毫秒数
- 连续 init failure 的上限计数
- 各条失败路径具体先写哪个字段、后清哪个字段
- 所有 overlay / notification priority 的实现细枝末节

这些内容只保留为作者判断依据，不回流正文主线。

## 最后的判断公式

当你看到 failed、disconnect、`replBridgeEnabled=false` 或 `remoteControlAtStartup=false` 时，先问七个问题：

1. 我现在看到的是故障提示，还是停机结果？
2. 当前 bridge 是被用户主动断开，还是被系统因为失败而熔断？
3. 这次变化只影响当前 session，还是连未来默认也改了？
4. `replBridgeEnabled=false` 是结果字段，还是足以解释原因的对象？
5. 当前展示面是 notification、system message、dialog，还是 settings policy？
6. 我是不是把手动 disconnect 与 failed 混成了同一种关闭？
7. 我是不是又把当前会话停机与未来默认策略回退压成了一个动作？

只要这七问先答清，就不会把 bridge 的故障提示、当前会话停机与默认策略回退写糊。

## 源码锚点

- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooter.tsx`
- `claude-code-source-code/src/components/BridgeDialog.tsx`
- `claude-code-source-code/src/commands/bridge/bridge.tsx`
- `claude-code-source-code/src/components/Settings/Config.tsx`
- `claude-code-source-code/src/bridge/types.ts`
