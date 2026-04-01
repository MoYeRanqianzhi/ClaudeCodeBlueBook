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
  - 运行时契约、知识层与生态边界
  - 能力全集、公开度与成熟度矩阵
  - 导航专题
  - 第一性原理阅读地图
  - 能力、API与治理检索图
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
  - SDK 消息与 Control 闭环对照表
  - 远程恢复与重连状态机
  - 闭环状态机优于单向请求
  - 状态消息、外部元数据与宿主消费矩阵
  - 双通道状态同步与外部元数据回写
  - 外化状态优于推断状态
  - 系统提示词、Frontmatter 与上下文注入手册
  - 提示词装配链与上下文成形
  - 安全分层、策略收口与沙箱边界
  - 源码质量、分层与工程先进性
  - 消息塑形、输出外置与Token经济
  - 提示词魔力来自运行时而非咒语
  - 工程化质量优于聪明技巧
  - query turn 状态机、继续语义与恢复链
  - 统一权限决策流水线与多路仲裁
  - services 层全景与 utils-heavy 设计
  - SDKMessage、worker_status 与 external_metadata 字段级对照手册
  - 多 Agent 编排与 Prompt 模板
  - 会话持久化、TaskOutput 与 Sidechain 恢复图
  - REPL 前台状态机、Sticky Prompt 与消息动作
  - 能力迁移、Consumer Subset 与产品边界
  - 提示词契约分层、知识注入与缓存稳定性
  - 知识层栈：CLAUDE.md、Session Memory、Auto-memory与Attachments
  - 多Agent任务对象、Mailbox与后台协作运行时
  - 提示词合同、缓存稳定性与多Agent语法
  - 安全、权限、治理与Token预算统一图
  - 公开源码镜像的先进性、热点与技术债
  - 宿主实现最小闭环与恢复案例手册
  - 提示词控制、知识注入与记忆 API 手册
  - 插件、Marketplace、MCPB、LSP与Channels接入边界手册
  - 能力平面、公开度与宿主支持矩阵
  - 命令、工具、会话、宿主与协作API全谱系
  - 命令、工具、任务与团队能力全集手册
  - SDK、Control、Session与Remote接入全景矩阵
  - 插件协议全生命周期：Manifest、Marketplace、Options、MCPB与Reload
  - 治理型API：Channels、Context Usage与Settings三重真相
  - 动态能力暴露、裁剪链与运行时可见性
  - workflow engine、LocalWorkflowTask 与可见边界
  - REPL transcript search、selection 与 scroll 协同
  - 真正的设计单位不是功能，而是运行时平面
  - 前台交互不是 UI 皮肤，而是认知控制面
  - Prompt 不是文本技巧而是契约分层
  - 安全与 Token 经济不是权衡而是同一优化
  - 生态成熟度必须与协议支持分开叙述
  - Prompt魔力来自约束叠加与状态反馈
  - 安全、成本与体验必须共用预算器
  - 源码质量不是卫生而是产品能力
  - 可见边界优于脑补全貌
  - CLAUDE.md、记忆层与上下文注入实践
  - Channels、托管策略与组织级治理实践
  - 企业托管设置实战：channelsEnabled、allowedChannelPlugins与危险配置审批

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
- “功能支持”后续必须持续按两层写：先写能力平面，再写公开度与成熟度矩阵
- `navigation/` 负责读者检索，根目录主线负责判断标准，这两层不能重新混回一篇大总文
- API 写作现在已有统一基线：先用总表型文档确定能力平面、公开度与 adapter 宽度，再进入具体专题
- API atlas 现在已经分成两层：`23/24` 负责矩阵与谱系，`25-29` 负责能力对象、宿主接入、插件生命周期、治理型 API 与动态可见性
- 宿主接入分析必须继续把 `query()`、control protocol、state writeback、remote adapter、consumer subset 一起写，不能回退成单层 SDK 介绍
- workflow engine 当前最稳的写法应是“对象模型已可见、执行内核仍缺席”，不能因为缺文件就写成空白，也不能反过来脑补完整 engine
- REPL 的前台优势更适合按 search / selection / sticky / teammate routing 的协同来解释，而不是按单个 UI 组件解释
- channels 与托管设置应从“组织级治理实践”角度单独写，不再只散落在 API 与 risk 章节里
- 公开镜像相关写作纪律应升级为“可见边界优于脑补全貌”
- prompt 魔力更适合按“角色合同 + 缓存结构 + 状态晚绑定 + 协作语法”四层叙述，而不是按 prompt 文案评论叙述
- Prompt 魔力更精确的第一性原理表述应升级为“角色合同 + 工具边界 + 缓存结构 + 状态反馈 + 协作语法”
- 安全、token 经济与体验本质上共用一个预算器，分别约束动作空间、上下文空间与认知噪音
- 治理型 API 不是附属 introspection，而是输入治理、成本治理与配置治理三条正式控制面
- 当前公开源码镜像的工程先进性与局限必须一起写：既要写 contract-first / runtime-first，也要写热点大文件与公开树不完整
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
- Claude Code 的宿主协议更适合按 request / response / follow-on SDKMessage 的闭环来理解，而不是按单次 RPC 理解
- 远程恢复更适合按 `SessionsWebSocket`、`remoteBridgeCore`、`RemoteIO` 三层状态机理解，而不是一句“自动重连”
- Claude Code 的宿主状态真相更适合按“双通道”理解：`SDKMessage` 负责时间线，`worker_status` / `external_metadata` 负责当前快照与恢复后真相
- consumer subset 与 compatibility shim 是 API 现实的一部分：schema 全集并不等于每个 adapter / UI 都完整消费
- Claude Code 的 prompt 魔力更适合按“装配链 + 角色合同 + cache 稳定性 + attachment 注入”理解，而不是按单段 system prompt 理解
- Claude Code 的安全更适合按 trust / policy / typed permission / sandbox / hook / MCP auth 分层理解，而不是按 permission modal 理解
- Claude Code 的源码先进性更适合按 query turn state、Tool ABI、schema/cache/retry 基础设施理解，而不是按“文件整洁度”理解
- Claude Code 的省 token 更适合按“稳定前缀 + 按需目录 + 大块输出外置 + 尾部回收”四层经济系统理解，而不是按“是否会 compact”理解
- `query.ts` 更适合被理解成 turn runtime kernel，而不是“模型请求循环”
- Claude Code 的 continue 语义更适合按 tool follow-up、recovery self-loop、policy continuation 三类理解
- Claude Code 的权限链更适合按 typed decision engine + relay/renderer + hard boundary 理解，而不是按 permission modal 理解
- Claude Code 的宿主真相更适合按 event stream、snapshot、recovery 三层理解，而不是只按 SDK message 理解
- `services` 更适合被理解成长生命周期 subsystem planes，`utils` 更适合被理解为 invariant kernels
- 多 Agent prompt 的效果更适合按 runtime contract、ownership、mailbox/task bus 与隔离语义理解，而不是按措辞技巧理解
- Claude Code 的恢复更适合按主 transcript、sidechain transcript、task output、state restore 四层理解，而不是按“会话日志”单层理解
- Claude Code 的前台更适合被理解成认知控制面，而不是终端聊天 UI
- Claude Code 的产品现实更适合按 build gate、runtime gate、compat shim、consumer subset 四层理解
- Claude Code 的更高层设计单位更适合概括成 runtime planes，而不是功能清单
- Claude Code 的 prompt 更适合按“静态法 + 动态 section + 角色覆盖层 + attachment 晚绑定”理解，而不是按单段文案理解
- Claude Code 的知识更适合按“规则层 + typed memory + session memory + relevant memories”四层栈理解，而不是按单层记忆理解
- Claude Code 的多 Agent 更适合按“coordinator law + task object + mailbox/team context + inherited runtime”理解，而不是按并发数量理解
- Claude Code 的安全与 token 经济本质上都在做“限制无序扩张”的同一优化，只是分别作用于动作空间和上下文空间
- Claude Code 的生态写作必须持续区分 protocol support、runtime path 与 product maturity，不能因为代码里有入口就上升为稳定公共承诺
- 蓝皮书目录现在必须显式分成“主线正文”“导航层”“机制层”“接口层”“哲学层”“风险层”“实践层”，否则章节增多后会失去检索性
- Claude Code 的第一性原理不应再只写成六问，而应扩展为观察、决策、行动、记忆、协作、恢复、治理、经济八问

