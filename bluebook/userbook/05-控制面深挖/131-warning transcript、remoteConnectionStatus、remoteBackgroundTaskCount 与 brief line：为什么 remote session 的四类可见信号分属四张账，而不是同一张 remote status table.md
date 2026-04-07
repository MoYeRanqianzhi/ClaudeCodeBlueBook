# `warning` transcript、`remoteConnectionStatus`、`remoteBackgroundTaskCount` 与 brief line：为什么 remote session 的四类可见信号分属四张账，而不是同一张 remote status table

## 用户目标

122 已经把：

- timeout watchdog
- reconnect warning
- `reconnecting`
- `disconnected`

拆成了不同的 recovery lifecycle。

130 又把：

- `remoteSessionUrl`
- brief line
- bridge pill
- bridge dialog
- attached viewer

拆成了不同的 surface presence。

但继续往下读时，读者还是很容易把另一组紧挨着的对象重新压成一句：

- transcript 里出现 warning
- `AppState` 里有 `remoteConnectionStatus`
- `AppState` 里有 `remoteBackgroundTaskCount`
- brief line 又把它们显示出来

于是正文就会滑成一句似是而非的话：

- “这些只是同一张 remote status table 在不同地方的展示。”

这句仍然不稳。

从当前源码看，它们不是一张表的多处渲染，

而是四张不同的账：

1. `warning transcript` 这张消息账
2. `remoteConnectionStatus` 这张 WS lifecycle 账
3. `remoteBackgroundTaskCount` 这张远端任务计数账
4. brief line 这张 lossy summary 投影账

## 第一性原理

更稳的提问不是：

- “remote session 的状态到底看哪一处？”

而是先问五个更底层的问题：

1. 当前这条信号是写进 transcript，还是写进 `AppState`？
2. 当前这条信号记录的是 remediation prompt、WS lifecycle，还是 remote task count？
3. 当前这条信号有没有自己的写路径，还是只是最后的摘要投影？
4. 当前这条信号会不会在 reconnect gap 里故意清零、合并、丢 provenance？
5. 当前这条信号在 `viewerOnly` 路径里是否仍然成立？

只要这五轴先拆开，后面的 warning、connection status、background count 和 brief line 就不会再被写成一张 remote status table。

## 第一层：`warning transcript` 是本地 remediation prompt，不是连接状态本体

`useRemoteSession.ts` 里的 timeout watchdog 触发后，会：

- `createSystemMessage('Remote session may be unresponsive. Attempting to reconnect…', 'warning')`
- `setMessages(prev => [...prev, warningMessage])`
- 然后 `manager.reconnect()`

这里最关键的一点是：

- warning 是写进 `messages`

它进入的是：

- transcript message ledger

而不是：

- `remoteConnectionStatus` 槽位

它回答的问题也不是：

- “当前 WS 已经 durable 地进入 `reconnecting`”

而是：

- “本地 owner-side watchdog 觉得这轮 turn 可能卡住了，正在发起补救动作”

所以这张账的主语是：

- remediation prompt

不是：

- authoritative connection state

## 第二层：`remoteConnectionStatus` 是 WS lifecycle 槽位，不是 transcript 的另一种皮肤

`useRemoteSession.ts` 先定义了：

- `setConnStatus`

它只写：

- `prev.remoteConnectionStatus === s ? prev : { ...prev, remoteConnectionStatus: s }`

而真正调用它的时机也很窄：

- `onConnected` -> `connected`
- `onReconnecting` -> `reconnecting`
- `onDisconnected` -> `disconnected`

这说明 `remoteConnectionStatus` 当前回答的是：

- 当前 remote session 的 WebSocket lifecycle 处在什么阶段

它不直接回答：

- 远端 worker 是否健康
- 这次恢复是否已经成功
- transcript 里有没有 warning
- 后台 task 有没有跑完

所以这张账更像：

- WS lifecycle ledger

不是：

- transcript ledger

## 第三层：`remoteBackgroundTaskCount` 是远端子任务 live counter，不是本地 `tasks` 的别名

`useRemoteSession.ts` 的注释写得很明确：

