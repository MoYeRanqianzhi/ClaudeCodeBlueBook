# 蓝皮书索引

## 目标

这套蓝皮书不重复产品介绍，而是回答六个问题：

1. Claude Code 的源码究竟由哪些运行时平面组成。
2. 功能、工具、命令、SDK、宿主协议分别暴露在哪一层。
3. 为什么它的 prompt、权限、安全、token 经济必须一起理解。
4. 为什么它更像 agent runtime，而不是聊天壳或 IDE 插件。
5. 哪些能力属于公共主路径，哪些只是 gate、子集或内部痕迹。
6. 用户、宿主开发者、Agent 平台设计者各该如何读这套源码。

## 目录职责

- `bluebook/` 根目录：主线结论，强调一跳能懂。
- `bluebook/architecture/`：运行时结构拆解，强调链路、状态机、时序和分层。
- `bluebook/api/`：接口、字段、协议和能力支持面，强调宿主可接入性。
- `bluebook/navigation/`：阅读地图与检索入口，不承载新的正文平面。
- `bluebook/philosophy/`：设计内涵、第一性原理与演化方法。
- `bluebook/guides/`：从源码反推的实战使用方法。
- `bluebook/risk/`：账号治理、风控、远程控制与误伤处置。
- `docs/`：持久化记忆与开发文档，不承载蓝皮书正文。

## 规范入口

- 规范主线入口是 `README.md + 00-08`
- `00-总览.md`、`00-蓝皮书总览.md`、`01-源码总地图.md` 作为兼容别名页保留，不再承担规范主线职责
- 目录治理说明见 [navigation/04-目录职责、规范入口与兼容别名页说明](navigation/04-%E7%9B%AE%E5%BD%95%E8%81%8C%E8%B4%A3%E3%80%81%E8%A7%84%E8%8C%83%E5%85%A5%E5%8F%A3%E4%B8%8E%E5%85%BC%E5%AE%B9%E5%88%AB%E5%90%8D%E9%A1%B5%E8%AF%B4%E6%98%8E.md)

## 主线阅读

1. [00-导读](00-%E5%AF%BC%E8%AF%BB.md)
2. [01-源码结构地图](01-%E6%BA%90%E7%A0%81%E7%BB%93%E6%9E%84%E5%9C%B0%E5%9B%BE.md)
3. [02-使用指南](02-%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.md)
4. [03-设计哲学](03-%E8%AE%BE%E8%AE%A1%E5%93%B2%E5%AD%A6.md)
5. [04-公开能力与隐藏能力](04-%E5%85%AC%E5%BC%80%E8%83%BD%E5%8A%9B%E4%B8%8E%E9%9A%90%E8%97%8F%E8%83%BD%E5%8A%9B.md)
6. [05-功能全景与 API 支持](05-%E5%8A%9F%E8%83%BD%E5%85%A8%E6%99%AF%E4%B8%8EAPI%E6%94%AF%E6%8C%81.md)
7. [06-第一性原理与苏格拉底反思](06-%E7%AC%AC%E4%B8%80%E6%80%A7%E5%8E%9F%E7%90%86%E4%B8%8E%E8%8B%8F%E6%A0%BC%E6%8B%89%E5%BA%95%E5%8F%8D%E6%80%9D.md)
8. [07-运行时契约、知识层与生态边界](07-%E8%BF%90%E8%A1%8C%E6%97%B6%E5%A5%91%E7%BA%A6%E3%80%81%E7%9F%A5%E8%AF%86%E5%B1%82%E4%B8%8E%E7%94%9F%E6%80%81%E8%BE%B9%E7%95%8C.md)
9. [08-能力全集、公开度与成熟度矩阵](08-%E8%83%BD%E5%8A%9B%E5%85%A8%E9%9B%86%E3%80%81%E5%85%AC%E5%BC%80%E5%BA%A6%E4%B8%8E%E6%88%90%E7%86%9F%E5%BA%A6%E7%9F%A9%E9%98%B5.md)

## 按角色阅读

### 1. 想先建立整体判断

- 先读 `00 -> 01 -> 03 -> 06 -> 07 -> 08`
- 目标：先看清 Claude Code 的设计单位是 runtime plane，而不是功能清单

### 2. 想高效使用 Claude Code

- 先读 [02-使用指南](02-%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.md)
- 再读 [guides/01-使用指南](guides/01-%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.md)
- 多 Agent 与 prompt 编排继续读 [guides/02-多Agent编排与Prompt模板](guides/02-%E5%A4%9AAgent%E7%BC%96%E6%8E%92%E4%B8%8EPrompt%E6%A8%A1%E6%9D%BF.md)
- 知识层与 `CLAUDE.md` 实践继续读 [guides/03-CLAUDE.md、记忆层与上下文注入实践](guides/03-CLAUDE.md%E3%80%81%E8%AE%B0%E5%BF%86%E5%B1%82%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E6%B3%A8%E5%85%A5%E5%AE%9E%E8%B7%B5.md)
- 想把复杂任务压缩成稳定方法，再读 [guides/06-第一性原理实践：目标、预算、对象、边界与回写](guides/06-%E7%AC%AC%E4%B8%80%E6%80%A7%E5%8E%9F%E7%90%86%E5%AE%9E%E8%B7%B5%EF%BC%9A%E7%9B%AE%E6%A0%87%E3%80%81%E9%A2%84%E7%AE%97%E3%80%81%E5%AF%B9%E8%B1%A1%E3%80%81%E8%BE%B9%E7%95%8C%E4%B8%8E%E5%9B%9E%E5%86%99.md)
- 想先观测预算再调 prompt / tools / memory，再读 [guides/07-用Context Usage与状态回写调优Prompt和预算](guides/07-%E7%94%A8Context%20Usage%E4%B8%8E%E7%8A%B6%E6%80%81%E5%9B%9E%E5%86%99%E8%B0%83%E4%BC%98Prompt%E5%92%8C%E9%A2%84%E7%AE%97.md)
- 想知道什么时候该继续当前 session、什么时候该升级成 task / worktree / compact，再读 [guides/08-如何根据预算、阻塞与风险选择session、task、worktree与compact](guides/08-%E5%A6%82%E4%BD%95%E6%A0%B9%E6%8D%AE%E9%A2%84%E7%AE%97%E3%80%81%E9%98%BB%E5%A1%9E%E4%B8%8E%E9%A3%8E%E9%99%A9%E9%80%89%E6%8B%A9session%E3%80%81task%E3%80%81worktree%E4%B8%8Ecompact.md)

