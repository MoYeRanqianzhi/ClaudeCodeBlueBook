# MCP 配置与连接状态机

这一章回答五个问题：

1. Claude Code 的 MCP config scope 与 transport 到底有哪些正式类型。
2. plugin、claude.ai、enterprise、dynamic config 如何汇总成统一 MCP 配置面。
3. MCP server 的连接状态为什么是一个状态机，而不是简单的 connect / fail。
4. SDK control surface 如何操作 MCP：查询、替换、重连、启停。
5. 为什么 Claude Code 的 MCP 设计本质上是“可治理的连接平面”，而不是插件附属品。

## 1. 先说结论

Claude Code 的 MCP 面至少分成四层：

1. 配置层：`ConfigScope`、`ScopedMcpServerConfig`、manifest / `.mcp.json` / dynamic config。
2. transport 层：`stdio`、`sse`、`sse-ide`、`http`、`ws`、`sdk`，以及 internal `claudeai-proxy` / `ws-ide` 变体。
3. 连接状态层：`connected`、`failed`、`needs-auth`、`pending`、`disabled`。
4. 控制层：`mcp_status`、`mcp_set_servers`、`mcp_message`、`mcp_reconnect`、`mcp_toggle`。

所以 MCP 在 Claude Code 里不是“外接工具协议”，而是一个正式的连接平面。

关键证据：

- `claude-code-source-code/src/services/mcp/types.ts:10-26`
- `claude-code-source-code/src/services/mcp/types.ts:124-169`
- `claude-code-source-code/src/services/mcp/types.ts:179-257`
- `claude-code-source-code/src/services/mcp/config.ts:1253-1290`
- `claude-code-source-code/src/services/mcp/config.ts:1297-1377`
- `claude-code-source-code/src/services/mcp/config.ts:1480-1569`
- `claude-code-source-code/src/services/mcp/client.ts:340-421`
- `claude-code-source-code/src/services/mcp/client.ts:595-1128`
- `claude-code-source-code/src/services/mcp/client.ts:1216-1402`
- `claude-code-source-code/src/services/mcp/useManageMCPConnections.ts:333-450`
- `claude-code-source-code/src/services/mcp/useManageMCPConnections.ts:765-1128`
- `claude-code-source-code/src/utils/plugins/mcpPluginIntegration.ts:341-429`
- `claude-code-source-code/src/utils/plugins/mcpPluginIntegration.ts:465-620`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:157-173`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:374-452`

## 2. 配置层：scope 先于连接

### 2.1 `ConfigScope` 明确区分来源层级

可见的 scope 有：

- `local`
- `user`
- `project`
- `dynamic`
- `enterprise`
- `claudeai`
- `managed`

证据：

- `claude-code-source-code/src/services/mcp/types.ts:10-21`

这说明 Claude Code 一开始就把“从哪里来的 MCP”当成一等元信息。

### 2.2 `ScopedMcpServerConfig` 不是普通 server config

它在 `McpServerConfig` 之上再加：

- `scope`
- `pluginSource?`

证据：

- `claude-code-source-code/src/services/mcp/types.ts:163-169`

也就是说，运行时不仅知道怎么连，还知道这个 server 的来源和治理边界。

## 3. transport 层：不是只有 stdio

公开 schema 里的 transport 包括：

- `stdio`
- `sse`
- `sse-ide`
- `http`
- `ws`
- `sdk`

而同文件里还出现 internal-only：

- `ws-ide`
- `claudeai-proxy`

证据：

- `claude-code-source-code/src/services/mcp/types.ts:23-26`
- `claude-code-source-code/src/services/mcp/types.ts:68-87`
- `claude-code-source-code/src/services/mcp/types.ts:115-134`

所以 Claude Code 的 MCP transport 已经是多宿主、多网络、多信任场景的统一抽象。

## 4. 配置汇总链：不是单文件读取

### 4.1 `getAllMcpConfigs()` 会做跨来源合并

它会：

- 在 enterprise config 存在时短路到 Claude Code config。
- 并行启动 claude.ai configs 获取。
- 合并 Claude Code configs 与 claude.ai configs。
- 对重复 connector 做 dedup。
- 让 claude.ai 拥有最低优先级。

证据：

- `claude-code-source-code/src/services/mcp/config.ts:1253-1290`

### 4.2 `parseMcpConfig(...)` / `parseMcpConfigFromFilePath(...)` 负责验证与扩展变量

这一层做的事情包括：

- `McpJsonConfigSchema` 验证
- per-server env var expansion
- 缺失环境变量告警
- Windows `npx` 兼容性提示
- JSON 读取 / 解析错误收口

证据：

- `claude-code-source-code/src/services/mcp/config.ts:1292-1377`
- `claude-code-source-code/src/services/mcp/config.ts:1379-1468`

### 4.3 启停本身也是配置层的一部分

`isMcpServerDisabled(...)` 与 `setMcpServerEnabled(...)` 说明：

- builtin disabled server 与普通 user-configured server 的启停逻辑不同。
- builtin 是 opt-in via `enabledMcpServers`。
- 普通 server 是 opt-out via `disabledMcpServers`。

证据：

- `claude-code-source-code/src/services/mcp/config.ts:1506-1569`

## 5. plugin MCP：先解析，再解析环境，再加 scope

### 5.1 plugin server 会被统一加上 `dynamic` scope

