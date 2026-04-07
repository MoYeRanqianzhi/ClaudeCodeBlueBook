# `createV1ReplTransport`、`createV2ReplTransport`、`reportState`、`reportMetadata` 与 `reportDelivery` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/134-createV1ReplTransport、createV2ReplTransport、reportState、reportMetadata 与 reportDelivery：为什么 bridge v1-v2 不是同一种 front-state consumer chain.md`
- `05-控制面深挖/132-worker_status、external_metadata、AppState shadow 与 SDK event projection：为什么 bridge 能形成 transcript-footer-dialog-store 对齐，而 direct connect、remote session 更多只是前台事件投影.md`

边界先说清：

- 这页不是三条链路总对比。
- 这页不是 metadata/store 字段页。
- 这页只抓 bridge 内部的 v1/v2 consumer capability 分叉。

## 1. 两条 bridge consumer chain

| 版本 | 当前最像什么 | 关键差异 |
| --- | --- | --- |
| v1 | local bridge surfaces + transport continuity | `reportState/reportMetadata/reportDelivery/flush/getLastSequenceNum` 基本是兼容壳 |
| v2 | local bridge surfaces + worker-side state/delivery chain | `CCRClient`、`SSETransport`、sequence、delivery、state upload 全部接上 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| footer/dialog 看起来一样，v1/v2 只是协议不同 | same surface, different chain depth |
| `remoteBridgeCore` 调了 `reportState()`，所以 bridge 一定持久化状态 | v1 的 `reportState()` 是 no-op |
| v1 没有 worker-side state，所以没有 bridge front surface | v1 仍有本地 `replBridge*` shadow、pill、dialog、部分 transcript |
| delivery tracking 只是实现优化，不属于状态消费链 | v2 delivery bookkeeping 会直接影响前台一致性 |
| bridge 是一个统一产品合同 | 当前更接近统一 affordance、分裂 capability |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 统一接口存在；v1 对 `report*` 能力是 no-op；v2 接到 `CCRClient/SSETransport`；本地 `replBridge*` surface 两条线都还存在 |
| 条件公开 | worker-side authoritative state upload 只在 v2 成立；mirror/outboundOnly/env-less 路径会进一步改变活跃 front-state 面；前台面存在不等于 worker chain 已接上 |
| 内部/灰度层 | delivery `received/processed` 细节；`getLastSequenceNum/flush` 恢复细节；v1 未来的演化方向 |

## 4. 五个检查问题

- 我现在写的是共享 front surface，还是共享状态消费链？
- 我是不是把抽象接口偷换成了所有版本都真实上传？
- 我是不是把 v2 的 worker-side能力写成了整个 bridge 的统一合同？
- 我是不是因为 v1 也有 pill/dialog，就断言它和 v2 的 consumer depth 一样？
- 我是不是又回到 132 的大对比，而没有把范围压到 bridge 内部版本分叉？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/replBridgeTransport.ts`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooter.tsx`
- `claude-code-source-code/src/components/BridgeDialog.tsx`
- `claude-code-source-code/src/components/messages/SystemTextMessage.tsx`
