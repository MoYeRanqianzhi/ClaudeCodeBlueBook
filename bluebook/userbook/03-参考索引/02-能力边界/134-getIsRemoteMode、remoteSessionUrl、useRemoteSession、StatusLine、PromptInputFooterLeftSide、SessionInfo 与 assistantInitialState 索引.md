# `getIsRemoteMode`、`remoteSessionUrl`、`useRemoteSession`、`StatusLine`、`PromptInputFooterLeftSide`、`SessionInfo` 与 `assistantInitialState` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/145-getIsRemoteMode、remoteSessionUrl、useRemoteSession、StatusLine、PromptInputFooterLeftSide、SessionInfo 与 assistantInitialState：为什么 remote bit 为真但 URL 缺席时，CCR 本体仍可继续，而 link 与 QR affordance 会停摆.md`
- `05-控制面深挖/144-getIsRemoteMode、commands-session、remoteSessionUrl、SessionInfo、PromptInputFooterLeftSide 与 StatusLine：为什么 session 命令的显隐与 pane 内容不是同一种 remote mode.md`
- `05-控制面深挖/143-getIsRemoteMode、setIsRemoteMode、activeRemote、remoteSessionUrl、commands-session 与 StatusLine：为什么全局 remote behavior 开关，不等于 remote presence truth.md`

边界先说清：

- 这页不是 144 的续写版实现笔记。
- 这页不是 viewer / `--remote` 启动流程全图。
- 这页只抓“remote bit 真但 URL 缺席”时的运行时影响面。

## 1. 幸存面 vs 停摆面

| 类型 | 当前代表对象 | 依赖什么 |
| --- | --- | --- |
| 幸存面 | `useRemoteSession` / `activeRemote` / `StatusLine` / startup-notification gate / terminal progress gate / session memory gate / settings watcher gate | `getIsRemoteMode()` 或 `remoteSessionConfig` |
| 停摆面 | `/session` pane / footer remote pill | `remoteSessionUrl` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 没有 `remoteSessionUrl`，就说明当前 remote runtime 没起来 | URL 缺席只先打击 URL 型 affordance |
| `/session` 说 “Not in remote mode”，所以 `getIsRemoteMode()` 一定为假 | 文案可能误报；结构上两者早已分离 |
| footer 没有 remote pill，就说明 CCR 本体坏了 | footer link 只是 URL 投影，不是 runtime 探针 |
| `remoteSessionUrl` 是所有 remote consumer 的共享核心状态 | 全仓直接 runtime consumer 其实非常窄 |

## 3. 启动路径证明

| 路径 | `setIsRemoteMode(true)` | `remoteSessionConfig` | 初始 `remoteSessionUrl` |
| --- | --- | --- | --- |
| `claude assistant` attach / viewer | 会写 | 会创建并传给 REPL | 不显式种下 |
| `claude --remote` TUI | 会写 | 会创建并传给 REPL | 显式种下 |

因此更稳的结论是：

- runtime readiness 与 URL affordance readiness 不是同一个门槛

## 4. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `remote bit` 与 URL 先天分离；assistant viewer 稳定可产生 “bit 真、URL 缺席”；大量 consumer 继续按 remote bit 工作；CCR runtime 继续依赖 config，不依赖 URL |
| 条件公开 | `/session` pane 与 footer remote pill 会在 URL 缺席时停摆；footer 还是 mount-time snapshot，不承诺后续自愈；status-line remote block 会继续存在，但 `session_id` 语义在 viewer path 上还要另看 bootstrap |
| 内部/灰度层 | `/session` fallback 文案把 “URL 缺席” 写成 “Not in remote mode”；`/reload-plugins` 的实现虽然 URL 无关，但 viewer path 上能否进入命令面仍是 reachability 问题 |

## 5. 五个检查问题

- 我现在说的是 runtime 是否活着，还是 URL affordance 是否可展示？
- 我是不是把 `/session` 的 warning 文案误当成系统级 verdict？
- 我是不是忽略了 `useRemoteSession` / `activeRemote` 这条真正的 CCR 运行链路？
- 我是不是把 footer remote pill 当成了 remote health probe？
- 我是不是把 URL 依赖面很窄这件事写丢了？

## 6. 源码锚点

- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/components/StatusLine.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/commands/session/session.tsx`
- `claude-code-source-code/src/hooks/notifs/useStartupNotification.ts`
- `claude-code-source-code/src/components/Messages.tsx`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts`
- `claude-code-source-code/src/utils/settings/changeDetector.ts`
