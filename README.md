# CCBlueBook

`CCBlueBook` 是一个面向 Claude Code 的源码蓝皮书工程。目标不是复述功能列表，而是基于本地源码证据，持续沉淀三类内容：

- 使用指南：Claude Code 应该怎么用，才能逼近它的最佳工作方式。
- 架构地图：Claude Code 的启动链路、Agent loop、工具系统、扩展系统如何组织。
- 设计哲学：为什么它在开发任务上表现强，背后的工程取舍是什么。

当前分析基线：

- 研究对象：`claude-code-source-code/`
- 版本：`@anthropic-ai/claude-code-source` `2.1.88`
- 形态：解包后的 TypeScript 源码，源码目录本地保留、仓库忽略，不随本仓库提交

阅读入口：

- [蓝皮书索引](docs/README.md)
- [蓝皮书总览](docs/00-蓝皮书总览.md)
- [源码总地图](docs/01-源码总地图.md)
- [使用指南](docs/02-使用指南.md)
- [设计哲学](docs/03-设计哲学.md)
- [开发文档](docs/development/00-研究方法.md)

专题拆解入口：

- [专题总览](docs/bluebook/00-总览.md)
- [启动链路与 CLI](docs/architecture/01-启动链路与CLI.md)
- [Agent 循环与工具系统](docs/architecture/02-Agent循环与工具系统.md)
- [扩展能力与远程架构](docs/architecture/03-扩展能力与远程架构.md)
- [长期记忆](docs/development/long-term-memory.md)

方法约束：

- 可追溯：所有关键判断尽量附源码锚点。
- 可验证：优先来自本地源码、配置、构建脚本与注释，不靠猜测。
- 可解释：不仅回答“是什么”，还回答“为什么这样设计”。

当前阶段成果：

- 完成蓝皮书目录骨架
- 完成第一版源码地图
- 完成第一版使用指南
- 完成第一版设计哲学总结
- 完成启动链路、Agent 循环、扩展能力三篇专题拆解
- 建立开发文档与证据索引，作为长期记忆
