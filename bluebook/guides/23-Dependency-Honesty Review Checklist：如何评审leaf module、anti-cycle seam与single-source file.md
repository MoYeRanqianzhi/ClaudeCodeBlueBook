# Dependency-Honesty Review Checklist：如何评审leaf module、anti-cycle seam与single-source file

这一章回答五个问题：

1. 如果你在评审一个 agent runtime，怎样判断它是在做诚实模块化，还是在做好看的抽象。
2. 怎样把 leaf module、anti-cycle seam、single-source file、风险命名与制度注释放进同一套评审框架。
3. 为什么适度不 DRY 可能是更强的评审结论，而不是坏味道。
4. 怎样识别“高扇入入口过胖”“共享真相漂移”“脏边无控制扩散”这三类结构风险。
5. 怎样把依赖图诚实性写成一张真正可执行的 review checklist。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/plugins/pluginPolicy.ts:1-20`
- `claude-code-source-code/src/utils/configConstants.ts:1-18`
- `claude-code-source-code/src/query/config.ts:1-45`
- `claude-code-source-code/src/query/deps.ts:1-40`
- `claude-code-source-code/src/utils/queryContext.ts:1-87`
- `claude-code-source-code/src/types/permissions.ts:1-63`
- `claude-code-source-code/src/utils/plugins/pluginDirectories.ts:1-79`
- `claude-code-source-code/src/state/teammateViewHelpers.ts:1-24`
- `claude-code-source-code/src/utils/cleanupRegistry.ts:1-21`
- `claude-code-source-code/src/utils/swarm/backends/registry.ts:81-114`
- `claude-code-source-code/src/constants/systemPromptSections.ts:27-38`
- `claude-code-source-code/src/utils/fingerprint.ts:40-63`

这些锚点共同说明：

- Claude Code 愿意通过极薄文件、显式 seam、风险命名和制度注释，主动让未来维护者看见哪些地方不能乱改。

## 1. 先说结论

依赖图诚实性的评审，可以压成六个问题：

1. 高扇入共享入口够不够薄。
2. 共享真相是否只有一个正式入口。
3. 不可避免的脏边是否被关进受控 seam。
4. 是否为了图健康接受了 purposeful duplication。
5. 风险是否已经在命名和注释阶段暴露。
6. 变化面与副作用面是否已经被 seam 化。

如果这六问答得都差，系统即使现在能跑，后面也很容易在演化里撒谎。

## 2. 依赖图诚实性评审模板

### 2.1 评审项一：高扇入入口是否足够薄

优先检查：

1. 有没有全仓高频依赖的入口。
2. 这些入口是否保持 dependency-free 或 near-leaf。
3. 它们是否顺手长进了不必要的业务逻辑。

Claude Code 的正例：

1. `pluginPolicy.ts`
2. `configConstants.ts`
3. `cleanupRegistry.ts`

这些文件的共同点不是“小”，而是：

- 被很多地方依赖，但不反向把一整条重依赖链带进来

评审结论模板：

- “这是共享真相入口，但已经胖到会污染模块图，应抽薄”
- “这是高扇入入口，当前厚度可接受，因为仍然没把外部依赖带回上层”

### 2.2 评审项二：共享真相是否只有一个正式入口

重点看：

1. 路径规则、模式枚举、策略判定、对象边界有没有 single source。
2. 下游是不是只消费这个入口，而不是各自写一版。
3. single source 是否还能保持轻量。

Claude Code 的正例：

1. `pluginDirectories.ts`
2. `types/permissions.ts`
3. `pluginPolicy.ts`

评审结论模板：

- “共享真相目前只有一个入口，且对外暴露面足够窄”
- “多个调用点存在二次实现，single source 已经漂移”

### 2.3 评审项三：不可避免的脏边是否被关进 seam

这里不是问“有没有脏边”，而是问：

1. 它是否被单独隔离。
2. 文件头是否写明为何存在。
3. 是否限制了谁能导入它。

`queryContext.ts` 就是这类 seam 的典型。

评审时最危险的错不是“承认脏边存在”，而是：

- 假装它不存在，结果让这条边到处扩散

评审结论模板：

- “这是合理 anti-cycle seam，边界清楚、调用者范围受限”
- “这是未命名脏边，目前靠隐性约定维持，应显式隔离”

### 2.4 评审项四：是否为了图健康接受了 purposeful duplication

看到局部重复时，不要立刻判坏味道。

先问：

1. 这段重复是不是在切断 runtime edge。
2. 抽象出去是否会制造 cycle 或加深扇入。
3. 重复的范围是否小于它所避免的全局风险。

`teammateViewHelpers.ts` 的内联常量与手写 type guard 就是标准正例。

评审结论模板：

- “这里不 DRY 是有意为之，换来了依赖图诚实”
- “这里的重复没有系统性收益，只是在逃避抽象”

### 2.5 评审项五：风险是否在命名和注释阶段暴露

要看：

1. 高风险 seam 是否有风险命名。
2. 注释是否写了“为什么不能随便改”。
3. 是否记录了必须与外部系统协调的前提。

Claude Code 的正例：

1. `DANGEROUS_uncachedSystemPromptSection`
2. `fingerprint.ts` 里的协调要求
3. registry / cleanup 一类文件里的 “avoid circular dependencies” 注释

评审结论模板：

- “风险已经在代码表面可见，未来维护者容易接手”
- “风险还靠团队记忆维持，说明治理边界没有编译进代码”

### 2.6 评审项六：变化面与副作用面是否已 seam 化

最后再看：

1. immutable config 是否和 runtime state 分离。
2. I/O deps 是否显式化。
3. 高扇入 registry 是否保持足够薄。

`query/config.ts`、`query/deps.ts`、`swarm/backends/registry.ts` 是这类评审的典型入口。

这里真正要判的是：

- 系统有没有为未来重构提前长出 seam

## 3. Review Checklist

可以直接拿下面这张单子做评审：

```text
[ ] 高扇入入口是否足够薄
[ ] 共享真相是否只有一个正式入口
[ ] 不可避免的脏边是否被单独隔离并写明原因
[ ] 是否接受了有收益的 purposeful duplication
[ ] 风险是否已经在命名和注释中暴露
[ ] immutable config 与 I/O deps 是否显式分离
[ ] registry 节点是否保持“只注册，不顺手长业务”
[ ] 未来维护者第一次读到这里，能否直接看见哪里不能乱改
```

## 4. 负面信号表

看到下面这些信号时，要提高警惕：

1. “公共工具文件”越来越胖，但没有任何约束说明。
2. 多个调用点各自维护一版路径、模式或策略判断。
3. 某条高位依赖边没有单独隔离，却被越来越多模块顺手 import。
4. 因为追求 DRY，把一个本应局部的 helper 抽成了全仓共享入口。
5. 风险高的边界起了中性名字，注释只写“这里做了什么”，不写“为什么不能乱改”。

## 5. 苏格拉底式检查清单

在你给出结构评审意见前，先问自己：

1. 我现在批评的是重复本身，还是重复背后的系统收益与代价。
2. 我是在鼓励更漂亮的抽象，还是在保护更诚实的依赖图。
3. 我是否已经确认这个 single source 真的被当作唯一真相。
4. 我是否把高风险 seam 当成普通 helper 看漏了。
5. 我的建议会不会让模块图更好看，却让未来维护更容易失真。

如果这些问题答不清，结构评审就很容易退回审美评论，而不是工程判断。

## 6. 一句话总结

依赖图诚实性的高级评审，不是鼓励“抽得更统一”，而是检查共享入口是否够薄、真相是否够单一、脏边是否被隔离、风险是否已暴露，从而让系统在增长时仍然不会偷偷撒谎。
