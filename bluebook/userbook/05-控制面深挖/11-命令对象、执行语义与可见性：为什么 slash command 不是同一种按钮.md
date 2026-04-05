# 命令对象、执行语义与可见性：为什么 slash command 不是同一种按钮

## 用户目标

不是只知道很多能力都长成 `/xxx`，而是先看清三件事：

- 这条命令到底是本地 UI、本地动作，还是受控 prompt 工作流。
- 它会立刻执行、排队等待，还是把结果重新注入模型。
- 它对谁可见、在哪种宿主里可用、在哪种模式下会被屏蔽。

如果这三件事不先分开，`/status`、`/compact`、`/review`、`/statusline`、`/debug`、`/desktop`、`/extra-usage` 很容易被误写成同一类“slash command”。

## 第一性原理

斜杠前缀只说明“输入以 `/` 开头”，不说明这条输入会被怎样执行。

Claude Code 真正在问的是三道制度问题：

1. 这条命令是本地执行，还是要把内容送进模型。
2. 它要不要绕过当前队列，直接在本地宿主开面板或做动作。
3. 当前用户、当前宿主、当前模式，是否有资格看到和执行它。

所以命令系统至少要拆成三条正交坐标：

- 对象类型：`prompt`、`local`、`local-jsx`
- 执行语义：`immediate`、排队、`context: fork`、headless 过滤
- 可见性边界：`availability`、`isEnabled()`、`isHidden`、`userInvocable`、`disableModelInvocation`

`CommandBase` 里的字段很多，但它们不属于同一层。把它们混成“命令标签”，会直接损坏 userbook 的解释力。

## 第一张坐标：命令对象到底是什么

### `prompt`：受控 prompt 工作流，不是普通聊天

`prompt` 命令的本质不是“显示一个本地面板”，而是生成一段正式内容注入当前对话，必要时再附带工具白名单、模型覆盖、hooks、effort、附加元消息。

这类命令的共同特点是：

- 结果会变成消息回流给模型，而不是只在本地 UI 停留。
- 能声明 `allowedTools`、`model`、`effort`、`hooks`、`paths`、`context`。
- 可以来自 builtin、skills 目录、bundled skills、plugin skills、MCP skills。

典型例子：

- `/review`：把 PR 评审协议注入模型，而不是本地打开 review 面板。
- `/commit`：把受控提交协议送进模型，而不是直接替用户跑一串任意 git。
- `/statusline`：不是“看状态”，而是创建 `statusline-setup` 子代理去配置状态线。

还要再拆两条边界：

- `disableModelInvocation`：模型不能通过 SkillTool 自动调用，但用户仍可能手打 `/xxx`。`/debug` 这类技能属于这一类。
- `userInvocable: false`：用户不能直接 `/xxx`，只能让 Claude 自己在工作流里调用。`keybindings-help` 就是这种“模型可用、用户不可直打”的 skill。

因此，`prompt` 类型内部也不止一种公开度。

### `local`：本地动作，返回文本、compact 或直接跳过

`local` 命令不把命令体送进模型。它在本地执行，返回三种结果之一：

- `text`：回写一段本地输出。
- `compact`：触发压缩并重建消息边界。
- `skip`：不向会话追加任何消息。

典型例子：

- `/cost`
- `/clear`
- `/release-notes`
- `/compact`

这一类更像“宿主上的本地动作接口”，而不是 prompt 编译器。

它还有两个关键边界：

- `supportsNonInteractive`：这条 `local` 命令能否进入 headless / 非交互模式。
- `isSensitive`：若声明为敏感，参数会在 transcript 里被打码。字段存在于运行时合同里，但当前这份公开源码里几乎看不到主线命令大量使用它。

所以 `local` 不是“轻量版 prompt”，而是另一种执行宿主。

还要补一条很容易漏掉的事实：

- 同一个命令名在不同模式下可能切换类型。
- 最典型的是 `/context`：交互 REPL 里它是 `local-jsx` 可视化网格，headless 下则换成 `local` 文本输出版本。

因此“看见了同一个名字”不代表“背后还是同一个对象”。

### `local-jsx`：本地 UI 宿主，不进入模型

`local-jsx` 命令的对象是本地 Ink UI：screen、panel、modal、picker。

典型例子：

- `/config`
- `/status`
- `/usage`
- `/doctor`
- `/mcp`
- `/plugin`
- `/permissions`
- 交互模式下的 `/context`

它的关键点不是“有界面”，而是：

