# 安全恢复续租信号：为什么绿色词必须靠heartbeat、poll、refresh与recheck持续续租，而不是一次观察永久有效

## 1. 为什么在 `64` 之后还要继续写“续租信号”

`64-安全恢复绿色词租约` 已经回答了：

`active、connected、ready 这类绿色词本质上都是可撤销租约，而不是永久承诺。`

但如果继续往下一层追问，  
还会出现一个更操作化的问题：

`既然它们是租约，那系统到底靠什么给这些绿色词续租？`

因为只说“它是租约”，  
还不够。  
如果没有明确的续租信号，  
这个概念就容易退化成抽象比喻。  
而从控制面角度，  
一个租约至少要回答三件事：

1. 靠什么续租
2. 多久续租一次
3. 续租失败时怎么降级

所以在 `64` 之后，  
统一安全控制台还必须再补一条制度：

`恢复续租信号。`

也就是：

`绿色词只有在 heartbeat、poll、refresh、recheck 等续租信号持续成功时才应继续成立；一旦续租链中断，就必须准备降级或撤销。`

## 2. 最短结论

从源码看，Claude Code 的不少正向状态已经在依赖持续续租，而不是一次成功后长期保留：

1. `CCRClient` 在初始化后会启动 heartbeat 定时器，持续用 `/worker/heartbeat` 保活  
   `src/cli/transports/ccrClient.ts:453-520,677-721`
2. bridge 的 crash-recovery pointer 会按小时 refresh mtime，防止“旧 pointer 被误当新租约”  
   `src/bridge/bridgePointer.ts:22-34,56-70`、`src/bridge/bridgeMain.ts:2700-2728`
3. bridge 的 active work items 会通过 `heartbeatWork()` 和 token re-dispatch 持续续租，不成功就退回 auth_failed / failed / fatal 分支  
   `src/bridge/bridgeMain.ts:198-275`
4. `useTasksV2` 会在 incomplete 状态下持续 poll，在“看似 completed”后还要 recheck，才允许隐藏  
   `src/hooks/useTasksV2.ts:138-170`

所以这一章的最短结论是：

`绿色词的成立不是一次性认证，而是持续续租。`

我会把这条结论再压成一句话：

`正向状态不是快照真理，而是被续租维持的临时事实。`

## 3. 源码已经证明：系统广泛依赖“持续续租”而不是“一次观察”

## 3.1 CCR worker 的绿色存活词依赖 heartbeat 续租

`src/cli/transports/ccrClient.ts:453-520` 里，  
worker 初始化一旦成功，  
就会立刻：

1. 写入 `worker_status: 'idle'`
2. 启动 `startHeartbeat()`
3. 注册 in-flight `keep_alive`

`src/cli/transports/ccrClient.ts:677-721` 更明确：

1. heartbeat 以固定 interval + jitter 持续调度
2. `sendHeartbeat()` 会向 `/worker/heartbeat` 发保活请求
3. 如果 timer 被 stop，续租即终止

这说明在 worker 域里，  
所谓“活着”“可继续工作”并不是一次 register 之后就永久成立，  
而是：

`靠持续 heartbeat 续租的短期绿色状态。`

## 3.2 bridge pointer 不是一次写入永久有效，而是靠 refresh mtime 续租

`src/bridge/bridgePointer.ts:22-34,56-70` 已经把这条逻辑写得非常直白：

1. pointer 写入后不会被视为永久新鲜
2. staleness 看的是 file mtime
3. 同内容重复写入也算 refresh

`src/bridge/bridgeMain.ts:2700-2728` 则把它落成具体实现：

1. pointer 先立即写一次
2. 然后每小时刷新一次
3. 目的就是让长会话 crash 后仍有 fresh trail

这说明就连 crash-recovery pointer 这种“看似静态”的对象，  
也不是永久真理，  
而是：

`靠周期性 refresh 维持有效租约。`

## 3.3 bridge active work 的正向存活同样依赖持续 heartbeat 与失败分支

`src/bridge/bridgeMain.ts:198-275` 进一步把续租思想推进到 active work。

这里的 `heartbeatActiveWorkItems()` 会：

1. 对 active session 的 work item 逐个 `heartbeatWork()`
2. 成功则维持 `ok`
3. 401/403 则转 `auth_failed`
4. 404/410 则转 `fatal`
5. 其他情况则可能落到 `failed`

更关键的是，  
auth_failed 还会主动触发 `reconnectSession()`，  
让下一轮 poll 重新派发 fresh token。