- viewer 的 `AppState.tasks` 是空的
- 任务活在另一个 process
- `task_started` / `task_notification` 通过 bridge WS 到达

对应的计数逻辑也很窄：

- `runningTaskIdsRef.current.add(task_id)` on `task_started`
- `runningTaskIdsRef.current.delete(task_id)` on `task_notification`
- `writeTaskCount()` 把 `Set.size` 写回 `remoteBackgroundTaskCount`

这说明 `remoteBackgroundTaskCount` 回答的问题是：

- 当前远端 daemon child 里，事件流所见的活跃子任务数是多少

它不是：

- 本地 `AppState.tasks` 的镜像
- 本地 task panel 的主表
- transcript 可见消息数

更关键的是，在 reconnect / disconnect 时，代码还会主动：

- `runningTaskIdsRef.current.clear()`
- `writeTaskCount()`

注释明确接受：

- 跨 WS gap 会低估

目的只是：

- 不要让 stale 高值永远挂着

所以这张账是：

- best-effort live counter

不是：

- provenance-safe task source of truth

## 第四层：brief line 只做摘要投影，而且故意丢信息

`BriefIdleStatus()` 和 brief spinner 共用的 running count 都不是只读 remote：

- `count(Object.values(tasks), isBackgroundTask) + remoteBackgroundTaskCount`

也就是说右侧这句：

- `N in background`

从一开始就是：

- 本地 background tasks
- 加上 remote background tasks

的合并数。

它并不保留：

- 哪一部分来自远端
- 哪一部分来自本地

左侧连接文案也一样是压缩投影：

- 只有 `reconnecting` / `disconnected` 才显示
- `connecting` / `connected` 被故意隐藏

所以 brief line 回答的问题其实是：

- “在 brief-only idle 这一刻，要不要用最少的字数告诉你有红色告警，以及总共有多少背景任务还在跑？”

它不是：

- 连接状态全表
- 任务来源全表
- transcript 的另一种视图

因此这一层是：

- lossy summary projection

不是：

- authoritative status table

## 第五层：`warning -> reconnect()` 与 `remoteConnectionStatus='reconnecting'` 不是同一个事件

这一步最容易被写错。

timeout 回调直接做的是：

- 写 warning transcript
- 调 `manager.reconnect()`

但把 `remoteConnectionStatus` 改成：

- `reconnecting`

并不是在这里发生的。

它是在更后面那条链里发生：

- `manager.reconnect()`
- 底层 WebSocket 进入自己的 reconnect path
- `onReconnecting`
- `setConnStatus('reconnecting')`

所以 warning 和 `reconnecting` 的关系更准确地说是：

- 相关
- 但不是同一步

这就解释了为什么更稳的写法应该是：

- warning 是 transcript 上的补救提示
- `reconnecting` 是 AppState 上的 lifecycle 槽位

而不是：

- “warning 就等于连接态已经进入 reconnecting”

## 第六层：`viewerOnly` 路径进一步证明这四样不是同一张表

`RemoteSessionManager.ts` 对 `viewerOnly` 的注释写得非常清楚：

- 60s reconnect timeout is disabled
- `Ctrl+C` interrupt disabled
- session title never updated

而 `useRemoteSession.ts` 的 watchdog 也明确：

- `if (!config?.viewerOnly) { ... start timeout ... }`

这意味着 attached viewer 这条路径可以出现：

- `remoteConnectionStatus = 'reconnecting'`
- brief line 上出现 `Reconnecting…`

但完全不会出现：

- timeout warning transcript

因为那条账从一开始就没开。

如果 warning 和 connection status 真是一张表的两种渲染，

这种现象就解释不通。

恰恰因为它们是：

- 两张不同的账

viewer path 才能天然地拥有：

- brief reconnect
- no warning transcript

## 第七层：因此 remote session 里不是“一张 status table 四处消费”，而是“四张账最后相邻摆在前台”

把前面几层压成一句，最稳的一句其实是：

- these are four ledgers, not one table

大致可以压成下面这张矩阵：

