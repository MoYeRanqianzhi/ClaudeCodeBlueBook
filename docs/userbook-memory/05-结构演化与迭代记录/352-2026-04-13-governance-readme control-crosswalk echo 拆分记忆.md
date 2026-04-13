# governance-readme control-crosswalk echo 拆分记忆

## 本轮继续深入的核心判断

这一轮不是继续扩写 `05-控制面深挖/README`，

而是把刚落下的：

- `control vs governance`

crosswalk

往上游的：

- `02-能力地图/03-治理与边界/README.md`

回声一次，

让治理总则页也不再把控制对象和治理裁决揉成一层。

## 为什么这轮值得单独提交

### 判断一：`05` 已经补了用户动作层 crosswalk，但上游治理 README 还缺一条对应的最小护栏

上一刀已经在：

- `05-控制面深挖/README`

补上了：

- 先归 control
- 再升 governance

但更上游的：

- `02-能力地图/03-治理与边界/README`

目前还只写到：

- pricing-right
- 不同控制面不是一把总开关
- 先回治理顺序

它还缺一句更显式的话：

- `host / session / sandbox / worktree / viewer`
  这些对象归 control
- `pricing-right / truth-surface`
  才归 governance

### 判断二：这刀比继续扩大到 `02-体验与入口/README` 更稳

`02-体验与入口`

已经把：

- `host -> session -> projection -> display`
- `无真相签发权`

说得很清楚。

当前最小缺口不在“体验层是否有 projection”，

而在：

- 治理总则页是否也显式承认 control 先于 governance

所以先在治理 README 补这一句，

比再横向扩到另一页更小、更稳。

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `02-能力地图/03-治理与边界/README.md`
   第一段之后加一个极小的：
   - `## control vs governance`
2. 用 3 行把它压成：
   - control 先分对象与 projection/readback
   - governance 再判 `pricing-right + truth-surface`
   - `/status / /usage / /resume / /remote-control`
     若不先归 control，就最容易被误写成 governance verdict

这样：

- `05`
  的用户动作层 crosswalk
  有了上游 echo
- 治理 README
  也不再只像“治理顺序摘要”，而开始显式承认控制对象层

## 苏格拉底式自审

### 问：为什么不把这一句直接放回 `02-体验与入口/README`？

答：因为那一页已经在讲 projection 与 signer 区分。当前缺的是治理页自己承认：不是所有相邻入口词都在谈 governance。

### 问：为什么只加 3 行，不写更完整表？

答：因为这一刀只是给上游 README 一个 echo，不是重复 `05` 的完整 crosswalk。太长就会重新变成两页并列解释同一件事。
