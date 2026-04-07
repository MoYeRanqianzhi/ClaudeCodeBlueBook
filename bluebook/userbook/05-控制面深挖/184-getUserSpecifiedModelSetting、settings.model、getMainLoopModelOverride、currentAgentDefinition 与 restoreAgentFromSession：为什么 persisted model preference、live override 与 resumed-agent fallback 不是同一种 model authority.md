# `getUserSpecifiedModelSetting`、`settings.model`、`getMainLoopModelOverride`、`currentAgentDefinition` 与 `restoreAgentFromSession`：为什么 persisted model preference、live override 与 resumed-agent fallback 不是同一种 model authority

## 用户目标

182 已经把 model 相关对象拆成：

- create-time stamp
- live shadow
- durable usage
- resumed fallback

183 又把 bridge 初始历史继续拆成：

- wire slot
- local seed
- success ledger

但如果正文停在这里，读者还是很容易把 model 主权顺序重新写平：

- `settings.model` 不就是当前用户选中的 model 吗？
- `getMainLoopModelOverride()` 不也只是把这个设置临时搬到内存里吗？
- `restoreAgentFromSession(...)` 恢复出来的 agent model，不也还是在恢复同一个用户偏好吗？
- 如果 resume 时 agent 带了 model，那它和当前 settings / override 到底谁说了算？

这句还不稳。

从当前源码看，至少还要继续拆开三种不同的 model authority：

1. persisted model preference
2. live override
3. resumed-agent fallback

如果这三层不先拆开，后面就会把：

- `settings.model`
- `getMainLoopModelOverride()`
- `restoreAgentFromSession(...)`

重新压成同一种“当前 model 设置”。

## 第一性原理

更稳的提问不是：

- “系统最终选中的 model 到底来自哪里？”

而是先问五个更底层的问题：

1. 当前值在回答“用户持久保存的偏好是什么”，还是“这轮 runtime 眼下必须跑什么”？
2. 当前值是在设置面持久化，还是在 bootstrap state 里夺取当前主权？
3. 当前 resume 路径是在恢复一个强主权，还是在没有更强主权时补一个 fallback？
4. 当前 agent 相关逻辑会不会被现有 `currentAgentDefinition` 或现有 override 直接短路？
5. 如果这些值虽然都能影响 `getMainLoopModel()`，为什么还要把它们写成不同 authority？

只要这五轴不先拆开，后面就会把：

- persisted preference
- runtime override
- resumed fallback

混成一句模糊的“用户当前选的模型”。

## 第一层：`settings.model` 先是 persisted preference，不是当前 runtime authority

`onChangeAppState.ts` 对 `mainLoopModel` 的本地变化会：

- `updateSettingsForSource('userSettings', { model: ... })`

这说明 `settings.model` 回答的问题首先是：

- 用户设置面里应持久保存的 model 偏好是什么

它不是直接在回答：

- 当前 main loop 这一刻是否一定要跑这个 model

因为“被保存”与“当前正在生效”本来就是两层对象：

- 前者更像 durable preference
- 后者更像 runtime authority

所以更准确的理解不是：

- `settings.model` 就是当前 runtime 必然执行的 model

而是：

- 它更像 persisted preference

## 第二层：`getMainLoopModelOverride()` 先是 live override，主权高于 `settings.model`

`utils/model/model.ts` 里的 `getUserSpecifiedModelSetting()` 把顺序写得非常硬：

- 先读 `getMainLoopModelOverride()`
- 没有 override 才退到 `ANTHROPIC_MODEL` / `settings.model`

这说明当前 runtime 回答的问题不是：

- 用户设置里最后保存了什么

而是：

- 在 override / env / settings 这个优先级链里，哪一层此刻拥有解释权

所以更准确的结论不是：

- override 只是 settings 的一个内存镜像

而是：

- override 是当前 runtime 的更高主权
- settings 只是它下面的一层 durable preference

## 第三层：系统会同时更新 settings 与 override，但这不等于两者是同一层

`onChangeAppState.ts` 在 `mainLoopModel` 变化时会同时：

- 写入 `settings.model`
- 调 `setMainLoopModelOverride(...)`

`print.ts` 在接收 settings 变更时也会：

- 如果 incoming settings 包含 `model`
- 直接同步 `setMainLoopModelOverride(...)`

这说明系统承认：

- persisted preference 与 live override 之间经常需要被一起维护

但“一起维护”不等于“它们是同一层对象”。

更准确的理解是：

