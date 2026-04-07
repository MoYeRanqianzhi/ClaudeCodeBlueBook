# remote session presence ledger split 拆分记忆

## 本轮继续深入的核心判断

140 已经把 `post_turn_summary` 压成 visibility ladder。

下一步如果不继续压 `remoteSessionUrl / remoteConnectionStatus / remoteBackgroundTaskCount` 这张账，正文还是会滑成：

- “所有 remote mode 理应共用它，只是 direct connect / ssh 还没复用。”

这轮要补的更窄一句是：

- remote-session presence ledger 不会自动被 direct connect、ssh remote 复用

## 为什么这轮必须单列

如果不单列，正文最容易在三种误写里摇摆：

- 把 `directConnectServerUrl` 写成 presence ledger 的替身
- 把 `getIsRemoteMode()` 写成 presence truth
- 把 remote-session ledger 的专属 consumer / producer 边界写成 UI backlog

这三种都会把：

- remote interaction shell
- bootstrap display hint
- authoritative presence ledger

重新压扁。

## 本轮最关键的新判断

### 判断一：`remoteSessionUrl / remoteConnectionStatus / remoteBackgroundTaskCount` 的字段定义本身就指向 `--remote` / assistant viewer

### 判断二：`useRemoteSession()` 当前是这张账唯一明确的 producer

### 判断三：footer、brief line、`/session` 当前只消费这张账，不消费 direct connect / ssh remote 的 transport runtime

### 判断四：`directConnectServerUrl` 只是 bootstrap display hint，不能充当 presence ledger

### 判断五：`getIsRemoteMode()` 当前更像全局行为开关，而不是多 surface 共享的 presence truth

## 苏格拉底式自审

### 问：为什么不能只说“138 已经讲过不共享 ledger”？

答：因为 138 讲的是 REPL 顶层 abstraction；这一页讲的是这张 ledger 自己为什么本来就不通用。

### 问：为什么一定要把 `/session` 拉进来？

答：因为它能直接证明“命令显隐”和“这张账是否存在”不是同一层 remote 语义。

### 问：为什么一定要把 `getIsRemoteMode()` 写进来？

答：因为它最容易制造“remote mode = presence mode”的误读，而这正是这一页要拆开的误解。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/141-remoteSessionUrl、remoteConnectionStatus、remoteBackgroundTaskCount、useRemoteSession、activeRemote 与 getIsRemoteMode：为什么 remote-session presence ledger 不会自动被 direct connect、ssh remote 复用.md`
- `bluebook/userbook/03-参考索引/02-能力边界/130-remoteSessionUrl、remoteConnectionStatus、remoteBackgroundTaskCount、useRemoteSession、activeRemote 与 getIsRemoteMode 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/141-2026-04-07-remote session presence ledger split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 141
- 索引层只补 130
- 记忆层只补 141

不扩目录，不回写旧页。

## 下一轮候选

1. 单独拆 hook 侧 outboundOnly 本地语义与 env-based core 双向 wiring 为什么会形成 gray runtime。
2. 单独拆 `getIsRemoteMode()` 的全局行为开关与 presence truth 为什么不是同一层 remote 语义。
3. 单独拆 `post_turn_summary` 在 raw stream、callback surface 与 terminal semantics 三层为什么不是同一种 “可见”。
