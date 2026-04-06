# 如何把安全与省Token写成治理控制面：typed decision、渐进暴露、Context Usage与继续预算

这一章不再解释安全为什么重要，而是把 Claude Code 式安全/省 token 设计压成一张治理控制面手册。

它主要回答五个问题：

1. 为什么安全设计与省 token 设计本质上是同一套治理顺序。
2. 怎样把动作审批、能力可见性、上下文席位与 continuation 写成统一控制面。
3. 为什么 host control、settings、MCP 与 Context Usage 必须一起看，而不能拆成独立 API。
4. 怎样用苏格拉底式追问避免把治理重新退回 modal、指标或压缩技巧。
5. 怎样把 Claude Code 的治理方法迁移到自己的 Agent Runtime，而不误抄某个单点策略。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-240`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:308-519`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-520`

这些锚点共同说明：

- Claude Code 的安全与省 token，不是两套分离的优化，而是同一张治理控制面在动作、能力、上下文与时间四个方向上的统一定价。

## 1. 第一性原理

更成熟的治理系统，不是：

- 先把东西都暴露给模型，再补审批、压缩和 stop 逻辑

而是：

1. 先定义谁能改边界。
2. 先定义哪些动作必须协商。
3. 先定义哪些能力必须延后出现。
4. 先定义哪些结果必须外置。
5. 先定义什么时候不该继续当前对象。

所以更准确的说法不是：

- 安全 + 省 token

而是：

- 治理控制面

## 2. 第一步：先固定 authority surface

治理最先要固定的，不是规则条目，而是权威入口：

1. settings / policy
2. permission mode
3. tool pool / visibility
4. MCP scope / status
5. Context Usage / decision window

构建动作：

1. 先定义哪些输入能改边界。
2. 先定义 host 只消费哪些权威状态，而不能自己猜。
3. 先定义 external mode、internal mode、consumer subset 的关系。

不要做的事：

1. 不要把磁盘 settings 直接当 effective settings。
2. 不要让宿主自己拼 mode、tool pool 或 pending_action。
3. 不要让 MCP、settings、permissions 各自产生一套真相。

## 3. 第二步：把动作审批写成 typed decision

Claude Code 真正保护的不是弹窗，而是正式动作语义：

1. `deny`
2. `ask`
3. `allow`
4. classifier / mode / async-agent 等拒收理由

更稳的顺序是：

1. 先做最硬拒收。
2. 再做需要协商的 ask。
3. 再做 mode 与 fast-path。
4. 最后才交给用户界面呈现。

构建动作：

1. 先定义 decision type。
2. 先定义 decision reason。
3. 先定义 `request_id + tool_use_id` 的幂等关系。
4. 先定义 cancel、orphan、late duplicate 如何被拒绝。

不要做的事：

1. 不要把审批写成纯 UI 行为。
2. 不要把 headless / background 模式写成“没有弹窗就默认允许”。
3. 不要把 classifier 当成最后一跳万能安全阀。

## 4. 第三步：把能力暴露写成渐进可见性

Claude Code 不是先把所有能力都给模型，再要求模型克制；它先限制模型能看见的世界。

更稳的做法是：

1. 先给稳定的 builtin surface。
2. 再给 deferred visibility。
3. 再给 ToolSearch / discovered set。
4. 再给 MCP delta / late attachment。

构建动作：

1. 先定义默认可见工具子集。
2. 先定义哪些能力通过搜索出现，而不是预先声明。
3. 先定义哪些高波动说明要走 delta，不进 stable prefix。

不要做的事：

1. 不要把“系统能做”直接写成“模型立刻可见”。
2. 不要把 MCP 连上就立即重写整段 system prompt。
3. 不要把可见性控制误写成产品灰度开关。

## 5. 第四步：把 Context Usage 写成 decision window

真正成熟的预算观测，不是只给一个 token 百分比。

Claude Code 更接近在做：

1. 当前哪些 section 占了席位
2. 当前哪些 tools 占了席位
3. 当前哪些 attachments 占了席位
4. 当前哪些能力还没加载
5. 当前继续是否还有决策增益

构建动作：

1. 先把 Context Usage 与 pending_action 并排消费。
2. 先把观测结果翻译成下一步治理动作。
3. 先把“为什么贵”解释到 prompt / tool / attachment / continuation。

不要做的事：

1. 不要把 Context Usage 写成仪表盘装饰。
2. 不要把 token 条形图当预算真相。
3. 不要在没有 decision window 的情况下直接做 compact 或继续。

## 6. 第五步：把 continuation 写成正式定价

Claude Code 把 continuation 理解成正式的 continuation pricing，而不是默认免费延长。

更稳的顺序是：

1. 先判断 `decision window` 是否仍成立。
2. 先判断当前对象是否还值得继续。
3. 先判断继续是否已进入 diminishing returns。
4. 先判断是 `stop / continue / object upgrade / human-fallback / cleanup-before-resume` 哪一种 verdict，而不是继续聊天。

构建动作：

1. 先定义 continuation counter / delta / diminishing rule。
2. 先定义 stop / continue / object upgrade / human-fallback / cleanup-before-resume 的分叉条件。
3. 先定义何时必须切换到 task / worktree / compact。
4. 先把 `rollback object` 与 durable/transient split 写成继续资格之前的前置对象，而不是收尾描述。

不要做的事：

1. 不要把 continuation 理解成“再来一轮”。
2. 不要把 stop 写成“模型自己收尾”。
3. 不要在对象早该升级时继续消耗时间预算。
4. 不要把 compact 当成 continuation pricing 的别名；compact 只是下游执行策略，不是前门 verdict。

## 7. 六步最小治理顺序

如果要把上面的原则压成一张治理 builder 卡，顺序可以固定成：

1. `authority`
   - settings / policy / mode / subset
2. `typed decision`
   - deny / ask / allow / reason
3. `visibility pricing`
   - deferred / subset / delta
4. `decision window`
   - Context Usage + pending_action + current state
5. `continuation pricing`
   - stop / continue / object upgrade / human-fallback / cleanup-before-resume
6. `outside pricing`
   - externalization / preview / replacement + rollback object + durable-transient cleanup

## 8. 苏格拉底式检查清单

在你准备继续补一层安全或压缩机制前，先问自己：

1. 我治理的是边界，还是只治理了交互形式。
2. 动作审批是否已经是 typed decision，而不是 modal。
3. 模型看见的是当前最小必要世界，还是几乎全量世界。
4. Context Usage 是否真的进入了下一步决策，而不是留在观测层。
5. continuation 是正式 continuation pricing，还是默认免费扩张。
6. mode 面板、审批弹窗、usage 条、compact 技巧里，当前是哪一个 projection 在冒充治理真相。

## 9. 一句话总结

真正成熟的安全与省 token 设计，不是多几条限制或多一层压缩，而是把动作、能力、上下文与时间统一写成同一张治理控制面。
