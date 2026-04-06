# `post_turn_summary` wider-wire visibility 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/105-post_turn_summary、SDKMessageSchema、StdoutMessageSchema、print.ts 与 directConnectManager：为什么它不是 core SDK-visible，却不等于完全不可见.md`
- `05-控制面深挖/100-task_summary、post_turn_summary、SDKMessageSchema、StdoutMessageSchema 与 ccr init clear：为什么 Claude Code 的 summary 不是同一条 transport-lifecycle contract.md`
- `05-控制面深挖/101-lastMessage、outputFormat switch、gracefulShutdownSync、prompt_suggestion 与 session_state_changed(idle)：为什么 headless print 的 result 是最终输出语义，却不是流读取终点.md`

边界先说清：

- 这页不是 summary 总论。
- 这页不替代 100 对 summary family transport/lifecycle 的总分层。
- 这页不替代 101 对 terminal semantics 的拆分。
- 这页只抓 `post_turn_summary` 为什么“不是 core SDK-visible”却“不等于完全不可见”。

## 1. 四层可见性总表

| 层级 | `post_turn_summary` 在这里是什么 | 更接近什么 |
| --- | --- | --- |
| core SDK message surface | 被排除 | not core SDK-visible |
| stdout/control wire surface | 被接纳 | wider-wire admissible |
| `print.ts` terminal semantics | 被过滤 | terminal-inert tail |
| direct-connect callback surface | 被 strip | not callback-visible |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 不在 `SDKMessageSchema` 里，就等于完全不可见 | 它仍在更宽的 `StdoutMessageSchema` 里 |
| 在 `StdoutMessageSchema` 里，就等于普通 SDK message | stdout/control wire 可见性比 core SDK surface 更宽 |
| raw stream 能承载它，所以 `print.ts` 终态也该认它 | `print.ts` 会把它排除在 terminal semantics 外 |
| direct connect 能解析 `StdoutMessage`，callback 就一定能看到它 | manager 会在 callback 暴露前 strip 掉它 |
| 当前源码已经证明它运行时每轮必发 | 当前硬证据是 admissibility + filtering，不是 emission frequency |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 有 schema但不进 core `SDKMessageSchema`；进更宽 `StdoutMessageSchema`；被 `print.ts` 和 `directConnectManager` 过滤 |
| 条件公开 | 只有在实际 emit 且 consumer 读更宽 raw stdout/control wire 时才可能看到；stream-json 原始可见性还受 `--verbose` 约束 |
| 内部/灰度层 | `@internal`、opaque metadata slot、具体 emitter 路径与运行时频率 |

## 4. 六个检查问题

- 当前讨论的是 core SDK surface，还是 wider wire surface？
- 当前说的是 raw admissibility，还是 terminal semantics？
- 当前 consumer 会看到 raw `StdoutMessage`，还是只看到 narrowed callback surface？
- 我是不是把“非 core SDK-visible”写成了“完全不可见”？
- 我是不是把“可以出现在某层”写成了“每轮一定会 emit”？
- 我有没有把 100/101 的广义结论直接搬来，而没继续收窄主语？

## 5. 源码锚点

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts`
- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
