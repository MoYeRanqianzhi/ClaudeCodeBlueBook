# `handleIngressMessage`、`recentPostedUUIDs`、`recentInboundUUIDs` 与 `onInboundMessage`：为什么 outbound echo drop、inbound replay guard 与 non-user ignore 不是同一种 ingress consumer contract

## 用户目标

55 已经把 bridge 的多层防重拆成：

- outbound echo filter
- inbound replay guard

190 又把桥接写入入口拆成：

- REPL write contract
- daemon write contract

但如果正文停在这里，读者还是很容易把 `handleIngressMessage(...)` 这条共享 ingress reader 写平：

- 不就是先解析一条 ingress message，再决定要不要处理吗？
- `recentPostedUUIDs` 和 `recentInboundUUIDs` 不都是在“防重复”吗？
- non-user message 被忽略，不也是 dedup 的一种结果吗？
- 既然最终都是“不要把某条消息再交给 REPL”，为什么还要继续拆分？

这句还不稳。

从当前源码看，至少还要继续拆开四种不同 consumer contract：

1. control bypass
2. outbound echo drop
3. inbound replay guard
4. non-user ignore

如果这四层不先拆开，后面就会把：

- `control_response`
- `control_request`
- `recentPostedUUIDs`
- `recentInboundUUIDs`
- `onInboundMessage`

重新压成一句模糊的“ingress 去重/过滤逻辑”。

## 第一性原理

更稳的提问不是：

- “这条 ingress handler 不就是在决定哪些消息别再处理吗？”

而是先问六个更底层的问题：

1. 当前分支在回答“这条 payload 是谁的控制通道”，还是“这条 SDK message 是否该进入用户输入链”？
2. 当前过滤是在判断“这是我自己刚写出去的 echo”，还是“这是 server 重放过来的旧 inbound prompt”？
3. 当前忽略一条消息，是因为它已经被消费过，还是因为它根本不属于 `onInboundMessage` 的 consumer domain？
4. 当前 UUID 集合是在服务 outbound echo 语义，还是 inbound replay 语义？
5. 当前路径是在保护 REPL 的 prompt 注入链，还是在处理 permission/control side-channel？
6. 我现在分析的是 55 的去重家族，还是 `handleIngressMessage(...)` 作为一个 reader 为什么内部已经分成不同合同？

只要这六轴不先拆开，后面就会把：

- control routing
- echo drop
- replay guard
- non-user ignore

混成一张“ingress 过滤表”。

## 第一层：`control_response` / `control_request` 先是 side-channel bypass，不是 SDK message consumer

`bridgeMessaging.ts` 的 `handleIngressMessage(...)` 一上来先做的不是：

- `isSDKMessage(parsed)`

而是先检查：

- `isSDKControlResponse(parsed)`
- `isSDKControlRequest(parsed)`

命中后就分别：

- `onPermissionResponse?.(parsed)`
- `onControlRequest?.(parsed)`
- `return`

这说明这些分支回答的问题首先是：

- 这条 ingress payload 属于 permission / control side-channel，应由哪条控制消费链接住

它们不是在回答：

- 这条消息是不是该进入普通 `onInboundMessage` prompt 流

所以更准确的理解不是：

- ingress 先统一看 UUID，再决定怎么处理

而是：

- control payload 连 SDK message reader 都不会进入

## 第二层：`recentPostedUUIDs` 回答的是 outbound echo drop，不是 inbound replay guard

当 payload 已经通过 `isSDKMessage(parsed)`，
handler 才会开始看 UUID。

第一道 UUID 过滤是：

- `if (uuid && recentPostedUUIDs.has(uuid))`

命中后日志也直接写成：

- `Ignoring echo`

这说明这层回答的问题不是：

- 这条 inbound prompt 是否已经被转发过

而是：

- 这是不是我自己刚刚写出去、现在被 server / worker 弹回来的 echo

更准确地说：

- 这是 outbound echo drop

不是 generic dedup。

## 第三层：`recentInboundUUIDs` 回答的是 inbound replay guard，也不是同一种“已发过就丢”

只有没撞上 `recentPostedUUIDs`，
handler 才继续看：

- `if (uuid && recentInboundUUIDs.has(uuid))`

命中后日志明确写成：

- `Ignoring re-delivered inbound`

旁边注释也写得很硬：

- drop inbound prompts we've already forwarded
- 场景包括 seq-num negotiation failure、server replayed history、transport swap races

这说明它回答的问题不是：

- 这是我自己刚发出的 echo 吗

而是：

- 这是 server 又送来的一条旧 inbound prompt 吗

所以更准确的理解不是：