- 执行中心在本地 UI，而不是模型。
- 在非交互模式下通常没有意义。
- 在 bridge/mobile 输入下默认更严格，因为本地 Ink UI 不能随便在远程输入里弹出来。

因此 `local-jsx` 也不是“只是更好看的 local”。

## 第二张坐标：同样是 slash，执行时机也不同

### 普通路径：空闲时立即处理，忙碌时进入队列

`handlePromptSubmit` 的基础制度很简单：

- 当前空闲时，输入进入统一的 `executeUserInput` 流程。
- 当前已有查询或外部加载时，大部分输入先进队列。
- 真正执行时再统一经过 `processUserInput` 和 `processSlashCommand`。

这意味着“输入什么时候被执行”并不只由命令名决定，还取决于当前是否在忙、是否来自外部加载、是否桥接而来。

还要再补两条调度事实：

- 队列里的 slash / bash 命令是逐条 drain，不会批量并发冲出去。
- 只要当前有 active local JSX UI，队列就会暂停消费。

所以命令队列更像串行调度器，而不是后台批处理池。

### 未知的 `/foo` 不一定是错误

`processSlashCommand` 对未知 slash 输入不是一律报错。

更准确地说：

- 若它看起来像命令名，且不像真实文件路径，系统才会返回 `Unknown skill: ...`
- 若它更像路径或普通文本，系统会把整段输入退化成普通 prompt

因此：

- `/tmp`
- `/var`
- `/foo/bar`

不一定会进入“未知命令”分支。

这再次说明：slash 前缀本身并不直接等于“命令对象已经成立”。

### `immediate`：不是更高级，而是允许绕过当前 stop point

`immediate` 字段的含义不是“这条命令更重要”，而是：

- 当当前查询仍在进行中，且这条命令是 `local-jsx`
- 系统允许它直接在本地宿主打开或切换 UI
- 不必等待当前模型回合结束

当前源码里能看到多条这样的命令：

- `/status`
- `/exit`
- `/mcp`
- `/plugin`
- `/hooks`
- `/rename`
- `/color`
- `/sandbox`

这类命令走的是本地 fast path：

- 输入会被立刻清空。
- 直接加载 JSX 命令实现。
- 必要时通过通知或本地 UI 反馈结果。
- 不必先进入排队链。

所以 `immediate` 不等于：

- root command
- 非交互兼容
- bridge 可用
- 模型更容易调用

它只回答“忙碌时能不能先在本地宿主做这件事”。

### `context: fork`：不是第四种命令类型，而是 `prompt` 的执行上下文

运行时显式支持 `prompt` 命令声明 `context: 'fork'`：

- slash 命令进入 `executeForkedSlashCommand`
- 系统为它准备 forked agent 上下文
- 可同步显示进度，也可在 Kairos/assistant 模式下异步回流结果

这说明 `fork` 不是新命令类型，而是 `prompt` 的一种执行上下文。

更稳的写法应是：

- `prompt + inline`：在当前对话内展开
- `prompt + fork`：在子代理上下文内执行，再把结果带回来

还要补两条更细的事实：

- 对基于 frontmatter 的磁盘技能来说，显式写 `context: inline` 基本等于不写；真正有行为差异的是 `context: fork`
- `prompt + fork` 也不天然等于后台异步；是否异步还取决于 Kairos assistant mode

还要特别保护边界：

- 运行时合同明确支持这条路径。
- 但在当前可见的 builtin 命令注册里，并没有大量稳定主线命令都显式声明 `context: 'fork'`。
- 因此更适合写成“已被实现的执行能力”，而不是“所有 slash 技能都默认这样工作”。

还要继续保护一个易错点：

- `prompt + inline` 会继续触发主模型 query
- 同步 `prompt + fork` 则更像子代理工作流，完成后以本地结果消息回到 transcript，不会再让主模型就这条 slash 命令继续跑一轮

### `disableNonInteractive` 与 `supportsNonInteractive` 是两套相反方向的门

这两个字段很容易被误合并，但它们分属不同对象：

- `disableNonInteractive` 作用在 `prompt` 命令上，表示 headless 下不要把它纳入可用命令集合。
- `supportsNonInteractive` 作用在 `local` 命令上，表示这条本地动作可以进入 headless。

例如：

- `/statusline` 是 `prompt` 命令，并显式 `disableNonInteractive: true`
- `/compact`、`/cost`、`/release-notes` 以及 headless 版 `/context` 则是 `local` 命令，并声明 `supportsNonInteractive: true`

所以它们不是一组同义词，而是分别控制不同类型命令在 headless 下是否保留。

## 第三张坐标：谁能看到、谁能调用、在哪个宿主里能跑

