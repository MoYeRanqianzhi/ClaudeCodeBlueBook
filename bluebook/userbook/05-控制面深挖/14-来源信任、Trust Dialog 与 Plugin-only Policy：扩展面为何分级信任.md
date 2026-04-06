# 来源信任、Trust Dialog 与 Plugin-only Policy：扩展面为何分级信任

## 用户目标

不是只知道 Claude Code “有 Trust Dialog 和若干组织策略”，而是先看清三件事：

- 为什么同样是 skills / hooks / MCP / agents，不同来源会被系统区别对待。
- Trust Dialog 到底在防什么，为什么它特别关心某些能执行 Bash 的项目技能。
- `strictPluginOnlyCustomization`、`allowManagedHooksOnly`、`disableAllHooks` 这些设置分别锁住哪一层。

如果这三件事不先拆开，读者最容易把下面这些对象混成一锅“安全限制”：

- 工作区 Trust Dialog
- settings source 差异
- plugin-only policy
- hooks 的 managed-only / all-disabled
- admin-trusted source 例外
- agents/skills frontmatter 中的 hooks / MCP servers

## 第一性原理

Claude Code 治理的不是“能力本身”，而是“能力来自谁”。

同一条能力声明，系统至少会沿三个问题去判断：

1. 这个工作区我信不信。
2. 这条扩展来自用户控制源，还是管理员/产品控制源。
3. 这条扩展是在菜单里显示，还是已经进入运行时注册/执行阶段。

因此更稳的提问不是：

- “为什么这个 skill / hook / MCP server 被禁了？”

而是：

- “它卡在工作区信任边界、来源信任边界，还是执行期门控边界？”

如果把这页压成用户侧最小顺序，只该先做四步：

1. 先认 workspace trust
   - 当前工作区是否已被承认为可承载仓内扩展。
2. 再认 source trust
   - 这条扩展来自 user/project、plugin/managed，还是 built-in/bundled。
3. 再认 surface lock
   - 当前锁住的是 skills、hooks、MCP、agents 的哪一层 surface。
4. 最后才认 runtime gate
   - 真正被挡住的是注册、显示、还是执行。

这组顺序的核心，是把“安全限制”收回 `workspace trust -> source trust -> surface lock -> runtime gate`，而不是把 Trust Dialog、policy 和 hooks 总闸压成一个开关。

更短的判断是：

- 可见入口是发布承诺，不是运行时事实。
- 看见了，不等于已注册；已注册，也不等于会执行。

## 进入本页前的 first reject signal

看到下面迹象时，应先回到信任对象链，而不是继续把限制写成一锅：

- 你把 Trust Dialog 当一般功能开关，而不是工作区信任边界。
- 你把 plugin-only policy 写成“只能用插件”，却没说它锁的是 source/surface。
- 你把 `allowManagedHooksOnly` 和 `strictPluginOnlyCustomization['hooks']` 写成同一层规则。
- 你把“对象还在”直接等同于“它附带的 hooks / MCP servers 也还会生效”。

只要不先分清这三层，就会把 Trust Dialog、policy 与运行期 gating 写成一个平面。

## 第一层：Trust Dialog 是工作区信任边界，不是一般开关

### Trust Dialog 在问的是“这块工作区可不可以执行来自仓内的可执行扩展”

`TrustDialog` 的文案很直接：

- 这是在访问当前 workspace
- Claude Code 之后将能读、写、执行这里的文件

这不是普通的“欢迎弹窗”，而是工作区信任边界。

### 它重点关心的不是“所有技能”，而是“仓内扩展能否引出本地执行”

从实现意图看，Trust Dialog 并不是在对所有 skills / commands 做一刀切审查，而是在提高对这类组合的警惕：

- 能由当前工作区或本地配置携带
- 能通过 prompt 扩展进入执行路径
- 最终可能触发 Bash 一类本地执行能力

这说明 Trust Dialog 真正在防的不是“有 skill 就危险”，而是：

- 工作区里存在可随仓携带的可执行扩展
- 这些扩展一旦被接受，就可能把 prompt 工作流变成真实的本地执行入口

所以 userbook 里更稳的写法应是：

- Trust Dialog 重点防的是“仓内扩展借 prompt 工作流触发本地执行”

更短的判断是：

- Trust Dialog 在判工作区主权。
- plugin-only policy 在判来源主权。
- hooks 总闸在判执行主权。

