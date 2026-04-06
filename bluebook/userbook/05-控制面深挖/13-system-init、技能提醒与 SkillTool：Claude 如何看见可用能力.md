# system-init、技能提醒与 SkillTool：Claude 如何看见可用能力

## 用户目标

不是只知道 Claude Code “有很多技能和命令”，而是先看清：

- 远端客户端看到的能力清单从哪里来。
- Claude 本身在 turn 0 先看到什么。
- 为什么有时会出现 “Skills relevant to your task” 提醒。
- 为什么 `/skills` 菜单、system/init、SkillTool 三者看到的不是同一张表。

如果这一层不先拆开，读者最容易把这些不同对象混成一锅：

- `/skills`
- `system/init.slash_commands`
- `system/init.skills`
- `skill_listing`
- `skill_discovery`
- SkillTool 自己的技能列表
- DiscoverSkills 搜索链

## 第一性原理

Claude Code 不是把“全部能力”一次性平铺给 Claude。

它真正做的是把能力按对象和受众分成多条曝光链：

1. 给人类看的 UI 菜单。
2. 给 remote/web/mobile 客户端做 picker 和 gate 的 `system/init`。
3. 给 Claude 在模型上下文里看的 broad inventory。
4. 给 Claude 按当前任务动态推送的 relevant skills 提醒。
5. 给 SkillTool 自己做运行时调用校验的可调用集合。

所以更稳的提问不是：

- “Claude 到底看见了哪些技能？”

而是：

- “当前这条链路是给谁看的？”
- “它暴露的是广义库存、当前菜单，还是和当前任务相关的子集？”
- “它是稳定主线，还是实验搜索链的一部分？”

## 第一条链：`/skills` 是给用户看的菜单面

这一层上一批已经拆过，但这里要再明确它在整张曝光图里的位置。

`/skills` 是 `local-jsx` 命令。它把：

- `context.options.commands`

交给 `SkillsMenu`，然后只筛出：

- `prompt`
- 且 `loadedFrom in {skills, commands_DEPRECATED, plugin, mcp}`

的那一部分。

这意味着：

- `/skills` 菜单是用户菜单投影
- 不是能力库存总表
- 默认不会列出 bundled skills
- 也不会把 built-in plugin skills 当成独立菜单面给你看

所以 `/skills` 的对象是：

- “现在这个会话里，我作为用户能翻到哪些技能对象”

而不是：

- “Claude 当前整套能力宇宙”

## 第二条链：`system/init` 是给 remote 客户端做 UI gating 的

### `system/init` 的对象不是模型提示，而是 SDK / remote session 元数据

`buildSystemInitMessage()` 明确把它定义为：

- SDK stream 的第一条 system message
- 供 remote clients 渲染 picker 与 gate UI

它包含的关键字段有：

- `tools`
- `mcp_servers`
- `model`
- `permissionMode`
- `slash_commands`
- `skills`
- `plugins`

这说明 `system/init` 的设计目的不是“再给模型多一点上下文”，而是：

- 让远端前端知道当前会话有哪些宿主能力和入口

### `slash_commands` 与 `skills` 是两张不同的 remote UI 表

`system/init` 里：

- `slash_commands` 来自 `inputs.commands.filter(c => c.userInvocable !== false).map(c => c.name)`
- `skills` 来自 `inputs.skills.filter(s => s.userInvocable !== false).map(skill => skill.name)`

这至少说明三件事：

- remote UI 也在区分 slash commands 与 skills
- `userInvocable: false` 的对象不会出现在这两张 remote 可见表里
- system/init 暴露面更接近“可点、可触发的入口”，不是内部保留能力

### `system/init` 的 skills 也不是 `/skills` 菜单

在 QueryEngine 路径里，`inputs.skills` 来自 `getSlashCommandToolSkills(getCwd())`。

而 `getSlashCommandToolSkills()` 选择的是：

- `prompt`
- `source !== 'builtin'`
- 有 `hasUserSpecifiedDescription` 或 `whenToUse`
- 且属于 `loadedFrom in {skills, plugin, bundled}` 或 `disableModelInvocation`

这立刻带来一个关键边界：

- remote `system/init.skills` 里可以含 bundled skills
- 但 `/skills` 菜单默认不会列 bundled skills

所以：

- remote client 的 skills picker
- 本地 `/skills` 菜单

