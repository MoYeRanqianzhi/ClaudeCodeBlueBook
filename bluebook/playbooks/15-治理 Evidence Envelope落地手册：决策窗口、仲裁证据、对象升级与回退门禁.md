# 治理 Evidence Envelope落地手册：决策窗口、仲裁证据、对象升级与回退门禁

这一章不再解释治理 evidence envelope 应该长什么样，而是把它压成宿主、CI、评审与交接都能直接执行的一套落地手册。

它主要回答五个问题：

1. 治理线真正的 host implementation playbook 到底该检查什么。
2. decision window、control arbitration、Context Usage 与 rollback boundary 该怎样被不同角色共同消费。
3. 哪些检查最适合写成硬门禁，哪些只该保留为评审或交接提示。
4. 怎样避免治理再次退回只看 token、只看审批与只看结果。
5. 怎样用苏格拉底式追问避免把这章写成纯治理流程表。

## 0. 改写前状态

没有治理 host implementation playbook 的团队，最常见状态是：

1. 宿主只显示当前状态，不显示当前判断窗口。
2. CI 只看 token 与延迟阈值。
3. 评审只看 ask 次数和最终 allow / deny。
4. 交接只知道“现在被卡住了”，不知道为什么、卡在哪里、坏了回退哪个对象。
5. 治理成熟度退回局部 KPI。

## 1. 目标状态

迁移后的目标不是：

- 多一张审批看板

而是：

1. 宿主消费状态、当前判断窗口与当前回退边界。
2. CI 校验 decision window、control evidence 与 object-upgrade gate。
3. 评审先看 authority source、failure semantics、winner source，再看结果。
4. 交接拿到当前对象、当前窗口、当前 rollback object。
5. 四类角色围绕同一治理 envelope 骨架判断。

## 2. 最小落地 diff

### 改写前

```text
宿主:
- 显示 allow / deny / requires_action

CI:
- 看 token / latency 阈值

评审:
- 看 ask 次数 / 最终结果

交接:
- 知道当前卡住了
```

### 改写后

```text
宿主:
- 展示当前 object / worker_status / pending_action / rollback boundary

CI:
- 检查 decision window / continuation gate / object-upgrade gate

评审:
- 先看 authority source / failure semantics / control arbitration truth

交接:
- 先看 current object / current window / rollback object / retained assets
```

### 这段 diff 的意义

真正的变化不是：

- 增加几项指标

而是：

- 把治理从“结果面”收回到“判断面”

## 3. 角色检查点

### 3.1 宿主最小检查点

宿主至少必须消费：

1. `worker_status`
2. `pending_action`
3. 当前 object
4. 当前 decision window 状态
5. 当前 rollback object

硬要求：

- 宿主不能只显示 allow / deny 或 ask / idle。

### 3.2 CI 最小检查点

CI 至少必须检查：

1. `observed_window` 是否明确。
2. `decision_gain` 是否仍存在。
3. `continuation_policy` 是否满足停止条件。
4. `object_upgrade_rule` 是否被触发却未执行。
5. `rollback_boundary` 是否已明确。

硬门禁：

- decision window 缺失
- authority source 缺失
- object upgrade 该发生却未发生
- rollback object 缺失

### 3.3 评审最小检查点

评审至少必须先看：

1. authority source
2. failure semantics
3. control arbitration truth
4. decision window
5. final judgement

软检查点：

- token / latency 是否与 decision window 一致
- ask 次数是否真的解释了治理变化

禁止事项：

- 只凭 ask 次数或最终结果做治理判断

### 3.4 交接最小检查点

交接至少必须交付：

1. current object
2. current `pending_action`
3. current decision window
4. current rollback object
5. retained assets
6. next action

硬要求：

- 交接不能只说“现在比较贵/比较严/正在等审批”。

## 4. 统一检查顺序

治理线四类角色更稳的统一顺序是：

1. 当前对象
2. 当前状态
3. authority source
4. control arbitration truth
5. decision window
6. failure semantics
7. rollback boundary

## 5. 治理线硬门禁

下面这些最适合写成硬门禁：

1. `authority source` 缺失。
2. `decision window` 缺失。
3. `winner source` / arbitration trace 缺失。
4. `failure semantics` 缺失。
5. `rollback object` 缺失。
6. `object_upgrade_rule` 触发但未执行。

## 6. 回退与对象升级

治理线回退时，至少保留：

1. 当前 object。
2. 当前 decision window。
3. control evidence。
4. retained assets。
5. rollback object boundary。

对象升级优先级：

1. 先问当前对象还值不值得继续。
2. 若不值得，优先升级 object，而不是继续烧 token。
3. 回退时优先回退 object-boundary，不要先回退结果。

## 7. 苏格拉底式追问

在你准备宣布治理 host implementation 已落地前，先问自己：

1. 宿主、CI、评审与交接是不是都先围绕 decision window 判断。
2. 我保住的是治理判断链，还是只保住了 token / ask / result 三个表面结果。
3. 任何一个角色现在还能不能只凭局部 KPI 给出治理结论。
4. 如果今天要回退，我知道该退回哪个对象了吗。
