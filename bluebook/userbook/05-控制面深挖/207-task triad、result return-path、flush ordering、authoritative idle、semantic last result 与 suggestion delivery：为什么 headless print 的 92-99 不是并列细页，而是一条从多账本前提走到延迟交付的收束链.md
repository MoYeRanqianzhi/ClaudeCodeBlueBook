# `task triad`、result return-path、flush ordering、authoritative idle、semantic last result 与 suggestion delivery：为什么 headless print 的 92-99 不是并列细页，而是一条从多账本前提走到延迟交付的收束链

## 用户目标

92-99 连着拆完之后，读者最容易滑向一个新的误判：

- “这几页都在讲 headless print 的 task result，应该是七八篇平行小文，按兴趣挑一篇读就行。”

这句话表面上节省时间，

实际上会把后面的判断重新压扁。

因为这组页真正回答的不是：

- 一串互不依赖的局部 FAQ

而是：

- 同一份后台任务结果，从多账本前提一路收束到真实交付时，要经过哪些不能跳过的语义关口。

如果这个收束链不先钉死，读者就会反复混写：

- 92 的多账本前提
- 93 的 triad vs queue lifecycle
- 94 的 progress host projection
- 95 的 return-path split
- 96 的 flush ordering
- 97 的 authoritative idle
- 98 的 semantic last result
- 99 的 delayed suggestion delivery

于是：

- 把 94 写成 95 的前置正文
- 把 99 写成 98 的平行“结果页”
- 把 `drainSdkEvents()`、`heldBackResult`、`pendingSuggestion` 这类实现名误当成稳定功能名

这页要做的不是补更多叶子页，

而是先把 92-99 排成一条可读的结构链。

## 第一性原理

更稳的提问不是：

- “这几页里哪篇我最感兴趣？”

而是先问六个更底层的问题：

1. 我现在卡住的是“结果为什么不会落在同一本账”这个前提，还是“分裂之后怎样重新收束”的后继问题？
2. 我现在问的是任务运行时 triad、模型回流路径、输出时序护栏，还是最终交付记账？
3. 这一步在定义主干，还是只是在给某个局部分叉补一层细化？
4. 这句话是稳定用户合同、条件性可见合同，还是灰度实现证据？
5. 如果不先读当前节点，下一页里哪句话会失去主语？
6. 我现在依赖的是一个能跨实现名存活的语义判断，还是只是在跟着 helper 名称走？

只要这六轴不先拆开，

后面就会把：

- one split root plus one convergence chain with two side branches

重新误写成：

- seven parallel result pages

## 第一层：92 是根页，不是并列细页之一

92 先回答的是：

- 同一份任务结果为什么会同时落在 task bookend、command lifecycle 与 attachment 内容三套账本上。

如果这层没先读，

93-99 的很多句子都会失去前提：

- 为什么 triad 不是 pair
- 为什么 progress 先属于 host
- 为什么 return path 会分叉
- 为什么 idle 要晚于 held-back result
- 为什么 result 语义不让给系统尾流
- 为什么 suggestion 要等真实交付后才算 delivered

所以 92 的位置更像：

- 多账本前提根页

而不是：

- 这组页里任意可替代的一篇。

## 第二层：93-98 是主干，94/99 是挂枝

更稳的读法是：

```text
92 多账本前提
  ↓
207 收束链总览
  ↓
93 triad vs queue lifecycle
  └─ 94 progress = host projection
  ↓
95 task result return-path split
  ↓
96 staged flush ordering
  ↓
97 idle = authoritative turn-over
  ↓
98 result keeps semantic last-message
  └─ 99 suggestion delivery / accounting
```

这里真正的主干不是：

- 93/94/95/96/97/98/99 横着并列

而是：

- 93/95/96/97/98 五个连续收束节点

再加上：

- 94 作为 93 的 progress 分叉
- 99 作为 98 的 delivery 分叉

## 第三层：为什么 93 是主干起点

93 先把一个最危险的偷换拆开：

- `task_started/task_progress/task_notification` 的 triad
- `notifyCommandLifecycle(started/completed)` 的 pair

只有这一步先定住，

95 才能继续问：

- 既然 task runtime 和 queue consumption 本来就是两条时间轴，结果为什么还会在 XML re-entry 路和 direct SDK close 路之间继续分叉？

所以 93 的职责是：

- 给收束链固定“先分 task runtime，再谈 result 回流”的入口。

## 第四层：为什么 94 只是 93 的挂枝

94 很重要，

但它没有换掉主干主语。

它继续深挖的只是：

- triad 里的 `task_progress/workflow_progress`
- 为什么首先属于 host projection，而不是 model layer

如果你现在卡住的是：

- 结果为什么分叉回流
- idle 为什么可信
- result 为什么保住主语义

那 94 不是必须先读的下一页。

更准确的说法是：

