# Prompt Artifact Harness Runner落地手册：Replay Queue、Prefix Ledger、Continuation Gate 与 Rewrite Adoption

这一章不再解释 Prompt harness runner 为什么重要，而是把它压成团队可复用的落地手册。

它主要回答五个问题：

1. 怎样让 Prompt runner 真正围绕同一 `compiled request object` 连续运行，而不是围绕一次性 replay 运行。
2. 怎样把 `replay queue`、`prefix ledger`、`continuation gate` 与 `rewrite adoption` 放进同一张操作卡。
3. 怎样让宿主、CI、评审与交接沿同一执行顺序消费 Prompt runner，而不是各自补材料。
4. 怎样识别“实验室会跑、绿灯也有、摘要也写了”这类看似成熟、实则无法继续的假落地。
5. 怎样用苏格拉底式追问避免把 Prompt runner 退回定时脚本。

## 0. 代表性源码锚点

- `claude-code-source-code/src/QueryEngine.ts:436-463`
- `claude-code-source-code/src/QueryEngine.ts:687-717`
- `claude-code-source-code/src/QueryEngine.ts:734-750`
- `claude-code-source-code/src/QueryEngine.ts:875-933`
- `claude-code-source-code/src/query.ts:365-375`
- `claude-code-source-code/src/query/stopHooks.ts:84-132`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/services/compact/compact.ts:766-899`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:224-666`
- `claude-code-source-code/src/utils/toolResultStorage.ts:739-908`

这些锚点共同说明：

- Prompt 的持续执行单位不是聊天历史，而是“已被接受并可恢复的请求事实 + compact boundary 之后的 protocol transcript + 可重放的稳定字节资产”。

## 1. 第一性原理

更成熟的 Prompt runner 不是：

- 把 replay case 每天再跑一遍

而是：

- 每次继续前，都重新确认这次消费的仍然是同一份 compiled request truth

所以团队最该先问的不是：

- 现在有没有实验室结果

而是：

- 现在进入主路径的对象是不是同一个 `prompt_object_id`

## 2. Prompt Runner Header

任何 Prompt runner 操作卡都先锁这一组 shared header：

```text
queue_item_id:
prompt_object_id:
compiled_request_diff_ref:
cache_safe_params_ref:
stable_bytes_ledger_ref:
compact_boundary_ref:
lawful_forgetting_abi_ref:
current_object:
next_step_guard:
rollback_object:
rewrite_target:
transition_reason:
resume_consistency_delta:
```

团队规则：

1. 没有 `prompt_object_id` 的 queue item，直接不得入队。
2. 没有 `compiled_request_diff_ref` 与 `stable_bytes_ledger_ref` 的 CI 结果，不得进入 adoption 评审。
3. 没有 `lawful_forgetting_abi_ref` 与 `next_step_guard` 的 handoff，不得当作继续输入。
4. 没有 `compact_boundary_ref` 的 compact 后 replay，不得宣称 continuity 已恢复。
5. 同一 `tool_use_id` 的 replacement fate 一旦冻结，就不得在 resume 后改变。

## 3. Replay Queue Policy

先审 queue 是不是在保护真实 continuation，而不是保护“最后一次跑成功”：

```text
[ ] 用户输入是否先被 transcript 记录，才能进入 queue
[ ] queue item 是否点名当前 prompt_object_id
[ ] compact 之后是否改为消费 boundary 之后的 protocol transcript
[ ] side question / fork / resume 是否继续复用 cache-safe prefix
[ ] queue 里是否显式标出当前 rollback object
[ ] stopHooks 保存的 cache-safe params 是否被复用
```

直接判 drift 的情形：

1. queue 依赖 UI transcript，而不是 compact boundary 之后的请求切片。
2. queue 只保存“最后一次 assistant 输出”，没有 `compiled_request_diff_ref`。
3. fork / resume 重建系统 prompt，而不是复用 already-rendered bytes。
4. 用户消息入队了，但在首个 assistant token 前崩溃后无法 resume。

## 4. Prefix Ledger Review

任何 Prompt runner 都要单独审 prefix ledger，而不是只审 replay verdict：

```text
[ ] cache_safe_params 是否存在
[ ] stable_bytes_ledger 是否存在
[ ] cache break 的 pre-call / post-call 解释是否存在
[ ] tool result replacement 是否按 tool_use_id 冻结
[ ] cache key 是否覆盖 system/tools/cache_control/model/betas/effort/extraBody
[ ] compact 后的 preserved tail 是否已先落盘
```

团队规则：

1. “这次还能跑”不能替代 `cache_safe_params`。
2. “cache hit 了”不能替代 `stable_bytes_ledger`。
3. “工具结果被裁了”不能替代 `tool_use_id -> exact replacement` 账本。
4. 只 hash prompt 文本，不记录完整 cache key 漂移原因。

## 5. Continuation Gate

任何 replay / resume / compact 之后都必须过同一 continuation gate：

```text
[ ] 当前 replay 是否仍围绕同一 prompt_object_id
[ ] 当前 protocol transcript 是否已过 normalizeMessagesForAPI
[ ] orphan tool_result / duplicate tool_use 是否已修复
[ ] lawful forgetting 之后 current_object 是否仍可指出
[ ] next-step guard 是否仍在
[ ] resume_consistency_delta 是否接近 0
```

核心原则不是：

- 让 replay 能继续

而是：

- 让继续这件事仍然围绕同一份 compiled request truth 成立

## 6. Rewrite Adoption Runbook

更稳的 Prompt adoption 顺序应固定为：

1. 先看 drift ledger 指向哪一个 shared object 断裂。
2. 再确认这次 adoption 处理的是 summary 问题，还是 compact boundary / protocol transcript / stopHooks 仲裁问题。
3. 再决定 rewrite target 是 host、CI、review 还是 handoff。
4. 再补回 `compiled_request_diff_ref` / `stable_bytes_ledger_ref` / `lawful_forgetting_abi_ref`。
5. 最后重新 replay，并确认 `next_step_guard`、`resume_consistency_delta` 与 stopHooks 语义仍然成立。

团队记录卡：

```text
本次 drift:
断裂对象:
缺失证据:
rewrite target:
adoption 后重新 replay 的结果:
是否重新进入主路径:
```

## 7. 常见自欺

看到下面信号时，应提高警惕：

1. 用最后一条 assistant 输出替代 compiled request truth。
2. 用 cache hit 替代 stable bytes review。
3. 用 compact 摘要替代 lawful forgetting ABI。
4. 用“fork 成功”替代 byte-exact prefix continuity。
5. 用 adoption 已提交替代 adoption 已重新通过 continuation gate。
6. 用“能 resume”替代 `resume_consistency_delta` 已达标。

## 8. 苏格拉底式检查清单

在你准备宣布“Prompt runner 已经落地”前，先问自己：

1. 我现在消费的是同一份 compiled request truth，还是只是在消费一组相关输出。
2. prefix ledger 记录的是稳定字节资产，还是只记录了结果摘要。
3. compact 之后留下的是合法继续条件，还是更短的历史。
4. rewrite adoption 恢复的是主路径，还是只恢复了表面卡片。
5. stopHooks 保护的是继续条件，还是只充当旁路通知。
6. 如果今天换人接手，他拿到的是 `next_step_guard`，还是 transcript archaeology。
