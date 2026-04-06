# 技能来源、暴露面与触发：为什么 skills 菜单不是能力全集

## 用户目标

不是只知道 Claude Code “支持 skills”，而是先看清四件事：

- 技能到底从哪些来源进入运行时。
- `/skills` 菜单实际展示的是哪一部分。
- Claude 通过 SkillTool 看到的技能集合为什么又不一样。
- 为什么有些技能在会话开始时不存在，碰到文件之后才出现。

如果这四件事不先拆开，读者最容易把下面这些东西误写成同一张“技能总表”：

- `.claude/skills` 下的 file-based skills
- legacy `commands` 目录里的 commands-as-skills
- 编译进 CLI 的 bundled skills
- 插件自带 skills
- built-in plugin skills
- MCP prompts / MCP skills
- `paths:` 条件技能
- 触碰文件后才动态发现的嵌套技能目录

## 第一性原理

Claude Code 里的“技能”不是一个列表，而是多层投影：

1. 来源投影：技能从哪里进入运行时。
2. 用户投影：`/skills` 菜单现在把哪部分暴露给人看。
3. 模型投影：SkillTool 现在允许 Claude 调哪些技能。
4. 激活投影：哪些技能先潜伏，只有在文件路径命中时才被放出来。

因此更稳的提问不是：

- “Claude Code 一共有多少技能？”

而是：

- “当前这条会话里，哪些技能已经被装进命令面？”
- “它们是给用户直接 `/skill` 用的，还是给 Claude 自己调的？”
- “它们是常驻暴露，还是文件触发后才激活？”

只要不先分这四层，`/skills` 就会被误写成能力全集。

## 第一层：技能从哪里进入运行时

### 1. file-based skills

这是最容易被用户直接感知的一层。

`getSkillDirCommands(cwd)` 会从多种目录同时加载 skills：

- managed / policy skills
- `~/.claude/skills`
- 当前项目及向上目录中的 `.claude/skills`
- `--add-dir` 带进来的附加目录中的 `.claude/skills`

这层的共同点是：

- 以文件或目录形式存在
- 主要由 frontmatter 定义描述、工具白名单、模型、`userInvocable`、`disableModelInvocation`、`paths:` 等元数据
- 最终会变成 `type: 'prompt'` 的正式命令对象

### 2. legacy commands-as-skills

源码仍保留旧的 `commands` 目录加载链。

这意味着不是所有“技能”都只来自 `/skills/` 目录；旧的 commands-as-skills 仍会被视作一类 prompt 技能对象，并通过 `loadedFrom: 'commands_DEPRECATED'` 进入运行时。

对 userbook 来说，这层应写成：

- 仍受支持的旧暴露面
- 不是推荐的长期心智中心

而不应写成“现在只有 `.claude/skills` 一条路”。

### 3. bundled skills

这层不是磁盘上的项目技能，而是编译进 CLI 的 bundled skill 注册。

它们的特点是：

- 启动时由 `registerBundledSkill()` 注册
- `source: 'bundled'`
- `loadedFrom: 'bundled'`
- 可以声明 `userInvocable`、`disableModelInvocation`、`allowedTools`、`context`、`hooks`
- 还能在首次调用时把参考文件提取到专用 skill root 目录

所以 bundled skills 本质上是：

- 被编译进产品的官方工作流对象

而不是：

- 当前仓库里的用户自定义技能

### 4. plugin skills

插件技能来自已启用插件自己的 skill 目录或 manifest 指定的 skillsPaths。

它们的特点是：

- 只有 enabled plugins 才会被处理
- 最终 `source: 'plugin'`
- 处于 skill mode 时 `loadedFrom: 'plugin'`
- 同样支持 `userInvocable`、`disableModelInvocation`、`model`、`effort`、`allowedTools`

因此 plugin skills 应写成：

- 包管理层提供的技能来源

而不是：

- `/plugin` 的 UI 版本替代品

### 5. built-in plugin skills

这一层最容易误判。

它们来自 built-in plugins，但运行时会故意把它们标成：

- `source: 'bundled'`
- `loadedFrom: 'bundled'`

原因不是“它们真的是普通 bundled skills”，而是系统希望它们在 SkillTool 列表、描述预算截断、分析事件里按 bundled skill 的路径处理。

对 userbook 来说，这属于：

- 能解释设计意图的内部 provenance 细节

而不应轻易上升成用户稳定心智。例如“built-in plugin skills 一定会以 bundled 身份长期暴露”这种说法就过头了。

### 6. MCP skills

MCP prompts / MCP skills 是另一条独立线程。

关键点不是“它们也是 prompt”，而是：

- 它们不走 `getCommands()` 的主装配链
- 而是存在于 `AppState.mcp.commands`
- 需要时再由 `getMcpSkillCommands()` 之类的函数单独线程化并进来