本来就不是同一张表。

## 第三条链：`skill_listing` 是给 Claude 的 broad inventory

### `skill_listing` 的目标受众是模型，不是用户

`messages.ts` 对 `skill_listing` 的处理很直白：

- 把它包进 `system-reminder`
- 再生成一条 `isMeta` user message
- 内容是 `The following skills are available for use with the Skill tool: ...`

因此 `skill_listing` 的角色不是 UI 提示，而是：

- 给模型看的广义可用技能库存

### UI 上看见的不是真正的正文

`AttachmentMessage.tsx` 对 `skill_listing` 的可视化处理是：

- 初始批次 `isInitial` 直接不显示
- 后续增量才显示成类似 `N skills available` 的简短 UI 行

也就是说：

- 用户在 transcript 里看到的 skill listing 提示被大幅压缩
- 但模型真正收到的是更完整的 system reminder 文本

这再次说明：

- UI 可见面
- 模型可见面

不是同一层。

### `skill_listing` 的来源链

`getSkillListingAttachments()` 会先拿：

- `getSkillToolCommands(cwd)` 得到 local/bundled 可模型调用技能
- `getMcpSkillCommands(appState.mcp.commands)` 得到 MCP skills
- 必要时按名字去重合并

然后再做：

- 按 agentId 维度的 sent 去重
- resume 路径 suppression
- budget 截断格式化

对用户最重要的结论是：

- Claude 在 turn 0 或能力集变化后，会收到一份“广义技能库存”
- 这份库存比 `/skills` 菜单宽
- 但仍不是“所有潜在技能”，因为它已经经过 SkillTool 和 MCP skill 过滤

## 第四条链：`skill_discovery` 是按任务相关性动态推送的子集

### 这条链是实验搜索面，不是默认稳定主线

`skill_discovery` 与 DiscoverSkills tool 都在 `EXPERIMENTAL_SKILL_SEARCH` 条件下。

因此 userbook 里应明确降级写法：

- 这是源码可见、设计明确的一条能力曝光链
- 但属于条件公开 / 实验搜索面

不能写成“Claude Code 总会这样做”。

### 它暴露的不是广义库存，而是和当前任务相关的技能子集

`messages.ts` 对 `skill_discovery` 的 system reminder 内容是：

- `Skills relevant to your task:`
- 后接技能名与简短描述

而 `AttachmentMessage.tsx` 的 UI 只显示：

- `N relevant skills: name1, name2, ...`

所以它的角色非常明确：

- 不是再发一遍全部技能表
- 而是按当前任务抽出一个相关子集提醒 Claude

### 提醒本身还带 DiscoverSkills 的使用框架

`constants/prompts.ts` 里专门有一段 guidance：

- Relevant skills 会自动每回合作为提醒浮现
- 如果接下来要做的事不在这些提醒覆盖范围内
- 可以调用 DiscoverSkills tool 继续查
- 已经可见或已加载的技能会被自动过滤掉

这说明实验搜索链已经把能力曝光拆成两段：

1. 系统自动推一个相关子集
2. 再给模型一个按需扩检的工具

所以 `skill_discovery` 更像：

- relevance reminder

而不是：

- another skill menu

## 第五条链：SkillTool 自己还有一张运行时可调用表

### SkillTool 不是简单信任菜单或提醒

SkillTool 运行时真正校验调用名时，会走 `getAllCommands(context)`：

- 先拿本地 / bundled 命令链
- 再单独并入 `loadedFrom === 'mcp'` 的 MCP skills
- 明确排除 plain MCP prompts

这意味着：

- Claude 最终能不能真的调这条技能
- 不是只看它有没有出现在 `/skills`、system/init 或 skill_listing
- 还要看 SkillTool 的运行时命令集合是否认可它

### `disableModelInvocation` 在这里会成为硬门

SkillTool 对 `disableModelInvocation` 的处理不是软提醒，而是直接拒绝：

- 找到命令
- 但若 `disableModelInvocation` 为真
- 就返回 “cannot be used with SkillTool”

所以对模型来说，`disableModelInvocation` 才是真正的“运行时不可调”。

而这和：

- 用户能否 `/skill-name`
- 菜单里能否看见

仍然是三套不同边界。

## 第六条链：subagent 与 search 模式还会进一步裁剪曝光

### subagent 不是主线程曝光面的简单复制

