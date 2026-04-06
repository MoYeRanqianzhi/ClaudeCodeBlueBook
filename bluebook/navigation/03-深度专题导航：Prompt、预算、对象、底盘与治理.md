# 深度专题导航：世界进入模型、扩张定价与当前真相

这篇负责把最容易走偏的深度专题重新压回三条母线：世界如何进入模型、扩张如何被定价、过去如何不写坏现在。

## 0. 误判校正入口

这篇不是把所有深文并列陈列，而是先区分读者最常站错的证明层级。

如果你当前的误判是：

- Prompt 读成更强的话术
- 治理读成更严的拦截
- 源码质量读成更漂亮的目录与分层

就先回：

1. `09 -> philosophy/84-87`
2. `architecture/82-84`
3. `guides/99-102 -> playbooks/77-79 -> casebooks/73-75`

只有当这三层仍不能校正误判时，才继续补旧细拆页。

它主要防五种误读：

1. 把 Prompt 读成更强文案，而不是世界进入模型前的编译秩序。
2. 把治理读成更严拦截，而不是拒绝免费扩张的统一定价。
3. 把协作承载体读成工具堆叠，而不是对象升级与恢复闭环。
4. 把源码先进性读成目录美学，而不是 current-truth surface、consumer subset 与 chokepoint 的共同保护。
5. 把第一性原理实践与苏格拉底自检放到正文尾部，而不是把它们当作前置判题器。

## 1. 请求装配控制面深线

先问：

- 为什么 Claude Code 的 prompt 看起来像“有魔力”。
- 为什么它不是抄一段 system prompt 就能复刻。
- 为什么工具 ABI、mailbox、channel 输入、cache break 都和 prompt 强度有关。

成立证据：

1. [三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](../09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md)
2. [真正有魔力的 Prompt，会先规定世界如何合法进入模型](../philosophy/84-真正有魔力的Prompt，会先规定世界如何合法进入模型.md)
3. [请求装配流水线：消息血缘、投影消费面、协议转录与合法遗忘](../architecture/82-请求装配流水线：authority chain、section registry、protocol transcript、lawful forgetting与cache-safe forks.md)
4. [苏格拉底审读：消息血缘、协议转录与继续对象](../guides/99-如何用苏格拉底诘问法审读请求装配控制面：authority chain、protocol transcript与continuation object.md)
5. [验证手册：消息血缘、协议转录、继续对象与 cache-safe fork](../playbooks/77-请求装配控制面验证手册：authority chain、protocol transcript、continuation object与cache-safe fork回归.md)
6. [反例：假消息血缘、假协议转录与假继续对象](../casebooks/73-请求装配控制面验证失真反例：假authority chain、假protocol transcript与假continuation object.md)

补充证据：

1. `07-运行时契约、知识层与生态边界.md`
2. `api/18-系统提示词、Frontmatter与上下文注入手册.md`
3. `architecture/18-提示词装配链与上下文成形.md`
4. `architecture/28-提示词契约分层、知识注入与缓存稳定性.md`
5. `architecture/31-提示词合同、缓存稳定性与多Agent语法.md`
6. `architecture/36-五层合同、缓存断点与Prompt装配时序.md`
7. `architecture/39-Prompt可重放前缀、可观测预算与Section编译器.md`
8. `architecture/42-辅助循环、侧问题与后回合Fork共享前缀.md`
9. `architecture/46-Prompt稳定性解释层：cache-break detection的两阶段诊断器.md`
10. `architecture/53-稳定前缀、动态尾部与旁路Fork：Claude Code的Cache-Aware Prompt Assembly.md`
11. `architecture/54-从UI Transcript到Protocol Transcript：Prompt不是聊天记录的直接重放.md`
12. `philosophy/21-Prompt魔力来自约束叠加与状态反馈.md`
13. `philosophy/30-Prompt不是一次请求而是可复用前缀资产.md`
14. `philosophy/33-可解释稳定性比神秘措辞更接近Prompt魔力.md`
15. `philosophy/38-安全、治理、Token与Prompt稳定性本质上是同一收口问题.md`
16. `philosophy/39-治理必须落到字节级确定性：上下文准入优于功能堆叠.md`
17. `philosophy/40-允许轻微陈旧，换取系统级确定性.md`
18. `philosophy/41-渐进暴露优于全量声明：先限制模型可见世界，再要求模型聪明.md`
19. `architecture/56-能力可见性控制平面：Deferred、Delta与最小可见面.md`
20. `philosophy/43-最小可见面优于全量能力表.md`

