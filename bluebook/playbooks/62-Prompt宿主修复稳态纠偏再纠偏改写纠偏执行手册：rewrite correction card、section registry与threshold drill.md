# Prompt宿主修复稳态纠偏再纠偏改写纠偏执行手册：rewrite correction card、section registry reseal、dynamic boundary与threshold liability drill

这一章不再解释 Prompt 宿主修复稳态纠偏再纠偏改写纠偏协议该消费哪些字段，而是把 Claude Code 式 Prompt steady-state correction-of-correction rewrite correction protocol 压成一张可持续执行的 `rewrite correction card`。

它主要回答五个问题：

1. 为什么 Prompt 的魔力在再纠偏改写纠偏执行里运行的不是“rewrite correction prose 更完整”，而是同一条 `message lineage` 上的 `compiled request truth`、同一个 `section registry` 与同一个 `dynamic boundary` 被再次证明仍可继续、可交接、可重开。
2. 宿主、CI、评审与交接怎样共享同一张 Prompt `rewrite correction card`，而不是各自围绕 rewrite prose、UI 历史、summary handoff 与子 Agent prose 工作。
3. 应该按什么固定顺序执行 `compiled request truth restitution`、`section registry reseal`、`dynamic boundary rebinding`、`protocol transcript repair`、`stable prefix reseal`、`lawful forgetting reseal`、`continuation requalification` 与 `threshold liability reinstatement`，才能不让假 rewrite correction 重新复活。
4. 哪些 `reject verdict` 一旦出现就必须冻结 continuation、阻断 handoff 并进入 `re-entry / reopen` drill。
5. 怎样用第一性原理与苏格拉底式追问避免把这层写成“第四套 Prompt 值班表”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/systemPrompt.ts:28-93`
- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:491-560`
- `claude-code-source-code/src/utils/queryContext.ts:30-58`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:494-698`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/compact/prompt.ts:293-337`
- `claude-code-source-code/src/services/compact/compact.ts:330-711`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-66`
- `claude-code-source-code/src/coordinator/coordinatorMode.ts:251-257`
- `claude-code-source-code/src/tools/AgentTool/prompt.ts:101-112`
- `claude-code-source-code/src/query/tokenBudget.ts:22-92`
- `claude-code-source-code/src/query.ts:1308-1518`

## 1. 第一性原理

Prompt 宿主修复稳态纠偏再纠偏改写纠偏真正要执行的不是：

- rewrite correction prose 又写得更像咒语
- UI 历史重新看起来很顺
- summary handoff 又能把当前状态解释圆

而是：

- 同一条 `message lineage` 上的 `compiled request truth`、`section registry`、`dynamic boundary`、`protocol transcript`、`stable prefix`、`lawful forgetting boundary`、`continuation object` 与 `continue qualification` 仍被再次证明可继续、可交接、可反对

所以这层 playbook 最先要看的不是：

- `rewrite correction card` 已经填完了

而是：

1. 当前 rewrite correction object 是否仍围绕同一个 `restored_request_object_id + compiled_request_hash + truth_lineage_ref`。
2. 当前 `section registry reseal` 是否真的把 Prompt 真相从静态目录说明里救回来。
3. 当前 `dynamic boundary rebinding` 是否真的把 stable prefix 正文与 late-bound attachment 重新分层。
4. 当前 projection consumer 是否仍围绕同一条 lineage 消费 truth，而不是各自消费不同投影。
5. 当前 `coordinator_synthesis_owner` 是否仍阻止未综合的子 Agent prose 篡位成主线真相。
6. 当前 `threshold liability reinstatement` 是否仍保留 future reopen 的正式能力。

## 2. 共享 rewrite correction card 最小字段

每次 Prompt 宿主修复稳态纠偏再纠偏改写纠偏巡检，宿主、CI、评审与交接系统至少应共享：

1. `rewrite_correction_card_id`
2. `rewrite_correction_session_id`
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `truth_lineage_ref`
6. `projection_consumer_alignment`
7. `section_registry_snapshot`
8. `section_registry_generation`
9. `dynamic_boundary_attested`
10. `late_bound_attachment_set`
11. `coordinator_synthesis_owner`
12. `protocol_transcript_health`
13. `stable_prefix_boundary`
14. `lawful_forgetting_boundary`
15. `continuation_object_ref`
16. `continue_qualification`
17. `threshold_liability_reinstatement`
18. `reject_verdict`
19. `verdict_reason`

四类消费者的分工应固定为：

1. 宿主看 rewrite correction object 是否仍围绕同一条 `message lineage` 上的 `compiled request truth`。
2. CI 看 registry、boundary、transcript、prefix、forgetting、qualification 与 threshold 顺序是否完整。
3. 评审看 `reject_verdict` 与对象边界是否仍自洽。
4. 交接看 later 团队能否在不继承作者记忆的前提下继续消费同一 rewrite correction object 与 `continuation object`。

## 3. 固定 reject verdict 顺序

### 3.1 先验 `rewrite_correction_session_object`

先看当前准备宣布 rewrite correction 完成的，到底是不是同一个 `rewrite_correction_session_id`，而不是一份更正式的 prose。

### 3.2 再验 `false_rewrite_correction_demotion_set`

再看：

1. `rewrite_prose_demoted` 是否已冻结。
2. `ui_transcript_not_truth` 是否仍成立。
3. `summary_override_blocked` 与 `attachment_premature_binding_blocked` 是否仍防止显示层历史冒充协议真相。

### 3.3 再验 `compiled request truth restitution`

再看当前 truth 是否真的回到同一个 `restored_request_object_id + compiled_request_hash + truth_lineage_ref`，而不是只证明“当前解释讲得更顺了”。

### 3.4 再验 `section registry reseal`

再看：

1. `section_registry_snapshot` 与 `section_registry_generation` 是否仍自洽。
2. `registry_drift_cleared` 是否仍阻止旧 registry 漂移复活。
3. `coordinator_synthesis_owner` 是否仍保证主线程综合责任没有被外包。
4. `projection_consumer_alignment` 是否仍保证 display / protocol / handoff 消费的是同一条 lineage。

### 3.5 再验 `dynamic boundary rebinding`

再看：

1. `dynamic_boundary_attested` 是否仍成立。
2. `late_bound_attachment_set` 是否仍没有偷渡进 stable prefix 正文。
3. `attachment_binding_order` 是否仍保证 attachment 只在合法位置晚绑定。

### 3.6 再验 `protocol transcript repair`

再看：

1. `protocol_transcript_health` 是否仍成立。
2. `tool_pairing_health` 是否仍防止 UI transcript 冒充协议真相。
3. `transcript_boundary_attested` 是否仍保证模型消费的是被修复后的 protocol object。

### 3.7 再验 `stable prefix reseal` 与 `lawful forgetting reseal`

再看：

1. `stable_prefix_boundary` 是否仍成立。
2. `lawful_forgetting_boundary` 与 `preserved_segment_ref` 是否仍让 compact 后的继续链合法。
3. `continuation_object_ref` 是否仍让 compact / handoff 后的继续对象挂回同一条 lineage。
4. 当前 rewrite correction 是否仍围绕同一份可复用的 prefix asset，而不是围绕一次幸运 cache hit。

### 3.8 最后验 `continuation requalification`、`threshold liability reinstatement` 与 `reject_verdict`

最后才看：

1. `continue_qualification` 是否仍然成立。
2. `token_budget_ready` 是否仍支持继续。
3. `truth_break_trigger`、`reentry_required_when` 与 `reopen_required_when` 是否仍正式保留。
4. projection consumer 是否仍不会把 display truth 误当继续资格。
5. `reject_verdict` 是否与前七步对象完全一致。

更稳的最终 verdict 只应落在：

1. `steady_state_restituted`
2. `hard_reject`
3. `truth_recompile_required`
4. `boundary_rebind_required`
5. `protocol_repair_required`
6. `reentry_required`
7. `reopen_required`

## 4. 直接阻断条件

出现下面情况时，应直接阻断当前 Prompt rewrite correction execution：

1. `rewrite_correction_session_missing`
2. `compiled_request_truth_unrestituted`
3. `section_registry_unbound`
4. `coordinator_synthesis_owner_missing`
5. `late_bound_attachment_in_prefix`
6. `dynamic_boundary_unattested`
7. `protocol_transcript_health_failed`
8. `stable_prefix_boundary_missing`
9. `lawful_forgetting_boundary_missing`
10. `projection_consumer_split_detected`
11. `continuation_object_missing`
12. `continue_qualification_unbound`
13. `threshold_liability_missing`
14. `reopen_required`

## 5. re-entry 与 reopen 处理顺序

看到阻断 reason 之后，更稳的处理顺序是：

1. 先冻结新的 continuation 与 handoff，不再让 later 团队继续消费当前 `rewrite correction card`。
2. 先把 verdict 降级为 `hard_reject`、`truth_recompile_required`、`boundary_rebind_required`、`protocol_repair_required`、`reentry_required` 或 `reopen_required`。
3. 先把 UI transcript、summary prose、attachment 渲染顺序与子 Agent 未综合 prose 降回线索，不再让它们充当 truth object。
4. 先回到上一个仍可验证的 `restored_request_object_id`、`section_registry_snapshot` 或 `stable_prefix_boundary`，补新的 registry reseal、boundary rebinding、protocol rewrite、forgetting reseal 与 qualification rebinding。
5. 如果根因落在 rewrite correction protocol 本身，就回跳 `../api/81` 做对象级修正。

## 6. 最小 drill 集

每轮至少跑下面七个 Prompt 宿主稳态纠偏再纠偏改写纠偏执行演练：

1. `rewrite_correction_session_replay`
2. `compiled_request_truth_restitution_replay`
3. `section_registry_lifecycle_replay`
4. `dynamic_boundary_rebind_replay`
5. `protocol_rewrite_replay`
6. `shared_prefix_and_forgetting_reseal_recheck`
7. `threshold_liability_replay`

## 7. 复盘记录最少字段

每次 Prompt 宿主稳态纠偏再纠偏改写纠偏失败、再入场或 reopen，至少记录：

1. `rewrite_correction_card_id`
2. `rewrite_correction_session_id`
3. `restored_request_object_id`
4. `compiled_request_hash`
5. `truth_lineage_ref`
6. `section_registry_snapshot`
7. `dynamic_boundary_attested`
8. `projection_consumer_alignment`
9. `coordinator_synthesis_owner`
10. `protocol_transcript_health`
11. `stable_prefix_boundary`
12. `lawful_forgetting_boundary`
13. `continuation_object_ref`
14. `continue_qualification`
15. `threshold_liability_reinstatement`
16. `reject_verdict`
17. `verdict_reason`

## 8. 苏格拉底式检查清单

在你准备宣布“Prompt 已完成稳态纠偏再纠偏改写纠偏执行”前，先问自己：

1. 我救回的是同一条 `message lineage` 上的 `compiled request truth`，还是一份更正式的 rewrite correction 说明。
2. 我重封的是 runtime `section registry`，还是一张更好看的目录表。
3. 我重新绑定的是 `dynamic boundary`，还是在偷把 late-bound attachment 塞回 stable prefix 正文。
4. 我现在让 display / protocol / handoff 消费的是同一条 lineage，还是三套互相漂移的投影。
5. 我现在保护的是 `protocol transcript`，还是一段更顺滑的 UI 历史。
6. 我现在保留的是未来继续与未来反对当前状态的正式条件，还是一种“先继续再说”的体面包装。

## 9. 一句话总结

真正成熟的 Prompt 宿主修复稳态纠偏再纠偏改写纠偏执行，不是把 rewrite correction prose 运行得更熟练，而是持续证明同一条 `message lineage` 上的 `compiled request truth`、`section registry`、`dynamic boundary`、`protocol transcript`、`stable prefix`、`lawful forgetting`、`continuation object` 与 `continue qualification` 仍被同一张 `rewrite correction card` 正式约束。
