# root readme hub cleanup 拆分记忆

## 本轮继续深入的核心判断

在连续补完：

- topic-route
- task-matrix
- contract-table
- section hub cleanup

之后，

当前最容易继续拖慢首跳阅读的，

不再是某条专题叶子缺正文，

而是：

- 根 `README`

仍然把顶层 hub 和目标直达路由压在同一层前门。

## 为什么这轮落点选 `bluebook/userbook/README.md`

### 判断一：根 README 首先应该回答“我现在该进哪一类总入口”

根 README 当然可以保留：

- 按目标进入

但它首先还应该回答：

- 我现在该先进 `01`
- 还是 `03`
- 还是 `04`
- 还是 `05`

如果这一层不先露出来，

读者就会先被迫进入：

- 具体目标分流

而不是：

- 顶层结构分流

这会让根 README 先承担过多叶子路由，再把真正的 hub 埋到后面。

## 为什么这轮只补“先按目录结构进入”，不大改“按目标进入”

### 判断二：当前缺的是前门分层，不是把目标路由全部推翻重写

这轮的问题不在于：

- 目标导向入口本身错误

而在于：

- 顶层 hub 露出得太晚

所以最小且最稳的一刀不是：

- 重写整份 README

而是：

- 在最上层先加一组顶层 hub
- 再把现有目标路由保留为第二层入口

## 为什么底部“结构导航”也要改名

### 判断三：如果顶部已经有顶层 hub，底部同名“结构导航”就不该继续冒充同一层前门

当前顶部补完后，

底部那组全量目录仍然有价值，

但它更像：

- 完整目录回看面

而不再是：

- 首个顶层入口

所以这轮把它改成：

- 完整结构导航

让：

- 顶部承担 first-hop hub
- 底部承担 full navigation

## 为什么这轮不继续直链更多深页

### 判断四：根 README 的职责是尽快把读者交给中层 hub，而不是长期替代中层 hub

现在已经存在：

- `04-专题深潜/README`
- `05-控制面深挖/README`
- `03-参考索引/README`

这些中层 hub。

如果根 README 继续不断扩张对深页的直链密度，

就会重新把：

- 顶层 router

写成：

- 超长问题账本

所以这轮选择的是：

- 先让根 README 回到“总入口”角色

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git pull --ff-only origin main`
- `git rev-parse HEAD origin/main`

返回：

- `pull = Already up to date.`
- `HEAD = 9a6085ae3a95218282b701899647ca0e1a11a705`
- `origin/main = 9a6085ae3a95218282b701899647ca0e1a11a705`

因此本轮 root README hub cleanup 切片开始前，主仓库在 fast-forward 视角与 `origin/main` 同步；本轮仍继续只在：

- `.worktrees/userbook`

推进文档切片。

## 苏格拉底式自审

### 问：我现在缺的是再加更多深页直链，还是先让根 README 像一个真正的顶层 router？

答：如果中层 hub 已经存在，当前更缺的是顶层 router 分层。

### 问：我是不是又想通过大改整份 README，去解决其实只是入口层级过平的问题？

答：如果问题只是顶层 hub 暴露太晚，先加一组 first-hop hub 比整体重写更稳。

### 问：我是不是把底部“结构导航”和顶部新加的 hub 当成同一种入口？

答：如果顶部负责 first-hop，底部就应该改回 full navigation，而不是继续和顶部争同一层角色。
