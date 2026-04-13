# success `result` `ignored`、error `result` visible、`isSessionEndMessage`、`setIsLoading(false)` 与 permission pause：为什么 direct connect 的 visible result、turn-end 判定与 busy state 不是同一种 completion signal

## 用户目标

115 已经讲清：

- `convertToolResults`
- `convertUserTextMessages`
- success `result -> ignored`

虽然都发生在 adapter 附近，却不是同一种 consumer policy。

但继续往下读时，读者仍然很容易把另一组相邻概念重新压平：

- success `result` 被静默
- error `result` 会显示
- `isSessionEndMessage(...)` 命中 `result`
- `setIsLoading(false)` 在 `result` 到来时执行

于是正文就会滑成一句似是而非的话：

- “direct connect 里一旦到 `result`，系统就在用同一个 completion signal 同时完成显示、收口和状态更新。”

从当前源码看，这也不成立。

这里至少有三层不同问题：

1. transcript 里要不要显示一条结果消息
2. 当前 turn 在 hook 看来是否已经结束
3. UI 眼下是否还在等待服务器继续工作

这三层都和“完成”有关，但不是同一种 completion signal。

还有一个前提必须先钉死：

- `result` 不是 direct connect 私有补丁对象
- 它本来就是 public SDK message family 的成员
- direct-connect manager 也不会先把它从 callback 面滤掉

所以这页真正要拆的不是：

- “系统到底有没有把 `result` 送到前端”

而是：

- “同一个 callback-visible `result`，为什么会在相邻层里承担不同的 completion semantics”

## 第一性原理

更稳的提问不是：

- “它是不是表示完成了？”

而是先问五个更底层的问题：

1. 当前说的是 transcript-visible outcome，还是 hidden state transition？
2. 当前判断的是“结果要不要显示”，还是“这一轮是否结束”？
3. 当前状态变化是 terminal close，还是 temporary pause？
4. 当前 flag 回写描述的是 result semantics，还是 UI busy state？
5. 当前 object 被忽略，是否就表示它不再参与任何别的控制逻辑？

只要这五轴先拆开，下面几件事就不会再被写成同一个 completion contract。

## 第一层：adapter 的 `result` 分支回答的是 visible result policy

`sdkMessageAdapter.ts` 在 `result` 分支里做的事情非常具体：

- 非 success `result` -> `message`
- success `result` -> `ignored`

而注释也把理由写死了：

- success result 在 multi-turn session 里是 noise
- `isLoading=false` 已经是足够的 signal

所以 adapter 这里回答的不是：

- “这轮是不是结束了？”

而是：

- “这条 `result` 要不要落成 transcript 里的可见消息？”

这意味着：

- error `result` visible
- success `result` ignored

首先是一对 transcript policy。

不是 turn-end classifier。

更不是 UI busy-state machine。

## 第二层：`isSessionEndMessage(...)` 回答的是 coarse turn-end 判定

同一个文件里，`isSessionEndMessage(...)` 的定义非常粗：

- 只要 `msg.type === 'result'`，就返回 true

它既不区分：

- success / error

也不区分：

- 这条 `result` 会不会在 transcript 里显示

所以它的主语不是：

- visible result

而是：

- hook 层对“这一轮 result 已经到达”的粗粒度收口判断

这也解释了为什么：

- success `result` 虽然 adapter 会静默

但依旧可以：

- 被 `isSessionEndMessage(...)` 当成 session end message

于是这一层回答的是：

- turn-end classification

不是：

- transcript rendering

## 第三层：`useDirectConnect` 先做状态收口，再做 adapter 转换

`useDirectConnect.ts` 的 `onMessage` 顺序很关键：

1. 先检查 `isSessionEndMessage(sdkMessage)`
2. 命中就 `setIsLoading(false)`
3. 再处理 `system.init` 去重
4. 再把 `sdkMessage` 交给 `convertSDKMessage(...)`
5. 最后只在 `converted.type === 'message'` 时追加正文消息

这个顺序本身已经说明：

- busy-state release 早于 transcript policy

所以不能再写成：

- transcript 是否显示这条 `result`

决定了：

- direct connect 是否认定这一轮结束

更准确的写法应是：

- hook 先按 `result` 做 turn-end/busy-state 收口
- adapter 再按 subtype 决定它要不要变成可见消息

这两步顺序上相邻，语义上不同。

## 第四层：同一个 `result` 会同时触发不同层的不同结论

success `result` 是最值钱的反例。

它会同时触发：

- `isSessionEndMessage(...)` -> true
- `setIsLoading(false)`
- adapter -> `ignored`

这说明同一个 callback-visible object，可以在相邻层里分别得到：

- 这轮结束了
- UI 不再等待了
- 但 transcript 不需要新增一条成功结果消息

error `result` 则是另一组对照：

- `isSessionEndMessage(...)` -> true
- `setIsLoading(false)`
- adapter -> `message`

也就是说：

- success / error

在 turn-end 判定上相同，在 transcript policy 上不同。

这已经足够证明：

- visible result
- turn-end
- busy-state release

不是同一种 completion signal。

## 第五层：`setIsLoading(false)` 甚至不只发生在 `result`

