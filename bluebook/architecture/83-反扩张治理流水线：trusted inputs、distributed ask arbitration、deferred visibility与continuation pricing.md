# 反扩张治理流水线：trusted inputs、distributed ask arbitration、deferred visibility与continuation pricing

这一章回答五个问题：

1. 为什么 Claude Code 的安全设计与省 Token 设计其实在压制同一个敌人。
2. 为什么 `trusted inputs`、权限决策、能力可见性、结果外置与 continuation 必须被放在同一条流水线上。
3. 为什么 permission 在这里更像 typed transaction，而不是一个弹窗。
4. 为什么 fail-open / fail-closed 不该按情绪区分，而应按资产类型区分。
5. 这对 Agent runtime 设计者意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/managedEnv.ts:93-220`
- `claude-code-source-code/src/utils/settings/settings.ts:319-520`
- `claude-code-source-code/src/utils/settings/pluginOnlyPolicy.ts:1-123`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:472-716`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1158-1318`
- `claude-code-source-code/src/utils/permissions/PermissionMode.ts:42-90`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:44-380`
- `claude-code-source-code/src/cli/structuredIO.ts:149-657`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:178-260`
- `claude-code-source-code/src/utils/toolSearch.ts:385-704`
- `claude-code-source-code/src/utils/toolResultStorage.ts:740-860`
- `claude-code-source-code/src/utils/analyzeContext.ts:1043-1382`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:433-698`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:413-610`

这些锚点共同说明：

- Claude Code 的治理控制面不是分别在做安全、成本、继续与观测，而是在统一反对模型可达世界的无序扩张。

## 1. 先说结论

Claude Code 更深的治理律，不是：

- 多几道检查
- 少花一点 token

而是三种反扩张动作：

1. `Narrow`
   - 现在就收窄动作、能力与输入来源
2. `Later`
   - 没必要立即可见的能力与事实延后暴露
3. `Outside`
   - 体积大、波动高、只需引用的对象迁出主 prompt

所以安全与省 Token 之所以同构，不是因为它们都在“限制”，而是因为它们都在决定：

- 什么东西值不值得进入当前世界

## 2. 第一性原理：trusted inputs 先于 trust UI

Claude Code 的一个高级点，是它先问：

- 谁配定义边界

而不是先问：

- 谁点了允许

`managedEnv.ts`、`settings.ts` 与 `pluginOnlyPolicy.ts` 共同说明：

1. `userSettings`、`flagSettings`、`policySettings` 可以在 trust 之前影响环境
2. project/local settings 因为活在仓库里，反而不能免费扩张边界
3. `policySettings` 还带着 first-source-wins 与 admin-trusted 的不对称规则

这背后的制度判断很硬：

- 低信任来源可以自我收缩，但不能自我扩权

所以真正成熟的安全观不是：

- 工具执行前再多审一次

而是：

- 什么输入源有资格改变运行时边界

## 3. Permission 是 distributed transaction，不是 modal

`permissionSetup.ts`、`permissions.ts`、`interactiveHandler.ts`、`structuredIO.ts` 与 SDK control schema 共同揭示：

- 一个 `ask` 不是等人点按钮，而是一场分布式仲裁事务

同一请求会被多方同时消费：

1. 本地 TUI
2. SDK host
3. bridge / CCR
4. channel relay
5. hooks
6. classifier

然后围绕：

- `request_id`
- `tool_use_id`
- duplicate suppression
- stale prompt teardown

形成一条 typed decision pipeline。

这条流水线真正保护的是：

1. 决策只生效一次
2. 旧 ask 不能在新世界里复活
3. 自动化不能跳过自己的 guardrail

所以 Claude Code 的 permission 成熟度，不在 modal，而在事务性。

## 4. 能力可见性本身就是价格

`toolSearch.ts` 与 deferred tools 机制说明：

- “工具存在”与“工具当前可见”是两件不同的事

Claude Code 不认为所有能力都该免费进入当前请求。

它更像在做四步筛选：

1. provider / path 是否支持 `tool_reference`
2. 当前模型有没有必要知道这组 schema
3. schema 体积值不值得占据上下文席位
4. compaction 后这些可见性资产是否需要继续携带

所以它真正管理的不是：

- 工具目录

而是：

- 模型此刻可达世界的熵

这也是为什么 deferred visibility 同时是：

- 安全设计
- 省 Token 设计

## 5. Externalization：把高体积对象迁出主席位

`toolResultStorage.ts` 的价值不在“支持把结果存盘”，而在：

- 主上下文里的席位被当作昂贵资产对待

Claude Code 的正式做法是：

1. 大结果被持久化
2. 当前回合只留 preview
3. 一旦某个 `tool_use_id` 被替换，后续必须按相同字节重放

这说明结果外置不是 opportunistic 优化，而是：

- runtime boundary asset

系统在这里保护的不是：

- 更短一点

而是：

- stable prefix 不被高体积、高波动对象反复击穿

## 6. Context Usage 与 Continuation Pricing：时间也要被定价

`analyzeContext.ts`、`tokenBudget.ts` 与 `query.ts` 共同说明，Claude Code 并不把 continue 当默认免费选项。

它更像在持续重问四件事：

1. 当前对象是什么
2. 当前成本来自哪些扩张
3. 当前 decision window 还剩下什么正式条件
4. 当前 continuation 还有没有边际收益

因此 continuation 在这里不是 granted，而是 rented。

真正成熟的省 Token 不是：

- 字数更短

而是：

- 时间不被免费烧掉

这也解释了为什么：

- recovery continuation
- policy continuation
- diminishing returns
- reserved headroom

要被写进同一条预算链。

## 7. Fail-Open / Fail-Closed 必须按资产类型区分

Claude Code 的失败语义成熟点，不在于“永远更保守”，而在于：

- 不同资产有不同失败语义

从锚点可以压出一条更稳定的判断：

1. 动作授权、network ask、危险 managed-setting delta
   - 应偏向 fail-closed 或 deny
2. remote managed settings fetch、部分 policy cache 缺失
   - 可选择 fail-open 或 stale-degrade

原因不是系统摇摆，而是它先区分：

- 当前保护的是 sovereignty，还是 availability

所以 Claude Code 的失败语义，是资产类型化的，而不是情绪化的。

## 8. 为什么这解释了安全与省 Token 的统一性

把这些动作放在一起看，就会发现 Claude Code 真正在统一定价四个空间：

1. 动作空间
2. 权威空间
3. 上下文空间
4. 时间空间

这也是为什么：

- 安全
- Token 经济
- prompt 稳定性
- observability

最后会不断在同一条治理控制面上相遇。

它们都在持续回答：

- 当前什么配进入当前世界

## 9. 对 Agent Runtime 设计者的直接启发

如果你想复制 Claude Code 的治理成熟度，先别急着复制：

- 一个更复杂的 permission dialog

优先应该复制的是：

1. trusted input admission
2. typed permission transaction
3. deferred visibility
4. deterministic externalization
5. continuation pricing
6. asset-typed failure semantics

如果这六件事不先成立，再细的安全 UI 和再强的 compact 都只是在局部补丁。

## 10. 苏格拉底式追问

在你准备宣布“我已经理解了 Claude Code 的安全与省 Token 设计”前，先问自己：

1. 我解释的是更多限制，还是反扩张秩序。
2. 谁能定义边界；低信任来源有没有机会偷偷扩权。
3. permission 在我这里是弹窗，还是一次 typed transaction。
4. 工具存在与工具当前可见，我有没有分开。
5. 高体积对象是继续占据主 prompt，还是已经被迁出主席位。
6. continuation 在我这里是默认继续，还是被正式定价。
7. fail-open / fail-closed 的选择，是按资产类型，还是按团队焦虑。

## 11. 一句话总结

Claude Code 的安全设计与省 Token 设计，本质上是同一条反扩张治理流水线：先决定谁能扩边界，再决定什么值不值得进入当前世界，最后决定这笔世界成本还值不值得继续支付。
