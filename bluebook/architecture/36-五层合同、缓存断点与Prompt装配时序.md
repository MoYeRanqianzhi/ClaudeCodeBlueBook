# 五层合同、缓存断点与Prompt装配时序

这一章回答五个问题：

1. Claude Code 的 prompt 为什么更像一组合同，而不是一段文案。
2. system、developer、user、tool、channel 五层是怎样被装配到同一轮请求里的。
3. 为什么 cache 稳定性会直接约束 prompt 的写法。
4. 为什么动态状态更适合走 attachment / delta，而不是重写整段 prompt。
5. 这套结构为什么会让 Claude Code 的 prompt 看起来“有魔力”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/systemPrompt.ts:28-123`
- `claude-code-source-code/src/constants/prompts.ts:105-115`
- `claude-code-source-code/src/constants/prompts.ts:343-350`
- `claude-code-source-code/src/constants/prompts.ts:508-549`
- `claude-code-source-code/src/context.ts:22-34`
- `claude-code-source-code/src/context.ts:113-149`
- `claude-code-source-code/src/utils/attachments.ts:1455-1475`
- `claude-code-source-code/src/utils/attachments.ts:1490-1505`
- `claude-code-source-code/src/utils/attachments.ts:3520-3695`
- `claude-code-source-code/src/coordinator/coordinatorMode.ts:120-257`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-75`

## 1. 先说结论

Claude Code 的 prompt 魔力，不是来自某一段 system prompt，而是来自五层合同被稳定装配：

1. system 合同：默认身份、工具原则、语气与安全底线。
2. developer 合同：自定义 `systemPrompt`、`appendSystemPrompt`、agent prompt、coordinator prompt。
3. user 合同：git 状态、CLAUDE.md、language、session-specific guidance。
4. tool 合同：工具池、tool delta、agent listing、MCP instructions。
5. channel 合同：`task-notification`、teammate mailbox、宿主 initialize 请求。

这五层的关键不在“文字更多”，而在：

- 它们拥有稳定顺序
- 它们共享 cache 边界
- 它们支持状态晚绑定
- 它们知道什么内容应进入模型，什么内容只应进入前台或宿主

## 2. 第一层与第二层：system / developer 合同先决定身份，再决定文案

`buildEffectiveSystemPrompt(...)` 先处理角色优先级，再返回最终系统提示词数组。

顺序是：

1. `overrideSystemPrompt`
2. coordinator prompt
3. agent prompt
4. custom system prompt
5. default system prompt
6. `appendSystemPrompt`

这说明 Claude Code 的真正逻辑不是“把很多字符串拼在一起”，而是：

- 先决定当前是谁
- 再决定哪些合同覆盖默认身份
- 最后才得到当前轮 prompt 文本

这也是它和很多 prompt 工程实践最不一样的地方：

- 角色切换是 runtime 事件
- prompt 只是这个 runtime 事件的文本投影

## 3. 第三层：cache 断点迫使 prompt 结构分成静态前缀与动态尾部

`SYSTEM_PROMPT_DYNAMIC_BOUNDARY` 把系统提示词切成两半：

- 断点之前：跨会话更稳定、可全局缓存
- 断点之后：用户、会话、能力集合相关的动态内容

`getSessionSpecificGuidanceSection(...)` 的注释更直接暴露了作者的约束：

- 任何会造成 prefix hash 爆炸的 session bit，都不该放在静态前缀里

这意味着 Claude Code 的 prompt 不是先写出来再优化，而是一开始就服从：

- cache 稳定性
- prefix 可复用性
- 动态位最小化

再看 token budget 指导被无条件缓存、MCP instructions 被改成 delta attachment，就更能看清同一原则：

- 只要某个状态会频繁波动，它就不适合继续待在静态 prompt 主体里

## 4. 第四层：user / tool 状态通过 context 与 attachment 晚绑定

`context.ts` 负责把会话开始时相对稳定的用户现场做成缓存上下文：

- git 状态快照
- CLAUDE.md / memory files
- cache breaker

但真正更频繁变化的状态，作者并没有继续塞回静态 prompt，而是转向 attachment / delta：

- `deferred_tools_delta`
- `agent_listing_delta`
- `mcp_instructions_delta`

这背后的第一性原理很直接：

- 规则与身份应该稳定
- 现场与能力应该晚绑定

如果把两类信息混在一起，系统会同时损失：

- cache 命中率
- token 预算
- 当前状态与前台认知的一致性

## 5. 第五层：channel / multi-agent 合同决定协作消息怎样进入当前轮

`coordinatorMode.ts` 明确规定：

- worker 结果以 user-role 的 `<task-notification>` 进入 coordinator
- worker 不是对话伙伴，而是内部信号
- coordinator 只能基于结果综合，不能假装预知 worker 发现

`attachments.ts` 里的 `teammate_mailbox` 又进一步说明：

- 非结构化协作消息可以进 LLM 上下文
- 结构化协议消息必须保留给专用 handler
- leader 视角与 teammate 视角必须显式隔离

这意味着 Claude Code 的“channel”不只是 transport。

它真正定义的是：

- 哪类外部输入可以进当前轮
- 以什么结构进
- 以什么视角进
- 哪些消息绝不能退化成普通自然语言

## 6. 宿主 initialize 合同：developer 层并不只在 CLI 本地

`SDKControlInitializeRequestSchema` 暴露出宿主级 developer 合同：

- hooks
- `sdkMcpServers`
- `jsonSchema`
- `systemPrompt`
- `appendSystemPrompt`
- agents
- `promptSuggestions`
- `agentProgressSummaries`

这说明 Claude Code 的 developer 层不是一个抽象概念，而是正式控制面：

- 本地 CLI 可以注入
- SDK host 也可以注入

所以更准确的写法应该是：

- system 合同负责默认身份
- developer 合同负责宿主级覆写与增强
- user 合同负责任务与现场
- tool / channel 合同负责可行动能力与协作输入

## 7. 苏格拉底式追问

### 7.1 如果直接抄 system prompt，能复制这套魔力吗

不能。

因为被抄走的只是文本，而不是：

- 角色优先级
- cache 断点
- attachment 晚绑定
- channel 语义
- host initialize 合同

### 7.2 为什么动态状态不能继续写进主 prompt

因为一旦动态状态回流到静态前缀，系统会同时失去：

- cache 稳定性
- token 经济
- 变化来源的可解释性

### 7.3 为什么多 Agent 的 prompt 会特别强

因为它不只是 prompt。

它还是：

- 任务对象
- user-role task notification
- mailbox attachment
- channel 语义

四者共同组成的协作合同。

## 8. 一句话总结

Claude Code 的 prompt 魔力，本质上是五层合同在稳定顺序、稳定缓存和状态晚绑定下共同生效，而不是某段文案单独有魔力。
