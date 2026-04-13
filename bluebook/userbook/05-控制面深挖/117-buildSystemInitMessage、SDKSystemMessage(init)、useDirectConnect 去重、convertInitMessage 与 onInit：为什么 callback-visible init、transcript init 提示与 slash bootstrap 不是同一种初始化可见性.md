# `buildSystemInitMessage`、`SDKSystemMessage(init)`、`useDirectConnect` 去重、`convertInitMessage` 与 `onInit`：为什么 callback-visible init、transcript init 提示与 slash bootstrap 不是同一种初始化可见性

## 用户目标

116 已经把：

- visible result
- turn-end 判定
- busy state

拆成了三层 completion signal。

接着往下读时，读者又很容易把另一组相邻概念压成一句：

- `system.init` 进入 callback
- `useDirectConnect` 里只显示一次
- adapter 把它转成 “Remote session initialized”
- remote session 又会拿它做 `slash_commands` bootstrap

于是正文就会滑成一句错误总结：

- “初始化消息出现一次，就是同一个 init 被不同地方复用显示一下而已。”

从当前源码看，这也不成立。

同一个 `system.init` 至少同时承担四种不同职责：

1. 作为 SDK metadata object 暴露会话能力面
2. 作为 callback-visible object 进入宿主 hook
3. 作为 host-local dedupe target 避免重复初始化提示
4. 作为 transcript 提示或 slash bootstrap 输入，被不同 consumer 继续投影

这四者都与“初始化被看见”有关，但不是同一种初始化可见性。

## 第一性原理

更稳的提问不是：

- “init 有没有显示出来？”

而是先问五个更底层的问题：

1. 当前说的是 metadata object，还是用户看到的一条提示消息？
2. 当前消费的是 raw `sdkMessage`，还是 adapter 投影后的 `Message`？
3. 当前宿主要解决的是重复显示，还是初始化能力引导？
4. 当前要保留的是全量 metadata，还是只保留一句面向人看的提示？
5. 当前初始化是稳定公开合同，还是 feature-gated / host-specific 投影？

只要这五轴先拆开，后面几件事就不会再被写成同一层 init visibility。

## 第一层：`system.init` 先是 public SDK metadata object，不是“提示文案”

`SDKSystemMessageSchema` 明确把 `system/init` 定义成一类稳定 SDK message：

- `type: 'system'`
- `subtype: 'init'`
- 携带 `cwd`
- `model`
- `tools`
- `mcp_servers`
- `permissionMode`
- `slash_commands`
- `skills`
- `plugins`

`buildSystemInitMessage(...)` 的注释也把主语写得很清楚：

- 它是 SDK 流的第一条消息
- 承载 session metadata
- remote clients 用它来 render pickers 和 gate UI

所以 `system.init` 的第一层语义不是：

- “告诉用户远端会话已经初始化”

而是：

- “给 consumer 一份初始化能力元数据对象”

这点非常关键。

因为如果第一层主语写错了，后面所有 transcript 提示、dedupe、bootstrap 都会被误写成 init 本体。

## 第二层：builder 还能按宿主重投影 init，但这不等于 init 本体变化

`buildSystemInitMessage(...)` 还显式说明：

- QueryEngine 路径会把它作为每个 query turn 的第一条 SDK message
- `useReplBridge` 路径也会单独写这条消息到 REPL bridge wire

但 `useReplBridge.tsx` 同时又给出一个更细的事实：

- 这条 bridge init 还受 `tengu_bridge_system_init` feature gate 控制
- tools / mcpClients / plugins 会被 redacted

也就是说：

- `system.init` 作为 message family 是稳定公开的
- 不同宿主发出的 init payload 宽度却可以不同

这说明：

- init object visibility

本身就已经不是单一厚度。

更准确的写法应是：

- public SDK init contract 是一层
- host-specific projected init payload 是下一层

不是：

- 所有 init 在所有宿主里天然同宽

## 第三层：direct-connect manager 会把 `system.init` forward 到 callback，但 callback-visible 不等于 transcript-visible

`DirectConnectSessionManager` 对 SDK messages 的 forward 规则很宽：

- 它排除了 control、keep_alive、`streamlined_*`
- 以及 `post_turn_summary`
- 其余 `assistant / result / system / ...` 都会 `onMessage(parsed)`

这意味着：

- `system.init` 在 direct connect 中是 callback-visible 的

