# Direct connect message filtering、`init` dedupe 与 transcript surface 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/61-init、status、tool_result、tool_progress 与 ignored families：为什么 direct connect 的远端消息流不是原样落进 REPL transcript.md`
- `05-控制面深挖/60-can_use_tool、interrupt、result、disconnect 与 stderr shutdown：为什么 direct connect 的控制子集、回合结束与连接失败不是同一种收口.md`
- `05-控制面深挖/59-cc__、open、createDirectConnectSession、ws_url 与 fail-fast disconnect：为什么 direct connect 的建会话、直连 socket 与断线退出不是同一种远端附着.md`

边界先说清：

- 这页不是 direct connect 的建会话索引
- 这页不是 direct connect 的 control subset 索引
- 这页只抓消息过滤、`init` 去重、`tool_result` 转写与 transcript surface

## 1. 七类对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Wire Family` | 远端可能发来什么消息 | `assistant` / `user` / `result` / `system` |
| `Transport Filter` | 哪些家族在 manager 里就被吞掉 | `keep_alive` / `control_response` |
| `Adapter Projection` | 剩余消息会被转成什么 | `message` / `stream_event` / `ignored` |
| `Transcript Message` | 最终会落进正文的离散投影 | `status` / `tool_progress` / `tool_result` |
| `State-Only Signal` | 只改 loading/waiting，不落正文 | success `result` |
| `Init Surface` | 初始化提示来自哪一层 | main system message / deduped `init` |
| `Ignored Family` | 明知收到但故意不显示 | `auth_status` / `rate_limit_event` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| server 发什么，transcript 就显示什么 | 还有 transport 过滤、adapter 投影、hook 收口三层 |
| 所有 `user` 消息都会出现在正文里 | 默认只有 `tool_result` 会被特别转写 |
| success `result` 会显示一条完成消息 | 它通常只收 loading |
| `stream_event` 能转换 = direct connect 会显示流式事件 | 当前 hook 只接 `message` 分支 |
| 每轮 `init` 都会重新显示 | direct connect 只保留首条 `init` |
| 连接成功提示 = 远端 `init` | `Connected to server at ...` 来自 main 本地注入 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | direct connect 的正文只显示双重筛选后的离散事件；普通 user echo 不会重复显示；success `result` 通常不进正文 |
| 条件公开 | `tool_result` 依赖 `convertToolResults`；首条 `init` 保留、后续 suppress；本地连接消息与远端 `init` 是两层不同提示 |
| 内部/实现层 | filtered message families、`hasReceivedInitRef`、unknown type debug、`stream_event` 当前 hook 不消费 |

## 4. 七个检查问题

- 当前说的是 wire family，还是 transcript surface？
- 这条消息在 manager 被吞了，还是在 adapter 被忽略？
- 它会变成正文、overlay，还是纯状态信号？
- 这是普通 user echo，还是 `tool_result`？
- 这是 success `result`，还是 error `result`？
- 这条提示来自 main 注入，还是远端 `init` 投影？
- 我是不是又把 direct connect 写成原样远端流镜像了？

## 5. 源码锚点

- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
