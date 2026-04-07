# `assistant viewer`、`--remote` TUI、`viewerOnly`、`remoteSessionUrl` 与 `filterCommandsForRemoteMode` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/146-assistant viewer、--remote TUI、viewerOnly、remoteSessionUrl 与 filterCommandsForRemoteMode：为什么同一 coarse remote bit 不等于同样厚度的 remote 合同.md`
- `05-控制面深挖/145-getIsRemoteMode、remoteSessionUrl、useRemoteSession、StatusLine、PromptInputFooterLeftSide、SessionInfo 与 assistantInitialState：为什么 remote bit 为真但 URL 缺席时，CCR 本体仍可继续，而 link 与 QR affordance 会停摆.md`

边界先说清：

- 这页不是 145 的重复摘要。
- 这页不是 `viewerOnly` 参数说明书。
- 这页只抓 assistant viewer 与 `--remote` TUI 的合同厚度差异。

## 1. 共享外壳

| 共享层 | 共同点 |
| --- | --- |
| coarse remote bit | 都会 `setIsRemoteMode(true)` |
| remote config | 都会 `createRemoteSessionConfig(...)` |
| local shell | 都会 `filterCommandsForRemoteMode(commands)` |
| REPL boot | 都会带着 `remoteCommands + remoteSessionConfig` 进入 `launchRepl(...)` |

## 2. 厚度差异

| 维度 | assistant viewer | `--remote` TUI |
| --- | --- | --- |
| config contract | `viewerOnly = true` | 默认非 `viewerOnly` |
| 初始态 | `assistantInitialState`，不显式种下 URL | `remoteInitialState`，显式种下 `remoteSessionUrl` |
| session ownership | 启动分支里不显式 `switchSession(...)` | 显式 `switchSession(asSessionId(createdSession.id))` |
| prompt ownership | 仅 attach info message | info message + 可选 `initialUserMessage` |
| history | `useAssistantHistory` 专门为 `viewerOnly` 打开 | 不走这条 viewer history 合同 |
| title / timeout / interrupt | viewerOnly 收窄 | 本地端保留更多 operator 权限 |

## 3. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 两条路径都 `setIsRemoteMode(true)`，所以它们本质一样 | 它们只共享 coarse remote shell |
| viewer 只是少一个 URL 的 `--remote` TUI | viewer 同时缺少一整组 operator 权限与显示载荷 |
| 命令面一样薄，所以 remote 合同一样厚 | command shell sameness 不能推出 contract thickness sameness |
| `viewerOnly` 只是一个小行为开关 | 它会联动 history、title、timeout、interrupt 等一整组分支 |

## 4. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 两条路径共享 coarse bit 与 remote-safe 命令壳；assistant viewer 明确是 `viewerOnly`；`--remote` TUI 明确种下 URL、显式 `switchSession(...)`、可选带初始 prompt |
| 条件公开 | `--remote` TUI 只有在 remote TUI feature gate 打开时才真的走 REPL 本地 TUI 路径；初始 prompt 也是条件项 |
| 内部/灰度层 | assistant viewer 更像刻意更薄的 remote 合同，但“产品为什么这样分层”仍属于实现推断，不是公开承诺 |

## 5. 五个检查问题

- 我现在写的是共享外壳，还是共享完整合同？
- 我是不是把 `viewerOnly` 低估成了一个小 flag？
- 我是不是把相似的命令面误当成了相同的 ownership？
- 我是不是忽略了 `switchSession`、URL、initial prompt 这些厚载荷？
- 我是不是把 145 的运行时影响表和本页的合同厚度差异混成了一页？

## 6. 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/commands.ts`
- `claude-code-source-code/src/hooks/useAssistantHistory.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
