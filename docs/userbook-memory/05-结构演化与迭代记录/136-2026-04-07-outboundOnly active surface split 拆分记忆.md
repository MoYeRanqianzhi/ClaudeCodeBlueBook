# outboundOnly active surface split 拆分记忆

## 本轮继续深入的核心判断

135 已经把 direct connect 单独拆成 foreground runtime。

如果再往下不补这一页，bridge 这条线又会被重新压成：

- “只要是 v2 / env-less，前台状态面就已经统一。”

这轮要补的更窄一句是：

- 同属 v2 的 bridge 也不是同一种活跃 front-state surface

## 为什么这轮必须单列

如果不单列，正文最容易在三种误写里摇摆：

- 把 mirror 写成 full v2 的隐藏皮肤
- 把 outboundOnly 写成“没有 worker-side chain”
- 把 footer / dialog 的缺席误读成“桥没连上”

这三种都会把：

- transport generation
- worker-side write chain
- front-side consumer surface

重新压扁。

## 本轮最关键的新判断

### 判断一：mirror 从启动第一刻起就是 implicit + outboundOnly 拓扑，不是 full Remote Control 的前台变体

### 判断二：outboundOnly 当前真正压薄的是 read/control/front-state 这半条链，不是 worker-side write chain

### 判断三：`useReplBridge()` 会把 outboundOnly 的 `AppState` surface 主动压成近乎只剩 `replBridgeConnected`

### 判断四：full env-less v2 自己在 `ready` / `connected` 间就已经存在 URL display gap

### 判断五：mirror 更像“保留 `/worker` 生命体征的隐身投影链”，而不是 full bridge 少几个 UI

## 苏格拉底式自审

### 问：为什么一定要把 `system/init`、permission callbacks、footer pill 一起拉进来？

答：因为只有把 read/control/front-state 这几层一起看，才能证明 mirror 砍掉的不是一个组件，而是一整半条链。

### 问：为什么一定要写 `ready` / `connected` 的 display gap？

答：因为否则 full env-less 自己也会被误写成“一到 ready 所有 surface 同步点亮”。

### 问：为什么要把 `outboundOnly` 的消费中心写成条件判断？

答：因为当前 wiring 明显偏向 env-less v2 core，落回 env-based path 时并没有同样清晰的统一参数面。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/136-ccrMirrorEnabled、outboundOnly、system-init、replBridgeConnected 与 sessionUrl-connectUrl：为什么同属 v2 的 bridge 也不是同一种活跃 front-state surface.md`
- `bluebook/userbook/03-参考索引/02-能力边界/125-ccrMirrorEnabled、outboundOnly、system-init、replBridgeConnected 与 sessionUrl-connectUrl 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/136-2026-04-07-outboundOnly active surface split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 136
- 索引层只补 125
- 记忆层只补 136

不扩目录，不回写旧页。

## 下一轮候选

1. 单独拆 `pending_action.input`、`task_summary`、`post_turn_summary` 为什么更像跨前端 consumer path，而不是当前 CLI foreground consumer。
2. 单独拆 direct connect 与 ssh remote 共用 `activeRemote` 壳，却为什么不自动推出同一种远端存在账本。
3. 单独拆 mirror rollout gate、env-less gate 与 outboundOnly 实际兑现之间的灰度边界。
