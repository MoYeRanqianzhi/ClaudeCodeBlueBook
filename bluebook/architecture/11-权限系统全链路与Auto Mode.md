# 权限系统全链路与 Auto Mode

这一章回答五个问题：

1. Claude Code 的权限系统从启动到工具执行到底经过几层。
2. permission mode、rule source、tool check、classifier、headless fallback 如何串起来。
3. auto mode 为什么不是“全都交给 classifier”。
4. 为什么 dangerous rule stripping 是 mode transition 的组成部分。
5. 为什么这套系统本质上是 policy engine，而不是弹窗 UI。

## 1. 先说结论

Claude Code 的权限系统至少有五段主链：

1. 初始模式决议：CLI、settings、gate、remote 共同决定初始 mode。
2. 上下文装配：加载磁盘规则、CLI 规则、base tools、附加目录，构造 `ToolPermissionContext`。
3. 规则与工具检查：deny/ask/allow rule 与 `tool.checkPermissions(...)` 共同决定基础结果。
4. mode 覆写层：`bypassPermissions`、`dontAsk`、`auto`、`plan+auto`、headless/async 在基础结果上继续变换。
5. classifier / hooks / fallback：auto mode 的 classifier、PermissionRequest hooks、auto-deny、denial tracking 负责最后收口。

关键证据：

- `claude-code-source-code/src/utils/permissions/PermissionMode.ts:21-140`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:84-147`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:149-245`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:510-645`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:689-810`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:872-1033`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:1078-1158`
- `claude-code-source-code/src/utils/permissions/permissions.ts:109-131`
- `claude-code-source-code/src/utils/permissions/permissions.ts:213-343`
- `claude-code-source-code/src/utils/permissions/permissions.ts:473-955`
- `claude-code-source-code/src/utils/permissions/permissions.ts:958-1058`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1071-1318`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1408-1471`

## 2. permission mode 本身就是有内外边界的类型系统

### 2.1 并不是所有 mode 都属于外部可见面

`PermissionMode.ts` 里最重要的信号是：

- `default`
- `plan`
- `acceptEdits`
- `bypassPermissions`
- `dontAsk`
- ant-only 的 `auto`
- internal 的 `bubble`

而 `isExternalPermissionMode(...)` 会把 `auto`、`bubble` 排除在 external surface 之外。

证据：

- `claude-code-source-code/src/utils/permissions/PermissionMode.ts:21-24`
- `claude-code-source-code/src/utils/permissions/PermissionMode.ts:42-105`

这说明 Claude Code 不是只靠字符串枚举，而是从类型层就把“用户可见 mode”和“内部 runtime mode”分开。

### 2.2 mode 还带有显示层和外部映射层

每个 mode 都绑定：

- `title`
- `shortTitle`
- `symbol`
- `color`
- `external`

证据：

- `claude-code-source-code/src/utils/permissions/PermissionMode.ts:34-140`

因此 mode 不是纯策略值，而是同时服务 UI、SDK external mode 与 runtime 内部状态。

## 3. 初始 permission context 的装配链

### 3.1 初始 mode 不是单点决定

`initialPermissionModeFromCLI(...)` 会综合：

- `dangerouslySkipPermissions`
- `--permission-mode`
- settings `defaultMode`
- bypassPermissions disable gate
- auto mode circuit breaker
- remote 环境支持范围

证据：

- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:689-810`

这一步的本质是“求交集”，不是“照着用户偏好直接设置”。

### 3.2 `initializeToolPermissionContext(...)` 负责真正构造上下文

它会：

1. 解析 `allowedToolsCli` / `disallowedToolsCli`。
2. 处理 `baseToolsCli`，把未选中的工具自动转成 deny。
3. 加载磁盘上的全部 permission rules。
4. 识别 overly broad shell allow rules。
5. 在 auto mode 下识别 dangerous classifier-bypass rules。
6. 调 `applyPermissionRulesToPermissionContext(...)` 构造上下文。
7. 处理 additional working directories。

证据：

- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:872-1033`

这说明 permission context 不是静态配置快照，而是运行前合成结果。

## 4. rule source 也是正式状态面

`permissions.ts` 里定义的 source 顺序包括：

- `userSettings`
- `projectSettings`
- `localSettings`
- `policySettings`
- `flagSettings`
- `cliArg`
- `command`
- `session`

allow / deny / ask 三类规则都按 source 汇总成 `PermissionRule[]`。

证据：

- `claude-code-source-code/src/utils/permissions/permissions.ts:109-131`
- `claude-code-source-code/src/utils/permissions/permissions.ts:213-230`

而 `applyPermissionRulesToPermissionContext(...)` 与 `syncPermissionRulesFromDisk(...)` 进一步说明：

- 初始化是 additive。
- settings 热更新则是 replacement，并且会先清空旧的 disk-based source。

证据：

- `claude-code-source-code/src/utils/permissions/permissions.ts:1408-1471`

因此权限系统的真实对象不是“一个允许列表”，而是“按来源分层的规则叠加体”。

## 5. dangerous rule stripping：mode transition 里最关键的安全动作

### 5.1 为什么先识别危险规则

`permissionSetup.ts` 最早的一批函数就专门识别三类规则：

- Bash 危险规则
- PowerShell 危险规则
- Agent 危险规则

本质原因是：

- 这些 allow rule 会让动作在 classifier 之前就被自动放行。

证据：

- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:84-245`

### 5.2 进入 auto mode 时，不是直接改 mode，而是先 strip

`stripDangerousPermissionsForAutoMode(...)` 会：

- 遍历当前 allow rules
- 找到 classifier-bypass 规则
- 从上下文中移除
- 把被移除规则暂存到 `strippedDangerousRules`

离开 auto mode 时再通过 `restoreDangerousPermissions(...)` 加回去。

证据：

- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:510-579`