但 callback-visible 仍然不等于：

- transcript 一定原样显示

因为 object 一旦进入 hook，还会继续经过：

- host-local gating
- adapter projection
- sink admission

这一步的主语只是：

- raw init object 进入了 direct-connect callback 面

不是：

- 用户已经看见了完整 init 信息

## 第四层：`useDirectConnect` 的去重回答的是 host-local duplicate suppression，不是 init metadata contract

`useDirectConnect.ts` 在 `onMessage` 里对 `system.init` 做了一步很重要的本地处理：

- `hasReceivedInitRef`
- 如果已经收过 `init`，后续同 subtype 直接 return

注释也说得很直白：

- server sends one per turn

这一步在回答的不是：

- `system.init` 是不是合法 SDK object
- 这条 init 该不该作为 callback message 出现

而是在回答：

- 当前宿主是否还要再次把后续 turn 的 init 投进本地 transcript / sink

所以这一步的主语是：

- host-local duplicate suppression

不是：

- init object visibility 本身

这也是为什么同一个 raw init：

- 在 callback 面可能多次到达
- 却在当前 hook 里只让第一条继续往下走

所以不能写成：

- direct connect 里 init 只存在一次

更准确的写法是：

- direct connect 当前只消费第一条 init 到 transcript path

## 第五层：`convertInitMessage(...)` 只是 transcript projection，不是 init metadata 的镜像保留

adapter 里的 `convertInitMessage(...)` 非常值得单列。

因为一旦到这里，原始 `system.init` 里那些 metadata：

- `cwd`
- `tools`
- `mcp_servers`
- `slash_commands`
- `skills`
- `plugins`

都没有原样保留下来。

它只投影成一句：

- `Remote session initialized (model: ${msg.model})`

于是 `sdkMessageAdapter.ts` 对 `system/init` 做的是：

- `type: 'message'`
- `message: convertInitMessage(msg)`

这说明：

- transcript init 提示

只是 raw init metadata 的一种人类可读摘要投影。

它回答的是：

- “在正文里给用户一个初始化提示要怎么写”

不是：

- “初始化元数据对象完整长什么样”

所以更准确的写法应是：

- raw init object 是一层
- transcript init prompt 是下一层

不是：

- init prompt 就是 init object 的普通显示形式

## 第六层：`useRemoteSession` 直接消费 raw init 做 slash bootstrap，又是另一层

`useRemoteSession.ts` 给了一个特别值钱的对照。

它在收到 raw `sdkMessage` 时，会先检查：

- `sdkMessage.type === 'system'`
- `sdkMessage.subtype === 'init'`

如果 `onInit` 存在，就直接：

- `onInit(sdkMessage.slash_commands)`

也就是说，在 remote session 里，同一个 raw init object 还会作为：

- slash command bootstrap input

被直接消费。

这一步根本不依赖：

- `convertInitMessage(...)`
- `converted.type === 'message'`

更不依赖：

- 把 init 提示追加进 transcript

所以这里又多出一层：

- capability bootstrap consumer

它和 transcript prompt 的主语完全不同。

一个要保留：

- raw metadata 里的 `slash_commands`

另一个只保留：

- “Remote session initialized (model: ...)”

这正是“同一个 init，在不同 consumer 里被不同厚度投影”的硬证据。

## 第七层：viewer/history replay 会继续把 init 投成 message，但这仍然不等于 bootstrap

`useAssistantHistory.ts` 的 `pageToMessages(page)` 直接把历史页里的 event 通过：

- `convertSDKMessage(...)`

转成 `Message[]`

而 `convertSDKMessage(...)` 对 `system.init` 的规则是稳定的：

- 返回 `message`

这意味着历史 / viewer replay 路上，init 依然可能被投成一条 transcript message。

但它不会天然恢复：

- `useRemoteSession` 那种 raw init -> `onInit(slash_commands)` 的 bootstrap 动作

所以 even in replay path：

- init prompt visibility

也不等于：

- init bootstrap visibility

更不能写成：

- “历史里能看到 init，就说明初始化能力面也跟着被恢复了一遍”

## 第八层：所以至少有四种 init visibility

把上面几层压实之后，更稳的总表是：

