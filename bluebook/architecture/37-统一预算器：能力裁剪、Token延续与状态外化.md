# 统一预算器：能力裁剪、Token延续与状态外化

这一章回答五个问题：

1. 为什么 Claude Code 的安全、治理与省 token 应该被看成同一预算器。
2. 预算器在请求前、请求中、请求后分别做什么。
3. 为什么“省 token”本质上不是压缩文本，而是裁剪能力与稳定工作集。
4. 为什么预算器必须把状态同步给宿主，而不是只在内部偷偷修正。
5. 这套结构对 Agent runtime 设计有什么可迁移的启发。

## 0. 代表性源码锚点

- `claude-code-source-code/src/types/permissions.ts:16-38`
- `claude-code-source-code/src/types/permissions.ts:148-320`
- `claude-code-source-code/src/tools.ts:253-367`
- `claude-code-source-code/src/query.ts:369-467`
- `claude-code-source-code/src/query.ts:1065-1255`
- `claude-code-source-code/src/query/tokenBudget.ts:1-92`
- `claude-code-source-code/src/services/tokenEstimation.ts:244-325`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/main.tsx:1747-1771`
- `claude-code-source-code/src/main.tsx:2239-2408`
- `claude-code-source-code/src/main.tsx:2655-2676`

## 1. 先说结论

Claude Code 的预算器不是单一 token budget，也不是单一 permission engine。

它更像一套三段式 runtime correction system：

1. 请求前：裁掉不该暴露的能力。
2. 请求中：把上下文维持在可运行、可恢复的工作集。
3. 请求后：根据预算结果决定继续、自恢复还是显式停机。

所以“省 token”的更准确说法不是：

- 少说一点话

而是：

- 减少无谓能力暴露
- 稳定 prompt 前缀
- 外置大块输出
- 在上下文超限前完成纠偏

## 2. 请求前预算：先裁能力，再让模型看见世界

`types/permissions.ts` 把权限模式、规则来源、allow/ask/deny 决策、拒绝原因都显式做成 union。

这意味着权限不是模糊状态，而是正式预算对象。

`tools.ts` 又把这套预算落实到能力暴露层：

- deny 规则先过滤工具池
- blanket deny 可以直接让某个工具或某个 MCP server 前缀从模型视野里消失
- built-in 与 MCP 工具还会按稳定排序合并，避免 cache 因工具顺序抖动而失效

这里最关键的一点是：

- 预算发生在调用前，而不是调用后

也就是说，Claude Code 不只是“发现危险动作后拦住”，而是：

- 尽量不把不该做的动作暴露给模型

## 3. 请求中预算：把上下文当工作集，而不是当无限历史

`query.ts` 在真正调模型前会按顺序做多层预算收缩：

1. `applyToolResultBudget`
2. snip
3. microcompact
4. context collapse
5. autocompact

这条链路说明，Claude Code 不是把 compact 当最后补救，而是把预算内化为主路径。

再结合 `countTokensViaHaikuFallback(...)`，可以看到作者处理的并不是“理论 token 数”，而是：

- 在不同 provider / region / thinking block 约束下仍尽量得到保守估算

这背后的第一性原理是：

- 预算器宁可保守，也不能在发现超限时已经太晚

## 4. 请求后预算：自动继续、自恢复与显式停止

`query/tokenBudget.ts` 说明 token budget 不只是计数器，还负责：

- 判断是否继续
- 判断是否进入 diminishing returns
- 生成 continuation nudge

`query.ts` 又把预算失败后的恢复写成显式分支：

- `collapse_drain_retry`
- `reactive_compact_retry`
- `max_output_tokens_escalate`
- `max_output_tokens_recovery`

这说明 Claude Code 的预算器不是“爆了以后报错”，而是：

- 先尝试低成本恢复
- 再尝试高成本恢复
- 最后才把错误显式暴露给用户和宿主

## 5. 状态外化：预算器必须让宿主知道系统为什么变了

`onChangeAppState.ts` 明确把 `toolPermissionContext.mode` 的变化同步到：

- `external_metadata`
- SDK status stream

这一步非常关键，因为预算如果只在内部生效，宿主就只能猜：

- 为什么刚才还能做，现在不能做
- 为什么模式突然变了
- 为什么某条能力被撤回

Claude Code 选择的不是“让宿主猜”，而是：

- 让预算器的关键结果进入显式状态同步

## 6. 治理是高阶预算来源，不是部署尾巴

`main.tsx` 里有三类很说明问题的预算修正：

1. 初始化时剥离 overly broad shell permissions 与危险 auto-mode 权限。
2. trust 建立前延后 LSP、prefetch、remote control 等高风险能力。
3. 启动后再异步验证 `bypassPermissions` 与 auto mode entitlement，并在不满足时回写状态。

这说明治理层在做的不是“补一个企业开关”，而是：

- 决定预算器是否允许某些动作空间存在

所以权限、治理与 token 经济并不是三条平行逻辑，而是同一预算器的不同输入面。

## 7. 苏格拉底式追问

### 7.1 为什么“省 token”不等于少输出

因为真正昂贵的通常不是最终回复长度，而是：

- 工具目录重复注入
- 大块结果留在上下文里
- provider 差异导致的 token 低估
- 超限后没有恢复路径

### 7.2 为什么安全不能只靠 prompt

因为 prompt 无法：

- 从工具池里移除能力
- 在 gate 变化时回写宿主状态
- 阻止未经治理批准的远程能力继续暴露

### 7.3 为什么预算器必须是持续运行的

因为预算不是一次性判定。

用户、工具、上下文长度、provider、治理策略都在变。
如果预算器只在一个时间点工作，系统迟早会失去可解释性。

## 8. 一句话总结

Claude Code 的统一预算器，本质上是在持续裁剪能力、维持工作集并外化状态；它既是安全系统，也是 token 经济系统，还是治理系统。
