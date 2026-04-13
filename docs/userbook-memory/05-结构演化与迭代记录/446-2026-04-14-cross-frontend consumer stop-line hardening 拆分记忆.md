# cross-frontend consumer stop-line hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `212-217` 这一串结构页的 skeleton 收束
- `133 -> 137` 这条分支在 `215` 中的结构定位
- `133` 的字段级 producer / store / restore / consumer 分离

补齐之后，

当前更值钱的下一刀，

不是继续回头扩新的 README / hub，

也不是重写 `133`、`140` 这种相邻页，

而是回到：

- `137-pending_action.input、task_summary、post_turn_summary、externalMetadataToAppState、print.ts 与 directConnectManager：为什么“frontend 会读”更像跨前端 consumer path，而不是当前 CLI foreground contract.md`

给这张 leaf 页自己补硬 stop-line 与显式结论。

## 为什么这轮值得单独提交

### 判断一：`137` 的主结论比相邻页更依赖“reader 缺席 + 注释语义”的负证据组合

`133`

的根句更偏：

- definition / store / restore / consumer 四层分离

`140`

的根句更偏：

- visibility ladder

而 `137`

最核心的判断是：

- 注释里写 “frontend 会读”
- 但当前 CLI foreground 没有 reader
- 所以更稳的主语是跨前端 consumer path

这条结论天然更依赖：

- reader 缺席
- active narrowing
- 非当前 CLI 的解释性推断

所以比相邻页更值得先补一条 stop-line，把过度外推切死。

### 判断二：当前缺口不在正文主体，而在它还没把“到此为止”说成一句

`137`

正文主体已经成立：

- 它不是 `133` 的重复
- 它不是 `140` 的 visibility ladder
- 它已经把“frontend 会读”压成 cross-frontend consumer path

但页尾还停在旧式：

- `stable / conditional / internal`

没有：

- `所以这页最稳的结论必须停在`
- `## 结论`

这就会让读者继续把它误听成：

- “CLI 只是暂时还没把 UI 做出来”

### 判断三：这轮仍在优化目录结构，只是优化的是 leaf 页在结构骨架下的停笔边界

当前目录层已经足够清楚：

- `215` 先定 `133 -> 137`
- `133` 讲字段级分离
- `137` 讲哪个 frontend 在被暗示为 consumer

所以这轮继续优化“相关目录结构”，

更稳的做法不是再加入口，

而是把：

- leaf 页自己的停笔边界

写硬。

## 这轮具体怎么拆

这轮只做三件事：

1. 把 `137` 的尾部标题从：
   - `stable / conditional / internal`
   改成：
   - `稳定层、条件层与灰度层`
2. 在尾部补一条 stop-line：
   - 明确 “frontend 会读” 当前更像跨前端 consumer path
   - 不把它写成当前 CLI foreground contract
3. 在自审后补 `## 结论`
   - 明确 `pending_action.input`
   - `task_summary`
   - `post_turn_summary`
   三者各自怎样支撑 cross-frontend consumer path

## 苏格拉底式自审

### 问：为什么这轮不是继续补 `140`？

答：因为 `140` 的 visibility-ladder 主语更硬，主要问题是模板旧；而 `137` 的主结论更依赖负证据，优先补它的 stop-line 收益更高。

### 问：为什么这轮不是继续回头补 recovery 叶页？

答：因为 `122-127` 刚被 `212/213` 收紧成统一骨架。当前更该补的是 `133 -> 137` 这条 consumer-boundary 分支里最软的一张 leaf。

### 问：为什么这也算“优化相关目录结构”？

答：因为 leaf 页并不只是正文细节；它还是结构骨架下的最终落点。把 `137` 的停笔边界写硬，本质上是在减少结构骨架下的越层串写。
