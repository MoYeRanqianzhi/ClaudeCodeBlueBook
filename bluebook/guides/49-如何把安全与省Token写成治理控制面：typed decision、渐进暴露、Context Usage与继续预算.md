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

## 1. 先固定 builder 的唯一顺序

这张治理 builder 卡现在不再从 “authority surface / typed decision / visibility pricing / outside pricing” 这些近义步骤起笔，而固定从 canonical chain 起笔：

1. `governance key`
2. `externalized truth chain`
3. `typed ask`
4. `decision window`
5. `continuation pricing`
6. `durable-transient cleanup`

`Narrow / Later / Outside` 现在只保留为助记，不再充当第二套对象链。

## 2. 第一步：先固定 governance key

治理最先要固定的，不是规则条目，而是：

- 谁配改边界

构建动作：

1. 先定义 settings、policy、workspace trust、managed settings 谁拥有主键。
2. 先定义 host 只能消费哪些权威状态，而不能自己猜。
3. 先定义哪些边界变更需要先经过主键，再进入后续治理链。

不要做的事：

1. 不要把磁盘 settings 直接当 effective settings。
2. 不要让宿主自己拼 mode、tool pool 或 pending action。
3. 不要让 MCP、settings、permissions 各自产生一套真相。

## 3. 第二步：把 externalized truth chain 写硬

Claude Code 真正保护的不是一个 mode 字段，而是：

- 当前哪些真相被正式外化给宿主消费

构建动作：

1. 先定义 mode、tool visibility、pending action、usage 与 state writeback 的同一 truth chain。
2. 先定义哪些对象只配做 projection，哪些对象配成为 host-facing truth。
3. 先定义外化链如何在 trust、remote、resume、compact 后仍保持一致。

不要做的事：

1. 不要把 token 条或 mode 条当治理真相本体。
2. 不要让 UI 投影反向宣布“系统当前是什么”。
3. 不要把 settings 页面和当前运行时真相混成一层。

## 4. 第三步：把动作审批写成 typed ask

Claude Code 真正保护的不是弹窗，而是正式 ask 语义：

1. `deny`
2. `ask`
3. `allow`
4. classifier / mode / async-agent 等拒收理由

构建动作：

1. 先定义 decision type。
2. 先定义 decision reason。
3. 先定义 `request_id + tool_use_id` 的幂等关系。
4. 先定义 cancel、orphan、late duplicate 如何被拒绝。

不要做的事：

1. 不要把审批写成纯 UI 行为。
2. 不要把 headless / background 模式写成“没有弹窗就默认允许”。
3. 不要把 classifier 当成最后一跳万能安全阀。

## 5. 第四步：把 Context Usage 写成 decision window

真正成熟的预算观测，不是只给一个 token 百分比，而是回答：

- 当前继续还有没有决策增益

构建动作：

1. 先把 `Context Usage` 与 pending action、current object 并排消费。
2. 先把观测结果翻译成下一步治理动作，而不是留在观测层。
3. 先把“为什么贵”解释到 prompt / tools / attachments / continuation。

不要做的事：

1. 不要把 `Context Usage` 写成仪表盘装饰。
2. 不要把 token 条形图当预算真相。
3. 不要在没有 decision window 的情况下直接做 compact 或继续。

## 6. 第五步：把 continuation 写成正式定价

Claude Code 把 continuation 理解成正式的 continuation pricing，而不是默认免费延长。

构建动作：

1. 先判断 `decision window` 是否仍成立。
2. 先判断当前对象是否还值得继续。
3. 先判断继续是否已进入 diminishing returns。
4. 先判断是 `stop / continue / object upgrade / human-fallback / cleanup-before-resume` 哪一种 verdict。

不要做的事：

1. 不要把 continuation 理解成“再来一轮”。
2. 不要把 stop 写成“模型自己收尾”。
3. 不要在对象早该升级时继续消耗时间预算。
4. 不要把 compact 当成 continuation pricing 的别名。

## 7. 第六步：把 durable-transient cleanup 写成结算面

这一步不再叫“outside pricing”或“收尾技巧”，而是明确叫：

- `durable-transient cleanup`

构建动作：

1. 先定义哪些结果必须外置，哪些对象必须退场。
2. 先定义 compact、resume、replacement、preview、rollback object 如何回钉到当前链路。
3. 先定义 durable 与 transient 的分界，避免 stop 后旧对象偷偷复活。

不要做的事：

1. 不要把 cleanup 当成附录。
2. 不要让 stop / resume 留下第二真相。
3. 不要让外置对象重新篡位成当前工作主语。

## 8. `Narrow / Later / Outside` 现在只保留为助记

如果要把六步 builder 和旧助记 crosswalk 对齐，更稳的读法应是：

1. `Narrow`
   - `governance key -> externalized truth chain -> typed ask`
   - 先治理宽度，不让未定价能力先进入世界。
2. `Later`
   - `decision window -> continuation pricing`
   - 先治理时间，只在仍有 `decision gain` 时允许继续。
3. `Outside`
   - `durable-transient cleanup`
   - 先治理位置，把高波动对象迁成可回钉、可拒收、可清算的外部载体。

如果这张 crosswalk 说不清，builder 就还只是“步骤表”，还不是统一治理位置学。

## 9. 用 reject trio 做 builder 验收

这张卡的验收关口现在固定为：

1. `projection usurpation`
   - mode 条、审批弹窗、token 条、usage 仪表盘开始冒充治理真相。
2. `decision-window collapse`
   - `Context Usage` 只剩成本显示，不再决定下一步治理动作。
3. `free-expansion relapse`
   - 全量可见、默认继续、残留复活或无增益自动化重新获得免费资格。

## 10. 苏格拉底式检查清单

在你准备继续补一层安全或压缩机制前，先问自己：

1. 我治理的是边界，还是只治理了交互形式。
2. host 当前消费的是 externalized truth，还是某种 projection。
3. 动作审批是否已经是 typed ask，而不是 modal。
4. `Context Usage` 是否真的进入了下一步决策，而不是留在观测层。
5. continuation 是正式 continuation pricing，还是默认免费扩张。
6. cleanup 是否真的结算了 durable / transient，而不是只换了一个显示面。
7. 当前 failure verdict 是否已经退回 `reject / degrade / halt / cleanup-before-resume / human-fallback`，还是还停在投影替身的口语层。

## 11. 一句话总结

真正成熟的安全与省 token 设计，不是多几条限制或多一层压缩，而是把动作、能力、上下文与时间统一写成 `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup` 这一张治理控制面。
