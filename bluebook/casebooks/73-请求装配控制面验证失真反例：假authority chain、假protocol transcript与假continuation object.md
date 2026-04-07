# 请求装配控制面验证失真反例：假lineage kernel、假protocol transcript与假continuation object

这一章不再回答“请求装配控制面该怎样持续验证”，而是回答：

- 为什么团队明明已经有 `playbooks/77` 这一类验证手册，仍会把字段齐全、绿灯通过与 summary 能续写误当成同一个 request object 还活着。

它主要回答五个问题：

1. 为什么请求装配控制面最危险的失败方式不是“没有验证”，而是“验证还在，但验真的对象已经被偷换”。
2. 为什么假 `lineage kernel` 最容易让 handoff、summary 与 section 壁纸悄悄接管主权。
3. 为什么假 `protocol transcript` 最容易把 display transcript 偷换成模型真相。
4. 为什么假 `continuation object` 最容易把 lawful forgetting 重新退回“更短的故事”。
5. 怎样用苏格拉底式追问避免把这些反例读成“再补几条 Prompt 测试”。

这里还应再多记一句：

- 这页里的 continuity 失真不是第四类 Prompt 反例家族；它只是 `Continuation` 这一 rung 被 summary、handoff 与平行 world prose 夺权后的失真样式。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/systemPrompt.ts:28-123`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5458`
- `claude-code-source-code/src/utils/sessionStorage.ts:1025-1034`
- `claude-code-source-code/src/utils/sessionStorage.ts:2069-2128`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:188-327`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/tools/AgentTool/resumeAgent.ts:70-130`
- `claude-code-source-code/src/utils/forkedAgent.ts:46-126`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:483-698`

这些锚点共同说明：

- 请求装配控制面真正要保护的，不是“我们还记得这些字段”，而是 `message lineage`、`protocol transcript`、`continuation object` 与 fork reuse 是否仍围绕同一个 request world 被共同消费。

## 1. 第一性原理

请求装配控制面验证最危险的，不是：

- 没有验真卡
- 没有回归绿灯

而是：

- 绿灯已经存在，却没有继续绑定同一个 request object

一旦如此，团队就会重新回到：

1. 看卡片字段还在不在。
2. 看 transcript 看起来顺不顺。
3. 看 compact summary 能不能继续讲故事。
4. 看 worker / side loop 的结果像不像同一个世界。

而不再围绕：

- 同一个 `lineage_kernel + protocol_transcript + continuation_object + cache_safe_fork`

更硬一点说，这里真正坏掉的不是“恢复体验”，而是 Prompt 时间轴上 `continuation object -> continuation qualification -> cache-safe fork reuse` 这一段开始被当成 prose continuation。

## 2. 假lineage kernel vs 同一请求对象

### 坏解法

- `section registry`、边界字段、handoff 文本与评审结论都还在，于是团队默认 lineage 还在。

### 为什么坏

- `lineage_kernel_shadowed` 最常见的形式，不是历史消失，而是 `parentUuid / logicalParentUuid`、`message.id` 与 `tool_use_id / sourceToolAssistantUUID` 这组三键已经断开，却仍被 prose 冒充成“同一条线”。
- 一旦 registry 退回壁纸，团队就会把“看起来像同一套 Prompt 法典”误读成“仍是同一个请求对象”。
- 后来者将无法指出：这一轮到底是哪三个锚点还在接住同一个现场。

### Claude Code 式正解

- 验真 verdict 必须继续绑定同一个 `lineage kernel`，而不是绑定“解释材料仍然完整”的感觉。
- `section registry` 只能证明法律地位还在，不能替代 `lineage kernel` 本身。

## 3. 假protocol transcript vs display 真相篡位

### 坏解法

- UI transcript、日志回放、人工整理的 markdown 历史被直接当成 protocol transcript；tool pairing 也靠人眼补全。

### 为什么坏

- `display_protocol_conflation` 一旦发生，模型消费的世界就会退回“人类最容易读什么”，而不是“协议正式允许什么”。
- `tool_pairing_unattested` 会让工具链看起来没坏，实际却已经失去合法消息 ABI。
- Prompt 魔力会从协议诚实退回可读性崇拜。

### Claude Code 式正解

- display transcript 只能是显示层事实，不能替代 protocol transcript。
- pairing 要么被正式证明，要么直接拒收；不能靠“看起来差不多”补票。

## 4. 假continuation object vs summary 续写幻觉

### 坏解法

- compact、resume、handoff 后只剩 summary prose，但团队仍把“还能接着讲”误当成 continuation object 还在。

### 为什么坏

- `continuation_story_only` 意味着 lawful forgetting 已经退回叙事压缩，而不是对象保全。
- 系统忘掉的会不再只是噪音，而是 current work、next-step guard、required assets、rollback boundary、continue qualification 与 threshold liability。
- later resume 看起来像恢复成功，实际上只是拿着故事重新猜世界。

### Claude Code 式正解

- continuation object 必须继续显式保住当前工作、下一步、保留边界、必需资产与继续资格。
- summary 只是 continuation object 的投影，不能冒充 continuation object 本身。

## 5. 平行世界续写 vs cache-safe fork continuity

### 坏解法

- worker、side loop、suggestion、stop hook 只要“结果相近”就被当作还活在同一个世界；cache break 也只被说成“最近有点飘”。

### 为什么坏

- `parallel_world_fork_detected` 最危险的地方，不是分叉本身，而是分叉仍被汇总成一次“验证通过”。
- `cache_break_unexplainable` 会把对象级 drift 重新神秘化。
- 宿主、CI、评审与交接各自消费不同投影时，就会出现 `consumer_verdict_split`。

### Claude Code 式正解

- fork reuse 必须说明自己复用了哪一份 stable prefix / authority context。
- cache break 必须被解释到边界、schema、history 或参数层；不能再靠体感归因。

## 6. 从更多角度看它为什么迷惑

这类假象之所以迷惑，至少有五个原因：

1. 它借用了真正严格的外观：卡片、日志、handoff、summary、worker findings 都看起来像在认真验真。
2. 它满足了不同角色最容易满足的局部需求：宿主要顺，CI 要绿，评审要能解释，交接要能读懂。
3. 它把“模型实际消费什么”偷换成了“人类现在最容易读什么”。
4. 它把“对象仍连续”偷换成了“投影之间还算一致”。
5. 它把 Prompt 魔力从可验证的对象链偷换成了更像真相的材料表演。

## 7. 苏格拉底式追问

在你准备宣布“请求装配控制面验证仍然健康”前，先问自己：

1. 我现在绑定的是同一个 `lineage kernel`，还是一组相互解释的 prose。
2. 模型现在消费的是 protocol transcript，还是 display transcript 的替身。
3. compact 之后我保住的是 continuation object，还是一段更顺的 summary。
4. worker 与 side loop 是在复用同一个世界，还是在制造平行世界。
5. 这次绿灯如果被 later 团队复查，是否还能指出它到底保护了哪个 lineage kernel、哪个 protocol transcript 与哪个 continuation object。