- `recentPostedUUIDs` / `recentInboundUUIDs` 只是两张内容不同的同类 dedup 表

而是：

- 一个面向 outbound echo
- 一个面向 inbound replay

## 第四层：`parsed.type === 'user'` 才触发 `onInboundMessage`，说明 non-user ignore 不是 dedup，而是 consumer-domain narrowing

通过前两道 UUID 过滤后，
handler 还不会立即：

- `onInboundMessage?.(parsed)`

它还要继续判断：

- `if (parsed.type === 'user')`

只有这时才会：

- 先把 UUID 加进 `recentInboundUUIDs`
- 再 fire-and-forget `onInboundMessage`

否则就直接：

- `Ignoring non-user inbound message`

这说明更准确的理解不是：

- non-user inbound 只是没撞上 UUID 去重所以被“顺手忽略”

而是：

- 当前 `onInboundMessage` 的 consumer domain 本来就只吃 user message
- non-user ignore 是 consumer-domain narrowing

不是 dedup 结果。

## 第五层：`recentInboundUUIDs.add(uuid)` 的时机证明它是“转发后护栏”，不是“读到就算处理过”

handler 里只有在：

- `parsed.type === 'user'`

这个分支下，
才会：

- `recentInboundUUIDs.add(uuid)`

这说明它回答的问题不是：

- 只要这条 SDK message 被 parse 过，就算处理过

而是：

- 只有真正进入 user inbound consumer 域的 prompt，才应在后续 replay 中被视作“已转发”

所以更准确的结论不是：

- `recentInboundUUIDs` 是 ingress 总体已读账

而是：

- 它是 onInboundMessage consumer-path 的 replay guard

## 第六层：因此 `handleIngressMessage(...)` 更像一个 triage reader，而不是一个统一 dedup gate

到这里更稳的写法已经不是：

- ingress handler 只是先 parse，再 dedup，再回调

而应该明确拆成：

1. control bypass
   `control_response` -> `onPermissionResponse`
   `control_request` -> `onControlRequest`
2. outbound echo drop
   `recentPostedUUIDs`
3. inbound replay guard
   `recentInboundUUIDs`
4. consumer-domain narrowing
   only `user` reaches `onInboundMessage`

所以更准确的结论不是：

- `handleIngressMessage(...)` 里只有一套“要不要丢”的判断

而是：

- 它本身就是一个多合同 triage reader

## 第七层：为什么这页不是 55 的附录

55 讲的是：

- different dedup families are not the same

191 这一页更窄地关心的是：

- 在同一个 shared ingress consumer 里，
  这些 family 与 type-routing 到底如何分工

也就是说：

- 55 问 family taxonomy
- 191 问 single reader 的 internal contract split

不能压成同一页。

## 第八层：为什么这页也不是 142 的附录

142 讲的是：

- outboundOnly / gray runtime 下，
  `handleIngressMessage(...)` 仍然被 wiring 进 env-based core

191 要补的句子则是：

- 在这条 reader 真正执行时，
  它内部并不是“统一收消息再统一处理”，
  而是四种不同 contract

所以更准确的关系不是：

- 191 只是 142 的一段源码展开

而是：

- 142 讲这条 reader 有没有被挂上去
- 191 讲挂上去之后，这条 reader 自己怎样再分合同

## 稳定面与灰度面

本页只保护稳定不变量：

- control payload 不进入 SDK message consumer
- `recentPostedUUIDs` = outbound echo drop
- `recentInboundUUIDs` = inbound replay guard
- `onInboundMessage` 只消费 user message

本页刻意不展开的灰度层包括：

- `recentInboundUUIDs` 与 sequence handoff 的完整 edge-case 谱系
- outboundOnly / gray runtime 的更大 runtime 分叉
- REPL / daemon 共享这条 reader 的所有 wiring 细节
- viewer 侧 `sentUUIDsRef` 的并行 consumer 路径

这些都相关，但不属于本页的 hard sentence。

## 苏格拉底式自审

### 问：为什么不能把 non-user ignore 写成 dedup 的一个特例？

答：因为它根本不是基于“已经处理过”而被丢掉，而是从一开始就不属于 `onInboundMessage` 这条 consumer domain。

### 问：为什么 `recentPostedUUIDs` 和 `recentInboundUUIDs` 不能一起写成“UUID 去重”？

答：因为它们服务的因果方向完全不同：一个拦 outbound echo，一个拦 inbound replay。压成一层会丢掉 reader contract 的真正分工。

### 问：为什么这页不该继续写成 55 的家族总表？

答：因为 55 已经做完 taxonomy；191 的新增价值在于：同一个 ingress reader 里，家族、类型路由和 callback 域是如何交错分工的。
