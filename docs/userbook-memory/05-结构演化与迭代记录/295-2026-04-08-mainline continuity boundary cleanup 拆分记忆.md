# mainline continuity boundary cleanup 拆分记忆

## 本轮继续深入的核心判断

这轮最值得先收的，

不是 continuity 主线再加更多使用建议，

而是把主线使用页里仍然把：

- `/rename`
- `/export`

压回 continuity 的那一小段收干净。

## 为什么这轮落点选 `01-主线使用/04-会话、恢复、压缩与记忆.md`

### 判断一：专题层已经分清，主线页不能继续把 session operations 混回 continuity

前面几轮已经收过：

- continuity 专题本体只留 `/memory`、`/compact`、`/resume`
- session operations 专题负责 `/rename`、`/copy`、`/export`、`/branch`、`/rewind`、`/clear`

根层 `README`、阅读路径和专题前门也都已经按这条线分流。

但主线使用页里，

`/rename`、`/resume`、`/compact`、`/export`

仍被并列写成：

- 连续性手段

这会让读者回到最靠前的使用页时，

再次吸收成：

- 命名与导出也是 continuity 本体

从而冲掉前面已经收好的主线边界。

## 为什么这轮不顺手把 `/copy` 也塞进主线使用页

### 判断二：当前缺的是把错位动作拿出去，不是再把 session operations 全量搬进主线页

主线使用页这一段原本就是在讲：

- 长任务怎样续上

所以最小有效修法不是：

- 再把 `/copy`、`/branch`、`/rewind`、`/clear` 都补进来

而是：

- 把 `/rename`、`/export` 从 continuity 本体里拿出去
- 再给一个清晰 handoff 到会话运营专题

这样既能修对象边界，

又不会把主线页重新撑成 session operations 总表。

## 这轮具体怎么拆

### 判断三：主线页保留 continuity 本体，再加一个邻近动作提示就够了

这轮把：

- `什么时候该用哪条连续性手段`

改成：

- `什么时候该用哪条 continuity 本体手段`

并把：

- `/resume`
- `/compact`
- `/memory`

保留在本体里。

同时新增一小段：

- `邻近但不属于 continuity 本体的动作`

把：

- `/rename`
- `/export`

放进去，

再显式 handoff 到：

- `07-会话运营、分叉与回退专题`

## 为什么这轮不再回头改 continuity 专题

### 判断四：专题层已经对齐，这轮只补主线使用页残留

continuity 专题那边已经收过边界，

这轮剩下的残留就在最靠前的主线使用页。

所以这轮只补：

- `01-主线使用/04-会话、恢复、压缩与记忆.md`

避免把已对齐的专题层再带入一次 commit。

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

### 问：我是不是把“和长任务续上很接近”误当成了“就是 continuity 本体”？

答：接近不等于同属本体；命名与外化是邻近动作，不是系统内部连续性本身。

### 问：我是不是因为主线页追求简明，就允许它继续用一个宽标题把不同对象压在一起？

答：简明不能以牺牲主语边界为代价；主线页恰恰更需要早早分清对象。

### 问：我是不是又想借这刀顺手把整个 session operations 概览搬进主线页？

答：不需要。最小有效切片，是把错位动作拿出去并给出 handoff。
