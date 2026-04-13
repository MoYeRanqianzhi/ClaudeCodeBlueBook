# callback-narrowing contract hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `105`
- `109`

这两张更宽的 root page 先后拉回当前成熟口径之后，

`105-110`

这一支里下一刀最值得优先补的，

不是继续新增 hub，

也不是直接跳去 `110` 或 `116`，

而是回到：

- `108-direct connect 对 summary 的过滤不是消息不存在，而是 callback consumer-path 收窄.md`

把这页从旧式的：

- 当前源码能稳定证明什么
- 当前源码不能稳定证明什么

抬升成：

- `稳定可见`
- `条件公开`
- `内部/灰度层`

三层口径。

## 为什么这轮值得单独提交

### 判断一：`108` 是 `105` visibility ladder 在 direct-connect 这一格里的关键证据页

`105`

已经把：

- core SDK-visible
- stdout/control wire-visible
- terminal-visible
- callback-visible

这些层分开。

而 `108`

正是把其中的 direct-connect callback 这一格单独钉死：

- manager 的过滤证明的是 callback consumer-path narrowing
- 不是 message existence denial

如果这页继续停在旧尾部，

读者就仍会把：

- callback 看不见

误写成：

- wire 上不存在

### 判断二：这轮比先做 `110` 更值，因为 `110` 是比较叶页，`108` 是单 family 的 narrowing 证据页

`110`

当然也仍有价值，

但它回答的是：

- 两个都被 callback 排除的 family，为什么不是同一种 suppress reason

而 `108`

先回答的是：

- 一个具体 family 在 direct connect 里为什么是 callback narrowing，而不是不存在

先把这个更直接的证据页拉回成熟口径，

能为后面的 `110`

提供更稳的前提。

### 判断三：目录结构 ROI 仍然低，继续补正文厚度更值

当前这条线已经同时有：

- `105`
- `108`
- `109`
- `110`
- `111-115`

继续做结构入口，

不会增加 findability，

只会重复导航。

所以这轮结构优化的动作，

仍然不是新增 README，

而是继续减少根页与证据页之间的口径漂移。

## 这轮具体怎么拆

这轮只做三件事：

1. 修改 `108-...callback consumer-path 收窄.md`
   - 把原来的“稳定证明 / 不能稳定证明”改写成
   - `稳定可见`
   - `条件公开`
   - `内部/灰度层`
2. 新增这条 `414` 记忆
   - 记录为什么这轮优先补 `108`，而不是去做 `110` 或继续扩结构
3. 更新 `memory/05 README`
   - 把最新批次索引推进到 `414`

## 苏格拉底式自审

### 问：为什么这轮不是先去做 `110`？

答：因为 `110` 是比较叶页；`108` 先把 single-family callback narrowing 证据压硬，能给后续比较页提供更稳的前提。

### 问：为什么这轮不是直接去做 `116`？

答：因为 `116` 是另一支 completion-signal 线；而 `105-110` 这条可见性支线当前已经连续补到只剩 `108/110` 两个旧尾部，局部收束度更高。

### 问：为什么这也算“优化相关目录结构”？

答：因为结构优化不只等于新增 README。当前让证据页与根页共享同一套分层术语，本身就在减少这条支线里的口径漂移。
