# capability map hub cleanup 拆分记忆

## 本轮继续深入的核心判断

在已经完成：

- root README hub cleanup
- reference/topic/control hub layering
- memory root hub cleanup

之后，

读者侧顶层前门里最后一个还没真正分层的，

已经收缩到：

- `02-能力地图/README.md`

本身。

## 为什么这轮落点选 `02-能力地图/README.md`

### 判断一：能力地图页首先应该回答“五个子层分别解决什么问题”

当前这页只有：

- 一句角色说明
- 五个裸链接

但没有先回答：

- `01` 在看什么
- `02` 在看什么
- `03` 在看什么
- `04` 在看什么
- `05` 在看什么

如果不把这层写明，

根 README 把读者送到这里以后，

读者还是得自己猜：

- 到底该进哪一层

## 为什么这轮要补范围说明

### 判断二：能力地图不是工作主题 first-hop，也不是任务速查页

能力地图页回答的是：

- 为什么 Claude Code 这样实现

而不是：

- 眼前工作问题先走哪个专题
- 当前任务先走哪个入口

所以这轮要显式写出：

- 工作主题 first-hop 回根 README
- 入口速查看 `03`
- 控制面主权看 `05`

让能力地图页回到它自己的角色。

## 为什么这轮只补“五个子层分别回答什么”

### 判断三：当前缺的是层级说明，不是扩大成新的长索引

这轮不需要：

- 新开叶子页
- 重写 `02` 子目录

只需要：

- 给五个子层补一句对象说明

这样这页就从：

- 裸目录

变成：

- 真正可扫描的前门

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git pull --ff-only origin main`
- `git rev-parse HEAD origin/main`

返回：

- `pull = Already up to date.`
- `HEAD = 9a6085ae3a95218282b701899647ca0e1a11a705`
- `origin/main = 9a6085ae3a95218282b701899647ca0e1a11a705`

因此本轮 capability map hub cleanup 切片开始前，主仓库在 fast-forward 视角与 `origin/main` 同步；本轮仍继续只在：

- `.worktrees/userbook`

推进文档切片。

## 苏格拉底式自审

### 问：我现在缺的是再补叶子，还是先让能力地图自己解释五个子层的分工？

答：如果读者落到这页还要靠猜，当前更缺的是 hub cleanup。

### 问：我是不是又把能力地图页当成工作主题 first-hop？

答：如果它主要回答的是实现主链，就应该把工作主题和任务速查明确转回别的前门。

### 问：我是不是又想重写整份能力地图目录，其实只需要补五句对象说明？

答：这轮的价值就在于用最小说明把五个子层变成可扫描入口，不必扩大成整页重构。
