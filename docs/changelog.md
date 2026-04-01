# Changelog

## 2026-04-01

- 初始化蓝皮书文档结构
- 新增总览、架构、使用指南、设计哲学、长期记忆文档
- 完成基于 `claude-code-source-code` 第一轮源码结构分析
- 新增功能全景与 API 支持章节
- 新增命令矩阵、Agent SDK 控制协议、MCP/远程传输文档
- 新增第一性原理与苏格拉底反思章节
- 优化文档目录分层，统一 changelog 入口为 `docs/changelog.md`
- 新增 REPL、权限状态机、上下文压缩恢复链三篇架构深挖
- 新增 SDK 消息字典、控制请求矩阵两篇接口字典
- 新增上下文经济学、安全观与边界设计两篇哲学深化
- 新增 PromptInput/消息渲染链、内置命令域索引、产品实验与演化方法
- 进一步收紧目录结构，明确 `bluebook/` 为主线、顶层 00-03 为兼容入口
- 新增 `services/compact/*` 细拆章节，补全上下文管理算法层分析
- 新增命令字段与可用性索引，补强 slash command / skill / plugin 命令面的字段支持
- 新增构建期开关、运行期开关与兼容层专题，补强产品演化方法论
- 同步更新主索引、专题 README、研究日志、证据索引与反思准则
- 新增工具协议与 `ToolUseContext`，补强工具面 API 与运行语义
- 新增会话存储、记忆与回溯状态面，补强 state surface 分析
- 新增“状态优先于对话”专题，并继续收紧目录为控制面、执行面、状态面、演化面四条阅读线
- 新增会话与状态 API 手册，明确区分 SDK 文档化 session API 与当前提取实现边界
- 新增 AgentTool 与隔离编排专题，补强 fork/background/worktree/remote 的统一编排视角
- 新增“隔离优先于并发”专题，并将第一性原理阅读路径映射到主索引
- 同步更新章节规划、证据索引、研究日志与长期记忆，固化本轮结论
- 新增扩展 Frontmatter 与插件 Agent 手册，补强 skills / agents / plugins 的统一扩展 API 视角
- 新增权限系统全链路与 Auto Mode 细拆，补强 mode、rule、classifier、headless fallback 的全链路理解
- 新增“统一配置语言优于扩展孤岛”专题，并将扩展面提升为单独阅读链
