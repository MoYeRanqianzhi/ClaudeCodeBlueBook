# remote recovery-to-shell subfamily hub uplift 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经补完：

- `100-149` 的 family hub

之后，

当前更值钱的下一刀，

不是立刻去补新的单页 hardening，

而是把：

- `122-149`

从 `100-149` 家族里再抽成一个更细的子家族入口。

## 为什么这轮值得单独提交

### 判断一：`122-149` 已经天然长成三段稳定骨架

这一段现在已经清楚分成：

- `122-127` recovery / ownership / terminality / compaction
- `128-138` surface presence / topology / interaction shell
- `139-149` remote truth / shell pair / env-driven memory

而且每一段都已经有：

- 对应蓝皮书结构页
- 对应 scope guard 记忆

这说明它不再只是 `100-149` 里的一长串后续编号，

而是可以被单独浏览的一段中层家族。

### 判断二：这一刀比继续补新页更能提升检索效率

当前读者如果已经知道自己在追的是：

- recovery
- remote surface
- remote truth / shell / memory

却还得先进入 `100-149` 总家族再往下扫，

这条路径已经有点长。

所以更稳的最小改动不是再开新页，

而是加一个更细的 README-only subfamily hub，

把 `122-149` 直接抽成二层入口。

## 这轮具体怎么拆

这轮只做三件事：

1. 新增：
   - `122-149-remote recovery、surface truth 与 shell 家族/README.md`
2. 在主 `README.md`
   里，
   给 `family hub` 再补一条入口
3. 新增这条 `391` 记忆，
   记录为什么这轮优先做子家族入口，而不是继续补新页

这样：

- `122-149` 会从“`100-149` 家族里的中段”
  变成“可直接跳入 recovery / surface / truth-shell 三段骨架”的二层入口
- 目录结构仍保持 README-only 模式
- 后续若还要把 `122-149` 再细分到更小簇，也有一条清晰模板

## 苏格拉底式自审

### 问：为什么这轮不是继续补 `214` 或 `215` 的页首？

答：因为这几页和对应记忆已经能支撑结构判断。当前更缺的是目录层怎么让人直接跳到这一簇，而不是再补一句页首。

### 问：为什么不是给 `100-115` 或 `116-127` 单独抽子家族？

答：因为 `122-149` 跨越 recovery、surface 与 truth-shell 三层，内部阅读关系更复杂，抽出来的收益更高。

### 问：为什么仍然不搬原始记忆文件？

答：因为当前最需要优化的是导航，不是物理路径。先加 subfamily hub，后谈搬迁，风险更低。
