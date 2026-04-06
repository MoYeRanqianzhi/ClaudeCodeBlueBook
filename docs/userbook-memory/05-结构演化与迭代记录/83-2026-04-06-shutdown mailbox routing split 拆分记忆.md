# shutdown mailbox routing split 拆分记忆

## 本轮继续深入的核心判断

82 页已经把 shutdown lifecycle 的显示层拆成：

- rich message
- attachment
- task / spinner
- hidden cleanup

下一步最自然不是再开新的显示层页，而是继续追问：

- 为什么这些对象在更下层的 routing 上就已经分道扬镳？

这就是 83 页的主轴。

## 为什么这轮必须往 routing 层再下一步

因为如果只停在 82，读者仍可能把可见性差异误解成：

- 单个 UI 组件的过滤偏好

但真正更稳的解释是：

- request / approved / rejected / teammate_terminated 从一开始就没有共用同一条 mailbox routing 通道

显示层差异只是 routing split 的后果。

## 本轮最关键的新判断

### 判断一：request / approved 是 handler-first，不等于 transcript-first

`isStructuredProtocolMessage(...)` 把：

- `shutdown_request`
- `shutdown_approved`

留给 poller / handler 路由，attachments 也会故意避免先把这两类 unread 当 raw mailbox text 消耗掉。

### 判断二：rejected 更像 regular visible reply

它没有进入同一份 structured protocol 白名单，也没有自己的 unread 专属数组，所以更自然地回到 regular message route。

### 判断三：`teammate_terminated` 是 leader 本地 injected shadow

它不是对方发回的 mailbox lifecycle response，而是 cleanup 完成后本地塞进 `AppState.inbox.pending` 的系统影子。

### 判断四：`pending -> processed -> cleanup` 是本地 delivery 状态机，不是 lifecycle family 总合同

这套状态机主要服务于：

- interactive leader-side local delivery

它能解释 attachment mid-turn delivery 和下一轮 poller cleanup，但不该被写成 shutdown family 的普遍公开合同。

## 这轮新增的目录价值

81 解决的是：

- family 是什么

82 解决的是：

- 它会出现在哪些面

83 解决的是：

- 它们为什么从 routing 层就不共路

这三页一起，才足以避免把 shutdown lifecycle 又写回“一条线性对话”。

## 一个需要强制下沉到记忆的点

`isStructuredProtocolMessage(...)` 当前包含：

- `shutdown_request`
- `shutdown_approved`

不包含：

- `shutdown_rejected`

这个实现差异极有分析价值，但正文应避免把“具体白名单”写成长期稳定合同。正文更适合写成：

- request / approved 更偏 handler-first
- rejected 更偏 regular reply

## 苏格拉底式自审

### 问：为什么这轮不把 headless / interactive 直接写成两条并列总线？

答：因为高价值问题仍是 shutdown family 自身的 routing split。headless 与 interactive 的差异可以作为条件层补充，但不该抢走主轴。

### 问：为什么这轮要把 `pending/processed` 也纳入标题和正文？

答：因为否则读者看不见 leader 本地 injected shadow 是怎么被投递和清掉的，就会继续误解 `teammate_terminated` 的来源。

### 问：为什么 `teammate_terminated` 不能直接并回 82 的显示层页？

答：因为它在 82 里只是“显示上像系统影子”；到了 83，才把“为什么它来自另一条 routing”真正解释清楚。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/83-shutdown_request、shutdown_approved、shutdown_rejected、teammate_terminated、pending 与 processed：为什么 shutdown 生命周期不会走同一条 mailbox routing 通道.md`
- `bluebook/userbook/03-参考索引/02-能力边界/72-Shutdown mailbox routing split 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/83-2026-04-06-shutdown mailbox routing split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小改动：

- 长文层只补 83
- 索引层只补 72
- 记忆层只补 83

不把 shutdown family、显示层、routing 层、headless path 再混成一篇失焦总论。

## 下一轮候选

1. 把 81-83 压成一张 termination family 三层导航图：family、visible surfaces、routing split。
2. 单独拆 in-process teammate 的 `shutdownRequested`、`awaitingPlanApproval`、`idle` 三种状态投影。
3. 单独拆 `print.ts`、`attachments.ts` 与 interactive poller 的 shutdown 收口差异。
