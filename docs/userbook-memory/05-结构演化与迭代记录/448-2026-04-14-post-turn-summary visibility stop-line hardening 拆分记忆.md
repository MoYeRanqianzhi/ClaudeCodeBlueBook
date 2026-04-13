# post-turn-summary visibility stop-line hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `137` 的 cross-frontend consumer stop-line
- `216` 的 remote-truth skeleton
- `140` 在结构图里的位置固定成 `137` 之后的 visibility zoom

补齐之后，

当前更值钱的下一刀，

不是继续回头扩新的 README / hub，

也不是重写 `137` 或 `216`，

而是回到：

- `140-SDKPostTurnSummaryMessageSchema、StdoutMessageSchema、SDKMessageSchema、print.ts 与 directConnectManager：为什么 post_turn_summary 的 wide-wire、@internal 与 foreground narrowing 不是同一种可见性.md`

给这张 leaf 页自己补硬 stop-line 与显式结论。

这轮还顺手修掉了一处我上一刀写进 `125` 页尾的重复残留句，不改变那页主结论。

## 为什么这轮值得单独提交

### 判断一：`140` 的主结论比结构页更窄，但仍缺一个“到此为止”的页尾落点

`140`

正文主体已经成立：

- 它不是 `105` 的重复
- 它不是 `108` 的重复
- 它已经把 `post_turn_summary` 拆成 schema / stdout wire / core SDK / callback / terminal semantics 的 visibility ladder

但页尾还停在旧式：

- `stable / conditional / internal`

没有：

- `所以这页最稳的结论必须停在`
- `## 结论`

这就会让读者继续把它误听成：

- “`@internal` 和 foreground narrowing 本质上只是同一层不可见性”

### 判断二：这页该停在 visibility，不该滑去 consumer attribution 或 remote truth

`137`

已经回答：

- 哪个 frontend 在被暗示为 consumer

`216`

已经回答：

- `140` 只是 `137` 之后的 visibility zoom

所以 `140` 自己最该补的一句不是再解释结构关系，

而是把页内边界说死：

- 它只裁定可见性梯子
- 不推进到 consumer attribution
- 不推进到 remote-truth judgement

### 判断三：这轮仍在优化目录结构，只是优化的是 leaf 页在 skeleton 下的停笔边界

当前目录层已经足够清楚：

- `137` 先定 consumer path
- `140` 再压 visibility ladder
- `216` 把它放回 remote-truth 骨架里的正确位置

所以这轮继续优化“相关目录结构”，

更稳的做法不是再加入口，

而是把：

- `140` 自己的页尾边界

写硬。

## 这轮具体怎么拆

这轮只做四件事：

1. 把 `140` 的尾部标题从：
   - `stable / conditional / internal`
   改成：
   - `稳定层、条件层与灰度层`
2. 在尾部补一条 stop-line：
   - 明确它只裁定 visibility ladder
   - 不把它写成当前 CLI foreground 主合同
3. 在自审后补 `## 结论`
   - 明确 schema、stdout wire、core SDK、foreground narrowing 四层的关系
4. 顺手删掉 `125` 页尾重复残留的自审句

## 苏格拉底式自审

### 问：为什么这轮不是继续补 `123 / 124`？

答：因为 recovery 叶页当前更硬，且 `125` 已先把更软的 transport action-state 路径补了 stop-line。现在更值得补的是 `140` 这种 visibility-ladder 页的页尾收束。

### 问：为什么这轮不是继续补 `137`？

答：因为 `137` 的 stop-line 与显式结论已经补上。当前更该补的是它后面的 `140`，让 `137 -> 140` 这条线在 leaf 层也形成统一停笔方式。

### 问：为什么这也算“优化相关目录结构”？

答：因为 leaf 页并不只是正文细节；它还是结构骨架下的最终落点。把 `140` 的停笔边界写硬，本质上是在减少 `137 -> 140 -> 216` 这条线里的越层串写。
