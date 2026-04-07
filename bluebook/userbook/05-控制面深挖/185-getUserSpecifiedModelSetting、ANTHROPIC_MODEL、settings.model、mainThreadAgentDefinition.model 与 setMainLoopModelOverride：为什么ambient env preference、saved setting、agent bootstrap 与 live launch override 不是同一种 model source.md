# `getUserSpecifiedModelSetting`、`ANTHROPIC_MODEL`、`settings.model`、`mainThreadAgentDefinition.model` 与 `setMainLoopModelOverride`：为什么 ambient env preference、saved setting、agent bootstrap 与 live launch override 不是同一种 model source

## 用户目标

184 已经把 model 线里的主权顺序拆成：

- persisted preference
- live override
- resumed-agent fallback

但如果正文停在这里，读者还是很容易把 startup 这一层重新写平：

- `ANTHROPIC_MODEL` 和 `settings.model` 不都是“用户指定的模型”吗？
- `mainThreadAgentDefinition.model` 不也只是 startup 时的另一个默认值吗？
- 既然最后都会写进 `setMainLoopModelOverride(...)`，那这些来源是不是本来就是同一种 source？
- `setInitialMainLoopModel(...)` 记下来的值，不就是这些来源本体吗？

这句还不稳。

从当前源码看，至少还要继续拆开四个不同的 startup model source family：

1. ambient env preference
2. saved setting
3. agent bootstrap source
4. live launch override

如果这四层不先拆开，后面就会把：

- 环境变量来源
- 设置快照来源
- agent 自带来源
- 启动后实际写入的 runtime register

重新压成一句模糊的“启动时选中的 model”。

## 第一性原理

更稳的提问不是：

- “系统启动时最终用了哪个 model？”

而是先问六个更底层的问题：

1. 当前值在回答“进程环境里偏好什么”，还是“磁盘快照里保存了什么”？
2. 当前值是在描述 agent 自带的 bootstrap 候选，还是已经落进 runtime register 的执行值？
3. 两个来源最后写进同一个 slot，是否就代表它们原本属于同一种 source？
4. 当前读取的是 raw source，还是 precedence 计算后的 snapshot？
5. `undefined`、`null`、resolved string 进入同一个 register 后，fallback 语义是否还一样？
6. 我现在分析的是 startup source family，还是 184 已经处理过的 authority order？

只要这六轴不先拆开，后面就会把：

- env
- settings
- agent bootstrap
- launch override

混成一张“启动 model 来源表”。

## 第一层：`ANTHROPIC_MODEL` 先是 ambient env preference，不是 saved setting

`utils/model/model.ts` 的 `getUserSpecifiedModelSetting()` 只有在 `getMainLoopModelOverride()` 为 `undefined` 时，才去读：

- `process.env.ANTHROPIC_MODEL`
- `settings.model`

这说明 `ANTHROPIC_MODEL` 回答的问题首先是：

- 当前进程环境里有没有一个 ambient model preference

它不是在回答：

- 当前设置文件里保存了什么 model

更准确地说：

- 它来自进程环境
- 不通过 settings merge 写回磁盘
- 可以在不改 settings 文件的情况下直接压过 `settings.model`

所以不能把它写成：

- “另一种形式的设置项”

## 第二层：`settings.model` 先是 merged saved setting snapshot，不是 env shadow

`settings.ts` 里的 `getInitialSettings()` 返回的是当前时刻的 merged settings snapshot。

而且注释明确写了 merge 顺序：

- `userSettings`
- `projectSettings`
- `localSettings`
- `policySettings`

这说明 `settings.model` 回答的问题首先是：

- 当前 settings merge 结果里保存出来的 model 是什么

它不是在回答：

- 当前进程环境变量偏好什么

也不是在回答：

- 当前 runtime register 里已经生效的 model 是什么

因此更准确的理解不是：

- `settings.model` 就是 `ANTHROPIC_MODEL` 的磁盘镜像

而是：

- `settings.model` 是 saved-setting family 的 merged snapshot
- `ANTHROPIC_MODEL` 是 ambient-env family

二者只是在 override 缺席时，恰好共享同一个 reader。

## 第三层：`mainThreadAgentDefinition.model` 先是 agent bootstrap source，不是当前 model 本体

`main.tsx` 在启动时先决定：

- `userSpecifiedModel`
- `mainThreadAgentDefinition`

随后才计算：

- `effectiveModel`

这里的逻辑非常窄：

- 先把 `effectiveModel` 设成 `userSpecifiedModel`
- 只有当 `effectiveModel` 为空，且 `mainThreadAgentDefinition.model` 存在、且不等于 `inherit`
- 才把 agent 的 model 解析后塞进 `effectiveModel`

这说明 `mainThreadAgentDefinition.model` 回答的问题不是：

- 当前 runtime 已经强制使用哪个 model

而是：

