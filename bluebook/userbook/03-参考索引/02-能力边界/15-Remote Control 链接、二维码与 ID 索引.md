# Remote Control 链接、二维码与 ID 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/26-Connect URL、Session URL、Environment ID、Session ID 与 remoteSessionUrl：为什么 remote-control 的链接、二维码与 ID 不是同一种定位符.md`
- `05-控制面深挖/25-Settings、remote-control 命令、Footer 状态 pill 与 Bridge Dialog：为什么 bridge 的默认配置、当前开关与连接展示不是同一个按钮.md`
- `05-控制面深挖/24-remoteControlAtStartup、CCR Mirror、Perpetual Session 与 --continue：为什么 bridge 的 auto、mirror、resume 不是同一种重连.md`

## 1. 五类定位符总表

| 对象 | 回答的问题 | 典型 surface |
| --- | --- | --- |
| `connectUrl` | 这个 bridge environment 该从哪里接入 | BridgeDialog、disconnect dialog、standalone bridge banner / QR |
| `sessionUrl` | 当前已附着的 session 在哪里打开 | BridgeDialog、disconnect dialog、standalone single-session bridge |
| `environmentId` | 当前 environment 的调试标识是什么 | verbose dialog、control response |
| `sessionId` | 当前 session 的调试标识是什么 | verbose dialog |
| `remoteSessionUrl` | `--remote` 模式的远端会话在哪里打开 | footer 左侧 remote pill、`/session` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| connect URL = 当前会话链接 | 一个指 environment，一个指 session |
| 二维码永远应该指向 session | single-session / multi-session / ready-state 会改变目标对象 |
| `environmentId` = `sessionId` | 一个标识 environment，一个标识当前 session |
| `remoteSessionUrl` = `replBridgeSessionUrl` | 一个属于 `--remote` 模式，一个属于 always-on bridge |
| 看见一个 URL 就够了 | 不同 surface 可能同时需要 connect 与 session 两种定位符 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | BridgeDialog URL / QR、`--remote` 的 `remoteSessionUrl`、`/session` |
| 条件公开 | single-session vs multi-session 的 QR 切换、`sessionActive` 驱动的 displayUrl 切换、env-less v2 时 connect URL 可能缺失 |
| 内部/实现层 | `replBridgeConnectUrl`、`replBridgeSessionUrl`、`replBridgeEnvironmentId`、`replBridgeSessionId` 的具体赋值时机 |

## 4. 七个高价值判断问题

- 这个定位符指向的是 environment，还是 session？
- 它属于 always-on bridge，还是 `--remote` 模式？
- 当前展示面是在 ready / idle，还是 attached / active？
- 这个内容是用户要打开的 URL，还是调试 ID？
- 当前二维码为什么指向它，而不是另一种 URL？
- 我现在看的，是 bridge session URL，还是 `remoteSessionUrl`？
- 我是不是把链接、二维码和 ID 又写成了一种“远控地址”？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/bridgeStatusUtil.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/components/BridgeDialog.tsx`
- `claude-code-source-code/src/commands/bridge/bridge.tsx`
- `claude-code-source-code/src/bridge/bridgeUI.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/commands/session/session.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
