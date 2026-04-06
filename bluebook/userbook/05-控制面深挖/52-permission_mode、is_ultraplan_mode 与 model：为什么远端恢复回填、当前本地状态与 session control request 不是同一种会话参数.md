# `permission_mode`、`is_ultraplan_mode` 与 `model`：为什么远端恢复回填、当前本地状态与 session control request 不是同一种会话参数

## 用户目标

不是只知道远端会话里“权限模式会变、model 也会变、Ultraplan 好像还会记住一部分状态”，而是先分清五类不同对象：

- 哪些参数属于当前本地 `AppState` 的运行中状态。
- 哪些参数会被外化成远端 `external_metadata`。
- 哪些参数会在 worker / resume 恢复时从远端再回填到本地。
- 哪些参数虽然也会被远端改，但写回链和恢复链并不是同一路。
- 哪些参数只是一次性的 plan 标记，不应被误写成长期 session mode。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“远端会话参数”：

- `toolPermissionContext.mode`
- `permission_mode`
- `is_ultraplan_mode`
- `mainLoopModel`
- `model`
- `set_permission_mode`
- `set_model`
- `externalMetadataToAppState(...)`
- `setMainLoopModelOverride(...)`

## 第一性原理

远端会话参数至少沿着四条轴线分化：

1. `Runtime State`：当前本地真实生效的会话参数是什么。
2. `Externalized Metadata`：哪些参数会被镜像成远端可恢复的 `external_metadata`。
3. `Restore Path`：下次恢复时，这些 metadata 怎样回填到本地状态。
4. `Parameter Lifetime`：当前参数是长期 session 参数，还是只在某个阶段暂时成立的一次性标记。

因此更稳的提问不是：

- “远端现在不是已经知道我的 mode 和 model 了吗？”

而是：

- “当前这是本地运行态、远端镜像态，还是恢复回填态；它是长期 session 参数，还是只在第一次 plan cycle 有意义？”

只要这四条轴线没先拆开，正文就会把 `permission_mode`、`is_ultraplan_mode`、`model` 写成同一种 metadata。

这里也要主动卡住一个边界：

- 这页讲的是 session 参数的远端外化与恢复回填
- 不重复 29 页对 `set_permission_mode` / `set_model` 作为 control request 的边界
- 不重复 25 页对设置面、控制面与状态面的分工
- 不重复 51 页对运行态投影面的 phase / pending_action / summary 分层

## 第一层：`toolPermissionContext.mode` 是本地运行态，`permission_mode` 是外化后的远端镜像

### 本地 mode 不会原样直接写给远端

`onChangeAppState.ts` 把这层写得很明确：

- 监听的是 `toolPermissionContext.mode` 的本地 diff
- 写给远端前先经过 `toExternalPermissionMode(...)`

源码注释还专门强调：

- 某些 internal-only mode 不能直接发给 CCR
- 即使本地 mode 变了，如果 externalized mode 没变，也不应该制造远端噪音

这说明 `permission_mode` 回答的问题不是：

- 本地运行时到底精确走到了哪个内部 mode 名称

而是：

- 远端需要恢复和展示的那份“对外可见 permission mode”是什么

### 所以本地 mode 与远端 `permission_mode` 不是同一个值域

更准确的区分是：

- `toolPermissionContext.mode`：本地运行态
- `permission_mode`：去除了 internal-only 噪音后的外化镜像

只要这一层没拆开，正文就会把：

- 本地真正 mode
- 远端可恢复 mode

写成同一个字段。

## 第二层：`is_ultraplan_mode` 不是普通 mode，而是一次性 first-plan-cycle 标记

### 它只在进入外化后的 `plan` 且第一次超计划时写成 `true`

`onChangeAppState.ts` 对这层写得非常硬：

- 只有当 externalized mode 是 `plan`
- 且 `newState.isUltraplanMode === true`
- 且 `oldState.isUltraplanMode === false`

时，才会把：

- `is_ultraplan_mode: true`

写进 metadata。

否则写的是：

- `null`

注释也明确说：

- 这是 `Ultraplan = first plan cycle only`
- 并且 `null` 的语义是 RFC 7396 删除键

这说明它回答的问题不是：

- “这个 session 永远就是 Ultraplan 模式”

而是：

- 当前是不是正在第一次 plan cycle，需要把这个短期标记外化出去

### 所以 `is_ultraplan_mode` 不是另一种长期 `permission_mode`

更准确的理解应是：

- `permission_mode`：长期 session 参数的一部分
- `is_ultraplan_mode`：一次性阶段标记

只要这一层没拆开，正文就会把：

- session 处在 plan mode
- 当前这次是 first ultraplan cycle

写成同一层状态。

## 第三层：`model` 的写回链和 `permission_mode` 不同，它不是通过同一个中心 diff 自动外化

### `permission_mode` 走中心 diff，`model` 走显式 metadata notify

`onChangeAppState.ts` 只把：

- `permission_mode`
- `is_ultraplan_mode`

纳入中心化的 metadata writeback choke point。

而 `model` 的外化不是走这里，而是在 `print.ts` 里由显式改参路径主动发：

- `notifySessionMetadataChanged({ model })`

至少两条明确路径会这么做：

- `set_model`
- 其他 model 变更后重新注入 breadcrumb 的路径

这说明 `model` 回答的问题不是：

- “任何本地状态变了都由同一条中心 diff 自动镜像”

而是：

- model 作为 session 参数，需要由显式改参路径自己决定何时写回远端 metadata

