# 未来维护者消费者控制面：风险命名、制度注释、seam与状态机如何共同服务演化

这一章回答五个问题：

1. 为什么 Claude Code 的源码边界不仅服务机器执行，也在服务未来维护者。
2. 为什么风险命名、制度注释、leaf module、config / deps seam、snapshot、state machine 应一起理解。
3. 为什么这套源码先进性不在静态分层漂亮，而在演化控制面是否可读。
4. 为什么“未来维护者也是正式消费者”会改变代码写法。
5. 这对 agent runtime 设计者意味着什么。

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

## 1. 先说结论

Claude Code 的源码先进性真正稀缺的地方，不在于：

- 目录更优雅

而在于：

- 它把未来维护者纳入了正式消费者集合

这意味着代码不只要回答：

- 机器今天怎么跑

还要回答：

1. 未来维护者怎样一眼看出哪里不能乱改。
2. 未来重构者怎样顺着现有 seam 继续抽离。
3. 制度记忆怎样被留在代码，而不是继续留在老作者脑中。

## 2. risk-bearing naming 说明风险应在阅读阶段被看见

`DANGEROUS_uncachedSystemPromptSection` 这种名字，和 `single choke point`、`authoritative` 这类术语，最重要的作用不是优雅，而是：

- 在阅读阶段就让后来者看见风险

这意味着命名不再只是表达功能，而是在表达：

- 改这里会破坏什么

它把未来维护者最需要知道的信息前移到了：

- 读代码的第一眼

## 3. institutional-memory comments 说明注释在保存制度，而不是解释语法

`fingerprint.ts` 直接写明：

- 这个算法不能随便改，需要和外部 API 协调

`onChangeAppState.ts` 明确记录过去 mode sync 只覆盖了少数路径，导致外部 metadata 失真。

`hooksConfigSnapshot.ts` 又解释 stale settings、watcher 延迟和 refresh snapshot 的必要性。

这些注释保存的不是“这里做了什么”，而是：

- 为什么必须这样做
- 曾经错在哪里
- 改错会牵连谁

这正是未来维护者最需要的：

- 制度记忆

## 4. leaf modules 说明共享规则应被压成小而硬的治理节点

`pluginPolicy.ts`、`systemPromptType.ts`、`normalization.ts` 这类小模块体现的是同一条纪律：

- 高扇入共享规则必须尽可能小、薄、依赖少

这样做的价值不仅是切循环依赖，还在于：

1. 规则更容易被单点审计。
2. blast radius 更清楚。
3. 后来者不必把整张重模块图一起拉进来才能改一条规则。

这说明 leaf module 在这里服务的不是“文件拆小”，而是：

- 可治理的小真相文件

## 5. config / deps seam 说明今天就在为未来重构让路

`query/config.ts` 直接说明把 immutable config 从 mutable state 中拆开，是为了未来把 `step()` 提取成更纯的 reducer。

`query/deps.ts` 则直说：

- 先只抽 4 个依赖来证明模式

这说明 Claude Code 的重构观不是：

- 某天再整体大改

而是：

- 今天就让未来重构者能看见下一步从哪里抽

所以 seam 的价值在于：

- 降低未来认知债

而不是：

- 立即把所有代码整理得更漂亮

## 6. snapshot semantics 与 state machine 说明时间边界也必须被显式治理

`hooksConfigSnapshot.ts` 维护配置快照。

`QueryGuard.ts` 把 query 生命周期压成：

- idle
- dispatching
- running

`task/framework.ts` 又明确要求：

- against fresh state 合并

这说明 Claude Code 不允许未来维护者把时间边界继续模糊成：

- 多几个布尔值
- 差不多能跑

它把这些边界都正式化成：

- snapshot 语义
- generation 语义
- stale finally / stale state 的失效规则

## 7. 为什么这是一块正式控制面，而不是工程附属层

把命名、注释、leaf module、config seam、deps seam、snapshot、state machine 放在一起看，会发现它们都在做同一件事：

- 让未来修改有显式边界

也就是说，它们共同构成的是：

- 未来维护者消费者控制面

这块控制面越清楚，系统越容易：

1. 小步演化
2. 保留重构可能性
3. 避免制度失忆
4. 避免多套半真相并存

## 8. 一句话总结

Claude Code 的源码之所以成熟，不只因为它今天能跑，而是因为它已经把未来维护者当成正式消费者，把风险、制度、seam 和状态边界都提前写进了代码控制面。
