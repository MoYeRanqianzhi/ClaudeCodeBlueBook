# `init`、`status`、`tool_result`、`tool_progress` 与 ignored families：为什么 direct connect 的远端消息流不是原样落进 REPL transcript

## 用户目标

不是只知道 direct connect 里：

- 会显示一条连接成功消息
- 有时会看到 `Remote session initialized`
- 有时会看到 `Status: ...`
- 有时 tool result 会出现在 transcript 里
- 但很多远端事件根本没显示

而是先拆开七类不同对象：

- 哪些是在说 wire 上真实收到的远端消息家族。
- 哪些是在说 transport 层先过滤掉一批根本不上浮的消息。
- 哪些是在说 adapter 会把某些 SDK 消息投影成本地 transcript 消息。
- 哪些是在说即便 adapter 能产出 `stream_event`，direct connect 也不会把它接进流式 UI 管线。
- 哪些是在说远端 `user` 消息只有 `tool_result` 会被保留下来，普通 prompt echo 会被忽略。
- 哪些是在说 success `result` 只用于收 loading，不进入 transcript。
- 哪些是在说用户看到的“连接成功”本来就来自 main 注入的本地 system message，而不是远端原样回显。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“远端消息”：

- `init`
- `status`
- `compact_boundary`
- `tool_progress`
- `tool_result`
- `stream_event`
- `post_turn_summary`
- `control_response`
- `keep_alive`
- `auth_status`
- `rate_limit_event`

## 第一性原理

direct connect 的“我在 transcript 里最终看到什么”至少沿着六条轴线分化：

1. `Wire Family`：远端实际发来了哪一类 SDK message。
2. `Transport Filter`：socket manager 会不会先在消息线入口就把它吞掉。
3. `Adapter Projection`：剩余消息会被转成 `message`、`stream_event`，还是 `ignored`。
4. `REPL Sink`：就算 adapter 产出了东西，`useDirectConnect` 到底接不接。
5. `Transcript Surface`：最终显示在正文里的是 assistant/user/system 哪一类投影。
6. `State-Only Signal`：当前只是拿来关 loading、开 waiting、写 stderr，还是会进入 transcript。

因此更稳的提问不是：

- “server 发什么，REPL 不就显示什么吗？”

而是：

- “当前这条远端事件是在 wire 上存在、在 transport 被过滤、在 adapter 被忽略、还是被投影成 transcript；它回答的是正文内容、回合状态，还是纯内部信号？”

只要这六条轴线没先拆开，正文就会把 direct connect 写成“远端 stdout 的原样镜像”。

这里也要主动卡住几个边界：

- 这页讲的是 direct connect 的消息过滤与 transcript surface。
- 不重复 59 页对 session factory、`ws_url` 与 `work_dir` 的拆分。
- 不重复 60 页对 `can_use_tool`、`interrupt`、`result`、disconnect 与 stderr shutdown 的收口语义。
- 不重复 57 页对三种 remote hook 的总比较。

## 第一层：wire 上存在的消息家族，比 transcript 最终看见的多得多

### adapter 明确认识多种 SDK message

`sdkMessageAdapter.ts` 至少为这些家族写了分支：

- `assistant`
- `user`
- `stream_event`
- `result`
- `system`
- `tool_progress`
- `auth_status`
- `tool_use_summary`
- `rate_limit_event`
- unknown default

这说明协议层回答的问题不是：

- “正文最终该显示什么”

而是：

- “当前远端可能发来哪些类型的事件”

### 但这不等于 direct connect 会把它们原样交给 REPL

因为在 adapter 之前，`DirectConnectSessionManager` 已经先过滤一层；在 adapter 之后，`useDirectConnect` 又只接其中一部分。

只要这一层没拆开，正文就会把“协议认识哪些消息”和“REPL 最终显示哪些消息”写成同一层。

## 第二层：transport 先吞掉一批消息，它们根本到不了 transcript 决策层

### manager 会在 message 入口就过滤多个家族

`directConnectManager.ts` 对普通转发前会先跳过：

- `control_response`
- `keep_alive`
- `control_cancel_request`
- `streamlined_text`
- `streamlined_tool_use_summary`
- `system.post_turn_summary`

这说明这些对象回答的问题不是：

- “当前用户正文该看到什么”

而是：

- “transport / control 协议需要什么内部信号”

### 所以“没显示在 transcript”很多时候不是 adapter 忽略，而是 transport 根本没上抛

更准确的理解应是：

- 第一层遗漏：被 manager 直接截掉
- 第二层遗漏：进了 adapter 但返回 `ignored`

只要这一层没拆开，正文就会把所有“看不见”都归因成 adapter 的忽略规则。

## 第三层：adapter 会把远端消息投影成 transcript，但不是每一类都会保留

### assistant、status、compact boundary、tool progress 会变成可见消息

`sdkMessageAdapter.ts` 里：

- `assistant` -> assistant message
- `system.init` -> informational system message
- `system.status` -> informational system message
- `system.compact_boundary` -> compact boundary system message
- `tool_progress` -> informational system message

这说明它们回答的问题是：

- “当前这类远端事件能否被投影进 REPL 正文”

### success `result` 与若干 SDK-only 消息则会被刻意忽略

同一个 adapter 又明确写了：

- success `result` -> `ignored`
- `auth_status` -> `ignored`
- `tool_use_summary` -> `ignored`
- `rate_limit_event` -> `ignored`
- unknown -> `ignored`

而只有 error `result` 才会被转成 warning system message。

