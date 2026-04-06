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

“可解释稳定性”现在不再是 Prompt 的平行哲学，而是六个 nouns 里的最后一级：

- `Explainability`

更准确地说，Claude Code 的 prompt 魔力不是：

- 它有一段特别厉害的 system prompt

而是：

- 在 `Authority -> Boundary -> Transcript -> Lineage -> Continuation` 已经成立之后，它还能继续解释自己为什么稳定，为什么突然不稳定

所以真正难抄走的，不是某句提示词，而是系统能否回答：

1. 这次为什么还能复用同一 prefix。
2. 这次为什么 cache 断了。
3. 断在 system、tools、betas、effort、extra body 还是 server-side。
4. 当前预算为什么长成现在这样。

## 2. 为什么 Explainability 不是可有可无的附属层

如果 prompt 魔力主要来自措辞，那么最重要的问题应该是：

- 这段话写得够不够强

Claude Code 的源码却不断把真正问题改写成：

- 当前 authority 有没有变
- tool ABI 有没有打碎 boundary
- transcript 有没有混进高波动对象
- lineage / continuation 有没有继续沿同一 prefix
- 当前 break 是哪一类 break

这说明作者真正关心的不是“说得像不像”，而是：

- runtime 条件能不能让同一套合同持续成立，并在失败时继续被点名

从第一性原理看，这比文案本身更本质，因为 agent 系统最稀缺的资源之一不是“会不会说”，而是：

- 能不能长期一致地继续说

## 3. 为什么 cache break naming 是 Explainability 的硬证据

很多人会把解释层看成附属品，仿佛先有一个强 prompt，再额外加点可观测性。

Claude Code 更接近另一种逻辑：

- 正因为 prompt 可以被解释，所以它才配被当成长期资产

如果一个系统只能在成功时有效，失败时却不知道为什么失败，那么这套 prompt 很难被真正扩展、维护、复用。

反过来，如果系统能解释：

- 是 `systemPromptChanged`
- 是 `toolSchemasChanged`
- 是 `betasChanged`
- 是 `cachedMCChanged`
- 是 effort / extra body 变化
- 是 TTL 到了
- 还是 server-side eviction

那么 prompt 就从：

- 神秘配方

升级成：

- 可维护的工程资产

## 4. 为什么 shared prefix、预算观测、tool ABI 都在为 Explainability 服务

这三件事表面不同，底层其实在回答同一件事：

- 这条 same-world compiler 现在到底稳定在哪里，断裂又发生在哪里

### 4.1 shared prefix 说明可解释对象不是单轮文本

`CacheSafeParams` 与 `/btw`、memory、summary 等路径说明：

- 解释对象首先是 shared prefix，而不是“这一轮最后发出去的 prompt”

### 4.2 预算观测说明 prompt 不是黑箱

`get_context_usage` 与 `ContextVisualization` 说明：

- prompt 的结构、开销、膨胀点必须被看到，才能解释 decision gain 还在不在

### 4.3 tool ABI 稳定性说明解释对象也包含行动空间

tool pool 顺序与过滤逻辑稳定，意味着：

- explainability 不只解释系统文本，还解释模型当前到底看见了什么行动世界

所以这一页真正想收住的是：

- Explainability 不是第二前门，而是前五层成立后的命名权

更硬一点说：

- `Explainability is diagnostic, not adjudicative.`

它只有命名权，没有改判权；它能解释 `winner / boundary / qualification` 断在何处，但不能把已经失真的世界重新说成合法。

## 5. 这页真正要防的失真

这一页最容易重新长回两种错法：

1. 把“可解释稳定性”写成第二套 Prompt Constitution。
2. 只谈可观测性，不把它绑定到 `Authority -> Boundary -> Transcript -> Lineage -> Continuation`。

对应的 reject trio 仍然是：

- `authority_blur`
- `transcript_conflation`
- `continuation_story_only`

因为只要前五层失真，Explainability 也会立刻退回“解释一个已经混掉的东西”。

## 6. 一句话总结

Claude Code 的 prompt 魔力，更接近 `Authority -> Boundary -> Transcript -> Lineage -> Continuation -> Explainability` 里最后一级真正成立，而不是多了一段难以言传的神秘措辞。
