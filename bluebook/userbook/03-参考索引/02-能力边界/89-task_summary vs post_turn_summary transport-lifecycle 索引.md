# `task_summary` vs `post_turn_summary` transport-lifecycle 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/100-task_summary、post_turn_summary、SDKMessageSchema、StdoutMessageSchema 与 ccr init clear：为什么 Claude Code 的 summary 不是同一条 transport-lifecycle contract.md`
- `05-控制面深挖/51-worker_status、requires_action_details、pending_action、task_summary、post_turn_summary 与 session_state_changed：为什么远端看到的运行态不是同一张面.md`
- `05-控制面深挖/98-lastMessage stays at the result、SDK-only system events、pendingSuggestion、heldBackResult 与 post_turn_summary：为什么 headless print 的主结果语义不会让给晚到系统事件.md`

边界先说清：

- 这页不是 summary 总论。
- 这页不替代 51 对远端运行态投影面的总分层。
- 这页不替代 98 对 `result` 主位与 late tail 的拆分。
- 这页只抓 `task_summary` / `post_turn_summary` 的 carrier、clear、union visibility 与 forwarding suppression。

## 1. 两条合同总表

| 对象 | 它在回答什么 | 更接近什么 |
| --- | --- | --- |
| `task_summary` | 这一轮现在正在做什么 | transient progress metadata |
| `post_turn_summary` | 这一轮刚刚发生了什么 | structured after-turn recap event |

## 2. transport / lifecycle 差异

| 维度 | `task_summary` | `post_turn_summary` |
| --- | --- | --- |
| 时间尺度 | mid-turn | post-turn |
| 主要载体 | `external_metadata` | structured `system` event |
| 类型强度 | `string | null` | dedicated schema payload |
| 清理策略 | `idle` 清空，worker init 还会清 stale | 当前可见代码无同类 init-null 逻辑 |
| core SDK union | 不是 SDK message | 有 schema，但不进 `SDKMessageSchema` |
| 更宽输出层 | 不靠 stdout message schema | 进入 `StdoutMessageSchema` |
| 常规消费路径 | metadata 观察面 | `print` / direct-connect 会主动过滤 |

## 3. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `task_summary` 和 `post_turn_summary` 只是同一个摘要的早晚版本 | 一个是 mid-turn metadata，一个是 after-turn structured event |
| `task_summary` 也是普通 SDK message | 当前可见源码只把它当 `external_metadata` progress line |
| `post_turn_summary` 有 schema，所以一定是 public core SDK message | 它不进 `SDKMessageSchema`，只进更宽的 `StdoutMessageSchema` |
| summary 应该在恢复时一起回填为本地会话真相 | 当前 restore 路径并不把这些 summary 回填进本地 `AppState` |
| 既然它能在流里出现，就该参与最终输出主位 | 常规 CLI / direct-connect 路径会主动过滤 `post_turn_summary` |

## 4. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `task_summary` 是 mid-turn progress metadata；`idle`/restart cleanup 会清 stale `task_summary`；`post_turn_summary` 是 after-turn structured recap，不是 `result` 主位 |
| 条件公开 | `post_turn_summary` 能否被消费取决于走的是更宽 stdout/control 层，还是常规 CLI / direct-connect 路径 |
| 内部/灰度层 | `@internal` 边界、opaque typing、具体生产路径 |

## 5. 六个检查问题

- 这里的 summary 在回答“现在”，还是“刚刚”？
- 它是 metadata key，还是 structured message？
- 它是否进入了 `SDKMessageSchema` 这种 core union？
- 它会不会在 `idle` 或 worker restart 时被清掉？
- 它会不会在 resume 时重新注入本地 `AppState`？
- 我是不是把“更宽输出层可存在”误写成了“常规结果路径必定可见”？

## 6. 源码锚点

- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/state/onChangeAppState.ts`
