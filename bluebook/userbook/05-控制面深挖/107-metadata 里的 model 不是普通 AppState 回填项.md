# `model`、`externalMetadataToAppState`、`setMainLoopModelOverride` 与 `restoredWorkerState`：为什么 metadata 里的 `model` 不是普通 `AppState` 回填项

## 用户目标

52 已经讲清：

- `permission_mode`
- `is_ultraplan_mode`
- `model`

虽然都和远端 metadata 恢复有关，但写回链和恢复链并不完全相同。

103 又讲清：

- 同在 `external_metadata` 里，也不等于享有同一种恢复合同

但读到这里，读者仍然很容易保留一个没拆干净的误解：

- `model` 既然也来自 `metadata`，那恢复时为什么不顺手走 `externalMetadataToAppState(...)`？
- 它为什么要单独走 `setMainLoopModelOverride(...)`？
- 这到底只是实现风格，还是在说明 `model` 根本不是普通 `AppState` 回填项？
- `mainLoopModel`、`model`、override、settings 持久化，到底是不是同一张恢复表？

如果这些不拆开，正文最容易滑成一句过度简化的话：

- “`model` 只是漏写进 `externalMetadataToAppState(...)` 了。”

从当前源码看，这个结论太轻率。

## 第一性原理

更稳的提问不是：

- “为什么不统一走一个 mapper？”

而是先问五个更底层的问题：

1. 当前恢复目标是 `AppState` 字段，还是 main-loop 级 override？
2. 当前讨论的是 metadata restore，还是 settings / model selection 的另一条本地链路？
3. `permission_mode` / `is_ultraplan_mode` 与 `model` 在本地运行态中的落点，是不是同一层对象？
4. 当前代码是在做“反序列化进状态树”，还是在做“重新声明一个执行 override”？
5. 这里缺的是“同一路径没复用”，还是“本来就不该复用”？

只要这五轴没先拆开，后续就会把：

- model restore sink

误写成：

- “另一个普通的 `AppState` patch”

## 第一层：`externalMetadataToAppState(...)` 从一开始就不是 metadata 全量逆映射器

`onChangeAppState.ts` 里的 `externalMetadataToAppState(...)` 很克制：

- 只处理 `permission_mode`
- 只处理 `is_ultraplan_mode`

它没有任何：

- `model`

分支。

这说明这条函数回答的问题不是：

- “把 `SessionExternalMetadata` 原样变回本地状态”

而是：

- “把其中那两项适合直接 patch 回 `AppState` 的参数，映射回本地状态树”

所以第一句就不该写成：

- `externalMetadataToAppState(...)` 是 metadata 的通用反向装配器

更准确的说法是：

- 它只是窄范围的 AppState restore mapper

## 第二层：`model` 的本地落点本来就不是那条 mapper 处理的同类字段

同一个文件里，本地 model 变化的处理方式是：

- 更新 settings
- `setMainLoopModelOverride(...)`

也就是说，`mainLoopModel` 相关逻辑本来就围绕：

- override 入口

而不是围绕：

- 像 `toolPermissionContext.mode` 那样 patch 回某个嵌套状态树字段

这说明在本地运行态上，`model` 回答的问题更接近：

- 当前 main loop 实际应使用哪个 override

而不是：

- `AppState` 某个普通子字段该被动回填成什么值

所以更准确的判断是：

- `model` 的恢复落点天然就更像 override sink

而不是普通 `AppState` sink。

## 第三层：源码在远端恢复时也明确把这两类 sink 分开了

`print.ts` 在 CCR v2 resume 时，会先：

- `setAppState(externalMetadataToAppState(metadata))`

然后紧接着再单独判断：

- `typeof metadata.model === 'string'`

成立时再：

- `setMainLoopModelOverride(metadata.model)`

这段顺序很值钱，因为它明确把恢复拆成了两条 sink：

1. metadata -> AppState mapper
2. metadata -> main loop override

这说明这里不是：

- “本来都该进一个 mapper，只是实现上偷懒分了两步”

而是：

