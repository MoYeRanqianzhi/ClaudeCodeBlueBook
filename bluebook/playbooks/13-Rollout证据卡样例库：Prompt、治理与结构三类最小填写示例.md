# Rollout证据卡样例库：Prompt、治理与结构三类最小填写示例

这一章不再解释字段为什么存在，而是给三张最小可填写样例卡。

它主要回答四个问题：

1. 统一 rollout ABI 真正填出来时长什么样。
2. Prompt、治理与结构三条线分别该怎样压缩成最小证据卡。
3. 怎样避免样例卡重新膨胀成叙事报告。
4. 怎样让后来者直接照着填，而不是继续从空白文档起步。

## 0. 使用方式

这三张卡都遵守同一个原则：

- 只填最小必要证据，不写长故事

真正需要的不是：

- 把 rollout 讲得完整

而是：

- 把对象、diff、阶段、结果与回退写得可复查

## 1. Prompt 线最小填写样例

```text
[对象卡]
record_id: PRM-ROLL-003
rollout_line: prompt_constitution
owner: runtime-prompt
status: phase-2-active
object_name: repl_main_thread_prompt
object_authority: systemPrompt assembly
pre_state: 长文案 + 多入口各自拼接上下文
target_state: section constitution + stable prefix / dynamic boundary 分层
protected_assets: 角色主权链, cache stability, lawful forgetting, handoff continuity
baseline_symptoms: section drift, cache break 原因不可解释, compact 后接手成本高
baseline_metrics: cache_read_ratio 0.41, resume_success 0.88

[Diff 卡]
minimal_diff:
- 新增 section_slots: role, tools, memory, continuation
- 把临时观测迁出 stable prefix
- summary / suggestion 改读同一 lawful forgetting ABI
expected_changed_surface: constitution bytes, assembly order, summary ABI
expected_unchanged_surface: tool schema, task object contract, host state path

[阶段评审卡]
phase_name: phase-2-stable-prefix-cutover
entry_rule: side paths parity stable for 7d
exit_rule: stable prefix token variance < 3% and cache_read_ratio >= 0.50
stop_rule: 主线程出现 path parity split
decision_owner: prompt owner
fallback_owner: runtime lead

[灰度结果卡]
observed_window: 7d
cohort_or_scope: repl + suggestion
metrics_delta: cache_read_ratio +0.12, stable_prefix_tokens -0.18
unexpected_effects: summary 丢失 pending_action 1 次
judgement: continue with lawful_forgetting guard fix
next_action: 进入 phase-3 dynamic boundary cutover

[Prompt 扩展字段]
speaker_chain: system -> user -> task
section_slots_changed: role/tools/memory/continuation
stable_prefix_surface: constitution sections + tool policy
dynamic_boundary_surface: 临时观测, tool result delta, local diagnostics
shared_prefix_producer: repl_main_thread
lawful_forgetting_abi: mode, pending_action, current_object, next_step_guard
cache_aware_assembly_factors: section bytes, model, tool visibility, memory delta
handoff_continuity_fields: current_mode, task_summary, pending_action, next_step

[回退记录卡]
trigger: resume_success < 0.90 for 2 consecutive windows
rollback_target: 保留 phase-1 side-path constitution, 回退 phase-2 main-thread cutover
retained_assets: section slots, diff ledger, side-path evidence
prevention_followup: 为 summary 增加 pending_action 校验
```

## 2. 治理线最小填写样例

