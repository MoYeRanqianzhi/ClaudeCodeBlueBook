# 安全、治理、Token与Prompt稳定性本质上是同一收口问题

这一章回答五个问题：

1. 为什么 Claude Code 真正在压制的不是单一指标，而是模型可达世界的无序扩张。
2. 为什么安全、治理、省 token 与 prompt 稳定性应该被放进同一张解释图。
3. 为什么 prompt 稳定性不是性能技巧，而是运行时治理的一部分。
4. 为什么 Claude Code 反复偏爱“先裁剪再暴露”，而不偏爱“先全暴露再事后拦截”。
5. 这套第一性原理对 agent runtime 设计者有什么启发。

## 0. 代表性源码锚点

- `claude-code-source-code/src/tools.ts:345-364`
- `claude-code-source-code/src/utils/toolPool.ts:63-74`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1167-1259`
- `claude-code-source-code/src/utils/settings/settings.ts:322-343`
- `claude-code-source-code/src/utils/settings/settings.ts:675-689`
- `claude-code-source-code/src/constants/systemPromptSections.ts:17-50`
- `claude-code-source-code/src/utils/toolResultStorage.ts:272-320`
- `claude-code-source-code/src/utils/toolResultStorage.ts:740-772`
- `claude-code-source-code/src/query.ts:369-383`
- `claude-code-source-code/src/query/tokenBudget.ts:1-75`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-315`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:437-470`
- `claude-code-source-code/src/utils/forkedAgent.ts:47-79`
- `claude-code-source-code/src/query/stopHooks.ts:92-99`
- `claude-code-source-code/src/commands/btw/btw.tsx:183-210`
- `claude-code-source-code/src/utils/analyzeContext.ts:1353-1363`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:175-215`

## 1. 先说结论

Claude Code 真正在预算的，不是 token 本身。

它真正持续压制的是：

- 模型可达世界的无序扩张

这个“世界”至少有四个维度：

1. 动作空间：模型现在能做什么。
2. 权威空间：谁有资格改写系统边界。
3. 上下文空间：什么内容能长期常驻工作集。
4. 时间空间：跨轮前缀、工具顺序与状态装配会不会持续漂移。

Claude Code 之所以把安全、治理、token 与 prompt 稳定性做成同一系统，是因为它们共享同一个损失函数：

- 一旦动作更大、输入来源更多、常驻上下文更肥、跨轮前缀更飘，系统就会同时变得更危险、更贵、更不稳定、更难恢复

所以更准确的说法不是：

- 安全、治理、token、prompt 稳定性彼此权衡

而是：

- 它们是同一个反扩张系统在四个平面上的投影

## 2. 为什么 Claude Code 不爱“先全暴露，再事后拦截”

源码里反复出现同一种偏好：

- 先裁剪模型可见世界
- 再要求模型在这个世界里做对事

典型例子有四类。

### 2.1 工具先过滤再暴露

`tools.ts` 与 `toolPool.ts` 会先：

- 过滤 deny 规则
- 把 built-ins 保持为稳定前缀
- 再把工具池交给模型

这说明 Claude Code 不接受：

- 先把所有工具都给模型
- 出事后再靠解释或拦截补救

### 2.2 权威先收口再生效

`settings.ts` 中 `policySettings` 的 first-source-wins 说明：

- 谁说了算，必须先被稳定下来

它反对的是：

- 多个来源并发改写边界
- 最后再靠 merge 结果解释谁赢了

### 2.3 高波动 section 先剥离再进入 prompt

`systemPromptSections.ts` 把 section 显式分成：

- memoized
- dangerous uncached

这说明 Claude Code 不接受：

- 把高波动信息和稳定合同写在同一层前缀里

### 2.4 大块输出先外置再继续推理

`toolResultStorage.ts` 与 `query.ts` 说明：

- 大块 `tool_result` 先落盘替换
- 然后才进入 `microcompact` / `autocompact`

也就是说 Claude Code 不接受：

- 先把肥结果塞进工作集
- 之后再假装靠压缩器补救

这四件事表面不同，底层其实是同一个动作：

- 先把无序自由度裁掉，再让模型工作

## 3. 四个平面为什么本质同构

### 3.1 安全在管动作空间

`permissions.ts` 的顺序很能说明问题：

- 先 deny
- 再 ask
- 再 tool-specific checks
- 再 safety check

而不是先默认允许再补一层 UX。

### 3.2 治理在管权威空间

`policySettings`、managed-only allowlist、trusted setting sources 共同回答的是：

- 哪些输入有资格扩大运行时边界

### 3.3 token 机制在管工作集空间

`toolResultStorage.ts`、`query.ts`、`tokenBudget.ts` 分别在不同阶段约束：

