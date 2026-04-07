# activeRemote interaction shell split 拆分记忆

## 本轮继续深入的核心判断

137 已经把 metadata 这条线压到“跨前端 consumer path”。

下一步如果不继续拆 REPL 顶层 abstraction，正文还是会滑成：

- “REPL 已经有一个统一的 remote 子系统，只是 transport 不同。”

这轮要补的更窄一句是：

- 共用交互壳，不等于共用 remote presence ledger

## 为什么这轮必须单列

如果不单列，正文最容易在三种误写里摇摆：

- 把 `activeRemote` 写成统一 remote presence abstraction
- 把 `useDirectConnect` / `useSSHSession` 的 sibling shape 写成 shared authority
- 把 `directConnectServerUrl` 这类 display hint 写成 ledger

这三种都会把：

- turn-level interaction shell
- bootstrap display hint
- authoritative presence ledger

重新压扁。

## 本轮最关键的新判断

### 判断一：`activeRemote` 当前统一的是最小交互壳，而不是最小存在账

### 判断二：`useDirectConnect` 与 `useSSHSession` 的 sibling 关系，证明它们共享的是 stream-json interaction shell

### 判断三：`useRemoteSession` 才真正写 `remoteConnectionStatus / remoteBackgroundTaskCount`，因此它是 presence ledger 那条线

### 判断四：`isRemoteSession` 与 `activeRemote.isRemoteMode` 在 REPL 里本来就被拆成两种 remote 语义

### 判断五：`directConnectServerUrl` 只是 bootstrap display hint，不足以构成 remote presence truth

## 苏格拉底式自审

### 问：为什么不能只说“这三条都能 remote send/cancel”？

答：因为那只能说明共用 interaction shell，不能说明共用 presence ledger。

### 问：为什么一定要把 `/session` 拉进来？

答：因为 `/session` 只认 `remoteSessionUrl`，它能直接证明“presence mode”不是所有 `activeRemote` 都共享的语义。

### 问：为什么要把 `isRemoteSession` 单独写出来？

答：因为这是 REPL 自己留下的分界线，能防止把“交互 remote”与“存在面 remote”重新压平。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/138-activeRemote、useDirectConnect、useSSHSession、useRemoteSession、remoteSessionUrl 与 directConnectServerUrl：为什么共用交互壳，不等于共用 remote presence ledger.md`
- `bluebook/userbook/03-参考索引/02-能力边界/127-activeRemote、useDirectConnect、useSSHSession、useRemoteSession、remoteSessionUrl 与 directConnectServerUrl 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/138-2026-04-07-activeRemote interaction shell split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 138
- 索引层只补 127
- 记忆层只补 138

不扩目录，不回写旧页。

## 下一轮候选

1. 单独拆 mirror rollout gate、env-less gate 与 outboundOnly 实际兑现之间的灰度边界。
2. 单独拆 `post_turn_summary` 的 wide-wire、internal 标记与当前 CLI 主 consumer narrowing 为什么不是同一种“可见性”。
3. 单独拆 remote-session presence ledger 为什么不会自动被 direct connect / ssh 复用。
