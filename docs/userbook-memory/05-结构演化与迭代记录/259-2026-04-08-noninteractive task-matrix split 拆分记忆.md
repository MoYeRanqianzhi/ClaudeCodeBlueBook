# noninteractive task-matrix split 拆分记忆

## 本轮继续深入的核心判断

在完成：

- 顶层 README 的自动化入口
- 路径 9
- `04-专题深潜/13`
- `04-专题深潜/README` 的 topic route
- `03-参考索引/06` 的 `-p/--print`、`--bg`、`--sdk-url` 合同块

之后，

这条线当前缺的不是：

- 再扩合同速查
- 再写专题正文

而是：

- 把 noninteractive automation 压进任务视角的一跳矩阵

## 为什么这轮落点选 `03-参考索引/05`

### 判断一：`03-参考索引/05` 才回答“我现在该先走哪个入口”

`03-参考索引/06`

已经能回答：

- `-p/--print`
- `--bg`
- `--sdk-url`

背后的运行时合同。

但矩阵层仍没有直接回答：

- 我要一次性拿结果
- 我要把当前会话里的任务放到后台
- 我要让整个 CLI 会话脱离当前终端
- 我要把 Claude Code 接进协议宿主

这些目标分别先走什么入口。

所以这轮该补的是：

- task-to-entry matrix

不是：

- 新合同页

## 为什么这轮要拆成三刀半，而不是继续写成一个“自动化”总类

### 判断二：自动化线上最容易误写的，不是稳定性，而是对象主语

当前矩阵里原本只有：

- `claude -p/--print`
- `Agent + Task* + /tasks`

它们分别覆盖：

- 一次性结果
- 当前会话里的后台任务

却没有显式收：

- CLI 后台会话：`claude --bg` + `ps/logs/attach/kill`
- 协议宿主：`--sdk-url` + `stream-json`

如果继续把它们写成：

- “长任务后台跑”

读者就会再次把：

- 当前会话里的任务后台化
- 整个 CLI 会话后台化
- 协议流宿主化

压成同一种后台。

所以这轮矩阵至少要拆成：

- 脚本化一次性输出
- 把 Claude Code 接进协议宿主
- 在当前会话里把长任务放到后台
- 让 CLI 会话脱离当前终端继续活着

## 为什么这轮要顺手重命名 `Agent + Task*` 那一行

### 判断三：不重命名就会继续与 `--bg` 撞主语

原来的：

- “长任务后台跑”

太容易被读成：

- 所有后台化都是这一行

但 `Agent + Task* + /tasks`

回答的是：

- 当前会话内部的任务对象

不是：

- 整个 CLI 会话的生命周期

所以这轮必须把它显式改成：

- “在当前会话里把长任务放到后台”

这样才有空间把：

- `claude --bg` + `ps/logs/attach/kill`

单列为：

- “让 CLI 会话脱离当前终端继续活着”

## 为什么这轮不把 direct connect / remote 深线写回矩阵

### 判断四：这一刀只收入口对象，不收 deeper transport 分叉

`13`

正文和：

- `05-控制面深挖/20`
- `05-控制面深挖/非交互结果、summary 与协议流/README`

已经把：

- headless host
- summary / tail / restore
- wire / callback / projection

这些 deeper 分叉挂起来了。

矩阵层当前只需要先回答：

- 结果
- 当前会话任务
- CLI 后台会话
- 协议宿主

四种对象的 first-hop。

所以这轮不把：

- direct connect
- remote session deeper pages

重新压回同层。

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git rev-parse HEAD origin/main`
- `git pull --ff-only origin main`

返回：

- `HEAD = 9cb9fb702f5ea1590a16b15638d4c875284dabc2`
- `origin/main = 9cb9fb702f5ea1590a16b15638d4c875284dabc2`
- `Already up to date.`

因此本轮 noninteractive task-matrix 切片开始前，主仓库处于同步状态。

## 苏格拉底式自审

### 问：我现在缺的是再说一遍自动化合同，还是缺把用户任务写回“先按哪个入口”的矩阵层？

答：如果合同页已经存在，当前更缺的是矩阵层。

### 问：我是不是又想把 `Agent + Task*` 和 `--bg` 叫成同一种后台？

答：如果不重命名旧行并新增 CLI 后台会话行，这个误判会立刻复发。

### 问：我是不是又想把 direct connect / remote deeper branch 混回矩阵层？

答：矩阵层只该先收入口对象，不该提前压入 deeper transport 分叉。
