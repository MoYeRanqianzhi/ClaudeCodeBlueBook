# 提示词合同、缓存稳定性与多Agent语法

这一章回答五个问题：

1. Claude Code 的 prompt 为什么看起来“有魔力”。
2. 这种魔力为什么不是文案技巧，而是合同装配。
3. cache 稳定性为什么会反过来塑造 prompt 结构。
4. 多 Agent prompt 为什么本质上是协作语法，而不是几句命令模板。
5. 从源码看，Claude Code 真正不可复制的 prompt 部分是什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/systemPrompt.ts:29-123`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:343-350`
- `claude-code-source-code/src/constants/prompts.ts:508-549`
- `claude-code-source-code/src/context.ts:22-34`
- `claude-code-source-code/src/context.ts:113-149`
- `claude-code-source-code/src/utils/attachments.ts:500-522`
- `claude-code-source-code/src/utils/attachments.ts:1403-1489`
- `claude-code-source-code/src/utils/attachments.ts:3521-3685`
- `claude-code-source-code/src/coordinator/coordinatorMode.ts:120-300`

## 1. 先说结论

Claude Code 的 prompt 魔力来自四层叠加：

1. 角色合同：
   - coordinator、主线程 agent、proactive、forked worker 各有不同 prompt 形态。
2. 缓存结构：
   - 静态前缀、动态边界、尾部 attachment 被精心分层。
3. 状态反馈：
   - mailbox、date change、memory surfacing、tool/result delta 会把运行时状态晚绑定进 prompt。
4. 协作语法：
   - 多 Agent prompt 不是口号，而是 ownership、汇报方式、禁止事项和任务对象的正式语法。

也就是说，Claude Code 的 prompt 强，不是因为某几句话更会写，而是因为这些句子被嵌进了一台持续运行的 runtime。

## 2. Prompt 首先是装配顺序，不是最终文案

`buildEffectiveSystemPrompt(...)` 清楚定义了优先级：

1. override prompt
2. coordinator prompt
3. agent prompt
4. custom system prompt
5. default prompt
6. append system prompt

这里最重要的不是“谁覆盖谁”，而是：

- 角色切换本身就是 runtime 事件
- prompt 只是这个事件的文本投影

所以 Claude Code 的 prompt 设计从一开始就是：

- 先决定角色
- 再决定注入层次
- 最后才得到最终文案

## 3. cache 稳定性直接塑造了 prompt 结构

`SYSTEM_PROMPT_DYNAMIC_BOUNDARY` 明确把系统提示词切成：

- 可全局缓存的静态前缀
- 不可缓存的动态尾部

这意味着 Claude Code 不是先写完 prompt 再想办法提速，而是：

- 一开始就把 cache 命中率当成 prompt 设计约束

进一步看 `attachments.ts` 会发现，这种约束已经深入到细节：

- `relevant_memories` 预先缓存 header，避免“3 days ago -> 4 days ago”打爆前缀。
- `date_change` 用尾部 attachment 注入，而不重写用户上下文里的日期。
- agent listing、deferred tools、MCP instructions 都尽量走 delta，而不是每轮重写整段说明。

所以 Claude Code 的 prompt 结构，本质上是被 token 经济和 cache 语义共同雕出来的。

## 4. prompt 魔力来自“状态晚绑定”

Claude Code 很少把动态状态直接塞进静态 prompt。

它更常见的做法是：

1. 静态 prompt 保持稳定。
2. 动态状态通过 attachment / reminder / delta 晚绑定。
3. 真正需要时再把状态带进当前轮。

这样做有三个好处：

1. 稳定 cache 前缀。
2. 避免每轮都重写整个世界模型。
3. 让 prompt 只承载规则，状态通过运行时对象补齐。

这解释了为什么 Claude Code 的 prompt 看起来“像懂现场”：

- 因为现场真的被运行时状态对象持续喂进来了。

## 5. 多 Agent prompt 的本体是协作语法

`coordinatorMode.ts` 的关键价值不在于措辞，而在于它规定了多 Agent 协作的语法：

1. coordinator 负责综合，不负责假装知道 worker 结果。
2. worker prompt 必须自包含，不能依赖“基于你的发现继续做”这种模糊接力。
3. ownership、汇报格式、任务范围和完成条件都必须显式写入。
4. mailbox 不是附加聊天框，而是协作 runtime 的正式状态通道。

再看 `teammate_mailbox` attachment，会发现这套语法还有运行时配套：

- 非结构化消息进入 LLM 上下文
- 结构化协议消息保留给专门 handler
- leader 与 teammate 的视角被显式分离，防止 inbox 泄漏

这说明 Claude Code 的多 Agent prompt 不只是“几句指导话术”，而是：

- prompt 语法
- mailbox 协议
- 任务对象
- 权限与状态通道

四者一起工作。

## 6. 苏格拉底式追问

### 6.1 如果直接抄 system prompt，能复制这套魔力吗

不能。

因为被抄走的只是文本，而不是：

- 角色切换逻辑
- attachment 注入链
- cache 结构
- mailbox 与 task runtime

### 6.2 如果 prompt 已经很强，为什么还需要 attachment

因为动态状态太多，直接塞进静态 prompt 只会导致：

- cache 抖动
- token 膨胀
- 文案和现场失联

### 6.3 如果多 Agent prompt 已经写得很细，为什么还需要 task / mailbox

因为没有 task 对象与 mailbox，所谓协作 prompt 最终只会退化成：

- 多个会说话的副本

而不是：

- 多个受约束的协作单元

## 7. 一句话总结

Claude Code 的 prompt 魔力不是“神秘咒语”，而是“角色合同 + 缓存结构 + 状态晚绑定 + 协作语法”四层叠加出来的 runtime 效果。
