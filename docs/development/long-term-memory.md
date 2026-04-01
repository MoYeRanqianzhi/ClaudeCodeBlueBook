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
  - 会话存储、记忆与回溯状态面
  - AgentTool 与隔离编排
  - 权限系统全链路与 Auto Mode
  - 上下文经济学
  - 安全观与边界设计
  - 产品实验与演化方法
  - 构建期开关、运行期开关与兼容层
  - 状态优先于对话
  - 隔离优先于并发
  - 统一配置语言优于扩展孤岛
  - 内置命令域索引
  - 命令字段与可用性索引
  - 工具协议与 ToolUseContext
  - 会话与状态 API 手册
  - 扩展 Frontmatter 与插件 Agent 手册
  - SDKMessageSchema 与事件流手册
  - MCP 配置与连接状态机
  - ClaudeAPI 与流式工具执行
  - StructuredIO 与 RemoteIO 宿主协议手册
  - StructuredIO 与 RemoteIO 控制平面
  - 宿主控制平面优于聊天外壳
  - Control 子类型与宿主适配矩阵
  - Bridge 与宿主适配器分层
  - 协议全集不等于适配器子集
  - Control 协议字段对照与宿主接入样例
  - 宿主路径时序与竞速
  - 显式失败优于假成功

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
- Claude Code 的状态面至少应按 transcript、memory、session memory、metadata、file history / rewind 分层理解
- “对话只是入口，状态才是运行时真相”已经成为当前蓝皮书的一个核心解释轴
- session/state surface 必须继续区分两层：SDK 文档化入口，与当前提取源码里真实可见的 control/runtime 实现
- Claude Code 的多 Agent 设计更适合概括成“隔离优先于并发”，而不是简单的“支持并行”
- Claude Code 的扩展面更适合概括成“统一配置语言 + 分层信任边界”，而不是“功能越来越多的插件拼盘”
- 权限系统必须按“context 装配 + 规则匹配 + mode 覆写 + classifier / hooks fallback”理解，不能只看 prompt 弹窗
- Claude Code SDK 的输出面更适合概括成“runtime event stream”，而不是“助手答案流”
- `query.ts` + `services/api/claude.ts` 维护的是可恢复执行轨迹，不是单纯流式文本输出
- MCP 更适合按“配置面 + transport 面 + 连接状态面 + 控制面”理解，而不是“外接工具协议”
- `message_delta` 对已 yield assistant message 的原地写回，是 transcript 引用一致性的重要实现细节
- plugin MCP 的动态 scope 与环境变量分层解析，说明连接治理是扩展模型的一部分，不是附加逻辑
- Claude Code 更适合被理解成 host-integrated runtime，而不是 terminal shell
- `StructuredIO` 的本质是 request correlation + cancel + permission race + duplicate/orphan 防护，而不是 stdin/stdout 包装器
- `RemoteIO` 的价值是把同一控制平面投射到远程 transport，并接上 CCR v2 internal events 与 session ingress
- direct connect / remote session manager 目前都只实现了完整控制协议的窄化子集，后续写作必须持续区分“协议全集”和“适配器子集”
- bridge 当前支持的是中等宽度控制子集：比 direct connect / `RemoteSessionManager` 宽，但仍明显窄于完整 `StructuredIO` / schema 全集
- `handleIngressMessage(...)` 与 `handleServerControlRequest(...)` 说明 bridge 不是全量 SDKMessage 镜像，而是显式分流 control、permission 与 user inbound 的控制面适配器
- control protocol 的最小封套可以压成 `control_request` / `control_response(success|error)` / `control_cancel_request` 四个核心对象
- 在宿主控制面里，“显式失败优于假成功”已经可以视为稳定设计原则：unknown subtype error、outbound-only error、abort reject 都是在防状态错觉

## 后续章节建议

1. 深挖 `REPL.tsx` 的交互状态机
2. 深挖 Team、Coordinator、Workflow 的更高层编排范式
3. 深挖 `REPL.tsx` 的 transcript search / sticky prompt / message actions
4. 深挖权限系统与 auto mode 的风险控制
5. 深挖 memory / CLAUDE.md / scratchpad / durable knowledge
6. 给 bridge / direct-connect / remote-session 三类宿主路径做更细时序图
7. 把 `SDKMessageSchema` 与 control subtype 做成 message-response crosswalk
8. 给 MCP 状态、命令 availability、控制请求做时序化视图
9. 深挖 `Messages.tsx`、`PromptInput`、`messageActions` 的前台交互层
10. 继续把蓝皮书主线压缩成一跳结论，把细节持续下沉为可检索专题
11. 把工具面、宿主面、适配器面、时序面、事件面、连接面、状态面、控制面、演化面都做成清晰阅读路径
12. 把 plugin manifest / marketplace / MCPB / LSP / channels 的产品边界继续写实

## 编写约定

- 重要结论尽量附源码文件锚点
- 缺失模块不臆测，只写“可见事实 + 保守推断”
- 新研究先写入文档，再依赖上下文
- 正式章节优先写入 `bluebook/`，方法论和自我反思写入 `development/`
- 写 session/state 相关结论时，必须显式标注“声明接口”“运行协议”“后端机制”分别属于哪一层
- 写多 Agent 相关结论时，必须优先问清这是并发语义还是隔离语义
- 写扩展面相关结论时，必须优先问清这是“共享配置语言”还是“某个对象的局部特例”
- 写权限面相关结论时，必须先标出它位于初始装配、规则层、mode 层、classifier 层还是 fallback 层
- 写 SDK 相关结论时，必须先问清自己描述的是 answer stream 还是 event stream
- 写 MCP 相关结论时，必须先区分配置面、连接状态面、控制面与 transport 面
- 写宿主相关结论时，必须先区分聊天外壳、control plane、transport plane 与 host adapter
- 写宿主适配相关结论时，必须同时标出“协议全集”“控制平面主路径”“当前适配器子集”三层
- 写时序相关结论时，必须同时标出成功路径、失败路径，以及删除失败路径后会出现的假成功错觉
