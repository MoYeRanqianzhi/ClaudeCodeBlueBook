# 如何为未来维护者设计Agent Runtime：注释、命名、leaf module与重构余量

这一章回答五个问题：

1. 如果你在做自己的 agent runtime，最值得学的不是哪一个功能，而是哪一套长期可维护制度。
2. 怎样把注释、命名、类型、小模块和状态机从“代码风格”提升成治理工具。
3. 怎样在系统还没失控前就预留重构余量。
4. 为什么依赖图诚实性、单一真相文件和显式状态迁移，比表面上的目录整洁更重要。
5. 怎样用苏格拉底式追问避免把“写得好看”误当“能长期演化”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/systemPromptType.ts:1-12`
- `claude-code-source-code/src/services/mcp/normalization.ts:1-22`
- `claude-code-source-code/src/utils/toolSchemaCache.ts:1-25`
- `claude-code-source-code/src/utils/plugins/pluginPolicy.ts:1-20`
- `claude-code-source-code/src/constants/systemPromptSections.ts:27-50`
- `claude-code-source-code/src/utils/fingerprint.ts:40-63`
- `claude-code-source-code/src/query/config.ts:8-45`
- `claude-code-source-code/src/query/deps.ts:1-40`
- `claude-code-source-code/src/utils/queryContext.ts:1-87`
- `claude-code-source-code/src/utils/hooks/hooksConfigSnapshot.ts:1-132`
- `claude-code-source-code/src/types/permissions.ts:1-180`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/state/onChangeAppState.ts:50-128`

这些锚点共同说明：

- Claude Code 的源码不仅在服务机器执行，也在为未来维护者暴露治理边界和重构路径。

## 1. 先说结论

如果只记一套最小制度，可以压成五条：

1. 把高扇入共享规则压成 dependency-free leaf module。
2. 把未来会漂移的状态收成显式状态机。
3. 把未来会被重排的区域先切成 config / deps / snapshot 边界。
4. 把危险原因写进命名与注释，而不是留在团队口头记忆里。
5. 让单一真相文件服务全仓，而不是让多个半真相一起漂移。

这比“先把目录切漂亮”更接近长期可治理。

## 2. 第一步：把共享规则压成薄而诚实的 leaf module

`systemPromptType.ts`、`normalization.ts`、`toolSchemaCache.ts`、`pluginPolicy.ts` 都有一个共同点：

- 它们只承载一类共享规则，而且刻意保持依赖极薄

这些文件里反复出现的注释都是同一类信号：

- 放在这里，是为了避免循环依赖
- 放在这里，是为了保证全仓都能安全引用
- 放在这里，是为了让某个规则有单一权威来源

实践上：

1. branding、归一化、缓存句柄、策略真相这类高扇入规则，优先做成独立小模块。
2. 这些模块不要顺手挂上业务逻辑，否则很快又会重新膨胀成耦合源头。
3. 目标不是“更多 util”，而是“更少但更可信的共享真相”。

## 3. 第二步：提前为未来重构切出 seam

`query/config.ts` 明确把 query 入口时就能冻结的 immutable 值切成 `QueryConfig`；`query/deps.ts` 又只先抽出 4 个最常见的 I/O 依赖，用来证明 deps injection 模式。

这说明作者并没有追求一次性把所有东西抽干净，而是在做：

- 可渐进推进的重构制度

实践上：

1. 先把稳定配置切出来。
2. 再把最痛的 I/O 依赖切出来。
3. 不要求“一步到位”，但要让后来者看得出下一步该往哪抽。

成熟的重构余量，不是未来某天再大改，而是今天就把 seam 埋好。

## 4. 第三步：把“为什么必须分开”写进代码边上

`queryContext.ts` 不是只在实现功能，它还直说：

- 为什么这个文件要单独存在
- 如果把导入放错位置会造成什么 cycle
- 为什么 side question 的 fallback 允许轻微不完美但不能彻底失败

类似地，`hooksConfigSnapshot.ts` 也不是只返回 hooks，而是在代码里写清：

- managed hooks 和 non-managed hooks 的边界
- `disableAllHooks` 在不同来源下语义为什么不同
- 为什么更新快照前要先 reset settings cache

这类注释真正保存的是：

- 制度性记忆

实践上：

1. 注释优先写“为什么不能随便改”，而不只是“这里做了什么”。
2. 对 cycle、snapshot、authority、cache 这类制度边界，注释要比算法细节更清楚。
3. 好注释不是解释语法，而是帮后来者避免误改。

## 5. 第四步：把类型与状态迁移提升成治理界面

`types/permissions.ts` 被专门抽出来以打断 import cycle，同时集中管理 permission mode、rule source、update destination、decision shape 等正式合同；`QueryGuard.ts` 又把 query 生命周期压成：

- idle
- dispatching
- running

并显式写出转移规则与 generation 语义。

这说明长期可维护性依赖的不是“大家都小心一点”，而是：

- 系统把关键状态与合同先写成机器和人都能检查的正式面

实践上：

1. 高频共享 union / contract 放到单一类型源。
2. 会跨异步阶段漂移的状态，优先做成正式状态机。
3. 让清理、取消、stale finally 这类边角问题也有显式语义，而不是靠调用方自觉。

## 6. 第五步：让命名直接暴露治理意图

这一组源码里很值得学的，不只是抽模块，还有命名：

- `shouldAllowManagedHooksOnly`
- `shouldDisableAllHooksIncludingManaged`
- `clearToolSchemaCache`
- `isPluginBlockedByPolicy`
- `buildQueryConfig`

更强的一层证据是，作者会把风险直接写进名字里。比如 `DANGEROUS_uncachedSystemPromptSection` 这种命名，本质上是在提前告诉后来者：

- 这里一改就可能打碎缓存与协议稳定性

而 `fingerprint.ts` 这类文件里的注释又会直接写明：

- 这里不要随便改，除非和外部 API / 其他实现一起协调

这说明命名和注释在这里不是润色，而是：

- 显式护栏

这些名字几乎都在直接回答：

- 这段逻辑保护的到底是哪一层真相

比起抽象得很优雅但语义发虚的名字，这种写法更像治理界面，因为维护者几乎不用反向猜测：

- 这里到底在保护谁
- 这里的优先级关系是什么
- 改它会影响哪条制度边界

`onChangeAppState.ts` 这类 chokepoint 里甚至会把过去出现过的同步故障写进注释，等于把 bug 族谱直接编译进维护约束，避免后来者重复踩回原坑。

## 7. 苏格拉底式检查清单

在你设计自己的 agent runtime 时，先问自己：

1. 这一条共享规则，能不能压成全仓可安全引用的小模块。
2. 这个状态对象，是不是已经值得正式状态机。
3. 我现在切出来的边界，是否真的为未来重构留了路。
4. 哪些风险理由必须写进注释，而不能继续靠团队口头传承。
5. 这段代码暴露的是单一真相，还是多个彼此竞争的半真相。
6. 维护者第一次读到这里时，能不能一眼看出“哪里不能乱改”。

如果这些问题答不清，代码再漂亮也很难长期稳。

## 8. 一句话总结

Claude Code 值得学的不是“把目录抄成一样”，而是把制度记忆、单一真相、状态迁移和重构 seam 直接写进代码边界里，让未来维护者接手时不必重新猜一遍系统为什么这样设计。
