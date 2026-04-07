# `SDKPostTurnSummaryMessageSchema`、`StdoutMessageSchema`、`SDKMessageSchema`、`print.ts` 与 `directConnectManager` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/140-SDKPostTurnSummaryMessageSchema、StdoutMessageSchema、SDKMessageSchema、print.ts 与 directConnectManager：为什么 post_turn_summary 的 wide-wire、@internal 与 foreground narrowing 不是同一种可见性.md`
- `05-控制面深挖/105-post_turn_summary、SDKMessageSchema、StdoutMessageSchema、print.ts 与 directConnectManager：为什么它不是 core SDK-visible，却不等于完全不可见.md`
- `05-控制面深挖/108-StdoutMessage、SDKMessage、onMessage 与 post_turn_summary：为什么 direct connect 对 summary 的过滤不是消息不存在，而是 callback consumer-path 收窄.md`

边界先说清：

- 这页不是 post_turn_summary 全历史页。
- 这页不是 105 / 108 的合并摘要。
- 这页只抓 `post_turn_summary` 的 visibility ladder。

## 1. 六层 visibility ladder

| 层 | 当前含义 |
| --- | --- |
| schema-visible | `SDKPostTurnSummaryMessageSchema` 正式存在 |
| internal-visible | schema 描述本身带 `@internal` |
| stdout-wire-visible | `StdoutMessageSchema` 接纳它 |
| core-SDK-invisible | `SDKMessageSchema` 不接纳它 |
| callback-invisible | direct connect 在 callback 前主动 strip |
| terminal-semantic-invisible | `print.ts` 不让它进入 `lastMessage` 主结果语义 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `@internal` 就等于完全不可见 | stdout/control wire 仍可承载它 |
| 进了 `StdoutMessageSchema` 就等于普通 core SDK-visible | `SDKMessageSchema` 并没有接纳它 |
| raw stream 能看到它，就等于 terminal foreground 接纳它 | `print.ts` 的 `lastMessage` 语义会继续 narrowing |
| direct connect callback 收不到它，就等于 raw wire 根本不可能有它 | parse layer 和 callback layer 之间还有 consumer-path cut |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | schema 存在；描述带 `@internal`；stdout wire 接纳；core SDK 不接纳；print/directConnect 都主动 narrowing |
| 条件公开 | 运行时是否实际 emit 仍取决于上游；raw stream 是否看到取决于 output/consumer 选择；将来可见层级仍可能扩张 |
| 内部/灰度层 | `@internal` 本身就是灰度信号；wide-wire 与 foreground narrowing 的并存说明它仍处演化带 |

## 4. 五个检查问题

- 我现在写的是 schema existence，还是 foreground consumer visibility？
- 我是不是把 `@internal` 偷换成了“根本不会出现”？
- 我是不是把 raw stream 能看到，偷换成了 terminal semantic 接纳？
- 我是不是把 direct connect callback 收不到，偷换成了 raw wire 不存在？
- 我是不是把 105/108 的结论压回二元可见性，而没写出 visibility ladder？

## 5. 源码锚点

- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
