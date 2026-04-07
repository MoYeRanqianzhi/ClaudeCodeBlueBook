# gray runtime split 拆分记忆

## 本轮继续深入的核心判断

141 已经把 remote-session presence ledger 的专属边界拆开。

接下来如果不把 mirror 的灰度态继续压到运行时分叉面，正文还是会停在：

- “mirror 有灰度。”

这轮要补的更窄一句是：

- hook 已经在 mirror，本体运行时却仍可能落成 gray runtime

## 为什么这轮必须单列

如果不单列，正文最容易在三种误写里摇摆：

- 把 hook side 本地语义偷换成 core 已兑现 mirror topology
- 把 env-based fallback 写成纯 transport 版本差异
- 把 gray runtime 写成未来 bug，而不是当前仓里已经存在的结构分叉

这三种都会把：

- local mirror semantics
- core runtime semantics
- routing fallback

重新压扁。

## 本轮最关键的新判断

### 判断一：`useReplBridge()` 当前会因为 `outboundOnly` 先把本地 AppState / transcript / permission surface 压薄

### 判断二：真正的 outboundOnly runtime 兑现点在 `bridgeMessaging.ts` 与 transport 层，不在 hook 层

### 判断三：env-based delegate 当前没有吃到 `outboundOnly` 参数

### 判断四：env-based core 仍 wiring `handleServerControlRequest` 与 `handleIngressMessage`

### 判断五：gray runtime 的本质是“本地 mirror 语义已成立，但 core 双向语义仍可能继续存在”

## 苏格拉底式自审

### 问：为什么不能只说“139 已经证明有灰度”？

答：因为 139 主要讲 layer split；这一页讲的是 gray runtime 在哪几条 wiring 上具体显形。

### 问：为什么一定要把 `bridgeMessaging.ts` 拉进来？

答：因为它说明真正的 outboundOnly control-side 行为发生在哪，不然 hook 本地分支会被误写成全部 runtime 语义。

### 问：为什么一定要把 `replBridge.ts` 的 env-based wiring 写进来？

答：因为这正是 gray runtime 的直接证据，不写它就只剩抽象推测。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/142-outboundOnly、useReplBridge、initBridgeCore、handleServerControlRequest、handleIngressMessage 与 createV2ReplTransport：为什么 hook 已经在 mirror，本体运行时却仍可能落成 gray runtime.md`
- `bluebook/userbook/03-参考索引/02-能力边界/131-outboundOnly、useReplBridge、initBridgeCore、handleServerControlRequest、handleIngressMessage 与 createV2ReplTransport 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/142-2026-04-07-gray runtime split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 142
- 索引层只补 131
- 记忆层只补 142

不扩目录，不回写旧页。

## 下一轮候选

1. 单独拆 `getIsRemoteMode()` 的全局行为开关与 presence truth 为什么不是同一层 remote 语义。
2. 单独拆 `post_turn_summary` 在 raw stream、callback surface 与 terminal semantics 三层为什么不是同一种 “可见”。
3. 单独拆 remote-session pane 显隐和 pane 内容的双重 gate 为什么不是同一种 remote mode。
