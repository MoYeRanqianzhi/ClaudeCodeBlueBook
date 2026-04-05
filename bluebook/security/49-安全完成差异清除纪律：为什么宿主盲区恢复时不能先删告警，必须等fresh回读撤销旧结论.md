# 安全完成差异清除纪律：为什么宿主盲区恢复时不能先删告警，必须等fresh回读撤销旧结论

## 1. 为什么在 `48` 之后还要继续写“清除纪律”

`48-安全完成差异交互路由` 已经回答了：

`宿主盲区一旦变化，卡片、通知、动作和清除条件必须一起联动。`

但如果继续往更深一层追问，  
还会出现一个更危险的问题：

`什么证据出现之后，系统才有资格撤销旧结论、删除旧告警、重新放开旧动作？`

因为安全控制面最容易做错的地方，  
往往不是：

`风险升得不够快`

而是：

`恢复说得太快。`

也就是说，  
前一章虽然已经把“清除条件”放进了交互路由，  
但还没有把这件事单独上升成一条控制面公理：

`恢复不是把告警藏起来，而是用足够强的新鲜证据撤销旧结论。`

所以这一章要补的是：

`安全完成差异清除纪律。`

## 2. 最短结论

从源码看，Claude Code 在多个关键位置都已经体现出同一种成熟倾向：

1. 旧状态不会因为“看起来恢复了”就立刻被清掉  
   `src/context/notifications.tsx:78-116,172-213`
2. 恢复必须和真实 restore / hydrate 排序绑定  
   `src/cli/print.ts:5048-5055`
3. crash residue 与 stale metadata 必须在新会话 init 时被显式清理  
   `src/cli/transports/ccrClient.ts:474-522`
4. recovery 窗口里宁可丢弃 control/result，也不提前宣布恢复  
   `src/bridge/remoteBridgeCore.ts:824-879`
5. `session_state_changed(idle)` 被定义成 authoritative turn-over  
   `src/utils/sdkEventQueue.ts:56-66`
6. `files_persisted` 还被单独做成一类事件，而不是混在普通 result 里  
   `src/cli/print.ts:2261-2267`

所以这一章的最短结论是：

`对宿主盲区来说，降级可以基于风险迹象，恢复必须基于fresh回读。`

换句话说：

`安全控制面应当“快速怀疑，缓慢原谅”。`

## 3. 源码已经在多处拒绝“抢先恢复”

## 3.1 通知系统的删除本身就是显式动作，而不是自然蒸发

`src/context/notifications.tsx:78-116` 说明 `immediate` 通知替换当前内容时，  
系统会显式：

1. 清 timeout
2. 重排旧 current
3. 过滤被 `invalidates` 指定失效的旧通知

`src/context/notifications.tsx:172-213` 又说明：

1. 非 `immediate` 项只有在显式 `invalidatesCurrent` 时才清当前项
2. `removeNotification()` 也是显式删 key
3. 删除后还要重新 `processQueue()`

这说明在 Claude Code 里，  
连“删一条通知”都不是无条件自然发生的。  
它背后的默认哲学是：

`旧提示只有在明确失效时才配被移除。`

这正是清除纪律的第一层。

## 3.2 CCR 初始化会先清理 stale metadata，再谈 state restored

`src/cli/transports/ccrClient.ts:474-522` 很关键。  
在 worker 初始化时，系统会：

1. 并发取回旧 worker state
2. 先发新的 `PUT /worker`
3. 显式把 `pending_action` 和 `task_summary` 清成 `null`
4. 然后才在成功后记录 `cli_worker_state_restored`

源码注释写得很清楚：  
这是为了防 prior crash 留下的 stale residue，  
也为了避免在 init 失败时错误地同时记录 “init_failed” 和 “state_restored”。

这说明作者非常在意一件事：

`恢复声明不能跑在真正初始化成功之前。`

也就是说，  
清理旧脏状态不是“界面美化”，  
而是：

`恢复资格的一部分。`

