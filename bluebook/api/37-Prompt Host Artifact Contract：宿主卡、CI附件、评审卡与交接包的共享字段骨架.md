# Prompt Host Artifact Contract：宿主卡、CI附件、评审卡与交接包的共享字段骨架

这一章回答五个问题：

1. Prompt 线的宿主卡、CI 附件、评审卡与交接包，到底应该共享哪些正式字段。
2. 哪些字段是 shared contract，哪些只是 role-specific projection，哪些仍应停留在 internal hint。
3. 为什么 Prompt 工件必须继续围绕 compiled request truth、stable bytes、lawful forgetting ABI 与 next-step guard，而不是围绕原文 prompt、卡片与摘要。
4. 哪些字段最适合写成 hard contract，缺失时必须直接判定工件不合法。
5. 宿主开发者与平台设计者该按什么顺序接入这套 Prompt artifact contract。

## 0. 关键源码锚点

- `claude-code-source-code/src/constants/prompts.ts:491-557`
- `claude-code-source-code/src/constants/systemPromptSections.ts:17-43`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-104`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-520`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:232-437`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-62`
- `claude-code-source-code/src/utils/sessionState.ts:92-146`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`

## 1. 先说结论

Prompt 线真正成熟的 artifact contract，不是四类角色各写一份表格，而是四类工件共享同一份 Prompt object contract：

1. 宿主卡回答“当前 Prompt object 是谁、当前下一步是什么”。
2. CI 附件回答“编译真相、稳定字节与 ABI 完整性是否仍成立”。
3. 评审卡回答“这次改动是否真的改变了同一个 compiled request object”。
4. 交接包回答“忘掉全文之后，后来者还能否继续行动”。

四类工件的差异只应该体现在展开深度，而不应该体现在：

- 对象真相来源

## 2. Prompt Artifact Contract 的三层字段

### 2.1 Shared Contract

这些字段必须被四类工件共享：

1. `artifact_line_id`
2. `prompt_object_type`
3. `prompt_object_id`
4. `authority_source`
5. `assembly_path`
6. `compiled_request_summary`
7. `compiled_request_diff_ref`
8. `stable_bytes_ledger_ref`
9. `lawful_forgetting_abi_ref`
10. `current_object`
11. `pending_action`
12. `next_step_guard`
13. `rollback_hint`

### 2.2 Role-Specific Projection

这些字段只在特定工件里展开：

1. 宿主卡：
   - `task_summary`
   - `permission_mode`
   - `current_mode`
2. CI 附件：
   - `cache_break_summary`
   - `hard_fail_result`
   - `stable_bytes_drift_reason`
3. 评审卡：
   - `boundary_judgement`
   - `assembly_judgement`
   - `diff_judgement`
4. 交接包：
   - `transcript_refs`
   - `background_refs`
   - `rollback_steps`

### 2.3 Internal Hint

这些信息可以引用，但不应直接升格成稳定公共字段：

1. per-tool hash
2. 内部 cache fingerprint
3. promptCacheBreakDetection 的细粒度内部 trace
4. 临时 compact 中间结构

## 3. Shared Header

更稳的 Prompt artifact header 可以固定为：

```text
artifact_header:
- artifact_line_id
- prompt_object_type
- prompt_object_id
- authority_source
- assembly_path
- compiled_request_summary
- compiled_request_diff_ref
- stable_bytes_ledger_ref
- lawful_forgetting_abi_ref
- current_object
- pending_action
- next_step_guard
- rollback_hint
```

它的作用不是：

- 让每张卡都更长

而是：

- 让四类工件都从同一 Prompt object 起手

## 4. 四类工件的最小 contract

### 4.1 宿主卡

最少字段：

1. `artifact_line_id`
2. `current_object`
3. `authority_source`
4. `pending_action`
5. `compiled_request_summary`
6. `next_step_guard`

禁止退化为：

- prompt 原文截图
- 作者总结卡

### 4.2 CI 附件

最少字段：

1. `compiled_request_diff_ref`
2. `stable_bytes_ledger_ref`
3. `cache_break_summary`
4. `lawful_forgetting_abi_ref`
5. `hard_fail_result`

禁止退化为：

- 只有 pass / fail
- 只有 token / cache hit 曲线

### 4.3 评审卡

最少字段：

1. `authority_source`
2. `assembly_path`
3. `compiled_request_diff_ref`
4. `stable_bytes_ledger_ref`
5. `lawful_forgetting_abi_ref`
6. `review_judgement`

禁止退化为：

- 先看总结，再补字段

### 4.4 Handoff Package

最少字段：

1. `current_object`
2. `pending_action`
3. `next_step_guard`
4. `lawful_forgetting_abi_ref`
5. `rollback_hint`

禁止退化为：

- 只有 transcript 链接
- 只有摘要包

## 5. 为什么这些工件必须继续围绕 compiled request truth

因为 Prompt 真正送进模型的是：

- 编译后的 request truth

而不是：

- 原文 prompt
- 宿主卡片
- 作者总结

如果工件围绕的不是 compiled request truth：

1. 宿主卡会重新退回原文崇拜。
2. CI 附件会重新退回结果图表。
3. 评审卡会重新退回修辞判断。
4. handoff package 会重新退回历史考古。

## 6. 为什么 stable bytes 与 lawful forgetting ABI 也必须进入 contract

因为 Prompt 魔力不只来自“当前写得对”，还来自：

1. stable bytes 仍能解释为什么更稳或更贵。
2. lawful forgetting 之后，系统仍能合法继续。

如果这两类字段没有写进 contract：

1. CI 绿灯就无法解释漂移。
2. 交接包就无法证明后来者能继续工作。
3. 整个 Prompt line 会重新退回“这次好像还行”的经验判断。

## 7. Hard Contract 字段

最应写成 hard contract 的字段：

1. `prompt_object_type`
2. `prompt_object_id`
3. `authority_source`
4. `assembly_path`
5. `compiled_request_diff_ref`
6. `stable_bytes_ledger_ref`
7. `lawful_forgetting_abi_ref`
8. `current_object`
9. `next_step_guard`

这些字段缺任何一项，都不应再被视为：

- 合法 Prompt artifact

## 8. 最小接法

如果你要最小化接入 Prompt artifact contract，建议按下面顺序做：

1. 先把 shared header 固定下来。
2. 再让宿主卡、CI 附件、评审卡与 handoff package 都继承这一 header。
3. 再按角色增加 projection 字段。
4. 最后再把 internal hints 变成 evidence refs，而不是公共 schema。

## 9. 一句话总结

Prompt Host Artifact Contract 真正统一的，不是四类工件的页面样式，而是它们依赖的同一份 compiled request object 与同一组稳定判断字段。
