# 如何把统一定价治理落成控制面实现：authority source、decision window、Context Usage与rollback object

这一章不再解释安全与省 token 为什么同构，而是把 Claude Code 式统一定价治理压成一张可实现的控制面手册。

它主要回答五个问题：

1. 为什么真正成熟的治理系统不是几层审批，而是 authority source、decision window、Context Usage、continuation gate 与 rollback object 的同一判断链。
2. 怎样把动作、能力、上下文与时间统一写成同一治理控制面。
3. 为什么 host、SDK、session metadata 与 headless 路径必须围绕同一对象同步，而不能各自猜状态。
4. 怎样用苏格拉底式追问避免把治理实现重新退回 modal、仪表盘与“再来一轮看看”。
5. 怎样把 Claude Code 的统一定价方法迁移到自己的 Agent Runtime，而不误抄某条局部规则。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-260`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:464-519`
- `claude-code-source-code/src/cli/structuredIO.ts:149-657`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`

这些锚点共同说明：

- Claude Code 的治理控制面，并不是“权限 + token 条”的并列实现，而是对边界、窗口、继续资格与回退对象的统一编排。

## 1. 第一性原理

更成熟的治理实现，不是：

- 先把东西都暴露给模型，再补审批和 stop 逻辑

而是：

1. 先决定谁有权改边界。
2. 先决定当前判断围绕哪一个 governance object 成立。
3. 先决定动作、能力、上下文与时间各自怎样被定价。
4. 先决定当前继续是否仍有决策增益。
5. 先决定失败时回退到哪个对象。

所以更准确的说法不是：

- 安全系统 + 省 token 系统

而是：

- 治理控制面

## 2. 第一步：先固定 authority source

Claude Code 真正先固定的不是弹窗，而是 mode、settings、policy、host sync 与 session metadata 的权威入口。

更硬一点说，这一步不只是在固定入口，而是在固定 `source lattice`：

1. 哪些 source 只是 provenance
2. 哪些 source 真正拥有 higher-order authority
3. 哪些 source 只能自我收缩，不能自我扩权

构建动作：

1. 先区分 internal mode 与 external mode。
2. 先给所有 mode 变更定义唯一 choke point。
3. 先决定宿主与 SDK 只消费哪些正式权威状态。
4. 先决定哪些 rules、hooks、sandbox、plugin / MCP 能力只能由更高 authority source 覆写。

不要做的事：

1. 不要让 host、CLI、bridge 各自宣布 mode。
2. 不要把磁盘 settings 直接当成 effective settings。
3. 不要让 pending action 只活在某一个前台通道里。
4. 不要把 `source` 只当作事后 provenance，而不让它决定后续治理对象。

## 3. 第二步：把动作审批写成 typed decision

Claude Code 真正保护的不是审批弹窗，而是正式 decision type 与 reason。

更稳的顺序是：

1. 先做硬拒收与 fast-path。
2. 再决定 ask / allow / deny。
3. 再把结果投影到 UI 或 SDK。
4. 同时处理 duplicate control_response、orphan response 与 cancel path。

构建动作：

1. 先定义 decision type 和 decision reason。
2. 先用 `request_id + tool_use_id` 固定幂等关系。
3. 先定义 headless / background 模式的明确拒收语义。

不要做的事：

1. 不要把“弹窗出现过”当治理完成。
2. 不要把 classifier 当兜底万能安全阀。
3. 不要在没有 typed decision 的情况下直接做 UI 呈现。

## 4. 第三步：把 Context Usage 写成 decision window

真正成熟的 Context Usage，不是只展示 token 百分比，而是解释：

1. 当前哪些 section 在占席位。
2. 当前哪些 tools / memory / agents 在占席位。
3. 当前哪些对象仍未加载。
4. 当前 pending action 与继续边界如何成立。

构建动作：

1. 先把 Context Usage 与当前状态并排消费。
2. 先定义哪些类别变化会触发治理动作。
3. 先把“为什么贵”解释到 section / tool / memory / continuation。
4. 先把 visible set 写成 authority source 的下游，而不是独立开关。

不要做的事：

1. 不要把 Context Usage 做成独立仪表盘。
2. 不要把 token 条误当 decision window。
3. 不要在没有窗口解释的情况下直接 compact 或继续。

## 5. 第四步：把 continuation 写成时间定价

Claude Code 把 continuation 理解成正式时间资产，而不是默认免费延长。

更稳的实现是：

1. 先定义 continuation counter 与 delta。
2. 先定义 diminishing returns 条件。
3. 先定义何时 stop、何时 continue、何时升级对象。
4. 先把 pending action、headless deny 与 object upgrade 纳入同一判断链。

构建动作：

1. 先把 continue 写成正式 gate，而不是默认行为。
2. 先定义“继续资格”而不是“还能继续”。
3. 先定义什么时候必须从当前对象退出。
4. 先把 durable assets 与 transient authority 分开。

不要做的事：

1. 不要把 continue 理解成“再来一轮看看”。
2. 不要只看 token 剩余量，不看决策增益。
3. 不要让 headless 路径在无审批条件下继续免费运行。
4. 不要把旧 mode、旧 grant、旧可见集整包续租进 resume。

## 6. 第五步：把 rollback object 写回治理对象

治理成熟与否，关键看失败时是不是还能围绕对象回退。

构建动作：

1. 先为每条 governance path 定义 rollback object。
2. 先把 rollback object 和 next action 写进 session metadata 或 handoff 对象。
3. 先把文件/commit 回退降级为执行动作，而不是治理语义。
4. 先明确 rollback object 里哪些是 durable assets，哪些只是一次性 authority 痕迹。

不要做的事：

1. 不要失败后只谈回退文件或重试次数。
2. 不要把 rewind、cancel、resume 当成治理对象本身。
3. 不要让交接包只剩状态摘要，不剩 rollback object。

## 7. 六步最小实现顺序

如果要把上面的原则压成一张控制面 builder 卡，顺序可以固定成：

1. `authority source`
   - 谁能改边界，谁只消费投影；source 是治理主键
2. `typed decision`
   - deny / ask / allow / reason
3. `decision window`
   - Context Usage + state + pending action
4. `visibility pricing`
   - 哪些能力先隐藏、后出现、按需出现
5. `continuation gate`
   - 继续是否仍有决策增益；resume 只恢复 durable assets
6. `rollback object`
   - 失败时回退到哪个治理对象

## 8. 苏格拉底式检查清单

在你准备继续补一层安全或压缩机制前，先问自己：

1. 我治理的是 authority source，还是只治理了界面形式。
2. 当前审批是否已经是 typed decision，而不是交互事件。
3. Context Usage 是否真的在解释 decision window。
4. continuation 是正式 gate，还是默认继续。
5. 失败时我能否立刻指出 rollback object。
6. source 是不是治理主键，还是只是 provenance 标签。
7. resume 恢复的是 durable assets，还是 transient authority 也被一起续租。

## 9. 一句话总结

真正成熟的统一定价治理，实现上不是多几条规则，而是把 authority source、decision window、Context Usage、continuation gate 与 rollback object 写成同一条控制面判断链。
