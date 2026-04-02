# Prompt Artifact样例库：宿主卡、CI附件、评审卡与交接包最小填写示例

这一章不再解释 Prompt artifact contract 为什么需要，而是直接给出四类工件的最小填写样例。

它主要回答四个问题：

1. Prompt artifact contract 真正填出来时长什么样。
2. 宿主卡、CI附件、评审卡与交接包怎样共享同一 Prompt object header。
3. 怎样避免样例重新退回原文 prompt、CI 绿灯、评审总结与 transcript 摘要。
4. 怎样让后来者直接照着填，而不是继续从空白表格起步。

## 0. 第一性原理

Prompt 样例层真正要展示的，不是：

- 四个长得像的表单

而是：

- 同一份 Prompt object contract 被四类工件按不同粒度投影出来的最小形式

所以这组样例都遵守同一个原则：

- 先共享对象，再分化角色

## 1. Shared Header 最小样例

```text
artifact_header:
- artifact_line_id: PRM-ART-001
- prompt_object_type: session_prompt
- prompt_object_id: session:turn-204
- authority_source: rendered_prompt@turn-204
- assembly_path: constitution -> message normalization -> request render
- compiled_request_summary: repl 主线程 + tool visibility + memory delta
- compiled_request_diff_ref: diff://prompt/turn-204
- stable_bytes_ledger_ref: ledger://prompt/stable-bytes/turn-204
- lawful_forgetting_abi_ref: abi://prompt/lawful-forgetting/turn-204
- current_object: session:turn-204
- pending_action: none
- next_step_guard: wait_for_user_message
- rollback_hint: revert_to_rendered_prompt@turn-203
```

这组字段是四类工件都要继承的最小前缀。

## 2. 宿主卡最小填写示例

```text
host_card:
- artifact_line_id: PRM-ART-001
- prompt_object_id: session:turn-204
- authority_source: rendered_prompt@turn-204
- compiled_request_summary: repl 主线程 prompt 已按当前工具池重编译
- current_object: session:turn-204
- pending_action: none
- task_summary: 修正 contract 层索引后等待下一轮输入
- next_step_guard: new_user_turn_only
```

宿主卡的目标不是：

- 替代 compiled diff

而是：

- 让当前对象、当前状态与下一步动作在前台可见

## 3. CI 附件最小填写示例

```text
ci_attachment:
- artifact_line_id: PRM-ART-001
- compiled_request_diff_ref: diff://prompt/turn-204
- stable_bytes_ledger_ref: ledger://prompt/stable-bytes/turn-204
- cache_break_summary: section_bytes_changed=memory_delta_only
- lawful_forgetting_abi_ref: abi://prompt/lawful-forgetting/turn-204
- stable_bytes_drift_reason: compact 后 memory slot 更新，constitution bytes 未漂移
- abi_integrity_result: pass
- hard_fail_result: none
```

CI 附件的目标不是：

- 宣布绿灯

而是：

- 解释为什么当前 Prompt object 仍然合法

## 4. 评审卡最小填写示例

```text
review_card:
- artifact_line_id: PRM-ART-001
- authority_source: rendered_prompt@turn-204
- assembly_path: constitution -> message normalization -> request render
- compiled_request_diff_ref: diff://prompt/turn-204
- stable_bytes_ledger_ref: ledger://prompt/stable-bytes/turn-204
- lawful_forgetting_abi_ref: abi://prompt/lawful-forgetting/turn-204
- boundary_judgement: dynamic memory delta 未污染 stable prefix
- diff_judgement: 仅影响 summary / memory slot，不影响 tool policy
- review_questions: current object 与 next_step_guard 是否仍足够支撑 handoff
```

评审卡的目标不是：

- 再写一版作者总结

而是：

- 沿 shared header 对当前 Prompt object 给出 judgement

## 5. 交接包最小填写示例

```text
handoff_package:
- artifact_line_id: PRM-ART-001
- current_object: session:turn-204
- pending_action: none
- next_action: await_next_user_message
- next_step_guard: new_user_turn_only
- lawful_forgetting_abi_ref: abi://prompt/lawful-forgetting/turn-204
- rollback_hint: revert_to_rendered_prompt@turn-203
- handoff_notes: 无需通读全文，保留 current object 与 next_step_guard 即可继续
```

交接包的目标不是：

- 导出一份更短的故事

而是：

- 导出合法继续所需的最小对象

## 6. 三个最容易抄坏的地方

1. 把宿主卡退回 prompt 原文截图，而不是 shared header 的当前对象投影。
2. 把 CI 附件退回 pass/fail 与 token 图，而不是 compiled diff + stable bytes 解释。
3. 把交接包退回 transcript 链接，而不是 lawful forgetting ABI + next_step_guard。

## 7. 苏格拉底式追问

在你准备照抄这组样例前，先问自己：

1. 我抄到的是 shared header，还是只抄到表面格式。
2. 这四类工件是否都仍然围绕同一个 compiled request object。
3. 如果删掉原作者说明，后来者还能否继续。
4. 我是在压缩 Prompt 真相表达，还是在删掉 Prompt 真相本身。
