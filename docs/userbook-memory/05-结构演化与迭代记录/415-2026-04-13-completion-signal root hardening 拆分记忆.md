# completion-signal root hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `114`
- `115`

这条 direct-connect callback / adapter 支线的 stable / conditional / gray 口径统一起来之后，

`116-119`

这一支里最值得优先补的，

不是继续新增结构入口，

也不是直接去改 `117/118/119` 这些后继页，

而是回到：

- `116-success result ignored、error result visible、isSessionEndMessage、setIsLoading(false) 与 permission pause：为什么 direct connect 的 visible result、turn-end 判定与 busy state 不是同一种 completion signal.md`

把这张 root page 自己从旧式的：

- 当前源码能稳定证明什么
- 当前源码不能稳定证明什么

抬升成：

- `稳定可见`
- `条件公开`
- `内部/灰度层`

三层口径。

## 为什么这轮值得单独提交

### 判断一：`116` 是 completion-signal 支线的根页，先补根页比先补后继页更值

`116`

回答的是：

- transcript-visible outcome
- turn-end classifier
- busy-state transition

为什么都和“完成”有关，

却不是同一种 completion signal。

既然它是这条线的 root page，

那它如果继续停在“能证明 / 不能证明”的旧尾部，

读者就会把：

- `117`
- `118`
- `119`

这些相邻后继页，

误看成各自独立的 completion 细枝，

而不是同一根页往外压出的不同 zoom。

### 判断二：当前更值钱的是把 “same result family != same completion semantics” 写成稳定对象

这页最容易被误写成：

- direct connect 其实只有一个 authoritative completion signal

这轮真正要保住的稳定层是：

- same result family != same completion semantics

最需要降到条件或灰度层的是：

- 宿主是否共享同一 busy-state machine
- `isSessionEndMessage(...)` 将来会不会收细
- 其他 UI consumer 会不会给 success `result` 再加可见壳
- exact helper 顺序与 host wiring

这比继续新增导航，

更直接服务于：

- 保护稳定功能
- 隔离灰度实现

### 判断三：这轮也在继续优化根页与叶页的术语一致性

当前明确不再给 `116-119` 再裂目录，

而是让：

- `114/115` 这组成熟页
- `116` 这张根页

共享同一套 stable / conditional / gray 口径，

本质上是在减少这条支线里的术语漂移。

## 这轮具体怎么拆

这轮只做三件事：

1. 修改 `116-...completion signal.md`
   - 把原来的“稳定证明 / 不能稳定证明”改写成
   - `稳定可见`
   - `条件公开`
   - `内部/灰度层`
2. 新增这条 `415` 记忆
   - 记录为什么这轮优先补 `116`，而不是去做 `110` 或 `117-119`
3. 更新 `memory/05 README`
   - 把最新批次索引推进到 `415`

## 苏格拉底式自审

### 问：为什么这轮不是先去做 `110`？

答：因为 `110` 当然仍有价值，但 `116` 是另一条更完整支线的根页，而且 `117/118/119` 也都还停在旧尾部。先把根页口径统一，收益更高。

### 问：为什么这轮不是直接去改 `117/118/119`？

答：因为这些页更像后继 zoom；若 `116` 这张根页仍停在旧口径，后继页再成熟也会缺上游锚点。

### 问：为什么这也算“优化相关目录结构”？

答：因为结构优化不只等于新增 README。当前让根页和后继页共享同一套分层术语，本身就在降低支线里的口径漂移。
