# 如何为Agent Runtime设计统一Rollout ABI：Diff卡、阶段评审卡、灰度结果与回退记录

这一章不再解释为什么要做 rollout，而是把“怎样把 rollout 证据写成统一 ABI”压成一套 builder-facing 方法。

它主要回答五个问题：

1. 怎样避免把 rollout 记录写成周报、复盘故事或项目管理表。
2. 怎样为 Prompt、治理与结构三条线设计“共用骨架 + 专项扩展”的证据 ABI。
3. 怎样从第一性原理确定对象、Diff、阶段、观测与回退的最小字段。
4. 怎样用同一套卡片同时支持 rollout、复盘、回退与后来者接手。
5. 怎样用苏格拉底式追问避免把统一模板做成空洞格式主义。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/systemPrompt.ts:28-127`
- `claude-code-source-code/src/query/stopHooks.ts:84-120`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:28-520`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/query/tokenBudget.ts:1-93`
- `claude-code-source-code/src/utils/toolResultStorage.ts:367-860`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts:13-116`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

这些锚点共同说明：

- Claude Code 真正成熟的不是“会 rollout”，而是 prompt、治理与结构三条线都已经天然需要可回放、可观测、可回退的证据接口。

## 1. 第一性原理

一份好的 rollout ABI，不是：

- 为了方便汇报

而是：

- 为了让升级对象、判断主权、证据字段与回退路径在时间上保持同一真相

所以设计 rollout ABI 时，最该反问的不是：

- 模板看起来够不够完整

而是：

- 它能不能逼团队先说明对象、边界、指标与回退，而不是先写结果

## 2. 五步设计法

### 2.1 先定义对象，而不是先定义任务

第一步先写清：

1. 这次升级的对象是什么。
2. 对象的权威面在哪里。
3. 哪些资产必须被保护。
4. 哪些症状说明它现在确实有问题。

如果对象先没定义清楚，后面所有“指标”“阶段”“回退”都会漂。

### 2.2 先压最小 diff，而不是先写理想终态

Diff 卡至少要回答：

1. 哪些东西预期变化。
2. 哪些东西预期不变。
3. 为什么这一步值得切。
4. 不切会继续暴露什么风险。

真正成熟的 rollout 不是：

- 一次性画终局蓝图

而是：

- 每一阶段只切最小可证明差异

### 2.3 先定义阶段主权，再定义阶段动作

阶段评审卡必须先写：

1. 谁是当前阶段的判断 owner。
2. 谁是 fallback owner。
3. 进入条件是什么。
4. 退出条件是什么。
5. 哪些信号意味着必须停止。

如果这些问题答不清，所谓 rollout 只是在：

- 沿时间顺序堆动作

而不是：

- 沿制度顺序推进升级

### 2.4 先定义观测字段，再解释结果

灰度结果卡必须强制团队先写：

1. 观察窗口。
2. cohort 或 scope。
3. metrics delta。
4. unexpected effects。
5. judgement 与 next action。

没有这一步，很多“升级成功”最终都会退化成：

- 没有证据支撑的主观感受

### 2.5 回退卡必须与 rollout 同时设计

回退记录卡不能在事故后补写。

因为真正成熟的升级不是：

- 先冲上线，再祈祷不出事

而是：

- 每切一层时，就已经知道该回退到哪一层、保留哪一层

## 3. 共用骨架与专项扩展

统一 rollout ABI 时，不要强迫三条线使用完全同样的字段。

更好的做法是：

1. 共用五张卡：对象、Diff、阶段评审、灰度结果、回退记录。
2. 每条线再补专项扩展字段。

### 3.1 Prompt 线

Prompt 线最关键的不是“prompt 文案改了多少”，而是：

1. `speaker_chain`
2. `section_slots_changed`
3. `stable_prefix_surface`
4. `dynamic_boundary_surface`
5. `shared_prefix_producer`
6. `lawful_forgetting_abi`
7. `cache_aware_assembly_factors`
8. `handoff_continuity_fields`

### 3.2 治理线

治理线最关键的不是“token 降了多少”，而是：

1. `order_before / order_after`
2. `decision_owner_before / after`
3. `decision_gain_hypothesis / cutoff`
4. `stable_bytes_touched`
5. `lease_model / revoke_conditions`
6. `stop_logic`
7. `human_fallback_path`
8. `failure_semantics_matrix`
9. `continuation_policy / object_upgrade_rule`

### 3.3 结构线

结构线最关键的不是“目录是不是更清爽”，而是：

1. `authoritative_surface`
2. `projection_set`
3. `transport_shell`
4. `recovery_asset`
5. `anti_zombie_gate`

## 4. 设计 rollout ABI 的常见误区

看到下面信号时，应提高警惕：

1. 用统一模板把主权差异、失败语义差异和回退层级差异全部抹平。
2. 只记录结果，不记录最小 diff。
3. 只记录成功路径，不记录 stop rule 和 rollback target。
4. 把 Prompt、治理、结构三条线都写成一套泛化 KPI 表。
5. 把 evidence refs 省略，导致记录脱离真实 diff、日志和状态快照。

## 5. 更好的落地顺序

当你准备在团队里推统一 rollout ABI 时，优先按下面顺序推进：

1. 先读 `../playbooks/12`，固定共用骨架与专项扩展字段。
2. 再读 `../playbooks/13`，确保团队能先照着最小填写示例落卡。
3. 再把旧样例 `../playbooks/09-11` 逆向映射到新 ABI，验证字段是否够用。
4. 最后才把模板接进团队工作流、周会、回归与事故复盘。

如果一开始就把模板推进流程工具，而没有先验证字段是否承载真实证据，最终只会得到：

- 更多表单
- 更少真相

## 6. 审读记录卡

```text
审读对象:
authoritative object:
protected assets:
minimal diff 是否明确:
phase owner / fallback owner 是否明确:
metrics / observed window 是否明确:
rollback target 是否明确:
专项扩展字段是否覆盖本线关键风险:
evidence refs 是否足以支持后来者复核:
当前最像哪类失败:
- 模板过宽 / 模板过窄 / 字段洗平 / 无回退 / 无证据
下一步该重写的是:
- object / diff / phase / metrics / rollback / extension fields
```

## 7. 苏格拉底式检查清单

在你准备宣布“团队已经有统一 rollout 模板”前，先问自己：

1. 我统一的是证据语义，还是只统一了表格样式。
2. 这套 ABI 是否真的让 Prompt、治理、结构三条线共享骨架，同时保留各自的关键不变量。
3. 如果本轮 rollout 失败，这套卡片是否足够支持快速回退，而不是只支持复盘作文。
4. 如果原作者离开，后来者能否仅靠这些卡片继续同样的判断。
5. 我是在减少证据编写成本，还是在把关键真相压扁成管理噪音。
