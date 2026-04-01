# Claude Code Blue Book

面向 `claude-code-source-code/` 的 Claude Code 蓝皮书工程。

当前基于 `@anthropic-ai/claude-code` `v2.1.88` 的反编译源码进行结构分析，目标是把源码拆成可阅读、可验证、可持续迭代的文档体系，而不是只写一篇一次性的长文。

## 导航

- [docs/README.md](docs/README.md): 蓝皮书总索引
- [docs/bluebook/00-导读.md](docs/bluebook/00-导读.md): 研究范围、方法、阅读路径
- [docs/bluebook/01-源码结构地图.md](docs/bluebook/01-源码结构地图.md): 启动链路、核心模块、运行时结构
- [docs/bluebook/02-使用指南.md](docs/bluebook/02-使用指南.md): 基于源码反推出的高价值使用方法
- [docs/bluebook/03-设计哲学.md](docs/bluebook/03-设计哲学.md): 为什么 Claude Code 强，以及它依赖的设计选择
- [docs/bluebook/04-公开能力与隐藏能力.md](docs/bluebook/04-公开能力与隐藏能力.md): public / gated / internal 能力边界
- [docs/bluebook/05-功能全景与API支持.md](docs/bluebook/05-功能全景与API支持.md): 功能矩阵、命令面、SDK 面、MCP 面、远程面
- [docs/bluebook/06-第一性原理与苏格拉底反思.md](docs/bluebook/06-第一性原理与苏格拉底反思.md): 从第一性原理回看 Claude Code 与蓝皮书自身
- [docs/api/README.md](docs/api/README.md): 接口与协议索引
- [docs/architecture/README.md](docs/architecture/README.md): 架构深挖索引
- [docs/guides/README.md](docs/guides/README.md): 使用专题索引
- [docs/philosophy/README.md](docs/philosophy/README.md): 哲学专题索引
- [docs/development/research-log.md](docs/development/research-log.md): 研究日志、证据锚点、后续待办
- [docs/development/03-反思与迭代准则.md](docs/development/03-反思与迭代准则.md): 写作约束与下一轮迭代方法
- [docs/changelog.md](docs/changelog.md): 文档版本记录

## 当前范围

- 入口与启动: `entrypoints/cli.tsx`、`main.tsx`、`entrypoints/init.ts`
- 核心 agent loop: `QueryEngine.ts`、`query.ts`
- 工具与权限: `Tool.ts`、`tools.ts`、`utils/permissions/*`
- 技能与命令: `skills/*`、`commands.ts`、`tools/SkillTool/*`
- 扩展生态: `services/mcp/*`、`plugins/*`
- 多 Agent 与远程: `tools/AgentTool/*`、`remote/*`、`bridge/*`、`coordinator/*`

## 工作原则

- 所有关键结论都尽量指向具体源码文件与行号。
- 文档是长期记忆，后续分析继续增量写入 `docs/`。
- `claude-code-source-code/` 保持在 `.gitignore` 中，不直接纳入本仓库版本管理。
- 正式读者主线以 `docs/bluebook/` 为准，专题深挖分别放入 `architecture/`、`api/`、`guides/`、`philosophy/`、`development/`。
