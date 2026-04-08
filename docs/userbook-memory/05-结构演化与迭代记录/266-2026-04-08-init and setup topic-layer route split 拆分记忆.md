# init and setup topic-layer route split 拆分记忆

## 本轮继续深入的核心判断

在完成：

- 顶层 README 的开工环境入口
- `00-阅读路径` 的路径 88
- `04-专题深潜/14`

之后，

这条线当前最小却仍缺的一刀是：

- `04-专题深潜/README`
  里的 topic-layer route

## 为什么这轮该补专题层 route

### 判断一：顶层和路径层已经存在，但专题层还没把开工准备抬成 first-hop

当前用户已经可以在：

- 顶层 README
- 路径 88

看到这条线，

但进入 `04-专题深潜`

之后，

它还只是平铺列表里的：

- `14-初始化、安装与开工环境搭建专题`

没有像：

- context intake
- noninteractive automation
- delivery
- terminal efficiency

那样被抬成 first-hop。

所以这轮缺的是：

- topic-layer discoverability

不是：

- 再写正文

## 为什么 route 文案必须先保护“仓库 / 宿主 / 外部平台”三分

### 判断二：开工准备线上最容易被写平的，不是命令名，而是准备对象

`14`

正文已经明确拆成：

- 仓库对象：`/init`
- 宿主对象：`claude install`、`/terminal-setup`
- 外部平台对象：`/install-github-app`、`/install-slack-app`、`setup-token`

如果专题层 route 只说：

- “去看初始化与安装专题”

读者仍然会继续把：

- 仓库初始化
- 本机安装与终端治理
- GitHub / Slack 接入

写成同一种 setup。

所以这轮 route 的第一句必须先把问题压成：

- 我是在准备仓库、准备宿主，还是准备外部入口

## 为什么这轮先给路径 88，再给专题 14

### 判断三：专题层 first-hop 回答“先去哪”，路径层仍然负责“按什么顺序继续”

`14`

正文已经能回答对象边界，

但如果读者此时还没分清：

- 先把 repo setup 搭好
- 再调顺终端输入
- 再处理开工前诊断和外部平台入口

直接只送专题 14，

仍会跳过路径 88 已经给出的顺序价值。

所以这轮更稳的顺序应当是：

- 先给路径 88
- 再给专题 14
- 再把 root-command / panel 边界分流到 `19`

## 为什么这轮顺手接 `19-会外控制台与会内面板专题`

### 判断四：开工准备真正继续深入时，最容易误判的就是“会外 root command”和“会内面板”不分层

`14`

正文已经明确提醒：

- `setup-token`
- `claude install`

属于会外 root command，

而：

- `/doctor`
- `/status`
- `/init`
- `/terminal-setup`

处在会内面板或 slash 层。

所以这轮 route 不能只停在 `14`，

还应显式把：

- `19-会外控制台与会内面板专题`

接出来。

## 为什么这轮不先补矩阵或合同速查

### 判断五：对已经进入专题层的读者来说，当前更直接的物理断点仍然是 first-hop 缺失

路径 88 和正文 14 都已经存在，

但在专题总览层还没有一个第一跳告诉读者：

- 这条线已经成形
- 它和其他高频工作一样值得单独 first-hop

所以这轮先补：

- `04-专题深潜/README`

不是：

- `03-参考索引/05`
- `03-参考索引/06`

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git rev-parse HEAD origin/main`
- `git pull --ff-only origin main`

返回：

- `HEAD = 9cb9fb702f5ea1590a16b15638d4c875284dabc2`
- `origin/main = 9cb9fb702f5ea1590a16b15638d4c875284dabc2`
- `git pull --ff-only origin main` 因主仓库 unresolved conflict 失败

同时只读确认：

- 主仓库当前分支仍为 `main`
- `HEAD` 与 `origin/main` 相等
- 未解决冲突文件位于主仓库，不在 `.worktrees/userbook`

因此本轮继续只在：

- `.worktrees/userbook`

推进 init/setup 的 topic-route 切片，不去碰主仓库冲突。

## 苏格拉底式自审

### 问：我现在缺的是再解释 `14` 的正文，还是缺把这条高频开工线在专题层抬出来？

答：如果顶层、路径和专题正文都已存在，先缺的是 topic-layer route。

### 问：我是不是又想把仓库初始化、本机安装和外部平台接入压成同一种 setup？

答：如果 route 不先保护三种准备对象，这个误判会立刻复发。

### 问：我是不是应该先去补矩阵或合同速查，而不是先修专题层更近的断点？

答：对已经进入专题层的读者来说，first-hop 缺口更近，所以应先补 route。
