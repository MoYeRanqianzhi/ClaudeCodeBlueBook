# 统一定价治理宿主消费面手册：authority source、decision window、pending action、rollback object与continuation gate

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式支持面让宿主消费统一定价治理。
2. 哪些属于宿主可写 control request，哪些属于宿主可读状态面，哪些仍然是 internal-only 决策逻辑。
3. 为什么 authority source、decision window、pending action、continuation gate 与 rollback object 必须被一起消费。
4. 为什么宿主不该把治理理解成若干弹窗、若干 mode 名字与若干 token 条。
5. 宿主开发者该按什么顺序接入这套治理支持面。

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

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `governance_control_plane`

的单独公共对象。

但统一定价治理已经通过三层支持面被宿主稳定消费：

1. `control requests`
   - 宿主能写哪些治理输入。
2. `state / metadata / usage projections`
   - 宿主能看到哪些当前治理真相。
3. `internal decision machinery`
   - 真正做仲裁、时间定价与继续判断的内部机制。

更成熟的接入方式不是：

- 只接 `can_use_tool`

而是：

- 明确知道自己当前是在写治理边界、读治理状态，还是只消费内部决策的外化效果

## 2. control requests：宿主可写治理输入

当前最关键的治理写入口包括：

1. `can_use_tool`
2. `set_permission_mode`
3. `get_context_usage`
4. `get_settings`
5. `apply_flag_settings`
6. `rewind_files`

这说明宿主在 Claude Code 里不是：

- 被动接收答案的界面

而是：

- 正式参与治理边界与回退边界的控制面消费者

## 3. authority source：宿主可读权威源

宿主当前最该消费的 authority source 主要有：

1. `get_settings.sources`
2. `get_settings.effective`
3. `get_settings.applied`
4. `external_metadata.permission_mode`

这些面共同回答：

1. 谁改了边界。
2. 现在真正生效的边界是什么。
3. 对外应该看到哪一个 mode 投影。

正确理解不是：

- 只看 mode 名字

而是：

- 围绕 settings / policy / applied runtime 结果消费当前权威源

## 4. decision window：宿主可读当前判断窗口

当前最该被一起消费的 decision window 投影主要有：

1. `session_state_changed.state`
2. `worker_status`
3. `external_metadata.pending_action`
4. `get_context_usage`

这些面共同回答：

1. 当前卡在哪。
2. 当前需要谁行动。
3. 当前为什么变贵。
4. 当前是否还值得继续。

要特别避免的误读是：

- 把 `pending_action` 当 UI 附件
- 把 `get_context_usage.percentage` 当 decision window 本身

## 5. continuation gate 与 rollback object 的支持面

`continuation gate` 与 `rollback object` 当前没有单独公共对象，但已经通过多个支持面被正式外化：

1. `get_context_usage.autoCompactThreshold`
2. `get_context_usage.apiUsage`
3. `tokenBudget` 外化出来的 stop / continue 结果投影
4. `rewind_files`
5. `pending_action`
6. 当前 state / worker status

这说明 continuation 与 rollback 不该被理解成：

- 内部补丁逻辑

而该被理解成：

- 通过多个 state / control / usage surfaces 共同暴露的时间边界与回退边界

## 6. internal decision machinery：不应直接当公共 ABI 依赖

真正做治理判断的关键机制仍在内部：

1. classifier 内部分支
2. fast-path / fail-open / fail-closed 细节
3. continuation 内部 tracker 字段
4. StructuredIO 的内部竞速去重逻辑
5. append-chain 自愈与 adopt 细节

对宿主开发者来说，正确做法不是：

- 绑定这些内部细节

而是：

- 消费已经外化出来的 authority / window / rollback / state surfaces

## 7. 三层支持矩阵

更稳的治理接入矩阵可以写成：

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

1. 先接 `control requests`。
2. 再接 `session_state_changed / worker_status / pending_action`。
3. 再接 `get_settings` 与 `get_context_usage` 解释 authority source 与 decision window。
4. 最后才组织自己的治理面板、CI 门禁与交接包。

不要做的事：

1. 不要只接 `can_use_tool` 就宣布治理接入完成。
2. 不要只接 token 面板就宣布成本面成立。
3. 不要让宿主自己从 UI 状态猜 rollback object。
4. 不要把 internal mode 或内部 classifier 分支当公共契约。

## 9. 一句话总结

Claude Code 的统一定价治理支持面，不是若干零散 control API，而是“control requests + authority source + decision window + continuation / rollback 投影”共同组成的分层宿主消费面。
