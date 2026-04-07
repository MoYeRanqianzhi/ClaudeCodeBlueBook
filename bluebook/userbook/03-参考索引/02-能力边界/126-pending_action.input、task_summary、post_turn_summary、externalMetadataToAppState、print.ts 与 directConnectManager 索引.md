# `pending_action.input`、`task_summary`、`post_turn_summary`、`externalMetadataToAppState`、`print.ts` 与 `directConnectManager` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/137-pending_action.input、task_summary、post_turn_summary、externalMetadataToAppState、print.ts 与 directConnectManager：为什么“frontend 会读”更像跨前端 consumer path，而不是当前 CLI foreground contract.md`
- `05-控制面深挖/133-pending_action、post_turn_summary、task_summary 与 externalMetadataToAppState：为什么 schema-store 里有账，不等于当前前台已经消费.md`

边界先说清：

- 这页不是 metadata 总表。
- 这页不是 133 的重复摘要。
- 这页只抓“frontend 会读”为什么更像跨前端 consumer path，而不是当前 CLI foreground contract。

## 1. 三者当前更像什么

| 字段 | 当前更像什么 | 为什么 |
| --- | --- | --- |
| `pending_action.input` | 外部 frontend 的 `external_metadata` 快捷读取面 | 注释直接说 frontend 读它，当前 CLI foreground 没有 reader |
| `task_summary` | 长回合中途进展字段 | worker-side 真实维护与清理，但当前 CLI foreground 无 reader |
| `post_turn_summary` | wide stdout wire 可见的 internal tail summary | 在 `StdoutMessageSchema` 里可见，但不进 `SDKMessageSchema`，且 CLI 主 consumer path 主动绕开 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 注释里说 frontend 会读，就等于当前 CLI foreground 会读 | 当前 reader 缺席，更像跨前端 consumer path |
| 调用了 `externalMetadataToAppState()`，说明 metadata 都回灌进本地前台 | 当前只恢复 `permission_mode` / `is_ultraplan_mode`，`model` 还走单独通道 |
| `post_turn_summary` 进了 `StdoutMessageSchema`，说明它属于当前 core SDK / CLI 主合同 | 它不在 `SDKMessageSchema`，描述本身还是 `@internal` |
| 当前没显示它们，只是 UI 还没做 | `print` / `directConnect` 已经在主动 narrowing `post_turn_summary` |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `pending_action.input` 注释里有明确 frontend intent；`task_summary` 被真实写账 / 清账；`post_turn_summary` 是 wide stdout wire 可见但不进 core SDK；当前 CLI foreground 无这三者 reader |
| 条件公开 | 三者更像外部 / remote frontend consumer path；CLI 将来可以接，但当前没接；`task_summary` 的 producer 注释明确但仓内 emit site 不完整可见 |
| 内部/灰度层 | `post_turn_summary` 自带 `@internal`；哪种 frontend 最终把这些字段做成稳定 UI 仍带灰度 |

## 4. 五个检查问题

- 我现在写的是 frontend intent，还是 CLI contract？
- 我是不是把 restore 被调用，偷换成了所有 metadata 都恢复进 foreground？
- 我是不是把 wide wire 可见性偷换成了 core consumer 可见性？
- 我是不是把 reader 缺席这个负证据忽略了？
- 我是不是把 133 的 schema/store 结论直接重复，而没有回答“frontend 指向谁”？

## 5. 源码锚点

- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/state/onChangeAppState.ts`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts`
