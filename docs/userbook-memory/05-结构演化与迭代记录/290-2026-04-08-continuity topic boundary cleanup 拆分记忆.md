# continuity topic boundary cleanup 拆分记忆

## 本轮继续深入的核心判断

这轮最值得先收的，

不是 continuity 主线再加更多解释，

而是把 continuity 专题正文里仍然残留的：

- `/rename`
- `/export`

从主对象里退回到邻近动作。

## 为什么这轮落点选 `04-专题深潜/02-连续性与记忆专题.md`

### 判断一：导航层已经把 continuity 和 session operations 分开，但专题正文还留着一点主语渗漏

导航层现在已经比较一致：

- continuity 主线讲 `/memory`、`/compact`、`/resume`
- session operations 主线讲 `/copy`、`/rename`、`/export`、`/branch`、`/rewind`、`/clear`

索引层也已经明确：

- `/rename`、`/export` 只是 continuity 的邻近能力

但 continuity 专题正文里仍然有一节：

- `命名与导出`

并且在“稳定面”里还把：

- `/rename`
- `/export`

列进来。

这会让读者回到专题层时重新吸收成：

- 命名与外化也属于 continuity 本体

从而抵消前面已经收好的主线分工。

## 为什么这轮不动 `/export` 的误用提醒

### 判断二：误用提醒属于边界纠偏，不等于把它重新并入主对象

`/export`

虽然不该留在 continuity 的稳定面里，

但：

- “不要把 `/export` 当 continuity 替代品”

这条提醒本身是有价值的，

因为它正好在防止读者把：

- 外化

误当成：

- 系统内部连续性

所以这轮只做：

- 把 `/rename`、`/export` 从主题本体降级为邻近动作
- 从稳定面移除它们

而不删掉误用提醒。

## 为什么这轮不顺手改 `/clear`

### 判断三：`/clear` 的边界偏移属于 session operations 专题，不该和 continuity 主线混成同一刀

并行分析也给出另一个可做候选：

- `/clear` 在会话运营专题里被半步压进“时间线改写”

但那条处理的是：

- session operations 主线

而这轮更强的对象边界问题在于：

- continuity 专题还残留 session operations 的动作

所以这轮先把 continuity 主体收干净。

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

### 问：我是不是把“紧邻 continuity 的动作”误写成了“continuity 本体”？

答：如果 `/rename`、`/export` 继续留在稳定面里，这个误判就还在。

### 问：我是不是因为 `/export` 对 continuity 有边界提醒价值，就顺手把它并回主对象了？

答：边界提醒可以保留，但主对象不该因此扩张。

### 问：我是不是又想把 session operations 那边的 `/clear` 一起带上？

答：那会把两个不同主语的修正混成一刀，破坏提交边界。
