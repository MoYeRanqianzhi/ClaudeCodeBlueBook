# 治理控制面：PolicySettings、typed decision、deferred visibility、Context Usage与continuation pricing

这一章回答五个问题：

1. 为什么 Claude Code 的安全设计与省 token 设计最终必须回到同一张治理控制面。
2. 为什么 `PolicySettings`、typed decision、能力可见性、Context Usage 与 continuation window 共同构成一套连续的治理顺序。
3. 为什么宿主不是答案流接收器，而是治理控制面的共同参与者。
4. 为什么没有这层控制面，安全会退回 modal，省 token 会退回压缩技巧，继续语义会退回默认延长。
5. 这对 Agent Runtime 设计者意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-240`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:308-519`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:1-260`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/utils/contextSuggestions.ts:1-220`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`

## 1. 先说结论

Claude Code 真正成熟的治理，不是分别拥有：

1. 一套安全系统
2. 一套 token 优化系统
3. 一套宿主控制协议

而是已经把这些东西压成一张连续控制面：

1. 谁能写边界
2. 谁能宣布决定
3. 模型先看见什么
4. 当前成本如何被解释
5. 什么时候该停止当前对象

所以它更接近：

- governance control plane

而不只是：

- 预算器 + 权限系统 + 宿主接口

## 2. `PolicySettings`：控制面先决定谁有资格写边界

`controlSchemas.ts` 里的 `get_settings / apply_flag_settings` 明确说明：

1. settings 有 `effective`
2. settings 有按来源分层的 `sources`
3. settings 还有真正发送给模型的 `applied`

这意味着治理控制面的第一层不是：

- 读一个配置文件

而是：

- 先明确谁能写边界、边界当前怎样生效、运行时最终会使用哪个值

所以 settings 不只是偏好层，而是：

- authority surface 的写入口

更硬一点说，这里的 `source` 不是 provenance 附件，而是治理主键。

更稳的实现顺序应直接写成：

1. `source lattice`
   - 先定义哪些 source 拥有 higher-order authority
2. `managed-only switches`
   - 再定义哪些 rules / hooks / sandbox / plugin / MCP 能力只允许被更高 authority source 覆写
3. `derived pricing`
   - 最后才让动作、可见性、上下文与 continuation 去消费这些 source-tagged rules

## 3. typed decision：控制面再决定谁来宣布允许 / 拒绝

`permissions.ts` 说明：

1. `deny / ask / allow` 是正式动作结果
2. decision reason 会显式记录 mode、classifier、async-agent 等来源
3. auto mode 不是“默认允许”，而是继续先走治理顺序

这意味着治理控制面的第二层不是：

- 审批 UI 长什么样

而是：

- 当前动作被谁以什么理由判定

同样重要的是，`acceptEdits` fast-path、allowlist、classifier、denial limit 与 headless reject 都在一条顺序里运行。

所以 typed decision 真正保护的是：

- 同一动作不会因为宿主、模式、背景执行、classifier 或失败语义不同而长出第二套主权

所以 typed decision 也不是凭空成立的。

它更像：

- source lattice 派生出的动作裁决层

## 4. visibility pricing：控制面还要决定模型先看见什么

Claude Code 并不把“系统能做什么”等同于“模型现在就能看见什么”。

虽然具体延迟暴露机制散落在 tools / tool search / MCP delta 一侧，但治理上它们服务的是同一问题：

- 当前应该暴露哪一个最小可见世界

所以治理控制面的第三层不是：

- 能力表

而是：

- visibility pricing

也就是：

1. 哪些能力默认可见
2. 哪些能力 deferred
3. 哪些能力通过搜索或 delta 回填

而这层可见性价格也不是独立主权。

它更准确的角色是：

- `authority source` 先筛世界
- visibility 只负责按价发放席位

一旦没有这一层，安全与省 token 就会重新分裂：

1. 安全退回“先全给再拦”
2. token 退回“先全塞再压”

## 5. Context Usage：控制面必须解释当前成本与当前窗口

`controlSchemas.ts` 与 `contextSuggestions.ts` 一起说明：

1. Context Usage 不是单一百分比
2. 它按 categories、memory files、mcp tools、deferred builtin tools、grid rows 解释当前席位占用
3. 它还能进一步生成 action-oriented suggestions

这意味着治理控制面的第四层不是：

- 成本统计

而是：

- decision window observability

它回答的不是：

- 现在用了多少 token

而是：

- 当前为什么这么贵，下一步最该削减哪一类对象

## 6. continuation window：控制面最后决定时间是否还值得支付

`tokenBudget.ts` 说明：

1. continuation 有独立计数器
2. continuation 会比较 delta tokens
3. continuation 会判断 diminishing returns
4. continuation 最后会给出 `continue` 或 `stop`

这意味着治理控制面的第五层不是：

- 会话默认延长

而是：

- continuation pricing

也就是说，时间也是一种被正式定价的资源。

而且 continuation 也不是把所有旧授权一并续租。

更稳的写法应当承认：

1. durable assets
   - transcript、replacement state、仍被当前 authority chain 承认的 continuation objects
2. transient authority
   - mode、grants、可见集、一次性判断窗口

前者可以恢复，后者必须重审。

一旦当前对象已经进入 diminishing returns，系统不应继续默认延长，而应：

1. 停止
2. 升级对象
3. 或重新选择 worktree / compact / task

## 7. 宿主为什么是控制面的共同参与者

`controlSchemas.ts` 与 `onChangeAppState.ts` 一起说明：

1. 宿主可以读 settings、读 Context Usage、仲裁 `can_use_tool`
2. mode 的外化与同步必须通过权威 diff 点
3. 宿主不该自己猜 mode、pending action、当前预算窗口

所以宿主真正参与的是：

1. 控制面消费
2. 控制面仲裁
3. 控制面外化

而不是：

- 一个把回答显示出来的外壳

更硬一点说：

- host 只消费 runtime 已外化的 authority/status
- host 不配自己回放事件去拼 `mode / pending action / context truth`

## 8. 为什么这五层必须合在一起

`PolicySettings` 决定：

- 谁能写边界

typed decision 决定：

- 谁能宣布当前动作结果

visibility pricing 决定：

- 模型先看见什么

Context Usage 决定：

- 当前成本如何被解释

continuation window 决定：

- 当前对象还能继续多久

如果把这五层再压成更短的实现链，可以写成：

1. `source lattice`
2. `managed-only switches`
3. `typed decision`
4. `visibility pricing`
5. `decision window`
6. `continuation requalification`

五者合在一起，才构成 Claude Code 更深一层的统一结论：

- 安全与省 token 其实是在治理同一张控制面

## 9. 一句话总结

Claude Code 的治理成熟度，不在于它有多少规则，而在于它已经把 `PolicySettings`、typed decision、visibility pricing、Context Usage 与 continuation window 接成了同一张 governance control plane。
