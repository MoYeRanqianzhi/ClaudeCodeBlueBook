# Hooks 的加载、注册、执行与 UI：为什么 `/hooks` 看到的不是实际会跑的 hooks

## 用户目标

不是只知道 Claude Code “有 `/hooks` 和若干 hooks 策略”，而是先看清四件事：

- settings hooks、plugin hooks、session hooks、skill/agent frontmatter hooks 分别从哪里进入运行时。
- `/hooks` 菜单到底在展示什么，为什么它不等于实际执行总线。
- `allowManagedHooksOnly`、`disableAllHooks`、`strictPluginOnlyCustomization['hooks']` 分别卡在哪一层。
- 为什么同一个 hooks 对象会在 UI、注册、执行和 trust 上表现出不同结果。

如果这四件事不先拆开，读者最容易把下面这些对象混成一锅“hooks 配置”：

- `/hooks` 菜单
- settings snapshot
- registered plugin hooks
- session hooks
- skill / agent frontmatter hooks
- `statusLine` / `fileSuggestion`
- workspace trust
- `allowManagedHooksOnly`
- `disableAllHooks`
- plugin-only hooks policy

## 第一性原理

Claude Code 治理 hooks 的方式，不是维护一张“hooks 总表”，而是把 hooks 拆成四层不同投影：

1. 加载层：哪些来源先被读进来。
2. 注册层：哪些 hooks 真正被挂到当前 session。
3. 执行层：哪些 hooks 在当前策略与 trust 下真的会跑。
4. UI 层：`/hooks` 当前给人展示了哪些对象。

因此更稳的提问不是：

- “为什么这个 hook 失效了？”

而是：

- 它是没被加载、没被注册、执行时被拦，还是只是 UI 看起来还在？

只要不先分清这四层，`/hooks` 就会被误写成运行时真相。

## 第一层：`/hooks` 是 UI 观察面，不是执行总线

### `/hooks` 先按当前 permission context 构造菜单视图

`/hooks` 命令本身只是一个 `local-jsx` 面板：

- 先读取当前 `appState.toolPermissionContext`
- 再用当前工具池生成 `toolNames`
- 交给 `HooksConfigMenu`

这说明 `/hooks` 的对象不是：

- 一个脱离当前会话的抽象 hooks 宇宙

而是：

- 当前 session、当前工具上下文下，UI 愿意给你看的 hooks 视图

### `/hooks` 不是编辑器，而是只读观察面

`SelectEventMode` 的文案已经把这件事说得很直白：

- 这是只读菜单
- 真正的修改应回到 `settings.json` 或让 Claude 代改

所以 userbook 更稳的写法应是：

- `/hooks` 是观察面

而不是：

- “hooks 的权威配置中心”

### “菜单里看得到”不代表“运行时会执行”

这是这页最重要的结论。

`/hooks` 的 UI 聚合链会结合：

- `getAllHooks()` 看到的 settings hooks 与 session hooks
- `hooksConfigManager` 追加进来的 registered plugin hooks

但执行侧真正使用的，却是另一条 `getHooksConfig(...)` 运行时组装链。

所以：

- UI 可见对象
- 运行时有效对象

本来就不是同一层。

## 第二层：hooks 进入运行时的方式本来就不一样

### settings hooks：先被快照化

settings-file hooks 会进入 `hooksConfigSnapshot`：

- managed settings 可直接决定空、managed-only 或 merged 结果
- plugin-only hooks policy 也先在这里收缩 settings hooks 的来源

因此这层更像：

- 配置快照面

而不是：

- 完整运行总线

### plugin hooks：走 registered hooks 独立通道

plugin hooks 不依赖 settings snapshot，而是走 registered hooks 这条单独通道。

这意味着：

- 它们在 UI 中可能通过 registered hooks 被看见
- 但是否执行，还要继续过 managed-only、trust 等后续门

所以 userbook 不能把：

- “plugin hooks 不在 snapshot”

误写成：

- “plugin hooks 就不受治理”

### session hooks：是当前 session 内存态对象

session hooks 的作用不是替代磁盘配置，而是：

- 给当前 session 或当前 agent 暂时挂入额外 hooks

这层尤其容易和 skill / agent frontmatter hooks 混写，因为后者常会落到 session hooks 注册链里。

更稳的写法应是：

- session hooks 是运行时内存态层

而不是：

- “又一种 settings hooks”

### skill / agent frontmatter hooks：不是天然执行，要先过注册门

skill 与 agent 的 frontmatter hooks 不是“对象存在就自动执行”。

它们会先经过注册判断：

- `hooks` surface 是否被锁成 plugin-only
- 来源是否是 admin-trusted

因此更准确的写法是：

- frontmatter hooks 是候选扩展声明
- 只有通过来源与 surface 判断，才会变成 session 可执行 hooks

## 第三层：三个 hooks 策略不是同一个总闸

### `strictPluginOnlyCustomization['hooks']` 锁的是来源，不是执行总闸

这条策略的核心效果是：

- 把 settings-file hooks 收缩到 managed 来源
- 同时让非 admin-trusted 的 skill / agent frontmatter hooks 无法注册

但它不是：

- 在执行层把所有 plugin hooks 或 session hooks 一刀切杀掉

所以 userbook 不该把它写成：

- “hooks 只要 plugin-only 就全部只剩 managed hooks”

更稳的写法是：

- 它先改写来源面与注册面

### `allowManagedHooksOnly` 收窄的是执行层

这条策略更强，也更容易误判。

它的运行时效果是：

