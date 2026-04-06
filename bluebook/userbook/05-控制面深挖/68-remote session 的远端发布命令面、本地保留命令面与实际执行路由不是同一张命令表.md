# `slash_commands`、`REMOTE_SAFE_COMMANDS`、`local-jsx` fallthrough 与 remote send：为什么 remote session 的远端发布命令面、本地保留命令面与实际执行路由不是同一张命令表

## 用户目标

不是只知道 remote session 里同时存在：

- 远端 `system.init.slash_commands`
- 本地 `REMOTE_SAFE_COMMANDS`
- 输入框里的 slash 高亮与 typeahead
- 提交时对 `/xxx` 的路由分流

而是先拆开四个完全不同的问题：

- REPL 刚启动、还没等到远端 `init` 时，本地先露哪些命令？
- 远端发布的 `slash_commands` 到底在本地裁掉了什么，又没有裁掉什么？
- 输入框当前能高亮/补全的命令，是否等于远端真实可执行的命令？
- remote mode 下输入 `/xxx`，到底是本地执行，还是原样发给远端？

如果这四问不先拆开，读者最容易把 remote session 命令系统写成一句错误的话：

- “CCR 发布一张 slash command 表，本地就照着这张表执行。”

源码并不是这样工作的。

## 第一性原理

remote session 里的“命令”至少分裂成三层对象：

1. `Bootstrap Visibility`：REPL 刚挂起时，本地为了避免 race 先保留哪些安全命令。
2. `Published Visibility`：远端 `init.slash_commands` 到来后，本地还允许哪些已知命令继续显形。
3. `Submit Routing`：用户真正按下回车后，这段输入是本地吃掉，还是原样送到 remote。

更稳的提问不是：

- “remote session 现在有哪些 slash commands？”

而是：

- “我现在讨论的是启动期可见命令、本地提示层命令，还是提交时真正决定执行去向的路由层？”

只要这三层没先分开，正文就会把“能看到”“能补全”“会在本地执行”“会被远端执行”压成一张表。

这里也先卡住边界：

- 这页讲的是 remote session 内部的命令可见性与执行路由。
- 不重复 28 页对 remote session client / viewer / bridge host 的工作流拆分。
- 不重复 58 页对 `viewerOnly` ownership 的总论。
- 不重复 67 页对 `slash_commands` 作为一种 remote consumer 的总论。

## 第一层：启动时先暴露的是本地安全命令，不是远端发布命令

### `main.tsx` 在进入 remote session 前先调用 `filterCommandsForRemoteMode(...)`

无论是：

- attach 到 assistant session 的 `viewerOnly` 路径
- 创建新的 remote session 路径

`main.tsx` 都会先做：

- `const remoteCommands = filterCommandsForRemoteMode(commands)`

然后把这组命令作为 `initialCommands` 传进 REPL。

这说明 remote session 一开始回答的问题不是：

- “远端真实支持什么命令？”

而是：

- “在远端 `init` 还没回来前，本地最少保留哪组不会触碰本地工程上下文的安全命令，避免命令面 race 出整套本地 slash commands？”

### `filterCommandsForRemoteMode(...)` 只保留 `REMOTE_SAFE_COMMANDS`

`commands.ts` 里写得很直接：

- `REMOTE_SAFE_COMMANDS` 是一组只影响本地 TUI 状态、不依赖本地文件系统、git、shell、IDE、MCP 的命令。
- `filterCommandsForRemoteMode(commands)` 只做 `commands.filter(cmd => REMOTE_SAFE_COMMANDS.has(cmd))`。

所以 remote session 启动时看到的第一张命令表，本质上是：

- 本地安全控制表

不是：

- 远端已发布能力表

只要这一层没拆开，正文就会把启动时的命令面误写成远端能力镜像。

## 第二层：远端 `slash_commands` 在本地更像“保留过滤器”，不是“注入器”

### `useRemoteSession` 在 `system.init` 时把 `slash_commands` 交给 `onInit(...)`

`useRemoteSession.ts` 在：

- `sdkMessage.type === 'system'`
- `sdkMessage.subtype === 'init'`

时调用：

- `onInit(sdkMessage.slash_commands)`

这说明远端确实发布了一组 slash command 名字。

### 但 `handleRemoteInit(...)` 做的是 `prev.filter(...)`

`REPL.tsx` 的处理不是：

- “把远端发布的新命令塞进本地列表”

而是：

- 基于 `prev` 做 `filter`
- 只保留 `remoteCommandSet.has(cmd.name)` 或 `REMOTE_SAFE_COMMANDS.has(cmd)`

这带来两个关键后果。

#### 后果一：远端 `slash_commands` 不是唯一主权

因为 `REMOTE_SAFE_COMMANDS` 会被强保留，所以即使远端没发布它们，本地安全命令也不会因为这一步被裁掉。

也就是说本地命令面不是：

- 纯远端发布表

而是：

- 远端发布保留集合
- 加上本地强保留安全集合

#### 后果二：远端 `slash_commands` 也不是“自动加命令”的机制

因为 `handleRemoteInit(...)` 用的是：

- `prev.filter(...)`

不是：

- 根据远端名字重新构造一张更大的命令表

所以远端发布的名字只能：

- 保留当前本地已经认识的命令对象

不能：

- 凭空把本地当前列表里没有的命令对象注入出来

在当前实现里，这个结论还更强一层：

