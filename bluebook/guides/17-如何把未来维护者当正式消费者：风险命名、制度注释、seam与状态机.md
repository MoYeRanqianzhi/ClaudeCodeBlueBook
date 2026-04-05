# 如何把未来维护者当正式消费者：风险命名、制度注释、seam与状态机

这一章回答五个问题：

1. 为什么 agent runtime 的高级工程不该只服务今天的执行，也要服务未来维护者。
2. 怎样把风险命名、制度注释、leaf module、config / deps seam、snapshot 和状态机视为同一套治理制度。
3. 为什么“写给未来维护者看”不是附带好处，而是系统能力。
4. 怎样在代码里直接暴露哪些地方不能乱改。
5. 怎样用苏格拉底式追问避免把“结构更漂亮”误当“结构更可演化”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:27-38`
- `claude-code-source-code/src/utils/fingerprint.ts:40-63`
- `claude-code-source-code/src/utils/plugins/pluginPolicy.ts:1-20`
- `claude-code-source-code/src/query/config.ts:8-45`
- `claude-code-source-code/src/query/deps.ts:8-40`
- `claude-code-source-code/src/utils/queryContext.ts:1-87`
- `claude-code-source-code/src/utils/hooks/hooksConfigSnapshot.ts:90-132`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/state/onChangeAppState.ts:50-91`
- `claude-code-source-code/src/utils/task/framework.ts:208-248`

这些锚点共同说明：

- Claude Code 的源码边界不仅在服务机器执行，也在主动服务未来维护、未来重构和未来协作。

## 1. 先说结论

更成熟的 runtime 设计法，不是：

- 把目录切得更整齐

而是：

1. 让风险在命名阶段就被看见。
2. 让制度理由在注释阶段就被保存。
3. 让共享规则在依赖图上保持小而硬。
4. 让未来抽离点在今天就长出 seam。
5. 让状态和时间边界被正式写成 machine / snapshot 语义。

也就是说，未来维护者不该被当成偶然读者，而应被当成：

- 正式消费者

## 2. 第一步：用风险命名把“哪里不能乱改”写出来

`DANGEROUS_uncachedSystemPromptSection` 这种命名，和 `single choke point` 这类术语，本质上不是修辞，而是护栏。

它们在阅读阶段就告诉后来者：

- 这里一改，会破坏 cache
- 这里一改，会破坏同步权威面
- 这里是系统的收口点

实践上：

1. 风险高的边界不要起中性名字。
2. 名字要直接暴露“改它会破坏什么”。
3. 能在命名阶段暴露的风险，不要留到事故后再补文档。

## 3. 第二步：把制度记忆写进注释，而不是继续靠老作者口头传承

`fingerprint.ts` 直接写明某个算法不能随便改，需要和外部 API 协调；`onChangeAppState.ts` 又明确记录过去 mode sync 失真的历史问题；`hooksConfigSnapshot.ts` 还会解释 stale settings 是怎样出现的。

这类注释保存的不是“这里做了什么”，而是：

- 为什么这样做
- 哪些坑已经踩过
- 改错会牵连谁

实践上：

1. 对 cache、authority、cycle、external contract 这类边界，优先写制度理由。
2. 对曾经出现过系统性故障的地方，直接把事故史写进注释。
3. 好注释不是陪衬，而是避免制度失忆的存储层。

## 4. 第三步：让共享规则保持小而硬

`pluginPolicy.ts`、`normalization.ts`、`systemPromptType.ts` 这一类小模块的共同点是：

- 规则单一
- 依赖极薄
- 可被全仓安全引用

这说明真正成熟的小模块，不是“拆更多文件”，而是：

- 把高扇入共享规则压成小而硬的单一真相文件

实践上：

1. 对归一化、策略判断、branding 这类规则，优先做 leaf module。
2. 不要在这类文件里顺手塞业务逻辑。
3. 共享真相越小，未来维护越不容易漂移成多套半真相。

## 5. 第四步：今天就为未来重构切出 seam

`query/config.ts` 把 immutable config 单独抽出，`query/deps.ts` 把最关键的 I/O 依赖先单独抽出；它们都不是为了“今天立刻完美重构”，而是为了：

- 让明天的重构者知道下一步应该从哪里继续抽

实践上：

1. 先抽最稳定的 config。
2. 再抽最关键的 side-effect deps。
3. 不要求一步到位，但要让 seam 真实存在。
4. seam 的价值在于降低未来认知债，而不只是今天的整洁感。

## 6. 第五步：把时间边界和状态边界正式化

`hooksConfigSnapshot.ts` 会维护启动时快照和刷新时机；`QueryGuard.ts` 会把 query 生命周期写成状态机；`task/framework.ts` 又强调 against fresh state 合并，而不是写回 stale snapshot。

这说明成熟 runtime 里，状态管理不是：

- 多几个布尔值

而是：

- 明确谁是权威当前态
- 明确 stale finally / stale snapshot 该如何失效
- 明确跨 await 更新必须 against fresh state

实践上：

1. 会跨异步阶段漂移的状态，优先做显式状态机。
2. 会跨时间读取的配置，优先做 snapshot。
3. 所有跨 await 回写，都先问是不是在写 stale state。

## 7. 第六步：把单一真相当成维护协议，而不是 DRY 口号

Claude Code 在很多地方都在强调：

- single source
- choke point
- authoritative state

这说明它真正防的不是代码重复本身，而是：

- 不同维护者在不同入口各写一套“差不多”的规则

实践上：

1. 高风险规则必须只有一个真相入口。
2. 入口之外可以有投影，但不要有第二套判断逻辑。
3. 如果一个真相已经服务多个消费者，就要把“给不同消费者看不同投影”显式设计出来。

## 8. 苏格拉底式检查清单

在你准备继续抽模块、改命名或补注释前，先问自己：

1. 我现在是在改善结构美观，还是在暴露维护护栏。
2. 这个风险能不能在命名阶段就被看见。
3. 这个制度理由是不是必须写进注释，不能继续靠团队记忆。
4. 这里需不需要 leaf module 或单一真相入口。
5. 今天能不能先切出一个 seam，给明天的重构留路。
6. 这段状态是不是已经值得正式状态机或 snapshot 语义。

如果这些问题答不清，结构再漂亮也很难长期可演化。

## 9. 一句话总结

Claude Code 值得学的，不是把目录抄得更像，而是把风险、制度、seam、状态机和单一真相直接写进代码边界里，让未来维护者也能低成本正确接手。
