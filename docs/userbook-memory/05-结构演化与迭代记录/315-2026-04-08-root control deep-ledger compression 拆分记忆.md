# root control deep-ledger compression 拆分记忆

## 本轮继续深入的核心判断

这一轮最值得收的，

不是继续给根 `README` 加更多控制面直链，

而是把它已经越过一级摘要职责的 `05-控制面深挖` deep ledger 压回 section-hub handoff。

## 为什么这轮值得单独提交

### 判断一：根前门不该继续替 `05-控制面深挖/README.md` 列叶子账本

当前根 `README` 的 `05-控制面深挖` 段前半部分仍是合理的一级摘要：

- 权限
- 扩展边界
- 连续性
- 并行执行
- 入口决策
- 运行时自检

但后半段已经一路下钻到：

- headless
- host / viewer
- bridge
- direct-connect
- remote session
- permission tail
- model authority

这些 leaf-level ledger。

与此同时：

- `05-控制面深挖/README.md`

已经有：

- `优先控制面`
- `完整控制面目录`

所以根页继续保留这长串深页账本，

是在和 section hub 抢职责。

## 这轮具体怎么拆

### 判断二：只收 `05` 后半段，保留前半段一级摘要

这轮只做一件事：

- 把根 `README` 中 `05-控制面深挖` 里从 headless / bridge / direct-connect / permission tail / model authority 开始的长串叶子账本整体压缩成一句 handoff

保留：

- 前半段控制面总类目

删除：

- 继续在根页直列几十个深页问题

改成：

- 明确这些更细分叉统一去 `05-控制面深挖/README.md`
- 先看 `优先控制面`
- 再看 `完整控制面目录`

## 为什么这轮不顺手压 `04-专题深潜`

### 判断三：`04` 也有 section-hub 回漂，但当前最重的是 `05`

根页对 `04` 的过深直链仍有残留，

但深度和密度都明显低于 `05`。

如果只做一个提交，

先收：

- `05` 的后半段 deep ledger

更稳。

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

### 问：我是不是把根页收得太狠，让读者失去入口？

答：没有。更细入口仍在 `05-控制面深挖/README.md`，只是根页不再自己承担 leaf ledger。

### 问：我是不是应该把整段 `05` 全删掉？

答：不应该。前半段的一级控制面摘要仍然有价值，当前该收的是后半段越权的深页直链。

### 问：我是不是该把 `04` 也一起收掉？

答：不该。那会把两个不同规模的问题混成一刀。
