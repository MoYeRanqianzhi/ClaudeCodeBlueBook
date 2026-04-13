# loading-lifecycle branch hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `116`
- `117`
- `118`
- `120`
- `121`

这些相邻 root / branch page 依次拉回当前成熟口径之后，

这条 direct-connect 支线里下一刀更值钱的，

不是回头横跳去 `110`，

而是回到：

- `119-sendMessage、onPermissionRequest、onAllow、result、cancelRequest 与 onDisconnected：为什么 direct connect 的 setIsLoading(true_false) 不是同一种 loading lifecycle.md`

把这张 loading-lifecycle branch page，

从旧式的：

- 当前源码能稳定证明什么
- 当前源码不能稳定证明什么

抬升成：

- `稳定可见`
- `条件公开`
- `内部/灰度层`

三层口径。

## 为什么这轮值得单独提交

### 判断一：`119` 是 `116` completion-signal root 下最直接的 busy-state zoom

`116`

先回答：

- same result family != same completion semantics

而 `119`

继续往下压：

- same loading flag write != same lifecycle meaning

这两页是同一条 completion / waiting 支线里最自然的前后顺序。

先补 `119`，

能把：

- turn-end / transcript outcome
- busy-state transition
- loading edge family

这条线补成更完整的两步收束。

### 判断二：当前更值钱的是把 loading lifecycle 写成稳定对象

这页最容易被误写成：

- direct connect 其实只有一个 authoritative loading state machine

这轮真正要保住的稳定层是：

- same loading flag write != same lifecycle meaning

最需要降到条件或灰度层的是：

- remote host 是否共享同一 lifecycle
- `loading` 是否被更高层 source 合并覆写
- timeout/reconnect 等 future edge 是否会加入
- exact helper 顺序与 hook wiring

这比继续补新导航，

更直接服务于：

- 保护稳定功能
- 隔离灰度实现

### 判断三：这轮也在继续优化同支线根页与后继页的术语一致性

当前明确不再给这条线再裂目录，

而是让：

- `116`
- `119`

继续共享 stable / conditional / gray 口径，

本质上是在减少局部支线里的术语漂移。

## 这轮具体怎么拆

这轮只做三件事：

1. 修改 `119-...loading lifecycle.md`
   - 把原来的“稳定证明 / 不能稳定证明”改写成
   - `稳定可见`
   - `条件公开`
   - `内部/灰度层`
2. 新增这条 `420` 记忆
   - 记录为什么这轮优先补 `119`，而不是回头去做 `110`
3. 更新 `memory/05 README`
   - 把最新批次索引推进到 `420`

## 苏格拉底式自审

### 问：为什么这轮不是先去做 `110`？

答：因为 `110` 当然仍有价值，但它属于另一条可见性支线。当前 `116-121` 这一条 direct-connect 支线已经连续补到只剩 `119` 这一张 loading branch 还停在旧口径，局部顺序收益更高。

### 问：为什么这轮不是继续去做新的 hub？

答：因为当前瓶颈仍然不是入口缺口，而是正文边界厚度。继续新增 README 只会重复导航，不会增加 loading lifecycle 的合同清晰度。

### 问：为什么这也算“优化相关目录结构”？

答：因为结构优化不只等于新增 README。当前让同支线的根页和后继页继续共享同一套分层术语，本身就在降低目录系统里的口径漂移。
