# Task result return-path split 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/95-enqueuePendingNotification、emitTaskTerminatedSdk、print.ts parser、No continue 与 foreground done：为什么 headless print 的任务结果不会走同一条回流路径.md`
- `05-控制面深挖/90-task-notification、<task-id>、<status>、emitTaskTerminatedSdk、enqueuePendingNotification 与 fall through to ask：为什么 headless print 的 task-notification 不是普通进度提示.md`
- `05-控制面深挖/91-<status>、statusless ping、emitTaskTerminatedSdk、enqueuePendingNotification 与 double-emit：为什么 headless print 的 task-notification 不是同一种关单信号.md`

边界先说清：

- 这页不是 task system 总图。
- 这页不替代 90-91 对 dual-consumer 与 close-signal family 的拆分。
- 这页只抓 task result 的 XML re-entry 路与 direct SDK close 路。

## 1. 五个关键对象总表

| 对象 | 作用 | 更接近什么 |
| --- | --- | --- |
| `enqueuePendingNotification(..., mode: 'task-notification')` | 把结果送进 XML re-entry 路 | model-capable return path |
| `print.ts` parser + no-continue | 解析 XML 后继续喂模型 | result re-entry |
| `emitTaskTerminatedSdk(...)` | 直接给 SDK consumer 关单 | host-only close path |
| foreground done / no XML 注释 | 解释为何不回到模型回合 | foreground host ownership |
| anti-double-emit 注释 | 约束 close 只能走一条负责路径 | return-path invariant |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 所有 task result 最终都会重新进入模型回合 | foreground direct SDK close 明确不会触发 LLM loop |
| 所有 terminal close 都应先走 XML queue | foreground / suppressed 路径本来就不会再走 XML |
| direct `emitTaskTerminatedSdk(...)` 只是 XML 路的补发版 | 它在某些路径上是唯一 close 通道 |
| backgrounded/foregrounded 只影响展示面 | 它们直接决定 result return path |
| 双发更稳 | XML close 与 direct SDK close 双发会污染状态机 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | task result 至少有 XML re-entry 和 direct SDK close 两条路径；前者可回到模型，后者只服务宿主 close |
| 条件公开 | backgrounded / foregrounded / suppress XML 会改变回流路径；是否还需模型继续行动是分叉主因 |
| 内部/实现层 | `notified:true`、suppress 分支、各任务实现各自的 direct/XML 取舍 |

## 4. 六个检查问题

- 这条结果还需要重新进入模型回合吗？
- 这条终态会不会再走 XML queue？
- 当前 close 是由 XML parser 负责，还是 direct SDK emit 负责？
- foreground/background 在这里改变的是展示，还是回流路径？
- 这里讨论的是 close signal family，还是 return-path split？
- 我是不是把 multiple return paths 写成 one generic return path 了？

## 5. 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/sdkEventQueue.ts`
- `claude-code-source-code/src/utils/task/framework.ts`
- `claude-code-source-code/src/tasks/LocalMainSessionTask.ts`
- `claude-code-source-code/src/tasks/stopTask.ts`
- `claude-code-source-code/src/utils/swarm/inProcessRunner.ts`
- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx`
