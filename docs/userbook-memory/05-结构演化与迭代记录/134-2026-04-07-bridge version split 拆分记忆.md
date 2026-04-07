# bridge version split 拆分记忆

## 本轮继续深入的核心判断

132 已经写了 bridge 是三条链路里最接近 front-state 对齐的一条。

但如果继续往下不补这一页，读者还是会把：

- `createV1ReplTransport`
- `createV2ReplTransport`
- `reportState`
- `reportMetadata`
- `reportDelivery`

压成一句：

- “bridge 的 v1/v2 只是传输协议分叉。”

这轮要补的更窄一句是：

- bridge v1/v2 不是同一种 front-state consumer chain

## 为什么这轮必须单列

如果不单列，正文最容易在三种错误里摇摆：

- 把共享的本地 front surface 写成共享的状态消费链
- 把 `remoteBridgeCore` 的抽象 `reportState()` 调用偷换成所有版本都真实上传
- 把 v2 的 worker-side能力写成整个 bridge 的统一稳定合同

这三种都会把：

- local affordance
- abstract capability
- concrete worker-side chain

重新压扁。

## 本轮最关键的新判断

### 判断一：`ReplBridgeTransport` 的接口统一，不等于 capability 统一

### 判断二：v1 当前保留本地 `replBridge*` surface，但 `report*`、`flush`、`seq-num` 基本是 no-op / compatibility shell

### 判断三：v2 的分水岭不只是 SSE，而是 `CCRClient` 把 state/metadata/delivery 真正接进 worker-side store

### 判断四：同样的 pill/dialog/transcript surface 不能单独证明 worker-side chain 已接上

### 判断五：bridge 目前更接近“统一 affordance、分裂 capability”

## 苏格拉底式自审

### 问：为什么这页不能并回 132？

答：132 讲三链路对比；134 讲 bridge 内部版本分叉。

### 问：为什么一定要把 `reportDelivery` 拉进来？

答：因为 delivery bookkeeping 不只是实现细节，它会直接影响 restart 后的前台一致性。

### 问：为什么这页不能只写 `SSE vs HybridTransport`？

答：因为真正的消费链差别在 `CCRClient` / worker store / report*，不是 transport 关键词本身。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/134-createV1ReplTransport、createV2ReplTransport、reportState、reportMetadata 与 reportDelivery：为什么 bridge v1-v2 不是同一种 front-state consumer chain.md`
- `bluebook/userbook/03-参考索引/02-能力边界/123-createV1ReplTransport、createV2ReplTransport、reportState、reportMetadata 与 reportDelivery 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/134-2026-04-07-bridge version split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 134
- 索引层只补 123
- 记忆层只补 134

不扩目录，不回写旧页。

## 下一轮候选

1. 单独拆 direct connect 为什么更像 transcript+permission queue+loading 的前台壳，而不是 remote viewer / bridge 那样的远端状态面。
2. 单独拆 `pending_action.input` 注释里暗示的 frontend consumer 与当前 CLI consumer 的边界，避免把跨前端语义误写成 CLI 语义。
3. 单独拆 mirror/outboundOnly/env-less 对 bridge front-state surface 的影响，避免把 v2 内部不同拓扑再压成一条线。
