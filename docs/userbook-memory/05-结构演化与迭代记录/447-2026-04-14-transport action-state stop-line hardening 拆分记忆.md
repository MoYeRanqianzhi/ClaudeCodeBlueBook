# transport action-state stop-line hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `212 / 213` 这一段 recovery 结构页统一成 skeleton 口径
- `125` 在 recovery 分支里的位置固定成 transport authority / action-state leaf
- `137` 这类 soft-evidence leaf 的停笔边界补硬

之后，

当前更值钱的下一刀，

不是继续扩新的 README / hub，

也不是同时重写 `123 / 124 / 140`，

而是回到：

- `125-handleClose、scheduleReconnect、reconnect()、onReconnecting 与 onClose：为什么 transport recovery action-state contract 不是同一种状态.md`

给这张 leaf 页自己补硬 stop-line 与显式结论。

## 为什么这轮值得单独提交

### 判断一：`125` 的主结论比相邻 recovery leaf 更依赖实现路径推断

`123`

更像：

- ownership contract

`124`

更像：

- signer ceiling / proof contract

而 `125`

最关键的判断是：

- `scheduleReconnect(...)` 才会自然走到 `onReconnecting()`
- `reconnect()` 是 force reconnect action
- timeout warning 后不保证共享状态面已经先投成 `reconnecting`

这条结论天然更依赖：

- 当前实现 path
- early-return 顺序
- path-specific projection

所以更值得先补一条 stop-line，把“实现路径推断”稳稳压回条件层。

### 判断二：当前缺口不在正文主体，而在它还没把“到此为止”说成一句

`125`

正文主体已经成立：

- 它不是 `122` 的 lifecycle 页
- 它不是 `124` 的 signer 页
- 它已经把 close-driven backoff、force reconnect、terminal projection 拆开

但页尾还停在旧式：

- `stable / conditional / internal`

没有：

- `所以这页最稳的结论必须停在`
- `## 结论`

这就会让读者继续把它误听成：

- “transport 底层就是一条 reconnecting 状态机”

### 判断三：这轮仍在优化目录结构，只是优化的是 recovery 骨架下 leaf 页的停笔边界

当前目录层已经足够清楚：

- `212 / 213` 先定 recovery 双根 + 双主干 + zoom
- `125` 再落到 transport action-state contract

所以这轮继续优化“相关目录结构”，

更稳的做法不是再加入口，

而是把：

- leaf 页自己的停笔边界

写硬。

## 这轮具体怎么拆

这轮只做三件事：

1. 保留 `125` 现有正文主干不动
2. 在三层分账后补一条 stop-line：
   - 明确 `scheduleReconnect(...)`、`reconnect()`、`onReconnecting`、`onClose`、`onDisconnected` 不是同一种 action-state contract
   - 不把 timeout warning 后的 UI 变化写成必然共享状态
3. 在自审后补 `## 结论`
   - 明确 close-driven backoff
   - force reconnect
   - terminal projection
   三者的关系

## 苏格拉底式自审

### 问：为什么这轮不是先补 `140`？

答：因为 `140` 的 visibility-ladder 主语更硬，主要问题还是模板旧；`125` 的 stop-line 更依赖实现路径推断，优先补它收益更高。

### 问：为什么这轮不是同时补 `123 / 124`？

答：因为 `123 / 124` 的 ownership / signer 边界已经更硬。当前更软的是 `125` 这种 authority-path 叶页还没把“只能停到哪一步”明确写死。

### 问：为什么这也算“优化相关目录结构”？

答：因为 leaf 页是结构骨架下的最终落点。把 `125` 的停笔边界写硬，本质上是在减少 recovery 骨架下的越层串写。