- 94 负责细化 93 内部的 progress 分叉

不是：

- 整条收束链上不可绕过的第二个主干节点

## 第五层：95-98 为什么是一条连续收束主干

这四页真正回答的是同一个连续问题：

- 一份已经在多账本里分裂开的 task result，怎样在 headless print 里安全收口？

按顺序看：

### 95 先定回流路径

- 结果到底要不要重新进入模型回合
- 是 XML re-entry，还是 direct SDK close

### 96 再定时序护栏

- 一旦路径已分叉，`drainSdkEvents()` 为什么要在多个站位保护 progress、result、idle 的相对顺序

### 97 再把时序护栏收成 turn-over 信号

- 为什么 `idle` 必须晚于 `heldBackResult` flush 和 bg-agent do-while exit，才能成为 authoritative turn-over

### 98 最后定主结果语义

- 为什么 late-drained `task_notification`、idle、`post_turn_summary` 虽然都重要，却仍然不能篡改 result 的 semantic last-message 主位

所以这四页不是：

- 四种平行“结果细节”

而是：

- 从路径分叉到时序收口，再到语义主位保留的一条连续主干

## 第六层：为什么 99 只该挂在 98 后面

99 讨论的不是：

- 另一种平行 result semantics

而是：

- 在 result 已经保住 semantic last-message 之后，suggestion 为什么还要继续等真实交付，才能进入 acceptance tracking

换句话说，

99 只有在 98 已经成立之后才有主语：

- 如果 result 的主位都没保住，就无从谈 suggestion 为什么要让位于 result 落地

所以 99 更准确的位置是：

- 98 的 delivery/accounting 分叉

不是：

- 95-98 旁边另一篇独立结果页

## 第七层：为什么这条链能保护稳定功能，也能隔离灰度实现

这组页最容易被写坏的地方，

不是事实不够多，

而是稳定合同和灰度实现缠在一起。

更稳的写法应先分三层：

| 类型 | 应该保住什么 |
| --- | --- |
| 稳定用户合同 | 多账本分裂不是单账本；triad 不是 queue pair；progress 首先服务 host；result 回流会分 XML re-entry / direct SDK close；idle 晚于 held-back result 与 bg-agent exit；result 保住 semantic last-message；suggestion 在真实交付后才进入 tracking |
| 条件性可见合同 | 不同宿主看到的厚度不同；某些 terminal `task_notification` 只服务 SDK consumer；延后 suggestion 在新命令先到时可以被丢弃 |
| 灰度/实现证据 | `drainSdkEvents()`、`heldBackResult`、`pendingSuggestion`、`pendingLastEmittedEntry`、`lastEmitted` 等变量名与 helper 站位 |

这里最该保护的一句是：

- 用实现名作证据，但不要把实现名误写成用户合同本身。

## 第八层：苏格拉底式自审

每次继续深挖这条链，先追问自己：

1. 如果不先读 92，我现在这句话还有账本主语吗？
2. 我现在是在主干上推进，还是在 94/99 这种挂枝上补细节？
3. 这一步主要在回答 host、model、output，还是 delivery/accounting？
4. 这条判断在 helper 名全改掉以后还成立吗？
5. 我是不是把“晚到很重要”误写成了“晚到就该夺走主位”？
6. 我是不是把“已经生成”误写成了“已经交付”？

如果其中任何一个问题回答不稳，

就不该直接继续往叶子页下钻，

而应该先回到 92、93、95、98 这些主干节点补主语。

## 第九层：最常见的假等式

### 误判一：93-99 都是 task result 页，所以可以并列读

更准确的写法是：

- 93/95/96/97/98 是主干
- 94/99 是挂枝

### 误判二：94 是 95 的前置正文

更准确的写法是：

- 94 只细化 progress projection
- 不定义 result return-path split

### 误判三：99 是另一种 result semantics

更准确的写法是：

- 99 只讨论 result 之后的 suggestion delivery/accounting

### 误判四：helper 名就是稳定能力名

更准确的写法是：

- helper 名只提供实现证据
- 稳定层要写 consumer、path、ordering、delivery 这些跨实现名的合同

## 第十层：阅读建议

如果你现在的问题是：

- “为什么一份 task result 明明都在讲结果，却会被拆成这么多页？”

建议按这个顺序：

1. 92：先定多账本前提
2. 207：先把主干和挂枝分清
3. 93：先分 triad 和 pair
4. 95：再看 return-path split
5. 96：再看 flush ordering
6. 97：再看 authoritative idle
7. 98：再看 semantic last result
8. 99：最后再进 suggestion delivery

如果你只关心 progress，

可读：

- 92 -> 207 -> 93 -> 94

如果你只关心 suggestion 为什么不立刻交付，

可读：

- 92 -> 207 -> 93 -> 95 -> 96 -> 97 -> 98 -> 99