## 3.3 `print.ts` 会等待 restore 与 hydration 一起完成，避免 fresh default 冒充真实恢复

`src/cli/print.ts:5048-5055` 更像一条教科书级证据。  
源码明确写道：

`Await restore alongside hydration so SSE catchup lands on restored state, not a fresh default.`

这句话几乎可以直接压成清除纪律的底层公理：

`如果后续状态流落在 fresh default 上，而不是落在 restored state 上，系统就会过早把“空白”误当成“已恢复”。`

也就是说，  
Claude Code 已经明确反对：

`先把旧状态清空，再等增量事件慢慢回来。`

因为那样会制造一种最危险的乐观：

`不是状态真的好了，而是旧坏状态被过早遗忘了。`

## 3.4 401 recovery 窗口中，bridge 明确选择“丢弃”而不是“假恢复”

`src/bridge/remoteBridgeCore.ts:824-879` 也很关键。  
在 `authRecoveryInFlight` 时，系统会直接：

1. drop `control_request`
2. drop `control_response`
3. drop `control_cancel_request`
4. drop `result`

只有不在 recovery 窗口时，  
`sendResult()` 才会 `reportState('idle')` 并发送结果。

这说明作者已经在 bridge 层明确做出了一个偏保守、但非常成熟的选择：

`宁可暂时不交付结果，也不在恢复窗口里把局部进展错说成恢复完成。`

这正是清除纪律的第二层：

`恢复中的沉默，好过恢复中的假完成。`

## 3.5 turn over 也被要求有 authoritative signer

`src/utils/sdkEventQueue.ts:56-66` 明确写道：

1. `session_state_changed(idle)` 是 authoritative 的 turn-over signal
2. 它发生在 heldBackResult flush 和 bg-agent loop 退出之后

这意味着：

