# 蓝皮书索引

## 目标

这套文档不复述表层功能，而是回答四个问题：

1. Claude Code 的源码结构到底是怎么组织的。
2. 用户与开发者应该如何高效使用它。
3. 它为什么在工程场景里表现强。
4. 哪些能力是公开可用的，哪些只是 feature gate 或内部能力。

## 阅读顺序

1. [00-导读](00-%E5%AF%BC%E8%AF%BB.md)
2. [01-源码结构地图](01-%E6%BA%90%E7%A0%81%E7%BB%93%E6%9E%84%E5%9C%B0%E5%9B%BE.md)
3. [02-使用指南](02-%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.md)
4. [03-设计哲学](03-%E8%AE%BE%E8%AE%A1%E5%93%B2%E5%AD%A6.md)
5. [04-公开能力与隐藏能力](04-%E5%85%AC%E5%BC%80%E8%83%BD%E5%8A%9B%E4%B8%8E%E9%9A%90%E8%97%8F%E8%83%BD%E5%8A%9B.md)
6. [05-功能全景与 API 支持](05-%E5%8A%9F%E8%83%BD%E5%85%A8%E6%99%AF%E4%B8%8EAPI%E6%94%AF%E6%8C%81.md)
7. [06-第一性原理与苏格拉底反思](06-%E7%AC%AC%E4%B8%80%E6%80%A7%E5%8E%9F%E7%90%86%E4%B8%8E%E8%8B%8F%E6%A0%BC%E6%8B%89%E5%BA%95%E5%8F%8D%E6%80%9D.md)
8. [07-运行时契约、知识层与生态边界](07-%E8%BF%90%E8%A1%8C%E6%97%B6%E5%A5%91%E7%BA%A6%E3%80%81%E7%9F%A5%E8%AF%86%E5%B1%82%E4%B8%8E%E7%94%9F%E6%80%81%E8%BE%B9%E7%95%8C.md)

## 按目标阅读

- 想先建立整体判断：顺读 `bluebook/` 主线。
- 想查具体机制：看 `architecture/`。
- 想查接口、字段和协议：看 `api/`。
- 想研究风控、账号治理与封号技术：看 `risk/`。
- 想理解设计内涵与演化方法：看 `philosophy/`。
- 想核对证据、日志与边界：看 `../docs/development/`。

## 按分析面阅读

- 控制面：命令、权限、REPL、remote/bridge。
- 执行面：tools、subagent、MCP、tool orchestration。
- 宿主面：StructuredIO、RemoteIO、direct connect、remote session、control protocol。
- 事件面：SDK event stream、Claude API stream parts、tool/task/auth/status 信号。
- 连接面：MCP config scope、transport、auth、reconnect/toggle 与连接治理。
- 扩展面：skills、commands、agents、plugins、hooks、MCP、LSP、output styles。
- 状态面：transcript、memory、session、rewind、compact/recovery。
- 真相面：`worker_status`、`requires_action_details`、`external_metadata`、state writeback。
- 演化面：feature gate、runtime gate、compat shim、默认值与 rollout。
- 治理面：账号、订阅、组织 policy、remote managed settings、telemetry、trusted device。

## 按专题链阅读

