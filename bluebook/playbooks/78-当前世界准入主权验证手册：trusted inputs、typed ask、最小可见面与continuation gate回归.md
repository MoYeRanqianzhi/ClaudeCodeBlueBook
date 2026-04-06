# 当前世界准入主权验证手册：governance key、typed ask、decision window 与 continuation pricing 回归

当前世界准入主权验证真正要验证的，不是 deny 还在不在、token 还显不显示，而是：

1. `governance key`
2. `externalized truth chain`
3. `typed ask`
4. `decision window`
5. `continuation pricing`
6. `durable/transient cleanup`

这些对象是否仍在共同保住“当前世界的准入主权”。

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

- 当前动作、能力、上下文与时间仍然围绕同一个 `governance key + externalized truth chain` 被准入、定价与清算

所以这层验证最先要看的不是面板，而是：

1. `governance key continuity`
2. `typed ask continuity`
3. `decision window continuity`
4. `continuation pricing continuity`
5. `durable/transient cleanup continuity`

## 2. 回归症状

看到下面信号时，应提高警惕：

1. 低信任输入开始偷偷自我扩权。
2. ask 退回单一路径弹窗，不再是 typed transaction。
3. token 图表开始替代 decision window。
4. 高体积对象重新霸占主 prompt，却没有外化解释链。
5. 恢复时把 transient authority 一并续租。
6. continuation 重新退回“先继续再说”。

## 3. 每轮检查点

每次变更后，至少逐项检查：

1. `governance key continuity`
   - 当前世界边界是否仍由 `sources -> effective -> applied -> externalized` 这条对象链宣布。
2. `typed ask continuity`
   - ask 是否仍是同一请求对象上的正式仲裁事务。
3. `decision window continuity`
   - 当前 pending action、Context Usage、generation 与取消语义是否仍属于同一窗口。
4. `continuation pricing continuity`
   - 继续执行是否仍由 decision gain、对象升级条件与同一 `externalized truth chain` 约束。
5. `durable/transient cleanup continuity`
   - resume 是否只恢复 durable assets，而不会把旧 mode、旧 grant、旧可见集整包续租。

## 3.1 回归 / 拒收矩阵

把 drift 写成正式 verdict，而不是散装症状：

| drift | verdict | threshold trigger | 最小证据 | 回退动作 | 是否冻结 capability expansion | 是否必须重建 `decision window / cleanup` |
|---|---|---|---|---|---|---|
| `low_trust_source_expanded_authority` | `reject` | 低信任输入改边界 | source chain / applied config | rollback to trusted source | 是 | 是 |
| `typed_ask_collapsed_to_modal` | `degrade` 或 `reject` | ask 不再是 typed transaction | request object / winner evidence | rebuild ask path | 是 | 视情况而定 |
| `context_usage_detached_from_window` | `degrade` | token 图表脱离当前窗口 | window ref / pending action | rebuild window projection | 否 | 是 |
| `continuation_pricing_defaulted` | `halt` | 继续失去 stop condition | continuation ref / decision gain | stop and re-qualify | 是 | 是 |
| `transient_authority_resumed` | `reject` | 恢复时续租旧 authority | durable/transient split evidence | cleanup then resume | 是 | 是 |
| `failure_semantics_flattened` | `human-fallback` | 全部 drift 被写成同一种情绪 | verdict mismatch | escalate to reviewer | 视情况冻结 | 视情况重建 |
| `automation_no_longer_revocable` | `abort` 或 `human-fallback` | 自动化失去合法退场路径 | automation lease / killswitch evidence | kill automation path | 是 | 否 |

更稳的纪律是：

1. `reject` 用于主权泄漏与旧 authority 续租。
2. `degrade` 用于还能保最小合法形态、但不能继续免费扩张的情形。
3. `halt` 用于 continuation 已无正式价格。
4. `human-fallback` 用于 failure semantics 已失去资产分型。
5. `abort` 用于自动化路径已无法合法撤销。

## 4. 直接拒收条件

出现下面情况时，应直接拒收：

1. `low_trust_source_expanded_authority`
2. `typed_ask_collapsed_to_modal`
3. `decision_window_unbound`
4. `context_usage_detached_from_window`
5. `continuation_pricing_defaulted`
6. `transient_authority_resumed`
7. `rollback_not_object`
8. `failure_semantics_flattened`
9. `automation_no_longer_revocable`

## 5. 复盘记录最少字段

每次 drift 至少记录：

1. `admission_sovereignty_object_id`
2. `governance_key`
3. `externalized_truth_chain`
4. `typed_ask_winner`
5. `decision_window_ref`
6. `continuation_pricing_ref`
7. `durable_assets_after`
8. `transient_authority_cleared`
9. `symptom`
10. `reject_verdict`
11. `rollback_object`

## 6. 防再发动作

更稳的防再发顺序是：

1. 先补 `governance key`。
2. 先补 `typed ask` 的仲裁语义。
3. 先补 `decision window` 与外化真相链。
4. 先补 `continuation pricing`。
5. 先补 `durable assets / transient authority` 分界。
6. 最后才补更多弹窗、文案或统计图。

## 7. 苏格拉底式检查清单

在你准备宣布“治理控制面仍然健康”前，先问自己：

1. 谁配扩边界，谁只能自我收缩。
2. 当前 `governance key` 是不是仍先于动作、可见性与 continuation。
3. ask 是不是仍是一场 typed transaction。
4. decision window 是否仍在解释“为什么现在该继续或拒收”。
5. 恢复时有没有把 transient authority 免费续租。
6. continuation 还有没有正式价格与停止条件。
7. cleanup 恢复的是对象边界，还是只恢复表面状态。
8. 如果删掉所有 UI，这套准入主权是否仍成立。

## 8. 一句话总结

真正成熟的治理验证，不是看审批还在不在，而是持续证明 `governance key`、`typed ask`、`decision window`、`continuation pricing` 与 `durable/transient cleanup` 仍然共同保住了“当前世界的准入主权”。
