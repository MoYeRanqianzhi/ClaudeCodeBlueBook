# Remote Control `poll`、`heartbeat`、`reconnecting`、`give up` 与 `sleep reset` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/47-poll、heartbeat、reconnecting、give up 与 sleep reset：为什么 bridge 的保活、回连预算与放弃条件不是同一种重试.md`
- `05-控制面深挖/31-Remote Control active、reconnecting、Connect URL、Session URL 与 outbound-only：为什么 bridge 的状态词、恢复厚度与动作上限不是同一个“已恢复”.md`

## 1. 七类 liveness / retry 对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Seek-work Poll` | 多久再去找下一份 work | `poll_interval_ms_not_at_capacity` |
| `Partial-capacity Poll` | 已有部分 active session 时多久再 poll | `multisession_poll_interval_ms_partial_capacity` |
| `At-capacity Heartbeat` | 满载时怎样保 active work lease | `non_exclusive_heartbeat_interval_ms` |
| `At-capacity Poll Backstop` | heartbeat 期间何时跌回 poll | `multisession_poll_interval_ms_at_capacity`、`poll_due` |
| `Reconnect Surface` | 当前 backoff 如何向用户显示 | `updateReconnectingStatus(...)`、`Remote Control reconnecting` |
| `Retry Budget Track` | 当前按哪类错误累计 give-up 预算 | `connGiveUpMs`、`generalGiveUpMs` |
| `Sleep Reset / Give Up` | 是该清空旧预算重算，还是该停止等待 | `pollSleepDetectionThresholdMs(...)`、`tengu_bridge_poll_give_up` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| poll cadence = backoff budget | 一个是工作发现节奏，一个是错误恢复预算 |
| at capacity = disconnected | 满载时仍可能 heartbeat 保 lease |
| `poll_due` = heartbeat failure | 它只是跌回 poll 的内部时点 |
| `reconnecting` = session timeout | 一个是 host backoff，一个是 child runtime timeout |
| sleep reset = 已恢复成功 | 它只是把旧预算清空重算 |
| give up = `sessionTimeoutMs` 到了 | 两者打在不同对象上 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `Remote Control reconnecting`、`Reconnected`、长时间故障最终 `giving up` |
| 条件公开 | seek-work poll 影响 pickup 延迟、at-capacity heartbeat mode、connection/general 两条 give-up track、backoff 前 heartbeat 保 lease、sleep reset |
| 内部/实现层 | `poll_due`、GrowthBook poll config 字段、jitter/cap 公式、`reclaim_older_than_ms`、`session_keepalive_interval_v2_ms` |

## 4. 六个高价值判断问题

- 当前桥在保的是找 work、保 lease，还是累计错误预算？
- 我看到的是正常节流、heartbeat mode，还是错误 backoff？
- 这次 `reconnecting` 是哪类错误轨触发的？
- 当前是 sleep reset，还是 give-up？
- 我是不是又把 host reconnecting 和 child timeout 写成同一种超时？
- 我是不是又把 `poll_due`、heartbeat、sleep reset 与 give-up 混成一种 retry？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/pollConfigDefaults.ts`
- `claude-code-source-code/src/bridge/pollConfig.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/bridgeUI.ts`
- `claude-code-source-code/src/bridge/bridgeStatusUtil.ts`
