# `createV1ReplTransport`、`createV2ReplTransport`、`reportState`、`reportMetadata` 与 `reportDelivery`：为什么 bridge v1/v2 不是同一种 front-state consumer chain

## 用户目标

132 已经把 bridge 这条线写成：

- 最接近形成 `transcript/footer/dialog/store` 对齐

133 又补了：

- schema/store 里有账，不等于当前前台已经消费

但继续往下读 bridge 源码时，读者还是很容易把另一个关键差别压平：

- `useReplBridge` 里还是会写 `replBridgeConnected`
- footer pill 还是会出现
- `BridgeDialog` 还是能打开
- transcript 里还是会看到 `bridge_status`

于是正文就会滑成一句看似顺口、实际上不够严谨的话：

- “bridge 就是一条统一的前台状态消费链，只是实现细节里有 v1/v2 区别。”

这句不稳。

从当前源码看，至少有两条不同的 bridge consumer chain：

1. v1：HybridTransport + 本地 `replBridge*` surface
2. v2：SSETransport + CCRClient + 本地 `replBridge*` surface + worker-side state / delivery 账本

它们共享一部分前台 surface，

但并不是同一种 front-state consumer chain。

## 第一性原理

更稳的提问不是：

- “bridge 的 v1/v2 到底哪个更高级？”

而是先问五个更底层的问题：

1. 当前哪一层是共享的前台 surface，哪一层已经分叉成不同状态账本？
2. 当前 transport 只负责连通，还是还负责正式状态上传与 delivery tracking？
3. 当前 `reportState/reportMetadata/reportDelivery` 是真实写路径，还是 no-op 兼容面？
4. 当前看到的 pill/dialog/transcript，是不是已经意味着 worker-side store 同步也存在？
5. 当前这条“bridge”说的是 local UI affordance，还是完整的 authoritative state chain？

只要这五轴先拆开，v1/v2 就不会再被写成：

- “同一条 bridge，只是协议不同”

## 第一层：`ReplBridgeTransport` 类型表面统一，但能力从定义上就允许分叉

`replBridgeTransport.ts` 先给了一个统一接口：

- `write`
- `writeBatch`
- `setOnData`
- `setOnClose`
- `setOnConnect`
- `getLastSequenceNum`
- `reportState`
- `reportMetadata`
- `reportDelivery`
- `flush`

如果只看这里，读者很容易以为：

- 所有 bridge transport 都有同等 front-state 能力

但同一文件往下立刻就把这层假等式拆掉了。

因为 `createV1ReplTransport()` 明确返回：

- `reportState: () => {}`
- `reportMetadata: () => {}`
- `reportDelivery: () => {}`
- `flush: () => Promise.resolve()`
- `getLastSequenceNum: () => 0`

而 `createV2ReplTransport()` 则把这些全部接到：

- `CCRClient`
- `SSETransport`

所以这一步最该先写清：

- surface typed equal
- capability not equal

## 第二层：v1 仍然有本地 bridge surface，但没有 worker-side正式状态上传

这一步最容易被漏掉。

因为从用户眼前看，v1 也不是“什么都没有”。

`useReplBridge.tsx` 还是会写：

- `replBridgeConnected`
- `replBridgeSessionActive`
- `replBridgeReconnecting`
- `replBridgeConnectUrl`
- `replBridgeSessionUrl`
- `replBridgeEnvironmentId`
- `replBridgeSessionId`
- `replBridgeError`

footer pill 还是从这些字段读，

`BridgeDialog` 也还是从这些字段读。

也就是说 v1 当前仍然拥有：

- local AppState shadow
- footer surface
- dialog surface
- 一部分 transcript surface

但这不等于它已经拥有：

- worker-side authoritative state upload
- external metadata upload
- delivery tracking

所以更准确的说法必须是：

- v1 has local bridge surfaces
- v1 does not have the full worker-side front-state chain

## 第三层：v2 的关键新增不是“UI 更好看”，而是把 bridge 接进了 CCR worker store

`createV2ReplTransport()` 的真正分水岭不在：

- 读流改成 SSE

而在：

- `CCRClient.initialize()`
- `ccr.reportState(...)`
- `ccr.reportMetadata(...)`
- `ccr.reportDelivery(...)`

再加上 `remoteIO.ts` / `remoteBridgeCore.ts` 会把：

- `setSessionStateChangedListener`
- `setSessionMetadataChangedListener`

一路接进：

- `ccrClient.reportState`
- `ccrClient.reportMetadata`

所以 v2 新增的不是一层“更厚一点的本地 UI”，

而是：

- bridge 前台面和 worker-side authoritative state store 之间真的被接起来了

这一点非常关键。

因为如果把 v2 只写成：

- “transport from Hybrid to SSE”

就会漏掉最有价值的一层能力差异。

## 第四层：`remoteBridgeCore` 当前大量假定 `reportState()` 有意义，但这在 v1 只是兼容壳

`remoteBridgeCore.ts` 到处都在调用：

- `transport.reportState('running')`
- `transport.reportState('requires_action')`
- `transport.reportState('idle')`

出现在：

- user message 批量发送前后
- `can_use_tool` 请求到来时
- `control_response` / `control_cancel_request` 后
- result / teardown 时

如果读者忘了 v1 的实现是 no-op，

就会误写成：

- “bridge 一定会把这些 authoritative state 写进状态账本”

但更准确的说法应是：

- `remoteBridgeCore` speaks a richer abstract state language
- only v2 actually persists it into worker-side state

所以在 v1 里，这些调用更多是：

- semantic intent

而在 v2 里，这些调用才真正变成：

- persisted front-state signal

## 第五层：`reportDelivery()` 的存在进一步拉开了 v1/v2 的消费链差异

这一步很容易被忽略，因为用户前台未必直接看到 delivery 字段。

