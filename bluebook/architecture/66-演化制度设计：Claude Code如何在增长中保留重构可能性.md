# 演化制度设计：Claude Code如何在增长中保留重构可能性

这一章回答五个问题：

1. 为什么 Claude Code 的源码先进性还能再上升一层，被理解成演化制度设计。
2. 为什么 `query/config.ts`、`query/deps.ts`、leaf module 注释、snapshot 逻辑这些细节本质上在保留重构可能性。
3. 为什么真正成熟的仓库不是“更会重构”，而是“增长时仍保留可重构性”。
4. 为什么注释和基础设施抽边在这里不是文档附属物，而是制度的一部分。
5. 这条线对 agent runtime 设计者意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/query/config.ts:1-43`
- `claude-code-source-code/src/query/deps.ts:1-37`
- `claude-code-source-code/src/utils/toolSchemaCache.ts:1-20`
- `claude-code-source-code/src/utils/hooks/hooksConfigSnapshot.ts:1-120`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-108`
- `claude-code-source-code/src/utils/settings/settings.ts:798-840`

## 1. 先说结论

Claude Code 的高级工程感，不只来自：

- 它现在已经有多少清晰边界

更来自：

- 它在增长中持续保留下一次重排系统的可能性

这是一种比“当前结构漂亮”更强的制度：

- 演化制度设计

也就是说，作者一直在提前回答：

1. 未来如果要拆 step，这一层今天该先怎么写。
2. 未来如果要注入 fake，这一层今天该先怎么写。
3. 未来如果要切断 cycle，这一层今天该先怎么写。
4. 未来如果要冻结真相快照，这一层今天该先怎么写。

## 2. `query/config.ts` 说明作者在为未来重排留接口

`query/config.ts` 的注释已经把目的说得很直：

- separating config from mutable state makes future step() extraction tractable

这不是普通“把配置抽出去”。

它是在明确：

- 今天就先把未来 reducer / step extraction 所需的静态部分隔离出来

也就是说，当前代码虽然还没完全变成那个形状，但：

- 重构路径已经被制度化地预留了

## 3. `query/deps.ts` 说明作者在用“小抽离”积攒重构资本

`query/deps.ts` 同样很坦白：

- narrow scope to prove the pattern

这句话非常关键。

它说明作者并不追求一次性全面抽象，而是：

- 先挑最痛的几个依赖抽出来
- 证明模式有效
- 再逐步扩大

这是一种很成熟的演化制度：

- 小步抽离
- 先换取测试与替换能力
- 再慢慢扩大结构收益

所以 Claude Code 值得学的不是“懂依赖注入”，而是：

- 知道怎样用最小抽离保留未来重构可能性

## 4. leaf module 注释说明“为什么这样写”也被制度化

`toolSchemaCache.ts` 的注释不只是解释功能，它明确记录：

- 为什么要放 leaf module
- 在防什么 cycle
- 哪条依赖链会被闭合

这类注释的价值，不是给新同学入门。

它更像：

- 仓库级制度记忆

也就是说，作者不希望“为什么不能那样改”只存在于少数人脑内，而希望它写进代码边上。

这让未来的改动者更容易保住：

- 依赖图纪律
- cache 稳定性纪律

## 5. snapshot 逻辑说明“时间上的一致性”也被制度化

`hooksConfigSnapshot.ts` 与 `settings.ts` 的注释都反复强调：

- 什么时候读 disk
- 什么时候 reset cache
- 为什么要拿一个一致快照

这意味着作者清楚知道：

- 随着系统继续增长，最容易坏掉的不只是静态结构，还有“现在这一刻到底以谁为准”的时间一致性

因此 snapshot、reset、single choke point 都不是权宜之计，而是在保留：

- 未来继续增长时，真相仍然可被冻结、可解释、可重放

## 6. `QueryGuard` 说明状态机也是一种制度

`QueryGuard` 之所以成熟，不只是因为它好用，而是因为它把 query lifecycle 的制度写成了显式状态：

- `idle`
- `dispatching`
- `running`

并把：

- generation
- stale finally
- force end

收成明确规则。

这说明 Claude Code 不是把状态迁移留给使用习惯，而是把它们制度化。

只有这样，未来继续增长更多异步路径时，系统才不会重新退回 flag 池。

## 7. 为什么这比“更会重构”更高级

很多团队喜欢说：

- 我们以后可以再重构

真正成熟的系统更该问的是：

- 现在这次增长之后，我们还保不保留下一次重构的可能性

Claude Code 的强点正在这里。

它并不假装已经完成所有理想分层，而是持续用：

- config
- deps
- snapshots
- state machines
- leaf modules

这些制度工具，把“未来还能重构”这件事留在系统里。

## 8. 一句话总结

Claude Code 的源码先进性更深的一层，不是它今天已经把结构做到完美，而是它在增长中持续用制度化的小抽离、小冻结、小切边，保留下一次重构整套系统的可能性。
