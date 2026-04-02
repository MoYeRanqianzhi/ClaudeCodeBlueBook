# 如何把Prompt写成上下文准入编译器：section law、stable prefix、协议真相与合法遗忘

这一章不再解释 Prompt 为什么重要，而是把 Claude Code 式 Prompt 压成一张 builder-facing 的上下文编译卡。

它主要回答五个问题：

1. 为什么真正强的 Prompt 不是文案，而是“世界怎样进入模型”的编译器。
2. 怎样把 section law、stable prefix、protocol transcript 与 lawful forgetting 写成同一条构建顺序。
3. 为什么 side question、suggestion、summary、resume 不能各自重建一个“差不多的世界”。
4. 怎样用苏格拉底式追问避免把 Prompt 重新退回字符串工程。
5. 怎样把 Prompt 魔力迁移到自己的 Agent Runtime，而不误抄表面措辞。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/prompts.ts:491-557`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-104`
- `claude-code-source-code/src/query/stopHooks.ts:84-120`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts:184-225`
- `claude-code-source-code/src/services/AgentSummary/agentSummary.ts:81-119`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-520`

这些锚点共同说明：

- Claude Code 的 Prompt 不是“把更多文本喂给模型”，而是先把上下文准入、共享前缀、协议真相与合法遗忘压成正式语法，再让模型在这套语法里行动。

## 1. 第一性原理

更成熟的 Prompt 设计，不是：

- 先写一段更会说话的 system prompt

而是：

1. 先决定谁有资格发言。
2. 先决定什么有资格进入稳定前缀。
3. 先决定 UI 历史如何被编译成协议真相。
4. 先决定删掉什么以后系统仍能合法继续。
5. 最后才决定具体措辞。

所以 Prompt 的真正设计单位不是：

- 文案段落

而是：

- 上下文准入编译器

## 2. 第一步：先固定 section law 与主权链

Claude Code 先固定的不是提示词内容，而是主权顺序：

1. override
2. coordinator
3. agent
4. custom
5. default
6. append

同时它还把默认 Prompt 拆成 section registry：

1. stable section
2. dynamic section
3. dangerous uncached section
4. late delta / attachment section

构建动作：

1. 先列出你的 Prompt 中谁能覆盖谁。
2. 先列出哪些 section 允许稳定缓存，哪些必须动态计算。
3. 先把高波动信息从 stable prefix 里驱逐出去。

不要做的事：

1. 不要让多个入口同时改写主语。
2. 不要把“会影响 cache 与继续条件的内容”混在 late patch 里。
3. 不要让 side prompt、resume prompt、summary prompt 各自拥有一份不同的世界定义。

## 3. 第二步：只允许一个 stable prefix 生产者

Claude Code 真正复用的不是聊天历史，而是主线程保存下来的 cache-safe 前缀对象。

这意味着：

1. 主线程负责生产共享前缀资产。
2. side question / suggestion / summary / fork 优先复用这份资产。
3. 如果拿不到合法前缀，应 suppress，而不是“差不多重建”。

构建动作：

1. 先定义你的 Runtime 中谁有资格生产 compiled request truth。
2. 先定义哪些旁路循环必须复用这份 truth。
3. 先定义拿不到前缀时的 suppress 规则。

不要做的事：

1. 不要让 suggestion 自己拼一份世界。
2. 不要让 summary 为了方便改掉 cache key。
3. 不要把共享前缀理解成“复用上一轮摘要”。

## 4. 第三步：把 UI transcript 编译成 protocol transcript

Claude Code 保护的从来不是前台原样历史，而是模型真正消费的协议真相。

更稳的顺序是：

1. 先定义哪些消息允许进入协议层。
2. 先定义 tool_use / tool_result / thinking / attachment 的配对和补边规则。
3. 先定义哪些 UI 消息、虚拟消息、进度消息必须被剥离。
4. 最后才考虑显示层怎样保留可读性。

构建动作：

1. 先写 transcript normalization 规则。
2. 先写 protocol truth law，而不是先写聊天记录存储格式。
3. 先定义哪些消息在 compact / resume 后必须被补回。

不要做的事：

1. 不要把 UI transcript 直接送给模型。
2. 不要把显示层消息误当执行层消息。
3. 不要把 compact 做成“删点文字留个摘要”。

## 5. 第四步：把合法遗忘写成正式 ABI

Prompt 的高级感不只来自“保留了什么”，也来自“删掉什么以后仍能继续”。

Claude Code 的 lawful forgetting 真正保护的是：

1. 当前对象
2. 当前继续条件
3. 当前协议不变量
4. 当前恢复资产
5. 当前 handoff 最小真相

构建动作：

1. 先定义 compact 之后哪些对象必须仍然存在。
2. 先定义 resume / handoff 的合法输入。
3. 先定义哪些删除会直接破坏继续条件。

不要做的事：

1. 不要把 lawful forgetting 写成摘要风格优化。
2. 不要允许 compact 之后 tool 配对、pending action、rollback boundary 消失。
3. 不要把恢复写成“再读一遍完整聊天记录”。

## 6. 第五步：把 stable bytes 与失稳解释写成制度资产

Claude Code 并不满足于“缓存能命中”，它还追踪：

1. 哪些 section 变化了
2. 哪些 tool schema 变化了
3. 哪些 cache-control 边界变化了
4. 为什么 cache break

所以更成熟的 Prompt 系统还要多做两件事：

1. 把 stable bytes 当正式资产管理。
2. 把失稳原因做成可解释对象，而不是黑箱成本。

构建动作：

1. 先定义 stable bytes inventory。
2. 先定义 cache break diff。
3. 先定义哪些变化允许，哪些变化要触发治理审读。

## 7. 六步最小构建顺序

如果要把上面的原则压成一张 Prompt builder 卡，顺序可以固定成：

1. `section law`
   - 谁能发言，谁覆盖谁
2. `stable prefix producer`
   - 谁生产 compiled request truth
3. `protocol transcript compiler`
   - 哪些消息允许进入模型世界
4. `lawful forgetting ABI`
   - 删掉什么以后仍能合法继续
5. `stable bytes ledger`
   - 哪些字节是制度资产
6. `再写措辞`
   - 最后才写具体 Prompt 内容

## 8. 苏格拉底式检查清单

在你准备继续优化 Prompt 前，先问自己：

1. 我优化的是措辞，还是世界到模型的准入顺序。
2. 当前 Prompt 有没有唯一的 stable prefix 生产者。
3. side loop 消费的是共享 truth，还是重建出来的半真相。
4. 我的 compact / resume 是否真的保住了继续条件。
5. 如果 cache break 了，我能否解释是哪些治理字节变了。

## 9. 一句话总结

真正强的 Prompt，不是更会说服模型，而是先把 section law、stable prefix、protocol transcript 与 lawful forgetting 编译成同一套上下文准入系统。

