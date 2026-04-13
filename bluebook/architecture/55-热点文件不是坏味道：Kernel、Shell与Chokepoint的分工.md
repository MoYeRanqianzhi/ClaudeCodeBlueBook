# 热点文件不是坏味道：Kernel、Shell与Chokepoint的分工

这一章回答五个问题：

1. 为什么 Claude Code 存在 `query.ts`、`REPL.tsx`、`services/mcp/config.ts` 这类热点大文件，却仍然是成熟架构。
2. 什么样的大文件属于合法的 runtime kernel / orchestration shell。
3. 为什么真正危险的不是“大”，而是把时序复杂度撒满全仓。
4. Claude Code 如何用 leaf modules、single source of truth 与防循环边界为热点文件兜底。
5. 这对 agent runtime 的工程判断标准有什么启发。

## 0. 代表性源码锚点

- `claude-code-source-code/src/query.ts:181-260`
- `claude-code-source-code/src/query.ts:365-420`
- `claude-code-source-code/src/query.ts:659-865`
- `claude-code-source-code/src/query.ts:1065-1085`
- `claude-code-source-code/src/query.ts:1678-1735`
- `claude-code-source-code/src/query/config.ts:1-43`
- `claude-code-source-code/src/query/deps.ts:1-37`
- `claude-code-source-code/src/utils/queryContext.ts:1-40`
- `claude-code-source-code/src/QueryEngine.ts:175-210`
- `claude-code-source-code/src/screens/REPL.tsx:1-70`
- `claude-code-source-code/src/screens/REPL.tsx:889-907`
- `claude-code-source-code/src/screens/REPL.tsx:4392-4408`
- `claude-code-source-code/src/screens/REPL.tsx:4548-4566`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-108`
- `claude-code-source-code/src/tools.ts:329-345`
- `claude-code-source-code/src/hooks/useMergedTools.ts:1-30`
- `claude-code-source-code/src/services/mcp/config.ts:337-365`
- `claude-code-source-code/src/services/mcp/normalization.ts:1-20`
- `claude-code-source-code/src/services/analytics/index.ts:1-40`
- `claude-code-source-code/src/utils/plugins/pluginPolicy.ts:1-18`
- `claude-code-source-code/src/types/permissions.ts:1-36`

## 1. 先说结论

Claude Code 的成熟，不在于：

- 完全没有热点大文件

而在于：

- 它只允许少数地方复杂
- 并且这些复杂被明确命名成 kernel、shell、chokepoint

换句话说，它不是：

- 到处都复杂

而是：

- 少数 runtime kernel 承担时序复杂度
- 大量 leaf modules 承担稳定 contract

这才是更成熟的架构取向。

## 2. `query.ts` 为什么可以大

`query.ts` 之所以大，不是因为作者把一堆业务随手堆进去，而是因为它承担的是：

- turn runtime kernel

这里的复杂度有一个共同特征：

- 都属于同一轮 query 的时序耦合

例如：

- tool result budget
- microcompact / autocompact
- stream / tool execution
- max output recovery
- next turn transition

这些逻辑如果被“伪拆分”成很多孤立小文件，表面上可能更碎，但实际会把最危险的东西传播到全仓：

- continue reason
- stop reason
- compact / recovery 的先后顺序
- per-turn mutable state

所以 `query.ts` 的“大”，在这里并不是坏味道，而是：

- 对时序复杂度的集中收口

但这里也有一条硬降格线：如果一个热点答不出 `sole writer`、`forbidden substitute writer` 与最近的 `fail-closed seam`，它就还不配被叫作 lawful kernel，只配先算 `hotspot candidate` 或债务汇流点。

## 3. `REPL.tsx` 为什么也可以大

`REPL.tsx` 的复杂度也不是任意膨胀。

它承担的是：

- 前台 orchestration shell

也就是说，它处理的是多种交互临界区的统一编排：

- transcript screen 与 normal screen 的早退分支
- scroll chokepoint
- modal 与 overlay
- local query loading vs external loading
- keybinding composition

这些东西天然就需要：

- 同屏幕状态
- 同交互上下文
- 同步组合

如果强行把这类前台临界区拆成很多表面小文件，往往只会带来：

- 更多交叉 prop drilling
- 更多分散状态
- 更多“谁才是当前真相”的二次复杂度

所以 `REPL.tsx` 的合法性不在于它不大，而在于：

- 它的大主要服务前台编排壳，而不是把所有底层 contract 全塞进来

## 4. 大文件周围是否有显式 seams，才是判断关键

Claude Code 最大的成熟信号之一，不是“热点文件小”，而是：

- 热点文件周围有很多显式 seam

### 4.1 `query.ts` 周围的 seams

它旁边已经显式抽出了：

- `query/config.ts`
- `query/deps.ts`
- `query/tokenBudget.ts`
- `query/stopHooks.ts`
- `utils/queryContext.ts`

这说明作者并不是没意识到复杂度，而是在做更成熟的事：

- 把适合稳定下沉的边界先抽出去
- 把还必须同处一室的时序内核留在 kernel 文件里

### 4.2 `REPL.tsx` 周围的 seams

它周围也有：

- `QueryGuard`
- `ScrollKeybindingHandler`
- `useMergedTools`
- 一堆 hooks / components / helpers

这意味着 REPL 并不是一个把所有事情都内联的怪物，而是：

- 大壳 + 多个明确边界

## 5. Single Source of Truth 是热点大文件合法性的前提

热点文件之所以还能健康，前提是关键真相没有被复制。

Claude Code 在这点上做得很自觉。

例如：

- 工具池统一走 `assembleToolPool()`
- 本地 query 是否在飞统一走 `QueryGuard`
- 权限类型统一走 `types/permissions.ts`
- MCP 名字规范化统一走 `services/mcp/normalization.ts`
- plugin policy 统一走 leaf module

这意味着即使 kernel/shell 文件很大，它们周围的公共 contract 仍然是：

- 单点收口

而不是：

- 每个热点文件各写一套

## 6. 防循环意识说明这些大文件不是“自然长大”的

另一个很重要的成熟信号是：

- 仓库对 import cycle 有持续自觉

从注释里可以直接看到：

- `queryContext.ts` 被单独抽出是为了 break cycles
- `analytics/index.ts` 明确要求 no dependencies
- `pluginPolicy.ts` 明确要求 leaf module
- `types/permissions.ts` 明确抽纯类型以打断循环

这说明 Claude Code 的热点文件不是：

- 放任复杂度蔓延后的自然结果

而是：

- 在依赖图约束下，被有意识保留下来的 kernel / shell

## 7. `services/mcp/config.ts` 说明“策略 chokepoint”也可以合法地大

`services/mcp/config.ts` 也是一个典型例子。

它的“大”主要来自：

- scope precedence
- allow / deny 语义
- merge 规则
- dedup
- claude.ai 兼容路径

这些复杂度并不是散乱的业务逻辑，而是：

- 配置与策略控制面

这种文件最怕的不是大，而是被拆成十几个各自半真半假的 policy helper。

Claude Code 在这里反而做了更成熟的取舍：

- 让策略复杂度留在一个显式 chokepoint

## 8. 真正危险的不是大，而是把复杂性撒满全仓

从第一性原理看，复杂系统最怕的不是：

- 少数几个合法热点

而是：

- 每个文件都偷偷带一点时序逻辑
- 每个子系统都顺手维护一点真相
- 没有人能回答最终由谁说了算

Claude Code 在这一点上反而是清醒的。

它允许：

- kernel 文件继续大
- shell 文件继续大
- 策略 chokepoint 继续大

但配套要求是：

- 周围 contract 要更纯
- single source of truth 要更强
- cycles 要更受控

## 9. 工程判断标准

所以判断一个大文件是不是坏味道，更成熟的标准应当是：

1. 它承不承担合法的 kernel / shell / chokepoint 职责。
2. 它周围有没有显式 seams。
3. 它是否在复制真相，还是在集中真相。
4. 它是否把复杂度向外扩散，还是把复杂度拦在自己这里。
5. 依赖图是否仍然有 leaf modules 与 anti-cycle 边界兜底。

这比“文件越小越好”的审美判断更可靠。

## 10. 一句话总结

Claude Code 的成熟，不在于完全没有大文件，而在于它只让少数 kernel、shell 与策略 chokepoint 承担合法复杂度，并用 single source of truth、leaf modules 与防循环边界阻止复杂度向全仓扩散。