### `availability`：静态资格，不是临时开关

`availability` 回答的是“谁有资格看见”。

典型例子：

- `/desktop` 只对 `claude-ai` 用户开放
- `/usage` 只对 `claude-ai` 用户开放
- `/fast` 对 `claude-ai` / `console` 开放

它更接近账户/provider 资格筛选，而不是 feature toggle。

### `isEnabled()`：动态运行时门

`isEnabled()` 回答的是“现在能不能用”。

常见触发因素：

- 平台是否支持
- 环境变量是否禁用
- policy 是否允许
- 当前是否非交互
- Beta / entitlement helper 是否放行

典型例子：

- `/feedback` 同时受 provider、privacy、policy 和环境变量影响
- `ultrareview` 受启用条件约束
- `/chrome`、`/desktop` 还受平台限制

因此：

- `availability` 不是 `isEnabled()`
- “源码里注册了”也不是“当前这台机器一定能看到”

### `isHidden`：从 help/typeahead 隐身，不等于内部不存在

`isHidden` 的语义是“不要默认出现在 help / 自动补全里”，不是“系统完全没有这条能力”。

典型情况包括：

- `/rate-limit-options`：隐藏分流入口
- 非交互镜像命令：例如 `context`、`extra-usage` 的 headless 版本，在交互模式里隐藏
- 各类 stub / 内部诊断命令
- `/heapdump` 这类默认不出现在 help，但知道名字仍可直呼的命令

所以“隐藏”与“内部”不能直接画等号。

### `userInvocable` 与 `disableModelInvocation`：分别控制人和模型

这两个字段最容易被写反。

更准确地说：

- `userInvocable: false`
  - 用户不能直接 `/skill-name`
  - 但 Claude 可以在工作流里通过 SkillTool 调用
  - 典型例子是 `keybindings-help`
- `disableModelInvocation: true`
  - 模型不会自动把它当成可调用 skill
  - 但用户仍可以主动 `/debug`

所以它们分别回答：

- 人能不能直接敲
- 模型能不能自动调

这不是同一层门控。

### `loadedFrom`、`source`、`userFacingName`、`kind`：来源元数据，不是执行语义

这组字段更多在回答“这条命令从哪来、怎么显示”，而不是“怎么执行”。

- `source`：builtin、bundled、plugin、mcp、settings source
- `loadedFrom`：skills、plugin、bundled、mcp、`commands_DEPRECATED`
- `userFacingName()`：显示名可与内部名字不同
- `kind: 'workflow'`：当存在时更像 UI/索引上的工作流标识，而不是第四种命令类型

在稳定性判断上，更稳妥的写法是：

- `loadedFrom` 更像 provenance / 索引元数据
- `kind` 更像展示与遥测标记
- 在当前这份公开快照里，`kind` 甚至更偏“有消费点、少生产点”的保留字段

因此：

- 它们不应该和 `immediate`、`supportsNonInteractive` 混写
- 更不该被写成“能力级别”

### `INTERNAL_ONLY_COMMANDS`、`feature()`、`USER_TYPE === 'ant'`

这是另一层更硬的边界：

- `INTERNAL_ONLY_COMMANDS` 只在 ant/internal 构建路径下进入主命令集合
- 多条命令通过 `feature('...')` 条件引入
- 有些命令虽有名字，但实现只是 stub 或内部影子

因此普通用户主线不应把这些入口写成稳定推荐路径。

还要补一条更细的保护：

- 某条命令即使出现在 transport allowlist 里，也不代表当前用户一定拿得到
- 因为它还要先通过 `getCommands()` 的 `availability` / `isEnabled()` 过滤
- 例如某些 allowlist 里的内部 stub 或 ant-only 命令，在外部公开构建下依然不可达

## Remote、Bridge、Headless 不是一回事

这三种模式也经常被混写，但源码里是三套不同制度。

### Remote mode：整套 REPL 先按 `REMOTE_SAFE_COMMANDS` 预过滤

`--remote` 下，系统会先按 `REMOTE_SAFE_COMMANDS` 留下一批只影响本地 TUI 状态、不会依赖本地文件系统或复杂宿主副作用的命令。

例如：

- `/session`
- `/exit`
- `/help`
- `/theme`
- `/color`
- `/usage`
- `/plan`

这回答的是“在 remote mode 里哪些本地控制面仍合理存在”。

一个很值得写进 userbook 的例子是：

- `/mobile` 是 `local-jsx`，因此在 `--remote` TUI 的 remote-safe 集合里可以保留
- 但它并不因此变成 bridge-safe；从手机/web 反向打进本地宿主时，它仍会被挡掉