### 3. 想接入宿主、SDK 或控制协议

- 先读 [05-功能全景与 API 支持](05-%E5%8A%9F%E8%83%BD%E5%85%A8%E6%99%AF%E4%B8%8EAPI%E6%94%AF%E6%8C%81.md)
- 再读 [08-能力全集、公开度与成熟度矩阵](08-%E8%83%BD%E5%8A%9B%E5%85%A8%E9%9B%86%E3%80%81%E5%85%AC%E5%BC%80%E5%BA%A6%E4%B8%8E%E6%88%90%E7%86%9F%E5%BA%A6%E7%9F%A9%E9%98%B5.md)
- 再读 [api/README](api/README.md)
- 先用 [api/30-源码目录级能力地图：commands、tools、services、状态与宿主平面](api/30-%E6%BA%90%E7%A0%81%E7%9B%AE%E5%BD%95%E7%BA%A7%E8%83%BD%E5%8A%9B%E5%9C%B0%E5%9B%BE%EF%BC%9Acommands%E3%80%81tools%E3%80%81services%E3%80%81%E7%8A%B6%E6%80%81%E4%B8%8E%E5%AE%BF%E4%B8%BB%E5%B9%B3%E9%9D%A2.md) 校准能力地形
- 最后顺着 `13 -> 14 -> 15 -> 16 -> 17 -> 20 -> 26 -> 28 -> 31` 读宿主闭环、治理型 API 与失败修复语义

### 4. 想研究 prompt、知识、记忆与上下文经济

- 先读 `06 -> 07`
- 再读 `api/18 -> api/21 -> architecture/18 -> architecture/28 -> architecture/29 -> architecture/31 -> architecture/36`
- 哲学收束看 `philosophy/14 -> philosophy/18 -> philosophy/19 -> philosophy/21 -> philosophy/22`

### 5. 想研究安全、风控与治理

- 产品内安全先读 `architecture/05 -> architecture/11 -> architecture/19 -> architecture/32 -> architecture/37 -> architecture/50 -> architecture/51`
- 哲学收束看 `philosophy/03 -> philosophy/19 -> philosophy/22 -> philosophy/27 -> philosophy/31 -> philosophy/37 -> philosophy/38`
- 平台风控与账号治理读 [risk/README](risk/README.md)

### 6. 想研究源码结构与工程先进性

- 先读 `01 -> 03 -> 05`
- 再读 `api/30 -> api/34 -> architecture/20 -> architecture/21 -> architecture/22 -> architecture/24 -> architecture/25 -> architecture/33 -> architecture/38 -> architecture/40 -> architecture/41 -> architecture/44 -> architecture/47 -> architecture/52`
- 哲学收束看 `philosophy/15 -> philosophy/16 -> philosophy/17 -> philosophy/23 -> philosophy/24 -> philosophy/28 -> philosophy/29 -> philosophy/32 -> philosophy/34 -> philosophy/39`

