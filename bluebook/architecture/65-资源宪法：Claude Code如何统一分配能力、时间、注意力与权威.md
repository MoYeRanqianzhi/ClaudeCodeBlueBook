# 资源宪法：Claude Code如何统一分配能力、时间、注意力与权威

这一章回答五个问题：

1. 为什么 Claude Code 的安全设计和省 token 设计还能继续上升一层，被理解成资源宪法。
2. 为什么能力、时间、注意力与权威在它这里是四类需要统一分配的稀缺资源。
3. 为什么 permission、managed settings、budget continuation、context suggestions 该放在同一张图里。
4. 为什么这不是外围策略，而是运行时主权问题。
5. 这条线对 agent runtime 设计者意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/permissions/permissions.ts:1160-1265`
- `claude-code-source-code/src/utils/settings/settings.ts:798-840`
- `claude-code-source-code/src/utils/hooks/hooksConfigSnapshot.ts:1-120`
- `claude-code-source-code/src/query/tokenBudget.ts:1-84`
- `claude-code-source-code/src/utils/toolSchemaCache.ts:1-20`
- `claude-code-source-code/src/utils/analyzeContext.ts:1340-1385`
- `claude-code-source-code/src/utils/contextSuggestions.ts:30-110`
- `claude-code-source-code/src/utils/toolResultStorage.ts:367-430`

## 1. 先说结论

Claude Code 的 runtime 真正在分配四类稀缺资源：

1. 能力：
   - 模型现在能调用什么。
2. 时间：
   - 这一轮还能继续多久、继续几次。
3. 注意力：
   - 模型和用户现在该把上下文容量花在哪些对象上。
4. 权威：
   - 谁说了算，谁有资格改写运行时边界。

这四类资源并不是独立管理的。

Claude Code 更像在维护一部：

- 运行时资源宪法

也就是说，它先回答：

- 谁可以分配资源
- 资源怎么被暴露
- 资源何时终止扩张

然后才允许模型工作。

## 2. 能力资源：模型不是默认拥有全部行动权

`permissions.ts` 最清楚地说明了这一点。

它的顺序不是：

- 先默认能做
- 出事再兜底

而是：

- 先 deny / ask / tool-specific checks
- 再看 mode 和 bypass

这说明能力资源的分配权不在模型，而在 runtime。

模型拿到的不是“完整行动宇宙”，而是：

- 被 policy、tool checks、safety checks 过滤后的可行动作空间

## 3. 权威资源：谁有资格定义边界，本身就是稀缺资源

`settings.ts` 与 `hooksConfigSnapshot.ts` 说明 Claude Code 不只在合并配置。

它更在做：

- authority assignment

比如：

- `policySettings` 高于 user/project/local
- managed-only hooks 会直接排除低信任来源
- snapshot 为的是在一个稳定时间点冻结当前权威真相

这说明“谁说了算”不是抽象管理问题，而是运行时资源的一部分。

如果 authority 不被先分配清楚，后面的：

- capability
- attention
- time

也都会跟着漂。

## 4. 时间资源：继续执行不是默认权利，而是受宪法约束的续行

`query/tokenBudget.ts` 说明 Claude Code 不是简单做“预算到了就停”。

它会判断：

- 当前预算百分比
- continuation 次数
- 增量收益是否递减

这意味着时间资源被视为：

- 可以申请继续
- 但不能无限续写

也就是说，“继续思考多久”并不是模型天然拥有的权利，而是 runtime 按预算结构授予的临时资源。

## 5. 注意力资源：上下文容量不是给谁都一样多

`analyzeContext.ts` 与 `contextSuggestions.ts` 说明 Claude Code 对注意力资源的治理非常明确。

它持续关心：

- 哪类对象在吃掉上下文
- 哪类 tool results 太重
- memory 是否膨胀
- autocompact 是否该介入

这说明它眼中的 token 并不是纯成本数字。

token 更像：

- 模型注意力预算的度量单位

所以它会把“注意力花在哪”做成正式观测面，再导出下一步建议。

## 6. 为什么 tool schema 和 output externalization 也属于资源宪法

`toolSchemaCache.ts` 说明 schema 字节一旦抖动，整个高位前缀都会被击穿。

这其实不是单纯缓存问题，而是：

- 能力资源与注意力资源在同一个位置争夺高位前缀

`toolResultStorage.ts` 则说明大块输出不该长期占有公共工作集。

也就是说，Claude Code 对资源的态度很统一：

1. 能力不能无限膨胀。
2. 高位前缀不能被随意改写。
3. 大体积结果不能长期霸占注意力。
4. 时间预算不能被无限续借。

这就是“资源宪法”的真正含义。

## 7. 为什么这比“安全系统 + 成本系统”更接近本体

如果把它拆成两套系统：

- 安全
- 成本

你很容易漏掉两个关键事实：

1. 更大的能力面几乎总会带来更大的 token、注意力和稳定性代价。
2. 更漂移的 authority 几乎总会连带把能力面和 prompt 前缀一起改碎。

所以 Claude Code 更成熟的地方在于：

- 它不让模型管理资源
- 它也不让单个 feature 自己定义资源规则

它要求 runtime 先给出统一宪法。

## 8. 一句话总结

Claude Code 的安全、治理和省 token 设计之所以能继续统一，是因为它把能力、时间、注意力与权威都当成稀缺资源，并由 runtime 先行分配，而不是把资源主权外包给模型或局部 feature。
