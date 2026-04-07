# `ccrMirrorEnabled`、`outboundOnly`、`system/init`、`replBridgeConnected` 与 `sessionUrl/connectUrl` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/136-ccrMirrorEnabled、outboundOnly、system-init、replBridgeConnected 与 sessionUrl-connectUrl：为什么同属 v2 的 bridge 也不是同一种活跃 front-state surface.md`
- `05-控制面深挖/134-createV1ReplTransport、createV2ReplTransport、reportState、reportMetadata 与 reportDelivery：为什么 bridge v1/v2 不是同一种 front-state consumer chain.md`

边界先说清：

- 这页不是 bridge 全量 mirror 手册。
- 这页不是 v1 / v2 对比页。
- 这页只抓 v2 内部 full env-less 与 mirror / outboundOnly 的 active surface split。

## 1. 两种 v2 topology

| v2 拓扑 | 当前最像什么 | 关键差异 |
| --- | --- | --- |
| full env-less v2 | 可见、可交互、可回写的多 surface bridge | `system/init`、permission callbacks、URL surface、sessionActive、reconnecting 都能成立 |
| mirror / outboundOnly | 保留 worker-side write chain 的隐身 bridge | `replBridgeConnected` 还在，但 transcript / dialog / permission / URL surface 被主动压薄 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| mirror 只是 full v2 去掉一点 UI | 它压掉的是 read/control/front-state chain，不只是 UI 壳 |
| 同属 env-less / CCR v2，前台状态面厚度就一样 | full env-less 自己在 `ready` / `connected` 间已分叉，mirror 更是另一种 topology |
| outboundOnly 说明没有 worker-side chain | `/worker` 注册、heartbeat、`reportState(...)`、teardown 仍然成立 |
| footer / dialog 没显示，说明桥没连上 | 还可能是 implicit hidden gate 或 `displayUrl` 条件没满足 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | mirror 启动时当前是 implicit + outboundOnly；`useReplBridge()` 只维护薄 `replBridgeConnected`；不注册 permission callbacks / `system/init` / transcript status；v2 write-side chain 仍成立 |
| 条件公开 | full env-less 在 `ready` 与 `connected` 间存在 URL display gap；footer pill 还受 implicit / reconnecting 门控；`/remote-control` 在 mirror 运行时更像升级入口 |
| 内部/灰度层 | `outboundOnly` 当前主要由 env-less v2 core 真正消费；metadata 能力虽在 transport 上存在，但 mirror 路径未形成 metadata-backed front-state producer |

## 4. 五个检查问题

- 我现在写的是 transport generation，还是 active front-state surface？
- 我是不是把 outboundOnly 写成“没有 worker-side chain”？
- 我是不是把 implicit hidden gate 忽略了？
- 我是不是把 `ready` 与 `connected` 的 surface 点亮时机写成同一步？
- 我是不是把 mirror 当成 full bridge 的一个只读皮肤？

## 5. 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts`
- `claude-code-source-code/src/bridge/initReplBridge.ts`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooter.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx`
- `claude-code-source-code/src/components/BridgeDialog.tsx`
- `claude-code-source-code/src/commands/bridge/bridge.tsx`
