# in-process teammate state projection 拆分记忆

## 本轮继续深入的核心判断

84 页已经把 shutdown 这条线压到宿主路径层了。

下一步如果继续稳定扩展，最自然不是再留在 shutdown transport，而是换一个更一般的角度：

- in-process teammate 的状态投影

因为 81-84 虽然都围绕 shutdown 展开，但真正反复出现的底层机制其实是：

- `status`
- `shutdownRequested`
- `awaitingPlanApproval`
- `isIdle`

这几层状态被不同消费者压成不同脸。

## 为什么这轮要从 shutdown family 转到状态投影

因为如果不单独写这页，读者会继续把很多现象误解成 shutdown 专属：

- `[stopping]`
- `[awaiting approval]`
- `idle`
- working / recent activity

但这些并不只是 shutdown 家族的问题，而是 in-process teammate 状态模型本身的问题。

## 本轮最关键的新判断

### 判断一：in-process teammate 至少有两层状态

一层是通用 lifecycle：

- `status`

另一层是投影 flag：

- `shutdownRequested`
- `awaitingPlanApproval`
- `isIdle`
- `recentActivities`

### 判断二：一个 `running` teammate 可以稳定长出多种投影

例如：

- running + shutdownRequested -> `stopping`
- running + awaitingPlanApproval -> `awaiting approval`
- running + isIdle -> `idle`

这正是用户最容易误判的点。

### 判断三：不同消费者从同一份 task state 读取的层完全不同

- detail / footer 读 activity compression
- spinner 读行级状态投影
- pill strip 几乎只读 `isIdle`
- headless waiter 读 `status === running && !isIdle`

### 判断四：`isIdle` 更像 drain/wait 语义，不等于 finished verdict

这让 headless wait 与 UI 文案之间的差异变得可解释：

- 一个 teammate 可以已经显示 `idle`
- 但仍然不是 `completed`

## 为什么这轮不直接画 81-84 四层总图

这是 84 页记忆里的候选，但当前最值钱的是先把：

- layered state != single enum

这条判断钉死。

如果不先写 85，后面即使做 termination 四层导航图，读者仍会把很多状态词误当成 `status` 的直接别名。

## 苏格拉底式自审

### 问：为什么这页不算重复写 shutdown？

答：因为 shutdown 只是这套状态投影里的一个 flag。85 的主角是“状态层级错位”，不是 shutdown transport。

### 问：为什么 `idle` 值得单独强调？

答：因为它最容易被误写成 terminal，同时它又是 pill strip、waiter、spinner 都在反复消费的关键 flag。

### 问：为什么要把 headless waiter 也带进来？

答：因为只有把 wait/drain 逻辑一起放进来，读者才会理解：同一个 flag 在不同消费者里承担的不是同一个语义职责。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/85-status、shutdownRequested、awaitingPlanApproval、isIdle、recentActivities 与 [stopping]：为什么 in-process teammate 的状态投影不是同一层状态.md`
- `bluebook/userbook/03-参考索引/02-能力边界/74-In-process teammate state projection 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/85-2026-04-06-in-process teammate state projection 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小改动：

- 长文层只补 85
- 索引层只补 74
- 记忆层只补 85

不把 81-85 重新揉成一篇巨大的 shutdown / teammate 总论。

## 下一轮候选

1. 把 81-85 压成一张 termination family 五层导航图：family、visible surfaces、routing split、host paths、state projection。
2. 单独拆 headless `print` 的 shutdown prompt、team drain 与 active teammate 收口。
3. 单独拆 teammate pill strip、spinner tree、detail dialog 三种前台状态面的厚度差。
