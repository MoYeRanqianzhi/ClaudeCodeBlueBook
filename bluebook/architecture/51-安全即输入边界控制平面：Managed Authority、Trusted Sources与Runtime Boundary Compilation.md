# 安全即输入边界控制平面：Managed Authority、Trusted Sources与Runtime Boundary Compilation

这一章回答五个问题：

1. 为什么 Claude Code 的安全不该被理解成“执行前多几道检查”，而该被理解成输入边界控制平面。
2. 为什么 `policySettings` 的关键价值在于决定“谁有资格扩张能力边界”。
3. 为什么 Claude Code 在 allowlist 与 deny/self-restriction 上故意采用不对称设计。
4. 为什么 `sandboxTypes -> settings/types -> sandbox-adapter` 构成了一条正式的 boundary compilation 链，而不是零散 if 判断。
5. 为什么这条线也解释了 Claude Code 的源码结构为什么显得成熟。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/settings/constants.ts:159-180`
- `claude-code-source-code/src/utils/settings/settings.ts:319-343`
- `claude-code-source-code/src/utils/settings/settings.ts:665-689`
- `claude-code-source-code/src/utils/managedEnv.ts:93-135`
- `claude-code-source-code/src/entrypoints/sandboxTypes.ts:1-133`
- `claude-code-source-code/src/entrypoints/sdk/coreTypes.ts:1-16`
- `claude-code-source-code/src/utils/settings/types.ts:655-655`
- `claude-code-source-code/src/utils/permissions/permissionsLoader.ts:27-120`
- `claude-code-source-code/src/utils/hooks/hooksConfigSnapshot.ts:9-83`
- `claude-code-source-code/src/services/mcp/config.ts:337-360`
- `claude-code-source-code/src/utils/settings/pluginOnlyPolicy.ts:1-58`
- `claude-code-source-code/src/utils/sandbox/sandbox-adapter.ts:172-247`
- `claude-code-source-code/src/utils/sandbox/sandbox-adapter.ts:743-752`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:15-60`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:321-337`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:457-550`
- `claude-code-source-code/src/utils/settings/changeDetector.ts:437-447`

## 1. 先说结论

Claude Code 这里最值得升级的一层理解不是：

- 执行时做更多安全检查

而是：

- 先定义谁有资格改变系统边界，再把这个决定编译进运行时

这就是为什么 `policySettings` 重要。

它不是普通配置层，而是：

- authority control plane

它先回答：

1. 哪些输入源是高信任来源。
2. 哪些扩权输入只能来自这些来源。
3. 这些来源给出的 contract 如何继续下沉成 runtime hard boundary。

所以 Claude Code 的安全模型并不是：

- prompt 说谨慎一点
- tool 内部再做几层判断

而是：

- authority first
- source-gated expansion
- compiled runtime boundary

## 2. `policySettings` 的关键不是“多一层配置”，而是“能力授予权”

`constants.ts` 明确说明：

- `policySettings` 总是启用
- `policySettings` 不属于可编辑 source

`settings.ts` 又明确说明：

- `policySettings` 采用 first source wins
- 优先级不是“所有来源一起 merge”，而是 remote > MDM/HKLM/plist > managed file/drop-ins > HKCU

这说明它真正表达的是：

- 当前系统认定的最高治理真相

这比“加一层 enterprise config”要深得多。

因为它在回答一个更根本的问题：

- 谁有资格把系统边界往外推

如果这个问题没被单独建模，后面的：

- sandbox
- hooks
- permissions
- MCP allowlist
- skills / agents / commands

都会退化成：

- 各处各自做一点限制

那就不再是控制平面，而只是事后补丁。

## 3. Claude Code 的安全是不对称的：扩权只认高信任，收权允许本地自限

最关键的观察不是“managed settings 很强”，而是：

- Claude Code 明确区分扩权输入和收权输入

### 3.1 sandbox 面

`sandboxTypes.ts` 定义了：

- `allowManagedDomainsOnly`
- `allowManagedReadPathsOnly`

`sandbox-adapter.ts` 进一步落实为：

- allowed domains 可被锁到 `policySettings`
- `allowRead` 可被锁到 `policySettings`
- deny domains / deny paths 仍可来自全部来源

也就是说：

- 放大模型网络/读权限的 allowlist 可以被收敛到 managed source
- 本地用户的 deny / 自我限制仍然有效

这是一种典型的安全不对称：

- 扩张能力要高信任
- 缩小能力允许低信任

### 3.2 permission rules 面

`permissionsLoader.ts` 中的 `allowManagedPermissionRulesOnly()` 说明：

- 当策略要求时，只使用 `policySettings` 的 permission rules
- “always allow” 之类交互选项也会被隐藏

这意味着权限系统真正被治理的不是：

- 某一次弹窗要不要出现

而是：

- 谁有资格持久定义 allow rule

### 3.3 hooks 面

`hooksConfigSnapshot.ts` 里写得更清楚：

- managed settings 可以直接 `disableAllHooks`
- `allowManagedHooksOnly` 可以把 hooks 收敛到 managed
- 非 managed 的 `disableAllHooks` 不能关闭 managed hooks

