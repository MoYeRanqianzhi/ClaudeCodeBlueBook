# shutdown visible surfaces split 拆分记忆

## 本轮继续深入的核心判断

81 页已经回答了：

- shutdown family 是 lifecycle termination family

下一步最自然不是继续扩 protocol，而是补：

- visible surface split

因为用户真正会继续困惑的，不是“这是不是 shutdown family”，而是：

- 为什么 request / rejected / approved / stopping / teammate_terminated 不会出现在同一块显示面里？

## 为什么这轮必须把“可见面”单独拆出

因为如果不拆，读者会下意识期待：

- request
- approved
- rejected

像线性对话那样同厚度显示。

而源码实际采用的是：

- request / rejected 更偏人读对话
- approved 更偏 cleanup signal
- `shutdownRequested` 更偏运行态投影
- `teammate_terminated` 更偏 cleanup 完成后的系统影子

这四者同属一条 lifecycle，但不共享同一显示槽位。

## 本轮最关键的新判断

### 判断一：approved 被“识别”但不必被“展示”

`ShutdownMessage` 能识别 approved，summary helper 也能为 approved 生成摘要；

但 rich render、`UserTeammateMessage`、`AttachmentMessage` 又会主动把 approved 过滤掉。

所以重点不是“有没有识别能力”，而是：

- approved 的默认职责不是占主显示位

### 判断二：`stopping` 早于 approved，是本地状态投影

in-process `terminate()` 会在发 request 后立刻设置：

- `shutdownRequested: true`

于是 task status / spinner 会先变成：

- warning
- `stopping`
- `[stopping]`

这不是 shutdown 已完成，而是 shutdown 已经进入流程。

### 判断三：`teammate_terminated` 是 cleanup side 的系统影子

leader cleanup 完成后会注入：

- `type: teammate_terminated`

它不是对方发回的 mailbox response，而是本地 runtime 为了状态同步与通知一致性加出来的系统通知。

### 判断四：attachment / headless 也在复制这种分层

不是只有交互 UI 这样做。

`attachments.ts` 和 `print.ts` 也会：

- 优先处理 `shutdown_approved`
- 做 teammate 移除 / task unassign / 状态收口

然后再决定哪些东西值得进入当前可见面。

## 一个重要但应下沉到记忆的实现点

`isStructuredProtocolMessage(...)` 当前把：

- `shutdown_request`
- `shutdown_approved`

视为 structured protocol，但没有把：

- `shutdown_rejected`

列进去。

这很能解释 transport/visible 的不对称，但它属于实现名单，不宜在正文里写成硬合同。正文更稳的写法应是：

- request / approved 更偏 handler-first
- rejected 更偏 visible reply

而不是写死那份具体白名单。

## 苏格拉底式自审

### 问：为什么这轮不去写更大的 message routing 总图？

答：因为 shutdown 的高价值误判还没拆完。现在最需要纠偏的是“同一 lifecycle 是否必须同厚度显示”，而不是再开一张覆盖全部 mailbox family 的大路由图。

### 问：为什么这轮可以把 spinner/status 也并进来？

答：因为否则“approved 不显示”会被读者误解成“系统没有反馈”。只有把 `stopping` 这条状态投影一起写进来，用户才会理解反馈并没有消失，而是换了面。

### 问：为什么 `teammate_terminated` 更适合写成 cleanup shadow，而不是正文主角？

答：因为它不是 lifecycle negotiation 的主体，而是 leader 收口一致性时注入的系统影子。正文需要解释它存在，但不能把它上升成与 request/rejected 同层的公开 contract。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/82-shutdown_request、shutdown_approved、shutdown_rejected、teammate_terminated 与 stopping：为什么 shutdown 生命周期不会完整落在同一可见消息面.md`
- `bluebook/userbook/03-参考索引/02-能力边界/71-Shutdown lifecycle visible surface split 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/82-2026-04-06-shutdown visible surfaces split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小改动：

- 长文层只补 82
- 索引层只补 71
- 记忆层只补 82

不把 shutdown protocol、visible surface、message routing、team topology 重新混成一篇大总论。

## 下一轮候选

1. 单独拆 shutdown 与 `teammate_terminated` 在 attachment bridge / inbox pending / processed 状态上的 message routing 差异。
2. 回到 79-82，压一张 approval shell / mailbox family / visible surfaces 三层总图。
3. 单独拆 in-process teammate 的 `shutdownRequested`、`awaitingPlanApproval`、`idle` 三种状态投影。
