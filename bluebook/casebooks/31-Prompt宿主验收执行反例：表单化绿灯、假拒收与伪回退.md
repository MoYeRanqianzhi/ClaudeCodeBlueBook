# Prompt宿主验收执行反例：表单化绿灯、假拒收与伪回退

这一章不再回答“Prompt 宿主验收执行该怎样运行”，而是回答：

- 为什么团队明明已经写了 `compiled request truth` 的执行卡、reject reason 与 rollback 剧本，仍会重新退回字段齐全感、表单化绿灯与 last-message heuristic。

它主要回答五个问题：

1. 为什么 Prompt 宿主验收执行最危险的失败方式不是“没有执行卡”，而是“执行卡存在，却仍围绕表单存在性工作”。
2. 为什么表单化绿灯最容易把 `compiled request truth` 重新退回字符串、截图与摘要。
3. 为什么假 reject 最容易把 `reject_reason` 重新退回 reviewer 情绪、token 不适与 later 补写说明。
4. 为什么伪 rollback 最容易把对象级回退重新退回旧 prompt 文案、旧摘要与最后一条消息。
5. 怎样用苏格拉底式追问避免把这些反例读成“把验收表再填细一点就好”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:343-347`
- `claude-code-source-code/src/utils/api.ts:136-405`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:494-698`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/services/compact/prompt.ts:293-337`
- `claude-code-source-code/src/services/compact/compact.ts:330-711`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-66`
- `claude-code-source-code/src/query/stopHooks.ts:257-331`
- `claude-code-source-code/src/query.ts:1258-1518`
- `claude-code-source-code/src/utils/sessionState.ts:92-146`

这些锚点共同说明：

- Prompt 宿主验收执行真正最容易失真的地方，不在执行卡有没有写出来，而在执行卡是否仍围绕同一个 `compiled request truth`、`protocol transcript`、`lawful forgetting object` 与 `continue qualification` 运作。

## 1. 第一性原理

Prompt 宿主验收执行最危险的，不是：

- 没有执行卡
- 没有 reject 字段
- 没有 rollback 剧本

而是：

- 这些东西已经存在，却仍然围绕表单转绿、提示词截图与“先继续一轮再看”运作

一旦如此，团队就会重新回到：

1. 看字段是不是都填了
2. 看 CI 有没有转绿
3. 看 reviewer 有没有明确反对
4. 看最后一条消息像不像还能继续

而不再围绕：

- 同一个 `compiled request truth`

## 2. 表单化绿灯：执行卡存在即视为验收通过

### 坏解法

- 宿主、CI、评审与交接系统只要都拿到一张卡，就默认 Prompt 宿主验收已经成立，不再检查卡上的对象是否仍指向同一个 `compiled request truth`。

### 为什么坏

- Claude Code 的 Prompt 魔力不是来自“卡片上有更多字段”，而是来自 `compiled request truth`、`section registry`、`stable prefix boundary`、`protocol transcript` 与 `lawful forgetting object` 仍被当成一个协议对象消费。
- 一旦执行层只验证“字段齐了”，就会重新容忍：
  - `section_registry_snapshot` 只是抄录而不是 live object
  - `protocol_transcript_health` 只是空位补值而不是 rewrite 真相
  - `continue_qualification` 只是表格尾部的说明而不是正式 gate
- 这样看起来更制度化，实际却更容易把 Prompt 魔力消解成表单工艺。

### Claude Code 式正解

- 执行卡应该验证对象是否还活着，而不是验证字段是否都出现过。

### 改写路径

1. 把“字段是否存在”降为最外层 lint。
2. 把 `compiled request truth`、`protocol transcript health` 与 `lawful forgetting object` 提升为通过前提。
3. 任何只因表单齐全就转绿的 Prompt 宿主验收都判为 drift。

## 3. 假拒收：有 reject reason 名字，却没有 reject 顺序

### 坏解法

- 团队虽然写了 `reject_reason`，但真正拒收时仍靠 reviewer 不适感、token 变贵、看起来不稳定，或者 later 在复盘里补写一条理由。

### 为什么坏

- Prompt 宿主验收真正的拒收顺序应首先保护 authority 与 boundary，再保护 transcript，再保护 handoff，再保护 continue gate。
- 一旦 reject 顺序失踪，团队就会出现：
  - boundary 漂了却不拒收
  - transcript 失真却继续灰度
  - compact 只剩摘要却仍让交接ผ่าน
  - `continue_qualification` 不一致却只记成体验问题
