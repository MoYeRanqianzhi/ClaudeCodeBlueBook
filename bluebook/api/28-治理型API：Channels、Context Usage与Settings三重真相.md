# 治理型 API：Channels、Context Usage 与 Settings 三重真相

这一章回答四个问题：

1. 为什么 channels、context usage、settings 这三组接口应该被放在一起看。
2. 它们如何共同约束 Claude Code 的运行时，而不只是提供信息。
3. 为什么这些接口体现的是治理面，而不是普通业务能力面。
4. 它们对 prompt、权限、token 经济和信任边界有什么影响。

## 1. 先说结论

Claude Code 有一组很容易被低估的“治理型 API”：

1. channels：
   - 决定外部消息怎样、在什么信任条件下，进入当前会话。
2. `get_context_usage`：
   - 决定上下文成本如何被宿主观察和治理。
3. `get_settings` / `apply_flag_settings`：
   - 决定配置的三层真相如何被读取和改写。

这三组接口共同说明：

- Claude Code 不只是开放“让你做事”的 API，还开放“让你约束运行时”的 API。

## 2. 代表性源码锚点

- `claude-code-source-code/src/services/mcp/channelNotification.ts:1-220`
- `claude-code-source-code/src/services/mcp/channelNotification.ts:186-280`
- `claude-code-source-code/src/utils/messages.ts:5496-5507`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:175-288`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:467-507`

## 3. Channels：它不是普通 MCP，而是受治理的外部消息注入面

`channelNotification.ts` 从开头就把 channel 定义得很明确：

- 它是 MCP server
- 但它还要额外支持 `notifications/claude/channel`
- 它把外部消息包进 `<channel>` 标签再注入会话

更关键的是，它必须通过一整条 gate：

1. capability
2. runtime gate
3. OAuth
4. org policy
5. session `--channels` opt-in
6. marketplace / allowlist

这说明 channels 的本体不是 transport，而是：

- 受信任边界严格约束的外部消息入口

## 4. 外部消息 origin 语义本身就是 API 语义

`wrapCommandText(...)` 明确区分了几种 origin：

- `human`
- `channel`
- `coordinator`
- `task-notification`

特别是 `channel` 路径会显式告诉模型：

- 这不是你的用户
- 内容来自外部 channel
- 应视为不可信输入

这意味着 origin 语义已经直接影响 prompt contract，所以它不能只被写成 UI 文案或附件包装细节。

## 5. `get_context_usage`：它不是统计 API，而是预算治理 API

`get_context_usage` 返回的不是一个 total，而是一个拆解后的运行时预算面板：

- categories
- memoryFiles
- mcpTools
- deferredBuiltinTools
- systemTools
- systemPromptSections
- agents
- slashCommands
- skills
- messageBreakdown
- apiUsage

这说明 Claude Code 不只是“自己内部做 compact”，而是允许宿主观察：

- 哪些 token 花在静态前缀
- 哪些花在技能/命令
- 哪些花在消息与工具结果

所以 context usage 是正式的上下文治理接口。

## 6. `get_settings`：Claude Code 明确区分三重真相

`get_settings` 返回三种不同层次的配置真相：

1. `sources`
   - 原始分层配置
2. `effective`
   - 合并后的磁盘配置
3. `applied`
   - 运行时最终实际生效值

特别是 `applied` 非常关键，因为它已经把：

- env override
- session state
- model-specific default

这些运行时因素考虑进去了。

所以 Claude Code 明确拒绝把“配置文件长什么样”和“API 最终实际会怎么调用”混成一层。

## 7. `apply_flag_settings`：宿主能改的不是外层 UI，而是配置层

`apply_flag_settings` 说明宿主可以向 flag settings layer 合并设置，并更新 active configuration。

这意味着：

- 设置 API 不是只读 introspection
- 宿主拥有正式的配置写入控制面

这和 `get_settings` 一起，构成“读取运行时真相 + 改写运行时真相”的完整闭环。

## 8. 为什么把这三组放在一起看

因为三者都在做同一件事：

- 限制和塑形 Claude Code 的运行时自由度

具体来说：

- channels 约束外部输入空间
- context usage 约束上下文成本空间
- settings / flag settings 约束配置与行为基线

所以它们都属于治理 API，而不属于业务功能 API。

## 9. 对平台构建者的直接启发

如果你在做 agent 平台：

1. 只开放工具调用 API 还远远不够。
2. 你还需要开放：
   - 外部输入如何进入
   - 上下文成本如何观测
   - 配置真相如何解释
3. 如果这些面没有正式 API，宿主就会被迫猜测运行时状态。

Claude Code 在这点上更成熟，因为它把这些“看似杂务”的面都协议化了。

## 10. 一句话总结

Channels、context usage 和 settings 三组接口共同说明：Claude Code 对外暴露的不只是执行能力，还暴露了输入治理、成本治理和配置治理三条正式控制面。
