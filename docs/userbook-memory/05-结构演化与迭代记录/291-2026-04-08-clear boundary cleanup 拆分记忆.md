# clear boundary cleanup 拆分记忆

## 本轮继续深入的核心判断

这轮最值得先收的，

不是再扩 session operations 主线的全体解释，

而是把：

- `/clear`

从会话运营专题里被半步压错的分组中拉出来。

## 为什么这轮落点选 `04-专题深潜/07-会话运营、分叉与回退专题.md`

### 判断一：索引层已经分对了，但专题分组标题还留着旧压平

索引层已经把：

- `/branch`
- `/rewind`
- `/clear`

区分成三种不同对象：

- `/branch` 是新时间线分支
- `/rewind` 是受约束恢复点
- `/clear` 是新的空工作面 / 新 session id

但会话运营专题的第三段标题还写成：

- 改写当前工作对象的时间线

并把：

- `/branch`
- `/rewind`
- `/clear`

并列塞进去。

这会让读者先吸收成：

- `/clear` 也是时间线分叉 / 回退的一种

而这和正文后半段已经写明的：

- `切出新的空工作面`

是冲突的。

## 为什么这轮不重写整个 session operations 专题

### 判断二：当前缺的不是更多解释，而是标题层对象重新对齐

会话运营专题本身已经讲清：

- `/copy` 是快速搬运结果
- `/export` 是正式外化
- `/branch` 是分叉
- `/rewind` 是受约束恢复
- `/clear` 是新空工作面

所以这轮不需要：

- 重排整页结构
- 新增分节
- 去动索引页或导航层

只需要：

- 把第三段标题从“纯时间线改写”改成“改写当前时间线，或切出新的工作面”
- 再补一句显式说明 `/clear` 不属于分叉 / 回退
- 再把 `00-阅读路径` 的“路径 8”标题收窄成“先找回以前的工作，再分清恢复与当前时间线运营的边界”

就够了。

## 为什么这轮不顺手改 continuity 主线之外的其它 session operations 入口

### 判断三：这是一条 `/clear` 的边界纠偏，不是 session operations 全面重构

前一轮已经收过：

- continuity 主线不要吞 `/rename`、`/export`

这一轮继续收的是：

- session operations 里 `/clear` 不该被压回时间线改写

如果再顺手去动：

- `/copy`
- `/export`
- `/branch`
- `/rewind`

其它段落，

就会把这次单一边界纠偏重新扩成大修。

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git pull --ff-only origin main`

结果是：

- `pull` 成功：`Already up to date.`

因此本轮继续深入仍只在：

- `.worktrees/userbook`

推进。

## 苏格拉底式自审

### 问：我是不是把“改写当前时间线”和“切换到新的空工作面”误当成了同一种动作？

答：如果 `/clear` 继续被留在“改写时间线”标题下，这个误判就还在。

### 问：我是不是因为 `/branch`、`/rewind`、`/clear` 都紧邻出现，就偷懒把它们压成同一类？

答：相邻不等于同类；`/clear` 改的是会话容器 / frontstage，不是同一条时间线。

### 问：我是不是又想因为这刀很小，就顺手扩成整个 session operations 的重排？

答：当前更缺的是局部边界纠偏，不是整页翻修。
