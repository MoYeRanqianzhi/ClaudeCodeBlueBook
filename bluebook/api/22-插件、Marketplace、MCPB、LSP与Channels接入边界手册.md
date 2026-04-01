# 插件、Marketplace、MCPB、LSP与Channels接入边界手册

这一章回答四个问题：

1. Claude Code 的生态接入面到底由哪些不同对象组成。
2. builtin plugin、marketplace plugin、bundled skill、MCPB、LSP、channels 为什么不能混写。
3. 哪些是格式支持，哪些才是产品级可用能力。
4. 对接入方和蓝皮书作者来说，最重要的边界是什么。

## 1. 先说结论

Claude Code 的生态面至少由六类不同对象构成：

1. bundled skill：
   - 随 CLI 发货的 prompt artifact
2. builtin plugin：
   - 随 CLI 发货，但用户可在 `/plugin` 中启停的插件
3. marketplace plugin：
   - 通过 marketplace source 声明、缓存、安装的插件
4. MCPB / DXT：
   - 插件或扩展打包格式
5. LSP：
   - 本地代码智能基础设施，被 `LSPTool` 选择性暴露给模型
6. channels：
   - 在 MCP 基础上叠加 capability、auth、org policy、session opt-in、allowlist 的消息通道能力

代表性证据：

- `claude-code-source-code/src/plugins/builtinPlugins.ts:1-18`
- `claude-code-source-code/src/plugins/builtinPlugins.ts:52-121`
- `claude-code-source-code/src/utils/plugins/marketplaceManager.ts:1-19`
- `claude-code-source-code/src/utils/plugins/marketplaceManager.ts:154-191`
- `claude-code-source-code/src/utils/dxt/helpers.ts:5-33`
- `claude-code-source-code/src/utils/dxt/zip.ts:7-13`
- `claude-code-source-code/src/tools/LSPTool/LSPTool.ts:127-160`
- `claude-code-source-code/src/services/mcp/channelAllowlist.ts:1-16`
- `claude-code-source-code/src/services/mcp/channelNotification.ts:191-280`

## 2. bundled skill、builtin plugin、marketplace plugin 不是同一种东西

`builtinPlugins.ts` 自己就把区别写明了：

- builtin plugin 会出现在 `/plugin` UI
- 用户可以启停
- 可以同时提供 skills、hooks、MCP servers
- 它的 ID 形式是 `{name}@builtin`

证据：

- `claude-code-source-code/src/plugins/builtinPlugins.ts:1-18`
- `claude-code-source-code/src/plugins/builtinPlugins.ts:21-39`
- `claude-code-source-code/src/plugins/builtinPlugins.ts:52-121`

而 marketplace plugin 则是另一套体系：

- 有 marketplace 声明与缓存
- 有 source、installLocation、autoUpdate
- 分 intent layer 与 state layer

证据：

- `claude-code-source-code/src/utils/plugins/marketplaceManager.ts:1-19`
- `claude-code-source-code/src/utils/plugins/marketplaceManager.ts:132-191`

所以更准确的理解应是：

1. bundled skill：
   - 最轻量的 prompt/skill 分发表面
2. builtin plugin：
   - 随产品发货但可治理的组件
3. marketplace plugin：
   - 外部分发表面

## 3. marketplace 不是“插件列表”，而是受治理的来源系统

`marketplaceManager.ts` 管的不只是下载，还包括：

- known marketplaces 配置
- cache 目录
- declared marketplaces
- install location
- official marketplace fallback

证据：

- `claude-code-source-code/src/utils/plugins/marketplaceManager.ts:10-19`
- `claude-code-source-code/src/utils/plugins/marketplaceManager.ts:99-112`
- `claude-code-source-code/src/utils/plugins/marketplaceManager.ts:154-191`

这说明 marketplace 在 Claude Code 里不是一个 UI tab，而是：

- 受配置、缓存、来源策略约束的分发系统

