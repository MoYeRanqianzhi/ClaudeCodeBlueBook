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

## 按目标阅读

- 想先建立整体判断：顺读 `bluebook/` 主线。
- 想查具体机制：看 `architecture/`。
- 想查接口、字段和协议：看 `api/`。
- 想研究风控、账号治理与封号技术：看 `risk/`。
- 想研究权限、沙箱、密钥、受管环境与外部能力收口：看 `security/`。
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
- 事件链：`api/04-SDK消息与事件字典.md` -> `api/11-SDKMessageSchema与事件流手册.md` -> `architecture/12-ClaudeAPI与流式工具执行.md` -> `philosophy/06-状态优先于对话.md`
- 连接链：`api/03-MCP与远程传输.md` -> `api/12-MCP配置与连接状态机.md` -> `architecture/03-扩展能力与远程架构.md` -> `philosophy/08-统一配置语言优于扩展孤岛.md`
- 策略链：`architecture/05-权限系统与安全状态机.md` -> `architecture/11-权限系统全链路与Auto Mode.md` -> `philosophy/03-安全观与边界设计.md`
- 安全链：`security/00-研究方法与可信边界.md` -> `security/01-安全总论：Claude Code 不是单点沙箱，而是分层安全控制面.md` -> `security/02-权限、沙箱与最小授权：真正危险的不是工具强，而是工具绕过仲裁.md` -> `security/03-认证、密钥与受管环境：安全边界首先要防的是运行时被配置污染.md` -> `security/04-MCP、WebFetch、hooks 与外部能力收口：外部世界不是默认可信上下文.md` -> `security/05-安全设计哲学与技术先进性：它不是把能力做小，而是把边界做实.md` -> `security/06-第一性原理与苏格拉底式反思：如果要把这套安全性再提高一倍，还缺什么.md` -> `security/07-权限状态机与安全仲裁时序：从 mode 切换到 ask、allow、deny 的真实顺序.md` -> `security/08-配置来源优先级矩阵与受管环境主权：谁有资格定义运行时.md` -> `security/09-外部入口风险分级矩阵：MCP、WebFetch、hooks、gateway 分别在打开哪一种攻击面.md` -> `security/10-安全状态面与可解释性产品化：系统已经有零件，但还缺一张统一仪表盘.md` -> `security/11-给 Agent 平台构建者的可迁移安全设计法则：把来源、仲裁、主权与解释做成同一套控制面.md` -> `security/12-如果要把 Claude Code 的安全产品化再推进一代：平台方最该做成产品的十二项改进.md` -> `security/13-安全专题二级索引：按问题、攻击面、主权冲突与产品改进快速阅读.md` -> `security/14-安全控制面总图：从 trust 到 entitlement 的全链结构图谱.md` -> `security/15-来源主权总表：settings、permissions、hooks、MCP、plugins、sandbox、gateway 到底谁能覆盖谁.md` -> `security/16-安全反模式与反公理：哪些看似方便的做法会掏空这套边界.md` -> `security/17-终局总指南：Claude Code 安全研究的最佳最全版.md` -> `security/18-安全检测技术内核：从危险模式识别到来源主权收口.md` -> `security/19-安全不变量：哪些约束绝不能被模式切换、快路径和来源合并打破.md` -> `security/20-边界失真理论：为什么 Claude Code 检测的不是坏动作而是结构失真.md` -> `security/21-安全状态面源码解剖：为什么系统已有很多零件，却还没有一张统一安全控制台.md` -> `security/22-安全证明链：主体、主权、授权、包络、外部能力与增量审批为何必须同时成立.md` -> `security/23-统一安全控制台字段设计：源码里已经有哪些状态字段，还缺哪些跨面字段.md` -> `security/24-统一安全控制台卡片设计：如何把字段、证明链与最短动作做成真正可用的界面.md` -> `security/25-统一安全控制台最短诊断路径：如何把状态、证明断点、控制动作与回读验证闭成一条链.md` -> `security/26-统一安全控制台交互状态机：页面切换、动作触发、回读刷新与宿主适配为什么必须统一设计.md` -> `security/27-安全对象协议：为什么统一安全控制台必须先有宿主保真契约，再谈页面设计.md` -> `security/28-显式降级理论：为什么窄宿主不是问题，隐性子集才是安全问题.md` -> `security/29-宿主资格等级：观察宿主、控制宿主、证明宿主为何必须分层定义.md` -> `security/30-安全真相源层级：为什么 worker_status、external_metadata、AppState 与界面文案不能互相替代.md` -> `security/31-安全真相仲裁：当实时事件、复制状态、本地状态与界面摘要冲突时谁说了算.md` -> `security/32-安全裂脑防御：为什么单一更新闸门、镜像纪律、去重与清理优于事后解释.md` -> `security/33-安全单写者原则：为什么关键安全事实必须有唯一作者，其他层只能镜像.md` -> `security/34-安全提交语义：关键安全事实何时算已提交，何时只是排队、可见或可恢复.md` -> `security/35-安全多账本原则：为什么语义、复制、可见与恢复不能共用同一本账.md`
- 风控链：`risk/00-研究方法与可信边界.md` -> `risk/01-风控总论：封禁不是单点开关.md` -> `risk/02-身份、订阅、组织与策略限制.md` -> `risk/03-遥测、GrowthBook 与远程下发控制.md` -> `risk/04-本地执行面：权限、Auto Mode、Sandbox 与阻断.md` -> `risk/05-Remote Control、Trusted Device 与高安全会话.md` -> `risk/06-失效模式、封禁表现与合规使用边界.md` -> `risk/07-合规降低误判、保护权益与高风险地区用户建议.md` -> `risk/08-风控检测技术的先进性、原理与源码启示.md` -> `risk/09-第一性原理与苏格拉底式反思.md` -> `risk/10-错误语义、能力撤回与治理层矩阵.md` -> `risk/11-治理闭环时序：观测、判定、下发、阻断与恢复.md` -> `risk/12-Selective Fail-Open  Fail-Closed 的设计哲学.md` -> `risk/13-误伤处置、支持路径与证据保全决策树.md` -> `risk/14-图解：Remote Control、能力门槛与误伤处置流程.md` -> `risk/15-平台正义、误伤、公平性与可解释性.md` -> `risk/16-图解：Bridge、Trusted Device 与 401 Recovery 精细时序.md` -> `risk/17-速查卡：错误语义、用户动作与支持路径.md` -> `risk/18-可迁移设计法则：给 Agent 平台构建者的启示.md` -> `risk/19-单页总纲：从主体到处置的风控研究地图.md` -> `risk/20-高波动网络环境、中国用户与连续性破坏机制.md` -> `risk/21-给平台方的改进清单：诊断、解释层与恢复路径.md` -> `risk/22-源码模块地图：风控相关代码入口与职责分层.md` -> `risk/23-案例推演：五类“像被封了”的典型路径.md` -> `risk/24-信号融合、连续性断裂与“像被封了”的生成机制.md` -> `risk/25-问题导向索引：按症状、源码入口与合规动作阅读风控专题.md` -> `risk/26-苏格拉底附录：如果要把误伤再降一半，系统该追问什么.md` -> `risk/27-判定非对称性矩阵：哪些路径要快放行，哪些路径必须硬收口.md`
- 风控增量链：`risk/28-连续性自检、故障窗口纪律与证据包：高波动环境用户的合规自保手册.md` -> `risk/29-控制平面先进性：从信号、判定、恢复到解释的技术设计图谱.md` -> `risk/30-会前体检与最短恢复路径：把误伤前移成可解释的预检系统.md` -> `risk/31-语义压缩税：为什么不同限制最后都像“被封了”.md` -> `risk/32-多真相源冲突：本地缓存、服务端画像与会话状态如何共同决定你是谁.md` -> `risk/33-证明责任转移：平台、用户与支持体系谁在为可证明性买单.md` -> `risk/34-错误族谱与最短支持路径：从提示语到正确求助对象.md` -> `risk/35-可证明性产品化：把 auth status、预检与证据包收敛成同一张用户仪表盘.md` -> `risk/36-恢复预算与拒绝层级：重试、冷却、缓存与终止的四层状态机.md` -> `risk/37-治理时钟：5分钟、10分钟、15分钟与30秒背后的时间边界.md` -> `risk/38-组织管理员视角：策略下发、误伤协同与三方责任分配.md` -> `risk/39-三条证明链：主体链、资格链与会话链为何必须同时成立.md` -> `risk/40-共享词汇表：用户、管理员与支持团队如何减少语义错配.md` -> `risk/41-连续性成本最小化：把合规自保从故障窗口扩展到日常操作纪律.md` -> `risk/42-风控最小公理与反公理：从第一性原理重写控制面哲学.md` -> `risk/43-支持联动附录：按症状、证明链、归属方与证据面快速分流.md` -> `risk/44-仓库不是可信主体：从权限优先级到托管收口的信任边界.md` -> `risk/45-认证连续性工程：缓存、锁、密钥链与为什么不要乱换登录路径.md` -> `risk/46-冻结语义与单链恢复：为什么故障窗口越乱试越像被封了.md` -> `risk/47-高波动环境用户的合规权益保护：如何降低误伤并缩短自证路径.md` -> `risk/48-身份路径绑定：配置根、托管环境与组织闭锁为什么必须一致.md` -> `risk/49-检测先进性再评估：风控不是规则堆积，而是观测驱动的分布式控制平面.md` -> `risk/50-损失函数视角：平台究竟在最小化什么，而用户又在失去什么.md` -> `risk/51-批准链分析：谁有资格替用户说“可以”，以及这本身为何是风控问题.md` -> `risk/52-局部撤权优于全局封号：能力撤回、连接降级与主体保全的治理哲学.md` -> `risk/53-高波动环境严格运行SOP：从日常纪律到升级求助的四阶段手册.md` -> `risk/54-如果要把误伤再降一半：平台必须把哪些现有能力前置成产品.md` -> `risk/55-后期研究索引：41-54的二级导航、问题入口与最短阅读链.md` -> `risk/56-反规避原则：为什么任何绕过思路都会回到更高风险与更高证明负担.md` -> `risk/57-终局总指南：Claude Code风控研究的最佳最全合规版.md` -> `risk/58-治理主权与恢复主动权：谁能关、谁能开、谁能替你说 yes.md` -> `risk/59-资产保全与退出策略：账号风控窗口里真正该保护的不是面子而是工作连续性.md` -> `risk/60-结构化求助模板库：用户、管理员与平台支持的最短高质量文本.md` -> `risk/61-中国用户使用生态与认识论边界：官方路径、中转站与幕后叙事该如何判断.md` -> `risk/62-中国用户利益保护与中转站退出策略：把接入便利转化为可控退出权.md` -> `risk/63-中国用户为什么在买入口而不是买模型：Claude Code 的地区摩擦、兼容层补贴与工作流争夺.md` -> `risk/64-官方路径、云厂商路径与兼容入口的能力语义差清单：哪些只是能跑，哪些更接近等价.md`
- 会话链：`architecture/09-会话存储记忆与回溯状态面.md` -> `api/09-会话与状态API手册.md` -> `philosophy/06-状态优先于对话.md`
- 协作链：`architecture/10-AgentTool与隔离编排.md` -> `philosophy/07-隔离优先于并发.md` -> `06-第一性原理与苏格拉底反思.md`

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
- 恢复：`architecture/06-上下文压缩与恢复链.md`、`architecture/12-ClaudeAPI与流式工具执行.md`、`philosophy/06-状态优先于对话.md`

