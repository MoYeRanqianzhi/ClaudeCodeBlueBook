# `model.tsx`、`validateModel`、`getModelOptions` 与 `getUserSpecifiedModelSetting` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/188-model.tsx、validateModel、getModelOptions 与 getUserSpecifiedModelSetting：为什么显式拒绝、选项隐藏与 silent veto 不是同一种 allowlist contract.md`
- `05-控制面深挖/187-getUserSpecifiedModelSetting、isModelAllowed、ANTHROPIC_MODEL、settings.model 与 getMainLoopModel：为什么 source selection 之后的 allowlist veto 不会回退到更低优先级来源.md`
- `05-控制面深挖/185-getUserSpecifiedModelSetting、ANTHROPIC_MODEL、settings.model、mainThreadAgentDefinition.model 与 setMainLoopModelOverride：为什么ambient env preference、saved setting、agent bootstrap 与 live launch override 不是同一种 model source.md`

边界先说清：

- 这页不是 allowlist matcher 总页。
- 这页不是 source precedence 总页。
- 这页只抓 explicit rejection、option hiding 与 silent getter veto 的 surface 分裂。

## 1. 四层对象

| 对象 | 当前更像什么 | 关键位置 |
| --- | --- | --- |
| `model.tsx` | `/model` explicit rejection | slash command write path |
| `validateModel(...)` | reusable write-time validator | `/config` / custom model write |
| `getModelOptions()` | option hiding with `Default` preserved | config / picker surfaces |
| `getUserSpecifiedModelSetting()` | silent getter veto | runtime read path |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| allowlist 不让用，系统都会统一报错 | getter 读路径根本不会报错，只会交出 `undefined` |
| `getModelOptions()` 只是另一种拒绝 | 它首先是在隐藏候选面 |
| `/config` 的 model 写入和 `/model` 完全是两套逻辑 | 二者共享 `validateModel(...)` 这条 write-time validator |
| `isModelAllowed(...)` 被复用，所以 contract 也相同 | 同一 predicate 在不同 surface 上承担不同合同 |
| `Default` 也会被 allowlist 一起隐藏 | option surface 明确保留 `Default` |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | explicit rejection / option hiding / silent veto 是三种不同 surface |
| 条件公开 | known alias、`default`、custom model 在 write path 上有不同 bypass / validation 分支 |
| 内部/灰度层 | sideQuery 细节、provider-specific option generation、1M qualification 分支 |

## 4. 五个检查问题

- 我现在写的是 write-time、option-build time，还是 getter read-time？
- 我是不是把 option hiding 误写成了输入后拒绝？
- 我是不是把 `validateModel(...)` 误缩成 `/model` 的局部细节？
- 我是不是又回卷到 187 的 admission stage split？
- 我是不是忘了 `Default` 在 option surface 上被稳定保留？

## 5. 源码锚点

- `claude-code-source-code/src/commands/model/model.tsx`
- `claude-code-source-code/src/utils/model/validateModel.ts`
- `claude-code-source-code/src/utils/model/modelOptions.ts`
- `claude-code-source-code/src/utils/model/model.ts`
- `claude-code-source-code/src/tools/ConfigTool/supportedSettings.ts`
