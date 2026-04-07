# `session_context.model`、`metadata.model`、`lastModelUsage`、`modelUsage` 与 `restoreAgentFromSession`：为什么 create-time model stamp、live override shadow、durable usage ledger 与 resumed-agent fallback 不是同一种 model ledger

## 用户目标

178 已经把 `session_context` 继续拆成：

- repo source
- branch outcome
- model stamp

181 又把 bridge create / hydrate 拆成：

- session birth
- history hydrate

但如果正文停在这里，读者还是很容易把 model 这条线重新写平：

- `session_context.model` 不就是这条 session 的 model 吗？
- `metadata.model` 不也还是同一个 model 的恢复值吗？
- `lastModelUsage` / `STATE.modelUsage` 不也只是同一个 model 的另一种记账吗？
- `restoreAgentFromSession(...)` 恢复出来的 agent model，不也还是同一个 model truth 吗？

这句还不稳。

从当前源码看，至少还要继续拆开四张不同的 model ledger：

1. create-time model stamp
2. live runtime override shadow
3. durable per-model usage ledger
4. resumed-agent fallback

如果这四层不先拆开，后面就会把：

- `session_context.model`
- `metadata.model`
- `STATE.modelUsage` / `lastModelUsage`
- `restoreAgentFromSession(...)`

重新压成同一种“当前 session 的 model”。

## 第一性原理

更稳的提问不是：

- “系统里到底哪个字段才是真正的 model？”

而是先问五个更底层的问题：

1. 当前字段在回答“建会话时 stamp 了什么”，还是“此刻 main loop 应跑什么”？
2. 当前字段在回答“远端当前要向 observer 镜像什么”，还是“本地累计按 model 记了多少 usage”？
3. 当前恢复逻辑在恢复 live override，还是在恢复 durable cost ledger？
4. 当前 fallback 在回答“如果没有更强主权时，要不要把 agent model 重新声明进来”？
5. 如果这些字段虽然都带着 `model` 之名，却服务不同对象层，为什么还要把它们写成同一种 model ledger？

只要这五轴不先拆开，后面就会把：

- model stamp
- model shadow
- model usage ledger
- agent fallback

混成一句模糊的“会话的模型设置”。

## 第一层：`session_context.model` 先是 create-time stamp，不是当前 runtime truth

`createSession.ts` 在 request body 里会写：

- `session_context.model: getMainLoopModel()`

这说明它回答的问题首先是：

- 建这条 remote session 时，当前解析出来的 main-loop model 是什么

它不是在回答：

- 这条 session 未来每个时刻实际跑的 model override 是什么
- 本地已经累计了哪些 per-model usage
- 之后 resume 时要从哪个 ledger 恢复 model

更关键的一点是：

- `utils/teleport/api.ts` 虽然在 `SessionContext` typing 里保留了 `model`
- 但当前 helper surface 真正在用的仍是 `sources` / `outcomes`

也就是说，当前本地 teleport readback helper 并没有围绕：

- `session_context.model`

建立一条对称的 runtime consumer。

所以更准确的理解不是：

- `session_context.model` 已经是当前代码里最 authoritative 的 model ledger

而是：

- 它更像 create-time provenance stamp

## 第二层：当前 runtime model truth 先由 override cascade 决定，不由 create-time stamp 反推

`utils/model/model.ts` 把 model 解析优先级写得很硬：

1. session 内 override
2. startup `--model`
3. `ANTHROPIC_MODEL`
4. settings
5. built-in default

对应实现就是：

- `getMainLoopModelOverride()`
- `getUserSpecifiedModelSetting()`
- `getMainLoopModel()`

这说明当前 runtime 回答的问题不是：

- “建会话时 stamp 了哪个 model”

而是：

- “此刻 main loop 在 override / env / settings cascade 下应实际解析到哪个 model”

bootstrap state 里也把这条线单独挂成：

- `getMainLoopModelOverride()`
- `setMainLoopModelOverride(...)`

所以更准确的理解不是：

- 运行时 model 只是 create-time stamp 的延续

而是：

- runtime model truth 首先是一条 override cascade

## 第三层：`metadata.model` 先是 live runtime shadow / readback，不是 durable ledger

`print.ts` 在两条 live runtime 变更路径上都会主动维护：

- `setMainLoopModelOverride(...)`
- `notifySessionMetadataChanged({ model })`

一条是：

- `set_model`

另一条是：

- incoming settings 包含 `model` 变化

与此同时，`RemoteIO` / `CCRClient` 这条链又会：

- `reportMetadata(...)`
- `getWorkerState()`
- `initialize()` 返回 prior `external_metadata`

最后在 `print.ts` 的 remote restore 里：

- `await options.restoredWorkerState`
- `if (typeof metadata.model === 'string') setMainLoopModelOverride(metadata.model)`

这说明 `metadata.model` 回答的问题更准确地说是：

- 当前 runtime 想向远端 observer 镜像哪个 model
- 或者在 remote readback 时，把这个 live shadow 再喂回 override sink

它不是在回答：

- 这一整条 session 的 per-model usage ledger 长成什么样
- durable project config 里最后一次保存的 model usage 是什么

所以更准确的结论不是：

- `metadata.model` 就是 durable model ledger

而是：

- 它更像 live override shadow / readback

## 第四层：`STATE.modelUsage` / `lastModelUsage` 先是 per-model usage ledger，不是当前 model selection

