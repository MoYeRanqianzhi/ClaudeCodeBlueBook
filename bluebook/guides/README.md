# 使用专题

本目录收纳从源码反推的实战方法，不重复产品文案。

## 当前入口

1. [01-使用指南](01-%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.md)
2. [02-多Agent编排与Prompt模板](02-%E5%A4%9AAgent%E7%BC%96%E6%8E%92%E4%B8%8EPrompt%E6%A8%A1%E6%9D%BF.md)
3. [03-CLAUDE.md、记忆层与上下文注入实践](03-CLAUDE.md%E3%80%81%E8%AE%B0%E5%BF%86%E5%B1%82%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E6%B3%A8%E5%85%A5%E5%AE%9E%E8%B7%B5.md)

## 按使用目标阅读

- 想先把 Claude Code 用顺手：`01`
- 想把多 Agent 用对，而不是只会并行：`01 -> 02`
- 想把规则层、长期记忆、会话连续性分层设计清楚：`01 -> 03`
- 想把 Prompt 写成可运行的 contract，而不是一次性文案：`02 -> 03 -> ../philosophy/18`

## 与其他目录的边界

- 需要字段、schema、控制协议时回到 [../api/README.md](../api/README.md)
- 需要运行时机制时回到 [../architecture/README.md](../architecture/README.md)
- 需要第一性原理解释时回到 [../philosophy/README.md](../philosophy/README.md)

后续继续补：

- 项目级 skills 工程化设计
- 团队权限与托管策略配置
- 宿主接入与远程协作实践
