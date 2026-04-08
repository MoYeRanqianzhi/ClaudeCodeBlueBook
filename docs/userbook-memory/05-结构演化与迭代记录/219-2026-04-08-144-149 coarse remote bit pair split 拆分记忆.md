# 144-149 coarse remote bit pair split 拆分记忆

## 本轮继续深入的核心判断

`144-149` 还不能被写成：

- 一条从 `/session` 一路走到 remote memory 的线性六连页

更准确的结构是：

- `144 -> 145` = `/session` 命令面与 URL-affordance failure 这一对
- `146 -> 147` = coarse remote 合同厚度与 remote-safe command shell 这一对
- `148 -> 149` = env-driven remote 轴与 memory persistence 这一对

所以这轮最该补的是：

- 一张新的 `05` 结构页，把 `144-149` 收成三组相邻配对
- 一张新的 `03` 索引页，把三对问题的归属钉死
- 一条新的持久化记忆，记录为什么这轮不把它们继续压成 `143` 的线性尾巴

## 为什么这轮不把 `148/149` 另开一支

### 判断一：`148` 的根句仍然接在 `143` 的 coarse remote bit 后面

`143` 先保护：

- `getIsRemoteMode()` 是 global behavior bit

`148` 再继续问：

- `CLAUDE_CODE_REMOTE` 为什么不是它的镜像

所以 `148` 并不是完全离开了这条线，

而是在 coarse remote bit 之后切出一条：

- env-driven remote 轴

因此更稳的结构不是把 `148/149` 完全单开，

而是把它作为第三对挂在 `143` 之后。

## 为什么这轮的三组最稳

### 判断二：`144 -> 145` 是 pane / URL pair

`144` 先拆：

- `/session` 命令显隐看 coarse bit
- pane 内容看 `remoteSessionUrl`

`145` 再继续拆：

- `remote bit = true`
- `URL = absent`

时，先坏掉的是 link / QR affordance，

不是 remote runtime 本体。

所以这对的主语一直没变：

- pane / URL affordance

### 判断三：`146 -> 147` 是合同厚度 / command-shell pair

`146` 先把 assistant viewer 与 `--remote` TUI 拆成：

- same coarse bit
- different contract thickness

`147` 再继续拆：

- remote-safe command surface
- 不等于 runtime readiness

所以这对的主语一直没变：

- command shell 只是合同厚度的外层 affordance

### 判断四：`148 -> 149` 是 env / memory pair

`148` 先把：

- env-driven remote 轴

从 interactive remote bit 里拆开。

`149` 再继续追：

- `CLAUDE_CODE_REMOTE_MEMORY_DIR`
- `memdir`
- `SessionMemory`
- `extractMemories`

为什么说明 remote memory 不是单根目录，而是双轨持久化体系。

所以这对的主语一直没变：

- env-driven remote persistence

## 本轮最关键的新判断

### 判断五：命令面、合同厚度、env 轴必须分三层

更稳的顺序是：

1. 先问命令该不该露出来
2. 再问 coarse bit 下合同厚度是不是一样
3. 最后再问 env-driven remote 轴下的持久化是不是同根

这样才能避免把：

- `/session`
- remote-safe commands
- `CLAUDE_CODE_REMOTE_MEMORY_DIR`

写成同一条 remote 尾巴。

### 判断六：`148/149` 仍然不需要下沉到症状专题

这轮主语还是：

- command affordance
- contract thickness
- env-driven persistence

都属于结构层，

不是新的用户症状层。

因此最稳的最小改动面仍然是：

- `05 + 03 + memory + README/阅读路径`

## 主树状态记录

本轮开始前已再次核对：

- `git fetch origin`
- `git rev-list --left-right --count HEAD...origin/main` = `11 0`

并发现：

- `/home/mo/m/projects/cc/analysis` 主树存在未解决冲突
- `merge --ff-only origin/main` 被阻断

所以本轮继续只在：

- `.worktrees/userbook`

里推进，不触碰主树冲突面。

## 苏格拉底式自审

### 问：我现在写的是 pane / URL、command shell，还是 env-driven memory？

答：如果一句话说不清自己属于哪一对，就不要落字。

### 问：我是不是把 safe 命令还在，当成了 runtime ready？

答：先问当前命令面回答的是 affordance，还是 readiness。

### 问：我是不是把 `CLAUDE_CODE_REMOTE` 和 `getIsRemoteMode()` 写成同一个 remote bit？

答：先分 env-driven remote 轴与 interactive bootstrap 轴。

### 问：我是不是把 `149` 又写成“remote memory 都落一根目录”？

答：先问它讲的是 memdir 根，还是 session ledger；这两者从一开始就不是同一账。