- settings snapshot 只保留 managed hooks
- registered plugin hooks 在执行聚合时被跳过
- session hooks 也被跳过
- `SessionStart` / `Setup` 甚至连 plugin hooks 的加载都直接跳过

这说明：

- `allowManagedHooksOnly` 是 hooks 执行层的 managed-only 策略

而不是：

- 只是一个 UI banner 或只读提示

### `disableAllHooks` 还要区分 managed 与 non-managed 来源

这一点特别容易被误写。

若 `disableAllHooks` 来自 `policySettings`：

- 它才是真正的 hooks 全停

若 `disableAllHooks` 只来自 user/project/local 等 non-managed 来源：

- 运行语义会退化成 managed-only
- 并不是连 managed hooks 一起停掉

因此更稳的说法应是：

- `disableAllHooks` 不是一个脱离来源的绝对总闸

## 第四层：workspace trust 是执行前置条件，不只是 Trust Dialog 文案

### hooks 在交互模式下统一受 workspace trust 约束

`hooks.ts` 的注释写得非常明确：

- 所有 hooks 在交互模式下都要求 workspace trust

这条检查是集中执行的，目的就是避免：

- 某些路径在 trust 建立前提前触发 hooks
- 未来新代码路径绕过 trust

因此 userbook 里更稳的写法应是：

- hooks 的最终执行权，不只取决于配置，还取决于当前 workspace 是否已被信任

### 所以 Trust Dialog 没提示某类 hooks，不代表运行时没有 hooks 门

Trust Dialog 关注的是工作区信任边界上的高风险对象。

但 hooks 运行时的实际执行门，则是更统一的：

- 交互模式下所有 hooks 都要过 trust

这意味着：

- TrustDialog 的提示面
- hooks 的执行前置条件

不是同一对象。

## 第五层：`statusLine` / `fileSuggestion` 是 hooks 邻域，不是普通 hook matcher

### 它们共享 trust 和 managed-only 语义

`statusLine` 与 `fileSuggestion` 的执行路径会复用：

- workspace trust 检查
- managed-only / managed disable 的判断

所以它们和 hooks 治理是同一治理家族。

### 但它们不是普通 `/hooks` 菜单里的 matcher 世界

这两条路径并不是：

- 事件 matcher + hook list 的普通运行总线

而是：

- hooks 邻域里的专用命令入口

因此 userbook 不应把它们直接混写成：

- “`/hooks` 菜单里看到的普通 hooks”

更稳的写法是：

- hooks 邻域的专用旁路命令

## 最容易误写的八件事

### 误写 1

“`/hooks` 菜单就是会执行的 hooks 总表。”

更准确的写法：`/hooks` 是 UI 观察面，真实执行要再过 snapshot、registration、policy 与 trust。

### 误写 2

“只要 hook 配在 settings 里，就一定进入执行。”

更准确的写法：settings hooks 先进入 snapshot，再继续受 managed-only、plugin-only 与 trust 影响。

### 误写 3

“plugin-only hooks policy 会把 hooks UI 也同步清干净。”

更准确的写法：它主要改写来源面与注册面，UI 仍可能把某些对象显示出来。

### 误写 4

“`allowManagedHooksOnly` 只是 UI 上的一条策略提示。”

更准确的写法：它会真实改变 registered plugin hooks、session hooks 与 SessionStart/Setup 的执行结果。

### 误写 5

“`disableAllHooks` 无论来源如何都是全局 kill switch。”

更准确的写法：只有 managed 来源的 `disableAllHooks` 才是真正全停；non-managed 更接近 managed-only。

### 误写 6

“skill / agent 还在，说明它的 frontmatter hooks 也还会跑。”

更准确的写法：frontmatter hooks 还要先过来源与 surface 注册门。

### 误写 7

“Trust Dialog 没提到 hooks，就说明 hooks 不受 workspace trust。”

更准确的写法：交互模式下所有 hooks 执行都统一受 workspace trust 限制。

### 误写 8

“`statusLine` / `fileSuggestion` 就是普通 hooks 事件。”

更准确的写法：它们共享 hooks 家族的治理边界，但属于专用旁路命令。

## 稳定事实与降级写法

### 可以写成稳定 userbook 事实的

- hooks 至少有加载、注册、执行、UI 四层不同投影
- `/hooks` 是观察面，不是执行总线
- `strictPluginOnlyCustomization['hooks']`、`allowManagedHooksOnly`、`disableAllHooks` 分别作用于不同层
- skill / agent frontmatter hooks 仍要过来源信任与注册门
- 交互模式下 hooks 执行统一要求 workspace trust

### 应降级为实现细节或维护记忆的

- UI 具体通过哪些 grouping 函数把 registered plugin hooks 拼进来
- `statusLine` / `fileSuggestion` 的具体 timeout、命令结构和返回值格式
- registered hooks 与 session hooks 的精确内部数据结构
- 某些 disabled modal / banner 的即时文本

这些都适合作为源码证据，但不应写成长期稳定产品合同。

## 源码锚点

- `claude-code-source-code/src/commands/hooks/index.ts`
- `claude-code-source-code/src/commands/hooks/hooks.tsx`
- `claude-code-source-code/src/components/hooks/HooksConfigMenu.tsx`
- `claude-code-source-code/src/components/hooks/SelectEventMode.tsx`
- `claude-code-source-code/src/utils/hooks/hooksSettings.ts`
- `claude-code-source-code/src/utils/hooks/hooksConfigSnapshot.ts`
- `claude-code-source-code/src/utils/hooks.ts`
- `claude-code-source-code/src/utils/sessionStart.ts`
- `claude-code-source-code/src/utils/hooks/hooksConfigManager.ts`
