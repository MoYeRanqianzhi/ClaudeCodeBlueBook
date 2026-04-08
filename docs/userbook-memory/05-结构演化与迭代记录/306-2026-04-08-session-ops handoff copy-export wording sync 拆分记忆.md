# session-ops handoff copy-export wording sync 拆分记忆

## 本轮继续深入的核心判断

这一轮最值得收的，

不是再扩 session operations 内容，

而是把多层 handoff 文案里仍残留的：

- “命名、外化、分叉、回退和清空”

统一改回已经成形的：

- “复制、命名、导出、分叉、回退和清空”

## 为什么这轮值得单独提交

### 判断一：高层总图已经补回 `/copy`，但 handoff 句还在重复旧模型

前几轮已经明确：

- `/copy`、`/rename`、`/export`、`/branch`、`/rewind`、`/clear`

同属：

- 当前工作对象运营层

而且：

- `04-专题深潜/07-会话运营、分叉与回退专题.md`

正文已经写成：

- 工作对象需要被命名、复制、导出、分叉、回退和清空

但主线页、专题 README、控制面 continuity 页、合同速查页的 handoff 句仍在说：

- 命名、外化、分叉、回退和清空

这会把：

- `/copy`

再次挤出 handoff 口径，

也会把：

- `export`

重新抽象成模糊的“外化”，冲淡 `/copy` 与 `/export` 的对象差异。

## 这轮具体怎么拆

### 判断二：只同步 handoff 句，不重写各页正文结构

这轮只改多层转读句与边界句：

1. 把：
   - `命名、外化、分叉、回退和清空`
   改成：
   - `复制、命名、导出、分叉、回退和清空`
2. 把 continuity 邻接层的命令列从：
   - `/rename`、`/export`、`/branch`、`/rewind`、`/clear`
   补齐为：
   - `/copy`、`/rename`、`/export`、`/branch`、`/rewind`、`/clear`
3. 顺手把“当前时间线怎样...”收紧为：
   - `当前工作对象怎样...`

这样：

- handoff 口径与正文主对象重新一致
- `/copy` 与 `/export` 的差异不会在高层再次被写平

## 为什么这轮不继续改 `第一跳分诊`

### 判断三：对象边界回声比残余元话语更优先

局部页面里仍有少量：

- `第一跳分诊`

但这类更偏前门元话语残留。

相比之下，这一轮属于：

- session-ops 对象边界在多层 handoff 中持续回声

优先级更高。

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

### 问：我是不是把 `/copy` 也误写成“正式外化”了？

答：没有。这轮恰恰是为了保住 `/copy` 与 `/export` 的差异，所以用“复制、命名、导出”而不是笼统“外化”。

### 问：我是不是在做纯同义词替换？

答：不是。这里改的是对象边界表达，漏掉 `/copy` 会让高层 handoff 重新讲窄。

### 问：我是不是该直接把所有会话运营页重写一遍？

答：不需要。当前问题集中在跨层 handoff 句，最小有效切片就是把这组句子同步回主模型。