## 正式主线与兼容入口

- 正式主线以 `bluebook/00-导读.md` 到 `bluebook/06-第一性原理与苏格拉底反思.md` 为准。
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
- `security/`: 安全边界、权限仲裁、来源主权与外部入口收口专题
- `philosophy/`: 哲学、产品演化与第一性原理解读
- `../docs/`: 持久化记忆、研究过程、日志与迭代准则

## 专题索引

- [架构专题](architecture/README.md)
- [API 专题](api/README.md)
- [使用专题](guides/README.md)
- [风控专题](risk/README.md)
- [安全专题](security/README.md)
- [哲学专题](philosophy/README.md)

近期新增的深挖入口：

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
- [信号融合、连续性断裂与“像被封了”的生成机制](risk/24-%E4%BF%A1%E5%8F%B7%E8%9E%8D%E5%90%88%E3%80%81%E8%BF%9E%E7%BB%AD%E6%80%A7%E6%96%AD%E8%A3%82%E4%B8%8E%E2%80%9C%E5%83%8F%E8%A2%AB%E5%B0%81%E4%BA%86%E7%9A%84%E7%94%9F%E6%88%90%E6%9C%BA%E5%88%B6.md)
- [问题导向索引：按症状、源码入口与合规动作阅读风控专题](risk/25-%E9%97%AE%E9%A2%98%E5%AF%BC%E5%90%91%E7%B4%A2%E5%BC%95%EF%BC%9A%E6%8C%89%E7%97%87%E7%8A%B6%E3%80%81%E6%BA%90%E7%A0%81%E5%85%A5%E5%8F%A3%E4%B8%8E%E5%90%88%E8%A7%84%E5%8A%A8%E4%BD%9C%E9%98%85%E8%AF%BB%E9%A3%8E%E6%8E%A7%E4%B8%93%E9%A2%98.md)
- [苏格拉底附录：如果要把误伤再降一半，系统该追问什么](risk/26-%E8%8B%8F%E6%A0%BC%E6%8B%89%E5%BA%95%E9%99%84%E5%BD%95%EF%BC%9A%E5%A6%82%E6%9E%9C%E8%A6%81%E6%8A%8A%E8%AF%AF%E4%BC%A4%E5%86%8D%E9%99%8D%E4%B8%80%E5%8D%8A%EF%BC%8C%E7%B3%BB%E7%BB%9F%E8%AF%A5%E8%BF%BD%E9%97%AE%E4%BB%80%E4%B9%88.md)
- [判定非对称性矩阵：哪些路径要快放行，哪些路径必须硬收口](risk/27-%E5%88%A4%E5%AE%9A%E9%9D%9E%E5%AF%B9%E7%A7%B0%E6%80%A7%E7%9F%A9%E9%98%B5%EF%BC%9A%E5%93%AA%E4%BA%9B%E8%B7%AF%E5%BE%84%E8%A6%81%E5%BF%AB%E6%94%BE%E8%A1%8C%EF%BC%8C%E5%93%AA%E4%BA%9B%E8%B7%AF%E5%BE%84%E5%BF%85%E9%A1%BB%E7%A1%AC%E6%94%B6%E5%8F%A3.md)
