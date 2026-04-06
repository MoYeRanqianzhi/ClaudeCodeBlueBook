# Headless print SDK event flush ordering 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/96-drainSdkEvents、heldBackResult、task_started、task_progress、session_state_changed(idle) 与 finally_post_flush：为什么 headless print 的 SDK event flush 不是一次普通 drain.md`
- `05-控制面深挖/93-task_started、task_progress、task_notification、drainSdkEvents、remoteBackgroundTaskCount 与 notifyCommandLifecycle：为什么 headless print 的后台任务三段式事件不是同一层生命周期.md`
- `05-控制面深挖/95-enqueuePendingNotification、emitTaskTerminatedSdk、print.ts parser、No continue 与 foreground done：为什么 headless print 的任务结果不会走同一条回流路径.md`

边界先说清：

- 这页不是 SDK triad 总图。
- 这页不替代 93-95 对事件家族和回流路径的拆分。
- 这页只抓 `drainSdkEvents()` 的多站位时序合同。

## 1. 五个关键对象总表

| 对象 | 作用 | 更接近什么 |
| --- | --- | --- |
| do-while 顶部 drain | 让 `task_started/task_progress` 先于 queue 结果层落流 | pre-queue flush gate |
| mid-turn result 前 drain | 防 SDK 事件被 result 抢跑 | pre-result flush gate |
| mid-turn non-result drain | 防 progress 等到 result 才一起出来 | real-time progress gate |
| finally / idle drain | 防 idle 和晚到 terminal bookend 落后 | shutdown/idle flush gate |
| `lastMessage` 过滤 | 让 SDK events 及时落流但不夺 result 主位 | semantic rank guard |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `drainSdkEvents()` 到处都一样，只是多余保险 | 每个站位在保护不同的时序合同 |
| progress 晚一点和 result 一起出来也没关系 | 源码明确要求 progress 先于 `task_notification` / result 落流 |
| finally 那次 drain 只是退出前清缓存 | 它在保护 idle 事件和晚到 terminal bookend 的顺序 |
| SDK events 多次 drain 就会夺走主结果语义 | `lastMessage` 过滤明确把它们排除在外 |
| `heldBackResult` 只影响 result，不影响 SDK flush | 它直接改变 idle/bookend 时序的必要性 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `drainSdkEvents()` 在 headless `print` 里是多站位时序护栏，不是一次普通 queue drain |
| 条件公开 | `heldBackResult`、bg-agent teardown、late bookends、result/non-result 分支都会改变 flush 的保护目标 |
| 内部/实现层 | `runPhase`、suggestionState 联动、lastMessage 过滤范围、finally_post_flush 细节 |

## 4. 六个检查问题

- 这次 flush 是想让谁先看见事件，host 还是模型？
- 这里防的是 progress 拖后、result 抢跑，还是 idle 抢先？
- 如果删掉这一次 drain，会破坏哪条时序保证？
- 这里和 `heldBackResult` 有关系吗？
- 这次 SDK event 会不会影响 `lastMessage` 语义？
- 我是不是把 staged flush ordering 写成 one generic queue drain 了？

## 5. 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/sdkEventQueue.ts`
