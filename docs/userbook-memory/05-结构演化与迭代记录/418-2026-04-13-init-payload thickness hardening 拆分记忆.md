# init-payload thickness hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `117`

这张 init-visibility root page 拉回当前成熟口径之后，

`117-121`

这一支里更值钱的下一刀，

不是继续新增结构入口，

也不是直接跳去 `121` 的 attach restore 语义，

而是回到：

- `120-buildSystemInitMessage、QueryEngine、useReplBridge、convertInitMessage 与 redaction：为什么 full init payload、bridge redacted init 与 transcript model-only banner 不是同一种 init payload thickness.md`

把这张 payload-thickness root page，

从旧式的：

- 当前源码能稳定证明什么
- 当前源码不能稳定证明什么

抬升成：

- `稳定可见`
- `条件公开`
- `内部/灰度层`

三层口径。

## 为什么这轮值得单独提交

### 判断一：`120` 是 `117` 之后最直接的 payload-thickness root，先补它比先补 `121` 更顺

`117`

先回答：

- same init object != same initialization visibility

而 `120`

继续往下压：

- same init builder != same payload thickness in practice

这两页是同一条 init 支线里最自然的前后关系。

先补 `120`，

就能把：

- full init metadata contract
- bridge redacted init
- transcript model-only banner

这一层厚薄差异先压实，

再去看 `121`

的 attach restore 语义。

### 判断二：当前更值钱的是把 payload thickness 写成稳定对象

这页最容易被误写成：

- 所有宿主其实只是消费同一份 init，只是显示厚薄不同

这轮真正要保住的稳定层是：

- same init builder != same payload thickness in practice

最需要降到条件或灰度层的是：

- build 是否开启 `tengu_bridge_system_init`
- bridge redaction 会不会继续调整
- transcript prompt 会不会永远只保留 model
- exact helper 顺序、field list 与 build wiring

这比继续补新导航，

更直接服务于：

- 保护稳定功能
- 隔离灰度实现

### 判断三：这轮也在继续优化根页与后继页的术语一致性

当前明确不再给这条 init 支线再裂目录，

而是让：

- `117`
- `120`

两张根页共享同一套 stable / conditional / gray 口径，

本质上是在减少这条支线里的术语漂移。

## 这轮具体怎么拆

这轮只做三件事：

1. 修改 `120-...payload thickness.md`
   - 把原来的“稳定证明 / 不能稳定证明”改写成
   - `稳定可见`
   - `条件公开`
   - `内部/灰度层`
2. 新增这条 `418` 记忆
   - 记录为什么这轮优先补 `120`，而不是去做 `121` 或 `119/110`
3. 更新 `memory/05 README`
   - 把最新批次索引推进到 `418`

## 苏格拉底式自审

### 问：为什么这轮不是先去做 `121`？

答：因为 `121` 更像 attach restore semantics 的后继 zoom；若 `120` 这张 payload-thickness root page 还停在旧尾部，`121` 的前提会更松。

### 问：为什么这轮不是先去做 `119` 或 `110`？

答：因为它们当然仍有价值，但 `120` 属于 `117` 刚补完的同一 init 支线，局部连续性更高，且是更直接的根页。

### 问：为什么这也算“优化相关目录结构”？

答：因为结构优化不只等于新增 README。当前让相邻根页共享同一套分层术语，本身就在降低这条支线里的口径漂移。
