# Channels、托管策略与组织级治理实践

这一篇不讨论 channels 的协议字段，而是反推：

1. 团队 / 企业组织到底该怎样安全地启用 channels。
2. 为什么 `channelsEnabled`、`allowedChannelPlugins`、`--channels` 必须一起用。
3. 平台管理员、终端用户、插件开发者各自的职责边界是什么。
4. 如果把 channels 当“普通 MCP server”接入，会在哪些地方踩坑。

## 1. 先说结论

Claude Code 的 channels 不是“打开一个能力开关”就结束，而是三层共同成立：

1. 组织层：
   - `channelsEnabled: true`
   - 必要时配置 `allowedChannelPlugins`
2. 会话层：
   - 用户显式用 `--channels` 选择本次允许入站的 channel server
3. 信任层：
   - 插件来源、marketplace、一致性校验、allowlist 和 OAuth 共同成立

所以最稳的实践不是：

- “管理员全局开，用户想怎么接就怎么接”

而是：

- 管理员定义可接的来源集合
- 用户在单次会话里再 opt-in

## 2. 代表性源码锚点

- `claude-code-source-code/src/utils/settings/types.ts:896-920`
- `claude-code-source-code/src/services/mcp/channelNotification.ts:1-16`
- `claude-code-source-code/src/services/mcp/channelNotification.ts:120-140`
- `claude-code-source-code/src/services/mcp/channelNotification.ts:224-320`
- `claude-code-source-code/src/services/mcp/useManageMCPConnections.ts:560-622`

## 3. 管理员视角：先开总开关，再决定 allowlist

### 3.1 `channelsEnabled`

对 team / enterprise 来说，`channelsEnabled` 默认是关的。  
如果组织不显式开启，channel-capable MCP server 即使连上，也不会被注册为 channel handler。

这说明 channels 的默认安全姿势是：

- fail closed

### 3.2 `allowedChannelPlugins`

如果组织配置了 `allowedChannelPlugins`，它会替换默认的 Anthropic allowlist。

这意味着管理员真正控制的是：

- 哪些 marketplace/plugin 组合有资格把外部消息推入会话

所以推荐实践是：

1. 先少量白名单
2. 逐步放开
3. 把来源治理放在组织层，不要把这个判断下放给单个用户

## 4. 用户视角：永远不要跳过会话级 opt-in

即使组织层已经允许，用户这一层仍然要显式通过 `--channels` 选择 server。

这是个很重要的设计：

- 组织层决定“什么东西理论上能进”
- 会话层决定“这次我是否真的接受它进来”

也就是说，用户不是被动接收 channel，而是在每次会话中重新声明信任。

## 5. 为什么 channels 不能当普通 MCP server

因为普通 MCP server 主要做的是：

- tool / resource / prompt capability

而 channels 额外做的是：

- 把外部消息主动注入当前会话

这让它天然多出三类风险：

1. prompt injection 风险
2. 用户身份混淆风险
3. 入站消息过载风险

所以源码里才会显式提示模型：

- 这不是你的用户
- 这是外部 channel 的不可信内容

## 6. 组织实践建议

### 6.1 推荐最小策略

对大多数组织，最稳的起手式是：

1. 只在 team / enterprise 托管环境里启用
2. 只 allowlist 极少数明确审过的 channel plugin
3. 用户必须显式 `--channels` opt-in
4. 只允许明确业务场景，不把它当默认通信总线

### 6.2 哪些场景值得启用

适合启用的场景：

- 值班告警回流
- 远程审批或确认
- 明确来源的业务通知

不适合一上来启用的场景：

- 开放式群聊回流
- 任何人都能发消息的公共 channel
- 想把它变成“第二个用户输入口”的场景

## 7. 插件开发者视角：你承担的是来源与语义责任

如果你在做 channel plugin，最重要的不是把消息送进来，而是保证：

1. 来源身份明确
2. marketplace/source 一致
3. permission relay 明确
4. 不把普通聊天文本误伪装成审批或系统消息

更直白地说：

- 你写的不是“消息转发器”
- 而是“外部输入信任适配器”

## 8. 苏格拉底式追问

### 8.1 为什么不直接让用户连任何 channel server

因为 channel 的危险不在“能不能发工具调用”，而在“能不能把外部内容变成当前会话的输入”。

### 8.2 为什么组织开了总开关，还要用户再用 `--channels`

因为总开关解决的是组织级治理，会话 opt-in 解决的是当前任务是否真的需要这个输入面。

### 8.3 为什么 `allowedChannelPlugins` 比“知道 plugin 名字”更重要

因为 channel 信任不是名字信任，而是：

- marketplace + plugin 来源信任

## 9. 推荐阅读链

- 想看协议与产品边界：`../api/22 -> ../api/27 -> ../api/28`
- 想看风控与误伤：`../risk/03 -> ../risk/05 -> ../risk/11`
- 想看组织级治理语义：`../philosophy/20`

## 10. 一句话总结

Claude Code 的 channels 最佳实践不是“把外部消息接进来”，而是“把组织治理、会话 opt-in 和来源信任三层同时收紧后，再有选择地接进来”。
