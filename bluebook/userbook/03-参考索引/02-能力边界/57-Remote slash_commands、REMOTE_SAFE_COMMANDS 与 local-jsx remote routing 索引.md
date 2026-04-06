# Remote `slash_commands`、`REMOTE_SAFE_COMMANDS` 与 `local-jsx` remote routing 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/68-slash_commands、REMOTE_SAFE_COMMANDS、local-jsx fallthrough 与 remote send：为什么 remote session 的远端发布命令面、本地保留命令面与实际执行路由不是同一张命令表.md`
- `05-控制面深挖/67-slash_commands、stream_event、task_started 与 status_compacting：为什么 remote session 的命令集、流式正文、后台计数与 timeout 策略不是同一种消费者.md`
- `05-控制面深挖/58-viewerOnly、hasInitialPrompt、useAssistantHistory 与 updateSessionTitle：为什么 attached assistant REPL 的首问加载、历史翻页与会话标题不是同一种主权.md`

边界先说清：

- 这页不是 remote session 总命令索引。
- 这页不是 slash command 类型学总表。
- 这页只回答 remote mode 下三件事：
  - 启动先露什么。
  - 输入框先认识什么。
  - 提交后到底去哪儿执行。

## 1. 三张“命令表”总表

| 对象 | 回答的问题 | 典型来源 |
| --- | --- | --- |
| `Bootstrap Visibility` | 远端 `init` 前本地先露什么 | `filterCommandsForRemoteMode()` |
| `Published Visibility` | 当前输入框认识哪些命令对象 | `handleRemoteInit()` + `commands` |
| `Submit Routing` | 当前输入最终留本地还是送 remote | `onSubmit()` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| remote `slash_commands` 就是本地命令表 | 本地还会强保留 `REMOTE_SAFE_COMMANDS` |
| 输入框补全里看不到，就说明远端不能执行 | 非 `local-jsx` 输入仍可能原样送 remote |
| slash command 只有一套可见性 | 至少有启动表、提示表、执行路由表三层 |
| `viewerOnly` 会把命令系统完全交给远端 | `viewerOnly` 改控制主权，不抹平三层命令表 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | remote mode 启动先预过滤；`local-jsx` 本地执行；prompt/plain text 走 remote send |
| 条件公开 | `init.slash_commands` 内容、`viewerOnly` 路径、当前 `commands` 能否识别某个 `/xxx` |
| 内部/实现层 | `REMOTE_SAFE_COMMANDS` 成员细节、对象身份匹配、`prev.filter(...)` 的保守实现 |

## 4. 七个检查问题

- 我现在讨论的是启动期命令表、提示层命令表，还是执行路由表？
- 这个 `/xxx` 是本地 `local-jsx`，还是会被原样送 remote？
- 输入框认识它吗？
- 输入框不认识它，是否仍可能被远端执行？
- 我是不是把 `slash_commands` 误写成唯一真相了？
- 我是不是把 `viewerOnly` 误写成“全远端命令主权”了？
- 我是不是把 discoverability 与 executability 混写了？

## 5. 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/commands.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx`