- 扩展链：`05-功能全景与API支持.md` -> `api/10-扩展Frontmatter与插件Agent手册.md` -> `architecture/03-扩展能力与远程架构.md` -> `philosophy/08-统一配置语言优于扩展孤岛.md`
- 宿主链：`api/13-StructuredIO与RemoteIO宿主协议手册.md` -> `architecture/13-StructuredIO与RemoteIO控制平面.md` -> `philosophy/09-宿主控制平面优于聊天外壳.md`
- 适配器链：`api/14-Control子类型与宿主适配矩阵.md` -> `architecture/14-Bridge与宿主适配器分层.md` -> `philosophy/10-协议全集不等于适配器子集.md`
- 时序链：`api/15-Control协议字段对照与宿主接入样例.md` -> `architecture/15-宿主路径时序与竞速.md` -> `philosophy/11-显式失败优于假成功.md`
- 闭环链：`api/16-SDK消息与Control闭环对照表.md` -> `architecture/16-远程恢复与重连状态机.md` -> `philosophy/12-闭环状态机优于单向请求.md`
- 状态同步链：`api/17-状态消息、外部元数据与宿主消费矩阵.md` -> `architecture/17-双通道状态同步与外部元数据回写.md` -> `philosophy/13-外化状态优于推断状态.md`
- Prompt 链：`api/18-系统提示词、Frontmatter与上下文注入手册.md` -> `architecture/18-提示词装配链与上下文成形.md` -> `philosophy/14-提示词魔力来自运行时而非咒语.md`
- 安全链：`architecture/05-权限系统与安全状态机.md` -> `architecture/11-权限系统全链路与Auto Mode.md` -> `architecture/19-安全分层、策略收口与沙箱边界.md` -> `philosophy/03-安全观与边界设计.md`
- 工程链：`architecture/20-源码质量、分层与工程先进性.md` -> `philosophy/15-工程化质量优于聪明技巧.md`
- 上下文链：`philosophy/02-上下文经济学.md` -> `architecture/08-compact算法与上下文管理细拆.md` -> `architecture/21-消息塑形、输出外置与Token经济.md`
- Query 链：`architecture/02-Agent循环与工具系统.md` -> `architecture/12-ClaudeAPI与流式工具执行.md` -> `architecture/22-query-turn状态机、继续语义与恢复链.md`
- 权限决策链：`architecture/05-权限系统与安全状态机.md` -> `architecture/11-权限系统全链路与Auto Mode.md` -> `architecture/23-统一权限决策流水线与多路仲裁.md`
- 状态字段链：`api/17-状态消息、外部元数据与宿主消费矩阵.md` -> `api/19-SDKMessage、worker_status与external_metadata字段级对照手册.md` -> `architecture/17-双通道状态同步与外部元数据回写.md`
- 协作链：`architecture/10-AgentTool与隔离编排.md` -> `guides/02-多Agent编排与Prompt模板.md` -> `philosophy/07-隔离优先于并发.md`
- 契约链：`api/21-提示词控制、知识注入与记忆API手册.md` -> `architecture/28-提示词契约分层、知识注入与缓存稳定性.md` -> `philosophy/18-Prompt不是文本技巧而是契约分层.md`
- 知识链：`guides/03-CLAUDE.md、记忆层与上下文注入实践.md` -> `api/21-提示词控制、知识注入与记忆API手册.md` -> `architecture/29-知识层栈：CLAUDE.md、Session Memory、Auto-memory与Attachments.md`
- 安全经济链：`architecture/19-安全分层、策略收口与沙箱边界.md` -> `architecture/21-消息塑形、输出外置与Token经济.md` -> `philosophy/19-安全与Token经济不是权衡而是同一优化.md`
- 协作运行时链：`architecture/10-AgentTool与隔离编排.md` -> `architecture/30-多Agent任务对象、Mailbox与后台协作运行时.md` -> `guides/02-多Agent编排与Prompt模板.md`
- 生态边界链：`api/22-插件、Marketplace、MCPB、LSP与Channels接入边界手册.md` -> `architecture/27-能力迁移、Consumer Subset与产品边界.md` -> `philosophy/20-生态成熟度必须与协议支持分开叙述.md`
- 分层链：`architecture/20-源码质量、分层与工程先进性.md` -> `architecture/24-services层全景与utils-heavy设计.md`
- 恢复链：`architecture/09-会话存储记忆与回溯状态面.md` -> `architecture/25-会话持久化、TaskOutput与Sidechain恢复图.md` -> `api/20-宿主实现最小闭环与恢复案例手册.md`
- 前台链：`architecture/04-REPL与Ink交互架构.md` -> `architecture/26-REPL前台状态机、Sticky Prompt与消息动作.md` -> `philosophy/17-前台交互不是UI皮肤而是认知控制面.md`
- 迁移链：`philosophy/05-构建期开关、运行期开关与兼容层.md` -> `architecture/27-能力迁移、Consumer Subset与产品边界.md`
- 事件链：`api/04-SDK消息与事件字典.md` -> `api/11-SDKMessageSchema与事件流手册.md` -> `architecture/12-ClaudeAPI与流式工具执行.md` -> `philosophy/06-状态优先于对话.md`
- 连接链：`api/03-MCP与远程传输.md` -> `api/12-MCP配置与连接状态机.md` -> `architecture/03-扩展能力与远程架构.md` -> `philosophy/08-统一配置语言优于扩展孤岛.md`
- 策略链：`architecture/05-权限系统与安全状态机.md` -> `architecture/11-权限系统全链路与Auto Mode.md` -> `philosophy/03-安全观与边界设计.md`
- 风控链：`risk/00-研究方法与可信边界.md` -> `risk/01-风控总论：封禁不是单点开关.md` -> `risk/02-身份、订阅、组织与策略限制.md` -> `risk/03-遥测、GrowthBook 与远程下发控制.md` -> `risk/04-本地执行面：权限、Auto Mode、Sandbox 与阻断.md` -> `risk/05-Remote Control、Trusted Device 与高安全会话.md` -> `risk/06-失效模式、封禁表现与合规使用边界.md` -> `risk/07-合规降低误判、保护权益与高风险地区用户建议.md` -> `risk/08-风控检测技术的先进性、原理与源码启示.md` -> `risk/09-第一性原理与苏格拉底式反思.md` -> `risk/10-错误语义、能力撤回与治理层矩阵.md` -> `risk/11-治理闭环时序：观测、判定、下发、阻断与恢复.md` -> `risk/12-Selective Fail-Open  Fail-Closed 的设计哲学.md` -> `risk/13-误伤处置、支持路径与证据保全决策树.md` -> `risk/14-图解：Remote Control、能力门槛与误伤处置流程.md` -> `risk/15-平台正义、误伤、公平性与可解释性.md` -> `risk/16-图解：Bridge、Trusted Device 与 401 Recovery 精细时序.md` -> `risk/17-速查卡：错误语义、用户动作与支持路径.md` -> `risk/18-可迁移设计法则：给 Agent 平台构建者的启示.md` -> `risk/19-单页总纲：从主体到处置的风控研究地图.md` -> `risk/20-高波动网络环境、中国用户与连续性破坏机制.md` -> `risk/21-给平台方的改进清单：诊断、解释层与恢复路径.md`
- 会话链：`architecture/09-会话存储记忆与回溯状态面.md` -> `api/09-会话与状态API手册.md` -> `philosophy/06-状态优先于对话.md`

