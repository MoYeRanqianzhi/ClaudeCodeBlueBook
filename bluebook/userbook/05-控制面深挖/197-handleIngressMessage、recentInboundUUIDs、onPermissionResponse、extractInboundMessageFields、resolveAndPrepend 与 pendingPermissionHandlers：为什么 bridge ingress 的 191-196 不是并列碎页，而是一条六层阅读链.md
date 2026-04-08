# `handleIngressMessage`、`recentInboundUUIDs`、`onPermissionResponse`、`extractInboundMessageFields`、`resolveAndPrepend` 与 `pendingPermissionHandlers`：为什么 bridge ingress 的 191-196 不是并列碎页，而是一条六层阅读链

## 用户目标

191 到 196 连着拆完之后，读者最容易出现一种新的误判：

- “这些页都在讲 bridge ingress，应该是六篇平行小文，按兴趣挑一篇读就行。”

这句话看似高效，

其实会让后面的很多句子重新塌掉。

因为 191-196 不是六个并列主题，

而是一条不断收窄主语的阅读链：

1. 先定共享 reader 的边界
2. 再定 reader 外部的 continuity 边界
3. 再拆 control leg
4. 再拆 user leg
5. 再拆 user leg 内部 normalization
6. 最后才拆 permission leg 内部的本地 verdict ledger

如果这个顺序不先写死，读者就会：

- 直接跳到 195 看 attachment
- 或直接跳到 196 看 pending handlers

然后再把 191-194 全都误写成“上文背景介绍”。

这句还不稳。

所以这里需要的不是再补一篇新的运行时正文，

而是补一页结构收束：

- 为什么 191-196 不是并列碎页，而是一条六层阅读链

## 第一性原理

更稳的提问不是：

- “这六页都在讲 ingress，我该先看哪篇？”

而是先问六个更底层的问题：

1. 我现在卡住的是“同一个 reader 里有哪些路”，还是“这条 reader 外面的 replay state 怎么延续”？
2. 我现在问的是 control leg 自身，还是 user leg 自身？
3. 我现在问的是 transcript adapter 的主句，还是 adapter 内部的前处理？
4. 我现在问的是 permission leg 的 transport callback，还是 permission leg 内部的本地 ownership？
5. 我现在需要的是一个任务入口路径，还是一个局部子系统的阅读顺序？
6. 我是不是已经把“目录导航”和“正文主语”混成一件事了？

只要这六轴不先拆开，

后面就会把：

- 191 的 reader boundary
- 192 的 continuity boundary
- 193 的 control callback asymmetry
- 194 的 transcript adapter
- 195 的 normalization split
- 196 的 verdict ledger

重新压成一句模糊的：

- “bridge ingress 有很多细节”

## 第一层：191 不是“细节之一”，而是整组阅读链的 reader boundary

191 先回答的是：

- `handleIngressMessage(...)` 这个共享 reader 内部到底先裂成哪几条 consumer contract

它把：

- control bypass
- outbound echo drop
- inbound replay guard
- non-user ignore

先分开。

如果这一层没先读，

后面你会把 193、194、195、196 全都误当成：

- 对同一条“message path”的不同旁证

但事实不是。

191 的作用是给整组阅读链划出最上游边界：

- ingress reader 里先有哪些不同腿

所以 191 必须最先读。

## 第二层：192 不是 replay 细节，而是 reader 外部 continuity boundary

192 继续问的是：

- 既然 reader 内部已经有 replay guard，那 reader 外部这张 replay state 在 same-session / fresh-session 下怎么保留或归零

它把：

- `lastTransportSequenceNum`
- `recentInboundUUIDs`

从 transport lifecycle 里重新抽出来，落回：

- session incarnation

这一步如果不先读，

后面你会很容易把 193-196 里所有读入路径都当成：

- 发生在同一种 continuity 背景里

这也不对。

192 的作用是把整组阅读链的第二层边界固定下来：

- reader boundary 之外，还有一层 continuity boundary

## 第三层：193 不是 permission 细节，而是 control leg 的 callback asymmetry

在 191-192 之后，才轮得到问：

- control 这条腿自身在 ingress 上是什么形状

193 的主语是：

- `control_response -> onPermissionResponse`
- `control_request -> onControlRequest -> handleServerControlRequest(...)`

也就是说，

193 不是 generic control taxonomy，

而是整条阅读链里：

- control leg 的第一层内部拆分

如果这一层不先读，

你再看 196 的 `pendingPermissionHandlers`，

就会把它误写成：

- 只不过是 control callback map 的某种实现

但 196 实际上只属于：

- 193 里 permission verdict leg 的更窄下游

## 第四层：194 不是 191 的重复，而是 user leg 的正向主句

191 里已经有一句：

- non-user ignore 不是 dedup 特例

但 194 继续往前推进，回答的是：

- user 这条腿最后到底落成什么 consumer 形状

它把：

- `onInboundMessage`
- `extractInboundMessageFields(...)`
- `enqueue(prompt)`

