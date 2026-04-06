# Remote slash discoverability、hidden exact、enabled gate 与 raw-send routing 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/69-hasCommand、isHidden、isCommandEnabled、local-jsx 与 remote send：为什么 remote mode 里的 slash 高亮、候选补全、启用态与实际执行去向不是同一个判定器.md`
- `05-控制面深挖/68-slash_commands、REMOTE_SAFE_COMMANDS、local-jsx fallthrough 与 remote send：为什么 remote session 的远端发布命令面、本地保留命令面与实际执行路由不是同一张命令表.md`
- `05-控制面深挖/11-命令对象、执行语义与可见性：为什么 slash command 不是同一种按钮.md`

边界先说清：

- 这页不是 command object 类型索引。
- 这页不是 remote 命令来源索引。
- 这页只抓 remote mode 下 slash 输入经过的五个判定器。

## 1. 五层判定器总表

| 判定器 | 回答的问题 | 典型实现 |
| --- | --- | --- |
| `Token Detector` | 语法上是不是 slash token | `input.startsWith('/')` / `findSlashCommandPositions(...)` |
| `Command Recognition` | 当前命令对象集合认不认得这个名字 | `hasCommand(...)` |
| `Suggestion Visibility` | 候选 UI 愿不愿意展示它 | `generateCommandSuggestions(...)` + `isHidden` |
| `Enabled Gate` | 此刻它还算不算启用命令 | `isCommandEnabled(...)` |
| `Execution Router` | 本地截走还是原样送 remote | `type === 'local-jsx'` + remote submit path |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 高亮了，就说明当前可本地执行 | 高亮只证明名字能匹配 |
| 候选里没有，说明远端也不会认 | 候选只是一层 UI 可见性 |
| 在 `commands` 里，说明现在还启用 | 提交时还会再过 `isCommandEnabled(...)` |
| slash command 都先由本地解释 | remote mode 下只有启用中的 `local-jsx` 留本地 |
| hidden 就等于永远不可见 | exact hidden match 仍可能被候选回补 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 五层判定器彼此独立；remote mode 只截启用中的 `local-jsx` |
| 条件公开 | `isHidden`、`isEnabled()`、当前 `commands`、当前是否 remote mode |
| 内部/实现层 | Fuse 排序、hidden exact prepend、命令对象热刷新时机 |

## 4. 七个检查问题

- 我现在讨论的是高亮、候选、启用，还是执行去向？
- 这个 `/name` 只是被 `hasCommand(...)` 认出来，还是已通过 `isCommandEnabled(...)`？
- 它是 hidden，所以不建议，还是根本不被识别？
- 它是不是只有在 exact 输入时才会回到候选里？
- 它是不是非 `local-jsx`，所以仍会 raw send？
- 我是不是把 discoverability 写成 executability 了？
- 我是不是把 UI 可见性写成远端解释权了？

## 5. 源码锚点

- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx`
- `claude-code-source-code/src/utils/suggestions/commandSuggestions.ts`
- `claude-code-source-code/src/commands.ts`
- `claude-code-source-code/src/types/command.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
