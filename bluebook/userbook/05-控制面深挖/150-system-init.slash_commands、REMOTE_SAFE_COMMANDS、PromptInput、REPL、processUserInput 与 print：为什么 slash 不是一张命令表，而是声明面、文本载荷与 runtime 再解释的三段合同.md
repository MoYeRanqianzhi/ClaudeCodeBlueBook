# `system/init.slash_commands`、`REMOTE_SAFE_COMMANDS`、`PromptInput`、`REPL`、`processUserInput` 与 `print`：为什么 slash 不是一张命令表，而是声明面、文本载荷与 runtime 再解释的三段合同

## 用户目标

68 已经把：

- remote session 的远端发布命令面
- 本地保留命令面
- 实际执行路由

拆成了三张不同的表。

69 又继续把：

- 高亮
- 补全
- hidden
- enabled
- 执行去向

拆成不同判定器。

147 再往下补了：

- `REMOTE_SAFE_COMMANDS`
- `filterCommandsForRemoteMode(...)`

并说明 remote-safe 命令面不是 runtime readiness proof。

但如果正文停在这里，还是会留下另一种常见误写：

- “既然 slash 命令已经有几张命令表，那 slash 的问题本质上还是表和表之间的关系。”

这句还不够稳。

这轮要补的不是：

- “再多列一张命令表”

而是：

- “为什么同一个 `/foo` 在 interactive、remote、headless 三种宿主里，会经历声明面、文本载荷与 runtime 再解释三次换形”

## 第一性原理

比起直接问：

- “哪张 slash 命令表才是真的？”

更稳的提问是先拆四个更底层的问题：

1. 当前代码在回答 slash 的可见声明、输入高亮，还是执行解释？
2. 当前宿主拿到的是命令对象，还是原始文本 payload？
3. 当前分支是在本地解析 slash，还是把 slash 文本原样过 wire 交给另一端 runtime 再解释？
4. 如果 headless `print` 和 bridge/channel 路径会主动 `skipSlashCommands: true`，那 slash 还能被写成单一命令表问题吗？

这四问不先拆开，slash 很容易被误写成：

- “同一套命令对象在不同地方被显示或隐藏”

而当前源码更接近：

- slash 先被声明
- 再被输入成文本
- 最后才在某个 runtime 被再次解释

## 第一层：`system/init.slash_commands` 是声明面，不是执行器

`utils/messages/systemInit.ts` 里对 `slash_commands` 的构造非常直接：

- 从 `inputs.commands`
- 过滤 `userInvocable !== false`
- 再取 `name`

这一步产出的不是：

- 可执行命令对象
- 各命令完整 metadata
- 最终 runtime readiness 证明

而只是：

- 一组 slash 命令名字

`entrypoints/sdk/coreSchemas.ts` 又把它固定进 `system/init` schema：

- `slash_commands: z.array(z.string())`

这说明它首先属于：

- wire-level init metadata

它回答的是：

- 当前宿主愿意声明哪些 slash 名字给对端看

不是：

- “这些 slash 在此刻一定可执行”

所以 `system/init.slash_commands` 更像：

- 声明面

不是：

- 运行时执行器

## 第二层：`REMOTE_SAFE_COMMANDS` 与 `filterCommandsForRemoteMode(...)` 只是裁本地壳

`commands.ts` 里：

- `REMOTE_SAFE_COMMANDS`
- `filterCommandsForRemoteMode(...)`

回答的是另一个问题：

- `--remote` TUI 在本地先保留哪些命令对象，不要让明显不适合 remote mode 的本地命令短暂露出来

这一步的关键词是：

- pre-filter
- local shell
- remote-safe affordance

它不是：

- 对 wire 上 slash 文本的最终解释

同文件里 `BRIDGE_SAFE_COMMANDS` / `isBridgeSafeCommand(...)` 又是另一条更严格的桥接合同：

- `local-jsx` 直接禁
- `prompt` 类型默认可过
- `local` 类型必须显式 allowlist

这也再次证明：

- 当前仓库里不是只有一张 slash 安全表