- 恢复目标本来就分属两种不同的本地对象层级

## 第四层：`model` 的写回链也已经预示它不是普通 `AppState` 镜像

`print.ts` 里涉及 model 改动时，明确会主动：

- `notifySessionMetadataChanged({ model })`

但这条写回不是由 `externalMetadataToAppState(...)` 的镜像逆向决定的，
而是由 model 相关改参路径主动触发。

这说明它从写回侧就已经表现出另一种合同：

- mode / ultraplan 更像“适合进统一 mapper 的参数”
- model 更像“显式改参路径自己维护的 override metadata”

所以如果恢复时也继续单独打到：

- `setMainLoopModelOverride(...)`

这不是偶然分叉，而是写回链与恢复链共同体现出来的同一设计倾向。

## 第五层：为什么 107 不能并回 52

52 已经给出结论：

- `model` 恢复不走 `externalMetadataToAppState(...)`

但 52 的主语仍然比较宽：

- session parameter 总体的 writeback / restore asymmetry

107 继续往下压到一个更窄的问题：

- 为什么 `model` 的恢复 sink 本来就不该被视作普通 `AppState` patch

前者讲：

- parameter family 对比

后者讲：

- one parameter’s restore sink identity

不该揉成一页。

## 第六层：为什么 107 也不能并回 103

103 的主语是：

- observer metadata 为什么不享有同一种恢复合同

107 的主语已经换了：

- durable-ish parameter 里的 `model`，为什么也不走同一条 `AppState` mapper

前者是：

- stale scrub vs restore absence

后者是：

- separate override sink vs AppState sink

层级不同，也必须分开。

## 第七层：最常见的假等式

### 误判一：`model` 只是漏写进 `externalMetadataToAppState(...)`

错在漏掉：

- 当前源码把恢复目标明确拆成 `AppState` sink 与 main-loop override sink

### 误判二：既然都来自 metadata，就都该 patch 回 `AppState`

错在漏掉：

- metadata 来源相同，不等于本地落点相同

### 误判三：`setMainLoopModelOverride(...)` 只是一个临时胶水函数

错在漏掉：

- 本地 model 变化、settings 持久化和 resume 恢复都围绕这条 override 入口组织

### 误判四：这和 52 完全一样

错在漏掉：

- 52 讲 family 差异；107 讲 `model` restore sink 的独立身份

### 误判五：既然 `model` 能恢复，它就是普通 durable config 字段

错在漏掉：

- 它虽能恢复，但恢复方式仍然是“声明执行 override”，不是“走统一 AppState mapper”

## 第八层：稳定、条件与内部边界

### 稳定可见

- `externalMetadataToAppState(...)` 只恢复 `permission_mode` / `is_ultraplan_mode`。
- `metadata.model` 恢复时单独走 `setMainLoopModelOverride(...)`。
- `model` 的本地变化与恢复都围绕 main-loop override 入口组织，而不是统一 `AppState` mapper。

### 条件公开

- 这条恢复分叉主要体现在 CCR v2 resume path。
- `model` metadata 只有在存在字符串值时才会触发该单独 override restore。

### 内部 / 灰度层

- `mainLoopModel`、settings 写回、requestedModel/default model 解析等具体胶水。
- 为什么设计上不把 model 纳入 `AppState` mapper 的更深架构理由。

## 第九层：苏格拉底式自检

### 问：为什么这页值得单列，而不是在 52 里多加两段？

答：因为这里真正需要钉死的不是“它不同”，而是“它为什么不同到不该被视作普通 `AppState` patch”。这是更窄、也更实用的一层。

### 问：为什么要强调 sink identity？

答：因为只要没看见“落到哪里”，读者就会一直把所有 metadata restore 混成“一个 mapper 反序列化回本地”。

### 问：为什么不能把这页写成 model 全链路总论？

答：因为本页只需要解释恢复 sink，不需要把设置面、切模入口、默认模型选择再全部拉进来。

## 源码锚点

- `claude-code-source-code/src/state/onChangeAppState.ts`
- `claude-code-source-code/src/cli/print.ts`
