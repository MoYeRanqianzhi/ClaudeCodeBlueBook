# task output naming split 拆分记忆

## 本轮继续深入的核心判断

这轮继续深入里，

最值得先修的不是再补一页后台任务专题，

而是把：

- `/tasks`
- `TaskOutput`
- `TaskOutputTool`
- `output_file`
- `TaskStop`

这些已经在正文不同层出现的名字重新分层。

## 为什么这轮落点选 `03-参考索引/06`

### 判断一：索引页里同一对象被多重命名，会先在入口层制造错位

`03-参考索引/06-高价值入口运行时合同速查.md`

里原本同时存在：

- `## /tasks、TaskOutputTool 与 output file`
- `## /tasks、TaskOutput、TaskStop`

这两段。

问题不在于名字多少，

而在于：

- 前一段把公开工具名、实现名和结果载体放在同一层
- 后一段又把结果读取和停止语义再次并列

读者很容易先吸收成：

- `TaskOutputTool ~= TaskOutput ~= output_file`
- `/tasks` 一打开就同时等于结果读取和停止控制

这会让专题页里已经写清的层次，

回到索引页时再次被压平。

## 为什么这轮不直接改成更大的任务专题重排

### 判断二：当前缺的不是更多解释，而是索引层主语重建

仓内其他正文其实已经给出较稳定的层次：

- `output_file` 是正式结果载体
- `TaskOutputTool` 是实现名 / 兼容层
- `TaskOutput` 是用户更常见的公开工具名
- `TaskStop` 是停止语义，不是结果读取语义

所以这轮不需要：

- 新增专题
- 扩长正文
- 合并更多章节

只需要：

- 前一段明确是“结果读取面”
- 后一段明确是“可见与停止面”

就足够把对象重新立住。

## 这轮具体怎么拆

### 判断三：公开名优先，兼容层降级到解释位

前一段改成：

- `## TaskOutput、output_file 与 <task-notification>`

并把正文改成：

- `TaskOutput` 仍可用
- 其实现仍在 `TaskOutputTool`
- 但更推荐直接读 `output_file`

这样保住了：

- 用户表层看到的工具名
- 源码实现名
- 结果主载体与回流信号

三层关系。

### 判断四：后一段不该再次重写结果读取合同

后一段改成：

- `## /tasks 与 TaskStop`

并明确：

- 结果读取合同以前一节为准
- 这里主要补 `/tasks` 的可见面和 `TaskStop` 的停止语义

这样读者不会再把：

- 可见面
- 结果读取面
- 停止面

压成一张表。

## 为什么这轮不选另外两个候选

### 候选一：根层 `02-能力地图` 降为 second-hop

这个候选成立，

但它处理的是：

- 根层 front-door 层级

而这轮更直接的使用功能剖析缺口，

是：

- 后台任务结果怎样取
- 兼容层工具与正式结果载体怎样区分

所以先修 `/tasks` 命名面。

### 候选二：`/review` 与 `ultrareview` 的主次标题

这个候选也成立，

但它更偏标题澄清。

相比之下，

`/tasks` 这轮能同时解决：

- 入口合同
- 使用心智模型
- 对象分层

收益更高。

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git pull --ff-only origin main`
- `git rev-parse HEAD origin/main`

结果是：

- `pull` 成功：`Already up to date.`
- `HEAD = 14c35307967740992aecb66f821b74a5d86efa7e`
- `origin/main = 14c35307967740992aecb66f821b74a5d86efa7e`

因此本轮继续深入仍只在：

- `.worktrees/userbook`

推进。

## 苏格拉底式自审

### 问：我是不是把公开工具名、实现类名和结果载体当成了同一种“入口名字”？

答：如果索引页同时把 `TaskOutputTool`、`TaskOutput`、`output_file` 并列写成同层对象，那就是在混主语。

### 问：我是不是又想通过增加更多正文，回避索引层本身的命名混乱？

答：当前更缺的是把索引层主语修干净，而不是继续加解释。

### 问：我是不是把 `/tasks` 当成万能任务面板，忘了它和结果读取、停止语义本来就不是同一动作？

答：如果不把后一段收窄成“可见与停止面”，这个误判就还会留在速查层。
