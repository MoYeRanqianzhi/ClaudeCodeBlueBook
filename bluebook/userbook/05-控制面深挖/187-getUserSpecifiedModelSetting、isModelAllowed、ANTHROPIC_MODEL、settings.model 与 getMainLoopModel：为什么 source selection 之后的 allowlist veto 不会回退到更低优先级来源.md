# `getUserSpecifiedModelSetting`、`isModelAllowed`、`ANTHROPIC_MODEL`、`settings.model` 与 `getMainLoopModel`：为什么 source selection 之后的 allowlist veto 不会回退到更低优先级来源

## 用户目标

184 已经把 model 线里的 authority order 拆成：

- persisted preference
- live override
- resumed-agent fallback

185 又把 startup source family 拆成：

- ambient env preference
- saved setting
- agent bootstrap source
- live launch override

但如果正文停在这里，读者还是很容易把 `getUserSpecifiedModelSetting()` 写成一条过度平滑的 fallback ladder：

- override 不行就退 env
- env 不行就退 settings
- settings 不行就再退 default

这句还不稳。

从当前源码看，这里至少还要继续拆开两层不同对象：

1. source selection
2. allowlist admission

如果这两层不先拆开，后面就会把：

- `getMainLoopModelOverride()`
- `ANTHROPIC_MODEL`
- `settings.model`
- `isModelAllowed(...)`
- `getDefaultMainLoopModel()`

重新压成一句模糊的“模型优先级回退链”。

## 第一性原理

更稳的提问不是：

- “系统选 model 时是不是会一路回退到下一个来源？”

而是先问六个更底层的问题：

1. 当前逻辑是在先挑一个来源候选，还是在同时遍历所有来源直到找到可用项？
2. allowlist 检查是在判断“这个来源应不应该参与”，还是在判断“当前挑出来的字符串能不能被接纳”？
3. allowlist 拒绝之后，代码会不会重新打开低优先级来源？
4. 当前返回的是“另一个用户指定模型”，还是“没有用户指定模型”？
5. `getMainLoopModel()` 是在重跑 source ladder，还是只消费 `getUserSpecifiedModelSetting()` 的返回值？
6. 我现在分析的是 authority order，还是 source selection 与 admission 的阶段错位？

只要这六轴不先拆开，后面就会把：

- source precedence
- allowlist veto
- built-in default

混成一张“自动回退表”。

## 第一层：`getUserSpecifiedModelSetting()` 先做 source selection，不是 while-loop 式 fallback

`model.ts` 里的 `getUserSpecifiedModelSetting()` 逻辑非常硬：

- 先看 `getMainLoopModelOverride()`
- 没有 override 才读 `process.env.ANTHROPIC_MODEL || settings.model || undefined`

这说明 source selection 回答的问题首先是：

- 在 override / env / settings 里，哪一个候选字符串先活下来

它不是在回答：

- 这些来源会不会被逐个试到“找到一个允许的为止”

更准确地说：

- 这一步只保留一个 authority candidate
- 不是 source-by-source retry

所以不能把这段写成：

- “先试 override，失败再试 env，再失败再试 settings”

因为代码在 allowlist 检查之前，
根本没有保留多候选集合。

## 第二层：`isModelAllowed(...)` 是 source-blind veto，不是低优先级来源的 reopen gate

在 source selection 之后，
`getUserSpecifiedModelSetting()` 才做：

- `if (specifiedModel && !isModelAllowed(specifiedModel)) return undefined`

而 `modelAllowlist.ts` 的 `isModelAllowed(model)` 只回答：

- 这个 model 字符串是否被 `availableModels` 接纳

它不回答：

- 这个字符串来自 override、env 还是 settings
- 如果它被拒绝，是否应改试下一层来源

更准确地说：

- 这是 source-blind admission veto
- 不是 reopen lower-source gate

所以如果当前活下来的高优先级候选被拒绝，
代码不会自动重新问：

- “那我们现在去看看 env / settings 里还有没有别的”

## 第三层：被拒绝的高优先级候选会把下游送到 `undefined`，而不是低优先级来源

一旦 `isModelAllowed(specifiedModel)` 返回 `false`，
`getUserSpecifiedModelSetting()` 直接：

- `return undefined`

这点很关键，因为这里返回的不是：

- 下一个来源的 model

而是：

- 没有 user-specified model

这说明更准确的理解不是：

- allowlist rejection 只是让系统继续往下一级来源回退

而是：

- allowlist rejection 直接终止了当前 user-specified candidate 链

也就是说，
一个被拒绝的高优先级候选会遮蔽低优先级来源，
而不是把它们重新放出来。

## 第四层：`getMainLoopModel()` 消费的是“有无 user model”，不是“再跑一遍低优先级来源”

`getMainLoopModel()` 的逻辑也很硬：

- 先拿 `getUserSpecifiedModelSetting()`
- 若结果既不是 `undefined` 也不是 `null`
  才 `parseUserSpecifiedModel(model)`
