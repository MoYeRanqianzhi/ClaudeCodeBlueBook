# 统一Rollout ABI模板：对象、Diff、阶段、观测与回退记录

这一章不再给某一条线的单次样例，而是给三条线共用的 rollout 证据 ABI。

它主要回答五个问题：

1. 为什么 rollout 不该只靠样例故事，而必须有稳定字段与卡片接口。
2. Prompt、治理与结构三条线，到底哪些字段必须共用。
3. 哪些字段必须作为专项扩展，不能被“统一模板”抹平。
4. 怎样把 Diff、阶段评审、灰度结果与回退动作压成同一套记录协议。
5. 怎样用苏格拉底式追问避免把 ABI 模板写成项目管理表。

## 0. 为什么 rollout 需要 ABI，而不只是样例

一份成熟的 rollout 记录，不是：

- 周报
- 会议纪要
- 成功故事
- 任务清单截图

而是：

- 一份可复查、可追责、可复用、可回退的证据接口

样例回答的是：

- 一次正确迁移看起来长什么样

ABI 回答的是：

- 以后每一次迁移都必须留下哪些最小证据字段

所以真正需要统一的不是文风，而是：

1. 对象如何被命名。
2. 改动如何被压成最小 diff。
3. 阶段如何进入与退出。
4. 指标如何被记录与解释。
5. 回退如何被触发、执行与保留。

## 1. 共用骨架：五张卡片与一个附件面

三条线都应共用同一骨架：

1. 对象卡
2. Diff 卡
3. 阶段评审卡
4. 灰度结果卡
5. 回退记录卡
6. 证据附件面

### 1.1 对象卡

对象卡负责回答：

- 这次 rollout 到底在升级哪个对象。
- 改写前真相与目标真相分别是什么。
- 这次升级要保护哪些资产，不能顺手打碎什么。

```text
record_id:
rollout_line:
owner:
status:

object_name:
object_scope:
object_authority:

pre_state:
target_state:
protected_assets:

baseline_symptoms:
baseline_metrics:
```

### 1.2 Diff 卡

Diff 卡负责回答：

- 到底改了什么。
- 哪些字节、规则、状态或边界应该变化。
- 哪些部分预期保持不变。

```text
minimal_diff:
diff_reason:
expected_changed_surface:
expected_unchanged_surface:
risk_if_applied:
risk_if_not_applied:
```

### 1.3 阶段评审卡

阶段评审卡负责回答：

- 这一阶段先切什么。
- 谁拥有本阶段的判断主权。
- 进入、退出与停止条件分别是什么。

```text
phase_name:
phase_goal:
entry_rule:
exit_rule:
stop_rule:
decision_owner:
fallback_owner:
phase_actions:
phase_risks:
```

### 1.4 灰度结果卡

灰度结果卡负责回答：

- 本阶段到底看了哪些指标。
- 指标变化意味着什么。
- 现在该继续、暂停还是回退。

```text
phase_name:
observed_window:
cohort_or_scope:
observations:
metrics_delta:
unexpected_effects:
judgement:
next_action:
```

### 1.5 回退记录卡

回退记录卡负责回答：

- 什么触发了回退。
- 回退回哪一层。
- 回退后保留了什么，后续如何防再发。

```text
trigger:
detected_by:
failed_surface:
rollback_target:
rollback_actions:
retained_assets:
post_rollback_state:
prevention_followup:
```

### 1.6 证据附件面

证据附件面负责回答：

- 哪些 diff、日志、状态快照、报表、截图、回放与 casebook 链接支持这份记录。

```text
evidence_refs:
- diff
- metric snapshot
- transcript / summary / log
- state snapshot / metadata
- casebook link
- recovery drill / replay note
```

## 2. Prompt 线专项扩展字段

Prompt 线不能只填共用骨架，还必须额外填写下面字段：

```text
speaker_chain:
section_slots_changed:
stable_prefix_surface:
dynamic_boundary_surface:
shared_prefix_producer:
lawful_forgetting_abi:
cache_aware_assembly_factors:
handoff_continuity_fields:
```

这些字段分别回答：

1. `speaker_chain`：这份 prompt 到底由谁代表谁发言，主权链是否稳定。
2. `section_slots_changed`：这次改的是哪几个 constitutional slot，而不是“改了一段文案”。
3. `stable_prefix_surface`：哪些制度字节必须被冻结。
4. `dynamic_boundary_surface`：哪些高波动事实必须留在稳定前缀之外。
5. `shared_prefix_producer`：谁是唯一合法共享前缀生产者。
6. `lawful_forgetting_abi`：compact、resume、handoff 后哪些字段绝不能丢。
7. `cache_aware_assembly_factors`：哪些因子会触发 cache break 或 assembly 变化。
8. `handoff_continuity_fields`：后来者继续工作时最小需要看到什么。

