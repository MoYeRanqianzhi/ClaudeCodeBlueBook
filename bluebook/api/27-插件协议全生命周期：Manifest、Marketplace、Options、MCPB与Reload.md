# 插件协议全生命周期：Manifest、Marketplace、Options、MCPB与Reload

这一章回答四个问题：

1. Claude Code 的 plugin API 为什么不能只看 manifest schema。
2. 一个插件从来源到生效，至少要经过哪些生命周期阶段。
3. 为什么 options、MCPB、LSP、MCP、reload 都属于同一插件协议面。
4. 敏感配置为什么会被拆到 secure storage，而不是只写 settings。

## 1. 先说结论

Claude Code 的 plugin surface 不是“读一个 manifest，然后注册几个能力”。

更准确的说法是：

1. distribution：
   - marketplace source / install location / built-in 来源
2. declaration：
   - manifest / `.mcp.json` / `.lsp.json` / MCPB
3. configuration：
   - options / userConfig / sensitive split storage
4. extraction：
   - 加载 commands / agents / MCP servers / LSP servers
5. activation：
   - plugin enablement、allowlist、session 组装
6. refresh：
   - `reload_plugins` 重新装配当前 runtime

也就是说，plugin API 是 supply chain + runtime assembly 的组合协议。

## 2. 代表性源码锚点

- `claude-code-source-code/src/utils/plugins/mcpPluginIntegration.ts:131-260`
- `claude-code-source-code/src/utils/plugins/lspPluginIntegration.ts:1-220`
- `claude-code-source-code/src/utils/plugins/pluginOptionsStorage.ts:90-184`
- `claude-code-source-code/src/utils/plugins/mcpbHandler.ts:176-320`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:405-507`

## 3. 生命周期第 1 层：来源与分发

plugin 首先不是代码对象，而是来源对象。

至少要先区分：

- built-in plugin
- marketplace plugin
- plugin 目录中的本地插件

所以 plugin lifecycle 的第一步不是 parse manifest，而是先回答：

- 这个插件从哪里来
- 是否允许被安装
- 是否允许被自动更新
- 它属于哪一种治理路径

## 4. 生命周期第 2 层：声明与提取

在声明层，Claude Code 至少支持三类来源：

1. manifest 内联声明
2. `.mcp.json` / `.lsp.json` 文件
3. MCPB / DXT 打包输入

`loadPluginMcpServers(...)` 和 `loadPluginLspServers(...)` 说明：

- 同一插件可以从多种位置声明能力
- 多个来源会被合并
- 不同来源有明确优先级

这已经不是“读一个 JSON”那么简单，而是配置装配协议。

## 5. 生命周期第 3 层：安全配置存储

`savePluginOptions(...)` 和 `saveMcpServerUserConfig(...)` 暴露出一个很重要的设计：

- 非敏感配置进入 `settings.json`
- 敏感配置进入 secure storage

而且写入顺序是：

1. 先写 secure storage
2. 再写 settings
3. 再 scrub 另一侧的过期字段

这样做是为了避免：

- keychain 写失败后，敏感信息在两个地方都丢失
- schema 翻转后，旧值在错误存储层残留并反向覆盖新值

所以 plugin options 本身就是安全协议面，而不是 UX 表单细节。

## 6. 生命周期第 4 层：MCP 与 LSP 双桥接

Claude Code 对 plugin 能力的两个最重要桥接是：

1. MCP bridge
2. LSP bridge

两者有相似点：

- 都支持从插件目录或 manifest 读取配置
- 都要做 schema 校验
- 都要把插件声明转成 runtime server config

两者也有不同点：

- MCP 还要处理 `.mcpb` / DXT、server config 合并等问题
- LSP 明确做了 path traversal 防护，避免插件声明把读取路径逃出 plugin 目录

这说明 plugin API 不是单一扩展总线，而是多协议适配层。

## 7. 生命周期第 5 层：`reload_plugins` 是运行时重组，而不是热刷新小按钮

`reload_plugins` 的响应里会返回：

- commands
- agents
- plugins
- MCP server status
- `error_count`

这很关键，因为它表明 plugin reload 实际在做的是：

- 重建当前 session 的扩展能力面

也就是说，reload 不只是“磁盘上有变更，重新读一下”，而是：

- runtime capability reassembly

## 8. 为什么这一整条链都属于 API，而不只是实现细节

因为对插件作者和宿主来说，真正重要的问题不是：

- manifest 里有哪些字段

而是：

- 这个能力如何被声明
- 何时被接入
- 哪些配置会进安全存储
- 修改后如何重新生效
- 出错时会反馈哪一层问题

所以 plugin lifecycle 本身就是正式 API 面。

## 9. 对接入方和平台设计者的直接启发

如果你要设计自己的 agent plugin system：

1. 不要把 plugin 简化成 manifest schema。
2. 要从一开始区分：
   - 来源治理
   - 声明格式
   - 敏感配置
   - 运行时桥接
   - 热重载
3. 敏感配置不要和普通设置混存。
4. reload 返回值要体现“重组后的能力面”，而不是只返回 success。

## 10. 一句话总结

Claude Code 的插件协议不是单文件 manifest，而是一条从来源治理、声明提取、敏感配置、MCP/LSP 桥接到 runtime reload 的完整生命周期协议。
