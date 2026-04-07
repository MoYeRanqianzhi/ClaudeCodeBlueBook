# remote behavior flag split 拆分记忆

## 本轮继续深入的核心判断

142 已经把 gray runtime 压到 hook/core 分叉面。

如果再不把 `getIsRemoteMode()` 单独拆开，正文还是会滑成：

- “既然很多地方都看它，它就是全局 remote truth。”

这轮要补的更窄一句是：

- `getIsRemoteMode()` 是全局 remote behavior 开关，不等于 remote presence truth

## 为什么这轮必须单列

如果不单列，正文最容易在三种误写里摇摆：

- 把广泛 consumer 偷换成 authoritative truth
- 把 `activeRemote.isRemoteMode` 与 `getIsRemoteMode()` 压成同一层语义
- 把 `/session` 的命令显隐和 pane 内容 gate 写成同一层 remote mode

这三种都会把：

- turn shell
- global behavior flag
- presence ledger

重新压扁。

## 本轮最关键的新判断

### 判断一：`getIsRemoteMode()` / `setIsRemoteMode()` 当前只是 bootstrap 布尔位

### 判断二：remote-session 路径当前会显式设置它，direct connect 当前不会

### 判断三：很多 consumer 只是在拿它做“要不要继续本地行为”的分支，不是在读取 presence 账

### 判断四：`/session` 的双重 gate 证明命令显隐与 presence 内容不是同一层

### 判断五：它和 `activeRemote.isRemoteMode` / `remoteSessionUrl` 是三种不同层级的 remote 语义

## 苏格拉底式自审

### 问：为什么不能只说“141 已经讲了 ledger，不必再讲 flag”？

答：因为这页的重点不是哪张账，而是为什么一个广泛被消费的布尔位仍然不是账。

### 问：为什么一定要把 `/session` 的 index 和 pane 一起写进来？

答：因为只有这样才能把“命令显隐”与“presence 内容”拆成两层，最能避免误写。

### 问：为什么一定要把 `activeRemote.isRemoteMode` 拉进来？

答：因为否则读者会把 REPL turn shell 和 global behavior flag 继续压平。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/143-getIsRemoteMode、setIsRemoteMode、activeRemote、remoteSessionUrl、commands-session 与 StatusLine：为什么全局 remote behavior 开关，不等于 remote presence truth.md`
- `bluebook/userbook/03-参考索引/02-能力边界/132-getIsRemoteMode、setIsRemoteMode、activeRemote、remoteSessionUrl、commands-session 与 StatusLine 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/143-2026-04-07-remote behavior flag split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 143
- 索引层只补 132
- 记忆层只补 143

不扩目录，不回写旧页。

## 下一轮候选

1. 单独拆 `post_turn_summary` 在 raw stream、callback surface 与 terminal semantics 三层为什么不是同一种 “可见”。
2. 单独拆 remote-session pane 显隐和 pane 内容的双重 gate 为什么不是同一种 remote mode。
3. 单独拆 `getIsRemoteMode()` 为真却没有 `remoteSessionUrl` 时，哪些 consumer 仍会工作、哪些 consumer 会停摆。