`cost-tracker.ts` 与 `bootstrap/state.ts` 把另一张账写得非常明确：

- `addToTotalModelUsage(...)`
- `addToTotalCostState(...)`
- `STATE.modelUsage[model] = modelUsage`

这里的 key 是：

- 各个 model 名称

而 value 里累计的是：

- input/output tokens
- cache read / creation tokens
- web search requests
- cost USD
- context window
- max output tokens

这说明它回答的问题不是：

- 当前 main loop 现在该选哪个 model

而是：

- 当前 session 截止此刻，在各个 model 名下已经累计了多少 usage

再往 durable 方向看：

- `saveCurrentSessionCosts(...)` 把 `getModelUsage()` 序列化到 `projectConfig.lastModelUsage`
- `getStoredSessionCosts(sessionId)` 只在 `lastSessionId` 匹配时读回
- `restoreCostStateForSession(...)` 再喂给 `setCostStateForRestore(...)`

这说明 `lastModelUsage` 这条链也在回答：

- 上一次同 session 的 per-model usage ledger

不是：

- 当前 live override / metadata shadow 应该是什么

所以更准确的理解不是：

- `lastModelUsage` 只是另一种 model restore source

而是：

- 它是一张按 model 维度累计 usage 的 durable ledger

## 第五层：`restoreAgentFromSession(...)` 先是 resumed-agent fallback，不是前面三张账的同义重放

`sessionRestore.ts` 的 `restoreAgentFromSession(...)` 只在特定条件下才会动到 model：

- 当前 CLI 没有更强的 `currentAgentDefinition`
- resumed session 带着 `agentSetting`
- resumed agent 自己声明了 `model`
- 当前也还没有更强的 main-loop override

这时它才会：

- `setMainLoopModelOverride(parseUserSpecifiedModel(resumedAgent.model))`

这说明它回答的问题不是：

- `session_context.model` 当时 stamp 了什么
- `metadata.model` 当前 shadow 了什么
- `lastModelUsage` 记了多少 per-model usage

而是：

- 在 resume agent 语境里，如果没有更高主权覆盖，要不要把 agent 自己的 model 重新声明成当前 override

所以更准确的理解不是：

- `restoreAgentFromSession(...)` 也在恢复同一张 model ledger

而是：

- 它只是 resumed-agent fallback source

## 第六层：四张账都带 `model`，不代表它们共享同一种 truth

到这里更稳的写法已经不是：

- 系统里有好几个地方都提到 model

而应该明确拆成：

1. `session_context.model`
   create-time stamp
2. `metadata.model`
   live override shadow / readback
3. `STATE.modelUsage` / `lastModelUsage`
   per-model usage ledger
4. `restoreAgentFromSession(...).model`
   resumed-agent fallback

它们虽然都在回答 model 相关问题，
但回答的是不同对象层：

- provenance
- runtime shadow
- accounting
- fallback declaration

所以不能再被压成一张“model truth table”。

## 第七层：为什么这页不是 52、107、152、167 或 178 的附录

### 不是 178 的附录

178 讲的是：

- `session_context.sources`
- `session_context.outcomes`
- `session_context.model`

为什么不是同一种上下文主语。

182 讲的是：

- `session_context.model` 往外再分裂成哪些不同 model ledger

178 讲 bag 内部的 subject split，
182 讲 model 这条线离开 bag 之后的多账本分裂。

### 不是 52 的附录

52 讲的是：

- `permission_mode`
- `is_ultraplan_mode`
- `model`

为什么不是同一种远端会话参数。

182 讲的不是 parameter family，
而是：

- model 自己内部不同 ledger 的对象层差异

### 不是 107 的附录

107 讲的是：

- `metadata.model` 为什么不是普通 AppState 回填项

182 继续往下压的不是：

- model restore sink 为什么独立

而是：

- 即使承认 restore sink 独立，model 仍然分成 stamp / shadow / usage / fallback 四张账

### 不是 152 的附录

152 讲的是：

- durable session metadata 不是 live system-init，也不是 foreground external-metadata

182 只借用了 durable ledger 里的：

- `lastModelUsage`

它不在讲整套 durable metadata family，
而是在讲：

- per-model usage ledger 与 live model truth 的错位

### 不是 167 的附录

167 讲的是：

- metadata readback bag
- live publish
- local consumption

182 虽然借用了 `metadata.model` readback，
但要证明的不是 observer metadata 的 admission gate，
而是：

- metadata.model 根本不是同一张账里的 durable usage ledger

## 第八层：这页真正保护的 stable 面与 gray 面

本页真正稳定的判断只有四句：

1. `session_context.model` 先是 create-time stamp。
2. `metadata.model` 先是 live override shadow / readback。
3. `STATE.modelUsage` / `lastModelUsage` 先是 per-model usage ledger。
4. `restoreAgentFromSession(...)` 先是 resumed-agent fallback source。

而不该在正文里继续放大的灰度细节包括：

- `activeUserSpecifiedModel` 等 print 内部胶水
- stats cache / UI 聚合展示
- 3P provider 默认值分支
- 将来 teleport helper 是否开始消费 `session_context.model`

这些可以变化，
但不会推翻本页更硬的结构判断：

- create-time model stamp、live override shadow、durable usage ledger 与 resumed-agent fallback 不是同一种 model ledger