### 所以 `model` 与 `permission_mode` 虽然都在 metadata 里，但写回合同不同

更准确的区分是：

- `permission_mode`：中心 diff 自动外化
- `model`：显式变更路径主动外化

只要这一层没拆开，正文就会把：

- mode / model 都属于 session 参数
- mode / model 因此一定共享同一条写回路径

误写成一回事。

## 第四层：恢复时，`permission_mode` / `is_ultraplan_mode` 与 `model` 也不是同一路回填

### mode / ultraplan 通过 `externalMetadataToAppState(...)` 回填

`print.ts` 在 CCR v2 resume 时会：

- 等 `restoredWorkerState`
- 拿到 `metadata`
- `setAppState(externalMetadataToAppState(metadata))`

而 `externalMetadataToAppState(...)` 只负责回填：

- `permission_mode`
- `is_ultraplan_mode`

这说明这条回填链回答的问题是：

- 从远端 metadata 里恢复本地 permission / plan-stage 相关状态

### `model` 则走单独的 override 回填

同一段 `print.ts` 紧接着又单独判断：

- `typeof metadata.model === 'string'`

若成立，就：

- `setMainLoopModelOverride(metadata.model)`

也就是说，`model` 恢复并不走 `externalMetadataToAppState(...)` 这条泛化映射。

### 所以“都能恢复”不等于“通过同一路恢复”

更准确的区分是：

- `permission_mode` / `is_ultraplan_mode`：metadata -> app state mapper
- `model`：metadata -> main loop model override

只要这一层没拆开，正文就会把：

- 这些参数都能远端恢复
- 它们一定走同一条 restore path

写成同一个结论。

## 第五层：`set_permission_mode` / `set_model` 是控制入口，不等于恢复回填合同本身

### control request 只是“谁能改”，不是“怎样被恢复”

29 页已经讲过：

- `set_permission_mode`
- `set_model`

属于 session control request。

但这页继续下钻的是：

- 改完之后哪些会被写回 `external_metadata`
- 哪些恢复时会回填
- 哪些回填路径不同

这说明 control request 回答的问题不是：

- “这些参数以后如何被远端保存并恢复”

而是：

- “当前远端有没有权力改它”

### 所以“能改”与“怎样恢复”不能写成同一种控制合同

更准确的区分是：

- 29 页：control authority
- 这页：metadata writeback + restore path

只要这一层没拆开，正文就会把：

- parameter control
- parameter persistence / restore

写成同一页。

## 第六层：`permission_mode`、`is_ultraplan_mode`、`model` 的生命周期也不同

### `permission_mode` 偏长期、`is_ultraplan_mode` 偏一次性、`model` 偏显式 override

从写回与回填链路综合看，更准确的理解应是：

- `permission_mode`：稳定 session parameter，外化后用于远端和恢复保持一致
- `is_ultraplan_mode`：第一次 plan cycle 的阶段标记，不应被看成长期 mode
- `model`：会话级 override，可被远端显式改动并在恢复时单独回填

这说明三者虽然都出现在 `external_metadata` 视野里，但并不属于同一种 lifetime。

### 所以不要把它们写成一张“远端设置表”

更准确的区分是：

- 长期 parameter
- 一次性 stage flag
- 会话 override

只要这一层没拆开，正文就会把：

- 模式
- 阶段标记
- 模型 override

写成同一类会话参数。

## 第七层：稳定、条件与内部三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 远端可保持的 permission mode、一轮 Ultraplan 的阶段标记、恢复时会带回的 model override |
| 条件公开 | `permission_mode` 的外化去噪、`is_ultraplan_mode` 的一次性真值 + 其余时机写 `null`、CCR v2 resume 的 metadata 回填 |
| 内部/实现层 | `externalMetadataToAppState(...)` 函数名、`toExternalPermissionMode(...)`、SDK status stream 旁支、`setMainLoopModelOverride(...)` 的胶水细节 |

这里尤其要避免两种写坏方式：

- 把 29 页的 session control request 重新写成“metadata 大全”
- 把 mode、stage flag 和 model override 写成同一种远端设置项

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `toolPermissionContext.mode` = `permission_mode` | 一个是本地运行态，一个是去噪后的远端镜像 |
| `permission_mode` = `is_ultraplan_mode` | 一个是长期参数，一个是第一次 plan cycle 标记 |
| `model` 和 `permission_mode` 会被同一条中心 diff 自动写回 | `model` 走显式 notify，`permission_mode` 走中心 diff |
| 都能恢复 = 都走 `externalMetadataToAppState(...)` | `model` 走单独 override 回填 |
| `set_model` = model 已永久成为设置默认值 | 这里讲的是 session override 与远端恢复，不是全局设置默认 |
| 看到 `is_ultraplan_mode=true` 就是长期 plan mode | 它只应解释为 first ultraplan cycle 的阶段真值 |

## 六个高价值判断问题

- 当前说的是本地运行态、远端镜像态，还是恢复回填态？
- 这个参数是长期 session parameter，还是一次性阶段标记？
- 它是通过中心 diff 自动写回，还是通过显式改参路径主动写回？
- 它恢复时走的是统一 metadata mapper，还是单独 override？
- 我是不是又把 control authority 和 restore path 写成同一层？
- 我是不是又把 mode、stage flag 和 model override 写成了一张设置表？

## 源码锚点

- `claude-code-source-code/src/state/onChangeAppState.ts`
- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/cli/print.ts`