## 按第一性原理阅读

- 观察：`05-功能全景与API支持.md`、`api/08-工具协议与ToolUseContext.md`
- 决策：`architecture/02-Agent循环与工具系统.md`、`architecture/12-ClaudeAPI与流式工具执行.md`
- 行动：`architecture/05-权限系统与安全状态机.md`、`api/01-命令与功能矩阵.md`
- 记忆：`architecture/09-会话存储记忆与回溯状态面.md`、`api/09-会话与状态API手册.md`
- 协作：`architecture/10-AgentTool与隔离编排.md`、`philosophy/07-隔离优先于并发.md`
- 宿主：`api/13-StructuredIO与RemoteIO宿主协议手册.md`、`architecture/13-StructuredIO与RemoteIO控制平面.md`、`philosophy/09-宿主控制平面优于聊天外壳.md`
- 适配器：`api/14-Control子类型与宿主适配矩阵.md`、`architecture/14-Bridge与宿主适配器分层.md`、`philosophy/10-协议全集不等于适配器子集.md`
- 时序：`api/15-Control协议字段对照与宿主接入样例.md`、`architecture/15-宿主路径时序与竞速.md`、`philosophy/11-显式失败优于假成功.md`
- 闭环：`api/16-SDK消息与Control闭环对照表.md`、`architecture/16-远程恢复与重连状态机.md`、`philosophy/12-闭环状态机优于单向请求.md`
- 真相：`api/17-状态消息、外部元数据与宿主消费矩阵.md`、`architecture/17-双通道状态同步与外部元数据回写.md`、`philosophy/13-外化状态优于推断状态.md`
- 提示词：`api/18-系统提示词、Frontmatter与上下文注入手册.md`、`architecture/18-提示词装配链与上下文成形.md`、`philosophy/14-提示词魔力来自运行时而非咒语.md`
- 上下文：`philosophy/02-上下文经济学.md`、`architecture/08-compact算法与上下文管理细拆.md`、`architecture/21-消息塑形、输出外置与Token经济.md`
- 契约：`api/21-提示词控制、知识注入与记忆API手册.md`、`architecture/28-提示词契约分层、知识注入与缓存稳定性.md`、`philosophy/18-Prompt不是文本技巧而是契约分层.md`
- 知识：`guides/03-CLAUDE.md、记忆层与上下文注入实践.md`、`architecture/29-知识层栈：CLAUDE.md、Session Memory、Auto-memory与Attachments.md`
- 安全经济：`architecture/19-安全分层、策略收口与沙箱边界.md`、`architecture/21-消息塑形、输出外置与Token经济.md`、`philosophy/19-安全与Token经济不是权衡而是同一优化.md`
- 工程：`architecture/20-源码质量、分层与工程先进性.md`、`philosophy/15-工程化质量优于聪明技巧.md`
- 恢复：`architecture/06-上下文压缩与恢复链.md`、`architecture/12-ClaudeAPI与流式工具执行.md`、`philosophy/06-状态优先于对话.md`
- 继续：`architecture/22-query-turn状态机、继续语义与恢复链.md`
- 权限：`architecture/23-统一权限决策流水线与多路仲裁.md`
- 分层：`architecture/24-services层全景与utils-heavy设计.md`
- 协作：`guides/02-多Agent编排与Prompt模板.md`
- 恢复：`architecture/25-会话持久化、TaskOutput与Sidechain恢复图.md`
- 前台：`architecture/26-REPL前台状态机、Sticky Prompt与消息动作.md`
- 迁移：`architecture/27-能力迁移、Consumer Subset与产品边界.md`
- 母题：`philosophy/16-真正的设计单位不是功能，而是运行时平面.md`
- 协作运行时：`architecture/30-多Agent任务对象、Mailbox与后台协作运行时.md`
- 生态：`api/22-插件、Marketplace、MCPB、LSP与Channels接入边界手册.md`、`philosophy/20-生态成熟度必须与协议支持分开叙述.md`