而不是：

- “有 skill 就会弹 Trust Dialog”

### 工作区信任与非交互模式也不是同一回事

源码里还能看出：

- 部分非交互或特定 root command 路径不会经过这个对话框
- 它们会改用更轻的警示或入口约束，而不是复用同一交互确认面

这意味着：

- Trust Dialog 是交互工作区边界
- 不是所有入口统一经过的一般性权限面

因此它不应与：

- `/permissions`
- tool approval
- policySettings

混写成一类。

## 第二层：Plugin-only Policy 是来源锁定，不是功能总禁用

### `strictPluginOnlyCustomization` 锁的是 surface，不是整个产品

`CUSTOMIZATION_SURFACES` 当前明确列出四个可锁 surface：

- `skills`
- `agents`
- `hooks`
- `mcp`

所以 `strictPluginOnlyCustomization` 的对象不是“Claude Code 全部能力”，而是：

- 哪些可自定义扩展面只允许 plugin / managed 来源

### 被锁时，用户和项目来源会被跳过，但 admin-trusted 来源继续放行

`isRestrictedToPluginOnly(surface)` 的注释和实现都很清楚：

- user-level 和 project-level 来源会被跳过
- managed / policy 来源继续放行
- plugin 来源继续放行

这意味着 plugin-only policy 的真实含义是：

- 不是“禁止扩展”
- 而是“禁止用户自行从仓内或本地文件系统定义扩展”

### `isSourceAdminTrusted()` 明确给了来源白名单

当前被视为 admin-trusted 的 source 有：

- `plugin`
- `policySettings`
- `built-in`
- `builtin`
- `bundled`

这说明系统的信任模型很明确：

- 用户控制源默认低一级
- 产品内建、管理员托管、已通过 plugin 分发链的来源高一级

因此 userbook 不该把 plugin-only policy 写成：

- “只能用插件”

更稳的写法是：

- “用户/项目级自定义被锁到 plugin 或 managed 来源”

## 第三层：同一套来源信任，会在 skills / hooks / MCP / agents 上分别落地

### `skills`

skills loader 在启动期和动态发现期都会检查：

- `isRestrictedToPluginOnly('skills')`

被锁住时：

- user/project/`--add-dir`/legacy commands-as-skills 会被挡掉
- dynamic skill discovery 也会跳过
- managed skills 与 plugin skills 仍可进入

所以 skills 面的真实边界不是：

- “skills 开 / 关”

而是：

- “哪些来源还能定义 skills”

### `hooks`

hooks 这层最复杂，因为它有两个不同治理维度。

第一维是来源锁定：

- `strictPluginOnlyCustomization['hooks']`

第二维是 managed-only / all-disabled：

- `allowManagedHooksOnly`
- `disableAllHooks`

`hooksConfigSnapshot.ts` 明确写了几条规则：

- managed settings 若 `disableAllHooks === true`，直接空
- `allowManagedHooksOnly === true` 时，只保留 managed hooks
- plugin-only policy 会挡掉 user/project/local settings hooks
- 但 plugin hooks 不因此在执行期被一刀切杀掉

这很重要，因为它说明：

- plugin-only policy 和 allowManagedHooksOnly 不是一回事
- 一个在来源层锁 surface
- 一个在 hooks 执行层收窄到 managed-only

更直接地说：

- plugin-only policy 决定“谁能把声明带进来”。
- managed-only hooks 决定“带进来后谁还能活着执行”。

### hooks UI

`hooksSettings.ts` 里还明确了一条容易误判的 UX 事实：

- 如果 `allowManagedHooksOnly` 为真，UI 里干脆不展示 hooks 列表

所以“UI 里没看到 hooks”可能有两种完全不同的原因：

- 没有 hooks
- 有 managed-only policy，系统故意不让你在 UI 里编辑

### `skills` / `agents` 的 frontmatter hooks

这条很关键，也最容易被写漏。

`processSlashCommand.tsx` 在注册 skill hooks 时，不是简单看 `command.hooks`，而是：

- `!isRestrictedToPluginOnly('hooks') || isSourceAdminTrusted(command.source)`

`runAgent.ts` 对 agent frontmatter hooks 的判断是同样模式。

这说明：

- 即使某条 skill / agent 本身还能被加载
- 它附带的 frontmatter hooks 也可能因为来源不被 admin-trusted 而不注册