这一步极其关键，因为它说明 auto mode 的安全性不是 classifier 单独提供的，而是先靠 mode-specific context rewrite 把绕过路径删掉。

## 6. `transitionPermissionMode(...)` 才是真正的状态机核心

它统一处理：

- `plan` enter / exit
- `auto` activate / deactivate
- `prePlanMode` stash / clear
- dangerous rule strip / restore
- auto mode active flag
- exit attachment signals

证据：

- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:581-645`

所以 mode 不是字符串切换，而是带副作用和上下文变换的状态转移。

## 7. 工具执行前的基础决策链

`hasPermissionsToUseToolInner(...)` 的链路很值得单独拆出来。

### 7.1 第 1 层：规则与工具自身检查

依次检查：

1. 整个工具是否被 deny。
2. 整个工具是否被 ask。
3. `tool.checkPermissions(...)`。
4. tool-level deny。
5. `requiresUserInteraction()`。
6. content-specific ask rule。
7. bypass-immune safety check。

证据：

- `claude-code-source-code/src/utils/permissions/permissions.ts:1167-1260`

### 7.2 第 2 层：mode 与 allow rule 覆写

然后才进入：

- `bypassPermissions` / `plan + bypass` fast-path allow
- entire-tool always allow rule

证据：

- `claude-code-source-code/src/utils/permissions/permissions.ts:1262-1297`

### 7.3 第 3 层：把 `passthrough` 收口成 `ask`

最后才把未决结果统一变成可提示的 permission request。

证据：

- `claude-code-source-code/src/utils/permissions/permissions.ts:1299-1318`

从第一性原理看，这里体现的是：

- 规则优先于 mode 放行
- 安全检查优先于 bypass
- 工具本身的语义优先于外层 UI

## 8. auto mode 不是“全都交给 classifier”

### 8.1 auto mode 只接管 `ask` 结果

`hasPermissionsToUseTool(...)` 先拿 `hasPermissionsToUseToolInner(...)` 的结果。

只有当结果还是 `ask` 时，才进入：

- `dontAsk` 变换
- `auto` / `plan+auto` classifier 路径
- headless hook / auto-deny 路径

证据：

- `claude-code-source-code/src/utils/permissions/permissions.ts:473-518`

### 8.2 classifier 前还有多层 fast-path

在 auto mode 下，仍会先检查：

- 非 classifier-approvable safety checks 直接要求人工
- `requiresUserInteraction()` 直接回到人工
- PowerShell 在无对应 feature 时直接要求人工
- `acceptEdits` 语义下本可通过的动作跳过 classifier
- allowlisted safe tools 跳过 classifier

证据：

- `claude-code-source-code/src/utils/permissions/permissions.ts:526-590`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-686`

所以 auto mode 的真实含义是：

先用低成本、高确定性的规则与 fast-path，剩余灰区再交给 classifier。

### 8.3 classifier 路径本身也是状态机

classifier 阶段还会处理：

- telemetry / token / cost 记录
- unavailable 时 fail-closed 或 fail-open
- transcript too long 时退回人工
- denial tracking
- denial limit hit 后回退 prompting，或在 headless 直接 abort

证据：

- `claude-code-source-code/src/utils/permissions/permissions.ts:688-927`
- `claude-code-source-code/src/utils/permissions/permissions.ts:958-1058`

这说明 classifier 不是“一个 if 分支”，而是独立的子状态机。

## 9. headless / async 场景的收口方式

当前环境无法显示 permission prompt 时，Claude Code 会：

1. 先跑 `PermissionRequest` hooks。
2. 有 hook 决策就采用。
3. 否则 auto-deny。

证据：

- `claude-code-source-code/src/utils/permissions/permissions.ts:397-470`
- `claude-code-source-code/src/utils/permissions/permissions.ts:929-951`

这就是为什么 async/background/subagent 场景天然更保守：

- 它们不具备前台交互条件。
- 因此权限系统宁可 deny，也不允许隐式放宽。

## 10. auto mode gate access 还是异步校验的

`verifyAutoModeGateAccess(...)` 进一步说明：

- 启动时用 cached config 只是同步近似值。
- 真正的 authoritative auto-mode gate 要等 GrowthBook 初始化后异步确认。
- 它返回的不是静态 context，而是 transform function，避免异步结果把用户中途手动切 mode 的状态覆盖掉。

证据：

- `claude-code-source-code/src/utils/permissions/permissionSetup.ts:1035-1158`

这体现出作者对“异步 gate 校验会与用户操作竞争”这一细节有非常强的系统意识。

## 11. 从第一性原理看：这不是 permission dialog，而是 policy engine

如果把整个链路还原一下，会发现 Claude Code 真正在解决四个问题：

1. 不同信任来源的规则如何叠加。
2. 不同运行模式如何重写同一份 context。
3. 工具自身安全语义如何与全局策略交汇。
4. 没有人机交互条件时，系统如何 fail-closed。

所以更准确的说法不是“Claude Code 有权限弹窗”。
更准确的说法是：

Claude Code 有一套能够在前台、后台、auto、plan、remote、subagent 场景下持续工作的 policy runtime。

## 12. 相关章节

- 旧版总览：`05-权限系统与安全状态机.md`
- 工具协议：`../api/08-工具协议与ToolUseContext.md`
- 扩展 Frontmatter：`../api/10-扩展Frontmatter与插件Agent手册.md`
- 设计哲学：`../philosophy/03-安全观与边界设计.md`
