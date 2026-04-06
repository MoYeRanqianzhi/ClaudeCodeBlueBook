# `shutdown_request`、`shutdown_approved`、`shutdown_rejected`、`teammate_terminated` 与 `stopping`：为什么 shutdown 生命周期不会完整落在同一可见消息面

## 用户目标

81 页已经把一个更底层的问题拆开了：

- `shutdown_*` 不是 approval family
- 而是 lifecycle termination family

但只停在这里还不够，因为读者下一步会马上撞上另一个更具体的困惑：

- 为什么 `shutdown_request` 会以醒目的 warning 卡片出现？
- 为什么 `shutdown_rejected` 也能以可读消息出现？
- 为什么 `shutdown_approved` 明明也有 summary，却常常在主显示层里消失？
- 为什么 teammate 明明还没“看到 approved 消息”，spinner 却已经先进入 `[stopping]`？
- 为什么 leader 侧还有 `teammate_terminated` 这种系统通知，却又不总是落到同一个 mailbox 视图里？

如果这些问题不拆开，读者就会把 shutdown family 重新误写成一句过度简化的话：

- “termination lifecycle 里三条消息应该都以同样方式显示给用户。”

源码不是这样设计的。

## 第一性原理

更稳的提问不是：

- “shutdown 相关消息有没有显示出来？”

而是四个更底层的问题：

1. 这条信号是给谁看的：模型、leader、runtime status，还是 cleanup path？
2. 这条信号是在描述一次 lifecycle decision，还是一次 cleanup consequence？
3. 这条信号应该优先被人读到，还是优先被状态机消费？
4. 这条信号应该进入同一块 transcript UI，还是应该投影到别的状态面？

只要这四轴不先拆开，后续就会把：

- lifecycle family sameness

误写成：

- visible surface sameness

## 第二层：shutdown 生命周期其实同时投影到四张面

| 面 | 代表对象 | 主要回答什么问题 |
| --- | --- | --- |
| rich message 面 | `ShutdownMessage`、`UserTeammateMessage` | 人现在该不该读这条 lifecycle 对话？ |
| mailbox attachment 面 | `AttachmentMessage`、`formatTeammateMessageContent` | 这批 mailbox 消息要不要算进“有几条可见消息”？ |
| task / spinner 面 | `shutdownRequested`、`describeTeammateActivity`、`TeammateSpinnerLine` | 这名 teammate 现在是在工作、等待批准，还是正在停机？ |
| hidden cleanup 面 | `useInboxPoller`、`print.ts`、`attachments.ts` | leader 何时移除 teammate、清理任务、同步 team topology？ |

这张表最重要的作用是先钉住一个事实：

- shutdown 生命周期不是只落在 transcript 里
- 而是被故意拆成多张不同厚度的可见面

## 第三层：`shutdown_request` 和 `shutdown_rejected` 被当作“值得人读”的 lifecycle 对话

`ShutdownMessage.tsx` 只专门渲染两类消息：

- `shutdown_request`
- `shutdown_rejected`

对应的显示语义也非常直接：

- request = warning border + 请求来源 + 可选 reason
- rejected = subtle border + 拒绝理由 + “teammate will continue to work” 提示

也就是说，这两类消息虽然同属 lifecycle family，但在显示层承担的是：

- human-readable lifecycle dialogue

这和 81 页的 termination contract 是一致的：

- request 代表 “请你结束”
- rejected 代表 “我拒绝结束，并继续工作”

这两类消息都值得被人直接读到。

## 第四层：`shutdown_approved` 明明有 summary，却常常在主显示器里被主动隐藏

### rich render 明确跳过 `shutdown_approved`

`tryRenderShutdownMessage(...)` 的逻辑是：

- request -> render
- approved -> `null`
- rejected -> render

这已经说明一个重要事实：

- approved 在这里不是 rich lifecycle card

### transcript / mailbox 组件也会预过滤 approved

`UserTeammateMessage.tsx` 在真正开始渲染前就先过滤：

- `shutdown_approved`

`AttachmentMessage.tsx` 在统计 mailbox attachment 的 `visibleMessages` 时也先过滤：

- `shutdown_approved`
- `idle_notification`
- `teammate_terminated`

所以 approved 不是“解析不到”，而是：

- 被识别出来之后，仍然被主显示器故意隐藏

### 但 summary helper 又知道 approved 是什么

`getShutdownMessageSummary(...)` 其实能生成：

- `[Shutdown Approved] ... is now exiting`

`formatTeammateMessageContent(...)` 也会优先尝试：

- plan summary
- shutdown summary
- idle summary
- task assignment summary
- `teammate_terminated` summary

这说明 approved 的设计不是“不存在用户语义”，而是：

- 它有语义
- 但默认不占主显示位

因为它更像：

- cleanup consequence marker

而不是：

