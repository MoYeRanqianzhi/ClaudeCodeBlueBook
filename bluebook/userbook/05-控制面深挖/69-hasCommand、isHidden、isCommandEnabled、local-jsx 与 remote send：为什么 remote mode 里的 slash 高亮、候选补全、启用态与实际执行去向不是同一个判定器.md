# `hasCommand`、`isHidden`、`isCommandEnabled`、`local-jsx` 与 `remote send`：为什么 remote mode 里的 slash 高亮、候选补全、启用态与实际执行去向不是同一个判定器

## 用户目标

不是只知道 remote mode 下输入 `/xxx` 时会发生：

- 输入框高亮 slash
- 底部出现命令候选
- 回车后要么本地吃掉，要么发给远端

而是先拆开五个不同层级的判断：

- 这段文本在语法上是不是一个 slash command token。
- UI 会不会把它高亮成“已识别命令”。
- typeahead 会不会把它作为候选建议出来。
- 当前这一刻它是否算“启用中的命令”。
- 回车后它会被本地 `local-jsx` 截走，还是原样发给 remote。

如果这五层不拆开，读者最容易把 remote mode 写成一句过平的话：

- “只要本地认得这是命令，就会按本地命令规则处理。”

源码并不是这样工作的。

## 第一性原理

同一个 `/name` 在 remote mode 里至少会经过五个判定器：

1. `Token Detector`：这段输入是不是 slash 形态。
2. `Command Recognition`：当前 `commands` 数组里能不能按名字、别名或用户可见名认出它。
3. `Suggestion Visibility`：候选系统愿不愿意把它作为建议项显示出来。
4. `Enabled Gate`：此刻它还算不算启用命令。
5. `Execution Router`：它是不是启用中的 `local-jsx`，从而留在本地，否则发往 remote。

更稳的提问不是：

- “这个 slash command 到底算不算存在？”

而是：

- “我现在讨论的是识别、建议、启用，还是执行去向；如果把五层压成一个布尔值，会误导用户哪一层判断？”

只要这五层没先分开，正文就会把：

- 被高亮
- 被推荐
- 被视为已启用
- 会本地执行
- 会远端执行

压成同一个“命令存在性”。

这里也先卡住边界：

- 这页讲的是 remote mode 下 slash 输入的五层判定器。
- 不重复 68 页对“三张命令表”的总论。
- 不重复 11 页对 command object 类型学的总论。
- 不重复 57 页 remote session / direct connect / ssh session 的会话合同差异。

## 第一层：高亮判定只问“认不认得这个名字”，不问它现在该不该执行

### `PromptInput` 先找 slash token，再用 `hasCommand(...)` 过滤

`PromptInput.tsx` 里：

- 先通过 `findSlashCommandPositions(displayedValue)` 找到 slash token。
- 再把 `/` 后面的文本切出来。
- 最后只保留 `hasCommand(commandName, commands)` 为真的位置做高亮。

### `hasCommand(...)` 只看名字匹配，不看 `isHidden` / `isCommandEnabled`

`commands.ts` 里：

- `findCommand(...)` 只是检查 `name`
- 或 `getCommandName(...)`
- 或 `aliases`

然后 `hasCommand(...)` 只是 `findCommand(...) !== undefined`。

这说明高亮层回答的问题是：

- “当前命令对象集合里，有没有一个名字上能对上的命令？”

不是：

- “它现在是不是可建议、可执行、可本地处理的命令？”

只要这一层没拆开，正文就会把蓝色高亮误写成“当前启用且可执行”的证明。

## 第二层：候选补全主要看 `isHidden`，不是看 `isCommandEnabled`

### `PromptInput` 把当前 `commands` 原样交给 `useTypeahead(...)`

`PromptInput.tsx` 里并没有单独构造一份“启用命令表”，而是直接把：

- `commands`

传给：

- `useTypeahead(...)`

### `generateCommandSuggestions(...)` 过滤的是 `isHidden`

`commandSuggestions.ts` 里：

- 只在 slash 输入且没有参数时生成建议。
- 输入只有 `/` 时，先做 `commands.filter(cmd => !cmd.isHidden)`。
- Fuse 索引的建立也只过滤 `!cmd.isHidden`。

这说明候选补全回答的问题更接近：

- “这个命令是否应该出现在建议 UI 中？”

而不是：

- “它当前是不是启用中的命令？”

因此高亮层和补全层已经不是同一个判定器：

- 高亮看 `hasCommand(...)`
- 补全看 `isHidden`

只要这一层没拆开，读者就会误以为“能高亮就一定能出现在候选里”。

## 第三层：hidden command 甚至还能出现“高亮了，但平时不建议；只有精确输入时才复活”的情况

### `generateCommandSuggestions(...)` 对 hidden command 有一个精确命中回补

`commandSuggestions.ts` 明确写了一个例外：

- 如果用户精确输入了当前 hidden command 的名字
- 且没有同名的可见命令覆盖它
- 就把这个 hidden exact match 预先插回结果前面

这意味着候选层本身也不是单层规则，而是：

- 平时：hidden 不进候选
- 精确键入时：某些 hidden 命令可以被“点名复活”

因此同一个 `/name` 可能出现三种不同状态：

- 能高亮
- 平时不出现在候选
- 但精确输入时又重新出现在候选

