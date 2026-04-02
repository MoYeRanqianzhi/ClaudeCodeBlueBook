# Prompt Constitution控制面：section宪法、角色主权链、合法遗忘与可观测diff

这一章回答五个问题：

1. 为什么 Claude Code 的 prompt 不该被理解成一段 system prompt，而应被理解成一套可执行的 Constitution。
2. 为什么 section registry、dynamic boundary、角色优先级链、合法遗忘和 transport 不变语义必须一起看。
3. 为什么 prompt 的稳定性不是性能技巧，而是 prompt Constitution 的制度效果。
4. 为什么 prompt 必须像协议一样可分段、可编译、可 diff、可诊断。
5. 这对 agent runtime 设计者意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/prompts.ts:105-560`
- `claude-code-source-code/src/constants/systemPromptSections.ts:1-60`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-115`
- `claude-code-source-code/src/utils/api.ts:321-388`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/conversationRecovery.ts:226-297`
- `claude-code-source-code/src/services/compact/prompt.ts:1-220`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:188-397`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:28-520`
- `claude-code-source-code/src/utils/analyzeContext.ts:204-281`

## 1. 先说结论

Claude Code 的 prompt 底盘不是：

- 一段拼好的长字符串

而是四层制度共同作用后的结果：

1. section 宪法：
   - prompt 由哪些条款组成，哪些条款是稳定正文，哪些条款是动态修正案。
2. 角色主权链：
   - 当前究竟是谁在定义运行身份，谁有权覆盖谁。
3. 合法遗忘：
   - 哪些历史可以删，删到什么程度仍然合法。
4. 可观测 diff：
   - prompt 为什么稳定、为什么失稳、究竟哪一段改了。

这四层放在一起，才构成 Claude Code 真正的：

- Prompt Constitution control plane

## 2. section 宪法：prompt 先被拆成条款，而不是直接写成总纲

`prompts.ts` 里最重要的结构不是哪一段文案，而是：

1. static sections；
2. dynamic sections；
3. `SYSTEM_PROMPT_DYNAMIC_BOUNDARY`；
4. `systemPromptSection(...)`；
5. `DANGEROUS_uncachedSystemPromptSection(...)`。

这说明 Claude Code 先制度化了两个问题：

1. 哪些内容属于稳定正文。
2. 哪些内容属于动态条款，且一旦变化会显式打碎 cache。

`systemPromptSections.ts` 又进一步把这套制度落成了可执行 registry：

1. 普通 section 会 memoize；
2. 危险 section 必须显式声明理由；
3. `/clear` 与 `/compact` 会重置这套状态。

这意味着 prompt 的“魔力”首先来自：

- 变更控制

而不是某句措辞本身。

如果没有 section 宪法，任何新能力接入都只能靠：

- 在同一段 prompt 上继续加字

这样系统就会同时失去：

- cache 稳定性；
- diff 能力；
- prompt 结构解释力。

## 3. dynamic boundary：边界不是注释，而是可执行法律

`SYSTEM_PROMPT_DYNAMIC_BOUNDARY` 的作用远不只是提醒开发者。

在 `utils/api.ts` 里，这条 boundary 会被：

1. `splitSysPromptPrefix()` 拆成 prefix / suffix；
2. `buildSystemPromptBlocks()` 编译成不同 cache scope 的 text blocks；
3. 最终转成真正发往 API 的 system prompt block 序列。

这说明 Claude Code 不是“写了边界说明”，而是：

- 把边界本身编译执行

从运行时角度看，这一层解决的是：

1. 哪些条款必须被视为共享宪法；
2. 哪些条款可以按回合重算；
3. 哪些变化会被当成正式 cache-break 事件。

所以 Prompt Constitution 的核心并不只是条款内容，而是：

- 条款如何获得不同法律效力

## 4. 角色主权链：谁在发言，决定 prompt 的真正形态

`buildEffectiveSystemPrompt()` 不是在给模型补充身份设定，而是在做角色主权调度。

它明确定义了优先级：

1. override；
2. coordinator；
3. main-thread agent；
4. custom；
5. default；
6. append。

并且还处理了一种更细的制度差异：

- proactive 模式下 agent prompt 不是替换默认，而是追加默认。

这意味着 prompt 的真正问题不是：

- “你是谁”

而是：

- “这一轮里，谁有权定义你是谁”

这条角色主权链解决的是 Claude Code 的一个核心难题：

1. coordinator 和 main loop 不能互相踩身份；
2. agent domain prompt 与 default runtime prompt 不能随意混写；
3. 用户 override 必须成为正式上位权威，而不是附加说明。

所以 Claude Code 的 prompt 稳定性，本质上有一半来自：

- 角色主权顺序稳定

## 5. protocol truth law：并非所有消息都有资格进入 prompt 真相

`normalizeMessagesForAPI()` 是 Prompt Constitution 的准入法。

它会：

1. 重排 attachment；
2. 剥掉 virtual / progress / synthetic error；
3. 把某些 local command 重新编码成 user turn；
4. 移除无效 `tool_reference`；
5. 补 sibling text 防止 stop sequence 采样错误。

这说明 Claude Code 不把 UI 看到的一切都自动视作 prompt 真相。

它在明确区分：

1. display truth；
2. protocol truth。

从运行时底盘看，这一层的作用不是“显示优化”，而是：

- 规定哪些对象有资格进入 prompt Constitution

一旦没有这层准入法，前台簿记消息、补偿消息和错误消息都会污染模型世界。

## 6. 合法遗忘：删什么、怎么删，和写什么同样重要

`services/compact/prompt.ts`、`sessionMemoryCompact.ts`、`conversationRecovery.ts` 共同构成 Prompt Constitution 的遗忘法。

它们做了三件事：

1. compact prompt 明确规定必须保留：
   - user intent
   - current work
   - next step
   - direct quotes
   - files and code sections
2. session memory compact 会回调切点，确保：
   - `tool_use / tool_result` 配对不断裂
   - thinking block 与共享 `message.id` 的归属链不断裂
3. conversation recovery 会在必要时补 synthetic assistant sentinel，让中断后的会话仍保持 API-valid。

这说明 Claude Code 的遗忘不是：

- 摘要一下历史

而是：

- 在不破坏 prompt Constitution 的前提下，合法删减历史

更准确地说，Claude Code 的 prompt 魔力并不只来自：

- 写入什么

同样来自：

- 删除什么以后系统仍然能继续工作

## 7. transport 不变语义：不同载体必须服从同一部宪法

Claude Code 的 prompt 并不绑定某一个 transport。

从架构上看：

1. API 路径有 `normalizeMessagesForAPI()`；
2. recovery 路径会补边界；
3. remote / SDK / bridge 层会过滤 echo、状态事件和 display-only 消息；
4. MCP instructions 在某些模式下会从 system prompt 本体转成 `mcp_instructions_delta` attachment。

这说明 Claude Code 在处理 transport 差异时，保护的不是：

- payload 一致

而是：

- prompt 语义一致

也就是说，Prompt Constitution 真正治理的是：

- 不同 transport 之上的不变语义层

这也是为什么 Claude Code 能在 REPL、SDK、remote viewer、bridge 之间保持 prompt 真义不散架。

## 8. prompt observability：宪法必须可 diff、可解释、可计量

Prompt Constitution 的最后一层不是写作，而是观测。

`promptCacheBreakDetection.ts` 会记录：

1. system hash；
2. tools hash；
3. cache control hash；
4. betas；
5. effort；
6. extra body；
7. 甚至可 diff 的内容快照。

`analyzeContext.ts` 又会复用同一份 `buildEffectiveSystemPrompt()`，对 sections 做 token breakdown。

这说明 Claude Code 已经把 prompt 提升成：

- 一条需要被正式观测和诊断的基础设施路径

真正成熟的 prompt 系统，不只是：

- 这次看起来有效

而是还必须能回答：

1. 为什么这次稳定；
2. 为什么这次失稳；
3. 究竟是哪个 section、哪条 beta、哪份 schema 在制造漂移。

## 9. 为什么这是控制面，而不是 prompt 附属层

把以上几层放在一起看，Claude Code 做的并不是“优化 prompt”。

它是在构造一套完整控制面：

1. section registry 决定 prompt 的立法单位；
2. dynamic boundary 决定条款的法律效力；
3. role sovereignty 决定谁有解释权；
4. protocol truth law 决定什么可进入宪法正文；
5. lawful forgetting 决定删掉什么后仍合法；
6. prompt observability 决定系统如何审计这部宪法。

这就是为什么 prompt 在 Claude Code 里不再是：

- 单次请求输入

而是：

- Prompt Constitution control plane

## 10. 一句话总结

Claude Code 的 prompt 底盘之所以强，不是因为它写了一段更好的 system prompt，而是因为它把 prompt 做成了一部可执行宪法：按 section 立法、按角色分配主权、按协议准入真相、按遗忘法维护连续性，并按 diff 与观测机制持续解释自身。
