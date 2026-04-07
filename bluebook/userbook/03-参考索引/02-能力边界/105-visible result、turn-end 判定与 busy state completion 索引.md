# visible result、turn-end 判定与 busy state completion 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/116-success result ignored、error result visible、isSessionEndMessage、setIsLoading(false) 与 permission pause：为什么 direct connect 的 visible result、turn-end 判定与 busy state 不是同一种 completion signal.md`
- `05-控制面深挖/115-convertToolResults、convertUserTextMessages、useAssistantHistory、viewerOnly 与 success result ignored：为什么 tool_result 本地补画、user text 历史回放与成功结果静默不是同一种 UI consumer policy.md`
- `05-控制面深挖/114-convertSDKMessage、useDirectConnect、stream_event 与 ignored：为什么 UI consumer 的三分法不是 callback surface 的镜像映射.md`

边界先说清：

- 这页不是 direct connect 全状态机总论。
- 这页不替代 115 对 adapter 内 policy 的拆分。
- 这页不替代 114 对 callback / adapter / sink 的拆分。
- 这页只抓 visible result、turn-end 判定与 busy-state 为什么不能写成同一个 completion signal。

## 1. 三层 completion-related signal

| 信号层 | 回答什么 | 典型例子 |
| --- | --- | --- |
| transcript-visible outcome | 结果要不要落成正文消息 | error `result` visible / success `result` ignored |
| turn-end classifier | hook 是否把这一轮当作已到 `result` 收口 | `isSessionEndMessage(msg.type === 'result')` |
| busy-state transition | UI 是否还在等待服务器继续推进 | `setIsLoading(false)` on result / permission request / disconnect / cancel |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| success `result` 被 `ignored`，所以它不算完成信号 | transcript 静默不影响它参与 turn-end / loading 收口 |
| error `result` 会显示，所以它比 success `result` 更“结束” | 二者在 `isSessionEndMessage(...)` 上一样，只在 visible outcome 上不同 |
| `setIsLoading(false)` 就是 authoritative completion signal | 它也会在 permission pause、disconnect、cancel 时触发 |
| result 是否可见决定 turn 是否结束 | hook 收口发生在 adapter transcript policy 之前 |
| loading false 说明本轮正常完成 | loading false 只说明当前不再继续等待服务器这一段推进 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `result` 本身是 public SDK message union 成员，direct-connect callback 当前也会收到它；`isSessionEndMessage(...)` 当前按 `msg.type === 'result'` 工作；success/error transcript policy 分叉；`useDirectConnect` 先收口 loading，再做 adapter 转换 |
| 条件公开 | success `result` 是否继续保持静默属于当前 transcript policy；busy-state 的更多来源取决于 host 具体交互流 |
| 内部/灰度层 | 后续是否细化 turn-end classifier、是否给 success `result` 增加别的 UI 壳、其他宿主是否共用同一 busy-state 语义 |

## 4. 五个检查问题

- 当前写的是 visible outcome、turn-end，还是 busy state？
- 我是不是把 success `result` ignored 写成了“不算完成”？
- 我是不是把 error `result` visible 写成了“更强结束”？
- 我是不是把 `setIsLoading(false)` 写成了 terminal close？
- 我有没有把 host-specific busy state 推广成 universal completion rule？

## 5. 源码锚点

- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