`addPluginScopeToServers(...)` 会：

- 给 server name 加前缀 `plugin:{pluginName}:{serverName}`
- 把 scope 设成 `dynamic`
- 记录 `pluginSource`

证据：

- `claude-code-source-code/src/utils/plugins/mcpPluginIntegration.ts:341-360`

### 5.2 plugin MCP env 不是简单字符串替换

`resolvePluginMcpEnvironment(...)` 会分层处理：

- `${CLAUDE_PLUGIN_ROOT}`
- `${user_config.X}`
- 通用 `${VAR}`

还会按 server type 分别解析：

- stdio 的 command / args / env
- remote transport 的 url / headers

证据：

- `claude-code-source-code/src/utils/plugins/mcpPluginIntegration.ts:465-582`

这说明 plugin MCP 的运行时语义，已经远远超出“从 manifest 读个 JSON”。

## 6. 连接状态层：五态状态机

`MCPServerConnection` 的五种状态是：

- `connected`
- `failed`
- `needs-auth`
- `pending`
- `disabled`

证据：

- `claude-code-source-code/src/services/mcp/types.ts:179-226`

它们不是 UI 文案，而是带不同后续动作的状态：

1. `pending` 可以等待或重连。
2. `needs-auth` 需要认证恢复。
3. `disabled` 不应发起连接。
4. `failed` 可以手动或自动重连。
5. `connected` 才能拉 tools/resources/commands。

## 7. `connectToServer(...)`：transport 细节在这里被统一封装

### 7.1 远程认证失败会进入 `needs-auth`

`handleRemoteAuthFailure(...)` 会：

- 打点
- 写 needs-auth cache
- 返回 `{ type: 'needs-auth' }`

证据：

- `claude-code-source-code/src/services/mcp/client.ts:340-360`

### 7.2 transport-specific 连接分支

`connectToServer(...)` 里分别处理：

- SSE
- SSE-IDE
- WS
- HTTP
- SDK
- claude.ai proxy
- in-process MCP
- stdio

证据：

- `claude-code-source-code/src/services/mcp/client.ts:595-960`

### 7.3 连接错误与自动重连不是 transport 自己完成的全部逻辑

client 侧还会：

- 识别 session expired
- 识别连续 terminal connection errors
- 主动 close transport 以拒绝 pending requests
- 清除连接缓存与 fetch caches

证据：

- `claude-code-source-code/src/services/mcp/client.ts:1216-1402`

这说明 Claude Code 没有把 SDK transport 默认行为当黑盒，而是在外面又包了一层更强的 runtime 管理。

## 8. `useManageMCPConnections(...)`：状态机真正的 orchestration 层

### 8.1 初始化阶段：先把服务器放入 `pending` / `disabled`

它会：

- 从 configs 中找出新 server
- 将新 server 先写入 app state 为 `pending` 或 `disabled`
- 同时清理 stale plugin clients，避免 ghost tools

证据：

- `claude-code-source-code/src/services/mcp/useManageMCPConnections.ts:765-848`

### 8.2 连接关闭后：远程 transport 进入自动重连回路

连接关闭时：

- 若 server 已 disabled，则跳过自动重连。
- 若是 remote transport，则用 exponential backoff 重连。
- 重连过程中 state 切为 `pending`，带 `reconnectAttempt`。
- 超过最大次数后切到 `failed`。

证据：

- `claude-code-source-code/src/services/mcp/useManageMCPConnections.ts:333-450`

### 8.3 phase 1 / phase 2 双阶段装载

它还会：

- 先连 Claude Code configs
- 后连 claude.ai configs
- 在 phase 2 前后做 dedup、pending state 注入、错误汇总

证据：

- `claude-code-source-code/src/services/mcp/useManageMCPConnections.ts:856-1008`

### 8.4 toggle / reconnect 也是正式操作

`toggleMcpServer(...)` 会：

- 持久化 enabled/disabled 状态
- 更新当前 client state 为 `disabled` 或 `pending`
- 必要时断开或重连

证据：

- `claude-code-source-code/src/services/mcp/useManageMCPConnections.ts:1043-1128`

## 9. control surface：SDK 宿主如何操作 MCP

control protocol 里与 MCP 直接相关的公开请求包括：

- `mcp_status`
- `mcp_message`
- `mcp_set_servers`
- `mcp_reconnect`
- `mcp_toggle`

证据：

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:157-173`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:374-452`

其中最关键的是：

- `mcp_status` 负责观测当前所有连接态
- `mcp_set_servers` 负责替换动态 managed MCP servers
- `mcp_reconnect` / `mcp_toggle` 负责状态机驱动

## 10. 从第一性原理看：为什么这是连接平面，不是插件附属品

如果把 MCP 只当作“给模型多几个工具”，就解释不了这些设计：

1. scope 分层
2. transport 多样性
3. needs-auth / pending / disabled / failed 五态
4. pluginSource / claude.ai / enterprise 的优先级
5. control protocol 里的专门观测与操作接口

这些都说明 Claude Code 真正在做的是：

把外部能力连接成一张可治理、可重连、可观察、可筛选的运行时连接平面。

## 11. 相关章节

- MCP 粗粒度总览：`03-MCP与远程传输.md`
- 扩展 manifest：`10-扩展Frontmatter与插件Agent手册.md`
- Claude API 与流式执行：`../architecture/12-ClaudeAPI与流式工具执行.md`
