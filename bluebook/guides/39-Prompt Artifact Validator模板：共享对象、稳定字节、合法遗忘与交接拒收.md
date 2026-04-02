# Prompt Artifact Validator模板：共享对象、稳定字节、合法遗忘与交接拒收

这一章不再解释 Prompt artifact 为什么重要，而是把它压成团队可复用 validator / linter 模板。

它主要回答五个问题：

1. 怎样判断 Prompt artifact 是否真的围绕同一 `compiled request object` 成立，而不是围绕原文 prompt、绿灯与摘要成立。
2. 怎样把 `shared header`、`stable bytes`、`lawful forgetting ABI` 与 `handoff reject rule` 放进同一张校验卡。
3. 怎样让宿主、CI、评审与交接沿同一校验顺序消费 Prompt artifact。
4. 怎样识别“宿主卡有了、CI 通过了、评审写了、交接也有摘要”这类看似合规的漂移。
5. 怎样用苏格拉底式追问避免把 Prompt validator 退回字段巡检。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/prompts.ts:491-557`
- `claude-code-source-code/src/constants/systemPromptSections.ts:17-43`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-104`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-520`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:232-437`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-62`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/utils/sessionState.ts:92-146`

这些锚点共同说明：

- Prompt 的魔力不是文案更长，而是 `compiled request truth -> stable bytes -> lawful forgetting ABI -> next-step guard` 这条对象链能被不同消费者持续验证。

## 1. 第一性原理

更成熟的 Prompt validator 不是：

- 字段更多

而是：

- 一旦 shared object 断掉，系统会比人更早拒绝继续消费

所以审读 Prompt artifact 时，最该先问的不是：

- 这四类工件是不是都存在

而是：

- 它们是否仍然共享同一 `prompt_object_id`

## 2. Prompt Validator Header

任何 Prompt artifact validator 都先锁这一组 shared header：

```text
artifact_line_id:
prompt_object_type:
prompt_object_id:
authority_source:
assembly_path:
compiled_request_diff_ref:
stable_bytes_ledger_ref:
lawful_forgetting_abi_ref:
current_object:
rollback_object:
next_step_guard:
```

团队规则：

1. 没有 `prompt_object_id` 的 Prompt 卡片，直接 `hard fail`。
2. 没有 `compiled_request_diff_ref` 与 `stable_bytes_ledger_ref` 的 CI 附件，不能冒充正式验证结果。
3. 没有 `lawful_forgetting_abi_ref` 与 `next_step_guard` 的 handoff package，直接 `reject`。
4. 宿主、CI、评审与交接四类工件的 `artifact_line_id` 与 `prompt_object_id` 不一致，直接判定 `split-brain drift`。

## 3. Host Card Gate

先审宿主卡是不是在消费真实对象，而不是退回原文 prompt：

```text
[ ] current_object 是否明确点名
[ ] authority_source 是否明确点名
[ ] assembly_path 是否明确点名
[ ] 宿主卡是否能回链到同一 prompt_object_id
[ ] 宿主卡是否避免用原文 prompt / 作者总结充当当前对象
```

直接判 drift 的情形：

1. 宿主卡主要展示原文 prompt，而不是 `current_object`。
2. 宿主卡引用最后一条 assistant 输出，却没有 `authority_source`。
3. 宿主卡看起来完整，但 `prompt_object_id` 和评审卡、交接包不一致。

## 4. CI Attachment Gate

任何 CI 附件都必须证明它审的是同一份 compiled request，而不是只剩通过结果：

```text
[ ] compiled_request_diff_ref 是否存在
[ ] stable_bytes_ledger_ref 是否存在
[ ] cache-break / drift explanation 是否存在
[ ] 结果是否能回链到同一 prompt_object_id
[ ] 绿灯之外是否仍保留可解释对象
```

团队规则：

1. `pass/fail` 不能替代 `compiled_request_diff_ref`。
2. `cache hit` 或 token 图不能替代 `stable_bytes_ledger_ref`。
3. “这次没问题”不能替代 drift explanation。

## 5. Review Card Gate

评审卡必须证明 judgement 锚在 shared object，而不是锚在 reviewer summary：

```text
[ ] judgement 是否回链到 authority_source
[ ] judgement 是否回链到 assembly_path
[ ] judgement 是否回链到 compiled_request_diff_ref
[ ] 评审是否点名 drift / stable bytes 变化
[ ] 评审是否避免只给一句总结
```

直接判 drift 的情形：

1. 评审卡只有“合理 / 通过 / 未污染”。
2. 评审卡有判断结论，但没有 `authority_source` 或 `assembly_path`。
3. 评审卡引用的是作者解释，而不是 compiled request object。

## 6. Handoff Reject Gate

交接卡必须先通过 reject gate，再看摘要：

```text
[ ] current_object 是否明确点名
[ ] lawful_forgetting_abi_ref 是否明确点名
[ ] next_step_guard 是否明确点名
[ ] rollback_object 是否明确点名
[ ] 不读全文时，接手者是否仍能继续
```

直接拒收条件：

1. 交接包只有摘要和 transcript 索引，没有 `current_object`。
2. 交接包没有 `next_step_guard`，却要求后来者继续。
3. compact 之后没有 `lawful_forgetting_abi_ref`，只剩口头描述。

## 7. Validator 输出等级

```text
HARD FAIL:
- prompt_object_id 缺失或跨工件不一致
- compiled_request_diff_ref 缺失
- lawful_forgetting_abi_ref 缺失

LINT WARN:
- authority_source 存在但 drift explanation 缺失
- 宿主卡仍混入原文 prompt 大段文本
- 评审卡结论多于对象锚点

REWRITE TARGET:
- host card / CI attachment / review card / handoff package
```

核心原则不是：

- 尽量多留信息

而是：

- 一旦 shared object 断掉，就必须尽早停止假继续

## 8. 苏格拉底式检查清单

在你准备宣布“Prompt artifact validator 已经成立”前，先问自己：

1. 我现在验证的是同一 `compiled request object`，还是几份互相相关的材料。
2. 这次绿灯证明了 shared object 仍成立，还是只证明检查器跑过。
3. stable bytes 的变化是被正式解释了，还是被结果面掩盖了。
4. lawful forgetting 之后留下的是 ABI，还是一段更短的故事。
5. 如果删掉原作者说明，这四类工件是否仍能让后来者继续。
