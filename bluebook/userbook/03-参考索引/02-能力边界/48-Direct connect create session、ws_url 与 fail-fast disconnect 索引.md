# Direct connect create session、`ws_url` 与 fail-fast disconnect 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/59-cc__、open、createDirectConnectSession、ws_url 与 fail-fast disconnect：为什么 direct connect 的建会话、直连 socket 与断线退出不是同一种远端附着.md`
- `05-控制面深挖/57-useRemoteSession、useDirectConnect 与 useSSHSession：为什么看起来都是远端 REPL，但连接、重连、权限与退出不是同一种会话合同.md`
- `05-控制面深挖/20-Headless 启动链、首问就绪与 StructuredIO：为什么 print 不是没有 UI 的 REPL.md`

边界先说清：

- 这页不是所有远端入口的总索引
- 这页只抓 direct connect 的建会话、transport locator、工作目录回填与 fail-fast 收口

## 1. 七类对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Entry Rewrite` | 同一个 connect URL 最终进交互态还是 headless | `cc://` / `open <cc-url>` |
| `Session Factory` | 当前是否已向 server 申请创建 session | `createDirectConnectSession(...)` |
| `Session Identity` | 这条 server-side session 叫什么 | `session_id` |
| `Transport Locator` | 真正建立 socket 的地址是什么 | `ws_url` |
| `Workspace Writeback` | 本地 cwd 是否被 server 回写 | `work_dir` |
| `Permission Roundtrip` | 当前支持哪类控制请求 | `can_use_tool` |
| `Failure Policy` | 断线后是重连还是退出 | `Server disconnected.` / `gracefulShutdown(1)` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `cc://` = 已连上的 WebSocket | 它先决定入口壳 |
| 建 session = 已连 transport | `createDirectConnectSession(...)` 先产出 `ws_url` |
| `session_id` = transport 地址 | transport 用 `ws_url` |
| connect 到 server = 本地 cwd 原样保留 | `work_dir` 可改写当前工作目录状态 |
| direct connect 断线 = remote session reconnect | 这条线是 fail fast |
| direct connect 控制面 = 通用 remote controller | 这里只窄支持 `can_use_tool`，并额外能发 `interrupt` |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | direct connect 会先建会话，再用 `ws_url` 直连；`session_id`、`ws_url`、`work_dir` 与断线退出不是同一种对象 |
| 条件公开 | `DIRECT_CONNECT` gate、`cc://` 到 `open` 的分流、`dangerously_skip_permissions` 下传、只支持 `can_use_tool` 的控制面 |
| 内部/实现层 | duplicate init suppression、消息过滤、WebSocket headers cast、逐行 parse 的收发细节 |

## 4. 七个检查问题

- 现在谈的是 URL 入口、session factory，还是 transport 本身？
- 当前看到的是 `session_id` 还是 `ws_url`？
- server 有没有回写 `work_dir`？
- 这是交互态 TUI，还是 headless `open`？
- 当前控制往返是不是只在做 `can_use_tool`？
- 断开后该期待 reconnect，还是直接退出？
- 我是不是又把 direct connect 写成 remote session attach 了？

## 5. 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/server/createDirectConnectSession.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/server/types.ts`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
