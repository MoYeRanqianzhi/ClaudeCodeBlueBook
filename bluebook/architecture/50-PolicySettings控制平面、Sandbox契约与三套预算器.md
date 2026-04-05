# PolicySettings控制平面、Sandbox契约与三套预算器

这一章回答五个问题：

1. 为什么 Claude Code 的安全设计不该被理解成“多几个设置项”，而该被理解成 `policySettings` 控制平面。
2. 为什么 `sandboxTypes` 只是策略契约，真正的硬边界要到 `sandbox-adapter` 才完成。
3. 为什么危险远端托管设置、trusted env、组织校验、skip-permissions 例外共同构成一套不对称安全模型。
4. 为什么 Claude Code 其实不是“一个总预算器”，而是三套以上预算机制的分层组合。
5. 这如何进一步解释“安全设计”和“省 token 设计”为什么是同一优化。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/settings/settings.ts:74-110`
- `claude-code-source-code/src/utils/settings/settings.ts:319-343`
- `claude-code-source-code/src/utils/settings/settings.ts:645-689`
- `claude-code-source-code/src/entrypoints/sandboxTypes.ts:1-133`
- `claude-code-source-code/src/utils/settings/types.ts:655-655`
- `claude-code-source-code/src/utils/sandbox/sandbox-adapter.ts:152-235`
- `claude-code-source-code/src/utils/sandbox/sandbox-adapter.ts:343-343`
- `claude-code-source-code/src/utils/sandbox/sandbox-adapter.ts:475-560`
- `claude-code-source-code/src/utils/sandbox/sandbox-adapter.ts:720-752`
- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:1-69`
- `claude-code-source-code/src/components/ManagedSettingsSecurityDialog/utils.ts:20-87`
- `claude-code-source-code/src/utils/managedEnvConstants.ts:75-125`
- `claude-code-source-code/src/utils/auth.ts:1914-1955`
- `claude-code-source-code/src/setup.ts:400-439`
- `claude-code-source-code/src/services/tools/toolExecution.ts:1403-1458`
- `claude-code-source-code/src/utils/toolResultStorage.ts:272-357`
- `claude-code-source-code/src/utils/toolResultStorage.ts:575-924`
- `claude-code-source-code/src/query.ts:369-383`
- `claude-code-source-code/src/services/compact/autoCompact.ts:33-140`
- `claude-code-source-code/src/query/tokenBudget.ts:1-75`

## 1. 先说结论

Claude Code 这里最值得升级的一条理解是：

- 统一第一性原理，不等于单一预算实现

也就是说，它确实在用同一个第一性原理处理：

- 安全
- 治理
- 省 token
- 连续性

但运行时里并不是只有“一个预算器”。

更准确的说法是：

1. `policySettings` 是高阶控制平面。
2. `sandboxTypes -> sandbox-adapter` 是策略契约到硬执行的转换链。
3. 预算器至少分成三套：
   - 工具结果预算
   - 上下文 headroom 预算
   - turn 输出/续写预算

所以 Claude Code 的先进性不在于“有一个万能计数器”，而在于：

- 同一第一性原理被拆成多套互补预算机制

## 2. `policySettings` 不是普通配置源，而是控制平面

`settings.ts` 里最关键的设计之一，就是 `policySettings` 不是和其他 settings 对等 merge。

源码明确采用：

- first source wins

优先级是：

1. remote managed settings
2. HKLM / plist
3. managed file / drop-ins
4. HKCU

这说明 `policySettings` 真正表达的不是：

- 很多策略配置的某一层

而是：

- 当前系统认定的最高治理来源

这种设计非常关键，因为它避免了策略层重新退化成：

- 多个来源各自提供一点意见
- 最后谁也说不清哪个才是真正边界

更准确的说法是：

- `policySettings` 在 Claude Code 里更像 control plane snapshot

而不是普通用户设置。

## 3. `sandboxTypes` 是策略契约，`sandbox-adapter` 才是硬执行

`sandboxTypes.ts` 很明确地把自己定义为：

- single source of truth for sandbox configuration types

但这并不意味着 schema 本身已经完成了安全。

真正的执行发生在 `sandbox-adapter.ts`。

### 3.1 schema 层定义了哪些治理意图

至少包括：

- `allowManagedDomainsOnly`
- `allowManagedReadPathsOnly`
- `failIfUnavailable`
- `autoAllowBashIfSandboxed`
- `allowUnsandboxedCommands`

这些字段表达的是：

- 哪些规则属于 managed-only
- 沙箱缺席时是 fail-open 还是 fail-closed
- 哪些例外在隔离环境里可被接受

### 3.2 adapter 层把治理意图写成运行时硬约束

`sandbox-adapter.ts` 会继续做：

- `shouldAllowManagedSandboxDomainsOnly()`
- `shouldAllowManagedReadPathsOnly()`
- settings 文件路径 denyWrite
- current / original cwd 下 `.claude/skills` denyWrite
- sandbox ask callback 包装
- `failIfUnavailable` 与 platform/dependency 检查

