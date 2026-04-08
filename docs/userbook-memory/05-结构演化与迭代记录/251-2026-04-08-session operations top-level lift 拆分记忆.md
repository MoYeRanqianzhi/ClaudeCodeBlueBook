# session operations top-level lift 拆分记忆

## 本轮继续深入的核心判断

`session operations`

也就是：

- `/copy`
- `/rename`
- `/export`
- `/branch`
- `/rewind`
- `/clear`

这条线现在已经有：

- `04-专题深潜/07`
- `03-参考索引/06` 里的局部合同

当前真正还缺的不是：

- 新专题正文
- 新参考索引页

而是：

- 顶层 README 的独立目标入口

## 为什么这轮先补顶层入口

### 判断一：用户最先缺的不是术语解释，而是“我该往哪条线走”

当前顶层 README 已经独立抬了：

- continuity
- extension operations
- settings/status/budget

但：

- `copy/rename/export/branch/rewind/clear`

这组仍然只散在专题目录和正文里。

这会让用户继续把它们听成：

- 杂项命令

而不是：

- 当前工作对象运营动作

所以这轮先补：

- top-level discoverability

不是：

- deeper body rewrite

## 为什么顶层入口应先直达专题 07

### 判断二：当前还没有 dedicated path，专题 07 本身已经足够充当第一跳

这条线和 continuity 不同，

当前还没有：

- 单独阅读路径

但：

- `04-专题深潜/07`

已经把对象分工写清：

- 可识别
- 可交付
- 时间线改写

所以顶层入口最稳的第一跳应当是：

- 直接到专题 07

而不是：

- 先为它补一条路径，再回头补顶层

## 为什么这轮要和 session discovery / continuity 主线分开

### 判断三：这条线回答的是“当前工作对象怎么被运营”，不是“当前对象怎么继续”也不是“过去对象怎么被找到”

`04-专题深潜/07`

关心的是：

- 当前工作对象怎么命名
- 怎么外化
- 怎么分叉
- 怎么回退
- 怎么切出新空工作面

`04-专题深潜/02`

更关心：

- continuity

`04-专题深潜/12`

更关心：

- past-object discovery

如果顶层不把这三者分开，

用户就会继续把：

- `/branch`
- `/rewind`
- `/clear`

误压进：

- continuity

或者：

- 旧会话恢复

## 为什么这轮不同时补专题层和路径层

### 判断四：先补最外层物理前门，再决定是否需要中层接力

当前最明显的缺口仍在：

- 顶层 README

专题层 `04-专题深潜/README`

虽然还没独立抬这条线，

但它属于：

- 已经进入专题层后的 second-hop

收益低于顶层缺口。

阅读路径层也是同理：

- 现在先缺物理前门
- 不是先缺路径排序

所以这轮只补：

- 顶层 README

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git rev-parse HEAD origin/main`

返回：

- `HEAD = 6dc2cdb43beb03b5d5e6e7acaf09455d4d095aae`
- `origin/main = 6dc2cdb43beb03b5d5e6e7acaf09455d4d095aae`

所以本轮继续推进 session operations 入口前，主分支仍与远端一致。

## 苏格拉底式自审

### 问：我现在缺的是再讲一次 `/branch`、`/rewind`、`/clear`，还是缺让用户在顶层就知道这是一条独立工作线？

答：如果专题页和速查页都已有，先缺的是顶层可发现性。

### 问：我是不是又把这组动作压回成“杂项命令”，而没保住“当前工作对象运营”这个主语？

答：只要顶层没把它当目标入口抬出来，这个误判就会继续。

### 问：我是不是又想一口气补顶层、专题层、路径层，而不是先切最外层这一刀？

答：如果目标是最小有效修复，就应先补最外层前门。
