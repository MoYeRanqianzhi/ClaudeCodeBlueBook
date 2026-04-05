# 治理 Evidence Envelope反例：只看Token、只看审批与只看结果

这一章不再收集“治理制度本身设计错”的反例，而是收集治理证据被不同消费者拆散之后最常见的失真样本。

它主要回答五个问题：

1. 为什么治理证据已经存在时，团队仍然会退回 token 崇拜、审批崇拜与结果崇拜。
2. 为什么治理的 shared evidence envelope 最容易被拆成“状态面”“成本面”“审批面”“结果面”四份互不相认的材料。
3. 哪些坏解法最容易把统一定价秩序退回局部 KPI。
4. 怎样把这些坏解法改写回 Claude Code 式共享证据消费。
5. 怎样用苏格拉底式追问避免把这一章读成“作者在抱怨大家不会看指标”。

## 0. 第一性原理

治理线最危险的，不是：

- 没有任何观测

而是：

- 各类观测都存在，却被不同角色拆着看，没人再围绕同一 decision window 与 rollback boundary 判断

这样一来，系统虽然记录了：

- `worker_status`
- `pending_action`
- `Context Usage`
- control arbitration
- rollback object

团队却依旧回到：

- 这轮更贵了吗
- 这次审批多了吗
- 结果是不是放行了

## 1. 只看 Token vs decision window

### 坏解法

- CI 或管理面只看 token 总量、平均成本或上下文占比，把治理证据压成成本曲线。

### 为什么坏

- token 只是结果，不是当前治理窗口的全部真相。
- 如果没有 `continuationCount`、`diminishingReturns`、current object、next action，团队就看不见“这轮还值不值得继续”。
- 最终会把治理成熟度误写成预算压缩能力。

### Claude Code 式正解

- 把 token 花费和 decision window 一起消费。
- 成本判断必须同时回答：当前继续是否还有增益、是否该升级对象、是否该停止。


## 2. 只看审批次数 vs control arbitration truth

### 坏解法

- 评审只看 ask 次数、批准次数、拒绝次数，默认审批流程已经被充分描述。

### 为什么坏

- ask 次数并不能说明是谁赢下了仲裁。
- `request_id`、`tool_use_id`、winner source、cancel / response race、等待时长缺失时，审批真相就会被压扁成按钮计数。
- 团队会把治理问题误读成“审批太多”或“审批太少”。

### Claude Code 式正解

- 把审批证据写成仲裁真相，而不是按钮统计。
- 审批的关键不在量，而在：
  - 谁先判断
  - 谁后判断
  - 为什么最终结束等待


## 3. 只看最终结果 vs authority source / failure semantics

### 坏解法

- 宿主和评审只看最终 allow / deny / fail，把治理证据消费成结果面。

### 为什么坏

- 不同 failure semantics 的治理意义完全不同。
- `fail-open`、`fail-closed`、退回人工、停止 continuation、升级对象，这些都是不同制度动作。
- 只看最终结果，会把治理顺序和失败分型一起抹掉。

### Claude Code 式正解

- 最终结果只是 envelope 的尾部，不是治理真相的全部。
- 先看 authority source、decision window、failure semantics，再看结果。


## 4. 只看状态面 vs rollback object boundary

### 坏解法

- 宿主或交接者只看当前 `worker_status`、`pending_action`、`permission_mode`，默认状态面已经足够描述治理现场。

### 为什么坏

- 状态面回答的是“现在怎样”，却不回答“如果坏了该退回哪个对象”。
- 一旦失败，团队又会退回按文件、按 commit、按症状拍脑袋回退。
- 治理证据失去未来约束力。

### Claude Code 式正解

- 当前状态必须和 rollback object boundary 一起消费。
- 只有同时知道当前状态和回退边界，治理证据才足以支撑下一步判断。


## 5. 分面消费 vs shared governance envelope

### 坏解法

- 宿主看状态，CI 看 token，评审看审批，交接看结果，默认大家合起来就等于同一套治理证据。

### 为什么坏

- 这四组材料各自都像对的，但没有共享同一套对象、窗口、仲裁和回退骨架。
- 最终团队会在不同视角里得出彼此冲突的结论。
- shared envelope 被拆成四份局部 dashboard。

### Claude Code 式正解

- 所有消费者先共享同一套治理证据骨架：
  - object
  - status
  - decision window
  - control evidence
  - rollback boundary


## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是 decision window，还是只是在看 token 曲线。
2. 我记录的是仲裁真相，还是只是在数审批次数。
3. authority source 与 failure semantics 是否已经点名。
4. 当前状态之外，rollback object boundary 是否也已经写清。
5. 我是在共享同一套治理证据骨架，还是只是共享几份相关指标。