```text
[对象卡]
record_id: GOV-ROLL-004
rollout_line: pricing_order
owner: runtime-governance
status: phase-3-active
object_name: permission_and_continuation_order
object_authority: permissions pipeline + token budget gates
pre_state: allow rule 提前拿主权, classifier 无增益也继续, auto mode 缺撤销条件
target_state: source gating -> hard guard -> mode/rule -> classifier -> human fallback
protected_assets: hard guard, stable bytes, approval race, human takeover path
baseline_symptoms: wrong deny 解释困难, approval race 退化, token spike
baseline_metrics: classifier_calls 1.00x, wrong_deny 0.04, approval_wait 18s

[Diff 卡]
minimal_diff:
- classifier 后移到 mode/rule 之后
- 为 ask/retry/continue 增加 decision_gain_cutoff
- auto mode 改为 lease + revoke
expected_changed_surface: order bytes, stop_logic, automation lease
expected_unchanged_surface: hard guard set, denied action taxonomy

[阶段评审卡]
phase_name: phase-3-decision-gain-stop-logic
entry_rule: order_after 在 shadow path 连续 5d 无 wrong_allow 上升
exit_rule: classifier_calls -20% and wrong_deny not worse
stop_rule: approval_wait > baseline + 20%
decision_owner: governance owner
fallback_owner: human reviewer

[灰度结果卡]
observed_window: 5d
cohort_or_scope: auto-mode + interactive approval
metrics_delta: classifier_calls -0.23, approval_wait -0.15, wrong_deny +0.00
unexpected_effects: 某些长任务过早停止 continuation 2 次
judgement: continue with object_upgrade_rule refinement
next_action: phase-4 automation lease rollout

[治理扩展字段]
order_before: mode -> allow rule -> classifier -> ask -> retry
order_after: source gating -> hard guard -> mode/rule -> classifier -> human fallback
decision_owner_before: allow rule
decision_owner_after: ordered policy chain
decision_gain_hypothesis: 无增益 classifier 应减少而误判不升
decision_gain_cutoff: classifier 连续 2 次不改变 verdict 即停止
stable_bytes_touched: prompt tool policy header, visible tool set, continuation guard
expected_stable_bytes_unchanged: hard guard matrix, dangerous command deny set
lease_model: auto mode 15m lease
revoke_conditions: denial spike, env drift, context overflow, policy change
stop_logic: no-gain classifier / retry / continue stop
human_fallback_path: interactive approval owner
failure_semantics_matrix: wrong_allow/wrong_deny/no_gain/timeout 四型
continuation_policy: no-gain then stop, long-tail then upgrade object
object_upgrade_rule: 超过 2 次 stop 触发 task/worktree upgrade

[回退记录卡]
trigger: approval_wait > 22s and approval_race degrades 2 windows
rollback_target: 回退 phase-3 stop_logic, 保留 phase-2 order_after
retained_assets: stable bytes ledger, source gating shrink, hard guard diff
prevention_followup: 为 approval race 加 owner handoff trace
```

## 3. 结构线最小填写样例

```text
[对象卡]
record_id: STR-ROLL-002
rollout_line: authority_recovery_shell
owner: runtime-structure
status: phase-4-active
object_name: session_truth_and_recovery_path
object_authority: authoritative session state
pre_state: UI/host/resume 各自维护 current truth, recovery 依赖猜测
target_state: authority single-write + projection read-only + recovery assets formalized
protected_assets: current truth, reconnect correctness, stale-write rejection
baseline_symptoms: split truth, stale pending action, reconnect drift
baseline_metrics: split_truth 17/w, reconnect_success 0.91

[Diff 卡]
minimal_diff:
- mode/state/metadata 统一写入 authoritative surface
- UI/search/host 改读 projection
- pointer/snapshot/replacement_log 登记为正式 recovery assets
expected_changed_surface: write paths, projection readers, recovery registry
expected_unchanged_surface: public host contract, UI visible fields

[阶段评审卡]
phase_name: phase-4-recovery-asset-formalization
entry_rule: projection-only readers 已覆盖 UI/host/search
exit_rule: reconnect_success >= 0.95 and split_truth <= 5/w
stop_rule: recovery_asset_drift appears in production
decision_owner: structure owner
fallback_owner: runtime maintainer

[灰度结果卡]
observed_window: 6d
cohort_or_scope: reconnect + resume + cleanup paths
metrics_delta: split_truth -0.31, reconnect_success +0.04, stale_pending_action -0.22
unexpected_effects: append cleanup 被 stale gate 误拦 1 次
judgement: continue after cleanup fate classification patch
next_action: phase-5 anti-zombie gate full enable

[结构扩展字段]
authoritative_surface: session state reducer
projection_set: UI panel, host metadata, search index, recovery view
transport_shell: repl bridge transport + session ingress adapters
recovery_asset: pointer, snapshot, replacement_log, cursor, adopt rules
anti_zombie_gate: generation check + fresh merge + stale drop

[回退记录卡]
trigger: reconnect_success < 0.93 or stale_cleanup false-positive spikes
rollback_target: 回退 phase-5 anti-zombie gate, 保留 phase-4 recovery assets
retained_assets: authority write path, projection readers, recovery registry
prevention_followup: 为 cleanup 单独增加 fate classification
```

## 4. 苏格拉底式追问

在你准备照抄这些样例卡前，先问自己：

1. 我抄到的是字段语义，还是只抄到了表面格式。
2. 我当前对象的主权、指标、停止条件与回退层级是否真的和样例一致。
3. 我是在压缩证据表达，还是在删掉关键证据。
4. 如果后来者只看这张卡，能否知道下一步该继续、暂停还是回退。