这条线的核心结论是：

- Prompt 魔力来自请求装配控制面：消息血缘、投影消费面、协议转录与继续对象必须持续对同一个世界保持诚实；装配顺序、工具 ABI、缓存边界、状态晚绑定与旁路 fork 只是这套控制面的实现面
- 最短记法：不是更强 prompt，而是同一世界的持续诚实

继续追问时：

- 为什么模型看到的 transcript 不能直接等于 UI transcript。
- 为什么 Claude Code 偏爱渐进暴露，而不是一开始全量声明。

补充证据：

1. `architecture/54-从UI Transcript到Protocol Transcript：Prompt不是聊天记录的直接重放.md`
2. `philosophy/41-渐进暴露优于全量声明：先限制模型可见世界，再要求模型聪明.md`

## 2. 当前世界准入主权深线

先问：

- 为什么安全和省 token 不是两套系统。
- 为什么治理设置、能力裁剪、budget continuation 与 prompt 稳定性应该放到同一张图里。
- 为什么“省 token”首先在控制什么进入上下文，而不是在压缩句子。
- 为什么运行时里需要多套预算机制，却仍共享同一第一性原理。

成立证据：

1. [三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](../09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md)
2. [真正成熟的治理，不是更会拦截，而是更会为扩张定价](../philosophy/85-真正成熟的治理，不是更会拦截，而是更会为扩张定价.md)
3. [反扩张治理流水线：治理键、typed ask、decision window 与 continuation pricing](../architecture/83-反扩张治理流水线：trusted inputs、distributed ask arbitration、deferred visibility与continuation pricing.md)
4. [苏格拉底审读：治理键、decision window 与 continuation pricing](../guides/100-如何用苏格拉底诘问法审读当前世界准入主权：trusted inputs、最小可见面与continuation pricing.md)
5. [验证手册：治理键、typed ask、decision window 与 continuation pricing 回归](../playbooks/78-当前世界准入主权验证手册：trusted inputs、typed ask、最小可见面与continuation gate回归.md)
6. [反例：低信任扩权、假 decision window 与免费继续](../casebooks/74-当前世界准入主权验证失真反例：低信任扩权、假最小可见面与免费继续.md)

补充证据：

1. `architecture/19-安全分层、策略收口与沙箱边界.md`
2. `architecture/21-消息塑形、输出外置与Token经济.md`
3. `architecture/23-统一权限决策流水线与多路仲裁.md`
4. `architecture/32-安全、权限、治理与Token预算统一图.md`
5. `architecture/37-统一预算器：能力裁剪、Token延续与状态外化.md`
6. `api/28-治理型API：Channels、Context Usage与Settings三重真相.md`
7. `api/29-动态能力暴露、裁剪链与运行时可见性.md`
8. `api/32-Context Usage、Prompt预算与观测型宿主手册.md`
9. `guides/07-用Context Usage与状态回写调优Prompt和预算.md`
10. `architecture/43-预算观测、Context Suggestions与调优闭环.md`
11. `architecture/50-PolicySettings控制平面、Sandbox契约与三套预算器.md`
12. `architecture/51-安全即输入边界控制平面：Managed Authority、Trusted Sources与Runtime Boundary Compilation.md`
13. `philosophy/22-安全、成本与体验必须共用预算器.md`
14. `philosophy/31-可观测预算优于经验调优.md`
15. `philosophy/37-统一第一性原理不等于单一预算实现.md`
16. `philosophy/38-安全、治理、Token与Prompt稳定性本质上是同一收口问题.md`
17. `architecture/56-能力可见性控制平面：Deferred、Delta与最小可见面.md`
18. `philosophy/43-最小可见面优于全量能力表.md`

