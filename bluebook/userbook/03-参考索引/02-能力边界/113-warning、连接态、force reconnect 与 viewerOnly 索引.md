# `warning`、连接态、force reconnect 与 `viewerOnly` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/124-warning、连接态、force reconnect 与 viewerOnly：为什么 recovery signer 不是同一种恢复证明.md`
- `05-控制面深挖/122-timeout watchdog、reconnect warning、reconnecting 与 disconnected：为什么 remote session 的 recovery lifecycle 不是同一种状态.md`
- `05-控制面深挖/123-viewerOnly、history、timeout、Ctrl+C 与 title：为什么 assistant client 不是 session owner.md`

边界先说清：

- 这页不是 recovery lifecycle 页。
- 这页不替代 122。
- 这页不替代 123 的 ownership contract。
- 这页只抓哪些 surface 有资格给 recovery 签字，哪些只是 prompt / action / projection / absence。

## 1. 五个 signer

| signer | 当前回答什么 | 典型位置 |
| --- | --- | --- |
| watchdog warning | owner-side timeout prompt 是否触发 | `createSystemMessage(...warning)` |
| durable connection state | WS lifecycle 当前处于哪一态 | `SessionsWebSocket` / `remoteConnectionStatus` |
| transport action | 是否主动发起 reconnect 动作 | `SessionsWebSocket.reconnect()` |
| brief projection | 当前摘要行如何投影 durable state | `BriefSpinner` / `BriefIdleStatus` |
| mode-conditioned absence | 某张 surface 为什么没出现 | `viewerOnly` / `remoteSessionUrl` / brief 挂载条件 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| warning 出现就说明已经 reconnecting | warning 是 prompt signer，durable authority 另有其人 |
| 调用了 `reconnect()` 就说明 recovery 状态已经成立 | 这是 action edge，不是 durable state signer |
| brief 行就是 recovery 真相面 | brief 只是 projection |
| 没看到 warning 就说明没有 recovery | signer 缺席不等于状态不存在 |
| 没看到 `remote` pill 就说明没有 remote session | attached viewer 路径本来就不一定设置 `remoteSessionUrl` |
| bridge reconnecting 可以直接给 remote session 签字 | 它们属于不同状态家族 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | warning 是 owner-side timeout prompt；transport state machine 更接近 raw authority，`remoteConnectionStatus` 是共享 authority projection；brief 是 projection；`viewerOnly` 切掉 owner-side warning signer 但不等于 shared transport reconnect 消失；bridge 与 remote 是两套 family |
| 条件公开 | warning 只在 `sendMessage()` 后且 `!viewerOnly` 出现；`onReconnecting()` 对应 close/backoff 路；brief 只在 brief-only / idle 等条件下挂载；`remote` pill 只在 `remoteSessionUrl` 被设置时出现 |
| 内部/灰度层 | timeout 常量、retry budget、500ms reconnect delay、warning 文案、某张 projection 当帧是否出现 |

## 4. 五个检查问题

- 我现在写的是 authority、prompt、action，还是 projection？
- 我是不是把某个 UI surface 写成 recovery 真相本身？
- 我是不是把 absence 写成了 opposite？
- 我是不是把 `viewerOnly` 的 skip timeout 写成了没有 reconnect？
- 我是不是把 bridge surface 拿来给 remote session 签字？

## 5. 源码锚点

- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/remote/SessionsWebSocket.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/components/Spinner.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
