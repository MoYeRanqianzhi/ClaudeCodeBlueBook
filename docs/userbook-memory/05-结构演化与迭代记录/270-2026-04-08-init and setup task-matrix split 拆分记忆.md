# init and setup task-matrix split 拆分记忆

## 本轮继续深入的核心判断

在完成：

- 顶层 README 的开工环境入口
- `00-阅读路径` 的路径 88
- `04-专题深潜/14`
- `04-专题深潜/README` 的 init/setup topic route

之后，

这条线当前缺的不是：

- 再补正文
- 先下潜合同速查

而是：

- 把 init/setup 压进任务视角的一跳矩阵

## 为什么这轮落点选 `03-参考索引/05`

### 判断一：`03-参考索引/05` 才回答“我现在该先走哪个入口”

这条线当前已经具备：

- 顶层目标入口
- 阅读路径
- 专题层 first-hop
- 专题正文

但矩阵层还没有直接回答：

- 我要初始化仓库
- 我要安装或切版本
- 我要把终端输入调顺
- 我要做宿主诊断
- 我要准备长期 token
- 我要接 GitHub / Slack 外部入口

这些任务分别先走哪个入口。

所以这轮该补的是：

- task-to-entry matrix

不是：

- 合同速查

## 为什么这轮至少要拆成 repo / host / platform 三组

### 判断二：开工准备线上最容易被写平的，就是三种准备对象

`14`

正文已经明确：

- 仓库对象：`/init`
- 宿主对象：`claude install`、`/terminal-setup`、`/doctor`、`setup-token`
- 外部平台对象：`/install-github-app`、`/install-slack-app`

如果矩阵层只写一行：

- “搭好开工环境”

就会把：

- repo setup
- host setup
- platform setup

重新压平。

所以这轮必须把这些对象至少拆成多行，并在用户层结论里保留三分主语。

## 为什么 `claude install` 与 `/terminal-setup` 不能写成同一行

### 判断三：一个改安装态，一个改输入摩擦

虽然它们都属于宿主对象，

但：

- `claude install [target]`

回答的是：

- 本机 Claude Code 安装 / 版本切换

而：

- `/terminal-setup`

回答的是：

- 多行输入与终端键位环境

如果把两者写成同一行，

读者会继续把：

- 安装形态

和：

- 终端输入治理

误写成同一种 setup。

## 为什么 `/doctor` 要单列

### 判断四：宿主健康检查不是安装，也不是仓库初始化

`/doctor`

会聚合：

- PATH / alias
- settings
- sandbox
- MCP
- keybindings
- context 体积

它的主语是：

- 宿主健康检查

而不是：

- 安装入口
- 仓库入口

所以这轮必须把 `/doctor` 单列。

## 为什么 `setup-token` 与 GitHub/Slack 接入也不能混成同一种外部入口

### 判断五：一个是长期 token setup，一个是平台接入

`setup-token`

是：

- CLI root command
- 长生命周期 token setup

而：

- `/install-github-app`
- `/install-slack-app`

回答的是：

- 外部平台入口接入

如果把它们压成同一种“外部集成”，

读者会再次混淆：

- 身份准备

与：

- 工作流平台接入

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git rev-parse HEAD origin/main`

返回：

- `HEAD = 9a6085ae3a95218282b701899647ca0e1a11a705`
- `origin/main = 9cb9fb702f5ea1590a16b15638d4c875284dabc2`

主仓库未作为本轮编辑面，继续只在：

- `.worktrees/userbook`

推进 init/setup task-matrix 切片。

## 苏格拉底式自审

### 问：我现在缺的是再解释 `14` 的正文，还是缺把用户任务写回“先按哪个入口”的矩阵层？

答：如果顶层、路径、专题和 first-hop 都已存在，当前更缺的是矩阵层。

### 问：我是不是又想把 repo setup、host setup 和 platform setup 压成同一种“开工准备”？

答：如果矩阵不显式保护三组对象，这个误判会立刻复发。

### 问：我是不是又想把 `claude install`、`/terminal-setup`、`/doctor` 写成一类宿主按钮？

答：如果不单列安装、输入治理和健康检查，这条线会再次被写平。
