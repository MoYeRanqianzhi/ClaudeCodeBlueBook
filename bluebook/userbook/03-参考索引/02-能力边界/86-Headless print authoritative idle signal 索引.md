# Headless print authoritative idle signal 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/97-heldBackResult、bg-agent do-while、notifySessionStateChanged(idle)、lastMessage 与 authoritative turn over：为什么 headless print 的 idle 不是普通 finally 状态切换.md`
- `05-控制面深挖/96-drainSdkEvents、heldBackResult、task_started、task_progress、session_state_changed(idle) 与 finally_post_flush：为什么 headless print 的 SDK event flush 不是一次普通 drain.md`

边界先说清：

- 这页不是 SDK event flush 总图。
- 这页不替代 96 对 flush ordering 的拆分。
- 这页只抓 idle 为什么是 authoritative turn-over signal。

## 1. 五个关键对象总表

| 对象 | 作用 | 更接近什么 |
| --- | --- | --- |
| `heldBackResult` | 防结果抢在 bg-agent 收口前落地 | result holdback gate |
| bg-agent do-while | 防后台影响未收口就宣告回合结束 | bg completion gate |
| `notifySessionStateChanged('idle')` | 宣告 turn-over | authoritative idle signal |
| finally late `task_notification` drain | 防 idle 先于晚到 close bookend | late-bookend gate |
| `lastMessage` 过滤 | 保 result 主位，不让 idle 篡位 | semantic rank guard |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| idle 就是 finally 里的状态回写 | 它是晚于 heldBackResult 和 bg-agent do-while 的 authoritative turn-over signal |
| main loop 不在跑了就能先发 idle | 结果和 late bookends 可能还没真正收口 |
| idle 很重要，所以理应成为 `lastMessage` | 系统要求 result 保持主结果主位 |
| late `task_notification` 只是体验细节 | finally 注释明确把它们纳入 idle 合同 |
| 96 已经讲过 flush，97 只是重复 | 96 讲 flush ordering；这页讲 idle signal semantics |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | idle 是 authoritative turn-over signal，不是普通 finally 状态切换；它必须晚于 heldBackResult、bg-agent do-while 和 late close bookends |
| 条件公开 | 是否存在 hold-back、bg teardown、late bookends 会改变 idle 收口的实际价值；headless/SDK consumer 才真正依赖这条信号 |
| 内部/实现层 | runPhase、idleTimeout、internal event flush、lastMessage 过滤细节 |

## 4. 六个检查问题

- 这里的 idle 在描述 finally，还是在描述 turn-over？
- 这次 idle 前，result 已经真正落地了吗？
- bg-agent do-while 和 late bookends 已经收口了吗？
- 为什么这些 SDK events 不能抢 `lastMessage` 主位？
- 这里讨论的是 flush ordering，还是 authoritative idle semantics？
- 我是不是把 turn-over signal 写成了普通 busy/idle 翻转？

## 5. 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/sdkEventQueue.ts`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
