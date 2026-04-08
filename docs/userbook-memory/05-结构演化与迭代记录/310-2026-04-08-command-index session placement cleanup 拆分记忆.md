# command-index session placement cleanup 拆分记忆

## 本轮继续深入的核心判断

这一轮最值得收的，

不是再扩 remote 命令边界，

而是把命令索引里重复出现的：

- `/session`

收回到唯一正确的那一层。

## 为什么这轮值得单独提交

### 判断一：`/session` 不该同时像普通会话导航项和 remote viewer 项

当前命令索引里：

- `/session`

在：

- `会话与导航`

和：

- `远程与桥接`

各出现了一次。

但既有合同页已经明确：

- `/session` 是 viewer 侧接续
- 只在 remote mode 下成立
- 不属于 host 侧控制能力

所以把它放在通用“会话与导航”组里，

会重新把它讲成：

- 普通会话导航入口

## 这轮具体怎么拆

### 判断二：删除前面的重复项，并把 remote 组那一项补成完整边界句

这轮只做两件事：

1. 从：
   - `会话与导航`
   组里删掉重复的 `/session`
2. 保留：
   - `远程与桥接`
   组里的 `/session`
   并补成：
   - `viewer 侧接续，remote mode only`

这样：

- 命令索引的组内归属恢复唯一
- `/session` 与 `/remote-control` 的 viewer/host 边界更清楚

## 为什么这轮不继续改矩阵或合同页

### 判断三：其它层已经对齐，问题只剩命令索引的重复落位

任务矩阵和合同速查里，

- `/session`

已经在 remote / viewer 侧边界上写清楚。

真正残留的是：

- 命令索引重复落位

所以这轮不扩大范围。

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git pull --ff-only origin main`

结果是：

- `pull` 成功：`Already up to date.`

因此本轮继续深入仍只在：

- `.worktrees/userbook`

推进。

## 苏格拉底式自审

### 问：我是不是因为 `/session` 和“会话”同名，就把它自动归到通用会话导航？

答：不能。它回答的是 remote viewer 接续，不是本地会话导航总入口。

### 问：我是不是该把 `/session` 从命令索引完全删掉？

答：不需要。它仍是一个公开命令，只是应放在 remote 组里单点解释。

### 问：我是不是在做纯排版清理？

答：不是。重复落位会直接改写命令对象归属，属于结构性误导。