## 正式主线与兼容入口

- 正式主线以 `bluebook/00-导读.md` 到 `bluebook/07-运行时契约、知识层与生态边界.md` 为准。
- 历史兼容入口如 `00-蓝皮书总览.md`、`01-源码总地图.md` 仍保留在 `bluebook/` 根目录，主要用于兼容旧链接与旧阅读习惯。
- 后续主线增补继续放在 `bluebook/` 根目录，字段级、状态机级、算法级细拆优先下沉到 `api/`、`architecture/`、`philosophy/`。

## 当前结论的可信边界

- 可靠: 目录结构、启动路径、工具与权限模型、技能与 MCP 装配方式、远程与多 Agent 主流程、`SDKMessageSchema` 事件族、Claude API 流式工具执行主链、MCP config/connection/control 四层模型、宿主控制协议与 `StructuredIO` / `RemoteIO` 主链。
- 半可靠: 某些通过 `feature()` 或 GrowthBook 控制的能力，只能确认“代码有入口”或“公开包引用了接口”，不能等同于“外部用户必可用”；`claudeai-proxy`、`ws-ide`、`research` / `advisor` 等 internal 痕迹也不应直接上升为稳定公共承诺。
- 不应过度断言: npm 发布包里被编译时裁剪掉的内部模块行为细节。

## 维护约定

- 新发现先写入 [development/research-log.md](../docs/development/research-log.md)。
- 形成稳定结论后，再升级到 `bluebook/` 正式章节。
- 发现源码版本变化时，先更新导读中的版本范围，再逐章校验。

## 目录结构

- `bluebook/`: 正式主线章节与兼容入口
- `architecture/`: 机制、状态机与算法深挖
- `api/`: 接口、字段与可用性索引
- `guides/`: 用法与工作流
- `risk/`: 风控、账号限制与远程高安全链路专题
- `philosophy/`: 哲学、产品演化与第一性原理解读
- `../docs/`: 持久化记忆、研究过程、日志与迭代准则

## 专题索引

- [架构专题](architecture/README.md)
- [API 专题](api/README.md)
- [使用专题](guides/README.md)
- [风控专题](risk/README.md)
- [哲学专题](philosophy/README.md)

近期新增的深挖入口：

