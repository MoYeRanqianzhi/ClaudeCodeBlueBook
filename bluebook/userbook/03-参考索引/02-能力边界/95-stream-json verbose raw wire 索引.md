# `stream-json --verbose` raw wire 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/106-stream-json、verbose、StdoutMessageSchema、SDKMessageSchema 与 lastMessage：为什么 headless print 的 raw wire 输出不是普通 core SDK message surface.md`
- `05-控制面深挖/20-Headless 启动链、首问就绪与 StructuredIO：为什么 print 不是没有 UI 的 REPL.md`
- `05-控制面深挖/105-post_turn_summary、SDKMessageSchema、StdoutMessageSchema、print.ts 与 directConnectManager：为什么它不是 core SDK-visible，却不等于完全不可见.md`

边界先说清：

- 这页不是 `stream-json` 入门。
- 这页不替代 20 对协议流入口语义的拆分。
- 这页不替代 105 对 `post_turn_summary` 单对象可见性层级的拆分。
- 这页只抓 `stream-json --verbose` 为什么面对的是 wider raw wire，而不是普通 core `SDKMessage` surface。

## 1. 三层对象总表

| 层级 | 在这里回答什么 | 更接近什么 |
| --- | --- | --- |
| default text/json | 最终如何收口 | terminal contract |
| `stream-json --verbose` | 消息怎样逐条向外转发 | raw wire contract |
| core `SDKMessage` surface | public/common SDK consumer 默认面对什么 | narrower public surface |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `stream-json --verbose` 就是在不断打印 ordinary `SDKMessage` | 它更接近 wider stdout/control wire |
| 它只是默认 JSON 模式多打几行日志 | 默认 json/text 是终态收口；它是 continuous raw forwarding |
| `lastMessage` 过滤掉的对象就不会出现在这个模式里 | raw `message` 已在循环中先被逐条写出 |
| `--verbose` 只是调试厚度 | 在这里它是 raw-wire contract 的开启条件 |
| 这条路径只会看到 public SDK API 的对象 | builder/control transport 面本来就比 public core SDK surface 更宽 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `stream-json` 需要 `--verbose`；该模式逐条 raw write；默认 text/json 与它主语不同 |
| 条件公开 | 上游实际 emit 什么、是否开启 streamlined transformer，会改变 raw wire 的可见厚度 |
| 内部/灰度层 | `StdoutMessage` 具体类型、control builder 子路径、各 raw family 的运行时常见度 |

## 4. 六个检查问题

- 当前输出面对的是终态收口，还是 raw wire forwarding？
- 这里说的是 public core SDK surface，还是 builder/control wire surface？
- `lastMessage` 此时是在控制“写什么”，还是只在维护别的模式需要的终态 cursor？
- 我是不是把 `--verbose` 当成了装饰参数？
- 我是不是把 `stream-json` 写成了“普通 JSON 模式增强版”？
- 我有没有把对象 family 目录学，误写成了这页的主轴？

## 5. 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts`
- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts`
