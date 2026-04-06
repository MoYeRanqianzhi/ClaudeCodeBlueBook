# standalone remote-control 显示面拆分记忆

## 本轮继续深入的核心判断

第 26 页已经拆开：

- connect URL
- session URL
- environment / session ID

第 31 页已经拆开：

- active
- reconnecting
- 动作上限

第 37 页已经拆开：

- spawn topology
- capacity
- cwd anchor

但 standalone host 还缺一层非常容易继续混写的显示面语义：

- banner
- lifecycle status line
- session count / mode line
- session list
- QR / footer
- `space` / `w` hint

如果不单独补这一批，正文会继续犯六种错：

- 把 banner 写成当前状态
- 把 `Ready` 与 `Connected` 写成同一层
- 把 `Capacity: x/y` 写成状态词的一部分
- 把 session list 写成状态行的延长
- 把 QR / footer 写成状态重复展示
- 把 `space` / `w` 写成状态本体

## 苏格拉底式自审

### 问：为什么这批不能塞回第 26 页？

答：第 26 页解决的是：

- 链接和二维码到底指向哪个对象

而本轮问题已经换成：

- 这些对象是如何被投影成不同显示面，并在不同状态下切换

也就是从：

- action target identity

继续下钻到：

- display surface partition

所以需要新起一页。

### 问：为什么这批也不能塞回第 31 页？

答：第 31 页解决的是：

- 状态词
- 恢复厚度
- 动作上限

而本轮更偏：

- 除了状态词之外，还有哪些行其实根本不在描述同一件事

也就是：

- state label

之后的：

- full display surface

所以不能再混回 31。

### 问：这批最该防的偷换是什么？

答：

- state = surface
- session count = state
- QR target = state
- hint = state

只要这四组没拆开，standalone host 正文就还会继续糊。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/38-Bridge Banner、QR、footer、session count 与 session list：为什么 standalone remote-control 的 banner、状态行与会话列表不是同一种显示面.md`
- `bluebook/userbook/03-参考索引/02-能力边界/27-Remote Control banner、QR、footer 与 session list 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/38-2026-04-06-standalone remote-control 显示面拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- banner 是 bootstrap fact surface
- `Ready` / `Connected` / `Reconnecting` / `Failed` 是 lifecycle surface
- session count 与 mode line 是 host budget projection
- session list 是 session object projection
- QR / footer 是 action-target surface
- `space` / `w` 是 interaction hint surface

### 不应写进正文的

- shimmer animation
- visual line counting
- OSC8 hyperlink 封装
- ticker 刷新机制

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `printBanner()` 最大的风险是被误写成状态面

它打印：

- version
- spawn mode
- environment ID
- sandbox

然后才开启 connecting spinner。

所以 reader 正文必须坚持：

- banner 先说 host facts
- 不是当前连接状态

### `setAttached()` 与 `updateIdleStatus()` 同时改变状态词和 action target

这意味着：

- “状态字” 与 “QR / footer 指向什么” 不是两套独立无关的东西
- 但它们也不是同一张面

正文应写“联动但不等同”，不能把二者写成单一 connected state。

### session list 的关键不是列表本身，而是异步补 title

`addSession()` 先注册 URL，`setSessionTitle()` 后补标题。

这说明 session list 展示的是 evolving object projection，而不是一次性静态状态行。

### single-session 与 multi-session 不只影响二维码，也影响整张显示面的结构

- single-session：mode line + tool summary
- multi-session：capacity line + session bullet list

如果只写二维码切换，正文就仍然不够完整。

## 并行 agent 结果

本轮并行 agent 主要用于核查：

- 这批是否会与 26、31、37 重复
- single vs multi-session 投影是否足够支撑独立页面

返回结论若只是在强化现有判断，不回灌正文，只沉到 memory。

## 后续继续深入时的检查问题

1. 我现在拆的是链接对象，还是显示面对象？
2. 这行内容是在说 host lifecycle，还是 session object？
3. 这部分是在告诉用户系统状态，还是下一步动作？
4. 我是不是又把 QR / footer 当成状态词的另一种写法？
5. 我是不是又让 shimmer / ticker 细节污染了正文？

只要这五问没先答清，下一页继续深入就会重新滑回：

- 状态与显示面混写
- 或 UI 实现细节回流正文

而不是用户真正可用的 standalone host 显示面正文。