但对 front-state consumer chain 来说，它非常关键。

`replBridgeTransport.ts` 在 v2 下专门做了：

- `received`
- `processed`

双重上报。

注释直接说明原因：

- 否则 daemon restart 后会重复 re-queue
- 造成 phantom prompts

这说明 v2 不只是“上传 worker_status”，

它还在维护：

- worker event consumption bookkeeping

而 v1 的：

- `reportDelivery: () => {}`

意味着这条消费链在 v1 根本不存在。

所以更稳的写法必须把 delivery 也算进 front-state chain，

而不是只盯着：

- pill / dialog / transcript

## 第六层：`getLastSequenceNum()` 和 `flush()` 也不是同一回事

统一接口里另外两项也很说明问题：

### `getLastSequenceNum()`

v1：

- 永远返回 `0`

v2：

- 真正从 `SSETransport` 读 sequence high-water mark

### `flush()`

v1：

- 立即 `Promise.resolve()`

v2：

- 真正 drain `CCRClient` 写队列

这说明 even at transport lifecycle level，

v1/v2 的“前台状态消费链”已经不是同一条逻辑：

- v1 更接近本地 UI + transport continuity
- v2 更接近本地 UI + worker-side state/delivery consistency

## 第七层：因此 bridge 前台面的一致，不等于 bridge 状态消费链的一致

把前面几层压成一句，最稳的一句其实是：

- same surface, different chain depth

也就是说：

### v1 当前更像

- local bridge surfaces
- transport continuity
- no worker-side state / metadata / delivery consumer

### v2 当前更像

- local bridge surfaces
- worker-side state upload
- worker-side metadata upload
- delivery tracking
- sequence-aware rebuild / flush semantics

所以如果只看：

- footer pill
- `BridgeDialog`
- transcript `bridge_status`

很容易误判成：

- bridge 本来就是一条统一消费链

但从源码看，更准确的结论是：

- bridge UI affordance is partly unified
- bridge front-state consumer chain is version-split

## 第八层：为什么它不是 132、133 的重复页

### 它不是 132

132 讲的是：

- direct connect
- remote session
- bridge

三条链路为什么不是同一种 front-state consumer。

134 讲的是：

- 即使只看 bridge，它内部的 v1/v2 也不是同一种 consumer chain

一个讲：

- cross-path split

一个讲：

- intra-bridge version split

### 它不是 133

133 讲的是：

- metadata/schema/store 不等于 foreground consumer

134 讲的是：

- bridge 表面上共享同一批前台面，但 worker-side state/delivery 链路仍随 v1/v2 分叉

一个讲：

- field-level producer/store/restore/consumer split

一个讲：

- transport-version capability split

## 第九层：最常见的假等式

### 误判一：既然 footer/dialog 看起来一样，v1/v2 就只是传输协议不同

错在漏掉：

- `reportState/reportMetadata/reportDelivery/flush/getLastSequenceNum` 的能力差异

### 误判二：`remoteBridgeCore` 调了 `reportState()`，所以 bridge 一定已经持久化状态

错在漏掉：

- v1 的 `reportState()` 是 no-op

### 误判三：v1 没有 worker-side state，所以就没有 bridge front surface

错在漏掉：

- v1 仍有本地 `replBridge*` shadow、pill、dialog、部分 transcript

### 误判四：delivery tracking 只是实现优化，不属于状态消费链

错在漏掉：

- v2 通过 delivery bookkeeping 避免 restart 后的 phantom prompts，这已经直接影响前台一致性

### 误判五：bridge 既然叫 bridge，就一定是一条统一产品合同

错在漏掉：

- 当前 bridge 仍是统一 affordance、分裂 capability 的状态

## 第十层：stable / conditional / internal

### 稳定可见

- `ReplBridgeTransport` 当前类型上统一暴露 `reportState/reportMetadata/reportDelivery`
- v1 当前对这些能力明确是 no-op
- v2 当前把这些能力接到 `CCRClient` / `SSETransport`
- footer pill / dialog / `replBridge*` 本地 shadow 当前两条线都还存在

### 条件公开

- worker-side authoritative state upload 当前只在 v2 成立
- env-less / outbound-only / mirror 路径还会进一步改变哪些 front-state 面真正活跃
- transcript 中的 `bridge_status`、footer pill、dialog 这些前台面并不能单独证明 worker-side chain 已接上

### 内部 / 灰度层

- delivery `received/processed` 的具体取舍窗口
- `getLastSequenceNum()` / `flush()` 的具体恢复细节
- v1 未来是否会继续保留、迁移或逐步收缩能力面

这些更适合作为：

- 当前实现证据

而不是：

- 永不变化的产品承诺

## 第十一层：苏格拉底式自审

### 问：我现在写的是共享的前台 surface，还是共享的状态消费链？

答：如果答不出来，就把 affordance 和 capability 混了。

### 问：我是不是把 `reportState()` 的抽象接口偷换成了“所有版本都真实上传”？

答：如果是，就漏掉了 v1 no-op。

### 问：我是不是把 v2 的 worker-side能力写成了整个 bridge 的统一稳定合同？

答：如果是，就把条件公开写过头了。

### 问：我是不是因为 v1 也有 dialog/pill，就断言它和 v2 的 consumer depth 一样？

答：如果是，就把 local surface 和 worker chain 混了。

### 问：我是不是又把 132 的三链路对比拿来重写，而没有把范围压到 bridge 内部版本分叉？

答：如果是，就还没真正进入 134。

## 源码锚点

- `claude-code-source-code/src/bridge/replBridgeTransport.ts`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooter.tsx`
- `claude-code-source-code/src/components/BridgeDialog.tsx`
- `claude-code-source-code/src/components/messages/SystemTextMessage.tsx`
