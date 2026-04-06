# Result terminal semantics vs stream tail 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/101-lastMessage、outputFormat switch、gracefulShutdownSync、prompt_suggestion 与 session_state_changed(idle)：为什么 headless print 的 result 是最终输出语义，却不是流读取终点.md`
- `05-控制面深挖/98-lastMessage stays at the result、SDK-only system events、pendingSuggestion、heldBackResult 与 post_turn_summary：为什么 headless print 的主结果语义不会让给晚到系统事件.md`
- `05-控制面深挖/100-task_summary、post_turn_summary、SDKMessageSchema、StdoutMessageSchema 与 ccr init clear：为什么 Claude Code 的 summary 不是同一条 transport-lifecycle contract.md`

边界先说清：

- 这页不是 suggestion 总论。
- 这页不替代 98 对 semantic last result 的拆分。
- 这页不替代 100 对 summary transport contract 的拆分。
- 这页只抓 `lastMessage`、最终输出、exit semantics 与 raw stream tail 的分层。

## 1. 三层对象总表

| 对象 | 它在回答什么 | 更接近什么 |
| --- | --- | --- |
| `lastMessage` | 终态语义 cursor 是谁 | filtered terminal cursor |
| `result` | 最终答案 / error payload 是什么 | terminal final payload |
| result 之后的 tail frames | 回合是否已 settle、还有什么尾流 | raw stream tail |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `result` 就是最后一个 raw frame | `result` 可以是 terminal final payload，但后面仍可能有尾流 |
| 最后一个流帧等于最终输出语义 | 默认文本 / JSON / exit code 都读 filtered `lastMessage` |
| `prompt_suggestion` 既然属于 `SDKMessage`，就会影响终态判断 | 它 stream-visible，但 terminal-inert |
| `session_state_changed('idle')` 最后到，所以它代表最终答案 | 它是 settled signal，不是 answer payload |
| `post_turn_summary` 有 schema，所以该参与终态判断 | 它不进 core `SDKMessage`，常规路径还会过滤 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `lastMessage` 是 filtered terminal cursor；最终文本/JSON/exit code 都绑在 filtered `result` 上；`result` 不是流读取终点 |
| 条件公开 | `heldBackResult`、`prompt_suggestion`、idle event gate、tail task events 会改变 `result` 后面的 raw tail 厚度 |
| 内部/灰度层 | `post_turn_summary` 的 stdout-vs-SDKMessage split、consumer heuristic、terminal task bookends 细节 |

## 4. 六个检查问题

- 我现在说的“最后”，到底是最后一个 raw frame，还是 terminal cursor？
- 这里需要的是 final answer payload，还是 turn-settled signal？
- 这个对象只是 stream-visible，还是 terminal-semantic？
- 当前 path 走的是默认文本/JSON 收口，还是 raw stream forwarding？
- `result` 后面还有没有 `prompt_suggestion`、idle 或 task bookends 可能继续出现？
- 我是不是把“能在流里看到”误写成了“会改变最终输出和退出语义”？

## 5. 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts`
- `claude-code-source-code/src/utils/sessionState.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
