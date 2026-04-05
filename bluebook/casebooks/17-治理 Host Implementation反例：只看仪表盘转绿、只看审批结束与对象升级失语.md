# 治理 Host Implementation反例：只看仪表盘转绿、只看审批结束与对象升级失语

这一章不再收集“治理 evidence envelope 被拆散”的反例，而是收集治理 host implementation 已经存在之后最常见的实施级失真样本。

它主要回答五个问题：

1. 为什么治理 implementation 明明已经有 decision window、control arbitration、Context Usage、rollback object 与 object-upgrade gate，团队仍然会退回局部 KPI 与流程通过。
2. 为什么治理的 host implementation 最容易被退化成“仪表盘转绿”“审批结束”“阈值安全”“对象先继续再说”四种形式化合规。
3. 哪些坏解法最容易让安全与省 token 再次退回事后解释。
4. 怎样把这些坏解法改写回 Claude Code 式共享 implementation 判断。
5. 怎样用苏格拉底式追问避免把这一章读成“执行流程不够严格”。

## 0. 第一性原理

治理 implementation 层最危险的，不是：

- 没有门禁

而是：

- 门禁已经存在，却只剩局部 dashboard、按钮结果与通过状态，没人再围绕同一 decision window、同一 arbitration truth 与同一 rollback object 判断

这样一来，系统虽然已经能要求：

- current object
- current state
- decision window
- winner source
- failure semantics
- rollback object
- object-upgrade gate

团队却依旧回到：

- 仪表盘绿了没有
- 审批结束没有
- 结果现在放行没有

## 1. 只看仪表盘转绿 vs decision window

### 坏解法

- 宿主只要显示状态恢复、负载下降、预算变绿，团队就默认治理 implementation 成立，不再检查当前 decision window 是否仍然存在、是否仍值得继续。

### 为什么坏

- 仪表盘转绿只说明表面压力下降，不说明当前判断窗口是否已关闭、是否只是把问题延后。
- 如果没有 observed window、decision gain 与 continuation policy，治理会重新退回“看起来好了”。
- 安全与省 token 的制度真相会被压扁成一张状态图。

### Claude Code 式正解

- 先证明当前 decision window，再解释仪表盘状态。
- 仪表盘只是治理 implementation 的投影，不是判断的起点。

### 改写路径

1. 宿主状态卡固定显示 observed window 与 continuation policy。
2. 任何“绿了”结论都必须回答当前还能改变什么判断。
3. 缺 decision window 的 dashboard 一律视为局部真相。

## 2. 只看审批结束 vs control arbitration truth

### 坏解法

- 审批一旦结束，评审与交接就默认治理 implementation 已经完成，不再追问 winner source、loser cancel、request / response race 与等待终止路径。

### 为什么坏

- 审批结束不等于仲裁真相成立。
- 如果不知道是谁赢下仲裁、谁被取消、为什么等待结束，审批记录只会退回按钮计数。
- 团队会把治理问题误读成“审批太多/太少”，而不是仲裁顺序失真。

### Claude Code 式正解

- 先验证 arbitration truth，再讨论审批体验。
- ask / accept / reject 是事件表面，winner source 与 cancel path 才是制度真相。

### 改写路径

1. 审批记录固定附 arbitration trace。
2. winner source、loser cancel、waiting time 变成固定列。
3. 任何“审批结束但说不清谁赢了”的情况，都视为 implementation 失真。

## 3. 只看阈值安全 vs Context Usage / blocked state

### 坏解法

- CI 只要看到 token、延迟或上下文占比落在阈值内，就默认治理 implementation 正常，不再检查 blocked state、pending action、message/tool/memory breakdown 与 near-capacity 建议。

### 为什么坏

- 阈值安全只能说明资源表面暂时可接受，不说明当前阻塞来自哪里、是否该继续、是否已经该升级对象。
- 如果 Context Usage 被消费成单一百分比，治理就会重新退回成本看板。
- 省 token 的设计哲学会再次退回“少花一点”。

### Claude Code 式正解

- 让 CI 同时消费成本阈值与 blocked state。
- Context Usage 必须回答当前资源状态、阻塞状态与继续价值。

### 改写路径

1. CI 报告固定并排显示 percentage、breakdown、blocked state、pending action。
2. near-capacity 与 diminishing returns 建议成为固定判读项。
3. 任何“阈值安全但解释不了为什么还在卡住”的情况，都视为 implementation 失真。

## 4. 只看回退开关存在 vs rollback object / object-upgrade gate

### 坏解法

- 宿主、评审或交接只要看到有 rollback 开关、有手工兜底，就默认治理 implementation 足够安全，不再检查 rollback object 是谁、object-upgrade gate 是否已经触发却没执行。

### 为什么坏

- “能回退”如果不绑定对象，就会退回拍脑袋回退。
- “还能继续”如果不先过 object-upgrade gate，就会把继续对话误当成默认正确动作。
- 治理 implementation 会重新退回事后补救，而不是事前定界。

### Claude Code 式正解

- 先定义 rollback object 与 object-upgrade 条件，再决定继续还是回退。
- 回退开关是执行动作，不是制度真相本身。

### 改写路径

1. 所有治理交接都强制写 rollback object。
2. object_upgrade_rule 触发后未执行视为硬失真。
3. 任何“先继续再说”的默认策略都要被显式标红。

## 5. 分角色各自打勾 vs shared governance implementation object

### 坏解法

- 宿主仪表盘完整、CI 阈值通过、评审审批结束、交接写了回退开关，团队就默认四类角色已经共享同一套治理 implementation。

### 为什么坏

- 这四项都可能局部正确，却仍然没有共享同一治理对象、同一判断窗口、同一回退边界。
- 每个角色都像在按手册做事，但整个系统已经退回不同 dashboard 的互相点头。
- 安全与省 token 的统一定价秩序会再次断成多条局部规则。

### Claude Code 式正解

- 所有角色先共享同一治理 implementation object：
  - current object
  - current state
  - decision window
  - control arbitration truth
  - failure semantics
  - rollback object
  - object-upgrade rule

### 改写路径

1. 为治理 implementation 固定 shared header。
2. 宿主、CI、评审、交接都先消费这一 header。
3. 任何 role-specific dashboard 都不得替代 shared header。

## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是 decision window，还是只是在看仪表盘有没有转绿。
2. 审批结束是否真的等于仲裁真相已经成立。
3. Context Usage 现在回答的是资源判断，还是只是一张成本曲线。
4. rollback object 与 object-upgrade gate 是否已经比“继续一下试试”更先被定义。
5. 我是在共享同一套治理 implementation 真相，还是在共享几份局部 dashboard。
