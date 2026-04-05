# 可解释稳定性比神秘措辞更接近Prompt魔力

这一章回答四个问题：

1. 为什么 Claude Code 的 prompt 魔力更接近“可解释稳定性系统”，而不是“神秘措辞模板”。
2. 为什么一个真正成熟的 prompt 系统，必须既能稳定工作，也能解释什么时候失稳。
3. 为什么 cache break 归因、预算观测、shared prefix 与 tool ABI 稳定性应该被看成同一哲学。
4. 从第一性原理看，什么才是最难被抄走的 prompt 能力。

## 0. 代表性源码锚点

- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:220-433`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:437-706`
- `claude-code-source-code/src/services/api/claude.ts:1457-1486`
- `claude-code-source-code/src/services/api/claude.ts:2380-2391`
- `claude-code-source-code/src/utils/toolPool.ts:55-71`
- `claude-code-source-code/src/query/stopHooks.ts:92-99`
- `claude-code-source-code/src/components/ContextVisualization.tsx:105-245`
- `claude-code-source-code/src/utils/contextSuggestions.ts:31-233`

## 1. 先说结论

Claude Code 的 prompt 魔力，如果继续往第一性原理收束，更准确的说法不是：

- 它有一段特别厉害的 system prompt

而是：

- 它把 prompt 做成了一套可解释稳定性系统

这套系统至少同时包含四件事：

1. 前缀尽量稳定
2. 预算尽量可观测
3. 失稳尽量可归因
4. 辅助循环尽量共享同一前缀资产

所以真正难抄走的，并不是一句话该怎么写，而是：

- 系统为什么知道自己什么时候稳定
- 什么时候不稳定
- 不稳定到底是哪里变了

## 2. 为什么“稳定”本身比“文案”更本质

如果 prompt 魔力主要来自措辞，那么最重要的问题应该是：

- 这段话写得够不够强

Claude Code 的源码却不断把真正问题改写成：

- 这段前缀能不能被共享
- 工具 ABI 会不会打碎 cache
- 哪些状态应该晚绑定
- 当前 break 是 system、tools、betas 还是 server-side

这说明作者真正关心的不是“说得像不像”，而是：

- runtime 条件能不能让同一套合同持续成立

从第一性原理看，这比文案本身更本质，因为 agent 系统最稀缺的资源之一不是“会不会说”，而是：

- 能不能长期一致地说

## 3. 为什么可解释性会反过来增强 prompt 能力

很多人会把解释层看成附属品，仿佛先有一个强 prompt，再额外加点可观测性。

Claude Code 更接近另一种逻辑：

- 正因为 prompt 可以被解释，所以它才更敢被当成长期资产

原因很简单。

如果一个系统只能在成功时有效，失败时却不知道为什么失败，那么这套 prompt 很难被真正扩展、维护、复用。

反过来，如果系统能解释：

- 是 system prompt 变了
- 是 tool schema 变了
- 是 betas 变了
- 是 effort / extra body 变了
- 是 TTL 到了
- 还是 server-side eviction

那么 prompt 就从：

- 神秘配方

升级成：

- 工程资产

## 4. 为什么这和 shared prefix、预算观测、tool ABI 是同一哲学

这三件事表面不同，底层却一致。

### 4.1 shared prefix 说明 prompt 是资产

`CacheSafeParams` 与 `/btw`、memory、summary 等路径说明：

- prompt 不该按单轮文本理解，而该按可复用资产理解

### 4.2 预算观测说明 prompt 不是黑箱

`get_context_usage` 与 `ContextVisualization` 说明：

- prompt 的结构、开销、膨胀点应该被看到

### 4.3 tool ABI 稳定性说明 prompt 也包含行动空间

tool pool 顺序与过滤逻辑稳定，意味着：

- prompt 稳定性不只是系统文本稳定
- 还是模型看到的行动空间稳定

### 4.4 cache break 归因说明 prompt 还是一个可诊断对象

`promptCacheBreakDetection` 把失稳的原因继续外化出来。

这四者合在一起，才真正构成 Claude Code 的 prompt 哲学：

- prompt 是资产
- prompt 可观测
- prompt 可诊断
- prompt 的本体包括前缀、工具、策略与请求面

## 5. 苏格拉底式追问

### 5.1 如果 prompt 魔力主要来自措辞，为什么系统要花这么多力气维护稳定性与归因

因为真正难的是复用和演化，不是写出一版漂亮文案。

### 5.2 如果一段 prompt 无法解释自己为什么失效，它还能被称为成熟系统吗

很难。
那更像一次幸运命中。

### 5.3 如果工具顺序变化、beta header 变化、extra body 变化都会改变效果，prompt 还只是“文本”吗

不是。
它已经是整条 request surface 的一部分。

### 5.4 为什么 Claude Code 的 prompt 感觉更“稳”

因为它努力让稳定性本身成为被设计、被观测、被解释的对象。

## 6. 一句话总结

Claude Code 的 prompt 魔力，更接近一套可解释稳定性系统，而不是一段难以言传的神秘措辞。