- 当用户没有显式给出更强来源时，agent 自己能否提供一个 bootstrap candidate

所以更准确的写法不是：

- agent model 就是当前 model 的另一种存储位置

而是：

- 它属于 agent bootstrap source family
- 只在启动归并阶段有条件投票

## 第四层：`setMainLoopModelOverride(effectiveModel)` 写入的是 live launch override，不再保留 raw source family

`main.tsx` 在算完 `effectiveModel` 后会直接：

- `setMainLoopModelOverride(effectiveModel)`

`bootstrap/state.ts` 说明这个 slot 就是：

- `mainLoopModelOverride`

而 `getUserSpecifiedModelSetting()` 又总是先读它。

这说明启动期最关键的一件事不是：

- 系统一直保留 env / settings / agent 三条独立读取链

而是：

- 启动先把 source family 归并
- 然后把当前 launch 要执行的值写进同一个 live register

所以更准确的理解不是：

- launch override 是 env / settings / agent 之中的某一个 source

而是：

- launch override 是 precedence 归并后的执行落点
- 它和 raw source family 不是同一层对象

同槽，不等于同源。

## 第五层：`setInitialMainLoopModel(getUserSpecifiedModelSetting() || null)` 记录的是 startup snapshot，也不是 raw source

`main.tsx` 在写完 `setMainLoopModelOverride(effectiveModel)` 之后，又会：

- `setInitialMainLoopModel(getUserSpecifiedModelSetting() || null)`

这一步很容易被误读成：

- 把 env / settings / agent source 原样记下来

但源码实际做的是：

- 先按 override-first 规则重新取一次 user-specified setting
- 再把结果快照化

所以 `initialMainLoopModel` 回答的问题不是：

- 原始来源到底是哪一类

而是：

- 启动阶段 precedence 计算之后，用户指定链最后落成了什么

它因此既不是：

- `ANTHROPIC_MODEL`
- `settings.model`
- `mainThreadAgentDefinition.model`

也不是：

- raw `effectiveModel` 推导过程本身

更准确地说，它是 startup snapshot，不是 raw source。

## 第六层：`undefined`、`null` 与 resolved string 进入同一 register，也不是同一种语义

如果只看“都写进 `mainLoopModelOverride`”，就会漏掉更关键的一层：

- 写进去的值状态并不相同

从当前实现可稳定推出三种不同语义：

1. override 为 `undefined`
   `getUserSpecifiedModelSetting()` 会继续开放 `ANTHROPIC_MODEL` / `settings.model`
2. override 为 resolved string
   当前 runtime 直接服从这个 live register
3. override 为 `null`
   `getUserSpecifiedModelSetting()` 不再回退到 env / settings，`getMainLoopModel()` 会走 built-in default

这也是为什么“同一个 override slot”仍然不能被误写成：

- 一种简单的启动缓存

它其实携带了 fallback contract。

## 第七层：为什么这页不是 184 的改写

184 关注的是：

- persisted preference
- live override
- resumed-agent fallback

也就是 authority order。

185 这一页更窄地关心的是：

- env source
- settings source
- agent bootstrap source
- launch override sink
- startup snapshot

也就是 source family 与 startup collapse。

两页虽然共享 `getUserSpecifiedModelSetting()` 和 `setMainLoopModelOverride(...)`，但回答的问题不同：

- 184 问“谁在当前 runtime 夺取主权”
- 185 问“启动前后的来源家族为什么不能混写成同一种 source”

## 稳定面与灰度面

本页只保护稳定不变量：

- override-first 是稳定 reader contract
- env / settings / agent bootstrap / launch override 是不同 source family
- `initialMainLoopModel` 是 post-resolution snapshot
- 同槽写入不等于同源

本页刻意不展开的灰度层包括：

- alias 解析与 GrowthBook 细节
- provider default 分支
- print / remote resume 对 override slot 的额外 writer 全谱系
- `/model`、bridge `set_model` 等运行期 writer 的 UX 细节

这些对象会影响更大的 model 运行时图谱，但不是本页要守住的 hard sentence。

## 苏格拉底式自审

### 问：既然 `getUserSpecifiedModelSetting()` 最终都先读 override，为什么还要继续拆 source family？

答：因为“先读哪个 register”只能回答执行主位，不能回答那个值最初来自 ambient env、saved settings 还是 agent bootstrap。source family 被写平后，读者就会误把 sink 当成 source。

### 问：为什么一定要把 `setInitialMainLoopModel(...)` 拉进来？

答：因为如果不把 startup snapshot 单独拆出，读者会自然把快照误写成 raw source 本体，进而又把 precedence 计算结果和输入来源混成一层。

### 问：为什么这页不顺手把 print / resume / `/model` 一起写完？

答：因为那会把“启动来源族”重新膨胀成“大一统 override writer 全表”。稳定句子会失焦，和 107、166、184 的边界又会重新打结。
