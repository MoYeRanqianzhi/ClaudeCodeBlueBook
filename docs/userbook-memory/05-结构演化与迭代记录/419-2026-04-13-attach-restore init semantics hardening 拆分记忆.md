# attach-restore init semantics hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `117`
- `120`

这条 init 支线的两个根页先后拉回当前成熟口径之后，

下一刀更值钱的，

不是去横跳 `119` 或回收 `110`，

而是回到：

- `121-useAssistantHistory、fetchLatestEvents(anchor_to_latest)、pageToMessages、useRemoteSession onInit 与 handleRemoteInit：为什么 history init banner 回放与 live slash 恢复不是同一种 attach 恢复语义.md`

把这张 attach-restore 语义页，

从旧式的：

- 当前源码能稳定证明什么
- 当前源码不能稳定证明什么

抬升成：

- `稳定可见`
- `条件公开`
- `内部/灰度层`

三层口径。

## 为什么这轮值得单独提交

### 判断一：`121` 是 `120` 之后最直接的 restore-semantics 后继页，顺着 init 支线补最值

`120`

先回答：

- same init builder != same payload thickness in practice

而 `121`

继续回答：

- same init trace != same attach restore semantics

这两页是同一条 init 支线里最自然的前后顺序：

- 先分 payload thickness
- 再分 attach restore 语义

先补 `121`，

能把这条线从 object thickness 继续推到 consumer semantics。

### 判断二：当前更值钱的是把 attach restore 语义写成稳定对象

这页最容易被误写成：

- attach 基本就等于把 live init 的副作用全补跑一遍

这轮真正要保住的稳定层是：

- same init trace != same attach restore semantics

最需要降到条件或灰度层的是：

- history replay 是否应补跑 bootstrap side effect
- attach 时 live init 是否一定再到一次
- metadata hydration 是否会改变当前结论
- exact helper 顺序与 host wiring

这比继续补新导航，

更直接服务于：

- 保护稳定功能
- 隔离灰度实现

### 判断三：这轮也在继续优化 init 支线内部的术语一致性

当前明确不再给这条线再裂目录，

而是让：

- `117`
- `120`
- `121`

继续共享 stable / conditional / gray 口径。

这本身就是在减少局部支线里的术语漂移。

## 这轮具体怎么拆

这轮只做三件事：

1. 修改 `121-...attach 恢复语义.md`
   - 把原来的“稳定证明 / 不能稳定证明”改写成
   - `稳定可见`
   - `条件公开`
   - `内部/灰度层`
2. 新增这条 `419` 记忆
   - 记录为什么这轮优先补 `121`，而不是去做 `119/110`
3. 更新 `memory/05 README`
   - 把最新批次索引推进到 `419`

## 苏格拉底式自审

### 问：为什么这轮不是先去做 `119`？

答：因为 `119` 当然仍有价值，但它属于 `116` 的 loading lifecycle 叶页；`121` 则直接承接刚补完的 `120`，局部顺序收益更高。

### 问：为什么这轮不是回头先收 `110`？

答：因为 `110` 是另一条较早的可见性支线。当前 init 支线已经连续补到 `117/120`，继续把 `121` 收上去，更能保持局部递进的一致性。

### 问：为什么这也算“优化相关目录结构”？

答：因为结构优化不只等于新增 README。当前让同一支线上的根页与后继页共享同一套分层术语，本身就在降低目录系统里的口径漂移。