如果还把 `setIsLoading(false)` 继续写成“完成信号本体”，当前源码马上会给出反例。

`useDirectConnect.ts` 里，`setIsLoading(false)` 还会出现在：

- `onPermissionRequest(...)`
- `onDisconnected(...)`
- `cancelRequest()`

这三种都说明：

- loading false

更像是在说：

- “当前不再等待服务器继续把这一段工作流往前推”

而不是在说：

- “这轮一定已经以同一种语义完成”

其中最重要的反例是：

- permission request 到来时也会 `setIsLoading(false)`

但这显然不是 terminal completion。

它只是：

- 服务器流暂停
- 控制权暂时切回本地用户审批

而一旦用户 `onAllow(...)`，源码又会：

- `setIsLoading(true)`

这进一步证明：

- busy/idle flag

描述的是交互等待状态，

不是 transcript result family 本身。

## 第六层：所以 direct connect 至少有三种 completion-related signal

把上面几层压实之后，更稳的总表是：

| 信号层 | 当前回答什么 | 典型例子 |
| --- | --- | --- |
| transcript-visible outcome | 结果要不要显示成正文消息 | error `result` visible / success `result` ignored |
| turn-end classifier | hook 是否把这一轮当作已到 `result` 收口 | `isSessionEndMessage(msg.type === 'result')` |
| busy-state transition | UI 是否还在等待服务器继续工作 | `setIsLoading(false)` on result / permission request / disconnect / cancel |

所以真正该写成一句话的是：

- visible result 是一层
- turn-end 判定是一层
- busy state 是一层

三者都与“完成”有关，但不是同一种 completion signal。

## 第七层：稳定层、条件层与灰度层

### 稳定可见

- same result family != same completion semantics
- success `result` transcript 静默，不等于它不参与 turn-end 收口
- error / success 当前在 `isSessionEndMessage(...)` 上没有区别
- `setIsLoading(false)` 当前的触发面比 `result` 更宽，至少还覆盖 permission pause、disconnect 和 cancel
- `converted.type === 'message'` 当前只是正文追加条件，不是 turn-end 或 busy-state 的唯一来源

### 条件公开

- 所有宿主是否都用同样的 busy-state machine，仍取决于当前 host/hook route
- 将来 `isSessionEndMessage(...)` 会不会比 `msg.type === 'result'` 更细，仍取决于当前实现策略
- 其他 UI consumer 会不会给 success `result` 单独再包一层可见壳，也仍是条件化宿主选择

### 内部/灰度层

- `isSessionEndMessage(...)`、`setIsLoading(false)`、`converted.type === 'message'` 与 permission pause 的 exact helper 顺序
- busy-state machine 的完整宿主实现与未来分支扩张
- 其他 hook/UI 是否会再引入第四种 completion-related consumer

所以这页最稳的结论必须停在：

- same result family != same completion semantics

而不能滑到：

- direct connect has one authoritative completion signal

## 第八层：为什么 116 不能并回 115

115 的主语是：

- adapter 内不同 policy 在补画、回放与静默之间并不相同

116 的主语则已经换成：

- 相邻层里看上去都像“完成”的几种信号，其实分属 transcript、turn-end 和 busy-state

前者讲：

- policy split inside adapter

后者讲：

- completion split across adapter and hook state

不是一页。

## 第九层：为什么 116 也不能并回 114

114 的主语是：

- triad 不是 callback mirror

116 的主语是：

- triad 外的 `isSessionEndMessage` 与 `setIsLoading(false)` 也不等于 triad 内的 visible result 判断

114 讲：

- callback -> adapter -> sink 的层次

116 讲：

- transcript outcome vs turn-end vs busy state 的层次

也不该揉成一页。

## 第十层：最常见的假等式

### 误判一：success `result` 被 `ignored`，所以它不算完成信号

错在漏掉：

- 它仍然会命中 `isSessionEndMessage(...)` 并触发 `setIsLoading(false)`

### 误判二：error `result` 会显示，所以它比 success `result` 更“结束”

错在漏掉：

- 二者在 turn-end classifier 上没有区别，只是在 transcript policy 上不同

### 误判三：`setIsLoading(false)` 就是 direct connect 的 completion signal

错在漏掉：

- permission request、disconnect、cancel 也会把它置为 false

### 误判四：一条 `result` 是否显示，决定了 hook 是否认定 turn 结束

错在漏掉：

- hook 收口发生在 adapter 转换之前

### 误判五：loading false 说明本轮一定正常结束

错在漏掉：

- disconnect 和 permission pause 都会带来同样的 busy-state 结果

## 第十一层：苏格拉底式自审

### 问：我现在写的是 visible outcome、turn-end，还是 busy state？

答：如果答不出来，就说明又把 completion signal 写平了。

### 问：我是不是把 success `result` ignored 直接写成“不算完成”？

答：如果是，就漏掉了 `isSessionEndMessage(...)` 那一层。

### 问：我是不是把 `setIsLoading(false)` 写成了 terminal close？

答：如果是，就回到 permission request、disconnect 和 cancel 这些反例。

### 问：我是不是把 error `result` visible 写成“更强的结束信号”？

答：如果是，就混淆了 transcript policy 和 turn-end classifier。
