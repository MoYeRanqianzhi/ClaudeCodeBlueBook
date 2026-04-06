# streamlined pre-wire rewrite ordering 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/109-createStreamlinedTransformer、structuredIO.write、lastMessage 与 streamlined_*：为什么 headless print 的 streamlined output 不是 terminal semantics 后处理，而是 pre-wire rewrite.md`
- `05-控制面深挖/106-stream-json、verbose、StdoutMessageSchema、SDKMessageSchema 与 lastMessage：为什么 headless print 的 raw wire 输出不是普通 core SDK message surface.md`
- `05-控制面深挖/101-lastMessage、outputFormat switch、gracefulShutdownSync、prompt_suggestion 与 session_state_changed(idle)：为什么 headless print 的 result 是最终输出语义，却不是流读取终点.md`

边界先说清：

- 这页不是 `stream-json` 总论。
- 这页不替代 106 对 raw wire contract 的总分层。
- 这页不替代 101 对 terminal semantics 的拆分。
- 这页只抓 streamlined transformer 为什么发生在 wire write 之前，而不是 terminal semantics 之后。

## 1. 四层对象总表

| 层级 | 在这里回答什么 | 更接近什么 |
| --- | --- | --- |
| streamlined gate | 当前是否启用 rewrite path | conditional mode gate |
| transformer signature | raw message 会被改写成什么 | `StdoutMessage -> StdoutMessage | null` |
| loop write step | 真正写出哪一个对象 | pre-wire rewrite |
| `lastMessage` cursor | 其他模式结尾要靠什么收口 | terminal-semantics cursor |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| streamlined output 是 raw write 之后补的一层显示优化 | transformer 发生在 `structuredIO.write(...)` 之前 |
| 原始 `message` 仍会照常写出，只是又补一条 streamlined message | streamlined 分支写出的就是 transformed object |
| `lastMessage` 决定 streamlined message 写不写 | `lastMessage` 过滤发生在 write 之后，只维护终态 cursor |
| 所有 `stream-json` 都会走 streamlined output | 还受 feature、env var 与 outputFormat gate 约束 |
| `streamlined_*` 只是终端显示别名 | schema 描述与 transformer 行为都表明它们是 replacement family |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | transformer 在 loop 内先运行、先写出；`streamlined_*` 之后又被排除在 `lastMessage` cursor 外 |
| 条件公开 | 只有 gate 打开时才走 streamlined rewrite；并非所有 `stream-json` 都自动如此 |
| 内部/灰度层 | `STREAMLINED_OUTPUT` build feature、`CLAUDE_CODE_STREAMLINED_OUTPUT` env var、具体各 family 的运行时常见度 |

## 4. 六个检查问题

- 当前变换发生在 write 之前，还是之后？
- 当前讨论的是 outgoing wire 对象，还是 terminal final cursor？
- 我是不是把 streamlined 写成了“额外追加”，而不是“替换式 projection”？
- 我是不是把 `lastMessage` 当成了当前路径的主写出器？
- 我是不是把 gate 条件写没了，暗示所有 `stream-json` 都会 streamlined？
- 我有没有把 106 的 raw-wire 总论直接重讲，而没有继续压到 rewrite ordering？

## 5. 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/streamlinedTransform.ts`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