## 按专题链速查

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
- 能力矩阵链：`08-能力全集、公开度与成熟度矩阵.md` -> `api/23-能力平面、公开度与宿主支持矩阵.md` -> `api/29-动态能力暴露、裁剪链与运行时可见性.md`
- API 全谱系链：`05-功能全景与API支持.md` -> `api/24-命令、工具、会话、宿主与协作API全谱系.md` -> `api/25-命令、工具、任务与团队能力全集手册.md`
- 治理 API 链：`api/26-SDK、Control、Session与Remote接入全景矩阵.md` -> `api/28-治理型API：Channels、Context Usage与Settings三重真相.md`
- 插件生命周期链：`api/27-插件协议全生命周期：Manifest、Marketplace、Options、MCPB与Reload.md` -> `architecture/27-能力迁移、Consumer Subset与产品边界.md`
- 提示词深挖链：`architecture/28-提示词契约分层、知识注入与缓存稳定性.md` -> `architecture/31-提示词合同、缓存稳定性与多Agent语法.md` -> `philosophy/21-Prompt魔力来自约束叠加与状态反馈.md`
- 安全预算链：`architecture/19-安全分层、策略收口与沙箱边界.md` -> `architecture/32-安全、权限、治理与Token预算统一图.md` -> `philosophy/22-安全、成本与体验必须共用预算器.md`
- 源码质量链：`architecture/20-源码质量、分层与工程先进性.md` -> `architecture/33-公开源码镜像的先进性、热点与技术债.md` -> `philosophy/23-源码质量不是卫生而是产品能力.md`
- 分层链：`architecture/20-源码质量、分层与工程先进性.md` -> `architecture/24-services层全景与utils-heavy设计.md`
- 恢复链：`architecture/09-会话存储记忆与回溯状态面.md` -> `architecture/25-会话持久化、TaskOutput与Sidechain恢复图.md` -> `api/20-宿主实现最小闭环与恢复案例手册.md`
- 前台链：`architecture/04-REPL与Ink交互架构.md` -> `architecture/26-REPL前台状态机、Sticky Prompt与消息动作.md` -> `philosophy/17-前台交互不是UI皮肤而是认知控制面.md`
- 迁移链：`philosophy/05-构建期开关、运行期开关与兼容层.md` -> `architecture/27-能力迁移、Consumer Subset与产品边界.md`
- 事件链：`api/04-SDK消息与事件字典.md` -> `api/11-SDKMessageSchema与事件流手册.md` -> `architecture/12-ClaudeAPI与流式工具执行.md` -> `philosophy/06-状态优先于对话.md`
- 连接链：`api/03-MCP与远程传输.md` -> `api/12-MCP配置与连接状态机.md` -> `architecture/03-扩展能力与远程架构.md` -> `philosophy/08-统一配置语言优于扩展孤岛.md`
- 策略链：`architecture/05-权限系统与安全状态机.md` -> `architecture/11-权限系统全链路与Auto Mode.md` -> `philosophy/03-安全观与边界设计.md`
- 风控链：`risk/00-研究方法与可信边界.md` -> `risk/01-风控总论：封禁不是单点开关.md` -> `risk/02-身份、订阅、组织与策略限制.md` -> `risk/03-遥测、GrowthBook 与远程下发控制.md` -> `risk/04-本地执行面：权限、Auto Mode、Sandbox 与阻断.md` -> `risk/05-Remote Control、Trusted Device 与高安全会话.md` -> `risk/06-失效模式、封禁表现与合规使用边界.md` -> `risk/07-合规降低误判、保护权益与高风险地区用户建议.md` -> `risk/08-风控检测技术的先进性、原理与源码启示.md` -> `risk/09-第一性原理与苏格拉底式反思.md` -> `risk/10-错误语义、能力撤回与治理层矩阵.md` -> `risk/11-治理闭环时序：观测、判定、下发、阻断与恢复.md` -> `risk/12-Selective Fail-Open  Fail-Closed 的设计哲学.md` -> `risk/13-误伤处置、支持路径与证据保全决策树.md` -> `risk/14-图解：Remote Control、能力门槛与误伤处置流程.md` -> `risk/15-平台正义、误伤、公平性与可解释性.md` -> `risk/16-图解：Bridge、Trusted Device 与 401 Recovery 精细时序.md` -> `risk/17-速查卡：错误语义、用户动作与支持路径.md` -> `risk/18-可迁移设计法则：给 Agent 平台构建者的启示.md` -> `risk/19-单页总纲：从主体到处置的风控研究地图.md` -> `risk/20-高波动网络环境、中国用户与连续性破坏机制.md` -> `risk/21-给平台方的改进清单：诊断、解释层与恢复路径.md` -> `risk/22-源码模块地图：风控相关代码入口与职责分层.md` -> `risk/23-案例推演：五类“像被封了”的典型路径.md` -> `risk/24-信号融合、连续性断裂与“像被封了”的生成机制.md` -> `risk/25-问题导向索引：按症状、源码入口与合规动作阅读风控专题.md` -> `risk/26-苏格拉底附录：如果要把误伤再降一半，系统该追问什么.md` -> `risk/27-判定非对称性矩阵：哪些路径要快放行，哪些路径必须硬收口.md`
- 风控增量链：`risk/28-连续性自检、故障窗口纪律与证据包：高波动环境用户的合规自保手册.md` -> `risk/29-控制平面先进性：从信号、判定、恢复到解释的技术设计图谱.md` -> `risk/30-会前体检与最短恢复路径：把误伤前移成可解释的预检系统.md` -> `risk/31-语义压缩税：为什么不同限制最后都像“被封了”.md` -> `risk/32-多真相源冲突：本地缓存、服务端画像与会话状态如何共同决定你是谁.md` -> `risk/33-证明责任转移：平台、用户与支持体系谁在为可证明性买单.md` -> `risk/34-错误族谱与最短支持路径：从提示语到正确求助对象.md` -> `risk/35-可证明性产品化：把 auth status、预检与证据包收敛成同一张用户仪表盘.md` -> `risk/36-恢复预算与拒绝层级：重试、冷却、缓存与终止的四层状态机.md` -> `risk/37-治理时钟：5分钟、10分钟、15分钟与30秒背后的时间边界.md` -> `risk/38-组织管理员视角：策略下发、误伤协同与三方责任分配.md` -> `risk/39-三条证明链：主体链、资格链与会话链为何必须同时成立.md` -> `risk/40-共享词汇表：用户、管理员与支持团队如何减少语义错配.md` -> `risk/41-连续性成本最小化：把合规自保从故障窗口扩展到日常操作纪律.md` -> `risk/42-风控最小公理与反公理：从第一性原理重写控制面哲学.md` -> `risk/43-支持联动附录：按症状、证明链、归属方与证据面快速分流.md` -> `risk/44-仓库不是可信主体：从权限优先级到托管收口的信任边界.md` -> `risk/45-认证连续性工程：缓存、锁、密钥链与为什么不要乱换登录路径.md` -> `risk/46-冻结语义与单链恢复：为什么故障窗口越乱试越像被封了.md` -> `risk/47-高波动环境用户的合规权益保护：如何降低误伤并缩短自证路径.md` -> `risk/48-身份路径绑定：配置根、托管环境与组织闭锁为什么必须一致.md` -> `risk/49-检测先进性再评估：风控不是规则堆积，而是观测驱动的分布式控制平面.md` -> `risk/50-损失函数视角：平台究竟在最小化什么，而用户又在失去什么.md` -> `risk/51-批准链分析：谁有资格替用户说“可以”，以及这本身为何是风控问题.md` -> `risk/52-局部撤权优于全局封号：能力撤回、连接降级与主体保全的治理哲学.md` -> `risk/53-高波动环境严格运行SOP：从日常纪律到升级求助的四阶段手册.md` -> `risk/54-如果要把误伤再降一半：平台必须把哪些现有能力前置成产品.md` -> `risk/55-后期研究索引：41-54的二级导航、问题入口与最短阅读链.md` -> `risk/56-反规避原则：为什么任何绕过思路都会回到更高风险与更高证明负担.md` -> `risk/57-终局总指南：Claude Code风控研究的最佳最全合规版.md` -> `risk/58-治理主权与恢复主动权：谁能关、谁能开、谁能替你说 yes.md` -> `risk/59-资产保全与退出策略：账号风控窗口里真正该保护的不是面子而是工作连续性.md` -> `risk/60-结构化求助模板库：用户、管理员与平台支持的最短高质量文本.md` -> `risk/61-中国用户使用生态与认识论边界：官方路径、中转站与幕后叙事该如何判断.md`
- 会话链：`architecture/09-会话存储记忆与回溯状态面.md` -> `api/09-会话与状态API手册.md` -> `philosophy/06-状态优先于对话.md`
- workflow 链：`architecture/30 -> architecture/34 -> philosophy/25`
- 目录拓扑链：`05 -> api/24 -> api/29 -> api/30 -> architecture/38 -> philosophy/24`
- 失败语义链：`api/31 -> architecture/40 -> philosophy/29`
- 预算观测链：`api/32 -> architecture/37 -> architecture/43 -> philosophy/31`
- 单一真相入口链：`api/34 -> architecture/44 -> philosophy/32`
- 对象升级链：`06 -> architecture/30 -> architecture/45 -> guides/08 -> philosophy/25`
- 远程失败链：`api/33 -> architecture/16 -> architecture/48 -> philosophy/11 -> philosophy/35`
- 插件真相链：`api/27 -> api/34 -> architecture/49 -> philosophy/20 -> philosophy/36`
- 边界编译链：`architecture/19 -> architecture/50 -> architecture/51 -> philosophy/37 -> philosophy/38`
- Prompt 稳定链：`architecture/31 -> architecture/46 -> architecture/53 -> philosophy/33 -> philosophy/39 -> philosophy/40`
- 前后台 transcript 链：`architecture/35 -> architecture/54 -> philosophy/26 -> philosophy/41`

