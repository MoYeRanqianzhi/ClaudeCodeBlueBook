# command-index resume grouping cleanup 拆分记忆

## 本轮继续深入的核心判断

这轮最值得先收的，

不是再去扩 continuity 正文，

而是把命令索引里：

- `/resume`

的分组位置纠正回来。

## 为什么这轮落点选 `03-参考索引/01-命令工具/01-命令索引.md`

### 判断一：其它层已经把 `/resume` 收进 continuity，本页是最后一个明显残留

前面几轮已经形成了稳定口径：

- continuity 本体是 `/memory`、`/compact`、`/resume`
- “旧会话怎么找回来”另属于 session discovery / resume picker

但命令索引里，

`/resume`

还放在：

- `会话与导航`

并写成：

- 恢复旧会话

这会让读者第一跳先吸收成：

- `/resume` 只是会话导航

而不是：

- 把同一工作对象重新接回可继续现场

这和主线使用页、continuity 专题、合同速查页都不一致。

## 为什么这轮不顺手改 `/session`

### 判断二：`/session` 仍然属于导航 / remote viewer，不该和 `/resume` 一起被拖去 continuity

这轮只改：

- `/resume`

因为：

- `/session` 是 remote mode 下的 viewer URL / QR
- `/resume` 是 continuity / 长任务接续

两者虽然都和“回到某个现场”有关，

但对象不同。

如果因为 `/resume` 挪组，就顺手去重写整个“会话与导航”大组，

就会把当前最小切片扩成重排。

## 这轮具体怎么拆

### 判断三：只挪一条命令，并顺手把它的释义改成 continuity 语义

这轮把：

- `/resume`

从：

- `会话与导航`

移到：

- `上下文与连续性`

并把释义从：

- 恢复旧会话

改成：

- 把同一工作对象重新接回可继续的现场

这样既补足分组，

也把命令索引里的单行定义同步到现有主线口径。

## 为什么这轮不再联动其它文件

### 判断四：其它层已经对齐，这轮只补命令索引最后一条残留

主线使用页、continuity 专题、运行时合同速查、阅读路径

都已经按 continuity 主体来写 `/resume`。

这轮剩下的唯一明显残留，

就是命令索引。

所以这轮只补它，

不再把其它页面带入 commit。

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

### 问：我是不是把“能回到旧现场”误当成了“只是会话导航”？

答：对 `/resume` 来说，重点不是导航，而是 continuity。

### 问：我是不是想顺手把整个命令索引再重排一遍？

答：不需要。当前最小有效切片只是一条命令的挪组与释义同步。

### 问：我是不是因为 `/resume` 和 `/session` 都有“会话”味道，就把它们硬压成一组？

答：名字接近不等于同层；`/session` 是 viewer 地址，`/resume` 是工作对象接续。