- 这会把 reject reason 重新退回语言风格，而不是协议真相。

### Claude Code 式正解

- reject 应先保护对象边界，后保护体验后果；任何倒序 reject 都是在纵容第二真相。

### 改写路径

1. 把 `raw_sysprompt_authority / missing_section_registry / transcript_repair_required / summary_only_handoff / continue_state_inconsistent` 固定成正式顺序。
2. 禁止 later 补写 reject reason 取代现场判定。
3. 任何“有 reject 词表、没 reject 顺序”的 Prompt 宿主验收都判为 drift。

## 4. 伪回退：回退到旧 prompt 文案、旧摘要与最后一条消息

### 坏解法

- rollback 看起来存在，实际只是回到上一版 prompt 文案、上一份摘要、上一轮最后一条消息或“重新跑一遍看看”。

### 为什么坏

- Prompt 回退真正该回的不是文案，而是上一个仍可验证的 `request_object`、`stable boundary` 或 lawful forgetting boundary。
- 一旦回退只剩旧摘要与旧消息，团队就无法分清：
  - 是 section law 变了
  - 是 tool schema 漂了
  - 是 rewrite 失真了
  - 还是 compact baseline 没重置
- 这会把 rollback 从对象级恢复重新退回叙事级安慰。

### Claude Code 式正解

- rollback 应围绕 `request_object`、boundary 与 preserved segment，而不是围绕“看起来像上一版”。

### 改写路径

1. 把 prompt 文案与 summary 降为辅助材料。
2. 把 `rollback_object` 明确绑定到 `compiled request truth` 的上一个合法对象边界。
3. 任何只回退文案、截图与最后一条消息的 Prompt rollback 都判为 drift。

## 5. protocol truth 被 CI 绿灯掩盖

### 坏解法

- CI 只要看到缓存、格式和字段校验通过，就默认 Prompt 验收通过，不再检查 raw history 与 `protocol transcript` 是否仍然分层。

### 为什么坏

- Claude Code 的 Prompt 真正面对模型的是 rewrite 之后的 protocol 世界，而不是 UI 历史。
- 一旦 CI 绿灯掩盖了 protocol gap，团队会最先误以为：
  - “日志都在，应该没问题”
  - “字段都齐，应该能继续”
- 这会让 Prompt 魔力在执行层被直接消解成日志存在性感。

### Claude Code 式正解

- CI 绿灯只能证明表面完整，不能替代 `protocol_transcript_health`。

### 改写路径

1. 把 protocol transcript health 提升为独立门禁。
2. 把 raw transcript 降为调试材料。
3. 任何“CI 绿灯即 Prompt 世界正确”的执行验收都判为 drift。

## 6. compact handoff 被交接通过感掩盖

### 坏解法

- 交接系统只要看到 summary 与 next step，就默认 compact handoff 通过，不再检查 `compact_boundary` 与 `preserved_segment`。

### 为什么坏

- Claude Code 的 lawful forgetting 保护的是“later 还能继续行动的对象”，不是“later 还能看懂故事”。
- 一旦交接只剩通过感，Prompt 验收执行就会最先退回“可读摘要”而不是“可继续对象”。

### Claude Code 式正解

- 交接通过应围绕 lawful forgetting object，而不是围绕 summary 可读性。

### 改写路径

1. 把 summary 降为交接说明，不再当通过依据。
2. 把 `compact_boundary / preserved_segment / next_step` 提升为交接硬条件。
3. 任何只看摘要通过感的 Prompt handoff 都判为 drift。

## 7. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在验证的是协议对象，还是表单存在性。
2. 我现在拒收的是对象边界漂移，还是 reviewer 情绪与 later 补写说明。
3. 我现在回退的是 `request_object`，还是旧 prompt 文案与旧摘要。
4. 我现在保护的是 protocol truth，还是 CI 绿灯。
5. 我现在交接的是 lawful forgetting object，还是一段可读故事。

## 8. 一句话总结

真正危险的 Prompt 宿主验收执行失败，不是没写执行卡，而是写了执行卡却仍在围绕表单化绿灯、假拒收与伪回退消费 Prompt 世界。