连成一条正向主句：

- bridge ingress 真正兑现的是 user-only transcript adapter

这一步如果不先读，

你再看 195 的 normalization，

就会把 image block repair / attachment prepend 误写成：

- 独立 consumer
- 或新的 ingress 腿

但 195 其实只属于：

- 194 里 transcript adapter 的内部前处理

## 第五层：195 不是 attachment 小技巧，而是 user leg 内部的 normalization split

195 接在 194 后面，专门回答：

- 同属 user transcript adapter，为什么 `normalizeImageBlocks(...)` 和 `resolveAndPrepend(...)` 也不是一层

它把：

- content-internal schema repair
- attachment materialization + prompt sink alignment

再拆开。

所以：

- 195 不是新的 adapter 主句
- 也不是单纯的附件技巧

而是整组阅读链里，

- user leg 下游的第二层细化

如果没有 194 做上游主句，

195 就会看起来像一篇零散实现页。

## 第六层：196 不是 generic callback map，而是 control leg 下游的 local verdict ledger

196 接在 193 后面，回答的是：

- 既然 `control_response` 已经被 193 收窄成 permission verdict leg，这条腿内部为什么还有 `pendingPermissionHandlers` 这张本地账

它进一步把：

- transport callback
- local ownership

拆开。

所以 196 在整组阅读链中的位置，也不是并列页，而是：

- control leg 下游的第二层细化

一旦跳过 193 直接读 196，

就会把：

- `pendingPermissionHandlers`
- `request_id`
- `handlePermissionResponse(...)`

误写成 generic control callback ownership。

## 第七层：这页不是 `00-阅读路径.md` 的复制，而是局部子系统的 anti-overlap map

这里还要再防一个结构误判：

- “既然 00 里已经有路径 70-75，这页是不是纯重复？”

不是。

`00-阅读路径.md` 的主语是：

- 面向用户目标的入口选择

比如：

- 我想分清 ingress reader
- 我想分清 permission race ledger

它解决的是：

- “我有一个问题，先点哪条路径”

而 197 的主语不同：

- 它面向已经进入 bridge ingress 这条子系统深线的读者
- 解决的是 191-196 这些页彼此怎么组织、为什么不能乱序、哪里是上游边界、哪里是下游细化

所以这页不是任务入口页，

而是：

- 子系统-local 的 anti-overlap map

它优化的是目录结构里的第二层导航，

不是重复 00 的任务入口。

## 第八层：稳定 / 条件 / 灰度保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | bridge ingress 至少稳定暴露了三种用户可观察 effect：server control request 会走独立 side-channel；真正进入 transcript / prompt 消费面的只有 user leg；permission verdict 会沿独立返回腿落回本地审批流 |
| 条件公开 | same-session replay continuity、transport swap 后的重放抑制、attachment materialization 与 path-ref prepend、remote prompt 时序与 bridge permission 往返，都属于运行时条件明显的行为，不写成无前提承诺 |
| 内部/灰度层 | `recentInboundUUIDs`、`recentPostedUUIDs`、`extractInboundMessageFields(...)`、`resolveAndPrepend(...)`、helper 调用顺序、buffer 大小、key normalization 细节，都更像 reader / adapter 内部证据，不该升级成稳定公共合同 |

更稳的落笔纪律是：

- 优先写“用户最后看到哪条腿真的出现在 prompt / transcript / permission flow 里”。
- continuity、attachment 与 remote bridge 往返只能写成条件公开行为。
- UUID 集、helper 名与前处理顺序只保留在证据层，不写成对外承诺。

## 第九层：苏格拉底式自审

### 问：我现在写的是用户真的看得到的 ingress effect，还是内部 dedup / normalization 账本？

答：先分 effect，再分证据；不要把 `recentInboundUUIDs` 直接写成能力名。

### 问：我是不是把 control leg、user leg 和 permission leg 又压回同一种“回调后处理”？

答：如果一句话同时想解释 control request、prompt adapter 和 permission verdict，它大概率已经混层。

### 问：我是不是把 attachment prepend、image repair 这些前处理写成新的 consumer 面？

答：195 只属于 user leg 内部 normalization，不是第四条 ingress 腿。

### 问：我是不是因为源码里到处都出现 `handleIngressMessage(...)`，就把 replay continuity 也写进 reader 本体？

答：192 讨论的是 reader 外部的 continuity boundary，不是 reader 内部的第四种消费。

## 结论

更稳的一句应该是：

- 191-196 不是六篇并列碎页
- 它们是一条从 reader boundary 开始，依次经过 continuity、control leg、user leg、user-leg normalization、permission-leg local ledger 的六层阅读链
- 00 的路径负责“从任务进入”，197 负责“进入之后按什么顺序继续读”

一旦这句成立，

后面就不会再把：

- 195 当成独立技巧页
- 196 当成 generic callback 页
- 或把 00 的路径列表继续塞成局部子系统的唯一导航

这也是这页存在的唯一理由。
