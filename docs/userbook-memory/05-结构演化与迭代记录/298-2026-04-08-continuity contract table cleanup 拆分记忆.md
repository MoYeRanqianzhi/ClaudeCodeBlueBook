# continuity contract table cleanup 拆分记忆

## 本轮继续深入的核心判断

这轮最值得先收的，

不是 continuity 再加更多正文，

而是把运行时合同速查页里还残留的：

- `/rename`
- `/export`

从 continuity 主表里拿出去。

## 为什么这轮落点选 `03-参考索引/06-高价值入口运行时合同速查.md`

### 判断一：标题已经收回 continuity 本体，但最小分工表还留着双重归属

这页的 continuity 段标题已经是：

- `/memory`、`/compact`、`/resume`

但最小分工表里，

仍然还挂着：

- `/rename`
- `/export`

这会让读者继续吸收成：

- `/rename`、`/export` 既属于 continuity
- 又属于 session operations

而前面几轮已经在：

- 主线使用页
- continuity 专题
- session operations 专题

把这条边界收回来了。

## 为什么这轮不顺手改其它 continuity 页面

### 判断二：主线页和专题层已经对齐，这轮只补合同速查残留

前面已经收过：

- 主线使用页：`/rename`、`/export` 降成邻近动作
- continuity 专题：`/rename`、`/export` 不属于本体

这轮剩下的明显残留只在：

- 运行时合同速查页的 continuity 主表

所以这轮不需要：

- 再回头改 continuity 专题
- 再改阅读路径
- 再改根 README

只要把表格收干净即可。

## 这轮具体怎么拆

### 判断三：表格只保留 continuity 本体，边界提醒继续保留

这轮把最小分工表收窄成：

- `/context` + `/files`
- `/memory`
- `/compact`
- `/resume`

同时保留一条边界提醒：

- `/rename`、`/export` 紧邻 continuity，但应转去 session operations 主线

这样既不会丢掉读者的邻近误判纠偏，

也不会再让 continuity 主表继续吞 session operations。

## 为什么这轮不去动 “完整结构导航”

### 判断四：物理目录列举不等于 first-hop 路由，本轮更强的矛盾在 same-object 表格

并行分析里还有一个更轻的候选：

- 根 README 的“完整结构导航”仍把 `02-能力地图` 与其它目录并列列出

但那一层更接近：

- 物理结构列举

而不是：

- first-hop 路由

相比之下，

continuity 主表把不同对象继续写进同一表，

是更直接的 same-object 问题。

所以这轮先收合同表。

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

### 问：我是不是以为“紧邻 continuity”就足够继续留在 continuity 主表里？

答：紧邻不等于属于本体；主表应只收本体对象。

### 问：我是不是为了保留边界提醒，就默认应该把 `/rename`、`/export` 继续放在表格里？

答：提醒可以留在文字层，但不该继续占 continuity 主表的行。

### 问：我是不是又想被另一个更轻的导航候选带偏，忽略了当前更直接的对象表格残留？

答：当前更强的矛盾是 same-object 表格混层，不是目录列举层的轻微泄漏。