- 还需要继续读的对话内容

## 第五层：`shutdownRequested` 会先把状态面推到 `[stopping]`，早于 approved 出现

这是这批最值得用户记住的第二个不对称点。

### in-process terminate 会先改本地 task state

`InProcessBackend.ts` 的 `terminate()` 在发出 mailbox `shutdown_request` 之后，会立刻：

- `requestTeammateShutdown(task.id, setAppState)`

而 `requestTeammateShutdown(...)` 做的事情很简单：

- 如果任务还在 running 且尚未 shutdownRequested
- 就把 `shutdownRequested: true`

这意味着在 in-process teammate 场景里，leader 本地状态面会先知道：

- “这名 teammate 正在停机流程里”

即使对方还没发回 approved。

### task / spinner 面会把它投影成 “stopping”

`taskStatusUtils.tsx` 和 `TeammateSpinnerLine.tsx` 都把：

- `shutdownRequested`

当成单独的状态分支。

结果是：

- 图标变成 warning
- 颜色变成 warning
- activity 变成 `stopping`
- spinner 文本变成 `[stopping]`

所以从用户视角看，shutdown lifecycle 至少分成两步：

1. 已进入停机流程
2. 真正完成退出 / 清理

如果把 `[stopping]` 和 `shutdown_approved` 混成同一时刻，就会误判状态。

## 第六层：leader cleanup 面真正关心的是 `shutdown_approved`，不是“展示 approved”

`useInboxPoller.ts` 在 leader 侧收到 `shutdown_approved` 后，会沿 cleanup path 做一串动作：

- 必要时按 `paneId + backendType` kill pane
- 从 team file 移除 teammate
- `unassignTeammateTasks(...)`
- 从 `teamContext.teammates` 删除该成员
- 额外向 `AppState.inbox.messages` 注入一条系统消息：
  - `type: 'teammate_terminated'`
  - `message: notificationMessage`

这个路径的核心不是：

- “把 approved 漂亮地显示出来”

而是：

- “让 leader 侧 runtime state 收口一致”

所以 approved 被隐藏，并不代表它不重要，恰恰相反：

- 它太重要了，重要到先拿去做 cleanup，再考虑是否留在显示面

## 第七层：`teammate_terminated` 是 cleanup side 的系统影子，不等于普通 mailbox 消息

`teammate_terminated` 不是对方发来的 mailbox shutdown response。

它更像 leader 本地在 cleanup 完成时额外注入的一条：

- synthetic system notification

这条通知的作用不是再表达一次 “approved”，而是让本地状态、任务分配和通知文案有一个统一的收口对象。

但这条消息又不会稳定落在同一个可见面里：

- `UserTeammateMessage.tsx` 预过滤 `teammate_terminated`
- `AttachmentMessage.tsx` 也预过滤 `teammate_terminated`
- `formatTeammateMessageContent(...)` 却又知道如何把它变成一条纯文本 summary

这再次证明一个关键事实：

- cleanup side effect 的系统通知
- 不等于 transcript rich card

## 第八层：attachment bridge 还故意把 request / approved / rejected 做了不对称 transport 分类

`isStructuredProtocolMessage(...)` 会把这些类型视为“应该先交给 handler，而不是直接当原始 LLM 上下文消耗”的 structured protocol：

- `shutdown_request`
- `shutdown_approved`

但它没有把：

- `shutdown_rejected`

放进去。

这意味着在当前实现里，shutdown family 在 attachment bridge 这一层也不是完全对称的：

- request / approved 更偏 handler-first
- rejected 更偏 visible reply

这能解释为什么 rejected 更自然地长成：

- 一条应该被人直接读到的生命周期反馈

而 approved 更自然地长成：

- 一条应该优先交给 cleanup / topology mutation 的控制信号

这里要非常小心边界：

- “为什么当前 transport 分类不对称” 属于实现层
- 但“不对称会投影成不同可见面” 是用户能稳定观察到的现象

## 第九层：headless / attachment 路径也在复制这套“隐藏 approved、优先 cleanup”的思想

`attachments.ts` 在 leader transcript attachment 路径下，也会手动处理：

- `shutdown_approved`

原因很直接：

- `-p` / attachment path 下不跑 `useInboxPoller`
- 所以要在这里镜像 interactive cleanup 逻辑

同一个函数还会：

- 合并 file mailbox unread 与 `AppState.inbox` pending messages
- dedup
- 折叠多条 idle notification
- 在可见计数前过滤 approved / idle / teammate_terminated

所以这不是 REPL 单组件的小聪明，而是一个更普遍的设计倾向：

- cleanup 先一致
- visible surface 再按受众裁切

## 第十层：最稳的使用者心智模型

如果只记一条最实用的心智模型，就是：

- shutdown 生命周期不会完整显示成“三条一模一样厚度的消息”

更准确的记法是四句：

