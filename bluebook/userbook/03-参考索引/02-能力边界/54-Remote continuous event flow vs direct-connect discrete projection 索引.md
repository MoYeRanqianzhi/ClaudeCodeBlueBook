# Remote continuous event flow vs direct-connect discrete projection 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/65-stream_event、task_started、task_notification 与 transcript_overlay_stderr：为什么 remote session 是持续事件流消费者，而 direct connect 只是离散交互投影.md`
- `05-控制面深挖/64-remoteSessionUrl、remoteConnectionStatus、remoteBackgroundTaskCount 与 busy_waiting_idle：为什么 remote session 的持续状态面和 direct connect 的当前交互面不是同一种状态来源.md`
- `05-控制面深挖/61-init、status、tool_result、tool_progress 与 ignored families：为什么 direct connect 的远端消息流不是原样落进 REPL transcript.md`

边界先说清：

- 这页不是远端状态来源索引
- 这页不是 direct connect transcript mode 索引
- 这页只抓“持续事件流消费”与“离散交互投影”两种消费合同

## 1. 六类对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Continuous Remote Flow` | 当前是否持续消费一条远端事件流 | `stream_event` |
| `Event-Sourced Counter` | 当前是否靠事件持续维护共享计数 | `task_started/task_notification` |
| `Durable Consumer` | 当前消费结果会不会持续修正共享状态 | `remoteConnectionStatus` |
| `Discrete Message Sink` | 当前只会落成一条消息吗 | transcript message |
| `Decision Overlay Sink` | 当前是否只等一次本地决定 | `PermissionRequest` |
| `Fatal Exit Sink` | 当前是否一断就直接退出 | stderr disconnect |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 两种远端模式都只是显示远端消息 | 一个持续消费事件流，一个主要投影离散结果 |
| `stream_event` 只是普通消息变种 | 对 remote session 它属于持续输出链 |
| `task_started/task_notification` 只是正文里的 system message | 它们主要驱动共享计数 |
| direct connect 也天然拥有持续后台任务状态 | 它没有同级事件计数链 |
| 两边断线后都只是不同文案 | remote session 留下可观察状态，direct connect 常直接 fatal 收口 |
| 这是 transport 差异 | 更根本的是消费合同差异 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | remote session 持续消费事件流并修正共享状态； direct connect 主要投影离散结果、overlay 与 fatal stderr |
| 条件公开 | remote session 持续状态依赖事件流； direct connect 的 overlay / stderr 依赖审批和断线时机 |
| 内部/实现层 | stream handler 细节、event-sourced set 维护、echo filter、stale cleanup |

## 4. 七个检查问题

- 当前是持续事件流消费，还是离散投影？
- 它会持续修正共享状态，还是只落成一条 UI 结果？
- 它会不会在没有新 prompt 时继续影响 UI？
- 当前 sink 是 transcript、overlay，还是 stderr？
- 当前断线后会留下状态，还是直接退出？
- 我是不是又把 stream/task 事件写成普通正文消息了？
- 我是不是又把 direct connect 写成持续流消费者了？

## 5. 源码锚点

- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/components/Spinner.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