`idle` 不是一个“看上去大概差不多了”的 UI 词，  
而是一个被延后到关键清理点之后的正式签字。`

换句话说，  
Claude Code 对“何时算结束”已经很谨慎。  
这条谨慎同样应该推广到：

`何时算可以撤销旧盲区。`

## 3.6 `files_persisted` 被单独发事件，说明“结果到了”也不等于“所有后续后果都已完成”

`src/cli/print.ts:2261-2267` 会单独 enqueue：

`files_persisted`

这说明系统没有把：

1. 结果产生
2. 文件落盘
3. turn over

混成一个“都算完成”的粗糙时刻。

所以对清除纪律来说，  
也应坚持同样原则：

`能撤销哪一层旧结论，要看哪一层新证据真的到了。`

## 4. 第一性原理：安全系统最危险的时刻，不是发现风险，而是决定何时忘记风险

如果从第一性原理追问：

`为什么恢复阶段比报警阶段更容易出事故？`

因为报警阶段通常遵守的是：

`宁严勿松。`

而恢复阶段最容易滑向：

`差不多就当它好了。`

但安全控制面一旦这样做，  
用户看到的就不再是“恢复中”，  
而是“已经恢复”。

所以清除纪律真正保护的是这条底层公理：

`旧风险不是因为时间流逝而失效，而是因为足够强的新证据到达才失效。`

这条公理可以压成一句话：

`撤销也是一种签字。`

## 5. 我给统一安全控制台的清除纪律规则

## 5.1 降级可以快，恢复必须慢

也就是：

1. 发现盲区扩大，可以先降级
2. 发现盲区缩小，不能先恢复
3. 必须等 fresh 回读、fresh hydrate 或 authoritative signer 到位后再恢复

## 5.2 先撤销动作限制，后改卡片，是错误顺序

正确顺序应当是：

1. 新鲜证据到位
2. 主卡结论恢复
3. 动作入口恢复
4. 旧通知与旧告警清除

如果先恢复动作，  
用户会在控制面尚未统一前先获得过宽权限。

## 5.3 “连接恢复”不等于“解释恢复”

这是最容易犯的错。  
尤其是 bridge / host 场景里：

1. transport 可能恢复了
2. read chain 未必恢复
3. restore / hydrate 未必完成
4. stale metadata 未必清掉

所以任何“已恢复”文案都不能只建立在连接词上。

## 5.4 删除旧告警必须绑定同一条原因链的消失

如果旧告警是因为：

1. `missing_ledgers[]`
2. `completion_claim_ceiling` 下调
3. recovery window 打开
4. 某 subtype 不可用

那就必须由同一条因果链上的新证据来清除。  
不能因为另一个表面状态恢复，就顺手把旧告警一起删了。

## 6. 把这条纪律重新压回宿主盲区控制面

我会把统一安全控制台里的“清除权限”压成下面四层。

### 6.1 通知清除权

只有在：

1. 当前 key 被显式 invalidated
2. 或原因链被显式确认消失

时，才允许清除当前通知。

### 6.2 卡片恢复权

只有在：

1. 主导盲区字段恢复
2. 相关缺失账本补齐
3. 解释 ceiling 回升

之后，卡片才配改口。

### 6.3 动作恢复权

动作恢复的门槛应比通知清除更高。  
因为一旦动作放开，  
用户就会立刻把系统当真。

### 6.4 结论恢复权

这是最高门槛。  
它要求：

1. authoritative state
2. fresh 回读
3. 必要时完成落盘或 turn-over

至少满足其中对应层级。

## 7. 技术先进性与技术启示

这一章最重要的技术判断是：

`Claude Code 在多个层次都已经体现出“反抢先恢复”的工程纪律。`

它先进的不只是会降级，  
而是已经知道：

1. stale residue 必须先清掉  
   `ccrClient.ts:482-487`
2. restore 与 hydrate 需要一起等待  
   `print.ts:5050-5055`
3. recovery 窗口里应主动 drop 某些输出  
   `remoteBridgeCore.ts:824-879`
4. turn-over 要等 authoritative idle  
   `sdkEventQueue.ts:56-66`
5. result 与 files persisted 不能混成一个时刻  
   `print.ts:2261-2267`

对其他 Agent 平台构建者，这里最重要的启示有四条：

1. 告警撤销逻辑必须和恢复逻辑同等正式
2. stale cleanup 不是运维细节，而是安全语义
3. 恢复窗口内宁可降吞吐，也不要假恢复
4. 结束信号、持久化信号、解释恢复信号必须分层

## 8. 哲学本质

这一章更深层的哲学是：

`真正保守的系统，不是更喜欢报警，而是更不愿意过早忘记报警。`

很多系统的问题不是“没有风险提示”，  
而是：

`一旦表面恢复，旧风险就被过快地抹掉。`

Claude Code 里那些关于 stale、restore、hydrate、recovery、idle signer 的细节，  
背后其实都在表达同一种哲学：

`遗忘必须比怀疑更难。`

从第一性原理看，  
这保护的是下面这条根本公理：

`如果撤销旧结论比建立新结论更容易，系统最终一定会滑向乐观谎言。`

## 9. 苏格拉底式反思：这一章最容易犯什么错

### 9.1 会不会把系统做得过于保守，导致恢复太慢

会。  
所以关键不是“永远不清”，  
而是：

`清除门槛必须和误导成本匹配。`

### 9.2 会不会把所有清除都绑定到最强 signer，导致轻微提示也拖太久

也会。  
因此应区分：

1. 通知清除权
2. 卡片恢复权
3. 动作恢复权
4. 结论恢复权

不同层级对应不同强度的恢复证据。


## 10. 结语

`48` 解决的是：宿主盲区变化时，多个界面对象必须一起改口。  
这一章继续推进后的结论则是：

`它们还必须一起遵守同一套清除纪律，不能因为表面恢复就过早删掉旧结论。`

这意味着 Claude Code 更深层的安全启示之一是：

`成熟控制面不仅会在风险到来时说“不”，也会在恢复到来时谨慎决定什么时候才配重新说“可以”。`