- 单对象大小
- 当前消息工作集
- 本轮是否继续

### 3.4 prompt 稳定性在管时间空间

`toolPool.ts`、`systemPromptSections.ts`、`promptCacheBreakDetection.ts`、`forkedAgent.ts` 共同维护的是：

- 跨轮前缀能否稳定复用
- 失稳能否被解释
- 旁路循环能否共享已有前缀资产

所以 prompt 稳定性不是“更快一点”的附属优化，而是：

- 让同一个运行时合同能跨轮持续成立

## 4. 为什么 prompt 稳定性其实属于治理

很多人把治理理解成后台设置，把 prompt 稳定性理解成性能技巧。

Claude Code 的源码恰好反驳了这种拆法。

因为真正的问题是：

- 当前轮到底什么算运行时真相

如果：

- policy source 会漂移
- 工具顺序会乱
- section 会无规则抖动
- fork 不能共享主线程前缀

那“谁说了算”与“模型看见什么”就会一起失稳。

所以 Claude Code 反复保存：

- `CacheSafeParams`
- stable tool prefix
- memoized system sections
- cache break reason

并把 `systemPromptSections`、`messageBreakdown` 等继续外化给宿主。

这说明 prompt 稳定性在它这里属于：

- runtime governance

而不只是：

- request optimization

## 5. Claude Code 共享的不只是原则，也共享工程手法

这四个平面之所以能被写成同一系统，还因为它们共享同一批工程方法。

### 5.1 typed decision

权限、控制、上下文使用、cache break 都被写成显式类型或显式状态，而不是 UI 副产物。

### 5.2 first source wins

当问题是“谁有资格定义边界”时，Claude Code 选择先定 authority，而不是把所有输入平均混合。

### 5.3 frozen decisions

`tool_result` 一旦决定替换或不替换，其 fate 就被冻结，避免后续反悔打碎 cache。

### 5.4 stable prefix

工具前缀、section cache、fork cache-safe params 都在维护同一个目标：

- 让稳定前缀成为可复用资产

### 5.5 explicit observability

`promptCacheBreakDetection`、`get_context_usage` 说明 Claude Code 不满足于系统自己稳定，还要求：

- 宿主和人类都看得见系统为什么稳定或为什么失稳

所以它并不是四支团队各做一套规则，而是一套收口方法投影到不同对象上。

## 6. 苏格拉底式追问

### 6.1 Claude Code 最怕的，真的是某一步回答不够聪明吗

不是。
它更怕模型每一轮都面对更大的动作空间、输入来源和上下文工作集。

### 6.2 如果工具池不先裁剪，增加的只是风险吗

也不是。
还会同步增加 schema token、cache 抖动和行动噪音。

### 6.3 如果治理来源并列改写权限边界，系统还能稳定回答“谁说了算”吗

很难。
这会直接把治理问题变成漂移问题。

### 6.4 如果高波动信息和稳定合同写在同一前缀里，得到的是更强上下文吗

未必。
更可能得到更高的 cache miss 和更差的复用性。

### 6.5 如果工具结果的替换决策可以事后反悔，resume、fork、summary 还能共享前缀资产吗

不能。
因为 byte-level 稳定性已经被破坏了。

### 6.6 如果 compact 只在爆窗后才做，它是在治理工作集，还是在收拾已经扩散的熵

更像后者。

### 6.7 如果危险策略变化也 fail-open，一次错放的代价会不会远高于一次中断

通常会。
所以 Claude Code 才采用选择性 fail-open / fail-closed。

### 6.8 如果宿主看不到 `systemPromptSections`、`messageBreakdown`、cache break 原因，它怎么区分“预算问题”和“治理变化”

它分不清。
最终只会把一切都理解成“系统卡住了”。

### 6.9 如果这些状态都不可解释，用户的重试会降低问题吗

不一定。
反而可能继续放大动作熵、上下文熵与支持成本。

### 6.10 那 Claude Code 真正在预算的，还是 token 吗

更准确地说，它在预算：

- 无序自由度

## 7. 对 Agent 平台设计者的启发

如果想学 Claude Code，最值得抄的不是某个 prompt 句子，而是这四条纪律：

1. 先裁剪模型可见世界，再要求模型正确。
2. 先定义 authority，再定义 merge。
3. 让稳定前缀成为资产，而不是每轮重建的偶然结果。
4. 把预算、边界、失稳原因外化给宿主和人类，而不是留在内部黑箱。

## 8. 一句话总结

Claude Code 真正强的地方，不是同时优化了安全、治理、token 与 prompt 稳定性，而是把它们都当成“限制无序扩张”的同一个控制系统，只是分别作用于动作空间、权威空间、上下文空间与时间空间。
