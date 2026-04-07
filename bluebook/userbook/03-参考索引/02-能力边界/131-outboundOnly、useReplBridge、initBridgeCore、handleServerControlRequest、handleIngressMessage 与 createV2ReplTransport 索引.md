# `outboundOnly`、`useReplBridge`、`initBridgeCore`、`handleServerControlRequest`、`handleIngressMessage` 与 `createV2ReplTransport` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/142-outboundOnly、useReplBridge、initBridgeCore、handleServerControlRequest、handleIngressMessage 与 createV2ReplTransport：为什么 hook 已经在 mirror，本体运行时却仍可能落成 gray runtime.md`
- `05-控制面深挖/139-ccrMirrorEnabled、isEnvLessBridgeEnabled、initReplBridge、outboundOnly、replBridge 与 createV2ReplTransport：为什么启动意图、实现选路与实际 runtime topology 不是同一层 mirror 合同.md`

边界先说清：

- 这页不是 mirror rollout 总表。
- 这页不是 139 的重复摘要。
- 这页只抓 hook side outboundOnly 语义与 env-based core 双向 wiring 为什么会形成 gray runtime。

## 1. gray runtime 的两半

| 层 | 当前更像什么 | 关键差异 |
| --- | --- | --- |
| hook side | local mirror semantics | 压薄 `AppState`、切 permission callbacks、切 transcript status |
| env-based core side | still-bidirectional runtime | 仍 wiring `handleServerControlRequest`、`handleIngressMessage`、permission response |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| UI / AppState 已经像 mirror，底层 runtime 一定也 pure outbound-only | hook side 和 core side 不是同一参数面 |
| env-based fallback 最多只是 transport 版本差异 | env-based core 仍保留双向 ingress / control wiring |
| gray runtime 只是理论担心 | 现成源码里已并存本地 outboundOnly 分支和 env-based 双向 wiring |
| transport 还是 v2，就等于 mirror 语义也还在 | transport generation 和 outboundOnly runtime semantics 不是同一层 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `useReplBridge()` 会因 `outboundOnly` 压薄本地 surface；env-less branch 真正消费 `outboundOnly`；env-based core 仍 wiring 双向 ingress / control |
| 条件公开 | gray runtime 最容易出现在 mirror intent 已成立但实现回落 env-based core 的条件下；env-based core 下 transport 仍可能是 v2 |
| 内部/灰度层 | hook 本地语义和 core wiring 当前没有硬约束同步；是否稳定复现仍取决于 rollout / routing 条件 |

## 4. 五个检查问题

- 我现在写的是本地 UI 语义，还是底层 core 语义？
- 我是不是把 env-based fallback 写成了“只是 transport 版本不同”？
- 我是不是因为 hook 已压薄 surface，就默认 read-side 也一定断开？
- 我是不是又回到 139 的 gate/routing 抽象层，而没有指出 gray runtime 的具体落点？
- 我是不是把 gray runtime 写成未来 bug，而不是当前源码已存在的结构分叉？

## 5. 源码锚点

- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/bridge/initReplBridge.ts`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts`
