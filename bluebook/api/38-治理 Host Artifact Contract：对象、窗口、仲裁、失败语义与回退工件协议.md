# 治理 Host Artifact Contract：governance key、truth chain、typed ask、decision window 与 cleanup carrier

这一章回答五个问题：

1. 治理线的宿主卡、CI 附件、评审卡与交接包，到底该共享哪一条正式对象链。
2. 哪些字段是 hard contract，哪些只是 role-specific projection，哪些仍只能停留在 internal hint。
3. 为什么安全设计与省 token 设计必须共用同一份 artifact header，而不是各自再长一张面板。
4. 为什么 `authority source`、`winner source`、`rollback object` 只能当槽位、见证或 carrier，不能再当第一页主语。
5. 宿主开发者与平台设计者该按什么顺序接入这套治理 artifact contract。

## 0. 关键源码锚点

- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:235-1283`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:244-300`
- `claude-code-source-code/src/query/tokenBudget.ts:1-82`
- `claude-code-source-code/src/utils/toolResultStorage.ts:367-860`
- `claude-code-source-code/src/utils/sessionState.ts:92-146`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

## 1. 第一性原理

治理 artifact contract 真正要共享的，不是：

- 同一套 dashboard
- 同一套结果颜色
- 同一套审批次数统计

而是同一条治理判断链在不同 carrier 上的可复述性：

1. `governance key`
2. `externalized truth chain`
3. `typed ask`
4. `decision window`
5. `continuation pricing`
6. `durable-transient cleanup`

这也是 Claude Code 安全设计与省 token 设计的硬处：它们不靠两套制度协作，而靠同一对象链同时给边界、时间和清理定价。artifact contract 若把这条链拆散，later maintainer 看到的就只剩 mode、usage 与 rollback 按钮。

## 2. Shared Header

更稳的治理 artifact header，至少应把六段链写成下面这组共享字段：

```text
artifact_header:
- artifact_line_id
- governance_object_type
- governance_object_id
- governance_key_ref
- truth_chain_ref
- typed_ask_ref
- permission_ledger_ref
- decision_window_ref
- continuation_pricing_ref
- cleanup_carrier_ref
- durable_assets_after
- transient_authority_cleared
- reject_verdict
- verdict_reason
- next_action
```

这份 header 的作用不是把所有治理细节摊平成一张表，而是保证四类工件都从同一个治理对象链起手。

## 3. 旧词只能回到槽位

下面这些 legacy nouns 仍可保留，但必须降回固定位置：

1. `authority source`
   - 只是 `governance key` 的 source slot。
2. `permission ledger`
   - 只是 `typed ask` 的 transaction evidence。
3. `winner source`
   - 只是仲裁结果的 witness 字段。
4. `continuation gate`
   - 只是 `continuation pricing` 的 verdict。
5. `rollback object`
   - 只是 `durable-transient cleanup` 的 carrier。

只要这些词再次抢走第一页主语，artifact contract 就会重新退回投影崇拜。

## 4. 四类工件的最小投影

### 4.1 宿主卡

最少字段：

1. `governance_object_id`
2. `current_state`
3. `typed_ask_ref`
4. `decision_window_ref`
5. `continuation_pricing_ref`
6. `cleanup_carrier_ref`
7. `next_action`

禁止退化为：

- 只有 allow / deny / requires_action
- 只有 mode 名字与 token 颜色

### 4.2 CI 附件

最少字段：

1. `governance_key_ref`
2. `truth_chain_ref`
3. `permission_ledger_ref`
4. `decision_window_ref`
5. `continuation_pricing_ref`
6. `cleanup_carrier_ref`
7. `reject_verdict`

禁止退化为：

- 只有 token / latency 阈值
- 只有 ask 次数或 completion 次数

### 4.3 评审卡

最少字段：

1. `governance_key_ref`
2. `truth_chain_ref`
3. `typed_ask_ref`
4. `winner_source`
5. `reject_verdict`
6. `cleanup_carrier_ref`

禁止退化为：

- 先看结果，再补判断链
- 用 modal 通过感替代事务语义

### 4.4 Handoff Package

最少字段：

1. `governance_object_id`
2. `decision_window_ref`
3. `continuation_pricing_ref`
4. `cleanup_carrier_ref`
5. `durable_assets_after`
6. `transient_authority_cleared`
7. `re_entry_condition`

禁止退化为：

- 只有“现在卡住了”
- 只有“现在比较贵/比较严”

## 5. Hard Contract 与 Reject Trio

最应被写成 hard contract 的字段：

1. `governance_object_id`
2. `governance_key_ref`
3. `truth_chain_ref`
4. `typed_ask_ref`
5. `decision_window_ref`
6. `continuation_pricing_ref`
7. `cleanup_carrier_ref`
8. `reject_verdict`
9. `next_action`

治理线最值得长期复用的 reject trio 是：

1. `projection_usurpation`
2. `decision_window_collapse`
3. `free_expansion_relapse`

如果 artifact contract 不能直接指出这三类 drift 中的哪一类在发生，那它仍然只是展示件，不是治理合同。

## 6. 最小接入顺序

更稳的接入顺序是：

1. 先固定 shared header，不让四类工件各发明一套对象名。
2. 再把 `governance key -> truth chain -> typed ask` 三段先接通。
3. 再把 `decision window -> continuation pricing` 接成同一收费面。
4. 最后把 `cleanup carrier + durable/transient split` 接进 handoff 与 rollback。
5. internal hints 只作为 evidence ref，不升格成公共 schema。

不要反过来：

1. 先做 token 面板。
2. 先做审批流截图。
3. 先做文件回退列表。

那样只会把 carrier 写得更漂亮，却仍然保不住治理主语。

## 7. 苏格拉底式检查清单

在你准备宣布“治理 artifact contract 已经稳定”前，先问自己：

1. 我共享的是同一条治理对象链，还是四张角色各自解释的卡片。
2. `authority source` 在这里还是 source slot，还是已经被读成治理主权本身。
3. `permission ledger` 记录的是事务真相，还是一次“用户点了允许”的表面事件。
4. `continuation pricing` 是否同时在保护安全边界与 token 边界。
5. cleanup 记录的是对象恢复，还是文件动作清单。
6. later maintainer 拿到 handoff package 后，能否不看 UI 也继续做 stop / continue / cleanup 判断。

## 8. 一句话总结

治理 Host Artifact Contract 真正统一的，不是四类工件的展示方式，而是它们都必须把 `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup` 写成同一份可复述、可拒收、可交接的合同头部。