## 按第一性原理阅读

- 观察：`05` -> `api/08` -> `architecture/12`
- 决策：`03` -> `architecture/02` -> `architecture/22`
- 行动：`architecture/05` -> `architecture/11` -> `architecture/19`
- 记忆：`architecture/09` -> `api/09` -> `architecture/29`
- 协作：`architecture/10` -> `architecture/30` -> `architecture/34` -> `guides/02`
- 宿主：`api/13` -> `architecture/13` -> `philosophy/09`
- 恢复：`architecture/06` -> `architecture/16` -> `architecture/25`
- 预算：`architecture/21` -> `architecture/32` -> `architecture/37` -> `architecture/50` -> `philosophy/22` -> `philosophy/37` -> `philosophy/38`
- 治理：`04` -> `api/28` -> `guides/04` -> `guides/05` -> `architecture/50` -> `architecture/51` -> `philosophy/27` -> `philosophy/38` -> `risk/README`
- 目录拓扑：`05` -> `api/23` -> `api/29` -> `api/30`

## 按问题阅读

### 为什么 prompt 看起来有魔力

- `06 -> 07 -> api/18 -> architecture/18 -> architecture/28 -> architecture/31 -> architecture/36 -> architecture/39 -> architecture/42 -> architecture/46 -> architecture/53 -> philosophy/14 -> philosophy/18 -> philosophy/21 -> philosophy/30 -> philosophy/33 -> philosophy/38 -> philosophy/39 -> philosophy/40`

### 为什么它不像普通 IDE 插件

- `03 -> 05 -> architecture/13 -> architecture/14 -> philosophy/09 -> philosophy/16`

### 为什么多 Agent 没有写成“多开几个线程”

- `06 -> architecture/10 -> architecture/30 -> guides/02 -> philosophy/07`

### 为什么复杂任务不该继续写成多轮聊天

- `06 -> architecture/30 -> architecture/34 -> architecture/45 -> guides/06 -> guides/08 -> philosophy/25`

### 为什么安全和 token 经济要一起看

- `03 -> architecture/19 -> architecture/21 -> architecture/32 -> architecture/37 -> architecture/50 -> architecture/51 -> philosophy/03 -> philosophy/19 -> philosophy/22 -> philosophy/37 -> philosophy/38`

### 为什么安全不是事后检查而是输入边界控制平面

- `03 -> architecture/19 -> architecture/23 -> architecture/50 -> architecture/51 -> philosophy/27 -> philosophy/38`

### 为什么 prompt 稳定性不是性能技巧而是运行时治理

- `06 -> architecture/31 -> architecture/39 -> architecture/46 -> architecture/50 -> philosophy/30 -> philosophy/33 -> philosophy/38 -> philosophy/39`

### 为什么 Claude Code 的 prompt 更像上下文准入编译器

- `07 -> architecture/28 -> architecture/39 -> architecture/46 -> architecture/53 -> philosophy/18 -> philosophy/30 -> philosophy/39 -> philosophy/40`

### 为什么 Claude Code 宁可接受轻微陈旧，也要换取系统级确定性

- `architecture/39 -> architecture/53 -> philosophy/33 -> philosophy/39 -> philosophy/40`

### 为什么模型看到的 transcript 不等于界面上看到的 transcript

- `architecture/53 -> architecture/54 -> philosophy/26 -> philosophy/30 -> philosophy/41`

### 为什么 Claude Code 偏爱渐进暴露，而不是全量声明

- `architecture/51 -> architecture/53 -> philosophy/38 -> philosophy/41`

### 为什么宿主接入不能只看 `query(prompt)`

- `05 -> api/30 -> api/02 -> api/13 -> api/15 -> api/16 -> api/20 -> api/31`

### 为什么有代码不等于有公共承诺

- `04 -> 08 -> architecture/27 -> philosophy/05 -> philosophy/20`

### 为什么目录结构本身也在暴露能力拓扑

- `05 -> api/24 -> api/29 -> api/30 -> architecture/24 -> architecture/38`

### 为什么高级工程不在功能数量，而在不变量治理

- `01 -> api/30 -> architecture/20 -> architecture/40 -> architecture/41 -> architecture/47 -> architecture/52 -> philosophy/23 -> philosophy/29 -> philosophy/39`

### 想按深度专题而不是按目录来读

- 先读 [navigation/03-深度专题导航：Prompt、预算、对象、底盘与治理](navigation/03-%E6%B7%B1%E5%BA%A6%E4%B8%93%E9%A2%98%E5%AF%BC%E8%88%AA%EF%BC%9APrompt%E3%80%81%E9%A2%84%E7%AE%97%E3%80%81%E5%AF%B9%E8%B1%A1%E3%80%81%E5%BA%95%E7%9B%98%E4%B8%8E%E6%B2%BB%E7%90%86.md)
- 需要先判断规范入口和兼容别名页时，读 [navigation/04-目录职责、规范入口与兼容别名页说明](navigation/04-%E7%9B%AE%E5%BD%95%E8%81%8C%E8%B4%A3%E3%80%81%E8%A7%84%E8%8C%83%E5%85%A5%E5%8F%A3%E4%B8%8E%E5%85%BC%E5%AE%B9%E5%88%AB%E5%90%8D%E9%A1%B5%E8%AF%B4%E6%98%8E.md)

### 为什么宿主不该猜，而系统必须显式失败与显式回写

- `architecture/13 -> architecture/17 -> architecture/40 -> philosophy/11 -> philosophy/29`

### 为什么调优上下文前必须先看预算结构

- `guides/07 -> api/32 -> architecture/43 -> philosophy/22 -> philosophy/31`

### 为什么远程失败不该写成“断线重连”

- `api/33 -> architecture/16 -> architecture/48 -> philosophy/11 -> philosophy/35`

### 为什么单一真相入口比多处半真相实现更可靠

