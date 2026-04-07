# `handleIngressMessage`、`control_response/control_request`、`extractInboundMessageFields` 与 `enqueue(prompt)` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/194-handleIngressMessage、control_response-control_request、extractInboundMessageFields 与 enqueue(prompt)：为什么 bridge ingress 只有 control 旁路和 user-only transcript adapter，non-user SDKMessage 没有第二消费面.md`
- `05-控制面深挖/191-handleIngressMessage、recentPostedUUIDs、recentInboundUUIDs 与 onInboundMessage：为什么 outbound echo drop、inbound replay guard 与 non-user ignore 不是同一种 ingress consumer contract.md`
- `05-控制面深挖/193-handleIngressMessage、isSDKControlResponse、isSDKControlRequest、onPermissionResponse 与 onControlRequest：为什么 bridge ingress 的 control side-channel 不是对称的通用 control 总线.md`

边界先说清：

- 这页不是 phase handoff 总页。
- 这页不是 gray runtime wiring 总页。
- 这页只抓 ingress 宽 `SDKMessage` 边界怎样坍缩成单一 user transcript adapter。

## 1. 五层对象

| 对象 | 当前更像什么 | 关键位置 |
| --- | --- | --- |
| `handleIngressMessage(...)` | 三分路由入口 | `bridgeMessaging.ts` |
| `control_response` / `control_request` | control 旁路 | `bridgeMessaging.ts` |
| `onInboundMessage` | user-only transcript callback slot | `initReplBridge.ts` |
| `extractInboundMessageFields(...)` | user/prompt 二次 narrowing | `inboundMessages.ts` |
| `enqueue({ mode: 'prompt' })` | 真正兑现的 transcript sink | `useReplBridge.tsx` / `print.ts` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `SDKMessage` = ingress 的通用事件面 | 在这条链上它只是宽外壳，真正兑现的是 user transcript adapter |
| non-user ignore = dedup 特例 | 它是因为这里根本没有 non-user 的第二消费面 |
| `onInboundMessage` = 通用 SDK consumer | 下游立刻继续收窄到 `extractInboundMessageFields(...)` |
| hook / print 是两套不同 inbound 语义 | 两边都落到 `enqueue(prompt)`，只是前处理厚度不同 |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | ingress 上唯一的 transcript sink 是 user-only prompt adapter |
| 条件公开 | hook 路径会额外做 attachment resolve / webhook sanitize，print 路径更薄 |
| 内部/灰度层 | outboundOnly wiring、phase handoff、turn-state 细节不在本页主语内 |

## 4. 五个检查问题

- 我现在写的是 phase handoff，还是 transcript adapter？
- 我是不是把 `SDKMessage` 宽类型当成了通用 consumer 面？
- 我是不是把 non-user ignore 误写成某种 dedup？
- 我是不是把 `extractInboundMessageFields(...)` 当成可有可无的实现细节？
- 我是不是又回卷到 56、142、191 或 193 的主语了？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/bridgeMessaging.ts`
- `claude-code-source-code/src/bridge/inboundMessages.ts`
- `claude-code-source-code/src/bridge/inboundAttachments.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/cli/print.ts`
