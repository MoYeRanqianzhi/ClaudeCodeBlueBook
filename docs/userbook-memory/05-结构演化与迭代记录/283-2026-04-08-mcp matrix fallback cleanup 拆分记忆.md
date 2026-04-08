# mcp matrix fallback cleanup 拆分记忆

## 本轮继续深入的核心判断

在已经完成：

- skills vs plugin matrix fallback cleanup
- object triage mini-tables

之后，

矩阵层剩余最明显的扩展对象错位，

已经收缩到：

- `MCP | plugin + hooks`
- `/mcp | plugin 携带的 MCP`

这两条。

## 为什么这轮仍落点选 `03-参考索引/05`

### 判断一：如果矩阵主表还在把不同扩展层压成 fallback，下面的分诊说明就会继续被主表抵消

前面已经补了：

- 扩展对象分诊 mini-tables
- `skills -> plugin` 的伪 fallback 清理

但主表仍然在暗示：

- MCP 可以退化成 plugin + hooks
- `/mcp` 可以退化成 plugin 携带的 MCP

这会继续把：

- 外部系统接入
- 外部 server 管理
- 包装来源
- 事件插针

压成同一种扩展动作。

所以这轮最小且必要的一刀仍然是：

- 修矩阵主表

## 为什么 `plugin + hooks` 不能当 `MCP` 的次选入口

### 判断二：外部系统边界不是包装层或事件层的同义词

`MCP`

回答的是：

- 把 Claude Code 接到外部工具宇宙

而：

- `plugin`

回答的是：

- 一组能力的打包、分发与管理

`hooks`

回答的是：

- 在事件点插入校验、审计或编排

如果继续把：

- `plugin + hooks`

写成 `MCP` 的次选入口，

读者会继续把：

- 外部系统接入

误写成：

- 包管理或事件插针的组合替代

## 为什么 `plugin 携带的 MCP` 也不能当 `/mcp` 的次选入口

### 判断三：来源说明不是管理动作

`/mcp`

回答的是：

- server 启停
- 重连
- 状态管理

而：

- plugin 携带的 MCP

回答的是：

- 这些 server 从哪一层被带进来

这不是同一种管理对象。

如果继续保留这条次选入口，

读者会继续把：

- server management

和：

- server provenance

压成同一步。

## 为什么这轮只改两行

### 判断四：当前缺的不是再加扩展说明，而是让矩阵主信号不再和分诊表冲突

这轮不需要：

- 再补专题正文
- 再扩分诊表

只需要：

- 把剩余两条最显眼的伪 fallback 去掉

让矩阵主表和下方的对象分诊保持一致。

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git pull --ff-only origin main`
- `git rev-parse HEAD origin/main`

返回：

- `pull = Already up to date.`
- `HEAD = 9a6085ae3a95218282b701899647ca0e1a11a705`
- `origin/main = 9a6085ae3a95218282b701899647ca0e1a11a705`

因此本轮 MCP matrix fallback cleanup 切片开始前，主仓库在 fast-forward 视角与 `origin/main` 同步；本轮仍继续只在：

- `.worktrees/userbook`

推进文档切片。

## 苏格拉底式自审

### 问：我现在缺的是再加扩展层解释，还是先把矩阵里最后几条错误 fallback 拿掉？

答：如果解释已经足够，当前更缺的是让主表不再发出错误信号。

### 问：我是不是还在把外部系统接入、包管理和事件插针压成同一类扩展动作？

答：如果继续保留 `MCP -> plugin + hooks`，这个误判就还留在主表里。

### 问：我是不是把来源说明误当成管理动作？

答：如果继续保留 `/mcp -> plugin 携带的 MCP`，server provenance 和 server management 就还在被混写。
