# extension operations contract-table split 拆分记忆

## 本轮继续深入的核心判断

在完成：

- 顶层 README 的扩展运维入口
- `00-阅读路径` 的路径 91
- `04-专题深潜/17`
- `04-专题深潜/README` 的 extension topic route
- `03-参考索引/05` 的扩展运维矩阵
- `05-控制面深挖/02` 的扩展层选择页

之后，

这条线当前缺的不是：

- 再补正文
- 再补任务矩阵

而是：

- 把 extension operations 压成显式合同块

## 为什么这轮落点选 `03-参考索引/06`

### 判断一：前门、路径、专题、矩阵和控制面页都已具备，最后缺的是“高价值入口运行时合同速查”

这条线当前已经具备：

- 顶层目标入口
- 阅读路径
- 专题层 first-hop
- 任务矩阵
- 控制面页

但在 `03-参考索引/06`

里，

还没有一组把：

- `/plugin`
- `/mcp`
- `/skills`
- `/hooks`
- `/agents`
- `/reload-plugins`

显式收成同主题合同块。

所以这轮最小且最高价值的一刀就是：

- extension operations contract-table

## 为什么这轮必须把“包管理 / 能力暴露 / 服务器管理 / 当前会话刷新”四层分开

### 判断二：扩展线最容易被写平的，不是命令名，而是主语

`17`

正文已经明确：

- `/plugin` 管插件包
- `/mcp` 管外部 servers
- `/skills` `/hooks` `/agents` 看当前会话暴露结果
- `/reload-plugins` 管当前 session 刷新

如果合同层不把这四层显式拆开，

读者就会继续把：

- 装了 plugin
- 看到 skill
- 刷新当前会话
- 重连 server

写成同一种“扩展管理”。

所以这轮合同块必须保护：

- 包管理
- 能力暴露
- server 管理
- session refresh

四种主语。

## 为什么这轮要把 `/reload-plugins` 单独拉出来

### 判断三：它不是安装器，而是当前 session refresh

这条线在正文里已经明确：

- `/reload-plugins` 只刷新当前 session
- `supportsNonInteractive: false`
- 还可能在 remote mode 下先重拉 settings

如果合同层不单列，

读者会继续把：

- 插件安装完成

误写成：

- 当前会话已经吃到变更

所以这轮必须把 `/reload-plugins`

作为独立合同对象收进来。

## 为什么这轮要在 `/skills`、`/hooks`、`/agents` 里强调 permission context

### 判断四：当前会话能看到什么，和磁盘上存了什么，不是同一张表

这三个入口真正回答的是：

- 当前 permission context 下可见、可管理的扩展暴露面

而不是：

- 全局理论目录

如果不把：

- permission context

和：

- 当前工具池

写进合同层，

读者会继续把：

- “仓里有”

误写成：

- “当前会话就能看见 / 管理”

## 为什么这轮不把 `/install-github-app`、`/install-slack-app` 混进这组

### 判断五：它们属于外部平台接入，不属于日常扩展运维主线

即使它们与插件 / GitHub workflow 靠得很近，

它们回答的主语仍然是：

- 外部平台接入

而不是：

- 当前会话怎样稳地管理 plugin/MCP/skills/hooks/agents

所以这轮合同块必须只收：

- 日常扩展运维主线

不把：

- `/install-github-app`
- `/install-slack-app`

重新混回这组。

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git rev-parse HEAD origin/main`

返回：

- `HEAD = f423b0e2f25d26c87905bc5317b1ee0b90bd0769`
- `origin/main = 9cb9fb702f5ea1590a16b15638d4c875284dabc2`

主仓库随后执行：

- `git pull --ff-only origin main`

返回：

- `Already up to date.`

因此本轮 extension contract-table 切片开始前，继续只在：

- `.worktrees/userbook`

推进，不对主仓库已有状态做额外修改。

## 苏格拉底式自审

### 问：我现在缺的是再解释 `17` 正文，还是缺把这条线压成速查层显式合同块？

答：如果前门、路径、专题、矩阵和控制面页都已存在，当前更缺的是合同速查。

### 问：我是不是又想把 `/plugin`、`/skills`、`/mcp`、`/reload-plugins` 全写成同一种扩展管理动作？

答：如果不把四层主语拆开，这个误判会立刻复发。

### 问：我是不是又要把外部平台接入混进扩展日常运维主线？

答：如果把 `/install-github-app`、`/install-slack-app` 混进这组六个入口，这条线又会被写平。
