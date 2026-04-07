# `ccrMirrorEnabled`、`isEnvLessBridgeEnabled`、`initReplBridge`、`outboundOnly`、`replBridge` 与 `createV2ReplTransport` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/139-ccrMirrorEnabled、isEnvLessBridgeEnabled、initReplBridge、outboundOnly、replBridge 与 createV2ReplTransport：为什么启动意图、实现选路与实际 runtime topology 不是同一层 mirror 合同.md`
- `05-控制面深挖/136-ccrMirrorEnabled、outboundOnly、system-init、replBridgeConnected 与 sessionUrl-connectUrl：为什么同属 v2 的 bridge 也不是同一种活跃 front-state surface.md`

边界先说清：

- 这页不是 mirror 表面 UI 差异页。
- 这页不是 env-less 配置参数总表。
- 这页只抓 mirror startup intent、implementation routing 与 runtime topology 为什么不是同一层合同。

## 1. 三层不能压成一层

| 层 | 当前在回答什么 | 不能偷换成什么 |
| --- | --- | --- |
| startup intent | `ccrMirrorEnabled` / `replBridgeOutboundOnly` 是否被写进本地状态 | 已稳定兑现 outboundOnly topology |
| implementation routing | `initReplBridge()` 最终走 env-less 还是 env-based | transport 版本是否一定 v1 / v2 |
| runtime topology | 实际是否切掉 read-side / control-side | 本地 hook 语义本身 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| mirror gate 开了，就等于 outboundOnly topology 已稳定兑现 | 这只证明 startup intent，不证明 env-less branch 一定命中 |
| env-less 没命中，就等于完全回到 v1 transport | env-based orchestration 下仍可能选 CCR v2 transport |
| hook 按 outboundOnly 做分支，说明底层 runtime 一定是 mirror | hook intent 和 core implementation 可能分叉 |
| env-less min version 不满足时会自动 fallback | 当前实现是直接 fail，不是自动降级 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | mirror gate 与 env-less gate 独立；`main.tsx` 会把 mirror intent 写进 `replBridgeOutboundOnly`；`initReplBridge()` 只有 env-less branch 真正消费 `outboundOnly`；env-based core 保留 inbound/control wiring |
| 条件公开 | env-based orchestration 下 transport 仍可能是 CCR v2；mirror startup intent 可以先于 env-less rollout 命中；telemetry / tag 只能证明部分 runtime 落地 |
| 内部/灰度层 | hook 的 outboundOnly 本地语义和底层 env-based runtime 可能分叉；仓内没有硬约束保证 mirror 必须依赖 env-less |

## 4. 五个检查问题

- 我现在写的是 startup intent，还是 runtime topology？
- 我是不是把 env-less gate 写成了 bridge 是否可用的总开关？
- 我是不是把 env-based fallback 偷换成了 transport 版本回退？
- 我是不是把 hook 的 outboundOnly 分支当成了 core 已兑现 mirror 的证据？
- 我是不是又在重写 136 的 surface 差异，而没有真正进入 gate / routing / topology？

## 5. 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/bridge/initReplBridge.ts`
- `claude-code-source-code/src/bridge/envLessBridgeConfig.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
