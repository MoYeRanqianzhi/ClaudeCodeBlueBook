# long-task continuity contract table refinement 拆分记忆

## 本轮继续深入的核心判断

上一轮 continuity contract table 已经补上：

- 落点
- continuity cluster
- 默认/条件边界

本轮继续深入后发现，

表还缺两刀更基础的收口：

- 把 `/context` + `/files` 拉回 continuity 链起点
- 把表头改成“什么时候用 / 延续或观察的对象 / 不要误用成”

## 为什么 `/context` + `/files` 应进入 continuity 入口组

### 判断一：continuity 不只是在“怎么接回”，还包括“先确认当前现场是什么”

`02-连续性与记忆专题`

开头就把：

- `/context`
- `/files`

放在“上下文观察”一节，

说明 continuity 主线并不是从：

- `/memory`
- `/compact`
- `/resume`

才开始，

而是从：

- 先确认当前共同工作现场

就已经开始。

如果速查表缺这一行，

用户仍会误把 continuity 理解成：

- 纯恢复链

而不是：

- 观察现场
- 延续现场
- 外化现场

的一整条链。

## 为什么表头要改成“什么时候用”

### 判断二：continuity 里最大的误判首先是时机误判，其次才是语义类比误判

“更像什么”

有助于解释类比，

但 continuity 主线最先要解决的是：

- 现在到底该用哪一个

也就是：

- 什么时候先看现场
- 什么时候沉淀长期规则
- 什么时候压缩
- 什么时候恢复
- 什么时候命名
- 什么时候外化

所以更稳的最小表头应当是：

- `入口`
- `什么时候用`
- `延续或观察的对象`
- `不要误用成`

这样可以直接承接：

- 主线页的动作判断
- 专题页的对象边界

## 为什么这轮不把 prompt history、custom title 搜索、session preview 拉进同一张表

### 判断三：这些能力属于“找到过去工作对象”，不是 continuity 主干上的当前对象续接

并行只读分析提示：

- prompt history
- custom title 搜索
- session preview

更应留在：

- `04-专题深潜/12`

这条“过去对象发现与恢复选择”线。

如果把它们一起拉进 continuity contract table，

就会再次把：

- 当前对象如何继续
- 过去对象如何被找到

写平。

所以这轮 contract table 只保留：

- continuity 主干

不把 discovery branch 并入主表。

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git rev-parse HEAD origin/main`

返回：

- `HEAD = 6dc2cdb43beb03b5d5e6e7acaf09455d4d095aae`
- `origin/main = 6dc2cdb43beb03b5d5e6e7acaf09455d4d095aae`

所以本轮 refinement 前，主分支仍与远端一致。

## 苏格拉底式自审

### 问：我是不是又把 continuity 缩成了“恢复命令表”，而忽略了先看现场这一步？

答：只要 `/context` + `/files` 不在表里，这个误判就还在。

### 问：我现在最缺的是再加更多入口，还是先把“什么时候用”说清？

答：如果表还不能直接回答动作时机，就不该先继续扩入口数量。

### 问：我是不是想把 discovery branch 全拉进主表，结果又抹掉 continuity 与 session discovery 的边界？

答：如果 prompt history、title search、preview 进主表，这条边界又会被冲淡。