这条线的核心结论是：

- Claude Code 真正持续压制的是当前世界的免费扩张；预算器、权限、可见性与 continuation pricing 只是它在动作空间、权威空间、上下文空间与时间空间上的具体定价器

## 3. 权威真相深线

先问：

- 为什么 Claude Code 反复强调 single source of truth。
- 为什么 mode、tool pool、schema、transcript path 这些地方不能让多个 feature 各自维护。
- 为什么“宿主不该猜”最终会继续走向 authoritative surface。

补充证据：

1. `api/17-状态消息、外部元数据与宿主消费矩阵.md`
2. `api/34-单一真相入口、权威状态面与Chokepoint手册.md`
3. `api/27-插件协议全生命周期：Manifest、Marketplace、Options、MCPB与Reload.md`
4. `architecture/41-叶子模块、扼流点与循环依赖切断法.md`
5. `architecture/44-单一真相入口：mode、tool pool、state与metadata的权威面.md`
6. `architecture/49-插件双真相：enabled、editable scope与policy block不能混写.md`
7. `architecture/59-协议全集、控制平面主路径与Consumer Subset：Claude Code的宿主三层治理.md`
8. `philosophy/28-复杂性应该收敛到扼流点而不是散落到产品层.md`
9. `philosophy/32-单一真相入口优于多处半真相实现.md`
10. `philosophy/36-安装状态、启用状态与策略状态必须分层叙述.md`
11. `philosophy/46-单一权威优于单一全景：多消费者系统必须分层暴露真相.md`

这条线的核心结论是：

- Claude Code 的稳定性不只来自更多状态外化，还来自关键状态必须只有一个真正可信的入口，并且同一权威真相必须允许面向不同消费者的诚实投影

## 4. 协作承载与升级深线

先问：

- 为什么 workflow 不是脚本。
- 为什么多 Agent 不是“多开几个线程”。
- 为什么 worktree、task、session、mailbox 是正式对象，而不是临时手段。

补充证据：

1. `architecture/10-AgentTool与隔离编排.md`
2. `architecture/25-会话持久化、TaskOutput与Sidechain恢复图.md`
3. `architecture/30-多Agent任务对象、Mailbox与后台协作运行时.md`
4. `architecture/34-workflow engine、LocalWorkflowTask与可见边界.md`
5. `architecture/45-对象升级而非继续对话：session、task、worktree与compact的选择机理.md`
6. `guides/02-多Agent编排与Prompt模板.md`
7. `guides/06-第一性原理实践：目标、预算、对象、边界与回写.md`
8. `guides/08-如何根据预算、阻塞与风险选择session、task、worktree与compact.md`
9. `philosophy/25-Workflow不是脚本而是编排对象.md`

这条线的核心结论是：

- Claude Code 的强项在于把长流程对象化、可观察化、可恢复化，并在预算、阻塞、风险变化时主动升级承载对象

## 5. 前台真相与治理输入深线

先问：

- 为什么前台不是 UI 皮肤，而是认知控制面。
- 为什么治理开关不是部署尾巴，而是输入边界。
- 为什么 channel 审批、外部消息 origin 和前台搜索真相应该共读。

补充证据：

1. `architecture/26-REPL前台状态机、Sticky Prompt与消息动作.md`
2. `architecture/35-REPL transcript search、selection与scroll协同.md`
3. `api/28-治理型API：Channels、Context Usage与Settings三重真相.md`
4. `guides/04-Channels、托管策略与组织级治理实践.md`
5. `guides/05-企业托管设置实战：channelsEnabled、allowedChannelPlugins与危险配置审批.md`
6. `philosophy/26-用户可见真相优于底层原始文本.md`
7. `philosophy/27-治理开关不是部署尾巴而是输入边界.md`
8. `philosophy/38-安全、治理、Token与Prompt稳定性本质上是同一收口问题.md`

