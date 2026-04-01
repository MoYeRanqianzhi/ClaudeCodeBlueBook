# 深度专题导航：Prompt、预算、对象、底盘与治理

这一篇不新增新的机制判断，而是把最近几轮新增的深度专题压成几条高价值阅读线。

它主要回答五个问题：

1. 想研究 prompt 魔力，应该从哪几章进入。
2. 想理解安全、治理与省 token 的统一预算器，应该怎样读。
3. 想把 workflow、task、worktree 当正式对象理解，应该怎样读。
4. 想判断公开镜像为什么仍然先进，应该先看哪些 contract 和 chokepoint。
5. 想真正把 Claude Code 用对，第一性原理实践应放在什么位置。

## 1. Prompt 深线

如果问题是：

- 为什么 Claude Code 的 prompt 看起来像“有魔力”。
- 为什么它不是抄一段 system prompt 就能复刻。
- 为什么工具 ABI、mailbox、channel 输入、cache break 都和 prompt 强度有关。

建议顺序：

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

- prompt 魔力来自装配顺序、工具 ABI、缓存边界、状态晚绑定、协作语法、辅助循环共享同一前缀资产，以及系统敢于用“稳定前缀 + 动态尾部 + 旁路 fork”保护整体确定性

如果问题进一步升级成：

- 为什么模型看到的 transcript 不能直接等于 UI transcript。
- 为什么 Claude Code 偏爱渐进暴露，而不是一开始全量声明。

补充阅读：

1. `architecture/54-从UI Transcript到Protocol Transcript：Prompt不是聊天记录的直接重放.md`
2. `philosophy/41-渐进暴露优于全量声明：先限制模型可见世界，再要求模型聪明.md`

## 2. 反扩张与预算实现深线

如果问题是：

- 为什么安全和省 token 不是两套系统。
- 为什么治理设置、能力裁剪、budget continuation 与 prompt 稳定性应该放到同一张图里。
- 为什么“省 token”首先在控制什么进入上下文，而不是在压缩句子。
- 为什么运行时里需要多套预算机制，却仍共享同一第一性原理。

建议顺序：

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

- Claude Code 真正持续压制的是模型可达世界的无序扩张；预算器只是它在动作空间、权威空间、上下文空间与时间空间上的若干具体控制器

## 3. 权威真相深线

如果问题是：

- 为什么 Claude Code 反复强调 single source of truth。
- 为什么 mode、tool pool、schema、transcript path 这些地方不能让多个 feature 各自维护。
- 为什么“宿主不该猜”最终会继续走向 authoritative surface。

建议顺序：

1. `api/17-状态消息、外部元数据与宿主消费矩阵.md`
2. `api/34-单一真相入口、权威状态面与Chokepoint手册.md`
3. `api/27-插件协议全生命周期：Manifest、Marketplace、Options、MCPB与Reload.md`
4. `architecture/41-叶子模块、扼流点与循环依赖切断法.md`
5. `architecture/44-单一真相入口：mode、tool pool、state与metadata的权威面.md`
6. `architecture/49-插件双真相：enabled、editable scope与policy block不能混写.md`
7. `philosophy/28-复杂性应该收敛到扼流点而不是散落到产品层.md`
8. `philosophy/32-单一真相入口优于多处半真相实现.md`
9. `philosophy/36-安装状态、启用状态与策略状态必须分层叙述.md`

这条线的核心结论是：

- Claude Code 的稳定性不只来自更多状态外化，还来自关键状态必须只有一个真正可信的入口，并且插件这类多作用域对象必须显式承认自己有多重真相

## 4. 对象化深线

如果问题是：

- 为什么 workflow 不是脚本。
- 为什么多 Agent 不是“多开几个线程”。
- 为什么 worktree、task、session、mailbox 是正式对象，而不是临时手段。

建议顺序：

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

如果问题是：

