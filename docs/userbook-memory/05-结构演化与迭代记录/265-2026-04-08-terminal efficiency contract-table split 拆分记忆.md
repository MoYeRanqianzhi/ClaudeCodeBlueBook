# terminal efficiency contract-table split 拆分记忆

## 本轮继续深入的核心判断

在完成：

- 顶层 README 的 terminal efficiency 入口
- 路径 7
- `04-专题深潜/11`
- `04-专题深潜/README` 的 terminal topic route
- `03-参考索引/05` 的 terminal task-matrix

之后，

这条线当前缺的不是：

- 再补正文
- 再扩矩阵

而是：

- 把 terminal efficiency 压成显式合同块

## 为什么这轮落点选 `03-参考索引/06`

### 判断一：前门、路径、专题和矩阵都已具备，最后缺的是“高价值入口运行时合同速查”

这条线当前已经具备：

- 顶层目标入口
- 阅读路径
- 专题层 first-hop
- 任务矩阵

但在 `03-参考索引/06`

里，

原来只有：

- `/voice`

作为输入相关合同块，

而：

- `/theme`
- `/color`
- `/vim`
- `/keybindings`
- `/statusline`
- prompt 历史检索

还没有形成同主题的显式压缩块。

所以这轮最小且最高价值的一刀就是：

- terminal efficiency contract-table

## 为什么这轮要把 `/statusline` 单独抬出来

### 判断二：`/statusline` 不是“查询状态”，而是“配置持续观测”

`11`

正文已经明确：

- `/statusline` 会调用 `statusline-setup` 子代理
- 读取 shell 现状
- 写入 `~/.claude/settings.json`

这说明它不是：

- `/status`

那种运行时自检或状态查询，

而是：

- 持续观测层配置工作流

所以这轮必须把它单列为一段合同，而不是塞回外观层或 `/status` 那组。

## 为什么这轮要把外观层和输入层收在同一合同块

### 判断三：`/theme`、`/color`、`/vim`、`/keybindings` 都属于稳定终端交互面，但它们共同回答的是“本地摩擦怎样降低”

这些入口的差异很重要，

但它们在合同层里仍共享一个更高阶主语：

- 本地终端交互面

所以这轮不需要把它们拆成四个小节，

而是可以收在：

- `/theme`、`/color`、`/vim`、`/keybindings`

这一组里，

同时明确：

- 外观层
- 输入模式与键位层

不是模型工作流。

## 为什么这轮要把 prompt 历史检索单列

### 判断四：不把它单列，读者就会继续用 `/resume` 或 shell history 代替它

prompt 历史检索回答的是：

- 以前怎么提过这个问题

而不是：

- 以前在哪个会话里做过这项工作

如果合同层不显式写出这点，

读者会继续把：

- shell history
- `/resume`

写成等价物。

所以这轮必须单列：

- prompt 历史检索

并明确：

- 输入历史不是会话连续性

## 为什么这轮要显式排除 `/voice`

### 判断五：语音输入是灰度/条件通道，不应被写成稳定终端效率主线

`/voice`

已经在 `06`

里有自己的合同块，

而且它依赖：

- auth
- kill-switch
- 音频环境
- 麦克风权限

这和稳定终端效率主线不是同一个对象。

所以这轮合同块必须显式提醒：

- 不要把 `/voice` 混回稳定终端效率主线

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git rev-parse HEAD origin/main`
- `git pull --ff-only origin main`

返回：

- `HEAD = 9cb9fb702f5ea1590a16b15638d4c875284dabc2`
- `origin/main = 9cb9fb702f5ea1590a16b15638d4c875284dabc2`
- `Already up to date.`

因此本轮 terminal efficiency contract-table 切片开始前，主仓库处于同步状态。

## 苏格拉底式自审

### 问：我现在缺的是再写一遍 `11` 的正文，还是缺把这条线压成速查层显式合同块？

答：如果前门、路径、专题和矩阵都已存在，当前更缺的是合同速查。

### 问：我是不是又想把 `/statusline` 写成 `/status` 的同类命令？

答：如果不把它单列成持续观测配置工作流，这个误判会继续存在。

### 问：我是不是又要把 `/voice` 混进稳定终端效率主线？

答：如果不显式排除灰度语音输入，这个混层会再次出现。
