# 安全、权限、治理与Token预算统一图

这一章回答五个问题：

1. 为什么 Claude Code 的安全设计和省 token 设计应该一起看。
2. 权限系统、策略治理与上下文预算本质上在控制什么。
3. 为什么它们都不是外围约束，而是 runtime 主路径。
4. Claude Code 如何把动作空间和上下文空间一起收束。
5. 这套统一图对 Agent 平台设计者有什么启发。

## 0. 代表性源码锚点

- `claude-code-source-code/src/types/permissions.ts:16-38`
- `claude-code-source-code/src/types/permissions.ts:149-280`
- `claude-code-source-code/src/tools.ts:253-367`
- `claude-code-source-code/src/main.tsx:1747-1770`
- `claude-code-source-code/src/main.tsx:2239-2405`
- `claude-code-source-code/src/main.tsx:2655-2672`
- `claude-code-source-code/src/query.ts:369-540`
- `claude-code-source-code/src/query.ts:1065-1247`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/services/tokenEstimation.ts:244-324`
- `claude-code-source-code/src/state/onChangeAppState.ts:50-89`

## 1. 先说结论

安全系统和 token 经济系统，表面看约束对象不同：

- 安全约束动作空间
- token 经济约束上下文空间

但它们在 Claude Code 里的工程目标其实相同：

- 限制无序扩张
- 保持主路径稳定
- 让状态可恢复、可解释、可治理

所以更准确的说法不是：

- “安全和 token 经济需要权衡”

而是：

- “安全和 token 经济共用一个预算器，只是预算维度不同”

## 2. 动作预算：安全、权限、治理

Claude Code 在动作空间上至少有五道闸门：

1. mode
2. rule
3. tool-specific safety
4. classifier / auto mode 校验
5. policy / org / managed settings

更关键的是，这些闸门并不是只在工具调用时才出现。

它们会提前影响：

- 工具是否出现在模型可见工具池里
- MCP server 是否允许进入配置集合
- channels / remote session 是否允许启用
- bypassPermissions / auto mode 是否会被异步撤回

这说明 Claude Code 的安全系统并不是“最后弹个确认框”，而是：

- 一台持续收束动作空间的 runtime 预算器

## 3. 上下文预算：消息、输出、恢复

在上下文空间上，Claude Code 也有完整预算系统：

1. tool result budget 先控制大块输出。
2. snip / microcompact / autocompact 再控制历史消息。
3. reactive compact 负责异常恢复。
4. token budget continuation 负责把“用户要求多花 token”变成受约束继续。
5. token estimation 负责在 API usage 不完整时保守估算，避免过晚爆窗。

关键点在于：

- Claude Code 不只是在“省 token”

而是在：

- 让上下文保持在可运行、可恢复、可解释的工作集范围内

## 4. 两种预算器的同构结构

动作预算器和上下文预算器在结构上高度相似：

### 4.1 进入前先过滤

- 权限系统先过滤工具池
- tool result budget 先过滤大块结果

### 4.2 运行中持续校正

- auto mode gate / bypass gate 会异步撤回
- autocompact / reactive compact 会在运行中纠偏

### 4.3 状态必须外化

- `permission_mode` 要同步给外部 metadata
- `worker_status` / compaction / pending_action 要同步给宿主

### 4.4 失败不能靠隐式猜测

- 权限变化必须经显式状态同步
- prompt-too-long / max_output_tokens 必须经显式恢复分支

这正是为什么 Claude Code 看起来同时“安全”“省 token”“还不至于卡死”：

- 因为它把这两套预算统一做成了 runtime correction system

## 5. 治理层为什么也属于这张图

`main.tsx` 清楚表明，治理并不是单独的后台管理功能。

它直接进入主路径并影响：

- trust 建立前后能做什么
- MCP server 是否被 policy 过滤
- remote session 是否被 org policy 禁用
- trusted device 是否需要重建
- onboarding 之后哪些能力需要重新 refresh

所以治理层并不是安全层外面再套一层，而是：

- 动作预算器的高阶来源

## 6. 苏格拉底式追问

### 6.1 为什么安全系统不能只靠 prompt 约束

因为 prompt 只能建议，不能：

- 从工具池里移除能力
- 阻止策略不允许的 remote path
- 保证 mode 变化被宿主看见

### 6.2 为什么 token 经济不能只靠 `/compact`

因为等到 `/compact` 才动作，已经太晚。

真正有效的系统必须在更早阶段就做：

- 输出外置
- delta 注入
- 保守估算
- 运行中恢复

### 6.3 为什么这两套系统必须和宿主状态同步一起写

因为预算如果不外化，宿主就只能猜：

- 当前为什么不能做
- 当前为什么继续做
- 当前为什么突然切 mode 或 compact

而 Claude Code 明显不接受这种“让宿主自己猜”的设计。

## 7. 一句话总结

Claude Code 的安全、权限、治理与 token 经济，本质上是同一件事：用一套持续运行的预算器，同时收束动作空间和上下文空间。
