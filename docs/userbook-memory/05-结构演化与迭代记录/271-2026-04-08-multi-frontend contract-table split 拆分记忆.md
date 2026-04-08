# multi-frontend contract-table split 拆分记忆

## 本轮继续深入的核心判断

在完成：

- 顶层 README 的多前端入口
- `00-阅读路径` 的路径 90
- `04-专题深潜/16`

之后，

这条线当前缺的不是：

- 再补正文
- 再补矩阵

而是：

- 把 IDE / Desktop / Mobile / session / remote-control 压成显式合同块

## 为什么这轮落点选 `03-参考索引/06`

### 判断一：前门、路径和专题都已具备，缺的是“高价值入口运行时合同速查”

这条线当前已经具备：

- 顶层目标入口
- 阅读路径
- 专题正文

而 `03-参考索引/06`

里原来只有：

- `/session`
- `/remote-control`

被显式收进合同层。

这会让：

- `/ide`
- `/desktop`
- `/mobile`

继续停留在正文层，而无法与 viewer / host 两类入口并列对照。

所以这轮最小且最高价值的一刀就是：

- multi-frontend contract-table

## 为什么这轮必须把五个对象压到同一组标题下

### 判断二：多前端线最容易被写错的，不是某个命令细节，而是对象间的相互错认

`16`

正文已经明确：

- `/ide` 是开发环境连接
- `/desktop` 是当前会话 handoff
- `/mobile` 是设备准备
- `/session` 是 viewer 侧接续地址
- `/remote-control` 是 host 侧宿主能力

如果合同层继续只写：

- `/session`
- `/remote-control`

读者就会把：

- `/ide`
- `/desktop`
- `/mobile`

继续当作正文里的零散功能，而不是与 viewer / host 并列的对象。

所以这轮必须把五个入口压到同一组标题下。

## 为什么 `/mobile` 必须显式保护“不是当前会话 handoff”

### 判断三：下载入口和接续入口是这条线里最常见的对象错位

`16`

正文已经写明：

- `/mobile` 解决的是 app 下载与设备准备

不是：

- 当前会话 continuation

如果合同层不把这点显式写死，

读者会不断把：

- `/mobile`

误写成：

- `/desktop` 的移动版
- 或 `/session` 的手机版

## 为什么 `/ide` 也必须单列

### 判断四：开发环境连接不是应用启动

`/ide`

真正处理的是：

- 可连接与不可连接实例
- workspace 匹配
- auto-connect 与当前连接状态

所以它的主语不是：

- 打开某个编辑器

而是：

- Claude Code 与当前开发环境的连接关系

如果不单列，

读者会继续把它和 `/desktop`、`/mobile`

写成同一种前端切换按钮。

## 为什么这轮不把 `/chrome`、`/voice` 混进稳定主线

### 判断五：它们属于条件前端或条件输入通道，不是多前端稳定主线

`16`

正文已经明确：

- `/chrome`
- `/voice`

都属于条件面。

所以这轮合同块必须只收：

- 稳定主线
- 稳定但带前提的 handoff / viewer / host

不把：

- 条件浏览器前端
- 条件语音输入

混回同层。

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git rev-parse HEAD origin/main`

返回：

- `HEAD = 9a6085ae3a95218282b701899647ca0e1a11a705`
- `origin/main = 9a6085ae3a95218282b701899647ca0e1a11a705`

因此本轮 multi-frontend contract-table 切片开始前，主仓库至少在 fetch 视角与 `origin/main` 同步；本轮仍继续只在：

- `.worktrees/userbook`

推进文档切片。

## 苏格拉底式自审

### 问：我现在缺的是再解释 `16` 的正文，还是缺把五个前端对象压成速查层显式合同块？

答：如果前门、路径和正文都已存在，当前更缺的是合同速查。

### 问：我是不是又想把 `/desktop`、`/mobile`、`/session` 写成同一种 continuation 入口？

答：如果不把 handoff、设备准备和 viewer 接续分开，这个误判会立刻复发。

### 问：我是不是又要把 `/chrome`、`/voice` 混回这条稳定主线？

答：如果不显式把条件前端和条件输入通道排除，这条线又会被写平。
