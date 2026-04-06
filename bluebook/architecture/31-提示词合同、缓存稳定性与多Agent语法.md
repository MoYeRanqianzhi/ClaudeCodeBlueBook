# 提示词合同、缓存稳定性与多Agent语法

这一章回答五个问题：

1. Claude Code 的 prompt 为什么看起来“有魔力”。
2. 这种魔力为什么不是文案技巧，而是合同装配。
3. cache 稳定性为什么会反过来塑造 prompt 结构。
4. 多 Agent prompt 为什么本质上是 `Transcript / Lineage / Continuation`，而不是几句命令模板。
5. 从源码看，Claude Code 真正不可复制的 prompt 部分是什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/systemPrompt.ts:29-123`
- `claude-code-source-code/src/tools.ts:253-366`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:343-350`
- `claude-code-source-code/src/constants/prompts.ts:508-549`
- `claude-code-source-code/src/context.ts:22-34`
- `claude-code-source-code/src/context.ts:113-149`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:28-158`
- `claude-code-source-code/src/utils/attachments.ts:500-522`
- `claude-code-source-code/src/utils/attachments.ts:1403-1489`
- `claude-code-source-code/src/utils/attachments.ts:3521-3685`
- `claude-code-source-code/src/coordinator/coordinatorMode.ts:120-300`

## 1. 先说结论

Claude Code 的 prompt 魔力，最稳的前门不再是“四层叠加”，而是：

- `Authority -> Boundary -> Transcript -> Lineage -> Continuation -> Explainability`

如果把旧的四层叠加回译回这条链，大致就是：

1. 角色合同
   - `Authority`
2. 缓存结构
   - `Boundary`
3. 状态反馈
   - `Transcript -> Lineage`
4. `Transcript -> Lineage -> Continuation`
   - `Transcript -> Lineage -> Continuation`
5. cache break naming
   - `Explainability`

也就是说，Claude Code 的 prompt 强，不是因为某几句话更会写，而是因为这些句子被嵌进了同一世界编译链。

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

### 2.1 装配顺序比“提示词写得漂亮”更重要

很多系统把 prompt 设计理解成：

- 先写一段 system prompt
- 再往里面慢慢缝补规则

Claude Code 不是这样。它先决定：

1. 当前是不是 coordinator
2. 当前是不是 main-thread agent
3. custom prompt 和 append prompt 各自处在什么层
4. proactive 模式下 agent prompt 是替换默认 prompt，还是叠加在默认 prompt 上

这意味着真正的设计单位不是某一段词，而是：

- 合同装配图

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

### 3.1 工具 ABI 也被做成 cache-stable contract

Claude Code 没有把“工具池”当作系统提示词之外的独立小事。

`filterToolsByDenyRules(...)` 会在调用前就剥离 blanket deny 工具，`assembleToolPool(...)` 则把 built-in 工具和 MCP 工具分区排序，保持 built-in 前缀连续，避免新连接的 MCP 工具把 prompt cache 前缀整体打碎。

所以 prompt 稳定性至少有两部分：

1. system prompt 和 attachments 的文本稳定性
2. 当前可见工具 ABI 的排序稳定性

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

`promptCacheBreakDetection.ts` 进一步说明作者没有把这件事停留在理念层。

它显式跟踪：

- system hash
- tools hash
- cache control hash
- per-tool schema hash
- global cache strategy
- beta headers

换句话说，Claude Code 甚至把“prompt 魔力失效”的条件也写成了可检测对象。

## 5. 多 Agent prompt 的本体是 Transcript / Lineage / Continuation

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

### 5.1 mailbox 不是聊天框，而是受过滤的协作入口

`getTeammateMailboxAttachments(...)` 最有价值的地方不是“能收消息”，而是它显式处理了三类协作污染：

1. 结构化协议消息不能当普通 LLM 文本投喂
2. leader inbox 不能泄漏到 teammate 视角
3. 文件邮箱和 AppState inbox 之间的重复消息要做去重

这说明 Claude Code 的多 Agent 语法并不是“谁都给彼此发点话”，而是：

- 协作文本和协作协议必须分流
- 同一条消息在不同视角下必须维持一致真相

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

### 6.4 如果 prompt 已经这么强，为什么还要坚持过滤协议消息

因为 prompt 再强，也不该承担协议解析器的职责。

如果权限响应、shutdown 协议、结构化 mailbox 消息都混进普通上下文：

- 模型看到的“当前现场”就不再可靠
- `Transcript / Lineage / Continuation` 语法和系统语法会相互污染
- 搜索、复制、前台来源判断也会一起失真

## 7. 一句话总结

Claude Code 的 prompt 魔力不是“神秘咒语”，而是把“角色合同、缓存结构、状态晚绑定与多 Agent 协作”都正式压回 `Authority -> Boundary -> Transcript -> Lineage -> Continuation -> Explainability`。
