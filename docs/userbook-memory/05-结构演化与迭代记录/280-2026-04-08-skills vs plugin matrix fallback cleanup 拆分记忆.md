# skills vs plugin matrix fallback cleanup 拆分记忆

## 本轮继续深入的核心判断

在已经完成：

- task-matrix object-triage cleanup
- object triage mini-tables

之后，

矩阵层里最显眼的一条残余对象错位，

已经收缩到：

- `扩展工作流 | skills | plugin`

这行本身。

## 为什么这轮仍落点选 `03-参考索引/05`

### 判断一：如果表格单行还在暗示错误 fallback，下面的分诊表就会被上面的错误信号抵消

前面已经补了：

- 分诊规则
- 迷你对照表

但如果主表正文仍然写着：

- `skills -> plugin`

读者会继续先吸收错误的 first-hop，

再被迫用下面的说明纠偏。

所以这轮最小且必要的一刀就是：

- 把这条假 fallback 去掉

## 为什么 `plugin` 不能当 `skills` 的次选入口

### 判断二：方法论固化和打包分发不是同一种对象

`skills`

回答的是：

- 让 Claude 以后按这套方法做

而：

- `plugin`

回答的是：

- 把一组 skills / hooks / MCP 打包、启停、分发和管理

如果继续把 `plugin` 写成 `skills` 的次选入口，

读者会继续把：

- 工作流封装

和：

- 扩展包管理

压成同一步。

## 为什么这轮只改一行

### 判断三：这里的问题已经不是缺少更多说明，而是表格主信号和分诊说明仍然互相冲突

当前缺的不是：

- 再补一段文字

而是：

- 让主表本身不再自相矛盾

所以这轮只改：

- 一条 `次选入口`

不继续扩大切口。

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git pull --ff-only origin main`
- `git rev-parse HEAD origin/main`

返回：

- `pull = Already up to date.`
- `HEAD = 9a6085ae3a95218282b701899647ca0e1a11a705`
- `origin/main = 9a6085ae3a95218282b701899647ca0e1a11a705`

因此本轮 skills vs plugin matrix fallback cleanup 切片开始前，主仓库在 fast-forward 视角与 `origin/main` 同步；本轮仍继续只在：

- `.worktrees/userbook`

推进文档切片。

## 苏格拉底式自审

### 问：我现在缺的是再加解释，还是把表格里最明显的错误 fallback 删掉？

答：如果解释已经足够，当前更缺的是让主表不再发出错误信号。

### 问：我是不是还在把“可封装的方法”与“可打包的扩展”当成同一种对象？

答：如果继续保留 `skills -> plugin`，这个误判就还在主表里。

### 问：我是不是又想顺手改更多行，结果把这笔极小修正膨胀成另一轮大整理？

答：这轮的价值就在于只修掉最明显的一条残余错位，不必扩张。
