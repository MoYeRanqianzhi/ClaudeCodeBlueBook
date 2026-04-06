# `disableSlashCommands`、`commands=[]`、`hasCommand` 与 `remote send`：为什么关掉本地 slash 命令层，不等于 remote mode 失去 slash 文本入口

## 用户目标

不是只知道有一个：

- `disableSlashCommands`

旗标

而是先拆开它到底关掉了什么、又没有关掉什么：

- 它是不是只关掉本地 slash 命令 UI？
- 它是不是也关掉本地 slash 命令识别？
- 它会不会顺带关掉 `local-jsx` 的本地旁路？
- 它是否让 remote mode 再也不能输入 `/xxx`？
- 还是说 `/xxx` 仍然可以作为普通文本原样发给远端？

如果这些问题不先拆开，读者最容易把这个开关写成一句过度绝对的话：

- “禁用 slash commands 以后，系统就没有 slash 输入能力了。”

源码并不是这样工作的。

## 第一性原理

`disableSlashCommands` 影响的是：

- 本地 REPL 里那套由 `commands` 数组支撑的 slash UI / 识别 / 本地拦截层

它不直接改写的是：

- 输入文本是不是以 `/` 开头
- remote mode 下这段文本能不能被原样送到远端

更稳的提问不是：

- “slash commands 还在不在？”

而是：

- “本地 slash 命令层是否还在，以及远端 slash 文本入口是否还在，这两层是不是同一个开关？”

只要这两层没先分开，正文就会把：

- 本地 slash UI 消失

误写成：

- slash 语义整体消失

这里也先卡住边界：

- 这页讲的是 interactive REPL 里的 remote mode。
- 不重复 69 页对 slash 判定器链的总论。
- 不重复 68 页对远端发布命令面 / 本地保留命令面的总论。
- 不展开 headless `commandsHeadless` 的非交互分支，只把它留作边界提醒。

## 第一层：`disableSlashCommands` 是从入口透传进 REPL 的显式开关

### `main.tsx` 直接从 `options.disableSlashCommands` 取值

`main.tsx` 明确做了：

- `const disableSlashCommands = options.disableSlashCommands || false`

这说明它不是：

- REPL 运行时自己推导出的状态

而是：

- 启动入口显式传入的控制旗标

### remote session 路径也会带着它进入 `launchRepl(...)`

无论是：

- attach assistant session
- 创建新的 remote session

`main.tsx` 都会在 `launchRepl(...)` 的参数里继续传：

- `disableSlashCommands`

这说明 remote mode 并不会绕过这个开关。

只要这一层没拆开，读者就会把它误写成“只有本地 REPL 才有的隐藏状态”。

## 第二层：它切掉的是 `commands` 数组，而不是输入框里的 `/`

### `REPL.tsx` 在合并本地、插件、MCP 命令后，直接把 `commands` 置成 `[]`

`REPL.tsx` 先做：

- `localCommands`
- `plugins.commands`
- `mcp.commands`

的合并

然后立刻用：

- `const commands = useMemo(() => disableSlashCommands ? [] : mergedCommands, ...)`

把结果整体替换掉。

这说明 `disableSlashCommands` 回答的问题不是：

- “输入框里还允不允许用户敲 `/`？”

而是：

- “本地 REPL 还持不持有一套命令对象集合去支持 slash UI 和本地命令分流？”

### 所以被切掉的是“本地命令层”，不是“斜杠字符本身”

只要这一层没拆开，正文就会把：

- `commands=[]`

误写成：

- slash 输入整体被语法禁止

源码并没有做这种语法级封禁。

## 第三层：`PromptInput` 的 slash 高亮和候选补全会一起塌掉

### 高亮层依赖 `hasCommand(commandName, commands)`

`PromptInput.tsx` 的高亮逻辑是：

- 先找 slash token
- 再用 `hasCommand(commandName, commands)` 过滤

当 `commands=[]` 时：

- 没有任何 `/name` 能通过这个过滤

所以蓝色 slash 高亮会消失。

### 候选层依赖 `useTypeahead({ commands })`

`PromptInput.tsx` 把当前 `commands` 原样交给：

- `useTypeahead(...)`

而 `generateCommandSuggestions(...)` 在 bare `/` 和 partial `/he` 这些场景里，都要依赖 `commands` 生成可见候选。

当 `commands=[]` 时：

- bare `/` 没有候选列表
- partial `/xxx` 也没有 fuzzy / prefix / hidden exact 候选

这说明 `disableSlashCommands` 对用户最直观的效果是：

- 本地 slash UI 几乎整层消失

只要这一层没拆开，读者就会把“看不到 slash UI”直接等同于“slash 文本不能再进系统”。

## 第四层：它还会顺手切掉本地 `local-jsx` 旁路