- 为什么前台不是 UI 皮肤，而是认知控制面。
- 为什么治理开关不是部署尾巴，而是输入边界。
- 为什么 channel 审批、外部消息 origin 和前台搜索真相应该共读。

建议顺序：

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

如果问题是：

- 为什么 Claude Code 的远程恢复不能被压成“断线重连”。
- 为什么 `401`、close code、epoch、timeout budget 与 env reconnect 必须一起看。
- 为什么恢复期间主动 drop 消息，反而比“尽量不丢”更成熟。

建议顺序：

1. `api/33-远程恢复、401与Close Code语义手册.md`
2. `architecture/16-远程恢复与重连状态机.md`
3. `architecture/48-远程失败不是断线重连：401、Close Code与环境恢复的分层语义.md`
4. `philosophy/11-显式失败优于假成功.md`
5. `philosophy/35-显式远程失败优于模糊在线状态.md`

这条线的核心结论是：

- Claude Code 的远程可用性不是靠“断了再试”，而是靠分层失败语义、防假连续性和恢复边界管理

## 7. 源码先进性深线

如果问题是：

- 为什么热点大文件和成熟架构可以同时成立。
- 为什么研究公开镜像时应该先找 contract，再看热点文件。
- 公开镜像缺口到底该怎样被严谨叙述。

建议顺序：

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

- Claude Code 值得学的不是“零技术债”，而是 contract-first、race-aware、runtime-first，以及把不变量收口进 chokepoint、authoritative surface 与 typed transition 的工程方向

## 8. 可解释运行时深线

如果问题是：

- 为什么 Claude Code 的 observability 不是调试附属层。
- 为什么 `context usage`、`worker_status/external_metadata`、`cache break detection` 应该放在同一张图里。
- 为什么一个成熟 runtime 必须能解释“模型看到了什么”“系统现在处于什么状态”“为什么前缀稳定或失稳”。

建议顺序：

1. `api/32-Context Usage、Prompt预算与观测型宿主手册.md`
2. `architecture/17-双通道状态同步与外部元数据回写.md`
3. `architecture/43-预算观测、Context Suggestions与调优闭环.md`
4. `architecture/46-Prompt稳定性解释层：cache-break detection的两阶段诊断器.md`
5. `architecture/57-可解释运行时：输入真相、状态真相与稳定性真相.md`
6. `philosophy/31-可观测预算优于经验调优.md`
7. `philosophy/33-可解释稳定性比神秘措辞更接近Prompt魔力.md`
8. `philosophy/44-Observability不是Debug层，而是正式运行时合同.md`

这条线的核心结论是：

- Claude Code 的 observability 不是为了调试方便，而是为了让输入真相、状态真相与稳定性真相都变成正式运行时合同

## 9. 依赖图诚实性深线

如果问题是：

- 为什么 Claude Code 会刻意做 leaf module、anti-cycle seam、single-source file。
- 为什么依赖图治理不是代码洁癖，而是 runtime 正确性工程。
- 为什么有时宁可少一点 DRY，也要让 import 边说真话。

建议顺序：

1. `architecture/41-叶子模块、扼流点与循环依赖切断法.md`
2. `architecture/52-Chokepoint、Typed Decision、Authoritative Surface、Race-Aware Runtime与Contract-First：Claude Code源码先进性五法.md`
3. `architecture/58-让依赖图说真话：Leaf Module、Anti-Cycle Seam与Single-Source File.md`
4. `philosophy/28-复杂性应该收敛到扼流点而不是散落到产品层.md`
5. `philosophy/42-成熟架构不是没有大文件，而是不把复杂性撒满全仓.md`
6. `philosophy/45-先让依赖关系诚实，再让抽象显得优雅.md`

这条线的核心结论是：

- Claude Code 的模块化不是拆分数量竞赛，而是持续让高扇入入口更薄、共享真相更小、脏边更可见

## 10. 真正的使用路线

如果你的目标不是研究，而是把 Claude Code 真正用顺：

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