- [运行时契约、知识层与生态边界](07-%E8%BF%90%E8%A1%8C%E6%97%B6%E5%A5%91%E7%BA%A6%E3%80%81%E7%9F%A5%E8%AF%86%E5%B1%82%E4%B8%8E%E7%94%9F%E6%80%81%E8%BE%B9%E7%95%8C.md)
- [提示词控制、知识注入与记忆 API 手册](api/21-%E6%8F%90%E7%A4%BA%E8%AF%8D%E6%8E%A7%E5%88%B6%E3%80%81%E7%9F%A5%E8%AF%86%E6%B3%A8%E5%85%A5%E4%B8%8E%E8%AE%B0%E5%BF%86API%E6%89%8B%E5%86%8C.md)
- [提示词契约分层、知识注入与缓存稳定性](architecture/28-%E6%8F%90%E7%A4%BA%E8%AF%8D%E5%A5%91%E7%BA%A6%E5%88%86%E5%B1%82%E3%80%81%E7%9F%A5%E8%AF%86%E6%B3%A8%E5%85%A5%E4%B8%8E%E7%BC%93%E5%AD%98%E7%A8%B3%E5%AE%9A%E6%80%A7.md)
- [知识层栈：CLAUDE.md、Session Memory、Auto-memory与Attachments](architecture/29-%E7%9F%A5%E8%AF%86%E5%B1%82%E6%A0%88%EF%BC%9ACLAUDE.md%E3%80%81Session%20Memory%E3%80%81Auto-memory%E4%B8%8EAttachments.md)
- [多Agent任务对象、Mailbox与后台协作运行时](architecture/30-%E5%A4%9AAgent%E4%BB%BB%E5%8A%A1%E5%AF%B9%E8%B1%A1%E3%80%81Mailbox%E4%B8%8E%E5%90%8E%E5%8F%B0%E5%8D%8F%E4%BD%9C%E8%BF%90%E8%A1%8C%E6%97%B6.md)
- [CLAUDE.md、记忆层与上下文注入实践](guides/03-CLAUDE.md%E3%80%81%E8%AE%B0%E5%BF%86%E5%B1%82%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E6%B3%A8%E5%85%A5%E5%AE%9E%E8%B7%B5.md)
- [Prompt 不是文本技巧而是契约分层](philosophy/18-Prompt%E4%B8%8D%E6%98%AF%E6%96%87%E6%9C%AC%E6%8A%80%E5%B7%A7%E8%80%8C%E6%98%AF%E5%A5%91%E7%BA%A6%E5%88%86%E5%B1%82.md)
- [安全与 Token 经济不是权衡而是同一优化](philosophy/19-%E5%AE%89%E5%85%A8%E4%B8%8EToken%E7%BB%8F%E6%B5%8E%E4%B8%8D%E6%98%AF%E6%9D%83%E8%A1%A1%E8%80%8C%E6%98%AF%E5%90%8C%E4%B8%80%E4%BC%98%E5%8C%96.md)
- [生态成熟度必须与协议支持分开叙述](philosophy/20-%E7%94%9F%E6%80%81%E6%88%90%E7%86%9F%E5%BA%A6%E5%BF%85%E9%A1%BB%E4%B8%8E%E5%8D%8F%E8%AE%AE%E6%94%AF%E6%8C%81%E5%88%86%E5%BC%80%E5%8F%99%E8%BF%B0.md)
- [StructuredIO 与 RemoteIO 宿主协议手册](api/13-StructuredIO%E4%B8%8ERemoteIO%E5%AE%BF%E4%B8%BB%E5%8D%8F%E8%AE%AE%E6%89%8B%E5%86%8C.md)
- [StructuredIO 与 RemoteIO 控制平面](architecture/13-StructuredIO%E4%B8%8ERemoteIO%E6%8E%A7%E5%88%B6%E5%B9%B3%E9%9D%A2.md)
- [宿主控制平面优于聊天外壳](philosophy/09-%E5%AE%BF%E4%B8%BB%E6%8E%A7%E5%88%B6%E5%B9%B3%E9%9D%A2%E4%BC%98%E4%BA%8E%E8%81%8A%E5%A4%A9%E5%A4%96%E5%A3%B3.md)
- [Control 子类型与宿主适配矩阵](api/14-Control%E5%AD%90%E7%B1%BB%E5%9E%8B%E4%B8%8E%E5%AE%BF%E4%B8%BB%E9%80%82%E9%85%8D%E7%9F%A9%E9%98%B5.md)
- [Bridge 与宿主适配器分层](architecture/14-Bridge%E4%B8%8E%E5%AE%BF%E4%B8%BB%E9%80%82%E9%85%8D%E5%99%A8%E5%88%86%E5%B1%82.md)
- [协议全集不等于适配器子集](philosophy/10-%E5%8D%8F%E8%AE%AE%E5%85%A8%E9%9B%86%E4%B8%8D%E7%AD%89%E4%BA%8E%E9%80%82%E9%85%8D%E5%99%A8%E5%AD%90%E9%9B%86.md)
- [Control 协议字段对照与宿主接入样例](api/15-Control%E5%8D%8F%E8%AE%AE%E5%AD%97%E6%AE%B5%E5%AF%B9%E7%85%A7%E4%B8%8E%E5%AE%BF%E4%B8%BB%E6%8E%A5%E5%85%A5%E6%A0%B7%E4%BE%8B.md)
- [宿主路径时序与竞速](architecture/15-%E5%AE%BF%E4%B8%BB%E8%B7%AF%E5%BE%84%E6%97%B6%E5%BA%8F%E4%B8%8E%E7%AB%9E%E9%80%9F.md)
- [显式失败优于假成功](philosophy/11-%E6%98%BE%E5%BC%8F%E5%A4%B1%E8%B4%A5%E4%BC%98%E4%BA%8E%E5%81%87%E6%88%90%E5%8A%9F.md)
- [SDK 消息与 Control 闭环对照表](api/16-SDK%E6%B6%88%E6%81%AF%E4%B8%8EControl%E9%97%AD%E7%8E%AF%E5%AF%B9%E7%85%A7%E8%A1%A8.md)
- [远程恢复与重连状态机](architecture/16-%E8%BF%9C%E7%A8%8B%E6%81%A2%E5%A4%8D%E4%B8%8E%E9%87%8D%E8%BF%9E%E7%8A%B6%E6%80%81%E6%9C%BA.md)
- [闭环状态机优于单向请求](philosophy/12-%E9%97%AD%E7%8E%AF%E7%8A%B6%E6%80%81%E6%9C%BA%E4%BC%98%E4%BA%8E%E5%8D%95%E5%90%91%E8%AF%B7%E6%B1%82.md)
- [状态消息、外部元数据与宿主消费矩阵](api/17-%E7%8A%B6%E6%80%81%E6%B6%88%E6%81%AF%E3%80%81%E5%A4%96%E9%83%A8%E5%85%83%E6%95%B0%E6%8D%AE%E4%B8%8E%E5%AE%BF%E4%B8%BB%E6%B6%88%E8%B4%B9%E7%9F%A9%E9%98%B5.md)
- [双通道状态同步与外部元数据回写](architecture/17-%E5%8F%8C%E9%80%9A%E9%81%93%E7%8A%B6%E6%80%81%E5%90%8C%E6%AD%A5%E4%B8%8E%E5%A4%96%E9%83%A8%E5%85%83%E6%95%B0%E6%8D%AE%E5%9B%9E%E5%86%99.md)
- [外化状态优于推断状态](philosophy/13-%E5%A4%96%E5%8C%96%E7%8A%B6%E6%80%81%E4%BC%98%E4%BA%8E%E6%8E%A8%E6%96%AD%E7%8A%B6%E6%80%81.md)
- [系统提示词、Frontmatter 与上下文注入手册](api/18-%E7%B3%BB%E7%BB%9F%E6%8F%90%E7%A4%BA%E8%AF%8D%E3%80%81Frontmatter%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E6%B3%A8%E5%85%A5%E6%89%8B%E5%86%8C.md)
- [提示词装配链与上下文成形](architecture/18-%E6%8F%90%E7%A4%BA%E8%AF%8D%E8%A3%85%E9%85%8D%E9%93%BE%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E6%88%90%E5%BD%A2.md)
- [提示词魔力来自运行时而非咒语](philosophy/14-%E6%8F%90%E7%A4%BA%E8%AF%8D%E9%AD%94%E5%8A%9B%E6%9D%A5%E8%87%AA%E8%BF%90%E8%A1%8C%E6%97%B6%E8%80%8C%E9%9D%9E%E5%92%92%E8%AF%AD.md)
- [安全分层、策略收口与沙箱边界](architecture/19-%E5%AE%89%E5%85%A8%E5%88%86%E5%B1%82%E3%80%81%E7%AD%96%E7%95%A5%E6%94%B6%E5%8F%A3%E4%B8%8E%E6%B2%99%E7%AE%B1%E8%BE%B9%E7%95%8C.md)
- [源码质量、分层与工程先进性](architecture/20-%E6%BA%90%E7%A0%81%E8%B4%A8%E9%87%8F%E3%80%81%E5%88%86%E5%B1%82%E4%B8%8E%E5%B7%A5%E7%A8%8B%E5%85%88%E8%BF%9B%E6%80%A7.md)
- [消息塑形、输出外置与 Token 经济](architecture/21-%E6%B6%88%E6%81%AF%E5%A1%91%E5%BD%A2%E3%80%81%E8%BE%93%E5%87%BA%E5%A4%96%E7%BD%AE%E4%B8%8EToken%E7%BB%8F%E6%B5%8E.md)
- [工程化质量优于聪明技巧](philosophy/15-%E5%B7%A5%E7%A8%8B%E5%8C%96%E8%B4%A8%E9%87%8F%E4%BC%98%E4%BA%8E%E8%81%AA%E6%98%8E%E6%8A%80%E5%B7%A7.md)
- [query turn 状态机、继续语义与恢复链](architecture/22-query-turn%E7%8A%B6%E6%80%81%E6%9C%BA%E3%80%81%E7%BB%A7%E7%BB%AD%E8%AF%AD%E4%B9%89%E4%B8%8E%E6%81%A2%E5%A4%8D%E9%93%BE.md)
- [统一权限决策流水线与多路仲裁](architecture/23-%E7%BB%9F%E4%B8%80%E6%9D%83%E9%99%90%E5%86%B3%E7%AD%96%E6%B5%81%E6%B0%B4%E7%BA%BF%E4%B8%8E%E5%A4%9A%E8%B7%AF%E4%BB%B2%E8%A3%81.md)
- [services 层全景与 utils-heavy 设计](architecture/24-services%E5%B1%82%E5%85%A8%E6%99%AF%E4%B8%8Eutils-heavy%E8%AE%BE%E8%AE%A1.md)
- [会话持久化、TaskOutput 与 Sidechain 恢复图](architecture/25-%E4%BC%9A%E8%AF%9D%E6%8C%81%E4%B9%85%E5%8C%96%E3%80%81TaskOutput%E4%B8%8ESidechain%E6%81%A2%E5%A4%8D%E5%9B%BE.md)
- [REPL 前台状态机、Sticky Prompt 与消息动作](architecture/26-REPL%E5%89%8D%E5%8F%B0%E7%8A%B6%E6%80%81%E6%9C%BA%E3%80%81Sticky%20Prompt%E4%B8%8E%E6%B6%88%E6%81%AF%E5%8A%A8%E4%BD%9C.md)
- [能力迁移、Consumer Subset 与产品边界](architecture/27-%E8%83%BD%E5%8A%9B%E8%BF%81%E7%A7%BB%E3%80%81Consumer%20Subset%E4%B8%8E%E4%BA%A7%E5%93%81%E8%BE%B9%E7%95%8C.md)
- [提示词控制、知识注入与记忆 API 手册](api/21-%E6%8F%90%E7%A4%BA%E8%AF%8D%E6%8E%A7%E5%88%B6%E3%80%81%E7%9F%A5%E8%AF%86%E6%B3%A8%E5%85%A5%E4%B8%8E%E8%AE%B0%E5%BF%86API%E6%89%8B%E5%86%8C.md)
- [插件、Marketplace、MCPB、LSP与Channels接入边界手册](api/22-%E6%8F%92%E4%BB%B6%E3%80%81Marketplace%E3%80%81MCPB%E3%80%81LSP%E4%B8%8EChannels%E6%8E%A5%E5%85%A5%E8%BE%B9%E7%95%8C%E6%89%8B%E5%86%8C.md)
- [提示词契约分层、知识注入与缓存稳定性](architecture/28-%E6%8F%90%E7%A4%BA%E8%AF%8D%E5%A5%91%E7%BA%A6%E5%88%86%E5%B1%82%E3%80%81%E7%9F%A5%E8%AF%86%E6%B3%A8%E5%85%A5%E4%B8%8E%E7%BC%93%E5%AD%98%E7%A8%B3%E5%AE%9A%E6%80%A7.md)
- [知识层栈：CLAUDE.md、Session Memory、Auto-memory与Attachments](architecture/29-%E7%9F%A5%E8%AF%86%E5%B1%82%E6%A0%88%EF%BC%9ACLAUDE.md%E3%80%81Session%20Memory%E3%80%81Auto-memory%E4%B8%8EAttachments.md)
- [多Agent任务对象、Mailbox与后台协作运行时](architecture/30-%E5%A4%9AAgent%E4%BB%BB%E5%8A%A1%E5%AF%B9%E8%B1%A1%E3%80%81Mailbox%E4%B8%8E%E5%90%8E%E5%8F%B0%E5%8D%8F%E4%BD%9C%E8%BF%90%E8%A1%8C%E6%97%B6.md)
- [SDKMessage、worker_status 与 external_metadata 字段级对照手册](api/19-SDKMessage%E3%80%81worker_status%E4%B8%8Eexternal_metadata%E5%AD%97%E6%AE%B5%E7%BA%A7%E5%AF%B9%E7%85%A7%E6%89%8B%E5%86%8C.md)
- [宿主实现最小闭环与恢复案例手册](api/20-%E5%AE%BF%E4%B8%BB%E5%AE%9E%E7%8E%B0%E6%9C%80%E5%B0%8F%E9%97%AD%E7%8E%AF%E4%B8%8E%E6%81%A2%E5%A4%8D%E6%A1%88%E4%BE%8B%E6%89%8B%E5%86%8C.md)
- [多 Agent 编排与 Prompt 模板](guides/02-%E5%A4%9AAgent%E7%BC%96%E6%8E%92%E4%B8%8EPrompt%E6%A8%A1%E6%9D%BF.md)
- [CLAUDE.md、记忆层与上下文注入实践](guides/03-CLAUDE.md%E3%80%81%E8%AE%B0%E5%BF%86%E5%B1%82%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E6%B3%A8%E5%85%A5%E5%AE%9E%E8%B7%B5.md)
- [真正的设计单位不是功能，而是运行时平面](philosophy/16-%E7%9C%9F%E6%AD%A3%E7%9A%84%E8%AE%BE%E8%AE%A1%E5%8D%95%E4%BD%8D%E4%B8%8D%E6%98%AF%E5%8A%9F%E8%83%BD%E8%80%8C%E6%98%AF%E8%BF%90%E8%A1%8C%E6%97%B6%E5%B9%B3%E9%9D%A2.md)
- [前台交互不是 UI 皮肤，而是认知控制面](philosophy/17-%E5%89%8D%E5%8F%B0%E4%BA%A4%E4%BA%92%E4%B8%8D%E6%98%AFUI%E7%9A%AE%E8%82%A4%E8%80%8C%E6%98%AF%E8%AE%A4%E7%9F%A5%E6%8E%A7%E5%88%B6%E9%9D%A2.md)
- [Prompt 不是文本技巧而是契约分层](philosophy/18-Prompt%E4%B8%8D%E6%98%AF%E6%96%87%E6%9C%AC%E6%8A%80%E5%B7%A7%E8%80%8C%E6%98%AF%E5%A5%91%E7%BA%A6%E5%88%86%E5%B1%82.md)
- [安全与 Token 经济不是权衡而是同一优化](philosophy/19-%E5%AE%89%E5%85%A8%E4%B8%8EToken%E7%BB%8F%E6%B5%8E%E4%B8%8D%E6%98%AF%E6%9D%83%E8%A1%A1%E8%80%8C%E6%98%AF%E5%90%8C%E4%B8%80%E4%BC%98%E5%8C%96.md)
- [生态成熟度必须与协议支持分开叙述](philosophy/20-%E7%94%9F%E6%80%81%E6%88%90%E7%86%9F%E5%BA%A6%E5%BF%85%E9%A1%BB%E4%B8%8E%E5%8D%8F%E8%AE%AE%E6%94%AF%E6%8C%81%E5%88%86%E5%BC%80%E5%8F%99%E8%BF%B0.md)
- [SDKMessageSchema 与事件流手册](api/11-SDKMessageSchema%E4%B8%8E%E4%BA%8B%E4%BB%B6%E6%B5%81%E6%89%8B%E5%86%8C.md)
- [MCP 配置与连接状态机](api/12-MCP%E9%85%8D%E7%BD%AE%E4%B8%8E%E8%BF%9E%E6%8E%A5%E7%8A%B6%E6%80%81%E6%9C%BA.md)
- [ClaudeAPI 与流式工具执行](architecture/12-ClaudeAPI%E4%B8%8E%E6%B5%81%E5%BC%8F%E5%B7%A5%E5%85%B7%E6%89%A7%E8%A1%8C.md)
- [compact 算法与上下文管理细拆](architecture/08-compact%E7%AE%97%E6%B3%95%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E7%AE%A1%E7%90%86%E7%BB%86%E6%8B%86.md)
- [会话存储、记忆与回溯状态面](architecture/09-%E4%BC%9A%E8%AF%9D%E5%AD%98%E5%82%A8%E8%AE%B0%E5%BF%86%E4%B8%8E%E5%9B%9E%E6%BA%AF%E7%8A%B6%E6%80%81%E9%9D%A2.md)
- [AgentTool 与隔离编排](architecture/10-AgentTool%E4%B8%8E%E9%9A%94%E7%A6%BB%E7%BC%96%E6%8E%92.md)
- [命令字段与可用性索引](api/07-%E5%91%BD%E4%BB%A4%E5%AD%97%E6%AE%B5%E4%B8%8E%E5%8F%AF%E7%94%A8%E6%80%A7%E7%B4%A2%E5%BC%95.md)
- [工具协议与 ToolUseContext](api/08-%E5%B7%A5%E5%85%B7%E5%8D%8F%E8%AE%AE%E4%B8%8EToolUseContext.md)
- [会话与状态 API 手册](api/09-%E4%BC%9A%E8%AF%9D%E4%B8%8E%E7%8A%B6%E6%80%81API%E6%89%8B%E5%86%8C.md)
- [扩展 Frontmatter 与插件 Agent 手册](api/10-%E6%89%A9%E5%B1%95Frontmatter%E4%B8%8E%E6%8F%92%E4%BB%B6Agent%E6%89%8B%E5%86%8C.md)
- [构建期开关、运行期开关与兼容层](philosophy/05-%E6%9E%84%E5%BB%BA%E6%9C%9F%E5%BC%80%E5%85%B3%E3%80%81%E8%BF%90%E8%A1%8C%E6%9C%9F%E5%BC%80%E5%85%B3%E4%B8%8E%E5%85%BC%E5%AE%B9%E5%B1%82.md)
- [状态优先于对话](philosophy/06-%E7%8A%B6%E6%80%81%E4%BC%98%E5%85%88%E4%BA%8E%E5%AF%B9%E8%AF%9D.md)
- [隔离优先于并发](philosophy/07-%E9%9A%94%E7%A6%BB%E4%BC%98%E5%85%88%E4%BA%8E%E5%B9%B6%E5%8F%91.md)
- [统一配置语言优于扩展孤岛](philosophy/08-%E7%BB%9F%E4%B8%80%E9%85%8D%E7%BD%AE%E8%AF%AD%E8%A8%80%E4%BC%98%E4%BA%8E%E6%89%A9%E5%B1%95%E5%AD%A4%E5%B2%9B.md)
- [权限系统全链路与 Auto Mode](architecture/11-%E6%9D%83%E9%99%90%E7%B3%BB%E7%BB%9F%E5%85%A8%E9%93%BE%E8%B7%AF%E4%B8%8EAuto%20Mode.md)