### 即时命令路径先看 `commands.find(...)`

`REPL.tsx` 在 slash 输入的早期路径里，会先找：

- `matchingCommand = commands.find(...)`

只有匹配到了启用中的命令，某些 `local-jsx` 即时命令才会走本地即时执行。

### remote submit path 同样依赖 `commands.find(... )?.type === 'local-jsx'`

remote mode 的关键条件是：

- 只要当前输入不是一个匹配到启用中 `local-jsx` 的 slash command
- 就进入 remote send

因此当 `commands=[]` 时：

- 即时 `local-jsx` 本地截流消失
- 普通 `local-jsx` 本地旁路也消失

更准确地说，`disableSlashCommands` 不只是关掉提示 UI，它还关掉了：

- “本地把某个 slash 认成 `local-jsx` 并留在本地执行”的那条旁路

只要这一层没拆开，正文就会低估这个开关对执行去向的影响。

## 第五层：但 remote mode 的 slash 文本入口还在

### `isSlashCommand` 仍然只是 `input.trim().startsWith('/')`

`REPL.tsx` 对 slash 的最外层定义仍然是：

- `const isSlashCommand = input.trim().startsWith('/')`

它不依赖：

- `commands.length`
- `hasCommand(...)`
- `disableSlashCommands`

这说明：

- `/foo`

在语法上仍然会被视作 slash 形态输入。

### remote send 分支会把 `input.trim()` 原样送到远端

当 remote mode 下本地没有命中 `local-jsx` 旁路时，REPL 会：

- 构造本地 user message
- 然后把 `input.trim()` 作为 `remoteContent`
- 调用 `activeRemote.sendMessage(...)`

因此在 `disableSlashCommands=true` 且 remote mode 打开的情况下，更准确的结论是：

- 本地没有 slash 命令层
- 但 `/xxx` 仍可能作为普通提交文本原样送给远端

这正是本页最重要的边界。

只要这一层没拆开，读者就会把“本地 slash 层没了”误写成“远端 slash 文本入口也没了”。

## 第六层：所以 `disableSlashCommands` 更像“砍掉本地 slash 控制面”，不是“禁用斜杠文本”

更准确地说，它会同时切掉四层东西：

### 1. 本地命令对象集合

- `commands=[]`

### 2. slash 高亮

- `hasCommand(...)` 不再命中

### 3. slash 候选补全

- `useTypeahead(...)` 无命令可建议

### 4. 本地 `local-jsx` 旁路

- `commands.find(... )?.type === 'local-jsx'` 永远不成立

但它没有直接切掉：

### 5. slash 文本作为远端输入的字面入口

- `/xxx` 仍然可能 raw send 到 remote

这就是为什么 `disableSlashCommands` 更像：

- kill local slash control plane

而不是：

- kill all slash semantics

## 第七层：这会带来哪些真实使用误判

### 误判一：UI 没了 slash 候选，说明 `/xxx` 已经无意义

错在把：

- 本地 discoverability

误当成：

- remote ingress

### 误判二：关掉 slash commands 后，本地 `local-jsx` 仍会照常截走

错在漏掉：

- `commands=[]` 后，本地已无从把输入识别成 `local-jsx`

### 误判三：`disableSlashCommands` 只是一个显示层开关

错在漏掉：

- 它还改了执行去向，因为本地旁路消失了

### 误判四：remote mode 里 slash 的存在性完全取决于本地 UI

错在漏掉：

- remote send 分支对 slash 文本仍然开放

## 第八层：稳定、条件与内部边界

### 稳定可见

- `disableSlashCommands` 会把本地 `commands` 置空。
- 本地 slash 高亮、候选补全和 `local-jsx` 旁路都会一起消失。
- remote mode 下 `/xxx` 仍可能原样送到远端。

### 条件公开

- 只有 remote mode 下，“本地 slash 层消失但远端 slash 文本入口仍在”这个差异才最明显。
- 是否还能在远端被解释成某种 slash 语义，取决于远端，不由本地 REPL 保证。
- 非交互 headless 路径另有 `commandsHeadless` 逻辑，这页不展开。

### 内部 / 实现层

- `options.disableSlashCommands` 的来源。
- headless `commandsHeadless` 的构造细节。
- 远端收到 `/xxx` 后如何解释，不属于本地 REPL 合同。

## 第九层：最稳的记忆法

把这个开关记成两句话：

- 它关掉的是本地 slash 命令层。
- 它不自动关掉 remote mode 的 slash 文本入口。

只要这两句话没有同时记住，后续分析就会重新滑回：

- “slash UI 没了，所以 slash 语义没了。”

## 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx`
- `claude-code-source-code/src/utils/suggestions/commandSuggestions.ts`
- `claude-code-source-code/src/types/command.ts`
