# streamlined dual-entry gate、passthrough 与 null suppression 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/112-shouldIncludeInStreamlined、assistant-result 双入口、streamlined_* 与 null：为什么 streamlined path 的纳入 gate、替换入口与抑制返回不是同一种消息简化.md`
- `05-控制面深挖/109-createStreamlinedTransformer、structuredIO.write、lastMessage 与 streamlined_*：为什么 headless print 的 streamlined output 不是 terminal semantics 后处理，而是 pre-wire rewrite.md`
- `05-控制面深挖/111-controlSchemas、agentSdkTypes、directConnectManager、useDirectConnect 与 sdkMessageAdapter：为什么 builder transport、callback surface 与 UI consumer 不是同一张可见性表.md`

边界先说清：

- 这页不是 streamlined 总论。
- 这页不替代 109 对 pre-wire rewrite 时序的拆分。
- 这页不替代 111 对多层 visibility table 的拆分。
- 这页只抓 `shouldIncludeInStreamlined(...)`、assistant/result 双入口与 `null` suppression 为什么不是同一种消息简化。

## 1. 四层对象总表

| 层级 | 在这里回答什么 | 更接近什么 |
| --- | --- | --- |
| `shouldIncludeInStreamlined(...)` | 谁值得进入 streamlined 候选集 | coarse inclusion gate |
| `assistant` 分支 | 要改写成什么或是否不输出 | rewrite-or-null branch |
| `result` 分支 | 是否保留原对象 | passthrough branch |
| `null` 返回 | 当前对象是否不进入 outgoing projection | suppression branch |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 被 gate 纳入就等于都会被简化成同一种输出 | gate 与 transform action 不是一层 |
| `result` passthrough 和 `null` suppression 都只是“没做转换” | passthrough 仍会写出对象，suppression 则不写 |
| `null` 是更激进的简化 | 在当前控制流里它表示 no outgoing projection |
| `assistant` 统一变成一种更短消息 | 它还会在 text summary、tool summary 与 no output 间分流 |
| helper gate 就等于当前 runtime emit 规则 | 当前主循环直接调用的是 transformer |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | gate 只纳入 `assistant`/`result`；assistant 分支 rewrite-or-null；result 分支 passthrough；其他 family suppression |
| 条件公开 | assistant 是否产生 `streamlined_text` 或 `streamlined_tool_use_summary` 还取决于文本与累计工具状态；整条 path 还受 streamlined gate 约束 |
| 内部/灰度层 | helper 是否在其他宿主复用、各 family 的运行时常见度、为什么某些 family 不被纳入 |

## 4. 六个检查问题

- 当前说的是 gate，还是纳入后的动作？
- 我是不是把 inclusion 直接写成了 same simplification？
- 我是不是把 passthrough 和 suppression 都写成“没变化”？
- 我是不是把 `null` 写成了“极简输出”？
- 我是不是把 helper 直接等同于当前 runtime emit contract？
- 我有没有把 109 的时序结论直接重讲，而没继续压到 action taxonomy？

## 5. 源码锚点

- `claude-code-source-code/src/utils/streamlinedTransform.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
