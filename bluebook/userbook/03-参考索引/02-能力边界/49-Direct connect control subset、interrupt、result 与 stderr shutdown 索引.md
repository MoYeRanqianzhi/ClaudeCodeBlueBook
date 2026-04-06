# Direct connect control subset、`interrupt`、`result` 与 stderr shutdown 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/60-can_use_tool、interrupt、result、disconnect 与 stderr shutdown：为什么 direct connect 的控制子集、回合结束与连接失败不是同一种收口.md`
- `05-控制面深挖/59-cc__、open、createDirectConnectSession、ws_url 与 fail-fast disconnect：为什么 direct connect 的建会话、直连 socket 与断线退出不是同一种远端附着.md`
- `05-控制面深挖/57-useRemoteSession、useDirectConnect 与 useSSHSession：为什么看起来都是远端 REPL，但连接、重连、权限与退出不是同一种会话合同.md`

边界先说清：

- 这页不是 direct connect 的建会话索引
- 这页只抓 direct connect 的控制子集、权限投影、turn end 与 stderr shutdown 分叉

## 1. 七类对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Protocol Family` | SDK 理论上允许哪些控制请求 | `initialize` / `interrupt` / `can_use_tool` |
| `Implemented Subset` | direct connect 实际正式承接哪些 | `can_use_tool` |
| `Permission Projection` | 远端权限请求怎样变成本地 UI | synthetic assistant message / tool stub |
| `Turn Cancel` | 当前是不是只取消这轮 | `interrupt` |
| `Turn End` | 当前是不是只结束当前回合 | `result` |
| `Transport Failure` | 当前是不是 socket 真正死亡 | `Server disconnected.` |
| `Visible Surface` | 这条事件会出现在 transcript / overlay / stderr 哪一层 | message / `PermissionRequest` / stderr |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| unsupported `control_request` = 消息处理坏了 | 这是 direct connect 故意保留的窄支持面 |
| 权限弹层 = 远端 transcript 正文 | 这是本地权限投影 |
| `interrupt` = disconnect | 一个停当前回合，一个是连接关闭 |
| `result` = transport end | 一个是回合结束，一个是连接死亡 |
| stderr 断线文案 = 远端 stderr 原文 | 这是 hook 本地投影 |
| UI 没显示某个协议事件 = 协议上没发生 | 可能只是被过滤掉了 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | direct connect 只正式承接窄控制子集；`interrupt`、`result`、stderr shutdown 不是同一种收口 |
| 条件公开 | unknown tool 会退化为 stub；连接前失败与连接后掉线的提示不同；remote mode 下 `Escape` 才走 interrupt |
| 内部/实现层 | synthetic assistant message、duplicate init suppression、filtered message families、debug-only `onError` |

## 4. 七个检查问题

- 当前说的是协议全集，还是 direct connect 的实现子集？
- 这是 transcript，还是本地合成的权限投影？
- 现在是 interrupt 当前回合，还是 transport 已经关了？
- 这是 `result`，还是 socket death？
- 当前可见提示来自 overlay、stderr，还是 transcript？
- 这是协议上无事发生，还是只是被过滤掉？
- 我是不是又把 direct connect 写成完整 remote control plane 了？

## 5. 源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/remote/remotePermissionBridge.ts`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