只要这一层没拆开，正文就会把：

- “远端发过”
- “正文应该显示”

写成同一个判断。

## 第四层：`user` 消息并不等于“远端 prompt echo”，direct connect 只偏爱 `tool_result`

### adapter 对 `user` 的处理是条件性的

`sdkMessageAdapter.ts` 会先看 `msg.message.content` 里是否有：

- `tool_result`

如果有，并且 `convertToolResults` 打开，就把它转成可渲染的本地 `UserMessage`。

如果只是普通用户文本，默认：

- `ignored`

因为 live 模式下本地 REPL 早就把用户输入加进 transcript 了。

### 所以 direct connect 的 transcript 不是“远端把用户说过的话再 echo 一遍”

更准确的理解应是：

- 普通用户 prompt：本地已经有，不再重复展示
- 远端工具结果：需要显式转成可见 user message，才能像本地工具结果一样渲染/折叠

只要这一层没拆开，正文就会把所有 `user` family 都写成“用户原话回显”。

## 第五层：`stream_event` 在 adapter 里有定义，但 direct connect 这条线不把它接到流式 transcript

### adapter 能产出 `stream_event`

`sdkMessageAdapter.ts` 明确存在：

- `stream_event` -> `StreamEvent`

这说明从协议与 adapter 角度，它是被认识的对象。

### 但 `useDirectConnect` 只消费 `converted.type === 'message'`

`useDirectConnect.ts` 的关键收口非常硬：

- `const converted = convertSDKMessage(...)`
- only if `converted.type === 'message'` then `setMessages(...)`

这说明 direct connect 这条线回答的问题不是：

- “流式事件存在不存在”

而是：

- “本地这条 hook 是否愿意把它接进当前 REPL 的显示链”

只要这一层没拆开，正文就会把“adapter 能转”和“当前 hook 会显示”写成同一件事。

## 第六层：`init` 不是一条持续刷新的远端状态面，它在 direct connect 里只保留第一条

### hook 明知 server 会重复发 `init`，但只保留首条

`useDirectConnect.ts` 里明确写了：

- server sends one per turn
- duplicate `init` 要 suppress

实现上靠的是：

- `hasReceivedInitRef`

这说明 `init` 在 direct connect 回答的问题不是：

- “每轮远端状态都要完整展示一次”

而是：

- “给这条会话一个一次性的初始化提示就够了”

### 这也解释了为什么“连上时的成功提示”与“远端 init 提示”不是同一来源

交互态一开始还有一条来自 `main.tsx` 的本地 system message：

- `Connected to server at ...`

因此用户看到的提示面至少分成两类：

- 本地启动时注入的连接消息
- 远端 `init` 被 adapter 投影出的初始化消息

只要这一层没拆开，正文就会把所有“开场提示”都写成远端原样回显。

## 第七层：transcript surface 与状态面不是同一个东西

### 有些远端事件进正文，有些只改 loading / waiting

当前这条线至少分成三种用户可见面：

- transcript 消息：assistant / status / compact boundary / tool progress / tool result / error result
- overlay：permission request
- 状态信号：loading / waiting / stderr disconnect

这说明它回答的问题不是：

- “当前 server 的完整状态是什么”

而是：

- “当前这条远端事件最终落到了哪一个用户面”

### 所以 direct connect 更像“离散投影”，不是持续状态板

更准确的理解应是：

- 正文里看到的是经过选择后的离散事件
- 不是 server 内部状态的完整镜像

只要这一层没拆开，正文就会把 direct connect 写成一张持续更新的远端状态面板。

## 第八层：stable、conditional 与 internal 三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | direct connect 的 transcript 只显示被 transport 与 adapter 双重保留后的消息；普通 user echo 不会重复进正文；success `result` 通常只收 loading，不落正文 |
| 条件公开 | `tool_result` 只有在 `convertToolResults` 打开时才会进 transcript；`init` 只保留第一条；连接成功消息来自 main 注入，不是远端 `init` 本体 |
| 内部/实现层 | `post_turn_summary` 过滤、`hasReceivedInitRef` 去重、unknown type debug logging、为什么 `parent_tool_use_id` 不可靠、`stream_event` 虽可转换但当前 hook 不消费 |

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| server 发什么，transcript 就显示什么 | direct connect 有 transport 过滤 + adapter 投影 + hook 收口三层筛选 |
| 远端所有 `user` 消息都会显示在正文里 | 默认只偏爱 `tool_result`；普通 prompt echo 会被忽略 |
| success `result` 会显示一条“本轮成功结束”消息 | 它通常只负责把 loading 关掉 |
| `stream_event` 在 adapter 里能转，REPL 就一定会显示 | `useDirectConnect` 只接 `message` 分支 |
| 每轮 `init` 都会持续刷新远端状态 | direct connect 只保留首条 `init` |
| “Connected to server at ...” 就是远端初始化消息 | 这条是 main 注入的本地 system message |

## 七个检查问题

- 当前说的是 wire 上收到什么，还是最终正文显示什么？
- 这条远端消息是在 transport 被截掉，还是在 adapter 被忽略？
- 它会变成 transcript message、overlay，还是纯状态信号？
- 当前 `user` family 是普通 prompt echo，还是 `tool_result`？
- 这是 success `result`，还是会落 warning 的 error `result`？
- 这条开场提示来自 main 本地注入，还是远端 `init` 投影？
- 我是不是又把 direct connect 写成原样远端消息镜像了？

## 源码锚点

- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
