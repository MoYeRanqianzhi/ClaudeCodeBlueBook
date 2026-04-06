# Observer metadata stale scrub vs restore 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/103-pending_action、task_summary、externalMetadataToAppState、state restore 与 stale scrub：为什么 CCR 的 observer metadata 不是同一种恢复面.md`
- `05-控制面深挖/51-worker_status、requires_action_details、pending_action、task_summary、post_turn_summary 与 session_state_changed：为什么远端看到的运行态不是同一张面.md`
- `05-控制面深挖/52-permission_mode、is_ultraplan_mode 与 model：为什么远端恢复回填、当前本地状态与 session control request 不是同一种会话参数.md`

边界先说清：

- 这页不是 external metadata 字段大全。
- 这页不替代 51 对 observer surface 的分层。
- 这页不替代 52 对 durable parameter restore 的拆分。
- 这页只抓 `pending_action` / `task_summary` 为什么属于 stale scrub first，而不是 local restore first。

## 1. 三层对象总表

| 对象 | 它在回答什么 | 更接近什么 |
| --- | --- | --- |
| `pending_action` | 当前被什么阻塞 | transient observer metadata |
| `task_summary` | 当前这轮正在做什么 | transient observer metadata |
| `permission_mode` / `is_ultraplan_mode` / `model` | 本地恢复时该重新生效的配置 | durable or semi-durable restore input |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 在 `SessionExternalMetadata` 里就该一起恢复 | metadata bag 宽度不等于 restore contract 宽度 |
| `pending_action` / `task_summary` 和 `permission_mode` / `model` 都是同一种会话参数 | 前者是 observer state，后者更接近 durable config |
| `GET /worker` 读回了旧 metadata，本地就会继续显示旧 blocked/progress 状态 | startup 会显式 scrub stale `pending_action` / `task_summary` |
| resume 就是把 `external_metadata` 原样 replay 回本地 | transcript/internal events 与 metadata restore 是不同通道 |
| scrub stale 与 restore path 是矛盾设计 | 对 observer metadata 来说，scrub stale 本来就是 recovery contract 的一部分 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `pending_action` / `task_summary` 是 observer metadata；worker startup 会 scrub stale；本地 restore 只窄恢复 durable config |
| 条件公开 | 这条恢复语义主要出现在 CCR v2 resume；`GET /worker` 读回旧值不等于本地采用旧值 |
| 内部/灰度层 | process-local sessionState 内存、internal event resume substrate、具体 writeback wiring |

## 4. 六个检查问题

- 我当前说的是 metadata bag，还是真实 restore contract？
- 这个 key 是为远端当前可见性服务，还是为本地恢复重生效服务？
- 当前动作是在 scrub stale，还是在 local restore？
- 我是不是把 `GET /worker` 读回误写成了 `AppState` 回填？
- 我是不是把 transcript/internal events resume 和 metadata restore 写成了同一个通道？
- 我是不是又把 observer state 写成了 durable config？

## 5. 源码锚点

- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
- `claude-code-source-code/src/state/onChangeAppState.ts`
- `claude-code-source-code/src/cli/print.ts`
