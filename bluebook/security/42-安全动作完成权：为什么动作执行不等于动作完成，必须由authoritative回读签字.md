# 安全动作完成权：为什么动作执行不等于动作完成，必须由 authoritative 回读签字

## 1. 为什么在 `41` 之后还要继续写“动作完成权”

`41-安全动作归属` 已经回答了：

`正确动作还必须绑定正确主体、正确写入层和正确持续时间。`

但如果继续往第一性原理再压一层，  
还会剩下最后一个更严苛的问题：

`谁有资格说这条动作已经完成了？`

因为从源码看，  
一条动作至少会经历几层完全不同的状态：

1. 已建议
2. 已执行
3. 已写入
4. 已持久化
5. 已被 authoritative 状态面重新读回并承认

如果系统把前面任一层，  
都误写成最后一层，  
就会出现一种极其危险的假象：

`动作看起来已经做完了，但真正的控制面还没有签字。`

Claude Code 的源码在很多地方都在防这个。  
它不是只关心动作有没有发出去，  
也不是只关心本地 UI 有没有切状态。  
它更关心：

`哪一个信号才有资格被当成“完成”的权威凭据。`

所以这一章的核心问题是：

`Claude Code 为什么不把“动作被执行过”直接当成“动作已经完成”，而还要把完成权继续收口到 authoritative 回读？`

## 2. 最短结论

从源码看，Claude Code 的安全控制面依赖一条很成熟的完成纪律：

`动作执行不等于动作完成；只有被 authoritative 状态与回读链重新承认后，系统才应宣布完成。`

这至少体现在五类地方：

1. `session_state_changed(idle)` 被单独定义成 authoritative turn-over signal
2. going idle 之前必须先 flush internal events
3. 文件持久化被拆成独立的 `files_persisted` 事件，而不是偷塞进普通 result
4. queue drain 与 transport flush 被单独建模，且文档明确提醒“delivery confirmation”与“server state”不是一回事
5. 401 recovery 窗口会主动 drop control/result，拒绝在不可判定窗口里发出伪完成信号

所以这一章的最短结论是：

`Claude Code 的成熟，不只在于它会给动作、给主体、给作用域，还在于它把“谁能宣布动作已完成”继续收口成一条更严格的签字链。`

## 3. 什么叫“安全动作完成权”

这里说的“完成权”，不是谁最后点了按钮。  
我在这一章里的定义是：

`系统中有资格把某条动作从“已执行”升级为“已完成”的那条 authoritative 证明链。`

一个成熟的完成权至少要回答四件事：

1. 动作何时算开始执行
2. 动作何时只是排队或在路上
3. 动作何时真的被写入目标层
4. 哪一个信号才配被当成最终完成信号

如果缺这四句，  
宿主和用户最容易犯的错就是把：

`看见局部副作用`

误读成：

`整条动作已经完成。`

## 4. 第一类完成权：`idle` 不是空闲文案，而是 authoritative turn-over signal

## 4.1 schema 自己就把 `session_state_changed(idle)` 写成权威信号

`src/entrypoints/sdk/coreSchemas.ts:1738-1746` 非常关键。  
这里 `session_state_changed` 的 `state` 只有：

1. `idle`
2. `running`
3. `requires_action`

但更重要的是它的描述直接写明：

`'idle' fires after heldBackResult flushes and the bg-agent do-while exits — authoritative turn-over signal.`

也就是说，  
作者非常明确地告诉下游：

`不要把“看起来暂时没输出了”当成完成。`

真正可被信赖的完成信号，  
是这条单独的 `idle` 事件。

## 4.2 `sdkEventQueue.ts` 用同一句话重复强调这不是普通状态切换

`src/utils/sdkEventQueue.ts:56-61` 再次把它写成：

`authoritative "turn is over" signal`

而且强调它发生在：

1. `heldBackResult` flush 之后
2. bg-agent do-while 退出之后

这说明在作者眼里，  
完成并不是某个 UI 时刻，  
而是：

`一串尚未彻底收口的后续工作都结束之后，才允许发出的最终判定。`

## 5. 第二类完成权：going idle 之前必须先 drain / flush，而不是先改状态

## 5.1 `print.ts` 明确先 `flushInternalEvents()`，再 `notifySessionStateChanged('idle')`

`src/cli/print.ts:2454-2466` 很关键。  
这里 finally 块不是先切 idle，  
而是先做：

