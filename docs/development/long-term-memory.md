# 长期记忆

## 项目目标

- 基于 `claude-code-source-code` 持续输出 `CCBlueBook`
- 从源码中提炼完整使用说明
- 提炼 Agent 设计原则与设计哲学
- 所有结论保持可追溯、可验证、可解释

## 当前已完成

- 建立文档目录骨架
- 完成首批核心章节：
  - 总览
  - 启动链路与 CLI
  - Agent 循环与工具系统
  - 扩展能力与远程架构
  - 使用指南
  - 设计哲学

## 已确认事实

- 研究对象版本：`2.1.88`
- 上游源码目录：`./claude-code-source-code`
- 公开源码中大量能力受 `feature()` 影响
- 技能、工具、权限、压缩、远程、子代理都是 Claude Code 的核心能力层，不是边角模块

## 后续章节建议

1. 深挖 `REPL.tsx` 的交互状态机
2. 深挖 `services/api/claude.ts` 与 streaming tool execution
3. 深挖 compact / microcompact / context collapse
4. 深挖权限系统与 auto mode 的风险控制
5. 深挖 memory / CLAUDE.md / scratchpad / durable knowledge
6. 深挖 AgentTool、Team、Coordinator 的编排范式
7. 深挖 MCP 接入面与插件生态边界

## 编写约定

- 重要结论尽量附源码文件锚点
- 缺失模块不臆测，只写“可见事实 + 保守推断”
- 新研究先写入文档，再依赖上下文
