# command-index session-ops split 拆分记忆

## 本轮继续深入的核心判断

这轮最值得先收的，

不是继续改 session operations 专题正文，

而是把命令索引里仍被压回 continuity 的那一小层分组纠正掉。

## 为什么这轮落点选 `03-参考索引/01-命令工具/01-命令索引.md`

### 判断一：命令索引仍把 session operations 混进“上下文与连续性”

在：

- `03-参考索引/01-命令工具/01-命令索引.md`

里，

`/copy`、`/rename`、`/export`

还放在：

- `会话与导航`

而：

`/branch`、`/rewind`、`/clear`

又放在：

- `上下文与连续性`

这会让读者第一跳先吸收成：

- 一部分 session operations 是导航
- 另一部分 session operations 是 continuity

而前面几轮已经明确收过：

- continuity 主线
- session operations 主线

不该再混回两层。

## 为什么这轮不顺手去重排全部命令索引

### 判断二：当前缺的是 session operations 独立成组，不是整页分类体系重构

命令索引的其它大组目前仍可读：

- 会话与导航
- 上下文与连续性
- 运行时配置
- 工具链与扩展管理
- 代码工作流

这轮最明显的错位，

只集中在：

- session operations 六个入口没有独立成组

所以不需要：

- 重命名全部大组
- 重排整页顺序
- 去动 root command 索引

只要新增一个：

- `会话运营`

小节，

把这六个入口收进去即可。

## 这轮具体怎么拆

### 判断三：导航留 `/resume`、`/session`，continuity 留 `/memory` 系列，运营独立收六个入口

这轮把：

- `/copy`
- `/rename`
- `/export`
- `/branch`
- `/rewind`
- `/clear`

独立成：

- `会话运营`

而：

- 会话与导航

继续只保留：

- `/help`
- `/status`
- `/resume`
- `/session`
- `/tag`
- `/exit`

同时：

- 上下文与连续性

继续只保留：

- `/context`
- `/files`
- `/memory`
- `/compact`
- `/plan`
- `/tasks`

这样既不至于把索引拆得过碎，

又能把 session operations 从 continuity / navigation 混层里拉出来。

## 为什么这轮不顺手再改其它索引页

### 判断四：矩阵、合同页和专题层已经同步，这轮只补命令索引残留

前几刀已经分别收过：

- `/clear` 的专题边界
- 阅读路径边界
- 高价值合同页边界
- 任务矩阵的拆行

这轮剩下的残留，

就是命令索引这一页。

所以这轮只补它，

不再把已同步页面重新带入 commit。

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

### 问：我是不是把“命令都和会话有关”误当成了“它们都属于会话导航或 continuity”？

答：会话相关不等于导航或连续性；session operations 讲的是当前工作对象运营。

### 问：我是不是因为命令索引只是索引页，就放任它保留一个已知分组错位？

答：索引页恰恰是第一跳；如果这里不改，前面收好的专题主线会继续被冲掉。

### 问：我是不是又想把 `/plan`、`/tasks` 也拉去别的组，导致整页重排？

答：当前最小有效切片，是先把 session operations 六个入口独立出来，不做全页分类重构。