- `api/34 -> architecture/41 -> architecture/44 -> philosophy/28 -> philosophy/32`

### 为什么插件系统不能只看一个 enabled 开关

- `api/27 -> api/34 -> architecture/49 -> philosophy/20 -> philosophy/36`

## 专题入口

- [导航专题](navigation/README.md)
- [架构专题](architecture/README.md)
- [API 手册](api/README.md)
- [哲学专题](philosophy/README.md)
- [使用专题](guides/README.md)
- [风险与治理专题](risk/README.md)
- [开发与持久化记忆](../docs/README.md)

## 近期新增的深挖入口

- [运行时契约、知识层与生态边界](07-%E8%BF%90%E8%A1%8C%E6%97%B6%E5%A5%91%E7%BA%A6%E3%80%81%E7%9F%A5%E8%AF%86%E5%B1%82%E4%B8%8E%E7%94%9F%E6%80%81%E8%BE%B9%E7%95%8C.md)
- [能力全集、公开度与成熟度矩阵](08-%E8%83%BD%E5%8A%9B%E5%85%A8%E9%9B%86%E3%80%81%E5%85%AC%E5%BC%80%E5%BA%A6%E4%B8%8E%E6%88%90%E7%86%9F%E5%BA%A6%E7%9F%A9%E9%98%B5.md)
- [第一性原理阅读地图](navigation/01-%E7%AC%AC%E4%B8%80%E6%80%A7%E5%8E%9F%E7%90%86%E9%98%85%E8%AF%BB%E5%9C%B0%E5%9B%BE.md)
- [能力、API与治理检索图](navigation/02-%E8%83%BD%E5%8A%9B%E3%80%81API%E4%B8%8E%E6%B2%BB%E7%90%86%E6%A3%80%E7%B4%A2%E5%9B%BE.md)
- [目录职责、规范入口与兼容别名页说明](navigation/04-%E7%9B%AE%E5%BD%95%E8%81%8C%E8%B4%A3%E3%80%81%E8%A7%84%E8%8C%83%E5%85%A5%E5%8F%A3%E4%B8%8E%E5%85%BC%E5%AE%B9%E5%88%AB%E5%90%8D%E9%A1%B5%E8%AF%B4%E6%98%8E.md)
- [提示词控制、知识注入与记忆 API 手册](api/21-%E6%8F%90%E7%A4%BA%E8%AF%8D%E6%8E%A7%E5%88%B6%E3%80%81%E7%9F%A5%E8%AF%86%E6%B3%A8%E5%85%A5%E4%B8%8E%E8%AE%B0%E5%BF%86API%E6%89%8B%E5%86%8C.md)
- [插件、Marketplace、MCPB、LSP与Channels接入边界手册](api/22-%E6%8F%92%E4%BB%B6%E3%80%81Marketplace%E3%80%81MCPB%E3%80%81LSP%E4%B8%8EChannels%E6%8E%A5%E5%85%A5%E8%BE%B9%E7%95%8C%E6%89%8B%E5%86%8C.md)
- [能力平面、公开度与宿主支持矩阵](api/23-%E8%83%BD%E5%8A%9B%E5%B9%B3%E9%9D%A2%E3%80%81%E5%85%AC%E5%BC%80%E5%BA%A6%E4%B8%8E%E5%AE%BF%E4%B8%BB%E6%94%AF%E6%8C%81%E7%9F%A9%E9%98%B5.md)
- [命令、工具、会话、宿主与协作API全谱系](api/24-%E5%91%BD%E4%BB%A4%E3%80%81%E5%B7%A5%E5%85%B7%E3%80%81%E4%BC%9A%E8%AF%9D%E3%80%81%E5%AE%BF%E4%B8%BB%E4%B8%8E%E5%8D%8F%E4%BD%9CAPI%E5%85%A8%E8%B0%B1%E7%B3%BB.md)
- [命令、工具、任务与团队能力全集手册](api/25-%E5%91%BD%E4%BB%A4%E3%80%81%E5%B7%A5%E5%85%B7%E3%80%81%E4%BB%BB%E5%8A%A1%E4%B8%8E%E5%9B%A2%E9%98%9F%E8%83%BD%E5%8A%9B%E5%85%A8%E9%9B%86%E6%89%8B%E5%86%8C.md)
- [SDK、Control、Session与Remote接入全景矩阵](api/26-SDK%E3%80%81Control%E3%80%81Session%E4%B8%8ERemote%E6%8E%A5%E5%85%A5%E5%85%A8%E6%99%AF%E7%9F%A9%E9%98%B5.md)
- [插件协议全生命周期：Manifest、Marketplace、Options、MCPB与Reload](api/27-%E6%8F%92%E4%BB%B6%E5%8D%8F%E8%AE%AE%E5%85%A8%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F%EF%BC%9AManifest%E3%80%81Marketplace%E3%80%81Options%E3%80%81MCPB%E4%B8%8EReload.md)
- [治理型API：Channels、Context Usage与Settings三重真相](api/28-%E6%B2%BB%E7%90%86%E5%9E%8BAPI%EF%BC%9AChannels%E3%80%81Context%20Usage%E4%B8%8ESettings%E4%B8%89%E9%87%8D%E7%9C%9F%E7%9B%B8.md)
- [动态能力暴露、裁剪链与运行时可见性](api/29-%E5%8A%A8%E6%80%81%E8%83%BD%E5%8A%9B%E6%9A%B4%E9%9C%B2%E3%80%81%E8%A3%81%E5%89%AA%E9%93%BE%E4%B8%8E%E8%BF%90%E8%A1%8C%E6%97%B6%E5%8F%AF%E8%A7%81%E6%80%A7.md)
- [远程恢复、401与Close Code语义手册](api/33-%E8%BF%9C%E7%A8%8B%E6%81%A2%E5%A4%8D%E3%80%81401%E4%B8%8EClose%20Code%E8%AF%AD%E4%B9%89%E6%89%8B%E5%86%8C.md)
- [单一真相入口、权威状态面与Chokepoint手册](api/34-%E5%8D%95%E4%B8%80%E7%9C%9F%E7%9B%B8%E5%85%A5%E5%8F%A3%E3%80%81%E6%9D%83%E5%A8%81%E7%8A%B6%E6%80%81%E9%9D%A2%E4%B8%8EChokepoint%E6%89%8B%E5%86%8C.md)
- [提示词契约分层、知识注入与缓存稳定性](architecture/28-%E6%8F%90%E7%A4%BA%E8%AF%8D%E5%A5%91%E7%BA%A6%E5%88%86%E5%B1%82%E3%80%81%E7%9F%A5%E8%AF%86%E6%B3%A8%E5%85%A5%E4%B8%8E%E7%BC%93%E5%AD%98%E7%A8%B3%E5%AE%9A%E6%80%A7.md)
- [知识层栈：CLAUDE.md、Session Memory、Auto-memory与Attachments](architecture/29-%E7%9F%A5%E8%AF%86%E5%B1%82%E6%A0%88%EF%BC%9ACLAUDE.md%E3%80%81Session%20Memory%E3%80%81Auto-memory%E4%B8%8EAttachments.md)
- [多Agent任务对象、Mailbox与后台协作运行时](architecture/30-%E5%A4%9AAgent%E4%BB%BB%E5%8A%A1%E5%AF%B9%E8%B1%A1%E3%80%81Mailbox%E4%B8%8E%E5%90%8E%E5%8F%B0%E5%8D%8F%E4%BD%9C%E8%BF%90%E8%A1%8C%E6%97%B6.md)
- [提示词合同、缓存稳定性与多Agent语法](architecture/31-%E6%8F%90%E7%A4%BA%E8%AF%8D%E5%90%88%E5%90%8C%E3%80%81%E7%BC%93%E5%AD%98%E7%A8%B3%E5%AE%9A%E6%80%A7%E4%B8%8E%E5%A4%9AAgent%E8%AF%AD%E6%B3%95.md)
- [安全、权限、治理与Token预算统一图](architecture/32-%E5%AE%89%E5%85%A8%E3%80%81%E6%9D%83%E9%99%90%E3%80%81%E6%B2%BB%E7%90%86%E4%B8%8EToken%E9%A2%84%E7%AE%97%E7%BB%9F%E4%B8%80%E5%9B%BE.md)
- [公开源码镜像的先进性、热点与技术债](architecture/33-%E5%85%AC%E5%BC%80%E6%BA%90%E7%A0%81%E9%95%9C%E5%83%8F%E7%9A%84%E5%85%88%E8%BF%9B%E6%80%A7%E3%80%81%E7%83%AD%E7%82%B9%E4%B8%8E%E6%8A%80%E6%9C%AF%E5%80%BA.md)
- [单一真相入口：mode、tool pool、state与metadata的权威面](architecture/44-%E5%8D%95%E4%B8%80%E7%9C%9F%E7%9B%B8%E5%85%A5%E5%8F%A3%EF%BC%9Amode%E3%80%81tool%20pool%E3%80%81state%E4%B8%8Emetadata%E7%9A%84%E6%9D%83%E5%A8%81%E9%9D%A2.md)
- [对象升级而非继续对话：session、task、worktree与compact的选择机理](architecture/45-%E5%AF%B9%E8%B1%A1%E5%8D%87%E7%BA%A7%E8%80%8C%E9%9D%9E%E7%BB%A7%E7%BB%AD%E5%AF%B9%E8%AF%9D%EF%BC%9Asession%E3%80%81task%E3%80%81worktree%E4%B8%8Ecompact%E7%9A%84%E9%80%89%E6%8B%A9%E6%9C%BA%E7%90%86.md)
- [Prompt稳定性解释层：cache-break detection的两阶段诊断器](architecture/46-Prompt%E7%A8%B3%E5%AE%9A%E6%80%A7%E8%A7%A3%E9%87%8A%E5%B1%82%EF%BC%9Acache-break%20detection%E7%9A%84%E4%B8%A4%E9%98%B6%E6%AE%B5%E8%AF%8A%E6%96%AD%E5%99%A8.md)
- [QueryGuard：本地查询生命周期的authoritative state machine](architecture/47-QueryGuard%EF%BC%9A%E6%9C%AC%E5%9C%B0%E6%9F%A5%E8%AF%A2%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F%E7%9A%84authoritative%20state%20machine.md)
- [远程失败不是断线重连：401、Close Code与环境恢复的分层语义](architecture/48-%E8%BF%9C%E7%A8%8B%E5%A4%B1%E8%B4%A5%E4%B8%8D%E6%98%AF%E6%96%AD%E7%BA%BF%E9%87%8D%E8%BF%9E%EF%BC%9A401%E3%80%81Close%20Code%E4%B8%8E%E7%8E%AF%E5%A2%83%E6%81%A2%E5%A4%8D%E7%9A%84%E5%88%86%E5%B1%82%E8%AF%AD%E4%B9%89.md)
- [插件双真相：enabled、editable scope与policy block不能混写](architecture/49-%E6%8F%92%E4%BB%B6%E5%8F%8C%E7%9C%9F%E7%9B%B8%EF%BC%9Aenabled%E3%80%81editable%20scope%E4%B8%8Epolicy%20block%E4%B8%8D%E8%83%BD%E6%B7%B7%E5%86%99.md)
- [PolicySettings控制平面、Sandbox契约与三套预算器](architecture/50-PolicySettings%E6%8E%A7%E5%88%B6%E5%B9%B3%E9%9D%A2%E3%80%81Sandbox%E5%A5%91%E7%BA%A6%E4%B8%8E%E4%B8%89%E5%A5%97%E9%A2%84%E7%AE%97%E5%99%A8.md)
- [安全即输入边界控制平面：Managed Authority、Trusted Sources与Runtime Boundary Compilation](architecture/51-%E5%AE%89%E5%85%A8%E5%8D%B3%E8%BE%93%E5%85%A5%E8%BE%B9%E7%95%8C%E6%8E%A7%E5%88%B6%E5%B9%B3%E9%9D%A2%EF%BC%9AManaged%20Authority%E3%80%81Trusted%20Sources%E4%B8%8ERuntime%20Boundary%20Compilation.md)
- [Chokepoint、Typed Decision、Authoritative Surface、Race-Aware Runtime与Contract-First：Claude Code源码先进性五法](architecture/52-Chokepoint%E3%80%81Typed%20Decision%E3%80%81Authoritative%20Surface%E3%80%81Race-Aware%20Runtime%E4%B8%8EContract-First%EF%BC%9AClaude%20Code%E6%BA%90%E7%A0%81%E5%85%88%E8%BF%9B%E6%80%A7%E4%BA%94%E6%B3%95.md)
- [稳定前缀、动态尾部与旁路Fork：Claude Code的Cache-Aware Prompt Assembly](architecture/53-%E7%A8%B3%E5%AE%9A%E5%89%8D%E7%BC%80%E3%80%81%E5%8A%A8%E6%80%81%E5%B0%BE%E9%83%A8%E4%B8%8E%E6%97%81%E8%B7%AFFork%EF%BC%9AClaude%20Code%E7%9A%84Cache-Aware%20Prompt%20Assembly.md)
- [从UI Transcript到Protocol Transcript：Prompt不是聊天记录的直接重放](architecture/54-%E4%BB%8EUI%20Transcript%E5%88%B0Protocol%20Transcript%EF%BC%9APrompt%E4%B8%8D%E6%98%AF%E8%81%8A%E5%A4%A9%E8%AE%B0%E5%BD%95%E7%9A%84%E7%9B%B4%E6%8E%A5%E9%87%8D%E6%94%BE.md)
- [如何根据预算、阻塞与风险选择session、task、worktree与compact](guides/08-%E5%A6%82%E4%BD%95%E6%A0%B9%E6%8D%AE%E9%A2%84%E7%AE%97%E3%80%81%E9%98%BB%E5%A1%9E%E4%B8%8E%E9%A3%8E%E9%99%A9%E9%80%89%E6%8B%A9session%E3%80%81task%E3%80%81worktree%E4%B8%8Ecompact.md)
- [CLAUDE.md、记忆层与上下文注入实践](guides/03-CLAUDE.md%E3%80%81%E8%AE%B0%E5%BF%86%E5%B1%82%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E6%B3%A8%E5%85%A5%E5%AE%9E%E8%B7%B5.md)
- [Prompt 不是文本技巧而是契约分层](philosophy/18-Prompt%E4%B8%8D%E6%98%AF%E6%96%87%E6%9C%AC%E6%8A%80%E5%B7%A7%E8%80%8C%E6%98%AF%E5%A5%91%E7%BA%A6%E5%88%86%E5%B1%82.md)
- [安全与 Token 经济不是权衡而是同一优化](philosophy/19-%E5%AE%89%E5%85%A8%E4%B8%8EToken%E7%BB%8F%E6%B5%8E%E4%B8%8D%E6%98%AF%E6%9D%83%E8%A1%A1%E8%80%8C%E6%98%AF%E5%90%8C%E4%B8%80%E4%BC%98%E5%8C%96.md)
- [生态成熟度必须与协议支持分开叙述](philosophy/20-%E7%94%9F%E6%80%81%E6%88%90%E7%86%9F%E5%BA%A6%E5%BF%85%E9%A1%BB%E4%B8%8E%E5%8D%8F%E8%AE%AE%E6%94%AF%E6%8C%81%E5%88%86%E5%BC%80%E5%8F%99%E8%BF%B0.md)
- [Prompt魔力来自约束叠加与状态反馈](philosophy/21-Prompt%E9%AD%94%E5%8A%9B%E6%9D%A5%E8%87%AA%E7%BA%A6%E6%9D%9F%E5%8F%A0%E5%8A%A0%E4%B8%8E%E7%8A%B6%E6%80%81%E5%8F%8D%E9%A6%88.md)
- [安全、成本与体验必须共用预算器](philosophy/22-%E5%AE%89%E5%85%A8%E3%80%81%E6%88%90%E6%9C%AC%E4%B8%8E%E4%BD%93%E9%AA%8C%E5%BF%85%E9%A1%BB%E5%85%B1%E7%94%A8%E9%A2%84%E7%AE%97%E5%99%A8.md)
- [源码质量不是卫生而是产品能力](philosophy/23-%E6%BA%90%E7%A0%81%E8%B4%A8%E9%87%8F%E4%B8%8D%E6%98%AF%E5%8D%AB%E7%94%9F%E8%80%8C%E6%98%AF%E4%BA%A7%E5%93%81%E8%83%BD%E5%8A%9B.md)
- [单一真相入口优于多处半真相实现](philosophy/32-%E5%8D%95%E4%B8%80%E7%9C%9F%E7%9B%B8%E5%85%A5%E5%8F%A3%E4%BC%98%E4%BA%8E%E5%A4%9A%E5%A4%84%E5%8D%8A%E7%9C%9F%E7%9B%B8%E5%AE%9E%E7%8E%B0.md)
- [可解释稳定性比神秘秘诀更接近Prompt魔力](philosophy/33-%E5%8F%AF%E8%A7%A3%E9%87%8A%E7%A8%B3%E5%AE%9A%E6%80%A7%E6%AF%94%E7%A5%9E%E7%A7%98%E7%A7%98%E8%AF%80%E6%9B%B4%E6%8E%A5%E8%BF%91Prompt%E9%AD%94%E5%8A%9B.md)
- [控制平面先于加载表现](philosophy/34-%E6%8E%A7%E5%88%B6%E5%B9%B3%E9%9D%A2%E5%85%88%E4%BA%8E%E5%8A%A0%E8%BD%BD%E8%A1%A8%E7%8E%B0.md)
- [显式远程失败优于模糊在线状态](philosophy/35-%E6%98%BE%E5%BC%8F%E8%BF%9C%E7%A8%8B%E5%A4%B1%E8%B4%A5%E4%BC%98%E4%BA%8E%E6%A8%A1%E7%B3%8A%E5%9C%A8%E7%BA%BF%E7%8A%B6%E6%80%81.md)
- [安装状态、启用状态与策略状态必须分层叙述](philosophy/36-%E5%AE%89%E8%A3%85%E7%8A%B6%E6%80%81%E3%80%81%E5%90%AF%E7%94%A8%E7%8A%B6%E6%80%81%E4%B8%8E%E7%AD%96%E7%95%A5%E7%8A%B6%E6%80%81%E5%BF%85%E9%A1%BB%E5%88%86%E5%B1%82%E5%8F%99%E8%BF%B0.md)
- [统一第一性原理不等于单一预算实现](philosophy/37-%E7%BB%9F%E4%B8%80%E7%AC%AC%E4%B8%80%E6%80%A7%E5%8E%9F%E7%90%86%E4%B8%8D%E7%AD%89%E4%BA%8E%E5%8D%95%E4%B8%80%E9%A2%84%E7%AE%97%E5%AE%9E%E7%8E%B0.md)
- [安全、治理、Token与Prompt稳定性本质上是同一收口问题](philosophy/38-%E5%AE%89%E5%85%A8%E3%80%81%E6%B2%BB%E7%90%86%E3%80%81Token%E4%B8%8EPrompt%E7%A8%B3%E5%AE%9A%E6%80%A7%E6%9C%AC%E8%B4%A8%E4%B8%8A%E6%98%AF%E5%90%8C%E4%B8%80%E6%94%B6%E5%8F%A3%E9%97%AE%E9%A2%98.md)
- [治理必须落到字节级确定性：上下文准入优于功能堆叠](philosophy/39-%E6%B2%BB%E7%90%86%E5%BF%85%E9%A1%BB%E8%90%BD%E5%88%B0%E5%AD%97%E8%8A%82%E7%BA%A7%E7%A1%AE%E5%AE%9A%E6%80%A7%EF%BC%9A%E4%B8%8A%E4%B8%8B%E6%96%87%E5%87%86%E5%85%A5%E4%BC%98%E4%BA%8E%E5%8A%9F%E8%83%BD%E5%A0%86%E5%8F%A0.md)
- [允许轻微陈旧，换取系统级确定性](philosophy/40-%E5%85%81%E8%AE%B8%E8%BD%BB%E5%BE%AE%E9%99%88%E6%97%A7%EF%BC%8C%E6%8D%A2%E5%8F%96%E7%B3%BB%E7%BB%9F%E7%BA%A7%E7%A1%AE%E5%AE%9A%E6%80%A7.md)
- [渐进暴露优于全量声明：先限制模型可见世界，再要求模型聪明](philosophy/41-%E6%B8%90%E8%BF%9B%E6%9A%B4%E9%9C%B2%E4%BC%98%E4%BA%8E%E5%85%A8%E9%87%8F%E5%A3%B0%E6%98%8E%EF%BC%9A%E5%85%88%E9%99%90%E5%88%B6%E6%A8%A1%E5%9E%8B%E5%8F%AF%E8%A7%81%E4%B8%96%E7%95%8C%EF%BC%8C%E5%86%8D%E8%A6%81%E6%B1%82%E6%A8%A1%E5%9E%8B%E8%81%AA%E6%98%8E.md)
- [信号融合、连续性断裂与“像被封了”的生成机制](risk/24-%E4%BF%A1%E5%8F%B7%E8%9E%8D%E5%90%88%E3%80%81%E8%BF%9E%E7%BB%AD%E6%80%A7%E6%96%AD%E8%A3%82%E4%B8%8E%E2%80%9C%E5%83%8F%E8%A2%AB%E5%B0%81%E4%BA%86%E7%9A%84%E7%94%9F%E6%88%90%E6%9C%BA%E5%88%B6.md)
- [问题导向索引：按症状、源码入口与合规动作阅读风控专题](risk/25-%E9%97%AE%E9%A2%98%E5%AF%BC%E5%90%91%E7%B4%A2%E5%BC%95%EF%BC%9A%E6%8C%89%E7%97%87%E7%8A%B6%E3%80%81%E6%BA%90%E7%A0%81%E5%85%A5%E5%8F%A3%E4%B8%8E%E5%90%88%E8%A7%84%E5%8A%A8%E4%BD%9C%E9%98%85%E8%AF%BB%E9%A3%8E%E6%8E%A7%E4%B8%93%E9%A2%98.md)
- [苏格拉底附录：如果要把误伤再降一半，系统该追问什么](risk/26-%E8%8B%8F%E6%A0%BC%E6%8B%89%E5%BA%95%E9%99%84%E5%BD%95%EF%BC%9A%E5%A6%82%E6%9E%9C%E8%A6%81%E6%8A%8A%E8%AF%AF%E4%BC%A4%E5%86%8D%E9%99%8D%E4%B8%80%E5%8D%8A%EF%BC%8C%E7%B3%BB%E7%BB%9F%E8%AF%A5%E8%BF%BD%E9%97%AE%E4%BB%80%E4%B9%88.md)
- [判定非对称性矩阵：哪些路径要快放行，哪些路径必须硬收口](risk/27-%E5%88%A4%E5%AE%9A%E9%9D%9E%E5%AF%B9%E7%A7%B0%E6%80%A7%E7%9F%A9%E9%98%B5%EF%BC%9A%E5%93%AA%E4%BA%9B%E8%B7%AF%E5%BE%84%E8%A6%81%E5%BF%AB%E6%94%BE%E8%A1%8C%EF%BC%8C%E5%93%AA%E4%BA%9B%E8%B7%AF%E5%BE%84%E5%BF%85%E9%A1%BB%E7%A1%AC%E6%94%B6%E5%8F%A3.md)
- [连续性自检、故障窗口纪律与证据包：高波动环境用户的合规自保手册](risk/28-%E8%BF%9E%E7%BB%AD%E6%80%A7%E8%87%AA%E6%A3%80%E3%80%81%E6%95%85%E9%9A%9C%E7%AA%97%E5%8F%A3%E7%BA%AA%E5%BE%8B%E4%B8%8E%E8%AF%81%E6%8D%AE%E5%8C%85%EF%BC%9A%E9%AB%98%E6%B3%A2%E5%8A%A8%E7%8E%AF%E5%A2%83%E7%94%A8%E6%88%B7%E7%9A%84%E5%90%88%E8%A7%84%E8%87%AA%E4%BF%9D%E6%89%8B%E5%86%8C.md)
- [控制平面先进性：从信号、判定、恢复到解释的技术设计图谱](risk/29-%E6%8E%A7%E5%88%B6%E5%B9%B3%E9%9D%A2%E5%85%88%E8%BF%9B%E6%80%A7%EF%BC%9A%E4%BB%8E%E4%BF%A1%E5%8F%B7%E3%80%81%E5%88%A4%E5%AE%9A%E3%80%81%E6%81%A2%E5%A4%8D%E5%88%B0%E8%A7%A3%E9%87%8A%E7%9A%84%E6%8A%80%E6%9C%AF%E8%AE%BE%E8%AE%A1%E5%9B%BE%E8%B0%B1.md)