`enhanceSystemPromptWithEnvDetails()` 明确写了：

- subagents 会收到 `skill_discovery` attachments
- 但它们不走完整 `getSystemPrompt`
- 所以要单独补上 DiscoverSkills guidance

这说明：

- 主线程和子代理对技能提醒的 framing 都要单独照顾
- 子代理并不是“天然继承主线程全部能力曝光面”

### skill search 开启时，turn-0 broad listing 会被压缩

`attachments.ts` 里说明了一个很重要的细节：

- 当 skill search 开启
- turn-0 / subagent 的 broad listing 不再维持全量 localCommands
- 而是先过滤到 bundled + MCP
- 若再过大，则继续退到 bundled-only

这属于非常典型的“实现可见但应降级措辞”的事实：

- 它很适合解释为什么某些环境下 Claude 起步时只先看见官方和外部 server 技能
- 但不适合直接写成长期稳定产品承诺

## 对用户最关键的使用结论

### 结论 1

不要把 `/skills`、`system/init.skills`、`skill_listing`、`skill_discovery` 当成同一张表。它们面对的是不同受众、不同用途。

### 结论 2

Claude 起步时更像被给了多层能力线索：

- remote/UI 元数据
- broad inventory
- task-relevant reminder
- 真正调用时的 SkillTool runtime 校验

所以“Claude 为什么没用某个技能”不能只看 `/skills` 菜单。

### 结论 3

如果实验搜索链开启，Claude 不一定先看到最大那张技能库存，而可能先看到：

- 相关技能提醒
- 或经过裁剪的 bundled + MCP turn-0 列表

### 结论 4

对使用层最稳的策略是：

- 把 `/skills` 当成人类浏览面
- 把 skill reminder 当成模型当前最被鼓励使用的子集
- 把 SkillTool 当成真正的运行时调用门

## 最容易误写的七件事

### 误写 1

“`system/init.skills` 就是 `/skills` 菜单。”

更准确的写法：前者是 remote/SDK 元数据，后者是本地用户菜单。

### 误写 2

“`skill_listing` 就是用户看到的技能列表。”

更准确的写法：它主要是模型 broad inventory，UI 只显示压缩后的提示。

### 误写 3

“`skill_discovery` 只是另一份全量技能表。”

更准确的写法：它是和当前任务相关的技能子集提醒。

### 误写 4

“只要在提醒里出现，SkillTool 就一定能调。”

更准确的写法：最终还要过 SkillTool 的运行时可调用校验。

### 误写 5

“`disableModelInvocation` 只是建议模型别用。”

更准确的写法：对 SkillTool 来说它是硬门。

### 误写 6

“subagent 天然继承主线程同样完整的技能曝光面。”

更准确的写法：subagent 还会走单独的提醒 framing 与搜索裁剪逻辑。

### 误写 7

“实验搜索链只是 UI 增强，不影响 Claude 看见什么。”

更准确的写法：它会改变 relevant reminder、DiscoverSkills framing，甚至影响 broad listing 的 turn-0 裁剪策略。

## 稳定事实与降级写法

### 可以写成稳定 userbook 事实的

- 能力曝光不是一张表，而是多条不同受众的链
- `/skills`、system/init、skill listing、skill discovery、SkillTool runtime 各自承担不同角色
- UI 可见面和模型可见面不同
- `disableModelInvocation` 是模型调用硬门

### 应降级为条件公开或实现细节的

- `EXPERIMENTAL_SKILL_SEARCH`
- DiscoverSkills tool 细节
- turn-0 bundled + MCP / bundled-only 裁剪策略
- remote skills / shortId / feedback 流
- 某些 subagent 与主线程之间的差异化注入策略

这些很适合当作源码证据，但不应被写成无条件产品承诺。

## 源码锚点

- `claude-code-source-code/src/utils/messages/systemInit.ts`
- `claude-code-source-code/src/QueryEngine.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/constants/prompts.ts`
- `claude-code-source-code/src/utils/attachments.ts`
- `claude-code-source-code/src/utils/messages.ts`
- `claude-code-source-code/src/components/messages/AttachmentMessage.tsx`
- `claude-code-source-code/src/tools/SkillTool/prompt.ts`
- `claude-code-source-code/src/tools/SkillTool/SkillTool.ts`
- `claude-code-source-code/src/commands.ts`
