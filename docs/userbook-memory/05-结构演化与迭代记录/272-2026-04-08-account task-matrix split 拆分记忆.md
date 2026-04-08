# account task-matrix split 拆分记忆

## 本轮继续深入的核心判断

在完成：

- 顶层 README 的账户入口
- `00-阅读路径` 的路径 89
- `04-专题深潜/15`
- `04-专题深潜/README` 的 account topic route
- `03-参考索引/06` 的 account contract-table

之后，

这条线当前缺的不是：

- 再扩正文
- 再下潜控制面细节

而是：

- 把账户线压进任务视角的一跳矩阵

## 为什么这轮落点选 `03-参考索引/05`

### 判断一：账户线当前缺的是“我现在该先走哪个入口”

这条线已经具备：

- 顶层目标入口
- 阅读路径
- 专题层 first-hop
- 专题正文
- 合同速查

但矩阵层还没有直接回答：

- 我想把 Anthropic 身份正式带进当前会话
- 我想把当前身份现场彻底清空
- 我想改消费者产品隐私设置
- 我想看 guest passes / referral 资格
- 我想升级消费者套餐并让新身份进入当前会话
- 我 hit rate limit 后该跟着哪条产品分流走

所以这轮该补的是：

- task-to-entry matrix

不是：

- 再写一张合同表

## 为什么这轮必须把账户线拆成至少五种对象

### 判断二：账户线最容易被写错的，不是命令名，而是对象主语

`15`

正文已经明确：

- `/login`、`/logout` 处理的是身份现场
- `/privacy-settings` 处理的是消费者产品隐私
- `/passes` 处理的是资格与本地 eligibility cache 显隐
- `/upgrade` 处理的是升级后重新鉴权
- `rate-limit-options` 处理的是 hit rate limit 后的产品分流

如果矩阵层只写：

- “账户设置”

读者就会把：

- 身份
- 隐私
- 资格
- 升级
- 限流分流

重新压平。

## 为什么 `/login` 与 `/logout` 要单列

### 判断三：它们回答的是身份现场的建立与清场，不是通用 provider 切换

`/login`

不是：

- 所有 provider 的统一登录器

而是：

- 把 Anthropic 身份正式带进当前会话

`/logout`

也不是：

- 局部账号切换

而是：

- 把当前会话里的 Anthropic 身份现场与依赖缓存正式清场

如果矩阵不把两者拆开，

读者会继续把：

- 建立身份现场

和：

- 清场身份现场

写成同一种“账户按钮”。

## 为什么 `/privacy-settings`、`/passes` 与 `/upgrade` 不能写成同一行

### 判断四：消费者产品隐私、资格显隐与升级后重鉴权不是同一种账户动作

`/privacy-settings`

回答的是：

- consumer 侧 Grove / Help improve Claude 设置

`/passes`

回答的是：

- guest passes / referral 资格是否显露

`/upgrade`

回答的是：

- 消费者套餐升级后让新身份重新进入当前会话

如果把三者压成一行，

读者会继续把：

- 产品设置
- 资格缓存
- 升级后重鉴权

误写成同一种“订阅管理”。

## 为什么 `rate-limit-options` 也要进矩阵

### 判断五：限流后的产品分流不是状态页尾巴，而是用户任务的一跳决策

`rate-limit-options`

虽然是：

- 隐藏入口
- 多由系统内部唤起

但它回答的仍然是：

- hit rate limit 后该走升级
- 还是买 extra usage
- 还是等待 reset

如果矩阵层不把这条线显式写出，

读者会继续把：

- 限流分流

误写成：

- `/usage` 的附属说明

而不是：

- 账户产品面的后续决策入口

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git rev-parse HEAD origin/main`

返回：

- `HEAD = 9a6085ae3a95218282b701899647ca0e1a11a705`
- `origin/main = 9a6085ae3a95218282b701899647ca0e1a11a705`

因此本轮 account task-matrix 切片开始前，主仓库在 fetch 视角与 `origin/main` 同步；本轮仍继续只在：

- `.worktrees/userbook`

推进文档切片。

## 苏格拉底式自审

### 问：我现在缺的是再解释 `15` 的正文，还是缺把用户任务压回“先走哪个入口”的矩阵层？

答：如果顶层、路径、专题和合同速查都已存在，当前更缺的是矩阵层。

### 问：我是不是又想把身份、隐私、资格、升级和限流分流压成同一种“账户设置”？

答：如果矩阵不显式保护五种对象，这个误判会立刻复发。

### 问：我是不是又想把 `/privacy-settings`、`/passes`、`/upgrade` 写成同一类订阅按钮？

答：如果不单列产品设置、资格显隐和升级后重新鉴权，这条线会再次被写平。