这条线的核心结论是：

- 用户可见真相、输入边界与稳定前缀共同决定系统为什么可信

## 6. 远程恢复与失败语义深线

先问：

- 为什么 Claude Code 的远程恢复不能被压成“断线重连”。
- 为什么 `401`、close code、epoch、timeout budget 与 env reconnect 必须一起看。
- 为什么恢复期间主动 drop 消息，反而比“尽量不丢”更成熟。

补充证据：

1. `api/33-远程恢复、401与Close Code语义手册.md`
2. `architecture/16-远程恢复与重连状态机.md`
3. `architecture/48-远程失败不是断线重连：401、Close Code与环境恢复的分层语义.md`
4. `philosophy/11-显式失败优于假成功.md`
5. `philosophy/35-显式远程失败优于模糊在线状态.md`

这条线的核心结论是：

- Claude Code 的远程可用性不是靠“断了再试”，而是靠分层失败语义、防假连续性和恢复边界管理

## 7. 源码先进性深线

先问：

- 为什么当前真相保护、合法复杂度中心与成熟架构可以同时成立。
- 为什么源码先进性首先要看 current-truth surface、danger surface 与 consumer subset，而不是目录观感。
- 为什么源码质量判断最终必须落到合法复杂度中心、边界可证与下一次重构仍有路。

成立证据：

1. [三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](../09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md)
2. [真正先进的内核，不是更会分层，而是更会阻止过去写坏现在](../philosophy/86-真正先进的内核，不是更会分层，而是更会阻止过去写坏现在.md)
3. [真正成熟的源码质量判断：复杂度中心合法、边界可证、下一次重构仍有路](../philosophy/87-真正成熟的源码质量判断，不是文件更小，而是复杂度中心合法、边界可证、下一次重构仍有路.md)
4. [真正成熟的源码地图：更快暴露权威入口、消费者子集与危险改动面](../philosophy/76-真正成熟的源码地图，不是目录列得更细，而是更快暴露权威入口、消费者子集与危险改动面.md)
5. [权威面与反僵尸图谱：current-truth surface、freshness gate 与 ghost capability](../architecture/84-权威面与反僵尸图谱：single-writer surfaces、409 adoption、bridge pointer freshness与release shaping.md)
6. [验证手册：current-truth surface、recovery asset 与 ghost capability 回归](../playbooks/79-one writable present验证手册：single-writer authority、recovery asset与anti-zombie回归.md)
7. [反例：健康投影篡位、恢复资产越权与 anti-zombie 伪证](../casebooks/75-one writable present验证失真反例：健康投影篡位、恢复资产越权与anti-zombie伪证.md)
8. [源码质量证据分级：contract、registry、authoritative surface 与 adapter subset](../guides/102-如何给公开镜像做源码质量证据分级：contract、registry、authoritative surface、adapter subset与hotspot gap discipline.md)

补充证据：

1. `api/30-源码目录级能力地图：commands、tools、services、状态与宿主平面.md`
2. `architecture/20-源码质量、分层与工程先进性.md`
3. `architecture/24-services层全景与utils-heavy设计.md`
4. `architecture/40-显式失败语义、重复响应与反竞争条件设计.md`
5. `architecture/41-叶子模块、扼流点与循环依赖切断法.md`
6. `architecture/47-QueryGuard：本地查询生命周期的authoritative state machine.md`
7. `architecture/33-公开源码镜像的先进性、热点与技术债.md`
8. `architecture/38-Contract优先、运行时底盘与公开镜像缺口.md`
9. `philosophy/23-源码质量不是卫生而是产品能力.md`
10. `philosophy/28-复杂性应该收敛到扼流点而不是散落到产品层.md`
11. `philosophy/29-反竞争条件意识优于局部功能正确.md`
12. `philosophy/34-控制平面先于加载表现.md`
13. `architecture/51-安全即输入边界控制平面：Managed Authority、Trusted Sources与Runtime Boundary Compilation.md`
14. `architecture/52-Chokepoint、Typed Decision、Authoritative Surface、Race-Aware Runtime与Contract-First：Claude Code源码先进性五法.md`
15. `architecture/55-热点文件不是坏味道：Kernel、Shell与Chokepoint的分工.md`
16. `architecture/58-让依赖图说真话：Leaf Module、Anti-Cycle Seam与Single-Source File.md`

