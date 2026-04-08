# evolution README recent-batch split 拆分记忆

## 本轮继续深入的核心判断

在已经完成：

- memory root hub cleanup

之后，

维护侧还有一个明显前门问题：

- `05-结构演化与迭代记录/README.md`

仍然让最近批次和全量档案挤在同一条长列表里。

## 为什么这轮仍落点选 `05-结构演化与迭代记录/README.md`

### 判断一：演化档案页首先应该回答“我是想看最近几轮，还是想追全量历史”

当前这页同时承载两种需求：

- 找最近几轮切片
- 追早期与全量演化历史

但它没有先把这两种阅读动作分开，

于是最近批次会被埋到长列表尾部，

而全量历史又会压住最近前门。

所以这轮该补的是：

- recent-batch split

## 为什么这轮只把 `273-281` 抬到前面

### 判断二：最近批次已经形成一段连续的前门/矩阵/合同/维护侧收敛带

最近这几轮并不是随机条目，

而是连续在做：

- root/readme hub cleanup
- reference/topic/control/memory hub cleanup
- task-matrix object triage
- contract-table 补全

把这组条目抬到前面，

读者就能先看到：

- 当前继续深入的主线切法

而不必先翻完整个历史长表。

## 为什么这轮不删尾部重复链接

### 判断三：这轮的目标是加前门，不是重写整份档案表

当前更缺的是：

- 最近批次先露出来

而不是：

- 立刻去重整份长列表

所以这轮先：

- 在顶部加 `最近批次`
- 再加 `全量档案`

让层级先成立。

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git pull --ff-only origin main`
- `git rev-parse HEAD origin/main`

返回：

- `pull = Already up to date.`
- `HEAD = 9a6085ae3a95218282b701899647ca0e1a11a705`
- `origin/main = 9a6085ae3a95218282b701899647ca0e1a11a705`

因此本轮 evolution README recent-batch split 切片开始前，主仓库在 fast-forward 视角与 `origin/main` 同步；本轮仍继续只在：

- `.worktrees/userbook`

推进文档切片。

## 苏格拉底式自审

### 问：我现在缺的是重写整份档案页，还是先让最近批次露出来？

答：如果当前最近批次已经被埋到底部，先把它抬出来更值钱。

### 问：我是不是又想一口气把全量档案去重、分批、重排完？

答：这轮先补前门层级，不扩大成整页重构。

### 问：我是不是把“最近几轮切片”与“追全量历史”当成同一种阅读动作？

答：如果不把这两种动作拆开，演化档案页就会继续难以扫描。
