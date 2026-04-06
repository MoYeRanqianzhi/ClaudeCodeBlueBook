# Remote `disableSlashCommands`、`commands=[]` 与 slash raw-send 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/70-disableSlashCommands、commands=[]、hasCommand 与 remote send：为什么关掉本地 slash 命令层，不等于 remote mode 失去 slash 文本入口.md`
- `05-控制面深挖/69-hasCommand、isHidden、isCommandEnabled、local-jsx 与 remote send：为什么 remote mode 里的 slash 高亮、候选补全、启用态与实际执行去向不是同一个判定器.md`
- `05-控制面深挖/68-slash_commands、REMOTE_SAFE_COMMANDS、local-jsx fallthrough 与 remote send：为什么 remote session 的远端发布命令面、本地保留命令面与实际执行路由不是同一张命令表.md`

边界先说清：

- 这页不是 CLI 参数总索引。
- 这页不是 headless `commandsHeadless` 专题。
- 这页只抓 interactive remote REPL 下 `disableSlashCommands` 的本地后果与远端残余语义。

## 1. 五个直接后果总表

| 对象 | 回答的问题 | 典型结论 |
| --- | --- | --- |
| `Flag Propagation` | 开关从哪来 | `options.disableSlashCommands` 透传到 REPL |
| `Local Command Plane` | 本地命令层还在不在 | `commands=[]` |
| `Prompt UI` | 高亮和候选还在不在 | 基本消失 |
| `Local Bypass` | `local-jsx` 还能不能留本地 | 失效 |
| `Remote Text Ingress` | `/xxx` 还能不能送远端 | 仍可 raw send |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 禁用 slash commands = 禁止 `/` 输入 | 只切本地 slash 命令层，不切斜杠字符本身 |
| 没有候选 = 没有 slash 语义 | 本地 UI 消失，不等于远端文本入口消失 |
| `disableSlashCommands` 只是显示开关 | 它还会影响本地执行去向 |
| `local-jsx` 仍会照常截走 | `commands=[]` 后本地旁路也一起失效 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `commands=[]`、本地 slash UI 消失、remote mode 仍可 raw send |
| 条件公开 | 是否处于 remote mode、远端是否理解 `/xxx`、headless 是否走另一条命令构造 |
| 内部/实现层 | 旗标来源、headless 细分、远端收到文本后的解释逻辑 |

## 4. 七个检查问题

- 我现在讨论的是本地 slash 命令层，还是远端文本入口？
- `commands` 是不是已经被清空？
- 高亮和候选没了，是因为 slash 文本被禁，还是因为本地命令层没了？
- `local-jsx` 旁路是不是已经一起失效？
- 这条 `/xxx` 是否仍会原样送远端？
- 我是不是把本地 discoverability 写成远端 ingress 了？
- 我是不是把“没有本地命令层”写成“没有 slash 语义”了？

## 5. 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx`
- `claude-code-source-code/src/utils/suggestions/commandSuggestions.ts`
- `claude-code-source-code/src/types/command.ts`
