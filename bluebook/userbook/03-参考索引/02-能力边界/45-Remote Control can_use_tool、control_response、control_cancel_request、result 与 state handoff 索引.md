# Remote Control `can_use_tool`、`control_response`、`control_cancel_request`、`result` 与 state handoff 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/56-initialize、can_use_tool、control_response、control_cancel_request 与 result：为什么 remote bridge 的握手、提问、作答、撤销与回合收口不是同一种状态交接.md`
- `05-控制面深挖/40-can_use_tool、SandboxNetworkAccess、hook-classifier 与 control_cancel_request：为什么 remote-control 的工具审批、网络放行、自动批准与提示撤销不是同一种批准.md`
- `05-控制面深挖/51-worker_status、requires_action_details、pending_action、task_summary、post_turn_summary 与 session_state_changed：为什么远端看到的运行态不是同一张面.md`

边界先说清：

- 这页不是 control message subtype 总表
- 这页只抓 ask / answer / cancel / result 如何推动 `requires_action → running → idle`

## 1. 六类对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Handshake` | 这条控制链能否先完成最小握手 | `initialize` |
| `Pending Ask` | 当前是否真的有一条待回答的权限问题 | `can_use_tool` |
| `Verdict` | 当前这条问题的回答是什么 | `control_response` |
| `Prompt Teardown` | 哪条 stale prompt 该被显式收掉 | `control_cancel_request` |
| `Turn Bookend` | 这一轮是否已经正式收口 | `result` |
| `Phase Handoff` | 上述动作会把远端推到哪个 phase | `requires_action / running / idle` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `initialize` = 一次批准 | 一个是握手，一个是 verdict |
| `can_use_tool` = 被动提示 | 它是真 pending ask |
| `control_response` = prompt teardown | 它首先是作答 |
| `control_cancel_request` = deny | 它是 stale prompt 收口 |
| `result` = 另一种 `control_response` | 它是 turn bookend |
| unsupported / outbound-only 也能回 success | 协议要求 truthful error，不能 fake success |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | ask 推到 `requires_action`；answer / cancel 拉回 `running`；`result` 落到 `idle` |
| 条件公开 | `initialize` 是必须及时回的握手；outbound-only 与 unsupported subtype 会回错；auth recovery 窗口里这组动作会被故意 drop |
| 内部/实现层 | server kill WS 的具体时限、callback wiring、pending request 存储细节 |

## 4. 七个检查问题

- 当前是在握手、提问、作答、撤销 stale prompt，还是结束整轮？
- 这个动作会把远端推到 `requires_action`、`running`，还是 `idle`？
- 这里返回的是 verdict，还是只是 prompt teardown？
- 当前上下文真的支持这个动作吗，还是必须诚实回错？
- 当前讲的是 control-plane state handoff，还是第 51 页的运行态投影？
- 当前处在稳定链路上，还是 recovery 窗口里？
- 我是不是又把 ask / answer / cancel / result 写成同一种远端回复了？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/bridgeMessaging.ts`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/cli/structuredIO.ts`
- `claude-code-source-code/src/cli/print.ts`
