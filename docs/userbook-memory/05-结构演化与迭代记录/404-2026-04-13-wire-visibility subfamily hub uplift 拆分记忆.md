# wire-visibility subfamily hub uplift 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经补完：

- `100-149 -> 100-115`
  的 handoff

之后，

当前最值钱的下一刀，

不是继续去做 `111-115`，

也不是回头再补 `209` 的正文厚度，

而是把：

- `105-110`

从 `100-115` 子家族里再抽成一个更窄的入口。

## 为什么这轮值得单独提交

### 判断一：`105-110` 已经天然收成一条 wider-wire visibility 分叉链

这一段现在已经清楚分成：

- `105` wider-wire visibility 根页
- `106` raw wire contract
- `108` callback narrowing
- `109` pre-wire projection
- `110` suppress-reason split 交叉叶子

并且已经被：

- `209`
- `374`

稳定钉成一张根分裂加三条后继线、再接一张交叉叶子的结构。

这说明它已经不只是 `100-115` 的中段，

而是可以被单独浏览的一条更窄子家族。

### 判断二：这轮比 `111-115` 更优先，因为 wider-wire 这一支边界更清楚

`111-115`

当然也已经有：

- `210`

这张结构页，

但它内部继续拆时，

会更快碰到：

- builder/control transport
- callback-visible surface
- adapter triad
- host-specific UI consumer policy

这些更依赖宿主与 policy 的对象。

相比之下，

`105-110`

更像一条完整的 visibility / provenance 链：

- wider wire
- raw wire
- callback narrowing
- projection
- suppress reason

这条线的阅读骨架更集中，

也更适合优先抽成 README-only hub。

### 判断三：目录优化在这一轮继续遵守“上一层只送到下一层”

这轮如果回 `100-115` 再补更多解释，

会把已经干净的上层入口重新写厚。

更稳的最小动作其实是：

1. 在 `100-115` 的 `105-110` 小节里
   明说：
   - 如果你已经确认自己在追 wider-wire / callback narrowing / projection 这支，就直接进 `105-110`
2. 新增一个 README-only subfamily hub：
   - `105-110-wider wire、callback narrowing 与 projection 家族/README.md`

这样：

- `100-115`
  继续只承担上一层分流
- `105-110`
  才承担 wider-wire 这一支的下一层入口

## 这轮具体怎么拆

这轮只做四件事：

1. 修改 `100-115` hub
   - 在 `105-110` 小节里增加直达 `105-110` 子家族的显式入口
2. 新增：
   - `105-110-wider wire、callback narrowing 与 projection 家族/README.md`
3. 新增这条 `404` 记忆
   - 记录为什么这轮优先抽 `105-110`
4. 更新 `memory/05 README`
   - 同步批次索引到 `404`

这样：

- `root -> 100-149 -> 100-115 -> 105-110`
  会形成连续的 hub handoff 链
- `105-110`
  也会成为一个稳定的 wider-wire 子家族入口

## 苏格拉底式自审

### 问：为什么这轮不是先做 `111-115`？

答：因为 `105-110` 的阅读骨架更集中，也更不依赖 host/policy 语境；它是更干净的一刀。

### 问：为什么这轮不是回头再补 `209`？

答：因为 `209` 已经有结构页和 scope guard。当前缺的是目录层怎样把人直接送到这条线，而不是再补一层正文。

### 问：为什么这也算“加强对使用功能的剖析”？

答：因为用户对 wire / callback / projection 这条线的理解，依赖先走对入口。没有 `105-110` 这层子家族，读者仍会在 `100-115` 里按范围碰运气，而不是沿着 visibility / provenance 的边界下钻。