这说明 Claude Code 的安全设计不是：

- 先在 schema 里声明，再希望调用方自己记得遵守

而是：

- schema 负责 contract
- adapter 负责 hard enforcement

## 4. 这是一个不对称安全模型，不是单纯“越严越好”

这一层很容易被误读。

Claude Code 的安全不是对称收紧，而是：

- 对不同风险面采用不同 fail-open / fail-closed 策略

### 4.1 trusted env 可以在 trust 前先吃

`SAFE_ENV_VARS` 明确列出哪些环境变量可以在 trust dialog 前应用。

危险 env 则会被视为：

- 可能把流量、证书、项目身份重定向到攻击者控制面

### 4.2 危险 remote managed settings 会触发阻断式确认

`checkManagedSettingsSecurity(...)` 和 `ManagedSettingsSecurityDialog/utils.ts` 共同说明：

- 危险 shell settings
- 非安全 env vars
- hooks

一旦新增或变化，就会触发 blocking dialog。

从可见调用路径看，这一检查主要覆盖：

- remote managed settings 更新路径

这是一个推断，不是 schema 自身声明。

### 4.3 组织身份校验是 fail-closed

`validateForceLoginOrg()` 的注释直接写明：

- `forceLoginOrgUUID` 校验在无法确定 token 所属组织时会 fail closed

这说明身份/组织边界被视为：

- 比可用性更高的真相

### 4.4 `--dangerously-skip-permissions` 也不是“真的危险就别拦了”

`setup.ts` 里反而继续加了非常苛刻的条件：

- root/sudo 不允许
- ant 环境下必须在容器/沙箱中
- 还必须无公网

这说明即使是看起来最放松的 bypass 模式，系统也不允许它脱离：

- 隔离 + 无外网

这正好证明安全模型的核心不是“多确认”，而是：

- 把高风险动作限制在可承受边界内

## 5. Claude Code 不是一个预算器，而是三套预算器

这点很重要，因为前面的“统一预算器”很容易被误读成：

- 有一个数字在管一切

实际并不是。

### 5.1 第一套：工具结果对象级与消息级预算

在工具执行完成后，超大单条结果就会先经过：

- `processToolResultBlock()`
- `maybePersistLargeToolResult()`

落盘并替换成 preview。

然后进入 `query()` 时，还会对同一 API 级 user message 内的多条 `tool_result` 做聚合预算：

- `applyToolResultBudget()`

这说明最先发生的“省 token”不是：

- 总结聊天历史

而是：

- 先把最肥的工具输出移出上下文

### 5.2 第二套：上下文 headroom / autocompact 预算

`autoCompact.ts` 又是另一套预算：

1. 先从 context window 里扣掉 summary 输出空间
2. 再扣 autocompact buffer
3. 再算 warning / blocking threshold
4. reactive / context-collapse 模式下还会 suppress autocompact

这说明上下文预算真正关心的是：

- 给 compaction 和继续执行预留头部空间

### 5.3 第三套：turn 输出/续写预算

`query/tokenBudget.ts` 又是第三套：

- 它不压历史
- 不替换工具结果
- 而是决定当前回合是否继续“干活，不要总结”

再往下，API `task_budget` 和客户端 `tokenBudget` 还不是同一层。

所以 Claude Code 的实际结构是：

- 统一原则
- 多套预算机制

## 6. 为什么这进一步解释了“安全与省 token 是同一优化”

把上面的几层放在一起看，就会发现一个更精确的表述：

- 安全不是成本侧系统
- 省 token 也不是摘要侧系统

二者都在做：

- 限制无序扩张

只是扩张对象不同：

1. 安全与治理限制动作面、输入来源、身份边界
2. 工具结果预算限制最肥输出进入 prompt
3. 上下文预算限制工作集膨胀
4. turn 预算限制无限续写

所以真正统一它们的，不是“大家都叫 budget”，而是：

- 它们都在为 runtime 争夺可治理的稳定工作面

## 7. 苏格拉底式追问

### 7.1 如果一个远端设置能改 proxy、CA 或 hooks，它还是“普通配置”吗

不是。
它已经在改系统的输入边界。

### 7.2 如果单条工具结果就足够把 prompt 撑爆，为什么还以为省 token 的第一步是总结历史

那说明你还没看到最肥的输入面在哪里。

### 7.3 如果一个系统只有一个总预算器，为什么还要区分 tool result replacement、autocompact headroom、turn continuation

因为它们治理的是不同对象、不同阶段、不同失败模式。

### 7.4 为什么 `policySettings` 必须 first-source-wins

因为高阶边界真相如果被普通 merge 掉，就不再是控制平面，只剩下配置噪音。

## 8. 一句话总结

Claude Code 的安全与省 token 之所以是同一优化，不是因为它只有一个预算器，而是因为 `policySettings`、sandbox enforcement 和三套预算机制都在共同限制系统的无序扩张。
