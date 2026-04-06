# 统一定价治理宿主消费面手册：governance key、externalized truth chain、typed ask、decision window 与 continuation pricing

Claude Code 当前没有公开一份名为 `governance_key` 的单独公共对象，但宿主已经能通过分层支持面消费同一条治理链：

1. 宿主可写的 key inputs
2. 宿主可读的 `externalized truth chain`
3. 宿主可见的 `typed ask / decision window / continuation pricing` 投影
4. 宿主不应直接绑定的 internal decision machinery

如果把统一定价治理宿主消费面前门继续压成最短公式，也只剩四句：

1. `same-world test`
   - 宿主写入和读出的仍然是同一个治理对象。
2. `externalized truth chain`
   - host 只消费 runtime 已外化的真相，不自己补完。
3. `decision window`
   - `Context Usage + pending action + current state`
4. `continuation pricing + rollback object`
   - 继续资格和回退边界都必须按正式对象消费。

## 0. 关键源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-260`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:308-328`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:475-519`
- `claude-code-source-code/src/cli/structuredIO.ts:470-639`
- `claude-code-source-code/src/utils/sessionState.ts:15-45`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/cli/print.ts:2961-3010`

## 1. 宿主可写：围绕 `governance key` 的输入面

当前最关键的宿主写入口包括：

1. `can_use_tool`
2. `set_permission_mode`
3. `apply_flag_settings`
4. `rewind_files`

这些写入口真正作用的不是零散操作，而是：

- 改变 `governance key`
- 请求一次 `typed ask`
- 触发 cleanup / rewind

因此宿主在 Claude Code 里不是被动接收答案的前端，而是正式参与治理主键与回退主键的控制面消费者。

## 2. 宿主可读：`externalized truth chain`

宿主当前最该一起消费的外化真相链主要有：

1. `get_settings.sources`
2. `get_settings.effective`
3. `get_settings.applied`
4. `external_metadata.permission_mode`
5. `session_state_changed.state`
6. `worker_status`
7. `external_metadata.pending_action`
8. `get_context_usage`

这些面共同回答：

1. 谁改了边界。
2. 当前真正生效的边界是什么。
3. 当前卡在哪。
4. 当前为什么变贵。
5. 当前需要谁行动。

更准确的读法不是：

- 只看 mode 名字
- 只看 token 百分比
- 只看 pending_action 文案

而是：

- 把它们当作同一条 `externalized truth chain` 的不同节点。

### 2.1 宿主不得自己反推治理真相

宿主最容易犯的错不是少接一个字段，而是开始自己脑补整条治理链。

必须直接拒绝的宿主读法包括：

1. 只看 mode 名字，就宣布边界已经对齐。
2. 只看 token 百分比，就宣布 `decision window` 还有效。
3. 只看 `pending_action` 文案，就宣布 ask 生命周期已经清楚。
4. 只看某次 rewind / rollback 动作，就宣布 cleanup 语义已经成立。

更稳的做法只有一个：

- host 只消费 runtime 已外化的 `externalized truth chain`，不从 mode 条、token 条、spinner 或文案自己回放拼治理真相。

宿主在这里最容易踩到的 first reject signal 也只该先剩三条：

1. 只看 mode 名字就宣布边界已对齐
2. 只看 token 百分比就宣布窗口仍有效
3. 只看 rewind 动作就宣布 cleanup 语义成立

## 3. `typed ask`：宿主可消费的事务投影

宿主不该把 ask 理解成“弹窗出现过”，而应把它理解成一场带关联键的治理事务。当前最重要的外化信号是：

1. `can_use_tool` request / response
2. 与 `request_id`、`tool_use_id` 相连的幂等关系
3. `pending_action`
4. `worker_status`

这些信号共同说明：

1. ask 围绕哪个行动对象成立。
2. ask 现在处于等待、拒收还是已消费状态。
3. 哪条 response 仍然有效，哪条已经 stale。

对宿主开发者来说，正确做法不是自己猜 ask 生命周期，而是消费这组已外化的事务投影。

## 4. `decision window`：宿主可读的解释窗口

当前最该被一起消费的 `decision window` 证据面包括：

1. `get_context_usage`
2. `external_metadata.pending_action`
3. `session_state_changed.state`
4. `worker_status`

这些面共同解释：

1. 当前上下文被什么占席位。
2. 当前还有哪些对象未加载。
3. 当前为什么不该继续，或者为什么还配继续。
4. 当前需要用户、宿主还是 worker 来采取动作。

要特别避免的误读是：

- 把 `pending_action` 当 UI 附件。
- 把 `get_context_usage.percentage` 当 decision window 本身。

## 5. `continuation pricing` 与 cleanup 的宿主投影

`continuation pricing` 与 `rollback / durable-transient cleanup` 当前没有单独公共对象，但已经通过多个支持面被正式外化：

1. `get_context_usage.autoCompactThreshold`
2. `get_context_usage.apiUsage`
3. `pending_action`
4. `worker_status`
5. `rewind_files`
6. 当前 state snapshot

这说明宿主不该把 continuation 与 rollback 理解成内部补丁逻辑，而应理解成：

- 时间是否继续收费的正式投影
- 哪些资产仍能带走、哪些权威必须清掉的正式投影

因此：

- `continuation gate` 只是 `continuation pricing` 的 verdict。
- `rollback object` 只是 cleanup / handoff 的 carrier。

## 5.1 最短 runtime 对照

如果要把这一页压成最短宿主实现表，可以先钉死下面这张对照：

| canonical node | 宿主该接什么 | 宿主不该怎么偷懒 |
|---|---|---|
| `governance key` | `get_settings.sources / effective / applied` | 不要只看 `permission_mode` |
| `externalized truth chain` | `permission_mode + session_state_changed + worker_status + pending_action + get_context_usage` | 不要从 UI 局部状态反推整体 |
| `typed ask` | `can_use_tool` request/response + request correlation | 不要把 ask 退回弹窗存在性 |
| `decision window` | `get_context_usage + pending_action + current state` | 不要把 usage 百分比当窗口本身 |
| `continuation pricing` | context usage、compact 阈值、state transition | 不要把 continue 当默认免费按钮 |
| `durable-transient cleanup` | rewind / cleared fields / post-resume state | 不要把 rollback carrier 当治理根对象 |

## 6. internal decision machinery：不应直接当公共 ABI 依赖

真正做治理判断的关键机制仍在内部：

1. classifier 细分支
2. fast-path / fail-open / fail-closed 细节
3. continuation tracker 内部字段
4. StructuredIO 的竞速去重逻辑
5. append-chain 自愈与 adopt 细节

对宿主开发者来说，正确做法不是绑定这些内部细节，而是消费已经外化出来的：

1. `governance key` 相关输入面
2. `externalized truth chain`
3. `typed ask` 投影
4. `decision window`
5. `continuation pricing` 与 cleanup 投影

## 7. 支持矩阵

### 7.1 宿主可写

1. `can_use_tool`
2. `set_permission_mode`
3. `apply_flag_settings`
4. `rewind_files`

### 7.2 宿主可读

1. `settings.sources / effective / applied`
2. `permission_mode`
3. `session_state_changed`
4. `worker_status`
5. `pending_action`
6. `get_context_usage`

### 7.3 不应直接依赖为公共 ABI

1. internal-only mode 名字
2. classifier 阶段细节
3. StructuredIO 竞速去重实现
4. tokenBudget tracker 内部字段
5. append-chain 重试与 adopt 实现细节

## 8. 接入顺序建议

更稳的顺序是：

1. 先接 `control requests`，保证宿主能写正式治理输入。
2. 再接 `session_state_changed / worker_status / pending_action`，保证宿主能读当前窗口。
3. 再接 `get_settings` 与 `get_context_usage`，保证宿主能解释 `externalized truth chain` 与 `decision window`。
4. 最后才组织自己的治理面板、CI 门禁与交接包。

不要做的事：

1. 不要只接 `can_use_tool` 就宣布治理接入完成。
2. 不要只接 token 面板就宣布成本面成立。
3. 不要让宿主自己从 UI 状态猜 rollback / cleanup 语义。
4. 不要把 internal mode 或 classifier 分支当公共契约。

## 9. 一句话总结

Claude Code 的统一定价治理支持面，不是若干零散 control API，而是“宿主可写 key inputs + 宿主可读 truth chain + typed ask / decision window / continuation pricing 投影 + internal-only machinery”共同组成的分层宿主消费面。
