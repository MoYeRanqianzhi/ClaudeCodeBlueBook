# terminal efficiency task-matrix split 拆分记忆

## 本轮继续深入的核心判断

在完成：

- 顶层 README 的 terminal efficiency 入口
- 路径 7
- `04-专题深潜/11`
- `04-专题深潜/README` 的 terminal topic route

之后，

这条线当前缺的不是：

- 再补正文
- 先下探合同速查

而是：

- 把 terminal efficiency 压进任务视角的一跳矩阵

## 为什么这轮落点选 `03-参考索引/05`

### 判断一：`03-参考索引/05` 回答的是“我现在该先走哪个入口”

这条线当前已经具备：

- 顶层目标入口
- 阅读路径
- 专题层 first-hop
- 专题正文

但矩阵层还没有直接回答：

- 我要调外观
- 我要切换输入模式或快捷键
- 我要把状态写进终端
- 我要找回刚才那条 prompt

这些任务分别先走什么入口。

所以这轮该补的是：

- task-to-entry matrix

不是：

- 合同速查

## 为什么这轮至少要拆成四行

### 判断二：终端效率主线本来就是四种不同摩擦对象

`11`

正文已经把这条线拆成：

- `/theme` / `/color`
- `/vim` / `/keybindings`
- `/statusline`
- prompt 历史检索

如果矩阵层只写一行：

- “让终端更顺手”

就会把：

- 外观层
- 输入模式/键位
- 持续观测层
- 输入历史检索

重新压平。

所以这轮必须拆成四行。

## 为什么这轮不把 `/voice` 混进这四行

### 判断三：`/voice` 属于灰度/条件输入面，不属于稳定 terminal efficiency 主线

矩阵里：

- `/voice`

已经单列为：

- 灰度 / 条件

terminal efficiency 这组行回答的是：

- 稳定终端交互摩擦怎样降低

它们不回答：

- 语音输入通道怎样接入

如果这轮把 `/voice`

混回这组，

读者会再次把：

- 稳定终端效率

和：

- 条件语音输入

写成同一种入口。

所以这轮必须让 `/voice` 继续保留为独立灰度行。

## 为什么 `/statusline` 要单列成条件行

### 判断四：它不是普通外观设置，而是依赖宿主与配置的持续观测工作流

`11`

正文已经明确：

- `/statusline`

会走受控 prompt 工作流，

并依赖：

- shell 现状
- 配置写入
- hooks / trust 等前提

所以这轮必须把它单列为：

- 条件，依赖 shell/config/hooks/trust

不能和：

- `/theme`
- `/color`
- `/vim`
- `/keybindings`

写成同一厚度的稳定本地设置。

## 为什么 prompt 历史检索也要有独立矩阵行

### 判断五：它回答的是“找回输入”，不是“恢复工作对象”

如果矩阵里没有这行，

读者就会继续拿：

- shell history
- `/resume`

去代替它。

但它真正回答的是：

- 最近 prompt 输入怎样被快速取回

所以这轮要显式写出：

- 找回最近的 prompt 输入

并把：

- shell history

列为退化路径。

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git rev-parse HEAD origin/main`
- `git pull --ff-only origin main`

返回：

- `HEAD = 9cb9fb702f5ea1590a16b15638d4c875284dabc2`
- `origin/main = 9cb9fb702f5ea1590a16b15638d4c875284dabc2`
- `Already up to date.`

因此本轮 terminal efficiency task-matrix 切片开始前，主仓库处于同步状态。

## 苏格拉底式自审

### 问：我现在缺的是再解释 `11` 的正文，还是缺把终端效率写回“先按哪个入口”的矩阵层？

答：如果顶层、路径、专题和 first-hop 都已存在，当前更缺的是矩阵层。

### 问：我是不是又想把 theme/color、Vim/键位、statusline 和历史检索压成同一种设置？

答：如果不拆成四行，这个对象误判会立刻复发。

### 问：我是不是又想把 `/voice` 混进稳定终端效率主线？

答：如果不把它继续留在独立灰度行，这个混层会再次出现。
