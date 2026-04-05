# 插件双真相：enabled、editable scope与policy block不能混写

这一章回答五个问题：

1. 为什么 Claude Code 的插件系统不能被压成一个“enabled 开关”。
2. `checkEnabledPlugins()`、`getPluginEditableScopes()`、`installed_plugins.json`、`pluginPolicy.ts` 分别在维护什么真相。
3. 为什么“插件已安装”“插件已启用”“用户可编辑哪个 scope”“组织策略是否阻断”必须分层。
4. 这套分层怎样避免插件系统退化成多处半真相。
5. 对 Agent 平台构建者来说，这套设计最值得迁移的是什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/plugins/pluginPolicy.ts:1-20`
- `claude-code-source-code/src/utils/plugins/pluginStartupCheck.ts:30-71`
- `claude-code-source-code/src/utils/plugins/pluginStartupCheck.ts:75-159`
- `claude-code-source-code/src/utils/plugins/performStartupChecks.tsx:24-61`
- `claude-code-source-code/src/services/plugins/PluginInstallationManager.ts:51-90`
- `claude-code-source-code/src/utils/plugins/pluginIdentifier.ts:27-31`
- `claude-code-source-code/src/utils/plugins/pluginIdentifier.ts:98-117`
- `claude-code-source-code/src/utils/plugins/installedPluginsManager.ts:4-12`
- `claude-code-source-code/src/utils/plugins/installedPluginsManager.ts:368-376`
- `claude-code-source-code/src/utils/plugins/installedPluginsManager.ts:488-537`
- `claude-code-source-code/src/utils/plugins/installedPluginsManager.ts:1033-1164`
- `claude-code-source-code/src/utils/plugins/marketplaceHelpers.ts:472-520`

## 1. 先说结论

Claude Code 的插件系统里至少有四个不同真相：

1. 安装真相：
   - 插件是否已经被安装到全局安装面
2. 启用真相：
   - 这一轮启动时它是否真的处于 enabled
3. 可编辑作用域真相：
   - 如果用户要写回设置，应该写回哪一个 scope
4. 策略阻断真相：
   - 就算用户想启用，组织策略是否仍然禁止

真正成熟的地方就在于，作者没有把这四件事混成一个字段。

所以 Claude Code 的插件系统本质上不是：

- 一个 enabled 开关

而是：

- 多重 authoritative surfaces

更准确一点说，它至少包含两组容易被混淆的双真相：

1. runtime truth：
   - 当前到底是否生效
2. persistence / ownership truth：
   - 当前安装元数据存在哪里
   - 当前应该向哪个 scope 写回

## 2. `checkEnabledPlugins()`：这才是“插件是否启用”的 authoritative truth

`pluginStartupCheck.ts` 里已经把这点写得非常清楚：

- `checkEnabledPlugins()` 才是 authoritative "is this plugin enabled?" check

它做的事情是：

1. 从 `getInitialSettings()` 读取合并后的 settings
2. 按 policy > local > project > user 的优先级处理 `enabledPlugins`
3. 再把 `--add-dir` 等 session 级来源纳入最低优先级

这意味着“当前是否启用”根本不是：

- 某个单一 settings 文件里有个 `true`

而是：

- 所有来源合并后的最终真相

所以如果你绕开 `checkEnabledPlugins()`，自己去读某个 scope 的 `enabledPlugins`，你看到的很可能只是：

- 局部意图

而不是真正生效状态。

还有一个容易被忽略的点：

- `pluginStartupCheck.ts` 这个名字本身有误导性

因为真正的启动总控链路其实更像：

- `REPL.tsx`
- `performStartupChecks.tsx`
- `PluginInstallationManager`
- `reconciler`
- `refresh`

`pluginStartupCheck.ts` 更接近：

- 启用真相 / scope 真相辅助模块

而不是：

- 插件启动总控层

## 3. `getPluginEditableScopes()`：它不是启用真相，而是写回真相

同一个文件里作者又非常明确地说：

- `getPluginEditableScopes()` 不是 authoritative enabled check

它解决的是另一件事：

- 如果用户要 enable / disable，一个插件应该写回哪个 user-editable scope

这件事和“当前是否启用”不等价。

因为：

1. managed policy 可能正在覆盖用户选择。
2. `--add-dir` 等 session 级来源可能临时启用。
3. local / project / user 三层可能同时声明同一个插件。

所以 `editable scope` 真相更接近：

- 谁对这个插件拥有可编辑所有权

而不是：

- 当前插件是不是活着

这两件事如果混写，插件系统就会马上变成：

- 你能改的不是当前生效的
- 当前生效的又未必是你能改的

## 4. `pluginPolicy.ts`：策略阻断必须独立成 leaf truth

`pluginPolicy.ts` 很小，但非常关键。

它明确承担：

- policy-blocked plugins 的 single source of truth

并且刻意保持成：

- leaf module

这说明作者不愿意让“是否被组织策略阻断”混进：

- marketplace UI
- install path
- enable op
- settings merge

这些各自的局部逻辑里。

从第一性原理看，这很合理。

因为策略阻断属于：

- 比用户意图更高一级的边界真相

这种真相如果分散实现，就会立刻产生：

- 某处看起来能装
- 某处看起来能开
- 但真正运行时又被别处挡住

而且插件治理其实不只一条轴。

除了：

- 插件级 policy block

还存在：

- marketplace source 级 policy block

也就是：

- 这个具体插件是否被禁
- 这个来源市场整体是否允许

是两条不同治理轴。

这进一步说明策略系统不是：

- 一个总开关

而是：

- 多级边界共同裁决

## 5. `installed_plugins.json`：安装真相和启用真相故意分离

`installedPluginsManager.ts` 开头就把设计意图说得很清楚：

- 安装状态是全局的
- 启用/禁用状态是每仓库的

更进一步，`syncInstalledPluginsFromSettings()` 又反复强调：

- settings.json 是 scope 的 source of truth

这说明作者在插件系统里刻意拆开了两层：

1. installation state
2. enablement / scope state

这比很多系统把“装了且开着”压成一个值成熟得多。

因为从产品事实看，确实可能出现：

- 已安装但当前项目没启用
- 已安装且当前项目启用
- 已安装但被 policy block
- 已安装但 scope 迁移了

所以 `installed_plugins.json` 保存的是：

- 安装资产面

而 settings 保存的是：

- 当前项目的启用意图与 scope 面

还要再往前走一步：

- `installed_plugins.json` 也不是 live session truth

源码里已经明确出现两种设计：

1. session-frozen snapshot：
   - 当前运行时读的是内存快照
2. persistent metadata：
   - 磁盘上的 `installed_plugins.json` 提供 installPath / version hint

更进一步，loader 在 cache miss 时可以 materialize 插件目录，但并不会顺手回写 `installed_plugins.json`。

这说明作者故意区分：

- 当前会话正在用什么
- 磁盘上记录了什么安装元数据

如果把两者混成一层，就会再次出现：

- 当前能加载
- 但持久化记录尚未同步

这类“可运行但未记账”的半真相。

## 6. 为什么这是一套“双真相”，而不是一套单真相

从表面看，好像“真相越多越复杂”。

但 Claude Code 这里更准确的说法是：

- 它不是多真相，而是把本就不同的真相显式拆开

至少可以压成两大组：

### 6.1 运行时真相

- 当前是否真的 enabled
- 当前是否被 policy block

### 6.2 写回真相

- 当前插件写回哪个 scope
- 当前安装状态存在于哪里

这样做的结果是：

- 运行时不必猜写回来源
- 写回时不必伪装成运行时真相

这就是插件系统里的“双真相”：

- runtime truth
- editable / persistence truth

再展开一点，它至少包含四个独立平面：

1. installation truth
2. enabled truth
3. editable scope truth
4. policy truth

## 7. 为什么这比“一处 bool”更先进

如果把插件系统压成一个 `enabled: boolean`，系统会立刻丢失：

1. 策略覆盖信息
2. scope 所有权信息
3. 安装与启用分离信息
4. session-only 来源信息

而这些恰恰是插件系统真正复杂的地方。

所以 Claude Code 值得学的，不是它把插件系统写得更简单，而是它接受：

- 插件系统天然不是单开关问题

然后把复杂性收敛到少数权威入口。

## 8. 苏格拉底式追问

### 8.1 如果一个插件在 user scope 是 enabled，但 policySettings 把它写成 false，它当前算 enabled 吗

不该由 user scope 单独决定。
这正是 `checkEnabledPlugins()` 必须存在的原因。

### 8.2 如果一个插件当前生效，但用户真正能编辑的是 project scope，这两个事实是同一件事吗

不是。
一个是 runtime truth，一个是 editable scope truth。

### 8.3 如果插件已经安装在全局，但当前项目没启用，它到底算“有”还是“没有”

取决于你问的是安装真相还是启用真相。

### 8.4 为什么 `pluginPolicy.ts` 要被刻意做成 leaf

因为组织策略这种更高阶边界，不应该被插件子系统各处各自脑补。

### 8.5 为什么 loader cache-on-miss 不能被直接当成“已经安装”

因为运行时 materialization 和持久化安装记录不是同一层事实。

## 9. 一句话总结

Claude Code 的插件系统之所以稳，不是因为它有一个 enabled 开关，而是因为它把安装、启用、可编辑作用域和策略阻断拆成了不同的 authoritative truth surfaces。
