# `hydrateFromCCRv2InternalEvents`、`externalMetadataToAppState`、`hydrateRemoteSession` 与 `startup fallback` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/165-hydrateFromCCRv2InternalEvents、externalMetadataToAppState、hydrateRemoteSession 与 startup fallback：为什么 print resume 的 remote recovery 不是同一种 stage.md`
- `05-控制面深挖/163-print.ts、parseSessionIdentifier、hydrateRemoteSession 与 loadConversationForResume：为什么 print resume 的 parse、hydrate、restore 不是同一种前置阶段.md`
- `05-控制面深挖/162-main.tsx、print.ts、loadInitialMessages、ResumeConversation 与 REPL.resume：为什么 interactive resume host 与 headless print host 共享恢复语义，却不是同一种宿主族.md`

边界先说清：

- 这页不是 print pre-stage 总表。
- 这页不是 metadata 总表。
- 这页只抓 `print` remote 路径里的 transcript hydrate、metadata refill 与 empty-session fallback。

## 1. 三张账

| 账 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| transcript hydrate 账 | 把远端事件 / 日志写成本地 transcript | `hydrateFromCCRv2InternalEvents()`、`hydrateRemoteSession()` |
| metadata refill 账 | 把 remote worker metadata 回填到 headless runtime | `externalMetadataToAppState()`、`setMainLoopModelOverride()` |
| emptiness semantics 账 | 空 transcript 时决定 startup 还是失败 | `messages.length === 0`、`processSessionStartHooks('startup')` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| remote hydrate 成功就等于恢复完成 | hydrate 之后还可能走 metadata refill，再决定 emptiness semantics |
| 空 transcript 就是 hydrate 失败 | 在 URL / CCR v2 路径里它还可能变成 startup fallback |
| CCR v2 和 ingress 都只是“从远端拿日志” | 两者的数据源和后续状态回填逻辑不同 |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | remote hydrate、metadata refill、startup fallback |
| 条件公开 | metadata refill 主要出现在 CCR v2 路径；startup fallback 只在 remote/URL 空结果里触发 |
| 内部/灰度层 | 某些 metadata 字段回填粒度和 remote reader 细节仍可能继续调整 |

## 4. 五个检查问题

- 当前是在写 transcript 文件，还是在回填 AppState？
- 当前是 CCR v2 internal events，还是 ingress logs？
- 当前空结果被解释成 startup，还是失败？
- 我是不是把 emptiness semantics 误写成 hydrate 成败？
- 我是不是把这页重新写回 163 的 print pre-stage 总链？

## 5. 源码锚点

- `claude-code-source-code/src/utils/sessionStorage.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/state/onChangeAppState.ts`
- `claude-code-source-code/src/utils/sessionStart.ts`
