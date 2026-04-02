# 治理 Host Artifact Contract：对象、窗口、仲裁、失败语义与回退工件协议

这一章回答五个问题：

1. 治理线的宿主卡、CI 附件、评审卡与交接包，到底应该共享哪些正式字段。
2. 哪些字段是 shared contract，哪些只是 role-specific projection，哪些仍应停留在 internal hint。
3. 为什么治理工件必须继续围绕 current object、decision window、winner source、failure semantics 与 rollback object，而不是围绕仪表盘、阈值图与审批次数。
4. 哪些字段最适合写成 hard contract，缺失时必须直接判定工件不合法。
5. 宿主开发者与平台设计者该按什么顺序接入这套治理 artifact contract。

## 0. 关键源码锚点

- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:235-1283`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:244-300`
- `claude-code-source-code/src/query/tokenBudget.ts:1-82`
- `claude-code-source-code/src/utils/toolResultStorage.ts:367-860`
- `claude-code-source-code/src/utils/sessionState.ts:92-146`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

## 1. 先说结论

治理线真正成熟的 artifact contract，不是四类角色各自看一套 dashboard，而是四类工件共享同一份 Governance object contract：

1. 宿主卡回答“当前对象、当前状态、当前窗口与当前回退边界是什么”。
2. CI 附件回答“仲裁、Context Usage、失败语义与升级条件是否仍成立”。
3. 评审卡回答“这次判断链是否仍由同一 authority source 支撑”。
4. handoff package 回答“后来者是否能直接继续做继续、停止、升级或回退判断”。

四类工件的差异只应该体现在展开深度，而不应该体现在：

- 判断链来源

## 2. Governance Artifact Contract 的三层字段

### 2.1 Shared Contract

这些字段必须被四类工件共享：

1. `artifact_line_id`
2. `governance_object_type`
3. `governance_object_id`
4. `current_state`
5. `authority_source`
6. `observed_window`
7. `decision_window`
8. `control_arbitration_truth`
9. `failure_semantics`
10. `rollback_object`
11. `object_upgrade_rule`
12. `next_action`

### 2.2 Role-Specific Projection

这些字段只在特定工件里展开：

1. 宿主卡：
   - `blocked_state`
   - `pending_action`
   - `permission_mode`
2. CI 附件：
   - `Context_Usage_breakdown`
   - `winner_source`
   - `hard_fail_result`
3. 评审卡：
   - `arbitration_judgement`
   - `window_judgement`
   - `rollback_judgement`
4. Handoff package：
   - `retained_assets`
   - `re_entry_conditions`
   - `background_refs`

### 2.3 Internal Hint

这些信息可以引用，但不应直接升格成稳定公共字段：

1. 内部 classifier 中间评分
2. 临时等待时序细项
3. 非公共的调试 trace
4. 临时 budget 实验标志

## 3. Shared Header

更稳的治理 artifact header 可以固定为：

```text
artifact_header:
- artifact_line_id
- governance_object_type
- governance_object_id
- current_state
- authority_source
- observed_window
- decision_window
- control_arbitration_truth
- failure_semantics
- rollback_object
- object_upgrade_rule
- next_action
```

它的作用不是：

- 把所有治理图表都塞进一张表

而是：

- 让四类工件都从同一治理判断链起手

## 4. 四类工件的最小 contract

### 4.1 宿主卡

最少字段：

1. `governance_object_id`
2. `current_state`
3. `decision_window`
4. `rollback_object`
5. `next_action`

禁止退化为：

- 只有绿色状态
- 只有 allow / deny

### 4.2 CI 附件

最少字段：

1. `control_arbitration_truth`
2. `Context_Usage_breakdown`
3. `failure_semantics`
4. `object_upgrade_rule`
5. `hard_fail_result`

禁止退化为：

- 只有 token / latency 阈值
- 只有 ask 次数

### 4.3 评审卡

最少字段：

1. `authority_source`
2. `decision_window`
3. `winner_source`
4. `failure_semantics`
5. `rollback_object`
6. `review_judgement`

禁止退化为：

- 先看结果，再补判断链

### 4.4 Handoff Package

最少字段：

1. `governance_object_id`
2. `current_state`
3. `decision_window`
4. `rollback_object`
5. `next_action`

禁止退化为：

- 只有“现在卡住了”
- 只有“现在比较贵/比较严”

## 5. 为什么这些工件必须继续围绕 decision window

因为治理真正要回答的不是：

- 结果是不是绿色

而是：

- 当前这轮判断还是否存在决策增益

如果工件围绕的不是 decision window：

1. 宿主卡会重新退回结果面。
2. CI 附件会重新退回阈值面。
3. 评审卡会重新退回审批计数。
4. 交接包会重新退回状态摘要。

## 6. 为什么 winner source、failure semantics 与 rollback object 也必须进入 contract

因为治理成熟度不只来自：

- 现在看起来没出错

还来自：

1. 谁赢下了仲裁。
2. 失败时退化到哪里。
3. 坏了之后退回哪个对象。

如果这三类字段没有写进 contract：

1. 仲裁真相会退回按钮结果。
2. 失败语义会退回事后解释。
3. 回退边界会退回拍脑袋操作。

## 7. Hard Contract 字段

最应写成 hard contract 的字段：

1. `governance_object_type`
2. `governance_object_id`
3. `authority_source`
4. `decision_window`
5. `winner_source`
6. `failure_semantics`
7. `rollback_object`
8. `object_upgrade_rule`
9. `next_action`

这些字段缺任何一项，都不应再被视为：

- 合法 Governance artifact

## 8. 最小接法

如果你要最小化接入治理 artifact contract，建议按下面顺序做：

1. 先把 shared header 固定下来。
2. 再让宿主卡、CI 附件、评审卡与 handoff package 都继承这一 header。
3. 再按角色增加 projection 字段。
4. 最后再把 internal hints 变成 evidence refs，而不是公共 schema。

## 9. 一句话总结

治理 Host Artifact Contract 真正统一的，不是四类工件的展示方式，而是它们依赖的同一条治理判断链与同一组回退、升级、仲裁字段。
