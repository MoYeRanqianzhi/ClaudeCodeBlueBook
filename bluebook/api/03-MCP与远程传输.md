# MCP 与远程传输

这一章把 Claude Code 的 transport 视角单独抽出来，因为它不只是“本地工具调用”。

## 1. MCP 在 Claude Code 中是什么

MCP 在这里不是附加插件协议，而是正式扩展总线。

`services/mcp/types.ts` 直接定义了:

- config scope
- transport type
- server config union
- server connection state union

证据:

- `claude-code-source-code/src/services/mcp/types.ts:10-26`
- `claude-code-source-code/src/services/mcp/types.ts:124-173`
- `claude-code-source-code/src/services/mcp/types.ts:180-222`

## 2. 支持哪些 transport

可见 transport 类型包括:

- `stdio`
- `sse`
- `sse-ide`
- `http`
- `ws`
- `sdk`

证据:

- `claude-code-source-code/src/services/mcp/types.ts:23-26`

这些 transport 并不是停留在 schema 层，`connectToServer()` 会分别构造对应 transport。

证据:

- `claude-code-source-code/src/services/mcp/client.ts:595-607`
- `claude-code-source-code/src/services/mcp/client.ts:619-676`
- `claude-code-source-code/src/services/mcp/client.ts:678-734`
- `claude-code-source-code/src/services/mcp/client.ts:735-900`
- `claude-code-source-code/src/services/mcp/client.ts:950-969`

## 3. MCP 连接状态不是二元的

`MCPServerConnection` 明确区分:

- `connected`
- `failed`
- `needs-auth`
- `pending`
- `disabled`

证据:

- `claude-code-source-code/src/services/mcp/types.ts:180-222`

这很重要，因为 Claude Code 不把“连不上”简单当异常，而是把连接生命周期纳入状态机。

## 4. `fetchToolsForClient()` 如何把 MCP tool 收敛进统一 Tool 协议

`fetchToolsForClient()` 会:

1. 调 `tools/list`
2. 清理/裁剪工具描述
3. 为每个 MCP tool 构造统一 `Tool` 结构
4. 把 readOnly/destructive/openWorld 注解收敛为统一工具属性
5. 衔接 auto classifier 与权限建议

证据:

- `claude-code-source-code/src/services/mcp/client.ts:1743-1845`

这意味着 MCP tool 在 Claude Code 里不是异构外设，而是被包成了一等 runtime tool。

## 5. Claude Code 也能反向暴露成 MCP server

`entrypoints/mcp.ts` 说明 Claude Code 不只是 MCP client，还可以把自己的工具暴露出去。

它会:

- 启动 stdio server
- 把内置工具导出为 MCP tool schema
- 在 `CallToolRequestSchema` 中直接执行本地工具

证据:

- `claude-code-source-code/src/entrypoints/mcp.ts:35-57`
- `claude-code-source-code/src/entrypoints/mcp.ts:59-97`
- `claude-code-source-code/src/entrypoints/mcp.ts:99-196`

这说明 Claude Code 不是 MCP 附庸，而是能成为 MCP 生态节点。

## 6. 远程传输不是单层 socket

`RemoteIO` 继承自 `StructuredIO`，在控制协议之上叠加:

- transport 选择
- session ingress token
- reconnect header refresh
- CCR v2 internal event 写入/恢复
- bridge keepalive
- debug echo

证据:

- `claude-code-source-code/src/cli/remoteIO.ts:31-42`
- `claude-code-source-code/src/cli/remoteIO.ts:54-93`
- `claude-code-source-code/src/cli/remoteIO.ts:111-168`
- `claude-code-source-code/src/cli/remoteIO.ts:174-199`
- `claude-code-source-code/src/cli/remoteIO.ts:225-254`

因此远程传输不只是“把 stdout/stderr 远程转发”，而是完整 session runtime 的网络化。

## 7. `StructuredIO` 与 `RemoteIO` 的分工

### StructuredIO

负责协议语义:

- 解析输入
- 发 control request
- 收 control response
- 管 permission/hook/elicitation/MCP message

### RemoteIO

负责网络化承载:

- transport 选择
- 连接生命周期
- keepalive
- bridge/CCR 特殊行为

这两个类分层很干净，说明作者明确区分了“协议逻辑”和“网络逻辑”。

## 8. 这对蓝皮书意味着什么

如果只站在本地 CLI 视角看 Claude Code，会低估它的目标边界。  
从传输层看，它更像一个可嵌入、可远程、可恢复、可多宿主接入的 agent runtime。

## 9. 待补章节

这一章下一步最值得补的是:

1. `config.ts` 的 scope 继承与 policy filter 细拆。
2. `RemoteSessionManager.ts` 与 `SessionsWebSocket.ts` 的消息模型。
3. bridge/CCR v2 的 internal event 恢复链。
