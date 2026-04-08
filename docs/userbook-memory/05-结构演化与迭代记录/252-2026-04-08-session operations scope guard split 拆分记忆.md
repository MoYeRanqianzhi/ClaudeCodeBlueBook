# session operations scope guard split 拆分记忆

## 本轮继续深入的核心判断

在完成：

- session operations 顶层前门

之后，

这条线当前最需要的不是：

- 再补一个阅读路径
- 再扩速查合同

而是：

- 给 `04-专题深潜/07`
  补范围护栏

## 为什么这轮该补范围护栏

### 判断一：当前最大风险已经从 discoverability 转成 boundary drift

顶层 README 现在已经把：

- “运营当前会话对象”

单独抬出来了。

这意味着用户已经能：

- 看见这条线

但 `07-会话运营、分叉与回退专题`

开头仍然容易让人把：

- continuity
- 旧会话发现
- remote host/viewer
- ant-only `/tag`

都误听成这页的同层对象。

所以当前更紧的修复是：

- scope guard

不是：

- 再加入口

## 为什么范围护栏要先把三条邻近线分走

### 判断二：当前工作对象运营、当前工作对象续接、过去工作对象发现、远端宿主/接续不是同一主语

`07`

关心的是：

- 当前工作对象怎么被命名
- 怎么外化
- 怎么分叉
- 怎么回退
- 怎么切出新的空工作面

`02`

更关心：

- `/memory`
- `/compact`
- `/resume`

怎样让当前工作对象继续。

`12`

更关心：

- 过去工作对象在哪里
- 该恢复哪个会话

`16/20`

更关心：

- host / viewer / remote continuation

所以这轮护栏必须先把：

- `02`
- `12`
- `16/20`

显式分走。

## 为什么这轮要补“默认只讨论普通用户、默认宿主、当前会话对象上的稳定运营动作”

### 判断三：如果不先锁范围，后文的 `/rewind`、`/clear`、`/tag` 很容易被误读成无前提主线

并行边界分析指出：

- `/rewind`
- `/clear`

的前置描述在没有护栏时，

很容易被误听成：

- 无条件 rollback
- 轻量清理动作

同时：

- `/tag`

虽然正文后面已降级，

但版位上仍可能被误收成普通入口。

所以这轮必须先补一句总前提：

- 普通用户
- 默认宿主
- 当前会话对象上的稳定运营动作

再明确：

- `/session`
- `/remote-control`

不属于这页主线，

`/tag`

也仍只是 ant-only / 内部边界提醒。

## 为什么这轮不动正文后面的合同句

### 判断四：当前缺的是开篇防漂移护栏，不是后文定义错了

`07`

后面已经分别解释：

- `/copy`
- `/export`
- `/branch`
- `/rewind`
- `/clear`

真正问题不是这些段落的定义本身，

而是：

- 读者在进入这些定义之前
- 还不知道哪些对象应该被排除在页外

所以这轮只补：

- 开篇 scope guard

不重写：

- 后文合同

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git rev-parse HEAD origin/main`
- `git pull --ff-only origin main`

得到：

- `HEAD = a0a81c32d6a7d8ca023c0b1f3f590f865e5923df`
- `origin/main = 6dc2cdb43beb03b5d5e6e7acaf09455d4d095aae`
- `git pull --ff-only origin main` 因主仓库存在未解决冲突而失败

同时 `git status --short --branch` 显示：

- `main...origin/main [ahead 28]`
- 并带未解决冲突与脏改动

因此本轮只能：

- 完成检查与拉取尝试
- 继续只在 `.worktrees/userbook` 内推进

不能安全修改主仓库 `main`。

## 苏格拉底式自审

### 问：我现在缺的是再补入口，还是缺让专题 07 一开头就把“这页不处理什么”说清？

答：顶层前门已补完，当前缺的是 scope guard。

### 问：我是不是又想把 continuity、旧会话发现和远端接续都顺手塞回会话运营页？

答：如果开篇不先分走 `02`、`12`、`16/20`，这个误判就会反复出现。

### 问：我是不是想继续碰主仓库 `main`，而不是遵守“只在 userbook worktree 推进”的隔离要求？

答：在主仓库 unresolved conflict 解除前，不应对 `main` 做进一步写操作。
