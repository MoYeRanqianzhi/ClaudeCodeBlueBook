# 治理控制面支持面手册：governance key、truth chain、typed ask、decision window 与 continuation pricing

这一章回答五个问题：

1. Claude Code 当前到底通过哪些正式支持面暴露治理控制面。
2. 哪些属于宿主可写控制请求，哪些属于宿主可消费状态面，哪些仍然是 internal-only 决策逻辑。
3. 为什么 Settings、Permission、MCP、Context Usage 与状态写回必须一起看。
4. 为什么 continuation pricing 虽然没有单独公共对象，却已经通过多个支持面被正式外化。
5. 平台设计者该按什么顺序接入这套治理控制面。

## 0. 关键源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-240`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:308-519`
- `claude-code-source-code/src/cli/structuredIO.ts:149-657`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/sessionState.ts:92-146`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`

## 1. 先说结论

Claude Code 当前并没有公开一份名为：

- `governance_control_plane`

的单独对象。

但治理控制面已经通过三层支持面稳定暴露出来：

1. `control requests`
   - 宿主能写哪些 `governance key` 输入。
2. `state / event surfaces`
   - 宿主能看到哪些 `externalized truth chain / typed ask / decision window` 投影。
3. `internal decision machinery`
   - 真正做仲裁、定价、继续判断与 cleanup 的内部机制。

这三层支持面真正共同支撑的，是同一条：

- `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup`

更成熟的接入方式不是：

- 只接其中一层

而是：

- 明确知道自己当前是在写边界、读状态，还是只消费内部决策的外化效果

## 2. control requests：宿主可写治理输入

当前最重要的治理写入口包括：

1. `set_permission_mode`
2. `can_use_tool`
3. `get_context_usage`
4. `get_settings`
5. `apply_flag_settings`
6. `mcp_status`
7. `mcp_set_servers`
8. `mcp_reconnect`
9. `mcp_toggle`
10. `mcp_message`

这说明宿主在 Claude Code 里不是：

- 被动接收答案的界面

而是：

- 正式参与治理边界的控制面消费者

## 3. state / event surfaces：宿主可消费治理真相

当前宿主最该消费的治理真相主要有：

1. `session_state_changed`
2. `worker_status`
3. `external_metadata`
4. `requires_action_details`
5. `Context Usage`

这些表面共同回答：

1. 当前卡在哪。
2. 当前模式是什么。
3. 当前需要谁行动。
4. 当前世界为什么变贵。
5. 当前是否还值得继续。

它们不是五套分散接口，而是治理控制面的不同投影。

## 4. internal decision machinery：不应直接当公共 ABI 依赖

真正做治理判断的关键机制仍在内部：

1. permission arbitration
2. classifier / fail-open / fail-closed 逻辑
3. token continuation decision
4. visibility pricing
5. stale-state cleanup 与 rollback boundary

对宿主开发者来说，正确做法不是：

- 依赖内部实现细节

而是：

- 消费已经外化出来的 control / state / usage surfaces

## 5. continuation pricing 与 cleanup 的支持面

`continuation pricing` 虽然没有一个单独公共对象，但它的判断条件已经通过多个支持面被看见：

1. `Context Usage`
2. `pending_action`
3. `worker_status`
4. completion / stop 相关状态变化
5. 当前 cleanup / object upgrade 条件

所以 continuation 不该被理解成：

- 一个隐藏内部开关

而更该被理解成：

- 通过多个状态面共同暴露出来的时间边界与 cleanup 资格

## 6. 三层支持矩阵

更稳的治理接入矩阵可以写成：

### 6.1 宿主可写

1. permission mode
2. flag settings
3. MCP server set / reconnect / toggle
4. tool permission decision

### 6.2 宿主可读

1. current state
2. worker / metadata
3. Context Usage
4. effective / sources / applied settings

### 6.3 不应直接依赖为公共 ABI

1. classifier 内部阶段细节
2. auto-mode 内部拒收逻辑的所有分支
3. continuation 内部计数器实现细节
4. internal-only mode 名字与临时投影状态

## 7. 接入顺序建议

更稳的顺序是：

1. 先接 control requests
2. 再接 state / event surfaces
3. 再接 Context Usage 与 settings explainability
4. 最后才基于这些表面组织自己的治理面板与证据包络

不要做的事：

1. 不要只接 `can_use_tool` 就宣布治理接入完成。
2. 不要只接 token 面板就宣布成本面成立。
3. 不要把 internal-only mode 或内部判断分支当公共 ABI。

## 8. 一句话总结

Claude Code 的治理控制面支持面，不是一组零散 control API，而是“`governance key` 输入 + `externalized truth chain` 写回 + `typed ask / decision window / continuation pricing` 投影 + internal-only cleanup machinery”共同组成的分层支持面。
