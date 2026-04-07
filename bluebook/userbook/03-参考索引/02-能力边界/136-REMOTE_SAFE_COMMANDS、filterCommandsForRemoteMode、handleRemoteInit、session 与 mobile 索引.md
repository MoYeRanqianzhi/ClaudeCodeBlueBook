# `REMOTE_SAFE_COMMANDS`、`filterCommandsForRemoteMode`、`handleRemoteInit`、`session` 与 `mobile` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/147-REMOTE_SAFE_COMMANDS、filterCommandsForRemoteMode、handleRemoteInit、session 与 mobile：为什么 remote-safe 命令面不是 runtime readiness proof.md`
- `05-控制面深挖/146-assistant viewer、--remote TUI、viewerOnly、remoteSessionUrl 与 filterCommandsForRemoteMode：为什么同一 coarse remote bit 不等于同样厚度的 remote 合同.md`

边界先说清：

- 这页不是 safe 命令清单本身。
- 这页不是 `/session` 的重复专题。
- 这页只抓“命令还在”为什么不能推出“runtime 已 ready”。

## 1. 三层对象

| 层 | 当前回答的问题 | 代表 |
| --- | --- | --- |
| allowlist | 哪些命令可以继续留在本地壳里 | `REMOTE_SAFE_COMMANDS` |
| surface assembly | 启动后如何把本地 safe 面与 backend 命令面拼起来 | `filterCommandsForRemoteMode` / `handleRemoteInit` |
| semantic readiness | 某个命令依赖的数据或状态是否真 ready | `remoteSessionUrl`、本地 cost tracker、固定 mobile 下载链接等 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 命令还在，说明 backend 已 ready | 命令还在，只说明 allowlist 允许它留在本地壳里 |
| `REMOTE_SAFE_COMMANDS` 是 remote runtime 的可见证明 | 它是 local-safe affordance allowlist |
| safe 集合里的命令都共享同一种主权与状态依赖 | `/session`、`/mobile`、`/cost` 本来就各不相同 |
| `handleRemoteInit` 保留下来的命令都是 ready 命令 | 它只是做 backend 与 local-safe 的 surface merge |

## 3. 对照例子

| 命令 | 为什么它在 safe 集合里 | 为什么它不是 readiness proof |
| --- | --- | --- |
| `/session` | local-safe JSX 面板 | 真正内容还要看 `remoteSessionUrl` |
| `/mobile` | 本地展示 app 下载二维码 | 依赖固定 app store / play store URL，不是 remote state |
| `/cost` | 本地 cost/accounting 文本命令 | 依赖本地 cost tracker 与订阅身份 |
| `/usage` | 本地 Usage tab JSX | 依赖本地 Settings UI，不是 remote presence |

## 4. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | allowlist 是 safe 壳，不是 readiness 表；`/session`、`/mobile`、`/cost` 等 safe 命令天生异质；CCR remote mode 里只有 `local-jsx` slash 稳定留本地 |
| 条件公开 | 某个命令能否兑现自身语义，要看各自 runtime dependency，不由 safe 壳统一保证；同一个命令在不同入口 policy 下的 “safe” 也可能不同 |
| 内部/灰度层 | backend 最终提供哪些 `slash_commands` 仍是各自 remote backend 的实现细节；bridge/mobile 的 safe 语义比 CCR remote TUI 更接近执行 gate，但这不影响“safe 面 ≠ readiness 证明” |

## 5. 五个检查问题

- 我现在写的是 allowlist，还是 readiness？
- 我是不是把 `/session` 个例偷换成了全体 safe 命令？
- 我是不是忽略了 `/mobile`、`/cost` 这类明显异质的 safe 命令？
- 我是不是把 `handleRemoteInit` 的 surface merge 写成了 semantic proof？
- 我是不是忘了 `BRIDGE_SAFE_COMMANDS` 这种并列 policy 集合的存在？

## 6. 源码锚点

- `claude-code-source-code/src/commands.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/commands/session/index.ts`
- `claude-code-source-code/src/commands/session/session.tsx`
- `claude-code-source-code/src/commands/mobile/index.ts`
- `claude-code-source-code/src/commands/mobile/mobile.tsx`
- `claude-code-source-code/src/commands/cost/index.ts`
- `claude-code-source-code/src/commands/cost/cost.ts`
