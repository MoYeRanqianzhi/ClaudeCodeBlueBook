# `handleIngressMessage`、`control_response/control_request`、`extractInboundMessageFields` 与 `enqueue(prompt)`：为什么 bridge ingress 只有 control 旁路和 user-only transcript adapter，non-user SDKMessage 没有第二消费面

## 用户目标

191 已经说明：

- non-user ignore 不是 dedup 特例

193 又说明：

- control side-channel 在 ingress 上也不是对称总线

但如果正文停在这里，读者还是很容易把 ingress 的 message 面继续写平：

- `handleIngressMessage(...)` 不是已经通过 `isSDKMessage(parsed)` 了吗？那不就说明整条 ingress 本来就在消费广义 `SDKMessage`？
- 非 user message 被忽略，顶多说明这次没处理，不代表这里没有别的消费面吧？
- `onInboundMessage` 不也是拿一个 `SDKMessage` 进来吗？为什么不能把它看成通用 SDK consumer？
- hook 和 print 的下游明明不同，为什么还说这里只有一个 transcript adapter？

这句还不稳。

从当前源码看，还得继续拆开三层不同对象：

1. control bypass
2. user-only transcript adapter
3. adapter 后的 prompt sink

如果这三层不先拆开，后面就会把：

- `SDKMessage`
- `onInboundMessage`
- `extractInboundMessageFields(...)`
- `enqueue(prompt)`

重新压成一句模糊的“bridge 在消费 inbound SDK message”。

## 第一性原理

更稳的提问不是：

- “为什么 non-user `SDKMessage` 在这里没被处理？”

而是先问六个更底层的问题：

1. 当前入口处的宽类型，是为了表达“所有这些对象都会被同一条 consumer 消费”，还是只是为了先做边界判定？
2. 当前这条腿在把一条 frame 继续投给通用事件系统，还是在把 user input 改写成 prompt queue 的载荷？
3. 当前下游消费的关键字段是整条 `SDKMessage`，还是只有 content/uuid 这些 prompt adapter 真正需要的字段？
4. 当前 ignore 一条 non-user message，是因为“暂时没处理”，还是因为系统根本没给它准备第二消费面？
5. hook 和 print 的差异是在对象主语上不同，还是只是 adapter 前处理厚度不同？
6. 我现在分析的是 56 的状态交接，还是 ingress consumer 最终只落到 transcript sink？

只要这六轴不先拆开，后面就会把：

- control frame
- user message
- prompt enqueue

混成一张“ingress SDKMessage 消费表”。

## 第一层：`handleIngressMessage(...)` 在 ingress 上实际只有三条入站面，没有第四条 non-user `SDKMessage` 消费面

`bridgeMessaging.ts` 的 `handleIngressMessage(...)` 里，入站对象先被分成三条腿：

- `control_response`
- `control_request`
- `parsed.type === 'user'`

这三条以外，代码并没有第四条：

- `assistant`
- `result`
- `tool`
- 其他 non-user `SDKMessage`

命中 `isSDKMessage(parsed)` 之后，如果：

- `parsed.type !== 'user'`

就直接：

- `Ignoring non-user inbound message`

这说明这里回答的问题不是：

- “non-user 这次先不处理，稍后可能还有别的 consumer”

而是：

- 这一层的 transcript sink 从定义上就只认 user

所以更准确的理解不是：

- ingress 在消费广义 `SDKMessage`

而是：

- ingress 只有 control 旁路与 user transcript adapter 两大面

## 第二层：`onInboundMessage` 不是通用 SDK consumer，而是 user leg 预留的 transcript callback slot

`initReplBridge.ts` 把同一个：

- `onInboundMessage`

线程化进：

- env-based `initBridgeCore(...)`
- env-less `initEnvLessBridgeCore(...)`

两个 core 自己并没有再给 non-user `SDKMessage` 找第二条路，

只是把 user leg 统一交给这个 callback slot。

这说明 `onInboundMessage` 的真实身份不是：

- “桥接层留给上层的通用 SDK event handler”

而是：

- “桥接层留给上层的 user transcript adapter 接口”

如果它真是通用 SDK consumer，

你会期待看到：

- 多种 `msg.type` 的继续分发
- 或不同 subtype 的并行消费者

但当前 wiring 没有这些。

它只有：

- 一条 user leg 的出口

## 第三层：`extractInboundMessageFields(...)` 把 user-only adapter 再次写死，`SDKMessage` 只是宽外壳

真正把这条 callback 再次收窄的，是：

- `extractInboundMessageFields(msg)`

`inboundMessages.ts` 明确写了：

- `if (msg.type !== 'user') return undefined`
- 没 content 返回 `undefined`
- 空 content blocks 返回 `undefined`

然后它只抽出：

- `content`
- `uuid`

并把 image blocks 做规范化。

这说明在 adapter 眼里，`SDKMessage` 的真实价值不是：

- 保留整条事件对象继续传下去

而是：

- 从宽外壳里抽出 prompt sink 真正需要的最小字段集

所以更准确的理解不是：

- `extractInboundMessageFields(...)` 只是某个可有可无的小工具

而是：

- 它是 user-only transcript adapter 的第二道收窄边界

## 第四层：hook 和 print 虽然前处理厚度不同，但最终都落到 `enqueue(prompt)`

