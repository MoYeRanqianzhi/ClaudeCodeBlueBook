# `getSessionId`、`switchSession`、`StatusLine`、`assistant viewer`、`remoteSessionUrl` 与 `useRemoteSession` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/151-getSessionId、switchSession、StatusLine、assistant viewer、remoteSessionUrl 与 useRemoteSession：为什么 remote.session_id 可见，不等于当前前端拥有那条 remote session.md`
- `05-控制面深挖/145-getIsRemoteMode、remoteSessionUrl、useRemoteSession、StatusLine、PromptInputFooterLeftSide、SessionInfo 与 assistantInitialState：为什么 remote bit 为真但 URL 缺席时，CCR 本体仍可继续，而 link 与 QR affordance 会停摆.md`
- `05-控制面深挖/146-assistant viewer、--remote TUI、viewerOnly、remoteSessionUrl 与 filterCommandsForRemoteMode：为什么同一 coarse remote bit 不等于同样厚度的 remote 合同.md`

边界先说清：

- 这页不是所有 `session_id` 字段总表。
- 这页不是 145 的 URL 缺席版重写。
- 这页只抓不同前端为什么不会共享同一张 session identity / ownership ledger。

## 1. 四张 session 身份账

| 账 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| 本地 bootstrap session 账 | 本地 REPL 当前 session 身份 | `getSessionId()`、`switchSession(...)`、`StatusLine.remote.session_id` |
| 远端 attach / transport 账 | 当前实际附着或发送到哪条远端 session | `createRemoteSessionConfig(sessionId, ...)`、`useRemoteSession`、`RemoteSessionManager` |
| 连接入口账 | link / QR / 可分享入口 | `remoteSessionUrl`、footer remote pill、`/session` pane |
| 远端主权账 | 当前前端是否拥有 title / timeout / interrupt 主权 | `viewerOnly`、title update、timeout、cancel |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `remote.session_id` 就是当前远端 session id | 它在 `StatusLine` 里只直接等于本地 `getSessionId()` |
| assistant viewer 的 `remote.session_id` 必然等于 attached target session | viewer attach 用的是 `config.sessionId`，但本地 bootstrap session 未必切过去 |
| 有远端 session 就一定有 `/session` link / QR | 这些入口依赖 `remoteSessionUrl` |
| 附着远端 session 就等于拥有主权 | `viewerOnly` 会收窄 title / timeout / interrupt |

## 3. 宿主视角速查

| 宿主 | session 身份当前更像什么 |
| --- | --- |
| remote TUI (`--remote`) | 本地 `switchSession(createdSession.id)`，多张账更接近对齐 |
| assistant viewer | remote bit 为真，但本地 bootstrap session、transport session、主权账分离 |
| footer remote pill / `/session` | 只认 `remoteSessionUrl` 这张连接入口账 |
| StatusLine hook | 只认本地 `getSessionId()` 这张 bootstrap 账 |

## 4. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `StatusLine` 读本地 session；assistant viewer 不 `switchSession(targetSessionId)`；remote TUI 会 `switchSession(createdSession.id)` |
| 条件公开 | footer remote pill 与 `/session` 只有在 `remoteSessionUrl` 存在时才出现 |
| 内部/灰度层 | 将来 viewer 是否会补独立 remote target session surface 仍可能调整 |

## 5. 五个检查问题

- 我现在写的是本地 bootstrap session，还是 remote transport session？
- 我是不是把 `remote.session_id` 误写成“远端目标 session”的统一真值？
- 我是不是忽略了 `remoteSessionUrl` 是另一张连接入口账？
- 我是不是忽略了 `viewerOnly` 收窄的是主权，而不是 session 是否存在？
- 我是不是又把 145/146 的结论压成一页？

## 6. 源码锚点

- `claude-code-source-code/src/components/StatusLine.tsx`
- `claude-code-source-code/src/bootstrap/state.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/commands/session/session.tsx`
- `claude-code-source-code/src/utils/messages/systemInit.ts`