更重要的是，这些表回答的都还是：

- “本地壳要先保留什么”
- “桥接入口允许什么”

不是：

- “slash 文本最终由谁解释”

## 第三层：`PromptInput` 消费的是命令对象集，看到的是高亮，不是执行主权

`PromptInput.tsx` 里 slash 高亮的逻辑很克制：

- 找 slash trigger
- 调 `hasCommand(commandName, commands)`

也就是说它只在回答：

- 当前输入框手里的命令对象集中，某个 slash 名字是不是已知命令

它并不回答：

- 最后是本地执行还是远端执行
- 是直接解释还是原样过 wire
- 是真命令还是最终会被当纯文本

所以 `PromptInput` 这一层属于：

- 输入可见性 / 高亮消费层

不是：

- 执行路由层

这也是为什么单看 slash 高亮，很容易高估当前宿主对 slash 的执行主权。

## 第四层：`REPL` 在 remote mode 下常常把 slash 当文本送远端，本地只截留 `local-jsx`

`REPL.tsx` 里的两段逻辑把 150 的核心差异写得很清楚。

### `handleRemoteInit(...)`

这里拿远端 `slash_commands` 做的事情不是重建远端命令系统，而是：

- 让本地现有命令对象只保留“远端声明的名字 OR 本地 remote-safe 命令”

也就是说，它仍然在：

- 调整本地可见壳

### remote send path

更关键的是 `handlePromptSubmit(...)` 一带。

当前逻辑里，在 `activeRemote.isRemoteMode` 为真时：

- 只有 `local-jsx` slash 命令留在本地
- 其余 slash 文本和 plain text 一起走 `activeRemote.sendMessage(...)`

这意味着对于大量 slash 来说，`REPL` 本地手上发生的并不是：

- “看到 slash -> 当场本地解释”

而是：

- “看到 slash -> 保留原始文本 -> 发给远端 runtime”

这一步非常关键，因为它说明 slash 在 remote mode 下已经从：

- 本地命令对象

退化成了：

- 文本 payload

## 第五层：bridge / headless `print` 甚至会主动把 slash 纯文本化

如果只看到 REPL remote send，还是容易以为：

- slash 文本只是换了宿主，依然会被另一端当命令认真解释

但 `processUserInput.ts` 和 `print.ts` 说明事情还更细。

### bridge/mobile

`processUserInput.ts` 里有一条 bridge-safe override：

- 默认 `skipSlashCommands` 仍可能为真
- 只有在 `bridgeOrigin` 且 slash 被解析后通过 `isBridgeSafeCommand(...)`，才会把 skip 清掉
- 已知但不安全的 slash 会被短路成帮助消息，而不是把 `/config` 一类原样交给模型

这说明 bridge/mobile 路径默认更像：

- plain-text 默认
- bridge-safe 例外

### headless `print`

`print.ts` 里 bridge inbound message、channel message、connection message 这些入口会显式入队：

- `skipSlashCommands: true`

这一步的含义不是：

- “这一端没有 slash 命令表”

而是更强的一句：

- “这一批输入在当前宿主里就不走 slash 解释链，而是按纯文本 prompt 处理”

所以 headless `print` 再次证明：

- slash 的命运不仅取决于命令表里有没有它
- 还取决于这批文本在当前宿主是否被允许进入 slash 解释阶段

## 第六层：direct connect / remote session 在线上传输的也是 user text，不是已解析命令

`directConnectManager.ts` 与 `RemoteSessionManager.ts` 的 `sendMessage(...)` 进一步把这件事坐实了：

- 在线上传的是 `content`
- 也就是 user text / remote content blocks

不是：

- “已解析好的 slash 命令对象”
- “本地执行决定”
- “命令表裁剪后的执行指令”

这说明从 transport 视角看，slash 更像：

- 带 `/` 前缀的用户文本

至于这段文本最后会不会再次变回 slash 命令，

要看的是：

- 哪一端 runtime 接手
- 那一端是否允许 slash 解释
- 那一端当前宿主手里又有哪些命令对象

