# ingress-permission-blocked family hub uplift 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经补完：

- `168-190` 的 memory family hub
- `100-149` 的 memory family hub

之后，

当前最自然的下一刀，

不是继续新开局部结构页，

而是给：

- `191-206`

这簇 ingress / permission / blocked-state 记忆也补一个 family hub。

## 为什么这轮值得单独提交

### 判断一：当前真正缺的是“家族入口”，不是新的 branch map

`191-206` 现在已经同时拥有：

- `197` 对 `191-196` 的 ingress 阅读链
- `203` 对 `196-202` 的 permission tail 分叉图
- `206` 对 blocked-state ceiling 的局部结构页
- `205` 的专题投影
- `222` 的 stable-gray hardening

这说明它缺的已经不是：

- 新的树形组织
- 新的范围图

而是：

- 在主 `README` 的时间流之外，
  先给这一整簇文件一个可浏览的家族入口

### 判断二：这轮和前两次 family hub 一样，最稳的仍是 README-only hub

当前最需要优化的是导航，

不是物理路径。

所以这一刀更稳的最小改动仍然是：

- 新增一个 README-only hub
- 不搬原始记忆文件
- 不改编号

这样既能让读者先入家族再分 ingress / permission / blocked-state，

又不会破坏已有引用。

## 这轮具体怎么拆

这轮只做三件事：

1. 新增：
   - `191-206-bridge ingress、permission tail 与 blocked-state 家族/README.md`
2. 在主 `README.md`
   里，
   给“family hub”再补一条入口
3. 新增这条 `390` 记忆，
   记录为什么这轮优先做家族入口，而不是继续 proliferation

这样：

- `191-206` 会从“需要顺时间扫文件名”
  变成“先入 ingress 阅读链，再跳 permission tail，再决定是否去 blocked-state 或专题出口”
- 目录结构会继续复用现有 README-only hub 模式
- 后续如果还要给更窄分支继续加入口，也会有一条统一模板

## 苏格拉底式自审

### 问：为什么这轮不是继续补新的 stable-gray hardening？

答：因为 `222` 已经把这一簇真正缺的“合同厚度”说清了；当前缺的是读者怎么先找到这一簇，而不是再加一层厚度说明。

### 问：为什么这轮不是再画一张 `191-206` 的总图？

答：因为 `197/203/206` 已经把局部结构说清了。再造新图只会制造“是不是还缺一层树形”的错觉。

### 问：为什么仍然不搬原始记忆文件？

答：因为当前最需要优化的是导航，不是物理路径。先加 hub，后谈搬迁，风险更低。
