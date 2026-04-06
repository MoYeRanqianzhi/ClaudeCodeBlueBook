# shutdown host paths split 拆分记忆

## 本轮继续深入的核心判断

83 页已经说明：

- shutdown family 在 routing 层就不共路

下一步最自然不是再开更细的单对象页，而是换一个角度，专门回答：

- 为什么 interactive `useInboxPoller`
- attachment bridge `attachments.ts`
- headless `print.ts`

都会处理 shutdown 收口，却不是同一条宿主路径。

## 为什么这轮要从“对象分流”转到“宿主分流”

因为如果只讲对象分流，读者仍可能误以为：

- 三条路径只是不同地方复制了同一段 shutdown 逻辑

但更稳的解释是：

- 它们共享 cleanup contract
- 但首先服从各自宿主职责

也就是：

- interactive host
- mid-turn bridge
- headless run loop

## 本轮最关键的新判断

### 判断一：interactive poller 是最重的双栈宿主

它既做 cleanup，也维护本地 inbox 继续投递，还会注入 `teammate_terminated`。

### 判断二：attachment path 不是第二个 poller

它的首要职责是当前回合桥接 unread mailbox 与 `pending` inbox，并把中途送达过的 pending 标成 `processed`。

### 判断三：headless print 不是没有 UI 的 poller

它会做 approved cleanup，但它推进的是：

- enqueue / run

而不是：

- REPL-local inbox `pending/processed`

### 判断四：`teammate_terminated` 更适合被写成 interactive host 的本地一致性影子

它不是 shutdown cleanup 的普适输出，也不是三条路径都必须构造的对象。

## 为什么这轮不去写 termination family 三层总图

这是 83 页留下的候选之一，但现在更值钱的是先把：

- shared cleanup contract != shared host path

这条判断钉死。

如果不先写 84，后面即使画三层总图，读者也仍会把 attachment 和 print 误认为“只是 poller 的变体”。

## 苏格拉底式自审

### 问：为什么这轮不直接比较更多 headless / interactive 全局差异？

答：因为本轮主轴必须仍然是 shutdown 收口。只要离开 shutdown，就容易从连续的 81-84 链条上跳题。

### 问：为什么 `SHUTDOWN_TEAM_PROMPT` 只能作为条件层，而不是正文核心？

答：因为它说明 print 的 run-loop 宿主目标不同，但不是三条路径最稳定的共同边界。最稳定的仍然是：谁拥有本地 inbox 状态机，谁只是 bridge，谁直接推进 enqueue/run。

### 问：为什么 84 值得单独成文，而不是只在 83 末尾加一节？

答：因为 83 的主角是对象路由；84 的主角是宿主路由。一个按对象分层，一个按宿主分层，问题不同，读者误判点也不同。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/84-useInboxPoller、attachments、print、shutdown_approved、teammate_terminated 与 pending-processing：为什么 interactive、attachment bridge 与 headless print 不共享同一条 shutdown 收口宿主路径.md`
- `bluebook/userbook/03-参考索引/02-能力边界/73-Shutdown host-path convergence and divergence 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/84-2026-04-06-shutdown host paths split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小改动：

- 长文层只补 84
- 索引层只补 73
- 记忆层只补 84

不把 81-84 重新揉成一篇 termination 大总论。

## 下一轮候选

1. 把 81-84 压成一张 termination family 四层导航图：family、visible surfaces、routing split、host paths。
2. 单独拆 in-process teammate 的 `shutdownRequested`、`awaitingPlanApproval`、`idle` 三种状态投影。
3. 单独拆 headless `print` 的 shutdown prompt、team drain 与 active teammate 收口。