| 对象 | 写入位置 | 当前回答什么 |
| --- | --- | --- |
| `warning transcript` | `messages` | 本地 watchdog 是否发起补救提示 |
| `remoteConnectionStatus` | `AppState.remoteConnectionStatus` | WS lifecycle 当前阶段 |
| `remoteBackgroundTaskCount` | `AppState.remoteBackgroundTaskCount` | 远端事件流所见的活跃任务数 |
| brief line | UI summary projection | 把前两张账的一部分再压成最小可见摘要 |

它们会相邻出现，

但不等于：

- 共享同一 owner
- 共享同一写路径
- 共享同一粒度

## 第八层：为什么它不是 122、130 的重复页

### 它不是 122

122 讲的是：

- watchdog
- warning
- `reconnecting`
- `disconnected`

为什么不是同一条 recovery lifecycle。

131 讲的是：

- warning transcript
- connection status slot
- background count slot
- brief summary

为什么不是同一张 status ledger。

一个讲：

- lifecycle ordering

一个讲：

- accounting ownership

### 它不是 130

130 讲的是：

- `remoteSessionUrl`
- brief line
- bridge pill
- bridge dialog
- attached viewer

为什么不是同一种 surface presence。

131 讲的不是：

- 哪个 surface 在签 presence

而是：

- 哪一类信号记在哪张账里

一个讲：

- presence signing

一个讲：

- status accounting

## 第九层：最常见的假等式

### 误判一：transcript 里的 warning 就等于 `remoteConnectionStatus='reconnecting'`

错在漏掉：

- warning 和 `setConnStatus('reconnecting')` 不是同一写路径

### 误判二：没有 warning，就说明当前连接一直健康

错在漏掉：

- `viewerOnly` 路径可以有 brief reconnect，却没有 watchdog warning

### 误判三：`remoteBackgroundTaskCount` 就是本地 `AppState.tasks` 的长度

错在漏掉：

- viewer 的本地 `tasks` 为空，remote count 是另一张账

### 误判四：brief line 就是完整 remote 真相面

错在漏掉：

- brief line 只显示 `reconnecting` / `disconnected`
- 右侧数字还是 merged aggregate

### 误判五：四样东西都写在 AppState，所以只是同一表的不同列

错在漏掉：

- warning transcript 根本写在 `messages`

## 第十层：stable / conditional / internal

### 稳定可见

- `warning transcript` 当前属于 transcript message 链
- `remoteConnectionStatus` / `remoteBackgroundTaskCount` 当前是独立 `AppState` 槽位
- brief line 当前只消费状态，不生产状态

### 条件公开

- warning 只在 timeout watchdog 开启时出现，而 watchdog 当前会跳过 `viewerOnly`
- `remoteBackgroundTaskCount` 当前只保证 best-effort，reconnect / disconnect 会主动清零以防 stale
- brief line 只在 brief-only idle 条件满足时出现，而且会隐藏 `connecting` / `connected`

### 内部 / 灰度层

- `scheduleReconnect()` 和 `reconnect()` 的具体关系
- reconnect 期间 transcript warning 与 AppState 连接态可能短暂失配
- brief 右侧 aggregate 的具体合并公式

这些更适合作为：

- 当前实现证据

而不是：

- 对外稳定承诺

## 第十一层：苏格拉底式自审

### 问：我现在写的是 transcript 账，还是 AppState 槽位？

答：如果答不出来，就把 warning 和 connection status 混了。

### 问：我是不是把 remote task count 写成了本地任务表？

答：如果是，就把 `remoteBackgroundTaskCount` 和 `tasks` 混了。

### 问：我是不是把 brief line 当成了完整 truth surface？

答：如果是，就把 summary projection 写成 authoritative ledger 了。

### 问：我是不是把 `viewerOnly` 路径的 absence 错写成了“系统从不恢复”？

答：如果是，就把 warning ledger 的关闭偷换成了 recovery ledger 的关闭。

### 问：我是不是把 122 的 lifecycle 再次抄成了 131 的 status accounting？

答：如果是，就还没有把“流程”和“账”拆开。

## 源码锚点

- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
- `claude-code-source-code/src/components/Spinner.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/utils/messages.ts`
- `claude-code-source-code/src/utils/task/framework.ts`
- `claude-code-source-code/src/components/messages/SystemTextMessage.tsx`
