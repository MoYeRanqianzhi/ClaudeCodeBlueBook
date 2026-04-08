# hooks matrix fallback cleanup 拆分记忆

## 本轮继续深入的核心判断

在已经完成：

- skills vs plugin matrix fallback cleanup
- mcp matrix fallback cleanup

之后，

矩阵层扩展线里最后一条仍然明显把不同对象写成 fallback 的，

已经收缩到：

- `hooks | 外部 wrapper`

这行本身。

## 为什么这轮仍落点选 `03-参考索引/05`

### 判断一：如果主表还在暗示 `wrapper ~= hooks`，下方分诊与专题正文就会继续被主表抵消

前面已经修掉：

- `skills -> plugin`
- `MCP -> plugin + hooks`
- `/mcp -> plugin 携带的 MCP`

现在剩下的同类问题就是：

- `hooks -> 外部 wrapper`

如果这条还留着，

读者会继续先在矩阵层吸收：

- 包一层外部 wrapper 约等于 hook event object

这会和专题正文里对 hooks 的定义直接冲突。

## 为什么 `外部 wrapper` 不能当 `hooks` 的次选入口

### 判断二：进程或调用外壳不是事件插针对象

`hooks`

回答的是：

- 在关键事件点前后插入校验、审计、补上下文或治理逻辑

而：

- 外部 wrapper

回答的是：

- 从进程外层包裹 Claude Code 调用

这不是同一种对象。

如果继续把：

- 外部 wrapper

写成 `hooks` 的次选入口，

读者会继续把：

- 事件插针层

和：

- 进程外壳层

压成同一步。

## 为什么这轮只改这一行

### 判断三：当前缺的不是更多扩展层解释，而是把矩阵主表的最后一条明显伪 fallback 清干净

这轮不需要：

- 再扩专题正文
- 再补对象分诊表

只需要：

- 把 `hooks -> 外部 wrapper` 改成 `无`

让矩阵主表和既有正文定义保持一致。

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git pull --ff-only origin main`
- `git rev-parse HEAD origin/main`
- `git status --short --branch`

结果是：

- `pull` 失败：`Pulling is not possible because you have unmerged files.`
- `HEAD = b20ac70698203d178a1493275454277b9d4d90c0`
- `origin/main = 9a6085ae3a95218282b701899647ca0e1a11a705`
- 主仓库 `main...origin/main [ahead 25]`
- 且存在未解决冲突，例如：
  - `UU bluebook/security/README.md`
  - `UU bluebook/security/source-notes/README.md`
  - `UU docs/development/research-log.md`

因此本轮 hooks matrix fallback cleanup 仍继续只在：

- `.worktrees/userbook`

推进，不触碰主仓库状态。

## 苏格拉底式自审

### 问：我现在缺的是再加解释，还是把矩阵主表里最后一条明显伪 fallback 拿掉？

答：如果正文定义已经够清楚，当前更缺的是让主表不再发错信号。

### 问：我是不是还在把事件插针和进程外壳当成同一种扩展动作？

答：如果继续保留 `hooks -> 外部 wrapper`，这个误判就还留在矩阵层。

### 问：我是不是又想因为这条更边缘，就放任主表保留一个已知的对象错位？

答：既然前三条同类错位已经收掉，这条最后的同类伪 fallback 也应一并清干净。