这说明 bridge 的正向工作态并不是“当前列表里有 active session 就算稳了”，  
而是：

`只要续租失败，系统就必须立刻准备降级、重派发或退出。`

## 3.4 task “完成”也依赖 recheck，不是一次观察就永久生效

`src/hooks/useTasksV2.ts:138-170` 是一个很好的非网络例子。

这里系统在看到：

`all tasks completed`

之后，并不会马上把它当成永久已完成。  
它会：

1. 启动 hide timer
2. 到点后再重新 `listTasks()`
3. 只有 `allStillCompleted` 才真正 `resetTaskList()`

同时，  
如果仍有 incomplete task，  
系统就继续 fallback poll。

这说明哪怕是一个本地 UI 对象，  
作者也在默认使用：

`看起来完成了 -> 进入续租观察期 -> 再确认 -> 再隐藏`

这和前面的 heartbeat/pointer refresh 在结构上是同一种思想。

## 4. 第一性原理：绿色词之所以需要续租，是因为系统永远无法用一次观察买断未来

如果从第一性原理追问：

`为什么控制面不能用一次成功就永久保留一个绿色词？`

因为任何一次观察都只能证明：

`它在那个瞬间是对的。`

但控制面面对的是持续运行的现实。  
而持续运行的现实意味着：

1. token 会过期
2. transport 会断
3. pointer 会变 stale
4. 本地状态会再次变化

所以一个成熟系统必须承认：

`未来会继续到来，旧观察会逐渐失效。`

这就是续租信号存在的根本理由。

## 5. 我给统一安全控制台的“续租信号模型”

我会把它压成四条规则。

## 5.1 每个绿色词都应绑定一种续租信号

例如：

1. heartbeat
2. poll
3. refresh
4. recheck

## 5.2 每个续租信号都应有失败分支

也就是：

1. 失败后降什么词
2. 是否转人工确认
3. 是否直接撤销绿色词

## 5.3 续租周期应与对象风险匹配

例如：

1. worker liveness 需要持续 heartbeat
2. pointer freshness 需要小时级 refresh
3. task completion 需要短窗 recheck

## 5.4 没有续租信号的绿色词默认不可信

如果某个正向词既没有 renewal condition，  
也没有 revocation path，  
那它本质上只是一个未经治理的乐观文案。

## 6. 技术先进性与技术启示

这一章最重要的技术判断是：

`Claude Code 的先进性不只在于它接受“绿色词是租约”，还在于它在多个层面都已经布置了真实的续租信号。`

当前先进的地方：

1. worker 有 heartbeat
2. bridge pointer 有 refresh mtime
3. active work 有 heartbeat + token redelivery
4. task 完成有 recheck

当前仍待系统化的地方：

1. 这些续租信号还没有被统一抽象成同一套绿色词治理语言
2. 不同绿色词的续租周期还没形成明确层级表
3. 缺少一张正式的“词 -> 续租信号 -> 失败分支”总表

这对其他 Agent 平台构建者的直接启示有五条：

1. 绿色词必须绑定 renewal signal
2. renewal signal 必须绑定 downgrade path
3. 不同对象的续租节奏应按风险分层
4. 续租失败应优先触发撤词，而不是继续乐观保留旧词
5. 将 heartbeat / poll / refresh / recheck 统一理解为“绿色词续租原语”

## 7. 哲学本质

这一章更深层的哲学是：

`成熟系统不会试图用一次成功冻结未来。`

它知道未来会继续带来新证据，  
因此它不会把“刚刚还对”误写成“以后都对”。  
相反，  
它会持续为自己的正向词缴纳续租成本。

## 8. 苏格拉底式反思：这一章最需要追问什么

### 8.1 为什么续租听起来像实现细节，但其实是认识论问题

因为它回答的是“系统凭什么继续声称这个词还成立”。

### 8.2 为什么一次 register / connect / complete 不够

因为这些都只是时间点事件，不是未来保证。

### 8.3 真正危险的错误是什么

不是绿色词短一点，  
而是：

`系统在没有持续续租成功的情况下，继续保留旧的绿色词。`


## 9. 结语

`64` 回答的是：绿色词本质上是可撤销租约。  
这一章继续推进后的结论则是：

`这些租约必须靠 heartbeat、poll、refresh 与 recheck 持续续租；没有续租信号的绿色词，不应继续被信任。`

这意味着 Claude Code 更深层的安全启示之一是：

`成熟控制面不仅要把绿色词设计成可撤销，还要把它们设计成必须持续续租。`