也正因为如此，看到“有 marketplace manager”并不等于：

- 任何插件生态能力都已经完全成熟

## 4. MCPB / DXT 说明“支持格式”不等于“信任格式”

`dxt/helpers.ts` 和 `dxt/zip.ts` 说明，Claude Code 对打包格式的态度非常谨慎：

1. manifest 校验是懒加载的
2. zip 解包有：
   - path traversal 检查
   - 单文件大小限制
   - 总大小限制
   - 文件数限制
   - 压缩比限制

证据：

- `claude-code-source-code/src/utils/dxt/helpers.ts:5-17`
- `claude-code-source-code/src/utils/dxt/helpers.ts:36-60`
- `claude-code-source-code/src/utils/dxt/zip.ts:7-13`
- `claude-code-source-code/src/utils/dxt/zip.ts:42-58`
- `claude-code-source-code/src/utils/dxt/zip.ts:63-101`

这说明 Claude Code 对 `.mcpb` / `.dxt` 的态度不是：

- 只要 schema 能 parse 就算支持

而是：

- parse、验证、解包安全和运行时信任是不同层

## 5. LSP 是基础设施，不等于“永远对模型开放”

`LSPTool.ts` 展示了两个关键事实：

1. LSPTool 是 read-only、concurrency-safe 的正式工具
2. 它仍然受连接状态与环境 gate 控制

证据：

- `claude-code-source-code/src/tools/LSPTool/LSPTool.ts:127-160`
- `claude-code-source-code/src/tools/LSPTool/LSPTool.ts:218-260`

此外它还有明显的安全边界：

- UNC path 不做文件系统访问，防止 NTLM credential leak

证据：

- `claude-code-source-code/src/tools/LSPTool/LSPTool.ts:166-208`

因此 LSP 更准确的定位是：

- 本地代码智能基础设施
- 在某些运行时与 gate 下暴露给模型

而不是：

- 无条件永远可用的公共工具

## 6. channels 是最典型的“多重边界叠加能力”

`channelNotification.ts` 清楚表明，一个 server 想成为 channel server，至少要过：

1. capability 声明
2. channels 总开关
3. claude.ai OAuth
4. org policy `channelsEnabled`
5. `--channels` session opt-in
6. plugin marketplace 校验
7. allowlist 校验

证据：

- `claude-code-source-code/src/services/mcp/channelNotification.ts:191-280`
- `claude-code-source-code/src/services/mcp/channelAllowlist.ts:1-16`
- `claude-code-source-code/src/services/mcp/channelAllowlist.ts:37-75`

这说明 channels 不是：

- 普通 MCP server 顺手多了个 notification

而是：

- 一个经过重重产品和安全门控后才开放的消息通道能力

## 7. 蓝皮书最容易写错的地方

在生态面上，最危险的误写方式有三种：

1. 看到 schema/support code，就直接写成“已公开支持”。
2. 把 bundled skill、plugin、marketplace、MCPB、LSP、channels 写成同一级。
3. 把“代码里有入口”和“用户默认可用”混为一谈。

正确写法应该始终追问：

1. 这是格式支持，还是产品承诺。
2. 这是基础设施层，还是模型可直接消费层。
3. 它受哪些 gate、auth、policy、allowlist 限制。

## 8. 对接入方的建议

如果你要扩展 Claude Code：

1. 只是分发 prompt/工作流：
   - 优先 skill / bundled artifact 思路
2. 需要组合 skills/hooks/MCP：
   - 再考虑 plugin
3. 需要正式分发与来源治理：
   - 再进入 marketplace 体系
4. 需要模型代码智能：
   - 把 LSP 当基础设施，而不是神奇插件
5. 需要消息推送：
   - 先理解 channels 的 auth/policy/allowlist 约束

## 9. 一句话总结

Claude Code 的生态面不是“插件很多”，而是把 skill、plugin、marketplace、MCPB、LSP、channels 明确放进了不同的分发、信任和治理层级。
