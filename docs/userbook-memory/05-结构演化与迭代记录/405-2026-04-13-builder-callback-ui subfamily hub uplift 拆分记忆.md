# builder-callback-ui subfamily hub uplift 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经补完：

- `100-115 -> 105-110`
  的 wider-wire 子家族入口

之后，

当前最值钱的下一刀，

不是回去重写 `210` 正文，

而是把：

- `111-115`

从 `100-115` 子家族里也抽成一个更窄入口。

## 为什么这轮值得单独提交

### 判断一：`111-115` 已经天然收成“一张根表 + 两条支线”

这一段现在已经清楚分成：

- `111` 四层可见性表根页
- `112→113` streamlined dual-entry / passthrough 支线
- `114→115` callback-visible / adapter triad / UI policy 支线

并且已经被：

- `210`
- `375`

稳定钉成一张根表加两条后继线的结构。

这说明它已经不只是 `100-115` 的后半段，

而是可以被单独浏览的一条更窄子家族。

### 判断二：这轮比回去补 `210` 更值，因为当前缺的是入口，不是事实

`210`

现在已经有：

- scope guard
- stable / conditional / gray 分层
- 苏格拉底式自审

所以这一刀如果继续回正文，

收益会低于直接把：

- `111-115`

抽成一条更清晰的入口。

更稳的最小动作其实是：

1. 在 `100-115` 的 `111-115` 小节里
   明说：
   - 如果你已经确认自己在追 builder / callback / streamlined / UI consumer 这支，就直接进 `111-115`
2. 新增一个 README-only subfamily hub：
   - `111-115-builder、callback、streamlined 与 UI consumer 家族/README.md`

这样：

- 上游 `100-115`
  继续只做上一层分流
- `111-115`
  才承担这条支线自己的下一层入口

### 判断三：这轮和 `105-110` 互补，不会产生范围重叠

`105-110`

已经单独承担了 wider-wire / callback narrowing / projection 那条 visibility / provenance 线。

`111-115`

则承担：

- builder/control transport
- callback-visible surface
- streamlined dual-entry
- adapter triad / UI policy

这条 consumer / policy 线。

两者同属 `100-115`，

但不抢同一段 first-stop。

## 这轮具体怎么拆

这轮只做四件事：

1. 修改 `100-115` hub
   - 在 `111-115` 小节里增加直达 `111-115` 子家族的显式入口
2. 新增：
   - `111-115-builder、callback、streamlined 与 UI consumer 家族/README.md`
3. 新增这条 `405` 记忆
   - 记录为什么这轮优先抽 `111-115`
4. 更新 `memory/05 README`
   - 同步批次索引到 `405`

这样：

- `root -> 100-149 -> 100-115 -> 111-115`
  会形成连续的 hub handoff 链
- `111-115`
  也会成为一条稳定的 builder/callback/UI 子家族入口

## 苏格拉底式自审

### 问：为什么这轮不是继续去补 `210` 的正文？

答：因为 `210` 的正文厚度已经足够。当前更缺的是目录层怎样把人直接送到这条支线，而不是再补一层说明。

### 问：为什么这轮不是去做 `116-127`？

答：因为 `116-127` 仍和现有 `122-149` 有更强重叠；`111-115` 则是 `100-115` 内部边界清楚、且不与别的现有子家族抢范围的一刀。

### 问：为什么这也算“加强对使用功能的剖析”？

答：因为用户对 builder / callback / streamlined / UI 这条线的理解，依赖先走对入口。没有 `111-115` 这层子家族，读者仍会在 `100-115` 里按范围碰运气，而不是沿着 consumer / policy 的边界下钻。
