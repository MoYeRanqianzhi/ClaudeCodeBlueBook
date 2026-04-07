# `getUserSpecifiedModelSetting`、`ANTHROPIC_MODEL`、`settings.model`、`mainThreadAgentDefinition.model` 与 `setMainLoopModelOverride` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/185-getUserSpecifiedModelSetting、ANTHROPIC_MODEL、settings.model、mainThreadAgentDefinition.model 与 setMainLoopModelOverride：为什么ambient env preference、saved setting、agent bootstrap 与 live launch override 不是同一种 model source.md`
- `05-控制面深挖/184-getUserSpecifiedModelSetting、settings.model、getMainLoopModelOverride、currentAgentDefinition 与 restoreAgentFromSession：为什么 persisted model preference、live override 与 resumed-agent fallback 不是同一种 model authority.md`
- `05-控制面深挖/182-session_context.model、metadata.model、lastModelUsage、modelUsage 与 restoreAgentFromSession：为什么 create-time model stamp、live override shadow、durable usage ledger 与 resumed-agent fallback 不是同一种 model ledger.md`

边界先说清：

- 这页不是 model authority 总页。
- 这页不是 model ledger 总页。
- 这页只抓 startup 阶段的 source family 与 launch override sink。

## 1. 五层对象

| 对象 | 当前更像什么 | 关键位置 |
| --- | --- | --- |
| `ANTHROPIC_MODEL` | ambient env preference | `getUserSpecifiedModelSetting()` fallback reader |
| `settings.model` | merged saved setting snapshot | `getInitialSettings()` / settings merge |
| `mainThreadAgentDefinition.model` | agent bootstrap source | `main.tsx` 启动归并 |
| `setMainLoopModelOverride(effectiveModel)` | live launch override sink | bootstrap state |
| `setInitialMainLoopModel(...)` | startup snapshot | 启动后快照 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `ANTHROPIC_MODEL` 就是 settings 的另一种写法 | env family 与 saved-setting family 不同 |
| `settings.model` 就是当前 runtime model | 它只是 merge 后的 saved snapshot |
| agent 自带 model 就是当前执行 model | 它只是 bootstrap candidate |
| `setMainLoopModelOverride(...)` 保留了原始来源信息 | 它只保留 launch override 结果 |
| `initialMainLoopModel` 就是启动来源本体 | 它是 post-resolution startup snapshot |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | override-first reader；env / settings / agent / launch override 分属不同 source family |
| 条件公开 | agent model 只有在 `effectiveModel` 为空且不为 `inherit` 时才参与 |
| 内部/灰度层 | alias 解析、provider 默认分支、print/resume 额外 writer 谱系 |

## 4. 三种 register 状态

| `mainLoopModelOverride` 状态 | 后果 |
| --- | --- |
| `undefined` | env / settings 仍可投票 |
| resolved string | live register 直接获胜 |
| `null` | env / settings 被遮蔽，回到 built-in default |

## 5. 五个检查问题

- 我现在说的是 raw source，还是 precedence 归并后的 sink？
- 我是不是把 `settings.model` 写成了 env shadow？
- 我是不是把 agent bootstrap candidate 写成了当前 runtime 主位？
- 我是不是把 `setInitialMainLoopModel(...)` 误写成 source 本体？
- 我是不是又回卷到了 184 的 authority order，而不是 185 的 source family？

## 6. 源码锚点

- `claude-code-source-code/src/utils/model/model.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/bootstrap/state.ts`
- `claude-code-source-code/src/state/onChangeAppState.ts`
- `claude-code-source-code/src/utils/settings/settings.ts`
