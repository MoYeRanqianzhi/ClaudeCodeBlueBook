# task matrix object-triage cleanup 拆分记忆

## 本轮继续深入的核心判断

在连续补完：

- account task-matrix
- init/setup contract-table
- reference index hub cleanup
- root README hub cleanup

之后，

当前最容易继续误导读者的，

不再是“哪条线缺入口”，

而是：

- `03-参考索引/05`

里少数“次选入口”把相邻但不同对象误写成 fallback。

## 为什么这轮落点仍选 `03-参考索引/05`

### 判断一：矩阵层负责“先走哪条路”，所以对象错位在这里伤害最大

`03-参考索引/06`

和专题正文已经把很多边界讲清楚了，

但用户真正 first-hop 仍然会先看：

- `03-参考索引/05`

如果矩阵层把：

- `/plugin`
- `/reload-plugins`

或：

- `/desktop`
- `/session`

写成同一条 fallback 链，

读者就会在第一跳上先被带偏，

再去叶子页里补救。

所以这轮最小且最高价值的一刀仍然是：

- 修矩阵层

## 为什么这轮要把 `/reload-plugins` 单列成独立任务

### 判断二：安装插件包和让当前 session 吃到变更本来就是两种对象

`/plugin`

管理的是：

- 插件包本体与来源

`/reload-plugins`

回答的是：

- 当前 session 刷新与换栈

如果继续把 `/reload-plugins` 塞在 `/plugin` 的次选入口里，

读者会继续把：

- 管包

和：

- 刷当前会话

压成同一步。

所以这轮必须把 `/reload-plugins` 提升成独立任务行。

## 为什么 `/desktop` 的次选入口要改掉

### 判断三：`/session` 不是 Desktop handoff 的退化路径

`/desktop`

回答的是：

- 当前工作对象 handoff 到 Claude Desktop

`/session`

回答的是：

- remote-mode viewer 接续地址

它们相关，

但不是同一种 continuation。

如果继续把 `/session` 写成 `/desktop` 的次选入口，

读者会继续把：

- handoff

和：

- viewer 接续

误写成同一种动作。

## 为什么 `/skills`、`/hooks`、`/agents` 也不能再把 `/plugin` 当次选入口

### 判断四：可见能力面不是插件包目录的同义词

`/skills`、`/hooks`、`/agents`

回答的是：

- 当前会话真实暴露了什么

而：

- `/plugin`

回答的是：

- 插件包本体和来源管理

如果继续把 `/plugin` 写成这些入口的次选路径，

读者会继续把：

- 当前暴露面

和：

- 包管理面

压成一层。

## 为什么要补一段“先分清你在改哪种对象”

### 判断五：修单行不够，还需要把矩阵的 fallback 规则写明

这轮不仅要改几行表格，

还要显式写出：

- `setup-token` vs `/login`
- `/desktop` vs `/session` vs `/remote-control`
- `/plugin` vs `/reload-plugins` vs `/skills|/hooks|/agents|/mcp`

否则同样的对象错位会在别的行里继续复发。

所以这轮补的不是长文专题，

而是：

- 矩阵层的 first-principles 分诊说明

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git pull --ff-only origin main`
- `git rev-parse HEAD origin/main`

返回：

- `pull = Already up to date.`
- `HEAD = 9a6085ae3a95218282b701899647ca0e1a11a705`
- `origin/main = 9a6085ae3a95218282b701899647ca0e1a11a705`

因此本轮 task-matrix object-triage cleanup 切片开始前，主仓库在 fast-forward 视角与 `origin/main` 同步；本轮仍继续只在：

- `.worktrees/userbook`

推进文档切片。

## 苏格拉底式自审

### 问：我现在缺的是再补一个叶子页，还是先修矩阵层里会把人带偏的对象错位？

答：如果对象边界已经在专题和合同层存在，当前更缺的是修 first-hop 矩阵。

### 问：我是不是又想把“相邻入口”直接写成“次选入口”？

答：如果两个入口已经换了对象，就不该再被写成 fallback。

### 问：我是不是只想改单行，而不把“什么时候次选入口才成立”这条规则写出来？

答：如果不把 fallback 规则写明，同样的误判还会在别的行复发。
