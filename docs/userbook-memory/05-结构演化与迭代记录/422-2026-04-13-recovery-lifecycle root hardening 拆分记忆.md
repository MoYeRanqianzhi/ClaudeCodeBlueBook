# recovery-lifecycle root hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `108`
- `109`
- `110`
- `116`
- `117`
- `118`
- `119`
- `120`
- `121`

这些相邻 root / branch page 逐步拉回当前成熟口径之后，

更值钱的下一刀，

不是继续在 direct-connect / init 这一簇里横向补页，

而是转到：

- `122-timeout watchdog、reconnect warning、reconnecting 与 disconnected：为什么 remote session 的 recovery lifecycle 不是同一种状态.md`

把这张 remote recovery 叶根页，

从旧式的：

- 当前源码能稳定证明什么
- 当前源码不能稳定证明什么

抬升成：

- `稳定可见`
- `条件公开`
- `内部/灰度层`

三层口径。

## 为什么这轮值得单独提交

### 判断一：`122` 是 recovery 线里最直接的叶根页，补它比横跳 193/203 更顺

`122`

回答的是：

- timeout watchdog
- reconnect warning
- reconnecting state
- disconnected state

为什么都围绕 recovery，

却不是同一种 lifecycle edge。

这和刚补完的：

- `119` loading lifecycle

在形式上相似，

但问题域已经切到 remote recovery 线。

先把 `122`

补成新口径，

能把 recovery 线的 leaf root 也拉回当前统一的收束纪律。

### 判断二：当前更值钱的是把 “same recovery episode != same lifecycle edge” 写成稳定对象

这页最容易被误写成：

- remote session 其实只有一种 reconnect state

这轮真正要保住的稳定层是：

- same recovery episode != same lifecycle edge

最需要降到条件或灰度层的是：

- reconnect 是否最终成功
- 所有 host 是否共享同一 recovery edge family
- future build 是否会细分 reconnecting
- timeout / heartbeat / compaction / viewerOnly 的 exact wiring

这比继续补新导航，

更直接服务于：

- 保护稳定功能
- 隔离灰度实现

### 判断三：这轮也在继续优化跨支线但同构 root 页的术语一致性

当前没有继续新增目录，

而是让：

- `119`
  的 loading lifecycle branch
- `122`
  的 recovery lifecycle root

继续共享 stable / conditional / gray 口径。

这本身就是在减少跨支线的命名漂移。

## 这轮具体怎么拆

这轮只做三件事：

1. 修改 `122-...recovery lifecycle.md`
   - 把原来的“稳定证明 / 不能稳定证明”改写成
   - `稳定可见`
   - `条件公开`
   - `内部/灰度层`
2. 新增这条 `422` 记忆
   - 记录为什么这轮优先补 `122`，而不是继续横跳 `193/203`
3. 更新 `memory/05 README`
   - 把最新批次索引推进到 `422`

## 苏格拉底式自审

### 问：为什么这轮不是继续去做 `193/203`？

答：因为那条 bridge/control 线当前已经至少有结构化三层口径；相反，`122` 仍停在旧式“能稳定证明/不能稳定证明”的尾部，且是 recovery 线更直接的叶根页。

### 问：为什么这轮不是继续待在 `116-121` 那条 direct-connect 支线？

答：因为那一簇刚被连续补到 `121`，局部已经形成较完整的连续口径；此时转去 `122`，比在同一簇里继续横跳更平衡。

### 问：为什么这也算“优化相关目录结构”？

答：因为结构优化不只等于新增 README。当前让不同支线的同构 root page 共享同一套分层术语，本身就在降低全局目录系统里的口径漂移。
