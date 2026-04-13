# init-visibility root hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `116`

这张 completion-signal root page 拉回当前成熟口径之后，

`117-119`

这一支里最值得优先补的，

不是继续新增结构入口，

也不是直接跳去 `118/119`，

而是回到：

- `117-buildSystemInitMessage、SDKSystemMessage(init)、useDirectConnect 去重、convertInitMessage 与 onInit：为什么 callback-visible init、transcript init 提示与 slash bootstrap 不是同一种初始化可见性.md`

把这张 initialization root page 自己从旧式的：

- 当前源码能稳定证明什么
- 当前源码不能稳定证明什么

抬升成：

- `稳定可见`
- `条件公开`
- `内部/灰度层`

三层口径。

## 为什么这轮值得单独提交

### 判断一：`117` 是 initialization visibility 支线的根页，先补根页比先补后继页更值

`117`

回答的是：

- callback-visible init
- transcript init 提示
- slash bootstrap
- host-local dedupe

为什么都围绕同一个 init object，

却不是同一种初始化可见性。

既然它是这条支线的 root page，

那它如果继续停在“能证明 / 不能证明”的旧尾部，

读者就会把：

- `118`
- `119`

这些后继页，

误看成各自独立的局部机制，

而不是同一根页向外压出的不同 zoom。

### 判断二：当前更值钱的是把 “same init object != same initialization visibility” 写成稳定对象

这页最容易被误写成：

- 所有宿主其实共享同一套 init contract，只是显示样式不同

这轮真正要保住的稳定层是：

- same init object != same initialization visibility

最需要降到条件或灰度层的是：

- 哪些宿主会把 init 当 bootstrap
- attach/replay 是否会恢复相同副作用
- REPL bridge 的 gated/redacted init 是否在所有 build 生效
- exact helper 顺序与 host wiring

这比继续补导航，

更直接服务于：

- 保护稳定功能
- 隔离灰度实现

### 判断三：这轮也在继续优化根页与后继页的术语一致性

当前明确不再给 `117-119` 再裂目录，

而是让：

- `116`
  这张完成信号根页
- `117`
  这张初始化可见性根页

共享同一套 stable / conditional / gray 口径，

本质上是在减少这段 direct-connect 支线里的术语漂移。

## 这轮具体怎么拆

这轮只做三件事：

1. 修改 `117-...初始化可见性.md`
   - 把原来的“稳定证明 / 不能稳定证明”改写成
   - `稳定可见`
   - `条件公开`
   - `内部/灰度层`
2. 新增这条 `416` 记忆
   - 记录为什么这轮优先补 `117`，而不是去做 `110` 或 `118/119`
3. 更新 `memory/05 README`
   - 把最新批次索引推进到 `416`

## 苏格拉底式自审

### 问：为什么这轮不是先去做 `110`？

答：因为 `110` 当然仍有价值，但 `117` 属于 `116-119` 这条已经显出根页结构的后继支线。先把 `117` 这张根页口径统一，能给 `118/119` 提供更稳的上游锚点。

### 问：为什么这轮不是直接去改 `118/119`？

答：因为它们更像 replay dedup / loading lifecycle 的后继 zoom；若 `117` 还停在旧口径，这条 initialization 支线就缺根页参照。

### 问：为什么这也算“优化相关目录结构”？

答：因为结构优化不只等于新增 README。当前让根页和后继页共享同一套分层术语，本身就在降低支线里的口径漂移。