- settings 负责把偏好持久化下来
- override 负责让当前 runtime 立即服从新的解释权

如果两者真是同一层，
`getUserSpecifiedModelSetting()` 就不需要先看 override 再看 settings。

## 第四层：`restoreAgentFromSession(...)` 先被 `currentAgentDefinition` 短路，所以它不是常驻主权

`sessionRestore.ts` 的 `restoreAgentFromSession(...)` 一上来先看：

- `currentAgentDefinition`

只要当前 CLI 已经带着更强的 agent 定义，
它就直接：

- `return { agentDefinition: currentAgentDefinition, ... }`

这说明 resumed-agent 路径回答的问题不是：

- “无论如何都把旧 session 的 agent model 抢回来”

而是：

- 如果当前没有更强的 agent 主权，再考虑旧 session 的 agent 定义

所以更准确的理解不是：

- resumed-agent model 与当前显式 agent 定义共享同一种 authority

而是：

- `currentAgentDefinition` 先天高于 resumed-agent fallback

## 第五层：即使 agent 恢复被允许，`restoreAgentFromSession(...)` 也只在没有 live override 时才补 model

`restoreAgentFromSession(...)` 真正触碰 model 的条件非常窄：

- `!getMainLoopModelOverride()`
- `resumedAgent.model`
- `resumedAgent.model !== 'inherit'`

才会：

- `setMainLoopModelOverride(parseUserSpecifiedModel(resumedAgent.model))`

这说明 resumed-agent model 回答的问题不是：

- “把旧 session 的 model 无条件恢复成当前解释权”

而是：

- 如果当前没有更强 override，且 agent 自己声明了一个非 `inherit` model，才让它补位

所以更准确的结论不是：

- resumed-agent model 与 live override 是同一层 authority

而是：

- resumed-agent model 只是 absence-based fallback

## 第六层：因此 `settings.model`、live override 与 resumed-agent model 是三层不同主权顺序

到这里更稳的写法已经不是：

- 系统里有好几个地方都能写 model

而应该明确拆成：

1. `settings.model`
   persisted preference
2. `getMainLoopModelOverride()`
   live runtime authority
3. `restoreAgentFromSession(...).model`
   resumed-agent fallback

它们虽然都会影响最终的 `getMainLoopModel()`，
但影响方式并不相同：

- settings 提供可持久化偏好
- override 直接夺取当前 runtime 主权
- resumed agent 只在更强主权缺席时兜底

所以不能再被压成一张“model settings table”。

## 第七层：为什么这页不是 52、107、158 或 182 的附录

### 不是 182 的附录

182 讲的是：

- stamp
- shadow
- usage
- fallback

四张不同 ledger。

184 讲的是：

- 在真正决定当前 model 时，persisted preference、live override 与 resumed fallback 如何排优先级

182 的主语是账本种类，
184 的主语是 authority order。

### 不是 52 的附录

52 讲的是：

- `permission_mode`
- `is_ultraplan_mode`
- `model`

为什么不是同一种远端会话参数。

184 不再讲 parameter family，
而是只讲 model 自己内部的主权顺序。

### 不是 107 的附录

107 讲的是：

- `metadata.model` 为什么不是普通 AppState mapper

184 不再讲 metadata sink 身份，
而是讲：

- settings / override / resumed agent 之间谁先抢到当前 runtime 主权

### 不是 158 的附录

158 讲的是：

- preview transcript
- formal session restore

虽然这页借用了 resume 路径里的 `restoreAgentFromSession(...)`，
但要证明的不是 preview vs formal restore，
而是：

- formal restore 里 resumed agent model 仍然只是一个被更强主权约束的 fallback

## 第八层：这页真正保护的 stable 面与 gray 面

本页真正稳定的判断只有四句：

1. `settings.model` 先是 persisted preference。
2. `getMainLoopModelOverride()` 先是当前 runtime authority。
3. `currentAgentDefinition` 会直接短路 resumed-agent restore。
4. `restoreAgentFromSession(...).model` 只有在更强主权缺席时才补位。

而不该在正文里继续放大的灰度细节包括：

- `ANTHROPIC_MODEL` 与 3P provider 默认值的完整分支
- `activeUserSpecifiedModel` 的 UI 胶水
- settings sync 的前端细节
- 将来 resume 入口是否增加更多 agent precedence 规则

这些会变化，
但不会推翻本页更硬的结构判断：

- persisted model preference、live override 与 resumed-agent fallback 不是同一种 model authority
