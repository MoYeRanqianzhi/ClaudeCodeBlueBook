# `StructuredIO`、`sessionState`、`remoteBridgeCore`、`pending_action`、`requires_action_details` 与 `reportState` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/206-StructuredIO、sessionState、remoteBridgeCore、pending_action、requires_action_details 与 reportState：为什么 can_use_tool 不等于 requires_action/pending_action，而 bridge blocked-state publish 只签裸 blocked bit.md`
- `05-控制面深挖/51-worker_status、requires_action_details、pending_action、task_summary、post_turn_summary 与 session_state_changed：为什么远端看到的运行态不是同一张面.md`
- `05-控制面深挖/133-pending_action、post_turn_summary、task_summary 与 externalMetadataToAppState：为什么 schema-store 里有账，不等于当前前台已经消费.md`

边界先说清：

- 这页不是 generic permission closeout 总页。
- 这页不是 schema/store restore 总页。
- 这页只抓 `can_use_tool` 什么时候会上升成 blocked session state，以及 bridge 最多把 blocked 状态发布到哪一层。

## 1. 六层对象

| 对象 | 当前更像什么 | 关键位置 |
| --- | --- | --- |
| `can_use_tool` | permission ask transport subtype | `structuredIO.ts` / `remoteBridgeCore.ts` |
| `notifySessionStateChanged('requires_action', details)` | blocked-state 升级门槛 | `print.ts` / `sessionState.ts` |
| `requires_action_details` | typed blocked context 的窄投影 | `sessionState.ts` / `ccrClient.ts` |
| `external_metadata.pending_action` | queryable blocked JSON 镜像 | `sessionState.ts` / `ccrClient.ts` |
| `externalMetadataToAppState(...)` | 本地恢复面的窄回填 | `onChangeAppState.ts` / `print.ts` |
| `transport.reportState('requires_action')` | bridge 侧裸 blocked bit publish | `remoteBridgeCore.ts` / `replBridgeTransport.ts` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 看到 `can_use_tool` 就等于 session 进入完整 blocked-state | 只有 `stdio -> onPermissionPrompt -> notifySessionStateChanged` 这条链才会升级成 `requires_action + pending_action` |
| `requires_action_details` = `pending_action` | 一个是 typed 窄投影，一个是 queryable 全对象镜像 |
| `pending_action` 写进 worker store 就等于 CLI 前台已经接上 | 当前 restore 只回填 `permission_mode/is_ultraplan_mode` |
| bridge 也在发 `can_use_tool`，所以它也会发布完整 pending context | bridge 这条线只签 `reportState('requires_action' | 'running' | 'idle')` 的裸 blocked bit |
| sandbox network access 既然也复用 `can_use_tool`，就一定走同样的 blocked-state 升级 | 它复用 transport，不经过 `onPermissionPrompt` 这条升级链 |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定不变量 | `stdio` permission path 才会形成 `requires_action_details + pending_action` 双轨投影；bridge publish ceiling 只到 state bit |
| 条件公开 | 只有 prompt 真被展示时才会打 `requires_action(details)`；最后一个 pending request 退场后才回 `running` |
| 内部/灰度层 | 哪些 frontend 真在读 `pending_action.input`；worker restore 后别的 client 是否会重建 blocked UI |

## 4. 六个检查问题

- 我现在写的是 permission ask transport，还是 blocked-state publish？
- 我是不是把 `can_use_tool` 直接写成了完整 blocked session？
- 我是不是把 `requires_action_details` 和 `pending_action` 写成了一张面？
- 我是不是把 worker-side metadata existence 误写成了 CLI foreground consumer 已接上？
- 我是不是把 bridge 的 `reportState('requires_action')` 误写成了完整 pending context 发布？
- 我是不是把 sandbox network 的 synthetic `can_use_tool` 误写成同一条 blocked-state 升级链？

## 5. 源码锚点

- `claude-code-source-code/src/cli/structuredIO.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/cli/remoteIO.ts`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts`
- `claude-code-source-code/src/state/onChangeAppState.ts`
