# 升级证据真相面：状态写回、可观测Diff、决策窗口与回退对象

这一章回答五个问题：

1. 为什么源码里虽然没有一个叫 `RolloutEvidence` 的类型，但其实已经存在一条正式的升级证据真相面。
2. 为什么状态写回、可观测 diff、决策窗口与回退对象边界必须一起理解。
3. 为什么 rollout 证据不该只停在 playbook，而必须回灌到 runtime 机制层。
4. 为什么这条线会同时解释 Prompt 魔力、安全/省 token 与源码先进性的更深统一性。
5. 这对 agent runtime 设计者意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/sessionState.ts:92-146`
- `claude-code-source-code/src/state/onChangeAppState.ts:24-90`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:1-118`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-360`
- `claude-code-source-code/src/utils/messages.ts:1989-2075`
- `claude-code-source-code/src/utils/messages.ts:5128-5188`
- `claude-code-source-code/src/utils/toolResultStorage.ts:739-860`
- `claude-code-source-code/src/query/tokenBudget.ts:1-82`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-83`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-120`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:824-878`
- `claude-code-source-code/src/services/api/claude.ts:1405-1460`

## 1. 先说结论

Claude Code 的源码里没有一份名为：

- `rollout_evidence.ts`

的集中定义。

但它已经把升级证据真正需要的四类对象写成了正式运行时表面：

1. 状态写回面：
   - 当前到底卡在哪、谁在宣布当前真相。
2. 可观测 diff 面：
   - 哪些字节变了，为什么这次行为/成本会变。
3. 决策窗口面：
   - 当前继续花 token 是否还值得，何时该停。
4. 回退对象面：
   - 失败时到底该回退哪个对象，而不是回退哪些文件。

这四块合起来，才构成 Claude Code 更深一层的：

- upgrade evidence surface

## 2. 状态写回面：证据首先不是日志，而是当前真相快照

`sessionState.ts` 与 `onChangeAppState.ts` 共同说明：

- Claude Code 不愿把“当前状态”留给外部自己从事件流猜

它会主动外化：

1. `worker_status`
2. `pending_action`
3. `permission_mode`
4. `is_ultraplan_mode`
5. `task_summary`

而且这些字段不是零散同步。

`onChangeAppState(...)` 明确把 mode diff 收口到 single choke point，`notifySessionStateChanged(...)` 又把 `requires_action`、`idle` 与 `task_summary` 清理写成正式状态变化。

这说明升级证据的第一层不是：

- 某次发布后团队写了什么总结

而是：

- 系统平时是否已经持续保存“当前到底是什么状态”的正式快照

如果这层不存在，任何 rollout 证据都会很快退化成：

- 事后解释

## 3. 可观测 diff 面：没有 diffable bytes，就没有可解释升级

`promptCacheBreakDetection.ts` 与 `claude.ts` 共同说明：

- Claude Code 会持续记录哪些 system bytes、tool schemas、betas、effort、extra body params 正在构成当前 prompt 真相

它不只看：

- cache 有没有命中

还看：

1. system hash
2. tools hash
3. cache control hash
4. model / betas / overage / auto mode / effort

而且这里的 diff 不只来自：

- system prompt 文本

`claude.ts` 在真正发请求前还会：

1. `normalizeMessagesForAPI(...)`
2. 按模型裁剪 tool-search 字段
3. `ensureToolResultPairing(...)`

这说明 Prompt rollout 真正保护的是：

- 编译后的 request truth

而不只是：

- 某段提示词原文

同样，`toolResultStorage.ts` 把 replacement preview 的 fate freeze 写成强约束：

- 一旦为某个 `tool_use_id` 选定 replacement，后续必须字节级稳定重放

这说明 Claude Code 要保护的不是：

- “看起来差不多”

而是：

- 关键治理字节是否真的可被比较、归因与重放

从升级证据视角看，这一点极其关键。

因为如果你不能回答：

- 这次到底是哪类字节变了

你就不能真正回答：

- 为什么这次更贵
- 为什么这次更稳
- 为什么这次需要回退

## 4. 决策窗口面：证据必须回答“为什么现在该继续或停止”

`tokenBudget.ts` 和 `QueryGuard.ts` 一起说明：

- Claude Code 不把 continuation 当默认权利，而是把它视为一个必须不断被重新证明的决策窗口

`tokenBudget.ts` 记录：

1. `continuationCount`
2. `lastDeltaTokens`
3. `pct`
4. `diminishingReturns`
5. `durationMs`

`QueryGuard.ts` 则用 generation 和同步状态机保证：

- 旧 finally、旧 reservation、旧 running signal 不能复活当前查询

所以升级证据的第三层不是：

- 这次总共跑了几轮

而是：

- 当前这轮继续还有没有决策增益
- 当前这轮结束时谁还有资格清理对象状态

这就是为什么 rollout 样例必须记录：

1. observed window
2. metrics delta
3. judgement
4. next action

因为 runtime 本身就已经在这样判断。

## 5. 回退对象面：失败时要回退的是对象，不是文件

Claude Code 很多最成熟的结构判断都在强调同一个事实：

- 真相是按对象成立的，不是按文件成立的

`sessionIngress.ts` 用 `Last-Uuid` 与 `409 adopt server uuid` 保护的是：

- session append chain 这个对象

`bridgePointer.ts` 保护的是：

- bridge session 的 crash-recovery object

`task/framework.ts` 保护的是：

- task object 的 fresh-state merge 与 anti-zombie 边界

`remoteBridgeCore.ts` 在 401 恢复期间丢弃 stale control / stale result，保护的是：

- remote bridge generation object

这说明成熟回退永远不是：

- 哪几个文件改回去

而是：

1. 当前哪一个对象开始说谎。
2. 这个对象的权威面在哪里。
3. 这个对象有哪些恢复资产还可以保留。
4. 哪些 stale writer 必须被继续挡住。

从升级证据视角看，真正该被登记的不是文件列表，而是：

- rollback object boundary

## 6. 为什么这四层必须合在一起

只看状态写回，你会得到：

- 当前系统看上去还能恢复

只看 diff 面，你会得到：

- 某些字节变了

只看决策窗口，你会得到：

- 现在该继续还是该停

只看回退对象，你会得到：

- 如果坏了该撤回哪个对象

但真正成熟的升级证据，必须一次性回答四件事：

1. 当前真相是什么。
2. 当前真相为什么变了。
3. 当前继续是否还有制度收益。
4. 当前失败时该撤回哪一个对象。

这就是为什么 `playbooks/12-13` 的统一 ABI 最终必须回灌到架构层。

否则 ABI 会停在：

- 模板层

而不会进入：

- runtime 的真实证据面

## 7. 第一性原理

从第一性原理看，Claude Code 在这里押注的是：

- 一个成熟 runtime 不只要会完成当前任务，还要持续保存下一次升级的判断条件

这些判断条件至少包括：

1. 当前对象
2. 当前权威真相
3. 当前关键 diff
4. 当前决策窗口
5. 当前回退边界

所以 upgrade evidence surface 的真正作用不是：

- 让复盘更好看

而是：

- 让系统在下一次升级、下一次恢复、下一次接手时，仍站在同一个真相上继续判断

## 8. 一句话总结

Claude Code 的升级证据真相面，不是一套额外表单，而是状态写回、可观测 diff、决策窗口与回退对象边界在 runtime 里的正式合流。