这条线的核心结论是：

- Claude Code 值得学的不是“零技术债”，而是把复杂度合法地收口到少数 current-truth surface、contract-first chokepoint 与 race-aware runtime，让边界可证、错误可拒、下一次重构仍有路

## 8. 可解释运行时深线

先问：

- 为什么 Claude Code 的 observability 不是调试附属层。
- 为什么 `context usage`、`worker_status/external_metadata`、`cache break detection` 应该放在同一张图里。
- 为什么一个成熟 runtime 必须能解释“模型看到了什么”“系统现在处于什么状态”“为什么前缀稳定或失稳”。

补充证据：

1. `api/32-Context Usage、Prompt预算与观测型宿主手册.md`
2. `architecture/17-双通道状态同步与外部元数据回写.md`
3. `architecture/43-预算观测、Context Suggestions与调优闭环.md`
4. `architecture/46-Prompt稳定性解释层：cache-break detection的两阶段诊断器.md`
5. `architecture/57-可解释运行时：输入真相、状态真相与稳定性真相.md`
6. `architecture/60-恢复优先的双通道状态面：writeback、resume与reconnect一体化.md`
7. `philosophy/31-可观测预算优于经验调优.md`
8. `philosophy/33-可解释稳定性比神秘措辞更接近Prompt魔力.md`
9. `philosophy/44-Observability不是Debug层，而是正式运行时合同.md`
10. `philosophy/47-当前真相必须可恢复，而不是事后可观测.md`

这条线的核心结论是：

- Claude Code 的 observability 不是为了调试方便，而是为了让输入真相、状态真相与稳定性真相都变成正式运行时合同，并让当前真相在恢复后仍然站得住

## 9. 依赖图诚实性深线

先问：

- 为什么 Claude Code 会刻意做 leaf module、anti-cycle seam、single-source file。
- 为什么依赖图治理不是代码洁癖，而是 runtime 正确性工程。
- 为什么有时宁可少一点 DRY，也要让 import 边说真话。

补充证据：

1. `architecture/41-叶子模块、扼流点与循环依赖切断法.md`
2. `architecture/52-Chokepoint、Typed Decision、Authoritative Surface、Race-Aware Runtime与Contract-First：Claude Code源码先进性五法.md`
3. `architecture/58-让依赖图说真话：Leaf Module、Anti-Cycle Seam与Single-Source File.md`
4. `philosophy/28-复杂性应该收敛到扼流点而不是散落到产品层.md`
5. `philosophy/42-成熟架构不是没有大文件，而是不把复杂性撒满全仓.md`
6. `philosophy/45-先让依赖关系诚实，再让抽象显得优雅.md`

这条线的核心结论是：

- Claude Code 的模块化不是拆分数量竞赛，而是持续让高扇入入口更薄、共享真相更小、脏边更可见

## 10. 实践入口

如果你的目标是实践，而不是继续拆解源码：

1. `02-使用指南.md`
2. `guides/01-使用指南.md`
3. `guides/03-CLAUDE.md、记忆层与上下文注入实践.md`
4. `guides/06-第一性原理实践：目标、预算、对象、边界与回写.md`
5. 根据需要再跳到 prompt、预算器、对象化或治理深线

这条线的核心结论是：

- 最佳使用方式不是写更长 prompt，而是先选对 runtime 形态

## 11. 最后一句

如果你只想记一个阅读原则：

- 先找 contract 和对象，再找预算和边界，最后才看热点文件和表面功能
