# Remote Control `work secret`、`ack timing`、existing session refresh 与 `unknown work` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/45-work secret、ack timing、existing session refresh 与 unknown work：为什么 standalone remote-control 的 work intake 不是同一种领取.md`
- `05-控制面深挖/42-register、poll、ack、heartbeat、stop、archive 与 deregister：为什么 standalone remote-control 的环境、work 与 session 生命周期不是同一种收口.md`

## 1. 六类 intake 对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Intake Validity` | 这条 work 是不是可安全处理 | `decodeWorkSecret` |
| `Commitment Gate` | 我现在要不要正式 claim 这条 work | `ackWork` |
| `Healthcheck Routing` | 这条 work 只是环境探针吗 | `healthcheck` |
| `Existing Session Refresh` | 这是已存在 session 的 fresh-token intake 吗 | `existingHandle` path |
| `Capacity Deferral` | 我是不是故意不 ack 让它可重投 | at-capacity break |
| `Compatibility Sink` | 这是坏数据还是未来类型 | invalid `session_id` / unknown work type |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| poll 到 work = 自动 ack | 只有 commit-to-handle 后才 ack |
| decode failure = 普通 session failure | 它是 poisoned intake，应该 stop |
| existing session refresh = 新 session spawn | 它是续接路径，不是 spawn 路径 |
| at capacity = 处理失败 | 它是故意不 ack、保持可重投 |
| invalid `session_id` = unknown work type | 一个是坏数据，一个是协议前向兼容 |
| healthcheck = session work 的空版本 | 它是不同的 work type |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 真正接手才 ack、existing session 可刷新、capacity 会阻止新 session intake |
| 条件公开 | healthcheck、poisoned work stop、unknown type 宽容处理 |
| 内部/实现层 | `decodeWorkSecret`、`ackWork`、`stopWorkWithRetry`、existing-handle token update |

## 4. 六个高价值判断问题

- 现在先要过 validity，还是已经进入 routing？
- 当前是在 claim，还是故意不 claim？
- 这是 existing session refresh，还是 new session spawn？
- 这是 poisoned work、invalid data，还是 unknown future type？
- 我是不是又把 capacity gate 写成了 error？
- 我是不是又把 ack 写成了 poll 后固定第一步？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/workSecret.ts`
- `claude-code-source-code/src/bridge/types.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
