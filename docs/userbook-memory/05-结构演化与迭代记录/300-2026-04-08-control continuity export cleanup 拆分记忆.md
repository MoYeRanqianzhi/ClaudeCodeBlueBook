# control continuity export cleanup 拆分记忆

## 本轮继续深入的核心判断

这轮最值得先收的，

不是连续性控制面再加更多机制解释，

而是把：

- `/export`

从控制面页里被抬成“第四类连续性机制”的残留收回去。

## 为什么这轮落点选 `05-控制面深挖/03-Compact、Resume、Memory：长任务连续性手册.md`

### 判断一：控制面页的定义已经落后于主线页、专题层和导出专题

当前其它层已经形成一致口径：

- continuity 本体是 `Compact`、`Resume`、`Memory`
- `/export` 是邻近动作，处理会话外正式外化

但控制面页里仍写成：

- 如果把用户对外交付也算进连续性管理，还应再加一类：`Export`

这会让读者在控制面层重新吸收成：

- `Export` 也是连续性本体

而这和：

- 主线使用页
- continuity 专题
- 导出与反馈专题

都已经冲突。

## 为什么这轮不删掉 `/export`

### 判断二：问题不是提不提 `/export`，而是它在这页里的对象层级被写高了

`/export`

当然仍然和长任务连续性相邻，

因为用户常常会在任务阶段结束时把结果带出系统。

所以这轮不需要：

- 把 `/export` 从这页完全删掉

只需要把它从：

- 连续性第四类机制

降成：

- 邻近但不属于连续性本体的动作

就够了。

## 这轮具体怎么拆

### 判断三：保留 `Export` 段落，但显式改成邻近动作并 handoff

这轮做三件事：

1. 删掉“第四类连续性机制：Export”这一层定义。
2. 把 `Export` 段标题改成“邻近但不属于连续性本体的动作：Export”。
3. 增加一条 handoff 到 `08-Rename、Export：会话对象化与对外交付`。

这样：

- 连续性本体的三元组重新闭合
- `/export` 仍被解释
- 但不再占 continuity 本体位阶

## 为什么这轮不顺手改 `08-Rename、Export`

### 判断四：导出专题本身已经对齐，这轮只补控制面残留

`08-Rename、Export：会话对象化与对外交付`

本身已经在承担：

- 当前工作对象怎样被命名与外化

所以这轮不需要再去动它。

真正落后的只剩：

- `03-Compact、Resume、Memory：长任务连续性手册`

这一页。

## 主树状态记录

2026-04-08 在主仓库 `/home/mo/m/projects/cc/analysis` 执行：

- `git fetch origin main`
- `git pull --ff-only origin main`
- `git rev-parse HEAD origin/main`
- `git status --short --branch`

结果是：

- `pull` 失败：`Pulling is not possible because you have unmerged files.`
- `HEAD = 972710438969878ee81241448a9d4b0e5789ccb3`
- `origin/main = 14c35307967740992aecb66f821b74a5d86efa7e`
- 主仓库状态：`## main...origin/main [ahead 10]`
- 且存在未解决冲突，例如：
  - `UU bluebook/userbook/01-主线使用/04-会话、恢复、压缩与记忆.md`
  - `UU bluebook/userbook/03-参考索引/06-高价值入口运行时合同速查.md`
  - `UU bluebook/userbook/README.md`

因此本轮继续深入仍继续只在：

- `.worktrees/userbook`

推进，不触碰主仓库冲突。

## 苏格拉底式自审

### 问：我是不是把“和长任务连续发生在相邻阶段”误当成了“就是连续性机制本体”？

答：相邻不等于同属本体；`Export` 是会话外外化动作，不是系统内部连续性本身。

### 问：我是不是因为这页标题就叫 Compact、Resume、Memory，所以不敢显式写它旁边还有邻近动作？

答：恰好相反，正因为标题已经限定了本体，`Export` 更不该再被抬成第四类本体机制。

### 问：我是不是又想把控制面整条链重写一遍？

答：不需要。当前最小有效切片只是在这一页把 `Export` 降回邻近动作。
