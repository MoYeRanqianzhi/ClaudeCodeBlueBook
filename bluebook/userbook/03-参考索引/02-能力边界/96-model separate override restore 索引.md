# `model` separate override restore 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/107-model、externalMetadataToAppState、setMainLoopModelOverride 与 restoredWorkerState：为什么 metadata 里的 model 不是普通 AppState 回填项.md`
- `05-控制面深挖/52-permission_mode、is_ultraplan_mode 与 model：为什么远端恢复回填、当前本地状态与 session control request 不是同一种会话参数.md`
- `05-控制面深挖/103-pending_action、task_summary、externalMetadataToAppState、state restore 与 stale scrub：为什么 CCR 的 observer metadata 不是同一种恢复面.md`

边界先说清：

- 这页不是 model 总论。
- 这页不替代 52 对 session parameter family 的总分层。
- 这页不替代 103 对 observer metadata restore contract 的拆分。
- 这页只抓 `model` 为什么恢复时落到 separate override sink，而不是普通 `AppState` mapper。

## 1. 三层对象总表

| 对象 | 它在回答什么 | 更接近什么 |
| --- | --- | --- |
| `externalMetadataToAppState(...)` | 哪些 metadata 适合直接 patch 回状态树 | narrow AppState restore mapper |
| `metadata.model` | 恢复时要声明哪个 main-loop 执行模型 | override restore input |
| `setMainLoopModelOverride(...)` | 把 model 真正落到本地执行入口 | separate restore sink |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `model` 只是漏写进 `externalMetadataToAppState(...)` | 当前源码明确把恢复目标拆成 AppState sink 与 override sink |
| 都来自 metadata，所以都该 patch 回 `AppState` | 来源相同不等于本地落点相同 |
| `setMainLoopModelOverride(...)` 只是临时胶水 | model 的本地变化与恢复都围绕这条入口组织 |
| 这和 52 完全一样 | 52 讲 family 差异；107 讲 `model` restore sink 身份 |
| 能恢复 = 普通 durable config 字段 | `model` 虽能恢复，但恢复方式仍然是 override 声明 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `externalMetadataToAppState(...)` 只恢复 mode/ultraplan；`metadata.model` 单独走 `setMainLoopModelOverride(...)` |
| 条件公开 | 这条恢复分叉主要体现在 CCR v2 resume；只有 `metadata.model` 为字符串时才触发 |
| 内部/灰度层 | `mainLoopModel` 本地胶水、settings 写回、默认模型解析与更深架构理由 |

## 4. 六个检查问题

- 当前恢复目标是状态树字段，还是 main-loop override？
- 我是不是把 metadata 来源相同写成了本地落点相同？
- 这里是 family 对比，还是单个 parameter 的 sink identity？
- 我是不是把 `setMainLoopModelOverride(...)` 误写成了实现噪音？
- 我有没有把 model 总链路一股脑拉进来，稀释了恢复主轴？
- 我是不是又把 52 的广义结论直接重讲了一遍？

## 5. 源码锚点

- `claude-code-source-code/src/state/onChangeAppState.ts`
- `claude-code-source-code/src/cli/print.ts`
