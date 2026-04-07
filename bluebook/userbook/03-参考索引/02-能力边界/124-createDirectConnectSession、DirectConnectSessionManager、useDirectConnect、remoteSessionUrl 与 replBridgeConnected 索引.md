# `createDirectConnectSession`、`DirectConnectSessionManager`、`useDirectConnect`、`remoteSessionUrl` 与 `replBridgeConnected` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/135-createDirectConnectSession、DirectConnectSessionManager、useDirectConnect、remoteSessionUrl 与 replBridgeConnected：为什么 direct connect 更像 foreground remote runtime，而不是 remote presence store.md`
- `05-控制面深挖/132-worker_status、external_metadata、AppState shadow 与 SDK event projection：为什么 bridge 能形成 transcript-footer-dialog-store 对齐，而 direct connect、remote session 更多只是前台事件投影.md`

边界先说清：

- 这页不是 direct connect 全量协议页。
- 这页不是 remote session / bridge 总对比页。
- 这页只抓 direct connect 为什么没有长成 dedicated remote presence store。

## 1. direct connect 当前最像什么

| 对象 | 当前最像什么 | 为什么 |
| --- | --- | --- |
| direct connect 启动合同 | foreground interactive transport config | 只有 `session_id / ws_url / work_dir`，没有 presence ledger |
| direct connect 前台消费 | transcript + loading + permission queue | `useDirectConnect()` 只写这三类本地面 |
| direct connect 断线语义 | terminal runtime end | `onDisconnected()` 直接 `gracefulShutdown(1)` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| direct connect 只是 `--remote` 少一个 URL | 它从合同、ledger、disconnect semantics 就不是 viewer presence 设计 |
| transcript 里有远端消息，说明已经有 remote state store | projection 不等于 authoritative ledger |
| bridge footer / dialog 稍微改一下就能复用到 direct connect | 这些 surface 依赖 `remoteSessionUrl` 或 `replBridge*` |
| 断线直接退出只是 UI 没做完 | 这是 foreground runtime 的产品边界 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | direct connect 只返回薄合同；只消费 transcript / loading / permission queue；多类 wire message 被主动过滤；不写 `remoteSessionUrl` / `replBridge*`；断线是 terminal exit |
| 条件公开 | 以后若增加 browser URL、detach / resume、reconnect budget、background-task ledger，才可能自然长出 dedicated remote surface |
| 内部/灰度层 | 当前 filter 列表、未来 reconnect 策略、server 端会话持久化是否会上浮到前台 |

## 4. 五个检查问题

- 我现在写的是 remote interaction，还是 remote presence？
- 我是不是把 transcript projection 偷换成了 shared state ledger？
- 我是不是把 `claude connect <url>` 的前台 TUI，当成了 `--remote` viewer？
- 我是不是忽略了 footer / dialog / `/session` 背后的 authoritative 字段前提？
- 我是不是把 terminal disconnect 误解成“尚未做完的 reconnect UI”？

## 5. 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/server/createDirectConnectSession.ts`
- `claude-code-source-code/src/server/types.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/hooks/useSSHSession.ts`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx`
- `claude-code-source-code/src/commands/session/session.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