只要这一层没拆开，正文就会把 `isHidden` 写成“完全不可见”，这同样不准确。

## 第四层：真正决定“当前是不是启用命令”的，是 `isCommandEnabled(...)`

### `isCommandEnabled(...)` 是单独的运行时门

`types/command.ts` 里：

- `isCommandEnabled(cmd)` 只是调用 `cmd.isEnabled?.() ?? true`

它不参与 slash 高亮，也不主导 typeahead 的主过滤。

### `getCommands(...)` 虽然会在装载时先做 enabled 过滤，但提交时仍然会重查

`commands.ts` 里的 `getCommands(...)` 会在生成命令列表时先过：

- `meetsAvailabilityRequirement(...)`
- `isCommandEnabled(...)`

这解释了为什么初始 `commands` 列表通常已经比较干净。

但 `REPL.tsx` 在真正处理 slash 提交时，仍然再次显式检查：

- `isCommandEnabled(cmd)`

这说明“列表装载时被放进来”和“当前提交时仍算启用”不是完全同一层判断。

更稳的说法不是：

- “只要它出现在 `commands` 里，就一定还是启用的。”

而是：

- “`commands` 是当前会话持有的命令对象集合，而提交时启用态仍由 `isCommandEnabled(...)` 再裁一遍。”

只要这一层没拆开，正文就会把命令对象存在性和当前启用态混写。

## 第五层：remote mode 真正决定执行去向的，只是“它是不是启用中的 `local-jsx`”

### `REPL.tsx` 的 remote submit path 用的是更窄的判定

在 remote mode 下，`REPL.tsx` 的关键判断是：

- 输入是不是 slash command
- `commands.find(...)` 是否匹配到一个
- `isCommandEnabled(...)` 为真的命令
- 且它的 `type === 'local-jsx'`

只有这组条件同时成立，它才不会走 remote send。

### 其余情况一律进入 raw send

如果上面的条件不成立，那么：

- prompt commands
- 普通文本
- 未匹配命令名的 slash 输入
- 当前不算启用的 slash 输入
- 非 `local-jsx` 的 slash 输入

都会被打包为本地 user message，然后：

- `activeRemote.sendMessage(remoteContent, ...)`

原样发给远端。

这说明执行路由回答的问题根本不是：

- “UI 认不认得它是命令？”

而是：

- “它现在是不是一个启用中的 `local-jsx` 命令；如果不是，就让远端自己解释。”

只要这一层没拆开，正文就会把“本地识别为命令”误写成本地一定接管。

## 第六层：因此同一个 `/name` 可能同时落在五种不完全一致的状态里

更准确地说，同一个 slash 输入可能出现下面这些组合：

### 组合一：高亮，但不出现在常规候选里

因为：

- 高亮只看 `hasCommand(...)`
- 候选主要看 `isHidden`

### 组合二：候选里能看到，但当前提交不会被当作启用命令

因为：

- 候选生成不重新过 `isCommandEnabled(...)`
- 提交期会重新过 `isCommandEnabled(...)`

### 组合三：看起来像 slash command，但仍会被原样送远端

因为：

- remote mode 本地只截 `local-jsx`
- 其它 slash 输入即使被 UI 认得，也可能继续 raw send

### 组合四：平时不出候选，但精确输入后又突然出现

因为：

- hidden exact match 会被专门补回

只要这些组合没单独拆开，读者就会继续把 slash UX 写成单一判定器。

## 第七层：为什么这对用户使用尤其重要

用户最常见的误判有四种。

### 误判一：蓝色高亮就代表“本地可执行”

错在把：

- `hasCommand(...)`

误当成：

- local execution gate

### 误判二：候选里没有，就代表远端也不会认

错在把：

- suggestion visibility

误当成：

- remote executability

### 误判三：命令存在就代表当前启用

错在把：

- command object presence

误当成：

- `isCommandEnabled(...)`

### 误判四：只要是 slash command，本地都会先解释一遍

错在漏掉：

- remote mode 只保留 `local-jsx` 的本地旁路

## 第八层：稳定、条件与内部边界

### 稳定可见

- slash 高亮、候选补全、启用态与执行去向不是同一个判定器。
- remote mode 下，只有启用中的 `local-jsx` 命令会被本地截走。
- 其它 slash 输入可能继续被原样发往 remote。

### 条件公开

- `isHidden` 是否为真。
- `isEnabled()` 当前返回什么。
- 当前 `commands` 数组里是否还持有这个命令对象。
- 当前会话是否正处于 remote mode。

### 内部 / 实现层

- Fuse 排序策略。
- hidden exact match 的具体插回顺序。
- `commands` 数组的具体构造与热刷新时机。
- 各个命令对象自己的 `isEnabled()` 实现细节。

## 第九层：最稳的记忆法

把 remote mode 下的 slash 输入分成五层：

- `Can parse as slash`
- `Can recognize by name`
- `Can suggest in UI`
- `Is enabled right now`
- `Will stay local or be remote-sent`

只有最后一层才直接回答：

- “它到底会在哪里执行？”

前四层都只是这条答案前面的局部投影。

## 源码锚点

- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx`
- `claude-code-source-code/src/utils/suggestions/commandSuggestions.ts`
- `claude-code-source-code/src/commands.ts`
- `claude-code-source-code/src/types/command.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
