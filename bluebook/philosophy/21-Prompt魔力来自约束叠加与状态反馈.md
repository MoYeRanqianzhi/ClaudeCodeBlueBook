# Prompt 魔力来自约束叠加与状态反馈

这一章回答四个问题：

1. Claude Code 的 prompt 为什么会显得“比普通 prompt 更有魔力”。
2. 这种魔力为什么不是文案技巧，而是 runtime 约束叠加。
3. 缓存稳定性与状态晚绑定为什么会反过来塑造 prompt 结构。
4. 从第一性原理看，什么才是最难被抄走的 prompt 能力。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/systemPrompt.ts:29-123`
- `claude-code-source-code/src/constants/prompts.ts:226-394`
- `claude-code-source-code/src/constants/prompts.ts:467-549`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:24-260`
- `claude-code-source-code/src/utils/attachments.ts:3521-3685`
- `claude-code-source-code/src/coordinator/coordinatorMode.ts:120-300`
- `claude-code-source-code/src/tools/AgentTool/prompt.ts:48-272`

## 1. 先说结论

Claude Code 的 prompt 魔力，至少来自六层叠加：

1. 装配顺序：
   - override、coordinator、agent、custom、default、append 不是一段 prompt，而是一条优先级链。
2. 角色约束：
   - coordinator、主线程 agent、forked worker、teammate 并不共享同一段 prompt。
3. 工具边界：
   - prompt 里写的不是抽象能力，而是当前运行角色真正可见的工具 ABI。
4. 缓存结构：
   - 静态前缀、动态边界、尾部 attachment 被刻意分层，以维持 cache 稳定性。
5. 状态反馈：
   - date change、relevant memories、mailbox、task notification、channel input 都通过运行时对象晚绑定进入当前轮。
6. 协作语法：
   - 多 Agent prompt 不只是指导语，而是 ownership、汇报格式、禁止事项和任务边界的正式语法。

所以 Claude Code 的 prompt 强，不是因为某段 system prompt 单独强，而是因为 prompt 已经被嵌进了一个持续运行的约束系统。

## 2. Prompt 首先是合同，不是文案

从第一性原理看，一个真正长期可用的 agent prompt，至少必须回答五个问题：

1. 你是谁。
2. 你能做什么。
3. 你不能做什么。
4. 你当前看到了什么最新状态。
5. 你和其他执行单元怎样分工。

Claude Code 强的地方在于，这五个问题并不都靠静态文本承担。

- 身份与工具边界来自角色化 prompt 和工具池。
- 最新状态来自 attachment 与外化状态对象。
- 协作分工来自 coordinator law、task 对象与 mailbox 语义。

也就是说，prompt 在这里更像：

- 合同文本

而不是：

- 一次性劝导文案

更准确一点说，prompt 首先是：

- 合同装配顺序

`buildEffectiveSystemPrompt(...)` 先决定 override / coordinator / agent / custom / default / append 的覆盖关系，再决定最终文本形态。真正难抄走的不是哪句 system prompt，而是：

- 哪些角色在什么前提下拿到哪一层合同
- 哪些补丁允许追加，哪些必须替换
- 角色切换时缓存和状态怎样保持可解释

## 3. 为什么 cache 稳定性会反过来塑造 prompt

如果只站在文案作者视角，会觉得 prompt 先写完，再做性能优化。

Claude Code 的源码恰恰说明相反：

1. 系统先区分静态前缀与动态边界。
2. 再决定哪些内容必须通过 attachment 晚绑定。
3. 最后才得到最终 prompt 形态。

这会带来三个直接结果：

1. 动态状态尽量不打爆前缀 cache。
2. 频繁变化的信息优先外移为 delta / reminder。
3. prompt 本身更偏规则层，而不是现场状态镜像层。

所以 Claude Code 的 prompt 看起来“更稳”，不是因为句子更顺，而是因为它尽量避免把高频抖动状态写进静态合同。

还有一层很关键但容易被忽略的原因：

- prompt 看到的工具 ABI 本身也被做成 cache-stable contract

`filterToolsByDenyRules(...)` 会在模型看见工具前先做 deny 预裁剪，`assembleToolPool(...)` 会把 built-in 和 MCP 工具分区排序，避免 MCP 工具插进 built-in 前缀，把整段 prompt cache 一起打碎。

所以“prompt 魔力”并不只来自 system prompt 文本，还来自：

- 模型看到的是一组被提前裁剪、排序并稳定过的行动空间

## 4. 为什么状态反馈比文案更重要

Claude Code 很少让静态 prompt 独自承担“理解现场”的任务。

它更常见的做法是：

1. 静态 prompt 负责规则。
2. attachment 负责现场。
3. 外化状态负责 authoritative truth。

这样做的价值是：

- 规则和现场不会互相污染。
- 缓存命中率不会被时间、记忆、通知等高频变量反复打碎。
- 模型每轮看到的是“规则 + 最新现场”，而不是一段不断膨胀的巨型 prompt。

这正是很多人主观感受到的“Claude Code 好像更懂现场”的来源。

它不是猜得更准，而是现场真的被 runtime 以更低噪音的方式喂给了它。

## 5. 为什么多 Agent prompt 的本体是协作语法

多 Agent prompt 最容易被误写成：

- 给 worker 的几句 instruction

但 `coordinatorMode.ts` 和 `AgentTool/prompt.ts` 说明，真正起作用的是一整套协作语法：

1. 谁负责综合。
2. 谁负责局部执行。
3. 何时必须汇报。
4. 结果必须如何表达。
5. 哪些行为被显式禁止。

而 mailbox / task / notification 再把这套语法接进运行时对象层。

所以所谓“多 Agent prompt 很强”，真正的本体不是句式，而是：

- prompt 语法
- task 对象
- mailbox 协议
- 状态回写

四者一起工作。

再往前一步看，coordinator prompt 里最强的并不是“多叫几个 worker”，而是强迫主线程承担：

- 先综合，再下发
- prompt 必须自包含
- 不能把“based on your findings”这种理解责任继续甩给下游 worker

这让多 Agent 协作避免退化成：

- 一群互相转述、但没人真正理解问题的 agent

## 6. 苏格拉底式追问

### 6.1 如果直接抄 system prompt，能复制这套魔力吗

不能。

因为被抄走的只是文字，没被抄走的是：

- 角色切换逻辑
- attachment 注入链
- cache 结构
- mailbox 与任务对象

### 6.2 如果 prompt 已经很强，为什么还需要 attachment

因为动态状态太多，直接塞进静态 prompt 只会导致：

- cache 抖动
- token 膨胀
- 规则和现场混写

### 6.3 如果多 Agent prompt 已经写得很细，为什么还需要 task / mailbox

因为没有 task 对象与 mailbox，所谓协作 prompt 最终只会退化成：

- 多个会说话的副本

而不是：

- 多个受约束、可恢复、可通信的协作单元

### 6.4 如果把权限、channel、worker 协议都当普通聊天文本，可不可以

不可以。

因为一旦把这些结构化信号也混成普通文本：

- 权限协议会污染普通对话语义
- channel 回复会变成可伪造的“聊天内容”
- worker mailbox 会把结构化协议消息误送进 LLM 上下文

Claude Code 更强的地方恰恰在于，它努力把：

- 可供模型理解的文本
- 必须由 runtime 专门处理的协议事件

分开处理。

## 7. 一句话总结

Claude Code 的 prompt 魔力，不是神秘文案，而是“装配顺序 + 角色合同 + 工具边界 + 缓存结构 + 状态反馈 + 协作语法”六层叠加出来的 runtime 效果。
