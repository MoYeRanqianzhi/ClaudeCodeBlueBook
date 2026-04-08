# memory root hub cleanup 拆分记忆

## 本轮继续深入的核心判断

在连续补完：

- root README hub cleanup
- topic README front-door split
- control README front-door split

之后，

维护侧前门里最明显还没分层的，

已经收缩到：

- `docs/userbook-memory/README.md`

本身。

## 为什么这轮落点选 `docs/userbook-memory/README.md`

### 判断一：维护侧前门也应先回答“我是在找方法规则，还是在找最近的切片档案”

当前 memory README 里已经有：

- 方法论
- 结构演化
- 边界写作规范
- 稳定/灰度保护原则

但这些入口仍被压成一组平表。

这会让维护者看不出：

- 哪些内容在回答“怎么继续写”
- 哪些内容在回答“最近几轮怎么拆”

所以这轮该补的是：

- memory root hub cleanup

## 为什么这轮要拆成“方法与规则”和“结构演化档案”

### 判断二：这两类对象的时间尺度不同

方法与规则更接近：

- 稳定维护原则
- 写作边界
- 第一性原理和苏格拉底诘问法

而结构演化档案更接近：

- 本轮怎样切片
- 为什么这样提交
- 继续深入时下一刀怎么选

如果不把这两类对象拆开，

维护侧前门就会继续把：

- 长期规则

和：

- 近期演化记录

压成同一种入口。

## 为什么这轮不去动 `05-结构演化与迭代记录/README.md`

### 判断三：当前缺的是 memory 根前门的分层，不是演化档案本体的再整理

`05-结构演化与迭代记录/README.md`

当然还很长，

但它目前主要服务的是：

- 已经知道自己要找演化档案的维护者

当前更缺的是：

- 在 memory 根前门上先把“方法规则”与“演化档案”分开

所以这轮先不动 `05` 本体。

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git pull --ff-only origin main`
- `git rev-parse HEAD origin/main`

返回：

- `pull = Already up to date.`
- `HEAD = 9a6085ae3a95218282b701899647ca0e1a11a705`
- `origin/main = 9a6085ae3a95218282b701899647ca0e1a11a705`

因此本轮 memory root hub cleanup 切片开始前，主仓库在 fast-forward 视角与 `origin/main` 同步；本轮仍继续只在：

- `.worktrees/userbook`

推进文档切片。

## 苏格拉底式自审

### 问：我现在缺的是继续整理演化档案本体，还是先把 memory 根前门分清用途？

答：如果当前连入口用途都还混在一起，先分清前门用途更值钱。

### 问：我是不是又把长期方法规则和近期切片档案写成同一种维护材料？

答：如果不把两者拆层，维护侧导航就会继续失焦。

### 问：我是不是又想顺手扩大到 `05-结构演化与迭代记录/README.md` 本体？

答：这轮的价值就在于先修 memory 根前门，不必扩大到档案长页。
