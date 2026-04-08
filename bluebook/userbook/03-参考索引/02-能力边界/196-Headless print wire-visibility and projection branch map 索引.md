# Headless print wire-visibility and projection branch map 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/209-post_turn_summary、StdoutMessage、SDKMessage、stream-json raw wire 与 streamlined_*：为什么 105、106、108、109、110 不是并列尾页，而是从 wider-wire visibility 分叉出去的四种后继问题.md`
- `05-控制面深挖/105-post_turn_summary、SDKMessageSchema、StdoutMessageSchema、print.ts 与 directConnectManager：为什么它不是 core SDK-visible，却不等于完全不可见.md`
- `05-控制面深挖/106-stream-json、verbose、StdoutMessageSchema、SDKMessageSchema 与 lastMessage：为什么 headless print 的 raw wire 输出不是普通 core SDK message surface.md`
- `05-控制面深挖/108-StdoutMessage、SDKMessage、onMessage 与 post_turn_summary：为什么 direct connect 对 summary 的过滤不是消息不存在，而是 callback consumer-path 收窄.md`
- `05-控制面深挖/109-createStreamlinedTransformer、structuredIO.write、lastMessage 与 streamlined_*：为什么 headless print 的 streamlined output 不是 terminal semantics 后处理，而是 pre-wire rewrite.md`
- `05-控制面深挖/110-streamlined_*、post_turn_summary、createStreamlinedTransformer 与 directConnectManager：为什么同样在过滤名单里，却不是同一种 suppress reason.md`

边界先说清：

- 这页不是 105-110 的细节证明总集。
- 这页不替代 209 的分叉结构页。
- 这页只抓“105 是根页，106/108/109 是分叉，110 是交叉叶子”的阅读图。

## 1. 分叉图总表

| 节点 | 作用 | 在图上的位置 |
| --- | --- | --- |
| 105 | 先分 core SDK-visible 与 wider wire-admissible | 根页 |
| 209 | 解释 105/106/108/109/110 的分叉关系 | 结构收束页 |
| 106 | 先分 terminal contract 与 raw wire contract | 分叉 |
| 108 | 先分 parse gate 与 callback contract | 分叉 |
| 109 | 先分 projection artifact 与 terminal post-process | 分叉 |
| 110 | 解释 same skip list 为什么不等于 same suppress reason | 交叉叶子 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 105-110 都在讲哪些消息会不会被看见，所以可以并列读 | 105 是根页；106/108/109 是分叉；110 是交叉叶子 |
| 106 只是 105 的 `stream-json` 附录 | 106 在分 raw wire contract，不在补单对象 visibility ladder |
| 108 只是 105 的 direct-connect 重述 | 108 在分 parse gate 与 callback contract |
| 109 只是显示优化页 | 109 在分 pre-wire projection 与 terminal post-process |
| 110 只是 108/109 的重复证明 | 110 讨论的是 suppress-reason split，不是单对象重述 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 不属于 core SDK-visible 不等于完全不可见；`stream-json --verbose` 是 raw wire contract；direct connect callback 比 parse gate 更窄；streamlined 是 pre-wire projection；same skip list 不等于 same suppress reason |
| 条件公开 | 是否实际 emit 某个 family、consumer 是否真读更宽 raw wire、以及 streamlined gate 是否打开，会改变可见厚度 |
| 内部/灰度层 | `@internal`、skip list 明细、feature/env gate、具体 emitter 路径与运行时频率 |

## 4. 六个检查问题

- 我现在卡住的是 105 的根分裂，还是某个更窄的后继分叉？
- 我现在在问 raw wire、callback contract，还是 projection artifact？
- 我是不是把“能进更宽 wire”误写成了“普通 SDK-visible”？
- 我是不是把 same skip list 写成了 same object class？
- 我是不是把 `streamlined_*` 写成了 raw summary tail？
- 我是不是把 `post_turn_summary` 写成了 projection artifact？

## 5. 源码锚点

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/utils/streamlinedTransform.ts`
