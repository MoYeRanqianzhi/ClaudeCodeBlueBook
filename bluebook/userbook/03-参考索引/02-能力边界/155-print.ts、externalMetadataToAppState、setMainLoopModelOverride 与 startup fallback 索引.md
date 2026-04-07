# `print.ts`、`externalMetadataToAppState`、`setMainLoopModelOverride` 与 `startup fallback` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/166-print.ts、externalMetadataToAppState、setMainLoopModelOverride 与 startup fallback：为什么 print remote recovery 的 transcript、metadata 与 emptiness 不是同一种 stage.md`
- `05-控制面深挖/165-hydrateFromCCRv2InternalEvents、externalMetadataToAppState、hydrateRemoteSession 与 startup fallback：为什么 print resume 的 remote recovery 不是同一种 stage.md`
- `05-控制面深挖/163-print.ts、parseSessionIdentifier、hydrateRemoteSession 与 loadConversationForResume：为什么 print resume 的 parse、hydrate、restore 不是同一种前置阶段.md`

边界先说清：

- 这页不是 remote recovery 总表。
- 这页不是 host family 页。
- 这页只抓 `print` remote 路径里的 transcript、metadata 与 emptiness 三层差异。

## 1. 三层差异

| 层 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| transcript layer | 有没有本地 transcript 文件 | `hydrateFromCCRv2InternalEvents()`、`hydrateRemoteSession()` |
| metadata layer | headless runtime 要不要吃远端 shadow | `externalMetadataToAppState()`、`setMainLoopModelOverride()` |
| emptiness layer | 空结果最后是 startup 还是失败 | `messages.length === 0`、`processSessionStartHooks('startup')` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| remote hydrate 完成就等于 remote recovery 完成 | hydrate 之后还可能有 metadata refill 和 emptiness interpretation |
| 空 transcript 就是 hydrate 失败 | 在 remote/CCR 路径里它还可能落成 startup |
| CCR v2 和 ingress 只是不同的日志入口 | CCR v2 还额外连着 metadata refill 逻辑 |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | transcript hydrate、metadata refill、startup fallback |
| 条件公开 | metadata refill 主要出现在 CCR v2；fallback 只在 remote 空结果里触发 |
| 内部/灰度层 | 某些 metadata 字段和 remote worker state 细节仍可能继续调整 |

## 4. 五个检查问题

- 当前是在写 transcript 文件，还是在回填 AppState？
- 当前空结果被解释成 startup，还是失败？
- 当前是 CCR v2 internal events，还是 ingress logs？
- 我是不是把 emptiness semantics 又写成 hydrate 成败？
- 我是不是把这页重新写回 165 的更宽 remote recovery stage？

## 5. 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/sessionStorage.ts`
- `claude-code-source-code/src/state/onChangeAppState.ts`
- `claude-code-source-code/src/utils/sessionStart.ts`
