# cross frontend consumer split 拆分记忆

## 本轮继续深入的核心判断

136 已经把 bridge v2 内部的 topology split 拆开。

但 `pending_action.input / task_summary / post_turn_summary` 这条线如果再不继续压缩，正文还是会滑成：

- “frontend 会读 = CLI 只是暂时没把 UI 做出来。”

这轮要补的更窄一句是：

- “frontend 会读”更像跨前端 consumer path，而不是当前 CLI foreground contract

## 为什么这轮必须单列

如果不单列，正文最容易在三种误写里摇摆：

- 把 frontend intent 偷换成当前 CLI contract
- 把 restore path 被调用偷换成所有 metadata 都回灌进 foreground
- 把 wide stdout wire 可见偷换成 core SDK / CLI 主 consumer 可见

这三种都会把：

- schema
- worker-side store
- frontend intent
- CLI foreground contract

重新压扁。

## 本轮最关键的新判断

### 判断一：`pending_action.input` 的注释证明了真实 frontend intent，但没有证明当前 CLI foreground 就是这个 frontend

### 判断二：`task_summary` 当前是被真实维护的中途进展账，但当前 CLI foreground 没有 reader

### 判断三：`post_turn_summary` 当前更像 wide stdout wire 上的 internal tail summary，而不是 core SDK / CLI 主合同

### 判断四：`externalMetadataToAppState()` 当前只恢复极少子集，所以 restore 被调用不等于这三者都回灌本地前台

### 判断五：`print` / `directConnect` 对 `post_turn_summary` 的主动 narrowing，本身就是“当前 CLI 不把它当主 consumer”的证据

## 苏格拉底式自审

### 问：为什么不能只说“这三者 CLI 还没接上”？

答：因为这句话没有回答“现在到底哪个 frontend 在被注释暗示为 consumer”，而这正是这轮要补的边界。

### 问：为什么一定要把 `StdoutMessageSchema` 和 `SDKMessageSchema` 一起拉进来？

答：因为只有这样才能把 wire 可见性和 core consumer 可见性拆开。

### 问：为什么一定要把 `print` 和 `directConnect` 的 filter 写进来？

答：因为这能证明当前 CLI 不是单纯“还没做 UI”，而是已有主 consumer path 主动绕开。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/137-pending_action.input、task_summary、post_turn_summary、externalMetadataToAppState、print.ts 与 directConnectManager：为什么“frontend 会读”更像跨前端 consumer path，而不是当前 CLI foreground contract.md`
- `bluebook/userbook/03-参考索引/02-能力边界/126-pending_action.input、task_summary、post_turn_summary、externalMetadataToAppState、print.ts 与 directConnectManager 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/137-2026-04-07-cross frontend consumer split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 137
- 索引层只补 126
- 记忆层只补 137

不扩目录，不回写旧页。

## 下一轮候选

1. 单独拆 direct connect 与 ssh remote 共用 `activeRemote` 壳，却为什么不自动推出同一种 remote presence ledger。
2. 单独拆 mirror rollout gate、env-less gate 与 outboundOnly 实际兑现之间的灰度边界。
3. 单独拆 `post_turn_summary` 的 wide-wire、internal 标记与当前 CLI 主 consumer narrowing 为什么不是同一种“可见性”。