- 否则直接 `getDefaultMainLoopModel()`

这说明 `getMainLoopModel()` 回答的问题不是：

- “如果上游候选没过 allowlist，那我们再去试 env / settings”

而是：

- “现在还有没有一个有效的 user-specified model；如果没有，就走 built-in default”

所以更准确的结论不是：

- 被 veto 的 env / override 候选会自然回退到 settings

而是：

- 被 veto 的 candidate 会让下游直接落入 default 路径

## 第五层：`/model` 和 `validateModel()` 的显式报错，说明它们属于另一种 user-facing contract

`commands/model/model.tsx` 和 `validateModel.ts` 都会在 allowlist 不通过时给出显式错误：

- `/model` 会直接告诉用户组织限制了该 model
- `validateModel()` 也会返回显式 invalid 结果

这说明这里还要再拆一层：

1. user-facing validation contract
2. getter-time silent veto contract

前者回答的是：

- 用户显式输入了一个 model，系统该怎么报错

后者回答的是：

- 内部 getter 在读取当前 candidate 时，若 admission 不通过，该向下游交付什么

所以不能把两者写成同一种“allowlist 拒绝行为”。

更准确地说：

- `/model` / `validateModel()` 负责显式拒绝
- `getUserSpecifiedModelSetting()` 负责 silent veto 后交出 `undefined`

`/config` 里的 `model` 写入也复用了同一类显式校验合同：

- `supportedSettings.model.validateOnWrite = validateModel(...)`

这进一步说明：

- write-time surfaces 更像 explicit validation
- getter-time 读路径更像 silent admission veto

## 第六层：resume / agent 路径在这页里只能算 upstream producer，不能重新吞掉主句

`sessionRestore.ts` 确实会在某些条件下：

- `setMainLoopModelOverride(parseUserSpecifiedModel(resumedAgent.model))`

但在 187 这一页里，它回答的问题只该是：

- 谁能在 admission 之前生产 candidate

它不该重新变成正文中心。

因为一旦 candidate 已经写进 override slot，
后续仍然会撞上同一个 getter-time allowlist veto 语义：

- 先选中这个 candidate
- 再统一交给 `isModelAllowed(...)`

所以 resume / agent 在这页里只是：

- candidate producer

不是：

- 另一套独立的 allowlist 合同

## 第七层：因此这页真正要保护的不是“优先级”，而是“阶段错位”

到这里更稳的写法已经不是：

- model 选择是一条平滑回退链

而应该明确拆成：

1. source selection
   先保留一个 candidate
2. allowlist admission
   对这个 candidate 做 source-blind veto
3. getter result
   veto 后交出 `undefined`
4. main loop fallback
   `getMainLoopModel()` 直接走 built-in default

所以更准确的结论不是：

- 高优先级来源失效后，系统会自然回退到更低来源

而是：

- 高优先级 candidate 一旦在 admission 阶段被 veto，
  低优先级来源不会被 reopen

## 第八层：为什么这页不是 184 或 185 的附录

184 讲的是：

- persisted preference
- live override
- resumed-agent fallback

也就是 authority order。

185 讲的是：

- env
- settings
- agent bootstrap
- launch override

也就是 source family。

187 这一页更窄地关心的是：

- candidate 选出来之后
- allowlist veto 会怎样改变下游语义

所以三页虽然共享：

- `getUserSpecifiedModelSetting()`
- `settings.model`
- override

但回答的问题不同：

- 184 问谁说了算
- 185 问这些值原本来自哪一类来源
- 187 问选中候选之后，allowlist veto 为什么不会重新打开低优先级来源

## 稳定面与灰度面

本页只保护稳定不变量：

- `getUserSpecifiedModelSetting()` 是 source selection 再 admission veto 的两阶段路径
- `isModelAllowed(...)` 是 source-blind veto
- veto 后交给下游的是 `undefined`，不是 lower-source fallback
- `getMainLoopModel()` 在这种情况下直接走 built-in default

本页刻意不展开的灰度层包括：

- allowlist 的 family alias 细则
- provider / alias 的全部解析细节
- `/model` 的全部 UX 分支
- resume / agent 的完整 producer 家族

这些都相关，但不属于本页的 hard sentence。

## 苏格拉底式自审

### 问：为什么一定要把 `isModelAllowed(...)` 单独拉成 admission，而不是继续放在“优先级链”里写？

答：因为只要不把 admission 单列，读者就会默认高优先级失败后还能回退下一来源；而当前代码根本没有 reopen lower-source 的逻辑。

### 问：为什么 `/model` 的显式报错不能当作这页的中心？

答：因为那会把主语从 getter-time semantics 换成 user-facing validation UX，正文就会偏离真正新增的句子：silent veto 后交给下游的是 `undefined`，不是 lower-source fallback。

### 问：为什么 resume / agent 不能在这页里重新变成主角？

答：因为它们只决定 candidate 从哪来，不决定 veto 之后会不会 reopen 低优先级来源；把它们抬成主角，就又会回卷到 184 / 185。
