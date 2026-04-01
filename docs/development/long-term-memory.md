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
  - 公开能力与隐藏能力
  - 功能全景与 API 支持
  - 第一性原理与苏格拉底反思
  - 命令与功能矩阵
  - Agent SDK 与控制协议
  - MCP 与远程传输
  - SDK 消息与事件字典
  - 控制请求与响应矩阵
  - REPL 与 Ink 交互架构
  - 权限系统与安全状态机
  - 上下文压缩与恢复链
  - compact 算法与上下文管理细拆
  - PromptInput 与消息渲染链
  - 上下文经济学
  - 安全观与边界设计
  - 产品实验与演化方法
  - 构建期开关、运行期开关与兼容层
  - 内置命令域索引
  - 命令字段与可用性索引

## 已确认事实

- 研究对象版本：`2.1.88`
- 上游源码目录：`./claude-code-source-code`
- 公开源码中大量能力受 `feature()` 影响
- 技能、工具、权限、压缩、远程、子代理都是 Claude Code 的核心能力层，不是边角模块
- SDK 面不仅有 query，还有会话、session 管理、控制协议与 SDK-MCP server 面
- Claude Code 的对外接口应至少按命令面、工具面、SDK 控制面、MCP 面、远程面分层理解
- REPL 本身是 orchestration layer，不是薄 UI
- Claude Code 的上下文管理应被理解为工作集管理，而不是“大窗口”策略
- PromptInput/Messages/VirtualMessageList/messageActions 共同构成前台控制面，而不是单纯输入框与滚动日志
- 产品能力需要按 build-time gate、runtime gate、compat shim 三层理解
- `services/compact/*` 体现的是多层上下文工作集管理，不是单一摘要算法
- `Command` 类型空间远大于内置 slash command 本身，很多高级字段主要为技能、插件、MCP 命令面准备

## 后续章节建议

1. 深挖 `REPL.tsx` 的交互状态机
2. 深挖 `services/api/claude.ts` 与 streaming tool execution
3. 深挖 `REPL.tsx` 的 transcript search / sticky prompt / message actions
4. 深挖权限系统与 auto mode 的风险控制
5. 深挖 memory / CLAUDE.md / scratchpad / durable knowledge
6. 深挖 AgentTool、Team、Coordinator 的编排范式
7. 深挖 MCP 接入面与插件生态边界
8. 深挖 `StructuredIO` / `RemoteIO` 的 host-CLI 协议与时序
9. 深挖 `services/api/claude.ts` 与 streaming tool execution
10. 把 `SDKMessageSchema` 做成可检索的消息字典
11. 深挖 `Messages.tsx`、`PromptInput`、`messageActions` 的前台交互层
12. 给 MCP 状态、命令 availability、控制请求做时序化视图
13. 继续把蓝皮书主线压缩成一跳结论，把细节持续下沉为可检索专题

## 编写约定

- 重要结论尽量附源码文件锚点
- 缺失模块不臆测，只写“可见事实 + 保守推断”
- 新研究先写入文档，再依赖上下文
- 正式章节优先写入 `bluebook/`，方法论和自我反思写入 `development/`
