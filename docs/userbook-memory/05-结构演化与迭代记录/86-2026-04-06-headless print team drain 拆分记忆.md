# headless print team drain 拆分记忆

## 本轮继续深入的核心判断

85 页已经把 in-process teammate 的 layered state 讲清了。

下一步如果继续深挖，更自然不是再横向扩 teammate UI，而是回到：

- headless `print` 自己的 drain protocol

因为 84 虽然已经比较了 `print` 和另外两条宿主路径，但还没把：

- input 关闭后到底如何等待、何时注入 shutdown prompt、何时真正允许退出

单独讲透。

## 为什么这轮必须单列 headless print 的 drain

因为用户最容易误判的一句就是：

- “headless 没有 UI，所以输入结束就该结束。”

而实际源码表达的是：

- 输入结束以后，才开始进入 team drain

这和 interactive “继续有宿主交互” 完全不是一回事。

## 本轮最关键的新判断

### 判断一：`inputClosed` 是 drain 起点，不是退出判据

只要 input 关闭，`print` 先看：

- working teammates 是否还没 idle

### 判断二：`hasWorkingInProcessTeammates` 与 `hasActiveInProcessTeammates` 不是同一层

前者回答：

- 还有没有人在真正工作

后者回答：

- 还有没有 running in-process teammate task

这正好构成两段式收口。

### 判断三：`SHUTDOWN_TEAM_PROMPT` 是 headless 的显式系统驱动

它不是附加提示，而是 non-interactive 模式下把“关团队后才能给最终答复”的规则回灌给模型。

### 判断四：`waitForTeammatesToBecomeIdle(...)` 等的不是 terminal

这条 helper 的语义是：

- 先等 still-working teammates 进入 idle

不是：

- 等他们都 completed

## 为什么这轮不直接写 headless vs REPL 总论

因为当前最值钱的是具体收口机制：

- `inputClosed`
- `hasWorking...`
- `waitFor...Idle`
- `hasActive...`
- `SHUTDOWN_TEAM_PROMPT`

如果直接跳到“大而泛的 headless vs REPL”，反而会把这条精确的 shutdown drain 协议写糊。

## 苏格拉底式自审

### 问：为什么不把这页并进 84？

答：84 的主轴是三条宿主路径的横向比较；86 的主轴是 `print` 自己的纵向 drain 协议。一个讲比较，一个讲机制。

### 问：为什么不把 `SHUTDOWN_TEAM_PROMPT` 细节全搬进正文？

答：正文只需要抓它的宿主作用：显式驱动团队收口。具体文案属于实现层，适合留在记忆。

### 问：为什么这页仍然和 85 有关？

答：因为它需要 85 才能解释“为什么先等 idle 再继续 drain”。85 提供状态语义，86 提供收口协议。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/86-SHUTDOWN_TEAM_PROMPT、inputClosed、hasWorkingInProcessTeammates、waitForTeammatesToBecomeIdle 与 hasActiveInProcessTeammates：为什么 headless print 的 team drain 不是 interactive REPL 的直接缩小版.md`
- `bluebook/userbook/03-参考索引/02-能力边界/75-Headless print shutdown prompt and team drain 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/86-2026-04-06-headless print team drain 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小改动：

- 长文层只补 86
- 索引层只补 75
- 记忆层只补 86

不把 81-86 重新揉成一篇巨大的 shutdown / headless 总论。

## 下一轮候选

1. 把 81-86 压成一张 termination family 六层导航图。
2. 单独拆 teammate pill strip、spinner tree、detail dialog 三种前台状态面的厚度差。
3. 单独拆 headless `print` 里的 active teammate polling 与 unread mailbox loop。
