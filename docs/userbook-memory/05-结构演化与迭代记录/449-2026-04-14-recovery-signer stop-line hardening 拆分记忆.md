# recovery-signer stop-line hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `212 / 213` 这一段 recovery 结构页统一成 skeleton 口径
- `125` 的 transport action-state stop-line
- `137 / 140` 这条 consumer / visibility 分支的 leaf 停笔边界

补齐之后，

当前更值钱的下一刀，

不是继续扩新的 README / hub，

也不是同时重写 `123 / 125`，

而是回到：

- `124-warning、连接态、force reconnect 与 viewerOnly：为什么 recovery signer 不是同一种恢复证明.md`

给这张 leaf 页自己补硬 stop-line 与显式结论。

## 为什么这轮值得单独提交

### 判断一：`124` 的主结论比 `123` 更依赖 absence semantics 与条件性 signer 区分

`123`

更像：

- ownership contract

而 `124`

最关键的判断是：

- warning 是 prompt signer
- `remoteConnectionStatus` 是 shared authority projection
- `reconnect()` 是 action edge
- brief / footer / remote pill 的缺席不等于 opposite proof

这条结论天然更依赖：

- absence semantics
- mode-conditioned visibility
- family split

所以更值得先补一条 stop-line，把过度外推切死。

### 判断二：当前缺口不在正文主体，而在它还没把“到此为止”说成一句

`124`

正文主体已经成立：

- 它不是 `122` 的 lifecycle 页
- 它不是 `123` 的 ownership 页
- 它也不是 `125` 的 transport action-state 页

但页尾还停在旧式：

- `stable / conditional / internal`

没有：

- `所以这页最稳的结论必须停在`
- `## 结论`

这就会让读者继续把它误听成：

- “任何恢复相关 signal 都在共同证明同一个 recovery 真相”

### 判断三：这轮仍在优化目录结构，只是优化的是 recovery 骨架下 signer leaf 的停笔边界

当前目录层已经足够清楚：

- `122` 讲 owner-side recovery lifecycle
- `123` 讲 ownership contract
- `124` 讲 recovery signer ceiling
- `125` 讲 transport action-state contract

所以这轮继续优化“相关目录结构”，

更稳的做法不是再加入口，

而是把：

- leaf 页自己的停笔边界

写硬。

## 这轮具体怎么拆

这轮只做三件事：

1. 保留 `124` 现有正文主干不动
2. 在三层分账后补一条 stop-line：
   - 明确 warning、`remoteConnectionStatus`、`reconnect()`、brief 与 absence 不是同一种 recovery signer
   - 不把任何缺席写成 opposite proof
3. 在自审后补 `## 结论`
   - 明确 prompt
   - durable authority
   - action edge
   - projection / absence semantics
   四者的关系

## 苏格拉底式自审

### 问：为什么这轮不是先补 `123`？

答：因为 `123` 的 ownership-contract 主语更硬，主要问题还是模板旧；`124` 的 signer ceiling 更依赖 absence semantics，优先补它的 stop-line 收益更高。

### 问：为什么这轮不是继续补 `140`？

答：因为 `140` 的 visibility-ladder 已经刚补完 stop-line 与结论。当前 recovery 这簇里更软的是 `124` 这种 signer 页。

### 问：为什么这也算“优化相关目录结构”？

答：因为 leaf 页是结构骨架下的最终落点。把 `124` 的停笔边界写硬，本质上是在减少 `122 / 123 / 124 / 125` 之间的越层串写。