`await structuredIO.flushInternalEvents()`

然后才：

`notifySessionStateChanged('idle')`

并且紧接着注释继续解释：

1. 先让 idle 的 SDK event 到达输出流
2. 再阻塞等待下一个 command
3. 因为下次 drain 可能迟迟不会发生

这说明完成权在这里被编码成一种很明确的顺序纪律：

`先把该送达的内部事实送达，再允许系统宣布“现在 idle 了”。`

## 5.2 这说明“状态切换”本身没有天然完成权

很多系统喜欢在 UI 上一收尾就把状态切回 idle。  
Claude Code 没有这么做。  
它更接近另一种更严格的理解：

`如果还有 pending internal events 没冲出去，那 idle 仍然说早了。`

## 6. 第三类完成权：文件持久化被单独建模，不允许结果消息冒充落盘确认

## 6.1 `SDKFilesPersistedEventSchema` 把 persistence confirmation 独立成专门事件

`src/entrypoints/sdk/coreSchemas.ts:1672-1692` 明确给出：

1. `files`
2. `failed`
3. `processed_at`

这说明作者非常清楚：

`文件相关动作的“执行完成”与“持久化完成”不是一回事。`

如果只是普通 result 或摘要文案，  
你最多知道动作跑过了；  
但 `files_persisted` 才在说：

`哪些文件真的持久化了，哪些失败了，以及处理时间是什么。`

## 6.2 `print.ts` 也是在异步持久化结果回来后才发这条事件

`src/cli/print.ts:2260-2269` 里，  
`files_persisted` 并不是普通助手输出的一部分，  
而是在持久化回调里额外 enqueue 出来的。

这进一步说明：

`作者不愿让“动作已经生成某个结果”直接冒充“结果已经落成文件事实”。`

## 6.3 这是一条非常成熟的完成语义

因为对很多安全相关动作而言，  
真正重要的并不是：

`我试图写了。`

而是：

`哪些对象真的被 authoritative 文件层承认了。`

## 7. 第四类完成权：queue flush 也不是完成本身，只是逼近完成的前提

## 7.1 `flushInternalEvents()` 的注释说得非常克制

`src/cli/transports/ccrClient.ts:816-821` 只说：

`ensure transcript entries are persisted`

而 `src/cli/transports/ccrClient.ts:824-829` 对 `flush()` 更进一步强调：

1. caller 需要 delivery confirmation 时才调用
2. close 会 abandon queue
3. 即使 flush 结束，也要 `check server state separately if that matters`

这句最后的话极其关键。  
它说明作者不接受一种偷懒逻辑：

`只要本地 queue drain 了，就算远端状态已经完成。`

他们明确把两层区分开：

1. 交付层是否已尽力送出
2. 服务器状态是否真的已经反映这一事实

## 7.2 `FlushGate` 进一步说明 queued 不是 committed

`src/bridge/flushGate.ts:1-15` 把 initial flush 期间的新消息定义成：

1. 先 queue
2. flush 结束后再 drain
3. 必要时还能 drop

这说明在作者眼里，  
只要一个事实还处在 gate 后面的 pending 队列里，  
它就仍然没有完成权。

换句话说：

`进入队列不是完成，离开队列也不是完成，只有被正确 drain 并被下游状态重新承认，才更接近完成。`

## 8. 第五类完成权：恢复窗口里主动拒绝宣布完成

## 8.1 `remoteBridgeCore.ts` 在 401 recovery 里直接 drop control/result

`src/bridge/remoteBridgeCore.ts:824-878` 非常关键。  
源码明确写出在 `authRecoveryInFlight` 时会：

1. drop `control_request`
2. drop `control_response`
3. drop `control_cancel_request`
4. drop `result`

这说明恢复窗口不是普通的“暂时不稳定”。  
它在完成语义上的真正含义是：

`当前任何看似像完成的东西，都不配被继续对外宣布。`

## 8.2 这是一种很高阶的诚实

很多系统在恢复窗口最爱做的就是：

`先把结果报出去，等恢复好了再补。`

Claude Code 这里的选择恰恰相反：

`宁可暂时什么都不算，也不让不可靠窗口生成伪完成声明。`

这说明成熟控制面不仅会授予完成权，  
还会在条件不成立时主动撤销完成权。

