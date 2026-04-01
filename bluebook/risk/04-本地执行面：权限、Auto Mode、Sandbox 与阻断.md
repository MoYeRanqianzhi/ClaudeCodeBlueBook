# 本地执行面：权限、Auto Mode、Sandbox 与阻断

## 1. 先说结论

Claude Code 的本地执行面并不负责“封号”，但它负责把高风险动作尽量挡在本地。

它的结构是：

1. trust 前后分层初始化。
2. permission rules 与 tool-specific check。
3. safety check 与危险规则剥离。
4. auto mode classifier 与 denial tracking。
5. sandbox 对文件系统、网络与命令执行做最后一层包裹。

关键证据：

- `claude-code-source-code/src/entrypoints/init.ts:62-79`
- `claude-code-source-code/src/utils/permissions/permissions.ts:520-955`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1061-1260`
- `claude-code-source-code/src/entrypoints/sandboxTypes.ts:45-143`
- `claude-code-source-code/src/components/AutoModeOptInDialog.tsx:9-10`

## 2. trust 是本地安全链路的前置边界

`init.ts` 里很明确：

- trust 前只应用 safe env vars。
- 完整环境变量与 telemetry 初始化在 trust 后继续。

证据：

- `claude-code-source-code/src/entrypoints/init.ts:62-79`
- `claude-code-source-code/src/entrypoints/init.ts:241-268`

这说明本地执行面的第一道门不是 tool permission，而是 workspace trust。

## 3. 权限系统先做规则裁决，再做模式裁决

`hasPermissionsToUseTool()` 的前半段体现出严格顺序：

1. deny rule
2. ask rule
3. tool-specific check
4. content-specific ask
5. safety check

证据：

- `claude-code-source-code/src/utils/permissions/permissions.ts:1061-1155`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1169-1260`

这意味着 Claude Code 并不是一上来就让 classifier“想想看”，而是先尊重本地明确定义的禁止和人工确认边界。

## 4. auto mode 的真实含义是“受约束的自动执行”

Auto mode 的官方文案本身就写得非常保守：

- 每次工具调用都会检查 risky actions 和 prompt injection。
- 安全动作自动执行。
- 风险动作会被阻断。
- Claude 可能犯错，建议只在隔离环境中使用。

证据：

- `claude-code-source-code/src/components/AutoModeOptInDialog.tsx:9-10`

也就是说，auto mode 并不是“无人值守全权代理”，而是“在额外安全仲裁之下的自动化”。

## 5. auto mode 里不是所有动作都能交给 classifier

`permissions.ts` 里几个分支非常关键：

### 5.1 非 classifier-approvable 的 safety check 直接要求人工

如果某个 safety check 标成不可 classifier 批准，就不会被 auto mode 吞掉。

证据：

- `claude-code-source-code/src/utils/permissions/permissions.ts:526-548`

### 5.2 PowerShell 可能被排除出 auto classifier

当 `POWERSHELL_AUTO_MODE` 关闭时，PowerShell 需要显式人工批准。

证据：

- `claude-code-source-code/src/utils/permissions/permissions.ts:560-590`

### 5.3 acceptEdits 与 allowlist 只是 fast-path，不是放弃审计

如果动作在 `acceptEdits` 语义下本可允许，或者工具在 safe allowlist 里，就跳过 classifier，但仍会记录 `tengu_auto_mode_decision`。

证据：

- `claude-code-source-code/src/utils/permissions/permissions.ts:593-686`

### 5.4 classifier 会记录大量决策遥测

它会上报：

- allow / blocked / unavailable
- toolName
- classifier model
- denial streak
- token 与耗时

证据：

- `claude-code-source-code/src/utils/permissions/permissions.ts:688-817`

这说明 auto mode 不只是本地执行器，更是一个可观测、可回流的风控节点。

## 6. denial tracking 让系统避免在危险路径上无限重试

当 classifier 持续拒绝时：

- 会累计 consecutive / total denials。
- 超过阈值后，交互模式回退到 prompting。
- headless 模式则直接 abort。

证据：

- `claude-code-source-code/src/utils/permissions/permissions.ts:878-911`
- `claude-code-source-code/src/utils/permissions/permissions.ts:980-1057`

这类设计体现的不是 UX，而是“危险动作不应被自动代理无限碰撞”。

## 7. headless 场景默认更保守

当当前上下文无法弹出 permission prompt 时：

1. 先尝试 `PermissionRequest` hooks。
2. 如果 hooks 没给结论，则自动 deny。

证据：

- `claude-code-source-code/src/utils/permissions/permissions.ts:929-951`

所以 headless/async 子代理不是更自由，而是更受限。

## 8. sandbox 说明本地阻断已经下沉到系统资源层

`sandboxTypes.ts` 显示它可以管：

- allowed domains
- allowManagedDomainsOnly
- allowWrite / denyWrite / denyRead / allowRead
- allowManagedReadPathsOnly
- failIfUnavailable
- allowUnsandboxedCommands
- autoAllowBashIfSandboxed

证据：

- `claude-code-source-code/src/entrypoints/sandboxTypes.ts:14-42`
- `claude-code-source-code/src/entrypoints/sandboxTypes.ts:47-85`
- `claude-code-source-code/src/entrypoints/sandboxTypes.ts:91-143`

尤其关键的是：

- `allowManagedReadPathsOnly`
- `allowManagedDomainsOnly`
- `failIfUnavailable`

这些都说明组织级管理可以把 sandbox 变成硬门槛，而不是建议项。

## 9. 这层和“封号”是什么关系

本地执行面通常不直接决定账号被不被封，但它会显著影响两件事：

1. 危险动作能否在本地提前被截断。
2. 系统会不会把某次会话标记成高风险、频繁被拒绝或需要更强约束。

换句话说：

- 服务端更像能力与身份裁决中心。
- 本地执行面更像风险泄漏的前置防火墙。

## 10. 一句话总结

Claude Code 的本地安全链路不是“防封号小技巧”，而是把高风险动作尽量在 trust、permission、classifier 和 sandbox 这四层里消化掉。
