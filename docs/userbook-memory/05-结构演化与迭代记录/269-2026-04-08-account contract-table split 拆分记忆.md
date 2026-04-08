# account contract-table split 拆分记忆

## 本轮继续深入的核心判断

在完成：

- 顶层 README 的账户入口
- `00-阅读路径` 的路径 89
- `04-专题深潜/15`
- `04-专题深潜/README` 的 account topic route

之后，

这条线当前缺的不是：

- 再补正文
- 先补矩阵

而是：

- 把 account / privacy / eligibility / upgrade 压成显式合同块

## 为什么这轮落点选 `03-参考索引/06`

### 判断一：前门、路径、专题和 first-hop 都已具备，最后缺的是“高价值入口运行时合同速查”

这条线当前已经具备：

- 顶层目标入口
- 阅读路径
- 专题层 first-hop
- 专题正文

但在 `03-参考索引/06`

里，

还没有一组把：

- `/login`
- `/logout`
- `/privacy-settings`
- `/passes`
- `/upgrade`
- `rate-limit-options`

显式收成同主题合同块。

所以这轮最小且最高价值的一刀就是：

- account contract-table

## 为什么这轮必须把“身份现场”和“产品面资格/升级”分成两组

### 判断二：账户线最容易被写平的，不是按钮名，而是主语

`15`

正文已经明确：

- `/login`、`/logout` 回答身份切换与清场
- `/privacy-settings` 回答消费者产品设置
- `/passes` 回答资格与激励
- `/upgrade`、`rate-limit-options` 回答升级与限流分流

如果合同层不把这两组显式拆开，

读者就会继续把：

- 登录/退出
- 隐私设置
- 资格显隐
- 升级与限流分流

写成同一种“账户设置”。

所以这轮必须先把：

- 身份现场

和：

- 产品面资格/升级

分开。

## 为什么这轮要把 3P provider 边界写进 `/login` 与 `/logout`

### 判断三：身份入口是否出现，本身就受 provider 模式改写

`15`

正文已经明确：

- `commands.ts` 里 `login/logout` 只在 `!isUsing3PServices()` 时注册

这意味着：

- Bedrock
- Vertex
- Foundry

这类模式下，

- `/login`
- `/logout`

本身就不会出现。

如果合同层不把这条边界写死，

读者会继续把：

- `/login`

误写成所有 provider 的统一入口。

## 为什么这轮要把 `/privacy-settings` 和全局 telemetry 抑制面明确切开

### 判断四：消费者产品隐私设置不是环境变量级 kill switch

`15`

正文已经明确：

- `/privacy-settings` 管的是 consumer 侧 Grove / Help improve Claude

而不是：

- `DISABLE_TELEMETRY`
- `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`

如果合同层不单独保护这点，

读者会继续把：

- 产品面隐私设置

和：

- 全局环境开关

写成一回事。

## 为什么这轮要把 `/passes` 和 `rate-limit-options` 的“显隐/隐藏”属性写进合同层

### 判断五：这条线里最容易被误判的，正是“看不到就代表没有”

`/passes`

依赖本地 eligibility cache，

没有 cache 时即使真实有资格也可能先隐藏。

`rate-limit-options`

本身就是：

- `isHidden: true`

且只在限流分流时由系统内部唤起。

如果合同层不把这两类显隐逻辑写明，

读者会继续用：

- “我看不到”

来直接推出：

- “它不存在”
- “我没有资格”

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git rev-parse HEAD origin/main`

返回：

- `HEAD = 14a32705ffe0eb9bb274fc2aa59ea3cfe2bae0e1`
- `origin/main = 9cb9fb702f5ea1590a16b15638d4c875284dabc2`

主仓库仍不适合作为本轮编辑面，因此继续只在：

- `.worktrees/userbook`

推进 account contract-table 切片，不去改主仓库状态。

## 苏格拉底式自审

### 问：我现在缺的是再解释 `15` 正文，还是缺把它压成速查层显式合同块？

答：如果前门、路径、专题和 first-hop 都已存在，当前更缺的是合同速查。

### 问：我是不是又想把 `/login`、`/privacy-settings`、`/passes`、`/upgrade` 压成同一种“账户菜单”？

答：如果不把身份现场与产品面资格/升级分组，这个误判会立刻复发。

### 问：我是不是又要把看不见某个入口直接等同于没有资格或功能不存在？

答：如果不把 `/passes` 的 cache 显隐和 `rate-limit-options` 的 hidden 分流写明，这个误判会继续存在。