所以 userbook 不能把“skill 还在”写成“skill hooks 也还会生效”。

### `agents` 的 frontmatter MCP servers

`runAgent.ts` 对 agentDefinition.mcpServers 也用了同样的来源信任逻辑：

- 若 `mcp` surface 被锁成 plugin-only
- 且 agent source 不是 admin-trusted
- 就跳过这批 frontmatter MCP servers

因此 agent 面的规律是：

- agent 可以存在
- 但它附带的 MCP / hooks 运行面可能被继续收窄

这再次说明来源信任是比“对象存在”更高一层的治理。

## 第四层：`allowManagedHooksOnly` 与 `disableAllHooks` 是 hooks 专用的更强总闸

### `allowManagedHooksOnly`

它的作用不是“隐藏非托管 hooks 的来源”，而是：

- 在执行层只留下 managed hooks
- plugin hooks 的加载链也会在 session start 里被跳过
- hooks UI 还会刻意不展示可编辑 hooks

所以它是：

- hooks 层的 managed-only 运行策略

而不是：

- 全局插件策略

### `disableAllHooks`

它还要再分 managed 与 non-managed 两种情况。

`hooksConfigSnapshot.ts` 明确写出：

- 若 policySettings 里 `disableAllHooks === true`，包括 managed hooks 在内都停
- 若 non-managed settings 里 `disableAllHooks === true`，managed hooks 仍可继续

因此：

- 同样写成 `disableAllHooks`
- 它的治理强度还取决于 source

这是 userbook 必须明确写出来的来源层差异。

## 第五层：普通用户最容易误判的五件事

### 误判 1

“Trust Dialog 接受后，所有项目技能和 hooks 都能照常执行。”

更准确的写法：Trust Dialog 只解决工作区信任；后面还有 plugin-only policy、managed-only hooks、source trust 等门。

### 误判 2

“plugin-only policy 会把 plugin 也关掉。”

更准确的写法：它锁的是用户/项目来源，把 surface 收敛到 plugin 或 managed 来源。

### 误判 3

“skill 还在，就说明它的 hooks 也在。”

更准确的写法：skill / agent 的 frontmatter hooks 还要再过 `isSourceAdminTrusted()` 这一层。

### 误判 4

“UI 里没看到 hooks，说明没有 hooks。”

更准确的写法：`allowManagedHooksOnly` 也会让 UI 故意不显示 hooks 列表。

### 误判 5

“`disableAllHooks` 是一个绝对总闸。”

更准确的写法：只有 policySettings 来源的 `disableAllHooks` 才会连 managed hooks 一起停掉。

## 稳定事实与降级写法

### 可以写成稳定 userbook 事实的

- Trust Dialog 是工作区信任边界，不是一般功能开关
- `strictPluginOnlyCustomization` 锁的是 surface 的来源
- `isSourceAdminTrusted()` 使 plugin / policy / built-in / bundled 来源在某些表面上获得更高信任
- hooks 有自己的 managed-only / all-disabled 总闸
- skills / agents 的 frontmatter hooks / MCP servers 会继续受来源信任判断影响

### 应降级为实现细节或组织策略细节的

- Trust Dialog 当前具体扫哪些 `loadedFrom/source` 组合来判断 Bash 风险
- plugin hooks 与 session start 的具体跳过时机
- 某些 root command 跳过 Trust Dialog 的精确文案

这些可以作为设计证据，但不应写成一成不变的产品承诺。

## 源码锚点

- `claude-code-source-code/src/components/TrustDialog/TrustDialog.tsx`
- `claude-code-source-code/src/utils/config.ts`
- `claude-code-source-code/src/utils/settings/pluginOnlyPolicy.ts`
- `claude-code-source-code/src/utils/settings/types.ts`
- `claude-code-source-code/src/skills/loadSkillsDir.ts`
- `claude-code-source-code/src/services/mcp/config.ts`
- `claude-code-source-code/src/utils/hooks/hooksConfigSnapshot.ts`
- `claude-code-source-code/src/utils/hooks/hooksSettings.ts`
- `claude-code-source-code/src/utils/sessionStart.ts`
- `claude-code-source-code/src/utils/processUserInput/processSlashCommand.tsx`
- `claude-code-source-code/src/tools/AgentTool/runAgent.ts`
