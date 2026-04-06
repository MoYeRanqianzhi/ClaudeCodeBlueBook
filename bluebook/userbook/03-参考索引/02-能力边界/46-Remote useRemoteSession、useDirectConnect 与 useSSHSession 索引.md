# Remote `useRemoteSession`、`useDirectConnect` 与 `useSSHSession` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/57-useRemoteSession、useDirectConnect 与 useSSHSession：为什么看起来都是远端 REPL，但连接、重连、权限与退出不是同一种会话合同.md`
- `05-控制面深挖/28-remote 会话、session 命令、assistant viewer 与 remote-safe commands：为什么远端会话 client、viewer 与 bridge host 不是同一种远程工作流.md`
- `05-控制面深挖/30-remoteConnectionStatus、remoteBackgroundTaskCount、BriefIdleStatus 与 viewerOnly：为什么远端会话的连接告警、后台任务与 bridge 重连不是同一张运行态面.md`

边界先说清：

- 这页不是所有 remote 入口的旗标索引
- 这页只抓三种远端会话 hook 的连接、重连、权限与退出合同差异

## 1. 六类对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Shared REPL Shape` | REPL 统一消费的远端接口长什么样 | `isRemoteMode / sendMessage / cancelRequest / disconnect` |
| `Session Ownership Line` | 当前是否在拥有或附着一条 remote session | `useRemoteSession` |
| `Direct Server Socket` | 当前是否直接连到一台 Claude Code server | `useDirectConnect` |
| `SSH Child Process Line` | 当前是否通过 SSH child process 驱动远端 REPL | `useSSHSession` |
| `Reconnect / Exit Contract` | 当前断开后会重连、提示，还是直接退出 | timeout reconnect / fail-fast / stderr shutdown |
| `Authority Surface` | 当前是否拥有 title / interrupt / watchdog / permission contract | `viewerOnly`、`hasInitialPrompt`、`sendInterrupt()` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 三条 hook 形状相同 = 合同相同 | 只是 REPL 统一消费 |
| `useRemoteSession` = `useDirectConnect` | 一个是 session ownership，一个是 server socket |
| `useDirectConnect` = `useSSHSession` | 一个是 WebSocket 直连，一个是 SSH child process |
| 所有远端断线都会先重连 | 三条线的 reconnect / exit 合同不同 |
| 所有远端模式都拥有 title rewrite | 只有部分 remote session owner 才接管 title |
| 所有权限请求都属于同一控制面 | remoteSession 的权限合同比 directConnect/ssh 更宽 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 三条线共享同一个 REPL 四元接口，但连接、重连、权限和退出合同不同 |
| 条件公开 | `viewerOnly` / `hasInitialPrompt` 改写 remote session owner 合同；direct connect 对 unsupported control request 回错；SSH 断开时是否展示 remote stderr 取决于连接历史与 exit code |
| 内部/实现层 | duplicate init suppression、managerRef wiring、auth proxy 创建时机、底层 manager 实现细节 |

## 4. 七个检查问题

- 当前远端 REPL 背后是 session WebSocket、server 直连，还是 SSH child process？
- 这里相同的是接口，还是生命周期？
- 当前客户端是否拥有 title / interrupt / watchdog？
- 断开后是应该重连、提示，还是直接退出？
- 这条线处理的是完整 remote session permission contract，还是最小 permission roundtrip？
- 这里应该展示 server disconnected，还是 remote stderr + exit code？
- 我是不是又把三种远端线写成同一种 remote mode 了？

## 5. 源码锚点

- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/hooks/useSSHSession.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/main.tsx`