| 层级 | 当前回答什么 | 典型例子 |
| --- | --- | --- |
| SDK metadata visibility | 初始化元数据对象本来有哪些字段 | `SDKSystemMessage(init)` / `buildSystemInitMessage(...)` |
| callback visibility | 哪些宿主能先拿到 raw init object | direct-connect manager `onMessage(parsed)` |
| transcript visibility | 用户在正文里看到什么初始化提示 | `convertInitMessage(...)` -> `Remote session initialized (model: ...)` |
| capability bootstrap visibility | 哪些 consumer 直接吃 raw init metadata 做 UI 初始化 | `onInit(sdkMessage.slash_commands)` |

再往里还有一层：

- host-local duplicate suppression

它决定：

- 某条已经 callback-visible 的 init，还要不要继续进当前 transcript path

所以真正该写成一句话的是：

- callback-visible init
- transcript init prompt
- slash bootstrap
- host-local dedupe

不是同一种初始化可见性。

## 第九层：稳定层、条件层与灰度层

### 稳定可见

- same init object != same initialization visibility
- `system.init` 当前是 public SDK schema 的一部分，而不是 direct connect 私有消息
- direct connect 当前会拿到 raw init object
- `useDirectConnect` 当前会去掉后续重复 init
- `convertInitMessage(...)` 当前只保留 model 提示，不镜像保留全量 metadata
- `useRemoteSession` 当前会直接从 raw init 提取 `slash_commands`

### 条件公开

- 所有宿主是否都会像 `useRemoteSession` 一样把 init 用作 bootstrap，仍取决于当前 host/consumer route
- viewer/history attach 是否一定恢复同样的 bootstrap 副作用，仍取决于当前 attach/replay path
- REPL bridge 的 gated/redacted init 是否对所有 build 生效，也仍是条件化实现问题

### 内部/灰度层

- `useDirectConnect` 去重 init 的 exact helper 顺序与 host wiring
- `convertInitMessage(...)` 的裁剪细节与未来 redaction 策略
- REPL bridge 上 gated/redacted init 的 exact build wiring

所以这页最稳的结论必须停在：

- same init object != same initialization visibility

而不能滑到：

- all hosts share one universal init contract in practice

## 第十层：为什么 117 不能并回 116

116 的主语是：

- result family 在 transcript、turn-end 和 busy-state 里不是同一种 completion semantics

117 的主语已经换成：

- init family 在 metadata、callback、dedupe、transcript prompt 与 bootstrap 里不是同一种 initialization visibility

前者讲：

- completion split

后者讲：

- initialization split

不是一页。

## 第十一层：为什么 117 也不能并回 115

115 的主语是：

- adapter 内不同 consumer policy

117 虽然也经过 adapter，但核心冲突已经不在 adapter 内部，而在：

- raw init object
- host-local dedupe
- transcript projection
- bootstrap consumer

这些层次之间。

所以这页不是：

- another adapter policy page

而是：

- one init object across multiple consumer layers

## 第十二层：最常见的假等式

### 误判一：`system.init` 在 direct connect 里只出现一次

错在漏掉：

- server sends one per turn
- 当前只是 hook 用 `hasReceivedInitRef` 把后续重复项截掉

### 误判二：`convertInitMessage(...)` 就是 init 的普通显示形式

错在漏掉：

- 它只保留 model 提示，不保留全量 metadata

### 误判三：历史里能看到 init 提示，就说明 slash command bootstrap 也恢复了

错在漏掉：

- replay path 和 raw init -> `onInit(slash_commands)` 是两种不同 consumer

### 误判四：`system.init` 既然是 public SDK object，各宿主里一定同宽出现

错在漏掉：

- `useReplBridge` 的 feature gate 和 redaction 说明 payload 宽度可以按宿主重投影

### 误判五：callback-visible init 就等于用户看到了初始化内容

错在漏掉：

- callback、dedupe、adapter 和 transcript 之间还有多层收窄

## 第十三层：苏格拉底式自审

### 问：我现在写的是 metadata object、callback、transcript，还是 bootstrap？

答：如果答不出来，就说明又把 init visibility 写平了。

### 问：我是不是把 dedupe 写成了 init object 本体只出现一次？

答：如果是，就漏掉了“server sends one per turn”这句注释。

### 问：我是不是把 init prompt 写成了 full metadata projection？

答：如果是，就回到 `convertInitMessage(...)` 只保留 model 的事实。

### 问：我是不是把 `onInit(slash_commands)` 当成 transcript 副作用？

答：如果是，就还没把 raw init consumer 和 adapter message consumer 分开。
