# init and setup contract-table split 拆分记忆

## 本轮继续深入的核心判断

在完成：

- 顶层 README 的开工环境入口
- `00-阅读路径` 的路径 88
- `04-专题深潜/14`
- `04-专题深潜/README` 的 init/setup topic route
- `03-参考索引/05` 的 init/setup task-matrix

之后，

这条线当前缺的不是：

- 再扩正文
- 再补矩阵

而是：

- 把 init/setup 压进显式合同速查层

## 为什么这轮落点选 `03-参考索引/06`

### 判断一：前门、路径、专题和矩阵都已具备，最后缺的是运行时合同压缩

这条线已经具备：

- 顶层目标入口
- 阅读路径
- 专题层 first-hop
- 专题正文
- 任务到入口矩阵

但在 `03-参考索引/06`

里，

除了已经存在的：

- `/doctor`

之外，

还没有一组把：

- `/init`
- `/terminal-setup`
- `claude install [target]`
- `setup-token`
- `/install-github-app`
- `/install-slack-app`
- `/init-verifiers`

显式压成同主题合同块。

所以这轮最小且最高价值的一刀就是：

- init/setup contract-table

## 为什么这轮不能把 repo setup、host setup 和 platform setup 写平

### 判断二：开工准备最容易复发的误判，是三种对象再次被压成同一种 setup

`14`

正文已经明确：

- `/init` 是 repo setup
- `/terminal-setup`、`claude install [target]` 是 host setup
- `/install-github-app`、`/install-slack-app`、`setup-token` 是外部入口或长期凭据准备

如果合同层不把三组对象显式分开，

读者就会继续把：

- 仓库初始化
- 宿主安装与输入治理
- 平台接入与凭据准备

写成同一种“开工按钮”。

## 为什么这轮要把 `setup-token` 和 `/login` 明确切开

### 判断三：长期 token provisioning 不是当前会话身份现场重建

`setup-token`

回答的是：

- 长生命周期 Claude token provisioning

而：

- `/login`

回答的是：

- 把 Anthropic 身份正式带进当前会话

如果合同层不把这条边界写死，

读者会继续把：

- 长期凭据准备

和：

- 当前会话登录

误写成同一种身份动作。

## 为什么这轮要把 `/install-github-app` 和 GitHub 登录切开

### 判断四：仓库工作流接入不是账号 OAuth 本身

`/install-github-app`

会检查：

- `gh`
- auth
- scopes
- repo 识别
- admin 权限

所以它真正回答的是：

- 仓库能不能接进 Claude GitHub 工作流

而不是：

- 用户有没有给 Claude 一个 GitHub 账号

如果合同层不把这点写明，

读者会继续把：

- GitHub 工作流接入

误写成：

- GitHub 登录

## 为什么这轮要把 `/init-verifiers` 单独标成 internal-only

### 判断五：内部辅助能力最容易反向污染公开主线

源码里确实存在：

- `/init-verifiers`

但它属于：

- `INTERNAL_ONLY_COMMANDS`

如果合同层不显式把它标成 internal-only，

读者会继续把：

- 内部 verifier 支撑能力

误写回：

- `/init` 的公开主线

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git pull --ff-only origin main`
- `git rev-parse HEAD origin/main`

返回：

- `pull = Already up to date.`
- `HEAD = 9a6085ae3a95218282b701899647ca0e1a11a705`
- `origin/main = 9a6085ae3a95218282b701899647ca0e1a11a705`

因此本轮 init/setup contract-table 切片开始前，主仓库在 fast-forward 视角与 `origin/main` 同步；本轮仍继续只在：

- `.worktrees/userbook`

推进文档切片。

## 苏格拉底式自审

### 问：我现在缺的是再解释 `14` 的正文，还是缺把开工准备压成合同速查层？

答：如果前门、路径、专题和矩阵都已存在，当前更缺的是合同速查。

### 问：我是不是又想把 `/init`、`claude install`、`/install-github-app` 写成同一种 setup？

答：如果不把 repo、host 和 platform 三组对象拆开，这个误判会立刻复发。

### 问：我是不是又想把 `setup-token` 当成 `/login` 的长期版？

答：如果不把长期凭据 provisioning 和当前会话身份现场分开，这条线会再次被写平。
