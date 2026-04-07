# `system/init.slash_commands`、`REMOTE_SAFE_COMMANDS`、`PromptInput`、`REPL`、`processUserInput` 与 `print` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/150-system-init.slash_commands、REMOTE_SAFE_COMMANDS、PromptInput、REPL、processUserInput 与 print：为什么 slash 不是一张命令表，而是声明面、文本载荷与 runtime 再解释的三段合同.md`
- `05-控制面深挖/68-slash_commands、REMOTE_SAFE_COMMANDS、local-jsx fallthrough 与 remote send：为什么 remote session 的远端发布命令面、本地保留命令面与实际执行路由不是同一张命令表.md`
- `05-控制面深挖/69-hasCommand、isHidden、isCommandEnabled、local-jsx 与 remote send：为什么 remote mode 里的 slash 高亮、候选补全、启用态与实际执行去向不是同一个判定器.md`
- `05-控制面深挖/147-REMOTE_SAFE_COMMANDS、filterCommandsForRemoteMode、handleRemoteInit、session 与 mobile：为什么 remote-safe 命令面不是 runtime readiness proof.md`

边界先说清：

- 这页不是 slash 命令总表。
- 这页不是 68/69/147 的改写版。
- 这页只抓 slash 在跨宿主时为什么会从命令声明变成文本 payload，再由目标 runtime 再解释。

## 1. 三段合同

| 段 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| 声明面 | 宿主愿意公布哪些 slash 名字 | `system/init.slash_commands` |
| 文本载荷 | 输入框 / wire 上的原始 `/foo ...` 文本 | `PromptInput`、`sendMessage(content)`、`RemoteMessageContent` |
| runtime 再解释 | 目标宿主决定这段文本是否重新进入 slash 解释链 | `REPL`、`processUserInput`、`skipSlashCommands`、bridge-safe override |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| slash 的问题本质上还是几张命令表 | 还要再加上文本运输和目标 runtime 再解释 |
| `system/init.slash_commands` 就是可执行命令表 | 它只是名字声明面 |
| 输入框能高亮 slash，就说明本地能执行 | 高亮只消费本地命令对象集 |
| remote send 发送的是已解析命令 | wire 上传的是 `content` 文本/块 |
| headless `print` 也会正常解释 slash | 某些入口会直接 `skipSlashCommands: true` |

## 3. 宿主视角速查

| 宿主 | slash 当前更像什么 |
| --- | --- |
| local interactive REPL | 既有命令对象，也可能本地解释 |
| remote `REPL` | `local-jsx` 留本地，其余常作为文本送远端 |
| bridge/mobile | plain-text 默认，bridge-safe slash 例外 |
| headless `print` | 某些注入入口会强制跳过 slash 解释 |

## 4. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `system/init.slash_commands` 是声明面；wire 上传的是文本 `content`；`print` 某些路径会跳过 slash 解释 |
| 条件公开 | bridge/mobile 只对 bridge-safe slash 清除 skip |
| 内部/灰度层 | 哪些宿主将来会继续扩展 safe slash 或更厚的 slash metadata，仍可能调整 |

## 5. 五个检查问题

- 我现在写的是 slash 声明面，还是执行解释面？
- 我是不是把输入框高亮误写成执行主权？
- 我是不是忽略了 wire 上发的是原始 `content`？
- 我是不是忽略了 `skipSlashCommands: true` 会把 slash 纯文本化？
- 我是不是又把 68/69/147 的结论压回“还是几张命令表”？

## 6. 源码锚点

- `claude-code-source-code/src/utils/messages/systemInit.ts`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
- `claude-code-source-code/src/commands.ts`
- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/utils/processUserInput/processUserInput.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/main.tsx`
