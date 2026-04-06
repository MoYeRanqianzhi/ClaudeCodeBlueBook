# Direct connect `post_turn_summary` callback consumer-path narrowing 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/108-StdoutMessage、SDKMessage、onMessage 与 post_turn_summary：为什么 direct connect 对 summary 的过滤不是消息不存在，而是 callback consumer-path 收窄.md`
- `05-控制面深挖/105-post_turn_summary、SDKMessageSchema、StdoutMessageSchema、print.ts 与 directConnectManager：为什么它不是 core SDK-visible，却不等于完全不可见.md`
- `05-控制面深挖/61-init、status、tool_result、tool_progress 与 ignored families：为什么 direct connect 的远端消息流不是原样落进 REPL transcript.md`

边界先说清：

- 这页不是 `post_turn_summary` 总论。
- 这页不替代 105 对 visibility ladder 的总分层。
- 这页不替代 61 对 direct connect transcript surface 的总拆分。
- 这页只抓 direct connect 里 `post_turn_summary` 为什么是 callback consumer-path narrowing，而不是 message existence denial。

## 1. 四层对象总表

| 层级 | `post_turn_summary` 在这里是什么 | 更接近什么 |
| --- | --- | --- |
| `StdoutMessage` parse gate | 可被承认的更宽 raw ingress family | wider-wire admissible |
| `SDKMessage` callback contract | 不属于普通 callback message set | not callback-contract member |
| manager skip list | 被显式剥离 | forwarding suppression |
| `onMessage(...)` delivery result | 不会被交给 direct-connect callback | consumer-path narrowed |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 过了 `isStdoutMessage(...)` 就一定会进 `onMessage(...)` | parse admissibility 与 callback contract 不是一层 |
| callback 看不到 `post_turn_summary`，所以 wire 上没有 | manager 是在 parse 之后、forward 之前主动 strip |
| direct connect 过滤了它，说明 schema 本来就不允许 | `StdoutMessageSchema` 明确单列接纳 `SDKPostTurnSummaryMessageSchema` |
| 这和 61/105 完全一样 | 61 讲 transcript surface，105 讲 visibility ladder，108 讲 direct-connect callback narrowing |
| 当前源码已经证明 direct connect 每轮都会收到它 | 当前硬证据是 admissibility + filtering，不是 arrival cadence |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `isStdoutMessage(...)` 面向更宽 `StdoutMessage`；`onMessage(...)` 只承诺 `SDKMessage`；manager 显式过滤 `system.post_turn_summary` |
| 条件公开 | 只有 upstream 真的把 `post_turn_summary` emit 到 stdout/control wire，parse widening 才有发挥空间；但 callback 仍不会收到 |
| 内部/灰度层 | `@internal` 标注、具体 emitter 路径、运行时出现频率与其他宿主是否消费 pre-filter raw wire |

## 4. 六个检查问题

- 当前讨论的是 parse gate，还是 callback delivery？
- 当前说的是 `StdoutMessage`，还是 `SDKMessage`？
- 我是不是把 manager-side skip list 写成了 schema-level impossibility？
- 我是不是把 callback 缺席写成了 wire 缺席？
- 我是不是把“允许出现”写成了“保证到达”？
- 我有没有把 61 的 broad transcript 结论直接重讲，而没有继续压到 direct-connect callback narrowing？

## 5. 源码锚点

- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts`