## 后续章节建议

1. 深挖 memory / CLAUDE.md / scratchpad / durable knowledge
2. 给 bridge / direct-connect / remote-session 三类宿主路径做更细时序图
3. 把 `SDKMessage`、control、snapshot、recovery 做成更细宿主实现 casebook
4. 给 MCP 状态、命令 availability、控制请求做时序化视图
5. 深挖 REPL 的 transcript mode、message actions、footer / quick search 协同
6. 继续把蓝皮书主线压缩成一跳结论，把细节持续下沉为可检索专题
7. 把工具面、宿主面、适配器面、时序面、闭环面、事件面、连接面、状态面、真相面、控制面、提示词面、工程面、协作面、前台面、演化面都做成清晰阅读路径
8. 把命令全集、工具全集、任务/团队/remote 能力全集从零散章节提升为统一可检索手册
9. 把治理型 API、插件 lifecycle、动态可见性继续做成宿主实践 casebook

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
- 写闭环相关结论时，必须同时标出 request、response、follow-on SDKMessage，以及哪个信号才算真正闭环完成
- 写状态相关结论时，必须同时标出事件时间线、当前快照、恢复路径，以及 consumer subset
- 写 prompt 相关结论时，必须同时标出装配链、角色合同、attachment 注入与 cache 约束
- 写源码质量相关结论时，必须同时标出 invariant、边界、cache/retry 结构与真实工程债务
- 写目录结构相关结论时，必须先问清自己是在补“正文主线”还是在补“导航/检索入口”