- 因为 remote session 进入 REPL 前已经先做过 `filterCommandsForRemoteMode(...)`
- 所以 `init.slash_commands` 至少不会把命令面直接扩成一张新的全远端列表

这比“远端发布一张表，本地直接照抄”更保守。

只要这一层没拆开，正文就会高估 `slash_commands` 在本地的主权。

## 第三层：输入框能高亮/补全什么，不等于远端真实能执行什么

### slash 高亮与 typeahead 都只看当前 `commands`

`PromptInput.tsx` 里：

- slash 高亮先找 `/name`，再用 `hasCommand(commandName, commands)` 过滤。
- `useTypeahead(...)` 也直接消费当前 `commands`。

这说明输入框回答的问题是：

- “本地当前命令提示层认识哪些命令对象？”

而不是：

- “远端最终能执行哪些 slash 输入？”

### 因为提交期路由和提示层不是同一个判定器

`PromptInput` 最终只把输入交给：

- `onSubmitProp(...)`

真正决定去向的是 `REPL.tsx` 的 `onSubmit(...)`。

只要这一层没拆开，读者就会把：

- “补全里看不到”

误判成：

- “远端一定不能执行”

源码并没有给出这种等式。

## 第四层：remote mode 下真正被本地截走的，只有 `local-jsx` 命令

### `REPL.tsx` 明确把 `local-jsx` slash commands 留在本地执行

remote mode 的提交分流逻辑是：

- 如果当前是 remote mode
- 且输入不是一个会命中 `commands` 且类型为 `local-jsx` 的 slash command
- 就把输入包装成 user message，调用 `activeRemote.sendMessage(...)` 发往远端

反过来说，被本地截走的只有一类：

- 当前本地命令表能识别出来的 `local-jsx` 命令

例如注释里直接点名的：

- `/agents`
- `/config`

它们在当前进程渲染 Ink UI，没有远端等价物，所以允许 fall through 到本地 `handlePromptSubmit(...)`。

### prompt 命令与普通文本会直接送 remote

同一段注释也写得很直白：

- `Prompt commands and plain text go to the remote.`

所以提交期真正回答的问题不是：

- “它有没有出现在本地命令提示里？”

而是：

- “它是不是一个被本地识别出的 `local-jsx` 命令；如果不是，就原样送 remote。”

这也是为什么 remote mode 的执行面，比本地提示面更宽。

只要这一层没拆开，正文就会把“命令提示面”和“执行路由面”写成一回事。

## 第五层：所以 remote session 至少有三张不同的“命令表”

更准确地说，本地至少同时维护三张不同意义上的表：

### 1. 启动期保守表

来源：

- `filterCommandsForRemoteMode(...)`

作用：

- 避免在 `init` 到来前短暂暴露整套本地命令

### 2. 提示层保留表

来源：

- `handleRemoteInit(...)`
- 当前 `commands`

作用：

- 决定 slash 高亮与 typeahead 能识别哪些命令对象

### 3. 提交期执行路由表

来源：

- `onSubmit(...)`
- `commands.find(... )?.type === 'local-jsx'`

作用：

- 决定输入留在本地还是原样送 remote

这三张表分别回答：

- 本地先保留什么
- 输入框先认识什么
- 提交后究竟去哪儿执行

它们不是同一个层级。

## 第六层：`viewerOnly` 只是这套机制的条件变体，不会把三层压成一层

assistant attach 路径在 `main.tsx` 里会：

- `createRemoteSessionConfig(..., /* viewerOnly */ true)`
- 同时仍然先做 `filterCommandsForRemoteMode(commands)`

说明 `viewerOnly` 改的是：

- 历史分页
- 标题 ownership
- timeout / interrupt 等控制主权

而不是把命令系统突然改回：

- “远端发布什么，本地就只剩什么”

因此这里更稳的结论是：

- `viewerOnly` 会改变 remote session 的控制合同
- 但不会取消“启动期本地安全表 + 提示层保留表 + 提交期路由表”这三个层次

## 第七层：稳定、条件与内部边界

### 稳定可见

- remote session 启动前会先预过滤命令，避免 race 暴露整套本地 slash commands。
- remote mode 下 `local-jsx` 命令会本地执行，prompt/plain text 会走 remote send。
- 输入框高亮和 typeahead 依赖当前本地 `commands`，不直接等于远端执行面。

### 条件公开

- `system.init.slash_commands` 何时到达、具体带哪些命令名，依赖远端 session 状态。
- `viewerOnly` 只在 attach assistant 等特定路径成立。
- 某条 `/xxx` 能否被本地判成 `local-jsx`，取决于当前 `commands` 是否认识它。

### 内部 / 实现层

- `REMOTE_SAFE_COMMANDS` 的具体成员列表。
- `Set<Command>` 的对象身份匹配方式。
- `commands.find(...)` 的具体别名匹配细节。
- 为什么当前实现选择 `prev.filter(...)` 而不是远端重建一张新命令表。

## 第八层：最容易犯的三种错

### 错一：把远端 `slash_commands` 当成唯一真相

会漏掉：

- 启动期的本地安全命令面
- 本地强保留命令

### 错二：把“补全里看不到”当成“远端不能执行”

会漏掉：

- remote mode 下非 `local-jsx` 输入依然会被原样送 remote

### 错三：把命令提示面和执行路由面写成一层

会漏掉：

- 本地提示层只是一个 UI / discoverability 投影
- 真正执行去向要看 `onSubmit(...)` 的路由判定

## 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/commands.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx`
