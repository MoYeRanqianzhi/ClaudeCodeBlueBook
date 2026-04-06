# Remote Control `register`、`poll`、`ack`、`heartbeat`、`stop`、`archive` 与 `deregister` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/42-register、poll、ack、heartbeat、stop、archive 与 deregister：为什么 standalone remote-control 的环境、work 与 session 生命周期不是同一种收口.md`
- `05-控制面深挖/33-Disconnect Dialog、Perpetual Teardown、bridge pointer 与 --continue：为什么 bridge 的断开、退出与恢复轨迹不是同一种收口.md`

## 1. 七类生命周期动作总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Environment Registration` | 这台 host 先以什么环境存在 | `registerBridgeEnvironment` |
| `Work Polling` | 这个环境现在有没有新 work | `pollForWork` |
| `Work Claim` | 我是否正式接下这条 work | `acknowledgeWork` |
| `Lease Extension` | 这条 work 还要不要继续续租 | `heartbeatWork` |
| `Work Stop` | 服务端是否知道这条 work 已结束 | `stopWork` |
| `Session Archival` | 这条 session 还应不应该留在 active surface | `archiveSession` |
| `Environment Teardown` | 整个 bridge environment 要不要下线 | `deregisterEnvironment` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| register = poll | 一个让 environment 上线，一个在其上取 work |
| ack = heartbeat | 一个是首次 claim，一个是 lease keepalive |
| stop = archive | 一个停 work，一个归档 session |
| archive = deregister | 一个收 session，一个下线 environment |
| reconnect = 正常生命周期 | 它是恢复性旁路 |
| bridge 退出 = 必然 archive + deregister | single-session resume 会跳过 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | bridge 上线 / 离线、session 归档效果、resume 提示 |
| 条件公开 | at-capacity heartbeat mode、resume 跳过 archive+deregister、`reconnectSession` |
| 内部/实现层 | `registerBridgeEnvironment`、`acknowledgeWork`、`heartbeatWork`、`stopWorkWithRetry` |

## 4. 六个高价值判断问题

- 当前动作在操作 environment、work，还是 session？
- 当前是在注册、领取、续租、停 work、归档，还是销毁环境？
- 这是主生命周期，还是恢复性旁路？
- 我是不是把 claim 和 keepalive 写成了一回事？
- 我是不是把 stop、archive、deregister 写成了同一种关闭？
- 我是不是又把 `reconnectSession` 写成了主线生命周期动作？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/types.ts`
- `claude-code-source-code/src/bridge/bridgeApi.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