这再次证明 Claude Code 的安全并不追求对称性。

它追求的是：

- 低信任来源可以限制自己
- 但不能撤销高信任来源已经建立的边界

### 3.4 MCP 与 customization surfaces 面

`services/mcp/config.ts` 明确区分：

- MCP allowlist 可以被锁到 managed settings
- MCP denylist 始终从所有来源合并

`pluginOnlyPolicy.ts` 则把同一个模式扩展到：

- skills
- hooks
- commands
- agents

这里的核心已经不是 shell 或 network，而是：

- 哪些 customization surface 有资格由谁定义

所以 Claude Code 的安全边界并不止于执行边界，也覆盖：

- 配置输入边界
- 生态输入边界
- 协作输入边界

## 4. Trusted Sources 先于 trust dialog，本身就是控制平面设计

`managedEnv.ts` 里有一条非常关键的设计：

- `userSettings`
- `flagSettings`
- `policySettings`

被视为 trusted setting sources，其 env 可以在 trust dialog 之前生效。

但：

- `projectSettings`
- `localSettings`

不在这个集合里。

这说明 Claude Code 很清楚：

- “是否属于项目目录”会改变一个输入的信任级别

所以它不是先默认所有 env 都能影响初始化，再靠后续检查补救，而是：

- 先把高信任输入面定义出来
- 再继续初始化

这正是控制平面式设计，而不是执行期临时修补。

## 5. `sandboxTypes -> SDK/types -> adapter` 是 boundary compilation 链

如果只盯 `sandbox-adapter.ts`，容易误以为安全语义都埋在实现细节里。

如果只盯 `sandboxTypes.ts`，又容易误以为 schema 本身已经等于安全。

更准确的理解是：

1. `sandboxTypes.ts` 定义边界 contract。
2. `settings/types.ts` 与 SDK `coreTypes.ts` 复用这份 contract。
3. `sandbox-adapter.ts` 再把 contract 编译成 OS/runtime 级限制。

这条链很重要，因为它说明 Claude Code 的安全并不是：

- BashTool 里写一段
- WebFetch 里写一段
- setup 里再写一段

而是：

- 先把边界类型做成共源 contract
- 再让 runtime adapter 成为唯一编译点

这正是成熟源码最值钱的地方之一：

- contract-first
- adapter-enforced

## 6. `sandbox-adapter` 不只执行限制，还保护控制平面本身

`sandbox-adapter.ts` 最容易被低估的一点是：

- 它不仅限制 agent 做什么
- 还限制 agent 去改未来的策略输入源

源码里能看到它会把这些路径加入 `denyWrite`：

- settings 文件
- managed drop-in 目录
- 原始 cwd 与当前 cwd 下的 `.claude/skills`

这意味着 Claude Code 的 hard boundary 也在保护：

- 未来轮次的 control plane 不被本轮 agent 篡改

这比“阻止某个危险命令”更深，因为它在保护：

- 系统治理真相本身

同样，`initialize()` 里对 network ask callback 的统一包装说明：

- `allowManagedDomainsOnly` 并不依赖某个调用方自觉遵守
- REPL、print、SDK 都被统一罩住

这正是扼流点式 enforcement。

## 7. remote managed settings 更像分发与热更新通道，而不是最终边界

`remoteManagedSettings/index.ts` 的设计也很有启发：

1. 先做 schema validation。
2. 危险变更先走 `checkManagedSettingsSecurity(...)`。
3. 通过后写 session cache / disk cache。
4. 再 `notifyChange('policySettings')` 扇出更新。

这说明 remote managed settings 的职责更接近：

- control plane distribution channel

而不是：

- 真正执行安全边界的最后一层

真正的边界仍然在：

- settings merge
- source gating
- runtime adapter enforcement

所以 Claude Code 的安全系统是分层的：

1. 分发层：拿到策略
2. 治理层：决定哪些输入有资格生效
3. 编译层：把 contract 变成 runtime boundary
4. 执行层：工具只能在该边界内运行

## 8. 这为什么能解释 Claude Code 的源码先进性

这条线之所以重要，不只是因为它更安全，而是因为它更能扩展。

它天然带来五个工程优势：

1. 策略语义集中在共源 schema 与少数 adapter/chokepoint，而不是散落到产品层。
2. 新增治理 surface 时，可以复用“扩权高信任、收权可本地自限”的现成模式。
3. 宿主、SDK、CLI 可以共享同一套边界类型，而不是各写一份解释。
4. 热更新只需重走 control plane 与 change fan-out，不必把每个消费者重写一遍。
5. 读代码时可以先找 authority source、再找 adapter compile 点，结构可推理。

这就是为什么 Claude Code 的源码虽然文件很多，但读起来仍有一种“边界被认真设计过”的感觉。

## 9. 一句话总结

Claude Code 的安全设计，真正厉害的不是执行前又多拦了一次，而是把“谁有资格扩张系统边界”建模成了一等控制平面，并把这份治理真相继续编译成统一的 runtime hard boundary。
