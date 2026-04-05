# Prompt宿主消费反例：字符串崇拜、缓存黑箱与继续资格误判

这一章不再回答“宿主该怎样消费 Prompt 编译支持面”，而是回答：

- 为什么宿主、SDK、CI 与交接系统明明已经拿到了 `systemPrompt` 输入面、`section breakdown`、`message breakdown`、`cache break reason` 与 `continue qualification` 投影，仍会重新退回字符串崇拜、黑箱稳定性与最后一条消息启发式。

它主要回答五个问题：

1. 为什么 Prompt 宿主消费最危险的失败方式不是“没接 prompt”，而是“把 Prompt 支持面重新消费成一个大字符串”。
2. 为什么 section breakdown 一旦被误读成文案目录，宿主就会主动打碎 stable prefix。
3. 为什么 cache break 一旦退回黑箱指标，宿主就会重新把 Prompt 魔力神秘化。
4. 为什么 continue qualification 一旦被误消费成 `stop_reason` 或最后一条消息，宿主就会重新误判任务状态。
5. 怎样用苏格拉底式追问避免把这些反例读成“前端没把字段接全”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:20-65`
- `claude-code-source-code/src/constants/prompts.ts:343-347`
- `claude-code-source-code/src/constants/prompts.ts:560-576`
- `claude-code-source-code/src/utils/api.ts:119-150`
- `claude-code-source-code/src/utils/api.ts:321-405`
- `claude-code-source-code/src/services/api/claude.ts:1374-1485`
- `claude-code-source-code/src/services/api/claude.ts:3213-3236`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:470-698`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/utils/messages.ts:5133-5460`
- `claude-code-source-code/src/services/compact/compact.ts:330-366`
- `claude-code-source-code/src/services/compact/compact.ts:596-711`
- `claude-code-source-code/src/query/stopHooks.ts:257-331`
- `claude-code-source-code/src/query.ts:1258-1340`

这些锚点共同说明：

- Prompt 宿主消费真正最容易退化的地方，不在是否拿到了更多字段，而在是否还围绕同一个 compiled request truth 的正式投影消费 Prompt 世界。

## 1. 第一性原理

Prompt 宿主消费最危险的，不是：

- 没有 `systemPrompt`
- 没有 token 数

而是：

- 已经有了 Prompt 支持面，却仍然把这些支持面重新消费成字符串、黑箱成本与 last-message heuristic

一旦如此，宿主就会重新回到：

1. 看原文 prompt
2. 看一串 token 数
3. 看最后一条消息
4. 看一段 summary

而不再围绕：

- 同一个 `compiled request truth`

## 2. 把 `systemPrompt` 当唯一真相 vs compiled request truth

### 坏解法

- 宿主只保存或展示一整段拼好的 `systemPrompt` 字符串，并把它当成 Prompt 世界的唯一真相。

### 为什么坏

- 真正的请求真相还包括 section registry、stable/dynamic 边界、tool schema、headers 与 body params。
- 只看字符串会让宿主丢掉哪些变化真的触碰了 request truth，哪些变化只是动态尾部或 ABI 漂移。
- later cache miss 或行为变化发生时，宿主无法解释是 Prompt law 漂了，还是外围编译对象漂了。

### Claude Code 式正解

- 宿主最多把 `systemPrompt` 当输入面，而不把它当编译真相本体。
- 真正应该消费的是输入面 + section breakdown + 继续资格投影，而不是只消费一段字符串。


## 3. 把 section breakdown 当文案目录 vs runtime registry

### 坏解法

- 宿主把 `section breakdown` 理解成“Prompt 的目录结构”，只把它当可读性装饰。

### 为什么坏

- section breakdown 真正回答的是哪些 section 稳定、哪些 section 必须 dynamic、哪些 section 会触发 cache break。
- 一旦宿主把它退回目录展示，就会主动要求“每轮都重算”“每轮都完整显示”，把 stable prefix 自己打碎。
- later 团队会误以为 section registry 只是文档组织，而不是运行时注册表。

### Claude Code 式正解

- 宿主应把 section breakdown 理解成 stable prefix 的正式投影，而不是普通 outline。
- 重点消费的是 section 身份、占席位情况与稳定边界，而不是章节排版。


## 4. cache break 退回黑箱指标 vs explainability

### 坏解法

- 宿主只看 `cache read tokens`、命中率或“最近变贵了”，不消费 `cache break reason` 的正式解释。

### 为什么坏

- 这样会把 Prompt 稳定性重新退回黑箱观察。
- 宿主无法分清 server-side eviction、cached microcompact 删除、model/tool/system/beta/extraBody 变化。
- later CI 与交接只能知道“变贵了”，不知道为什么贵、该改哪一层。

### Claude Code 式正解

- 宿主应围绕 cache break reason 的正式分类与 drift ledger 消费稳定性。
- token 变化只能是结果投影，不能替代 break explanation。


## 5. 把 raw transcript 当 protocol truth vs protocol rewrite

### 坏解法

- 宿主直接消费 JSONL、原始历史或 display transcript，把它当模型真正看到的 transcript。

### 为什么坏

- 模型实际消费的是 `normalizeMessagesForAPI()` 与 `ensureToolResultPairing()` 之后的合法协议面。
- raw transcript 里可能包含 display-only、orphaned tool_result、duplicate tool_use 与 resume 造成的坏首条结构。
- 宿主如果用 raw transcript 做评测、交接或回放，就会和模型实际世界错位。

### Claude Code 式正解

- 宿主应把 raw transcript 与 protocol truth 分层消费。
- 任何“模型看到什么”的判断都应围绕合法协议面投影，而不是前台原样历史。


## 6. 继续资格误判 vs continue qualification

### 坏解法

- 宿主只看最后一条消息、`stop_reason` 或某个 spinner，就判断当前已经结束、还在继续或已经卡住。

### 为什么坏

- stop hooks 可能在 assistant 之后追加 progress / attachment。
- API error 分支会跳过 stop hooks 以避免 death spiral。
- 当前真正的继续资格已经通过 `post_turn_summary`、`task_summary`、state 变化、Context Usage 和 stop hooks 结果被外化。

### Claude Code 式正解

- 宿主应围绕 continue qualification 的正式投影判断状态，而不是围绕最后一条消息启发式。
- `state + summary + Context Usage + pending action` 才是当前继续资格的正式消费面。


## 7. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是 compiled request truth，还是一段 system prompt 字符串。
2. 我看到的是 runtime registry 投影，还是文案目录。
3. cache miss 是被正式解释了，还是仍然停留在黑箱成本。
4. 宿主消费的是 protocol truth，还是 raw transcript。
5. 当前继续资格是被正式判断了，还是只是被最后一条消息猜出来的。