### Bridge inbound：输入默认 `skipSlashCommands`，只对 bridge-safe 命令重新开门

远端 mobile/web 通过 bridge 注入输入时，系统先把 `skipSlashCommands` 设为 `true`，防止：

- exit words 误杀本地会话
- `immediate` 本地 UI 命令直接在宿主弹出

随后 `processUserInput` 再做第二层判断：

- `prompt` 命令默认 bridge-safe
- `local` 命令只有进入 `BRIDGE_SAFE_COMMANDS` allowlist 才能执行
- `local-jsx` 一律不允许

因此移动端输入 `/config` 和手工在本地 REPL 输入 `/config`，制度上不是同一回事。

这也意味着：

- `skipSlashCommands` 不只是“暂时不要解析 slash”
- 它同时承担 exit-word 防护和 immediate fast-path 防护
- bridge 只是稍后在更下游有选择地重新打开 bridge-safe 命令

再看一个很好的对照例子：

- `/clear` 是 bridge-safe、也是 remote-safe
- 但它并不支持 headless non-interactive

这正好说明 bridge、remote、headless 不能互相替代。

### Headless：只保留 prompt 和显式声明可非交互的 local

非交互模式的命令筛选更直接：

- `prompt` 命令必须没有 `disableNonInteractive`
- `local` 命令必须 `supportsNonInteractive: true`
- `local-jsx` 不进 headless 主集合

这回答的是“在无人值守/脚本模式里还剩哪些命令合同”。

所以：

- bridge-safe 不等于 headless-safe
- remote-safe 不等于 bridge-safe
- `supportsNonInteractive` 也不等于 remote-safe

## 最容易误判的六件事

### 误判 1

“都是 slash command，所以只是 UI 形式不同。”

更准确的说法是：slash 只是入口记号，运行时合同至少还要看 `type`、时机和可见性。

### 误判 2

“`isHidden` 的命令就是内部命令。”

更准确的说法是：`isHidden` 只是默认不出现在 help/typeahead；它可以是条件入口、镜像入口，也可以是内部入口。

### 误判 3

“`availability` 和 `isEnabled()` 都是在说开关。”

更准确的说法是：`availability` 是静态资格，`isEnabled()` 是动态运行时放行。

### 误判 4

“`supportsNonInteractive` 说明这条命令也能从手机或 web 远程用。”

更准确的说法是：headless、bridge、remote 是三条不同边界。

### 误判 5

“只要是 skill，用户就能直接 `/skill-name`。”

更准确的说法是：`userInvocable: false` 的 skill 只能由 Claude 调用。

### 误判 6

“`immediate` 的命令更重要、更高级。”

更准确的说法是：它只是允许本地 UI 在当前回合尚未停稳时先执行。

### 误判 7

“同名命令在所有模式下都属于同一种对象。”

更准确的说法是：像 `/context`、`/extra-usage` 这类命令，在交互与非交互模式下可能会切换到不同实现类型。

## 对用户最有价值的使用结论

- 想打开本地控制面，先判断它是不是 `local-jsx`，而不是只看命令名像不像“设置”。
- 想让 Claude 执行一套协议化工作流，先判断它是不是 `prompt` 命令，而不是把 slash 都当快捷按钮。
- 想接到脚本、后台或 bridge/mobile，先看 headless / remote / bridge 三套过滤，不要只看命令是否存在。
- 想判断一条命令是不是稳定主线，先依次检查 `availability`、`isEnabled()`、`isHidden`、`feature()`、`USER_TYPE === 'ant'`。

## 源码锚点

- `claude-code-source-code/src/types/command.ts`
- `claude-code-source-code/src/commands.ts`
- `claude-code-source-code/src/utils/handlePromptSubmit.ts`
- `claude-code-source-code/src/utils/processUserInput/processSlashCommand.tsx`
- `claude-code-source-code/src/utils/processUserInput/processUserInput.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/commands/status/index.ts`
- `claude-code-source-code/src/commands/context/index.ts`
- `claude-code-source-code/src/commands/extra-usage/index.ts`
- `claude-code-source-code/src/commands/review.ts`
- `claude-code-source-code/src/commands/statusline.tsx`
- `claude-code-source-code/src/skills/loadSkillsDir.ts`
- `claude-code-source-code/src/skills/bundledSkills.ts`
- `claude-code-source-code/src/skills/bundled/debug.ts`
- `claude-code-source-code/src/skills/bundled/keybindings.ts`