Prompt 线真正记录的不是：

- 这次 prompt 写得更厉害了

而是：

- 主语、前缀、边界、遗忘与接手是否被共同治理

## 3. 治理与省 token 线专项扩展字段

治理线不能只填共用骨架，还必须额外填写下面字段：

```text
order_before:
order_after:
decision_owner_before:
decision_owner_after:
decision_gain_hypothesis:
decision_gain_cutoff:
stable_bytes_touched:
expected_stable_bytes_unchanged:
lease_model:
revoke_conditions:
stop_logic:
human_fallback_path:
failure_semantics_matrix:
continuation_policy:
object_upgrade_rule:
```

这些字段分别回答：

1. `order_before / order_after`：治理顺序到底改了什么。
2. `decision_owner_before / after`：谁先判断、谁后判断，主权有没有变动。
3. `decision_gain_hypothesis / cutoff`：继续花 token 还能改变什么决定，何时增益归零。
4. `stable_bytes_touched`：哪些制度字节本轮被改动，哪些预期冻结。
5. `lease_model / revoke_conditions`：自动化到底是临时租约，还是已经偷成永久主权。
6. `stop_logic`：哪类自动链在无增益时必须停止。
7. `human_fallback_path`：系统停止自动判断后交还给谁。
8. `failure_semantics_matrix`：不同失败是否被正确分型，而不是粗暴写成同一种错误。
9. `continuation_policy / object_upgrade_rule`：什么时候还能继续同一对象，什么时候必须升级成 task、worktree 或其他对象。

治理线真正记录的不是：

- 本轮省了多少 token

而是：

- 谁先判断、什么先被保护、哪些无增益链路被停止、哪些自动化被撤销

## 4. 结构线专项扩展字段

结构线不能只填共用骨架，还必须额外填写下面字段：

```text
authoritative_surface:
projection_set:
transport_shell:
recovery_asset:
anti_zombie_gate:
```

这些字段分别回答：

1. `authoritative_surface`：当前真相的唯一写入口在哪里。
2. `projection_set`：哪些消费者只应读取投影，而不应维护第二真相。
3. `transport_shell`：哪些 carrier 差异已被关进外壳，哪些仍泄漏到业务层。
4. `recovery_asset`：哪些 pointer、snapshot、replacement log、metadata 是正式恢复资产。
5. `anti_zombie_gate`：旧对象、旧 finally、旧 snapshot 怎样被 stale drop、generation 或 fresh merge 拦截。

结构线真正记录的不是：

- 目录变漂亮了

而是：

- 真相、传输、恢复与对象命运是否已经收口

## 5. 填写纪律

真正有用的 rollout ABI，必须遵守四条纪律：

1. 事实先于解释。
2. diff 先于评价。
3. 观测先于归因。
4. 没有回退条件的 rollout，不算正式 rollout。

更具体地说：

1. 不要先写“本次升级很成功”，要先写 `pre_state / target_state / minimal_diff`。
2. 不要先写“成本下降”，要先写 `metrics_delta` 和 `decision_gain`。
3. 不要先写“结构更合理”，要先写 `authoritative_surface / recovery_asset / anti_zombie_gate`。
4. 不要先写“可以继续推进”，要先写 `entry_rule / exit_rule / stop_rule / rollback_target`。

## 6. 何时拆分为多份记录

遇到下面情况时，不要把所有改动塞进同一份 rollout ABI：

1. 对象主权不同。
2. 回退层级不同。
3. 指标集合不同。
4. 决策 owner 不同。
5. 失败语义不同。

Prompt、治理与结构可以共用骨架，但不应为了“统一”而失去：

- 对象边界
- 判断主权
- 失败可解释性

## 7. 苏格拉底式追问

在你准备把一套 rollout 记录宣布为“统一模板”前，先问自己：

1. 我统一的是证据字段，还是只统一了排版。
2. 这套卡片能否迫使团队先说明对象、边界、指标和回退，而不是先讲结果。
3. 这份记录如果脱离原作者，还能不能支持后来者继续判断。
4. 我是在降低记录成本，还是在把关键差异洗平。
5. 这套 ABI 真能跨 Prompt、治理、结构三条线复用吗，还是只是看起来都像表格。
