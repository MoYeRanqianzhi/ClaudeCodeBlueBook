# `getUserSpecifiedModelSetting`、`isModelAllowed`、`ANTHROPIC_MODEL`、`settings.model` 与 `getMainLoopModel` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/187-getUserSpecifiedModelSetting、isModelAllowed、ANTHROPIC_MODEL、settings.model 与 getMainLoopModel：为什么 source selection 之后的 allowlist veto 不会回退到更低优先级来源.md`
- `05-控制面深挖/184-getUserSpecifiedModelSetting、settings.model、getMainLoopModelOverride、currentAgentDefinition 与 restoreAgentFromSession：为什么 persisted model preference、live override 与 resumed-agent fallback 不是同一种 model authority.md`
- `05-控制面深挖/185-getUserSpecifiedModelSetting、ANTHROPIC_MODEL、settings.model、mainThreadAgentDefinition.model 与 setMainLoopModelOverride：为什么ambient env preference、saved setting、agent bootstrap 与 live launch override 不是同一种 model source.md`

边界先说清：

- 这页不是 model authority 总页。
- 这页不是 startup source family 总页。
- 这页只抓 source selection、allowlist admission 与 default fallback 的阶段错位。

## 1. 四层对象

| 对象 | 当前更像什么 | 关键位置 |
| --- | --- | --- |
| `getMainLoopModelOverride()` / env / settings | source selection inputs | `getUserSpecifiedModelSetting()` |
| `specifiedModel` | single surviving candidate | `model.ts` |
| `isModelAllowed(...)` | source-blind admission veto | `modelAllowlist.ts` |
| `getDefaultMainLoopModel()` | downstream default path | `getMainLoopModel()` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 优先级链失败后会自然回退到下一个来源 | 代码先选一个 candidate，再做一次 veto |
| allowlist 拒绝 env 后会继续试 settings | lower-source 不会被 reopen |
| `isModelAllowed(...)` 在判断来源层级 | 它只判断选中的 model 字符串是否被允许 |
| getter-time veto 和 `/model` 报错是同一种合同 | 一个是 silent veto，一个是 user-facing validation |
| 被 veto 后仍然算“有一个用户指定模型” | 下游拿到的是 `undefined`，然后走 default |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | two-stage path：source selection -> allowlist admission |
| 条件公开 | 只有 `specifiedModel` 非空时才会触发 allowlist veto |
| 内部/灰度层 | allowlist family alias 细则、provider 解析、完整 producer 家族 |

## 4. 五个检查问题

- 我现在写的是 source precedence，还是 admission semantics？
- 我是不是误把 veto 当成了 lower-source reopen？
- 我是不是把 `/model` 的显式错误 UX 混成 getter-time 语义？
- 我是不是把 resume / agent producer 又抬回主角了？
- 我是不是又回卷到 184 / 185 的主语，而不是 187 的阶段错位？

## 5. 源码锚点

- `claude-code-source-code/src/utils/model/model.ts`
- `claude-code-source-code/src/utils/model/modelAllowlist.ts`
- `claude-code-source-code/src/commands/model/model.tsx`
- `claude-code-source-code/src/utils/model/validateModel.ts`
- `claude-code-source-code/src/utils/sessionRestore.ts`