`useReplBridge.tsx` 的 `handleInboundMessage(...)` 流程是：

- `extractInboundMessageFields(msg)`
- 可选 `sanitizeInboundWebhookContent(...)`
- `resolveAndPrepend(...)` 处理 attachments
- 最后 `enqueue({ value: content, mode: 'prompt', uuid, skipSlashCommands: true, bridgeOrigin: true })`

`print.ts` 里的 bridge 路径也一样：

- `extractInboundMessageFields(msg)`
- 直接 `enqueue({ value: content, mode: 'prompt', uuid, skipSlashCommands: true })`

两边前处理厚度不同：

- hook 更厚，会做 attachment resolve 与 webhook sanitize
- print 更薄，直接把已收窄内容推进 stdin/output loop

但两边真正兑现的对象主语完全一样：

- prompt queue

所以更准确的理解不是：

- hook / print 各有一套 inbound 语义

而是：

- 它们共享同一个 user-only transcript sink，只是在入队前做不同厚度的预处理

## 第五层：attachment resolve 不是第二消费面，而是 transcript adapter 的前处理

最容易被误判的地方是：

- `resolveInboundAttachments(...)`
- `resolveAndPrepend(...)`

看上去像开出了另一条 attachment consumer 面。

但 `inboundAttachments.ts` 写得很清楚：

- 它只是从 `file_attachments` 提取引用
- resolve 成 path refs
- prepend 回已有 content

也就是说它并没有把 message 改送去别的系统，

只是把：

- user transcript payload

改写成：

- 更适合 prompt queue 消费的 payload

所以 attachment resolve 不是第四条 consumer。

它只是：

- user-only transcript adapter 的 richer pre-processing

## 第六层：这页不是 56，也不是 142、191 或 193

这页最容易和四篇旧文混写。

先和 56 划清：

- 56 讲的是握手、提问、作答、撤销与回合收口这些 phase handoff
- 194 讲的是 ingress 一旦落到 transcript sink，为什么只剩 user-only prompt adapter

56 的主语是：

- turn / phase handoff

194 的主语是：

- transcript consumer shape

再和 142 划清：

- 142 讲 gray runtime wiring
- 194 不讲 mirror / outboundOnly 有没有一路传到底层，只讲即便 wiring 已成立，`SDKMessage` 这条腿也不是通用事件面

再和 191 划清：

- 191 的负判断是 non-user ignore 不是 dedup 特例
- 194 的正判断是：之所以 ignore，是因为这里根本没有 non-user 的第二消费面

最后和 193 划清：

- 193 讲 control side-channel 的 callback asymmetry
- 194 讲 user leg 为什么最后只落到 transcript adapter

193 的主语是：

- control 两腿为什么不对称

194 的主语是：

- user 这一腿为什么没有 sibling consumer

如果把这些层重新压平，就会把：

- control 旁路
- user adapter
- prompt sink

又写成一句模糊的“bridge 在处理 inbound SDKMessage”。

## 第七层：稳定层、条件层与灰度层

### 稳定可见

- bridge ingress 当前只有 control 旁路和 user-only transcript adapter，没有第四条 non-user `SDKMessage` 消费面。
- `onInboundMessage` 当前不是通用 SDK consumer，而是 user leg 的 transcript callback slot。
- `extractInboundMessageFields(...)` 当前是 user-only transcript adapter 的第二道 narrowing，不是可有可无的小工具。
- hook / print 当前共享同一个 `enqueue(prompt)` sink，只是在入队前有不同厚度的预处理。
- attachment resolve 当前只是 transcript adapter 的前处理，不是新的第二消费面。

### 条件公开

- hook / print 的前处理厚度差异，仍取决于当前宿主与消费路径。
- attachment resolve、webhook sanitize 等 richer pre-processing 是否参与，仍取决于当前 adapter route，而不是这页已经稳定暴露的 user-only consumer 合同。
- future build 会不会给 non-user `SDKMessage` 新开第二消费面，仍取决于当前 ingress consumer 设计，而不是这页已经稳定暴露的边界。

### 内部/灰度层

- `extractInboundMessageFields(...)` 的 exact 抽取细节
- `enqueue(prompt)` 之前的 helper 调用顺序
- hook / print 各自 richer pre-processing 的具体 wiring
- attachment resolve 与其他 normalization 的内部组合细节

所以这页最稳的结论必须停在：

- bridge ingress 的消息面只兑现 user-only transcript adapter
- non-user `SDKMessage` 在这里没有第二消费面

而不能滑到：

- 这里只是暂时没处理 non-user `SDKMessage`，以后自然会接到同一条通用 consumer 上

## 结论

所以这页能安全落下的结论应停在：

- `SDKMessage` 在 bridge ingress 上只是边界处的宽类型外壳
- 系统真正兑现的只有 `user -> extractInboundMessageFields(...) -> enqueue(prompt)` 这一条 transcript adapter
- hook 与 print 只是这条 adapter 的厚版和薄版
- 其他 non-user `SDKMessage` 在这里没有第二消费面

一旦这句成立，就不会再把：

- `onInboundMessage`
- `extractInboundMessageFields(...)`
- `enqueue(prompt)`

写成通用 SDK event pipeline。
