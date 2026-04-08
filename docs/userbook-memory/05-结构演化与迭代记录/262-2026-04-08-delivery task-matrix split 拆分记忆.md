# delivery task-matrix split 拆分记忆

## 本轮继续深入的核心判断

在完成：

- 顶层 README 的 delivery 入口
- 路径 6
- `04-专题深潜/09`
- `04-专题深潜/README` 的 delivery topic route
- `03-参考索引/06` 里的 `/commit`、`/commit-push-pr`、`/review` / `ultrareview` 合同块

之后，

这条线当前缺的不是：

- 再补正文
- 再扩合同页

而是：

- 把 delivery 压进任务视角的一跳矩阵

## 为什么这轮落点选 `03-参考索引/05`

### 判断一：`03-参考索引/05` 才回答“我现在该先按哪个入口”

`03-参考索引/06`

已经能回答：

- `/commit`
- `/commit-push-pr`
- `/review` 与 `ultrareview`
- `/export`
- `/feedback`

背后的运行时合同。

但矩阵层仍没有直接回答：

- 我要本地审查
- 我要远程深审
- 我要收口 commit
- 我要升级成 PR
- 我要正式导出
- 我要把摩擦带着证据回流产品侧

这些目标分别先走什么入口。

所以这轮该补的是：

- task-to-entry matrix

不是：

- 新合同块

## 为什么这轮不能把 `/review` 和 `ultrareview` 写成主次关系

### 判断二：它们不是同一路径的深浅两档，而是不同宿主与稳定性

旧矩阵里：

- `/review` -> `ultrareview`

看起来像：

- 本地版本
- 远程增强版

但 `09`

和 `06`

都已经明确：

- `/review` 是本地稳定审查路径
- `ultrareview` 是灰度 / 条件的远程深审路径

所以这轮必须把它们拆成两行：

- 在本地审查当前 PR 或分支
- 走远程深审路径

这样才能保护：

- 宿主差异
- 成本模型差异
- 稳定性差异

## 为什么这轮要新增 `/commit-push-pr`

### 判断三：PR 升级对象不等于 commit 收口

旧矩阵里只有：

- `/commit`

却没有：

- `/commit-push-pr`

这会让“提交”和“升级成团队协作对象”

重新压成一件事。

但这条线真正要保护的是：

- commit 是工作树收口
- PR 是 branch + PR 协作对象升级

所以这轮必须单列：

- 把本地变化升级成 branch + PR

## 为什么这轮要把 `/copy` 和 `/export` 分开

### 判断四：临时带出和正式外化不是同一种交付对象

旧矩阵把：

- `/copy`
- `/export`

写成同一行，

会让读者误以为：

- export 只是 copy 的放大版

但 `09`

正文已经明确：

- `/copy` 更像临时带出
- `/export` 是正式外化到文件系统或交接流程

所以这轮应拆成两行：

- 把当前结果临时带出会话
- 把当前会话正式外化到文件系统或交接流程

## 为什么这轮要把 `/feedback` 收进矩阵

### 判断五：feedback 的缺席，会让“产品回路”在任务视角上完全消失

即使它是：

- 条件公开
- 受 provider / privacy / policy 影响

它仍然是：

- 正式的用户任务入口

如果矩阵完全不收这行，

读者会继续把：

- feedback

当成：

- 文档边角
- 或外部 issue 的同义词

所以这轮必须单列：

- 把当前摩擦连同现场证据回流产品侧

同时显式写出：

- 条件公开
- 受 provider/privacy/policy 限制

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git rev-parse HEAD origin/main`
- `git pull --ff-only origin main`

返回：

- `HEAD = 9cb9fb702f5ea1590a16b15638d4c875284dabc2`
- `origin/main = 9cb9fb702f5ea1590a16b15638d4c875284dabc2`
- `Already up to date.`

因此本轮 delivery task-matrix 切片开始前，主仓库处于同步状态。

## 苏格拉底式自审

### 问：我现在缺的是再解释 delivery 合同，还是缺把用户任务写回“先按哪个入口”的矩阵层？

答：如果合同页已存在，当前更缺的是矩阵层。

### 问：我是不是又想把 `/review` 和 `ultrareview` 写成同一路径的主次关系？

答：如果不拆成两行，这个宿主误判会立刻复发。

### 问：我是不是又要把 `/copy` 和 `/export` 写成同一种外化动作？

答：如果不分临时带出和正式外化，这个误写会再次出现。