因此 MCP skills 更像：

- 外部 server 提供的技能宇宙

而不是：

- 当前本地 skill 目录的又一种写法

## 第二层：`/skills` 菜单到底在展示什么

### `/skills` 不是“技能总库”，而是当前命令上下文上的一层菜单投影

`/skills` 本身只是一个 `local-jsx` 命令。它真正做的事情是：

- 读取 `context.options.commands`
- 交给 `SkillsMenu`
- 再由 `SkillsMenu` 过滤出它认作“技能”的那一小部分

所以 `/skills` 展示的是：

- 当前这条会话的命令上下文里，某些来源类别的 prompt 技能

而不是：

- Claude Code 所有技能的权威总表

### `SkillsMenu` 实际过滤的集合

`SkillsMenu` 当前只把下面这些 `loadedFrom` 视为要展示的技能：

- `skills`
- `commands_DEPRECATED`
- `plugin`
- `mcp`

这立刻带来一个关键结论：

- bundled skills 默认不在 `/skills` 菜单里
- built-in plugin skills 因为也被标成 `loadedFrom: 'bundled'`，默认也不在 `/skills` 菜单里

所以：

- `/skills` 能回答“我现在能看到哪些文件型 / 插件型 / MCP 型技能”
- 不能回答“Claude 还能调用哪些官方 bundled workflows”

### `/skills` 还会按来源分组，而不是按能力级别分组

当前 `SkillsMenu` 会按 source 分组：

- project
- user
- policy
- plugin
- mcp

这说明 `/skills` 的设计重点是：

- 让你理解“这些技能从哪里来”

而不是：

- 给出一份按主题穷举的官方能力全景

因此 userbook 不能把 `/skills` 菜单直接改写成“技能能力地图”。

## 第三层：Claude 通过 SkillTool 看到的技能为什么不同

### SkillTool 看的是“模型可调用集合”，不是 `/skills` 菜单集合

SkillTool 的 prompt 构造和附件注入会使用 `getSkillToolCommands(cwd)`，必要时再并入 `getMcpSkillCommands(...)`。

这条链的筛法和 `/skills` 明显不同：

- 必须是 `prompt`
- 不能 `disableModelInvocation`
- `source !== 'builtin'`
- 对 plugin / MCP 还更看重是否有明确描述或 `whenToUse`

这里最重要的差异有三条。

### 差异 1：bundled skills 会进入 SkillTool，但不会进入 `/skills`

这正是“`/skills` 不是能力全集”的最强证据之一。

对用户最关键的理解是：

- Claude 能自动想起并调用的一部分官方工作流
- 并不一定会出现在 `/skills` 菜单里让你手动翻

### 差异 2：`disableModelInvocation: true` 会把技能从模型集合里拿掉，但不一定阻止用户手打

例如 `debug` 这类技能更像：

- 需要用户显式请求
- 不希望默认占用模型技能预算

所以它们可以是：

- 用户可直打
- 模型不可自动调用

这再次说明“用户集合”和“模型集合”不是同一张表。

### 差异 3：`userInvocable: false` 正好相反

这类技能会：

- 被 slash 直调路径拒绝
- 但仍可供 Claude 自己通过 SkillTool 使用

最典型的心智修正是：

- “用户不能 `/skill-name`” 不等于 “系统没有这条技能”

因此 userbook 里不能把 `userInvocable: false` 写成“技能不存在”，而应写成：

- 模型面有，用户直调面没有

## 第四层：技能不是全都开机即显，文件触达会改变技能面

### 1. `paths:` 条件技能会先潜伏

带 `paths:` frontmatter 的技能，在 startup 加载时不会直接进入 unconditional skills。

它们会：

- 先被放进 `conditionalSkills`
- 等有文件路径命中 glob 后
- 再被移动进 `dynamicSkills`

所以这类技能的本质不是“已加载但隐藏”，而是：

- 运行时待激活技能

### 2. 嵌套 `.claude/skills` 目录可以在会话中途被动态发现

当模型或用户触碰文件路径时，系统会沿文件父目录向上走到 cwd：

- 搜索嵌套的 `.claude/skills`
- 只发现 cwd 以下的嵌套目录
- 深层目录优先
- 然后把新目录里的技能并入 `dynamicSkills`

这意味着：

- 技能面不是纯静态的启动快照
- 触碰文件本身就可能改变后续可用技能面

这也是为什么“我明明没装新插件，为什么这会儿多了几个技能”并不一定是错觉。

### 3. `dynamicSkills` 会重新插回命令链

`getCommands()` 在构造 baseCommands 后，还会：

- 读取 `getDynamicSkills()`
- 去重
- 再把它们插回 builtin 命令之前