也就是说，slash 在跨宿主时的真实生命周期更像：

1. 声明面：`system/init.slash_commands`
2. 输入面：`PromptInput` / REPL 输入框里作为 slash token 被识别
3. 运输面：作为 raw text / content payload 过 wire
4. 解释面：由目标 runtime 再决定是命令、纯文本还是 bridge-safe 例外

## 稳定面与灰度面

### 稳定面

- `system/init.slash_commands` 是名字声明面，不是执行器
- `REMOTE_SAFE_COMMANDS` / `filterCommandsForRemoteMode(...)` 是本地 remote 壳过滤器
- `PromptInput` 的 slash 高亮只消费本地命令对象集
- remote `REPL` 会把大量 slash 文本原样送远端，只把 `local-jsx` 留本地
- bridge/headless 某些路径会显式 `skipSlashCommands: true`

### 灰度面

- 哪些 bridge-safe slash 会继续扩表
- 哪些 headless/channel 输入未来还会继续保持纯文本化
- `system/init` 将来是否会附带更厚的 slash metadata，而不只是名字

## 为什么这页不是 68、69、147、148

### 不是 68

68 讲的是：

- 命令面不是一张表

150 讲的是：

- slash token 会在跨宿主时从命令声明退化成文本 payload，再由另一端 runtime 重新解释

它已经不只是表与表的关系，而是：

- declaration -> transport -> reinterpretation

### 不是 69

69 讲的是同一宿主里的：

- discoverability
- hidden
- enabled
- executability

150 讲的是跨宿主、跨 wire 的 slash 文本命运。

核心不再是判定器层级，

而是：

- 谁先解析
- 谁只运输
- 谁再解释

### 不是 147

147 讲的是：

- remote-safe 命令面不是 readiness proof

150 承认这个前提，但继续往后拆：

- safe surface 之后，slash 文本到底是否原样过 wire
- 哪些入口直接把它纯文本化
- 最终由哪一端 runtime 再解释

### 不是 148

148 讲的是：

- `CLAUDE_CODE_REMOTE` 与 `getIsRemoteMode()` 是两根 remote 行为轴

150 不谈 remote bit 轴，

而是谈：

- slash 作为输入合同、本地壳、wire payload 与目标 runtime 之间的切换

## 苏格拉底式自审

### 问：为什么这页不能简单写成“slash 还是有很多表”？

答：因为那样仍然把 slash 看成静态对象集合，而当前源码已经清楚展示它会跨宿主变成原始文本再被重新解释。

### 问：为什么一定要把 `PromptInput` 写进来？

答：因为如果不写输入高亮这一层，很容易误把“本地输入框能认出来”当成“本地 runtime 有执行主权”。

### 问：为什么一定要把 `print` 写进来？

答：因为 `skipSlashCommands: true` 最能证明 slash 在某些宿主根本不会进入命令解释阶段，而会被强制纯文本化。

### 问：为什么一定要把 direct connect / remote session 发送层写出来？

答：因为只有把 wire 上实际发送的是 `content` 这件事写出来，slash 从命令对象退化成文本 payload 的过程才算闭环。

### 问：这页的一句话 thesis 是什么？

答：slash 的关键不是哪张命令表更真，而是同一个 `/foo` 在 interactive、remote、headless 三种宿主里会经历“声明面 -> 文本载荷 -> runtime 再解释”三次换形。

## 结论

对当前源码来说，更准确的写法应该是：

1. `system/init.slash_commands` 声明 slash 名字，不提供执行证明
2. `REMOTE_SAFE_COMMANDS` / `filterCommandsForRemoteMode(...)` 只裁本地 remote 壳
3. `PromptInput` 只基于本地命令对象集高亮 slash
4. remote `REPL` 常把 slash 当文本送远端，只让 `local-jsx` 留本地
5. bridge / `print` 某些路径会直接把 slash 纯文本化
6. 最终 slash 是否成为命令，要由目标 runtime 再次解释

所以：

- slash 不是一张命令表，而是声明面、文本载荷与 runtime 再解释的三段合同

## 源码锚点

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