- `shutdown_request` 像“进入终止协商”的 warning card
- `shutdown_rejected` 像“拒绝终止”的可见回复
- `shutdown_approved` 更像 cleanup signal，不保证占 transcript 主位
- `shutdownRequested/stopping` 与 `teammate_terminated` 分别投影到状态面和 cleanup 通知面

只要这四句没有一起记住，后续就很容易把：

- termination lifecycle

误写成：

- 一条线性对话

## 第十一层：最常见的假等式

### 误判一：`shutdown_request`、`shutdown_rejected`、`shutdown_approved` 应该同等显示

错在漏掉：

- request / rejected 更偏人读
- approved 更偏 cleanup

### 误判二：`shutdown_approved` 不显示，说明系统不关心它

错在漏掉：

- leader cleanup 正是围绕 approved 展开

### 误判三：spinner 的 `[stopping]` 说明对方已经退出

错在漏掉：

- `shutdownRequested` 只是停机流程已开始
- 不等于 approved 已回
- 更不等于 cleanup 已完成

### 误判四：`teammate_terminated` 就是 approved 的另一种别名

错在漏掉：

- 前者是 leader 本地注入的 cleanup notification
- 后者是 mailbox lifecycle response

### 误判五：只要 helper 能生成 summary，这条消息就一定会出现在主显示器里

错在漏掉：

- summary helper 负责“能不能压缩成说明”
- rich render 决定“要不要占可见主位”

### 误判六：shutdown family 的可见性不对称只是 UI 偶然

错在漏掉：

- task status
- spinner
- attachment bridge
- interactive cleanup
- headless cleanup

都在复制这种分层思想

## 第十二层：稳定、条件与内部边界

### 稳定可见

- shutdown lifecycle 会分裂到 rich message、task status、spinner、cleanup 这几张不同的面。
- `shutdown_request` 和 `shutdown_rejected` 更接近可读 lifecycle 对话。
- `shutdown_approved` 更接近 cleanup signal，不保证作为主消息面显示。
- `shutdownRequested` 会把 teammate 状态提前投影成 `stopping`。

### 条件公开

- `stopping` 这条状态投影在 in-process teammate 上最稳定，因为它直接依赖本地 task state。
- pane teammate 的最终退出更依赖 `paneId/backendType -> killPane(...)` 收口。
- headless / attachment 路径会镜像 interactive cleanup，但显示厚度仍受当前渲染面影响。
- `teammate_terminated` 是否在当前显示层出现，取决于该层是否过滤系统通知。

### 内部 / 实现层

- `isStructuredProtocolMessage(...)` 目前包含 `shutdown_request` / `shutdown_approved`，但不包含 `shutdown_rejected`。
- `AttachmentMessage`、`UserTeammateMessage`、summary helper 的具体过滤和顺序。
- `pendingInboxMessages` 合并、dedup、idle collapse、processed 状态回写。
- synthetic `teammate_terminated` 注入与 notification 文案的具体生成方式。

## 第十三层：苏格拉底式自检

### 问：如果 approved 真和 rejected 一样是“给人读的回复”，为什么多个主显示器都主动跳过它？

答：因为 approved 的主要职责不是继续沟通，而是触发 cleanup 与 topology 收口。

### 问：如果 `stopping` 真等于已经退出，为什么还需要 approved 和 cleanup？

答：因为 `stopping` 只是本地状态投影，表示“停机流程已发起”，不是 lifecycle 已闭环。

### 问：如果 `teammate_terminated` 真是普通聊天消息，为什么 transcript/mailbox 组件会过滤它？

答：因为它更像 cleanup 完成后的系统影子，不是对等协商消息。

### 问：如果这页只是 UI 讨论，为什么还要看 attachment 和 headless 路径？

答：因为只有把 interactive、attachment、task status、cleanup 一起看，才能证明这是一套跨路径的一致设计，而不是单个组件的偶然选择。

## 源码锚点

- `claude-code-source-code/src/components/messages/ShutdownMessage.tsx`
- `claude-code-source-code/src/components/messages/UserTeammateMessage.tsx`
- `claude-code-source-code/src/components/messages/AttachmentMessage.tsx`
- `claude-code-source-code/src/components/messages/PlanApprovalMessage.tsx`
- `claude-code-source-code/src/components/tasks/taskStatusUtils.tsx`
- `claude-code-source-code/src/components/Spinner/TeammateSpinnerLine.tsx`
- `claude-code-source-code/src/hooks/useInboxPoller.ts`
- `claude-code-source-code/src/utils/attachments.ts`
- `claude-code-source-code/src/utils/teammateMailbox.ts`
- `claude-code-source-code/src/utils/swarm/backends/InProcessBackend.ts`
- `claude-code-source-code/src/tasks/InProcessTeammateTask/InProcessTeammateTask.tsx`
