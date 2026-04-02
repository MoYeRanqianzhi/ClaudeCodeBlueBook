# Evidence Envelope字段矩阵：宿主、CI、评审与交接四类消费者的共享消费顺序

这一章回答五个问题：

1. 宿主、CI、评审与交接四类消费者，到底应该共享哪些字段。
2. 哪些字段来自正式公共表面，哪些应由宿主自建 envelope 承载，哪些仍是 internal hint。
3. 四类消费者的消费顺序为什么必须一致，而不能各看各的 dashboard。
4. 为什么“统一字段矩阵”并不等于“所有人看同一份原始日志”。
5. 宿主开发者和平台设计者该怎样最小化接入这套矩阵。

## 0. 关键源码锚点

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1735-1745`
- `claude-code-source-code/src/utils/sessionState.ts:1-146`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-90`
- `claude-code-source-code/src/cli/print.ts:1036-1056`
- `claude-code-source-code/src/cli/remoteIO.ts:149-168`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-360`
- `claude-code-source-code/src/utils/messages.ts:1989-2075`
- `claude-code-source-code/src/query/tokenBudget.ts:1-82`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

## 1. 先说结论

更稳的 Evidence Envelope，不是让所有消费者都直接读：

- transcript
- internal logs
- prompt dump

而是给四类消费者共享一份字段矩阵。

这份矩阵的关键不是“字段越多越好”，而是：

1. 字段有清晰来源
2. 字段有统一消费顺序
3. 字段能映射到对象、窗口、字节与回退边界

## 2. 三层字段来源

在共享字段矩阵之前，先分清三层来源：

### 2.1 正式公共表面

这些字段可以被正式消费：

1. `session_state_changed`
2. `worker_status`
3. `external_metadata`
4. `Context Usage`
5. control request / response / cancel 的正式字段

### 2.2 宿主自建 envelope

这些字段应由宿主或平台在正式表面之上整理：

1. `observed_window`
2. `minimal_diff_summary`
3. `rollback_object_type`
4. `rollback_object_id`
5. `retained_assets`
6. `judgement`

### 2.3 internal hints

这些字段很有价值，但不应被当成稳定公共契约：

1. `promptCacheBreakDetection` 细粒度 hash / per-tool diff
2. `bridgePointer` 文件
3. task framework 的内部 patch / eviction 中间结构

## 3. 四类消费者的共享字段矩阵

| 字段组 | 宿主 | CI | 评审 | 交接 | 来源层 |
|---|---|---|---|---|---|
| 当前对象 | 必需 | 必需 | 必需 | 必需 | 宿主自建 envelope |
| `session_state_changed` / `worker_status` | 必需 | 可选摘要 | 必需摘要 | 必需摘要 | 正式公共表面 |
| `external_metadata.permission_mode / pending_action / task_summary` | 必需 | 可选摘要 | 必需摘要 | 必需 | 正式公共表面 |
| `Context Usage` / budget progress | 必需 | 必需 | 必需 | 可选摘要 | 正式公共表面 |
| compiled request diff / cache-break summary | 可选摘要 | 必需 | 必需 | 可选摘要 | envelope + internal hint |
| control arbitration evidence | 必需 | 必需摘要 | 必需 | 可选摘要 | 正式公共表面 + envelope |
| observed window | 必需 | 必需 | 必需 | 必需 | 宿主自建 envelope |
| rollback object boundary | 必需 | 必需 | 必需 | 必需 | 宿主自建 envelope |
| retained assets / dropped stale writers | 可选 | 必需摘要 | 必需 | 必需 | envelope + internal hint |

这张表真正说明的是：

- 四类消费者不必消费同样多的细节，但必须共享同样的字段骨架

## 4. 共享消费顺序

更稳的消费顺序应固定为：

1. 当前对象
2. 当前状态
3. 当前 diff
4. 当前决策窗口
5. 当前 control evidence
6. 当前 rollback boundary

这组顺序对四类消费者都成立，只是粒度不同。

### 4.1 宿主

宿主优先关心：

1. 当前对象
2. 当前状态
3. 当前 pending action / permission mode
4. 当前 budget 进度

### 4.2 CI

CI 优先关心：

1. 当前对象
2. 当前 diff 是否越界
3. 当前 observed window 是否满足门槛
4. 当前 rollback boundary 是否明确

### 4.3 评审

评审优先关心：

1. 当前对象是否定义清楚
2. 当前 diff 是否是最小 diff
3. 当前 judgement 是否由 observed window 支撑
4. 当前 rollback target 是否过宽或过窄

### 4.4 交接

交接优先关心：

1. 当前对象
2. 当前状态摘要
3. 当前 retained assets
4. 当前 rollback boundary

## 5. 为什么不能各看各的 dashboard

因为那样最容易发生四种失真：

1. 宿主只看到状态，不知道为什么变。
2. CI 只看到阈值，不知道对象是谁。
3. 评审只看到总结，不知道当前窗口。
4. 交接只看到 transcript，不知道回退边界。

这些失真一旦同时出现，系统就会重新退回：

- 多处半真相

这正是 shared evidence envelope 试图阻止的事。

## 6. 最小接法

如果你要最小化接入这套字段矩阵，建议按下面顺序做：

1. 先消费正式公共表面的当前状态字段。
2. 再补 observed window 与 rollback boundary 两个 envelope 字段。
3. 再按需要引入 diff summary 与 control evidence。
4. 最后再把 internal hints 变成 evidence refs，而不是直接上升成公共 schema。

## 7. 五条消费纪律

1. 不要让任何消费者跳过“当前对象”直接看结果。
2. 不要让任何消费者只看 transcript 不看状态与窗口。
3. 不要把 internal hint 直接写成稳定公共字段。
4. 不要让 rollback boundary 缺席。
5. 不要为不同消费者制造不同字段骨架。

## 8. 一句话总结

Evidence Envelope 的字段矩阵真正统一的，不是大家看的页面，而是大家判断升级时依赖的字段顺序与真相骨架。
