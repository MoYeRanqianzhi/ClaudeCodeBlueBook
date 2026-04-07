# mirror gate topology split 拆分记忆

## 本轮继续深入的核心判断

138 已经把 `activeRemote` 拆成 interaction shell。

接下来如果不继续压 mirror 这条线，正文又会滑成：

- “mirror gate 打开 = outboundOnly bridge 已稳定落地。”

这轮要补的更窄一句是：

- mirror 的启动意图、实现选路与实际 runtime topology 不是同一层合同

## 为什么这轮必须单列

如果不单列，正文最容易在三种误写里摇摆：

- 把 mirror startup intent 写成 topology 已兑现
- 把 env-less miss 写成 transport 版本回退
- 把 hook 的 outboundOnly 本地分支写成 core 已经实现 mirror 的证据

这三种都会把：

- startup intent
- implementation routing
- runtime topology

重新压扁。

## 本轮最关键的新判断

### 判断一：mirror gate 与 env-less gate 当前是独立且不对称的两条开关

### 判断二：`main.tsx` / `useReplBridge()` 只证明本地 mirror startup intent 已经建立

### 判断三：`initReplBridge()` 只有 env-less branch 真正消费 `outboundOnly`

### 判断四：env-less miss 更像回到 env-based orchestration，而不必然回到 v1 transport

### 判断五：hook 侧 mirror 语义和底层 env-based runtime 可能分叉，这正是当前最大的灰度边界

## 苏格拉底式自审

### 问：为什么不能只说“mirror 还没完全 rollout”？

答：因为这句话没说明是 startup intent 没 rollout、env-less implementation 没 rollout，还是 runtime topology 没兑现。

### 问：为什么一定要把 env-based core 仍可用 `createV2ReplTransport(...)` 写进来？

答：因为否则很容易把 env-less miss 误写成“完全回 v1 transport”。这会把 orchestration 和 transport 版本混掉。

### 问：为什么一定要把 hook 的 outboundOnly 分支也写进来？

答：因为灰度边界恰恰出在这里：本地语义可能已经 mirror 化，而底层实现未必同层兑现。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/139-ccrMirrorEnabled、isEnvLessBridgeEnabled、initReplBridge、outboundOnly、replBridge 与 createV2ReplTransport：为什么启动意图、实现选路与实际 runtime topology 不是同一层 mirror 合同.md`
- `bluebook/userbook/03-参考索引/02-能力边界/128-ccrMirrorEnabled、isEnvLessBridgeEnabled、initReplBridge、outboundOnly、replBridge 与 createV2ReplTransport 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/139-2026-04-07-mirror gate topology split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 139
- 索引层只补 128
- 记忆层只补 139

不扩目录，不回写旧页。

## 下一轮候选

1. 单独拆 `post_turn_summary` 的 wide-wire、internal 标记与当前 CLI 主 consumer narrowing 为什么不是同一种“可见性”。
2. 单独拆 remote-session presence ledger 为什么不会自动被 direct connect / ssh remote 复用。
3. 单独拆 hook 侧 outboundOnly 本地语义与 env-based core 双向 wiring 为什么会形成 gray runtime。
