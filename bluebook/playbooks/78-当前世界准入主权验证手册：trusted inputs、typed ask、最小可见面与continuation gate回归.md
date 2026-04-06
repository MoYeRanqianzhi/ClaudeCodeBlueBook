# 当前世界准入主权验证手册：governance key、typed ask、最小可见面与continuation gate回归

这一章不再解释反扩张治理为什么成立，而是把 `architecture/83`、`philosophy/85` 与 `guides/100` 继续压成一张长期运行里的验证手册。

它主要回答五个问题：

1. 团队怎样知道当前仍在围绕同一个 `governance key` 做判断。
2. 哪些症状最能暴露治理已经退回弹窗、仪表盘或默认继续惯性。
3. 哪些检查点最适合作为持续回归门禁。
4. 哪些 drift 必须直接拒收，而不是继续补 UI、补统计或补解释。
5. 怎样用苏格拉底式追问避免把这层写成“治理流程手册”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/managedEnv.ts:93-220`
- `claude-code-source-code/src/utils/settings/settings.ts:319-520`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:472-716`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1158-1318`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:44-380`
- `claude-code-source-code/src/utils/toolSearch.ts:385-704`
- `claude-code-source-code/src/utils/toolResultStorage.ts:740-860`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`

## 1. 第一性原理

对世界准入主权来说，真正重要的不是：

- 现在还能 deny
- 现在还能显示 token

而是：

- 当前动作、能力、上下文与时间仍然围绕同一个 `governance key + externalized truth chain` 被准入

所以这层验证最先要看的不是面板，而是：

1. governance key continuity
2. typed ask continuity
3. visibility continuity
4. externalization continuity
5. durable-vs-transient continuity
6. continuation gate continuity

## 2. 回归症状

看到下面信号时，应提高警惕：

1. 低信任输入开始偷偷自我扩权。
2. ask 退回单一路径弹窗，不再是 typed decision transaction。
3. 工具“存在”被直接当成“现在可见”。
4. 高体积对象重新霸占主 prompt。
5. 恢复时把 transient authority 一并续租。
6. continuation 重新退回“先继续再说”。

## 3. 每轮检查点

每次变更后，至少逐项检查：

1. `governance key continuity`
   - 当前世界边界是否仍由 `sources -> effective -> applied -> externalized` 这条对象链宣布。
2. `typed ask continuity`
   - ask 是否仍是同一请求对象上的正式仲裁事务。
3. `visibility continuity`
   - 工具存在与工具当前可见是否仍然分层。
4. `externalization continuity`
   - 高波动、高体积对象是否仍按正式规则迁出主上下文。
5. `durable-vs-transient continuity`
   - resume 是否只恢复 durable assets，而不会把旧 mode、旧 grant、旧可见集整包续租。
6. `continuation gate continuity`
   - 继续执行是否仍由 decision gain、对象升级条件与同一 externalized truth chain 约束。

## 4. 直接拒收条件

出现下面情况时，应直接拒收：

1. `low_trust_source_expanded_authority`
2. `typed_decision_collapsed_to_modal`
3. `tool_visibility_unpriced`
4. `externalization_replay_unstable`
5. `context_usage_detached_from_window`
6. `transient_authority_resumed`
7. `continuation_without_gate`
8. `failure_semantics_flattened`
9. `automation_no_longer_revocable`

## 5. 复盘记录最少字段

每次 drift 至少记录：

1. `admission_sovereignty_object_id`
2. `governance_key`
3. `externalized_truth_chain`
4. `typed_ask_winner`
5. `visible_capability_set`
6. `externalized_object_set`
7. `durable_assets_after`
8. `transient_authority_cleared`
9. `continuation_gate`
10. `symptom`
11. `reject_reason`
12. `rollback_object`

## 6. 防再发动作

更稳的防再发顺序是：

1. 先补 governance key。
2. 先补 typed ask 的仲裁语义。
3. 先补可见面定价与 deferred visibility。
4. 先补 deterministic externalization。
5. 先补 durable assets / transient authority 分界。
6. 最后才补更多弹窗、文案或统计图。

## 7. 苏格拉底式检查清单

在你准备宣布“治理控制面仍然健康”前，先问自己：

1. 谁配扩边界，谁只能自我收缩。
2. 当前 `governance key` 是不是仍先于动作、可见性与 continuation。
3. ask 是不是仍是一场 typed decision transaction。
4. 模型此刻看见的世界是不是最小必要可见面。
5. 高体积对象有没有被继续迁出主上下文。
6. 恢复时有没有把 transient authority 免费续租。
7. continuation 还有没有正式价格与停止条件。
8. 失败语义是否仍按资产类型分型。
9. 如果删掉所有 UI，这套准入主权是否仍成立。

## 8. 一句话总结

真正成熟的治理验证，不是看审批还在不在，而是持续证明 governance key、typed ask、最小可见面、对象外置、durable-vs-transient 分界与 continuation gate 仍然共同保住了“当前世界的准入主权”。