因此 dynamic skills 不是旁路彩蛋，而是正式命令链的一部分。

## 第五层：模式和策略还会继续改写技能发现

### `--bare`

bare mode 下，系统会跳过：

- managed / user / project dir walks
- legacy commands-dir

只保留：

- 显式 `--add-dir` 路径里的 `.claude/skills`
- 以及另一路单独注册的 bundled skills

所以 bare mode 不是“更干净的同一世界”，而是：

- 主动收窄技能自动发现范围

### plugin-only policy / skillsLocked

当策略把 skills 限制到 plugin-only 时：

- user/project skill dir 加载会被跳过
- legacy commands-as-skills 也会被挡掉
- dynamic skill discovery 也会提前返回

因此这不是 UI 层小限制，而是：

- 来源层直接收窄

### project settings disabled

即使不是 plugin-only policy，只要 project settings 本身被禁用，动态发现与 conditional activation 也会被压缩。

所以“文件触发型技能为什么没出现”，不一定是 glob 写错，也可能是：

- 当前 settings source 根本没给这条链开门

## 对用户最关键的使用结论

### 结论 1

`/skills` 更像“当前会话对用户可见的技能菜单”，不是“Claude Code 全部技能宇宙”。

### 结论 2

如果一个技能不在 `/skills` 里，不代表系统就没有它。还要继续判断：

- 它是不是 bundled
- 它是不是 built-in plugin skill
- 它是不是 model-only
- 它是不是 `disableModelInvocation`
- 它是不是 `paths:` 条件技能尚未激活

### 结论 3

“技能来自哪里”与“谁能调用它”是两件事。至少要分开看：

- source / loadedFrom
- `userInvocable`
- `disableModelInvocation`

### 结论 4

文件触达会改变技能面。长任务里技能不是一份固定清单，而是会随：

- 嵌套 skill dir 被发现
- `paths:` 条件命中
- 插件启用状态变化

而发生变化。

## 最容易误写的六件事

### 误写 1

“`/skills` 展示全部 skills。”

更准确的写法：`/skills` 展示的是当前命令上下文里、特定来源类别的 prompt 技能投影。

### 误写 2

“bundled skills 就等于 `/skills` 菜单。”

更准确的写法：bundled skills 主要进入 SkillTool 和官方工作流面，不默认出现在 `/skills` 菜单里。

### 误写 3

“用户不能 `/skill-name`，说明这条技能不存在。”

更准确的写法：它可能只是 `userInvocable: false`，也就是只允许 Claude 调用。

### 误写 4

“Claude 能自动调的技能，用户肯定也能手动看到。”

更准确的写法：模型投影与用户投影是两张不同的技能表。

### 误写 5

“技能面在会话开始后就固定了。”

更准确的写法：dynamic discovery 和 `paths:` activation 会让技能面在会话中途继续增长。

### 误写 6

“MCP skills 只是本地技能的另一种写法。”

更准确的写法：MCP skills 走的是 `AppState.mcp.commands` 这条外部 server 线程，再被单独并入技能索引链。

## 稳定事实与降级写法

### 可以写成稳定 userbook 事实的

- 技能来源不是单一目录，而是多路装配
- `/skills` 不是能力全集
- SkillTool 与 `/skills` 的投影不同
- `userInvocable` 与 `disableModelInvocation` 是两种不同边界
- 动态发现和条件激活会改变会话中的技能面

### 更适合降级为实现细节或灰度元数据的

- built-in plugin skills 当前被标成 `source/loadedFrom = bundled`
- `loadedFrom` 的内部分类值与排序细节
- 某些 UI 分组和 token 估算方式
- 某些 consumer 侧对 `kind`、truncation、telemetry 的处理

这些可以作为解释设计的证据，但不应直接上升为长期产品承诺。

## 源码锚点

- `claude-code-source-code/src/commands/skills/index.ts`
- `claude-code-source-code/src/commands/skills/skills.tsx`
- `claude-code-source-code/src/components/skills/SkillsMenu.tsx`
- `claude-code-source-code/src/commands.ts`
- `claude-code-source-code/src/skills/loadSkillsDir.ts`
- `claude-code-source-code/src/skills/bundledSkills.ts`
- `claude-code-source-code/src/plugins/builtinPlugins.ts`
- `claude-code-source-code/src/utils/plugins/loadPluginCommands.ts`
- `claude-code-source-code/src/tools/SkillTool/prompt.ts`
- `claude-code-source-code/src/tools/SkillTool/SkillTool.ts`
- `claude-code-source-code/src/utils/messages/systemInit.ts`
- `claude-code-source-code/src/utils/attachments.ts`
- `claude-code-source-code/src/services/mcp/client.ts`