## 9. 第六类完成权：启动时先清 stale pending_action，拒绝沿用旧完成假象

`src/cli/transports/ccrClient.ts:473-488` 很有代表性。  
worker 初始化时，它一边读 `restoredPromise`，  
一边 PUT：

1. `worker_status: 'idle'`
2. `pending_action: null`
3. `task_summary: null`

注释还明确写出这是为了：

`Clear stale pending_action/task_summary left by a prior worker crash`

这说明作者非常清楚：  
动作完成权不仅要防“过早宣布完成”，  
还要防另一种相反错误：

`把旧进程遗留下来的未完成 / 半完成假象错误继承到新进程。`

也就是说，  
完成权不是一次性瞬间，  
而是一条需要在恢复、重启和接管时被重新校准的权威语义。

## 10. 把这些例子压成一条底层公理

我会把这一章压成一句话：

`安全动作的完成，必须由 authoritative 回读链签字，而不能由局部执行痕迹代签。`

这条公理几乎能统一前面所有例子：

1. `idle` 要等 authoritative turn-over signal
2. going idle 前要先 flush internal events
3. 文件持久化要靠独立的 persisted event
4. queue drain 不是 server state completion
5. recovery 窗口必须撤销完成权
6. 重启接管时要先清 stale pending_action

所以在 `40` 和 `41` 之后，  
控制面更深层的主线已经变成：

`状态 -> 动作 -> 归属 -> 完成签字权`

## 11. 技术先进性与技术启示

这一章最重要的技术判断是：

`Claude Code 的先进性，不只是把状态和动作 typed 化，还把“完成”本身单独做成一套可审计的语义层。`

这会带来几个很强的工程收益：

1. 宿主不容易把临时空闲误判成真正完成
2. 文件层、事件层和状态层不会被粗暴压成单一 done 标志
3. 恢复窗口更不容易产生伪成功或伪完成
4. 重启接管时不会把陈旧 metadata 当成当前事实
5. 下游系统能围绕 authoritative completion signal 做更稳的编排

这对其他 Agent 平台构建者的启示也很直接：

1. 不要把“执行过”直接当成“完成”
2. 不要把 queue drain 直接当成“远端已承认”
3. 要为 persistence confirmation 设计独立信号
4. 要在 recovery 窗口主动暂停完成声明
5. 要为完成语义设计明确 signer，而不是让任何局部副作用都能代签

## 12. 哲学本质

这一章更深层的哲学是：

`完成不是事件残影，而是权威承认。`

很多系统以为只要看到：

1. 结果已经生成
2. 队列已经发出
3. UI 已经切回 idle

就可以说“已经做完”。  
Claude Code 的源码更接近另一种成熟认识：

`只要 authoritative 链条还没回读承认，完成就仍然只是候选状态。`

这意味着控制面的成熟，  
不只在于它能发起动作，  
也不只在于它能约束动作归属，  
还在于它能回答：

`到底谁有资格签字说，这件事现在真的完成了。`

从第一性原理看，  
这其实是在保护一个更深的公理：

`没有签字权的局部事实，不应拥有完成解释权。`

## 13. 苏格拉底式反思：这一章最容易犯什么错

### 13.1 我们会不会把一些事件顺序写得过度形而上

有风险。  
但这里不是普通事件顺序，而是源码注释里反复出现的 `authoritative`、`flush`、`persisted`、`check server state separately`。

### 13.2 这会不会和前面的提交语义、多账本章节重复

有交叉。  
但前面更关注事实账本与提交层；  
这一章更关注：

`一条具体动作何时配被宣布完成。`

它是在把前面的账本思想重新压回动作语义。

### 13.3 这一章之后还缺什么

还缺一层更苛刻的问题：

`完成被签字之后，哪些宿主有资格把它投影给用户，哪些宿主只能转述局部完成。`

也就是说，  
下一步如果继续推进，  
最自然的方向会是：

`完成签字权如何跨宿主投影，以及哪里最容易再次被压扁。`

## 14. 结语

`41` 回答的是：正确动作必须由正确主体在正确层执行。  
这一章继续推进后的结论则是：

`即使动作已经由正确主体执行，也仍然不能直接宣布完成，必须等 authoritative 回读链签字。`

这意味着 Claude Code 更深层的安全启示之一是：

`真正可靠的控制面，不只是会给动作、给归属，还会严格限制谁能宣布“现在已经做完”。`
