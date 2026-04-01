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
8. `philosophy/21-Prompt魔力来自约束叠加与状态反馈.md`

这条线的核心结论是：

- prompt 魔力来自装配顺序、工具 ABI、缓存边界、状态晚绑定、协作语法，以及 prompt 本身的可重放与可观测性

## 2. 统一预算器深线

如果问题是：

- 为什么安全和省 token 不是两套系统。
- 为什么治理设置、能力裁剪、budget continuation 应该放到同一张图里。
- 为什么“省 token”首先在控制什么进入上下文，而不是在压缩句子。

建议顺序：

1. `architecture/19-安全分层、策略收口与沙箱边界.md`
2. `architecture/21-消息塑形、输出外置与Token经济.md`
3. `architecture/23-统一权限决策流水线与多路仲裁.md`
4. `architecture/32-安全、权限、治理与Token预算统一图.md`
5. `architecture/37-统一预算器：能力裁剪、Token延续与状态外化.md`
6. `api/28-治理型API：Channels、Context Usage与Settings三重真相.md`
7. `api/29-动态能力暴露、裁剪链与运行时可见性.md`
8. `philosophy/22-安全、成本与体验必须共用预算器.md`

这条线的核心结论是：

- Claude Code 的预算器同时裁动作空间、上下文空间与认知噪音

## 3. 对象化深线

如果问题是：

- 为什么 workflow 不是脚本。
- 为什么多 Agent 不是“多开几个线程”。
- 为什么 worktree、task、session、mailbox 是正式对象，而不是临时手段。

建议顺序：

1. `architecture/10-AgentTool与隔离编排.md`
2. `architecture/25-会话持久化、TaskOutput与Sidechain恢复图.md`
3. `architecture/30-多Agent任务对象、Mailbox与后台协作运行时.md`
4. `architecture/34-workflow engine、LocalWorkflowTask与可见边界.md`
5. `guides/02-多Agent编排与Prompt模板.md`
6. `guides/06-第一性原理实践：目标、预算、对象、边界与回写.md`
7. `philosophy/25-Workflow不是脚本而是编排对象.md`

这条线的核心结论是：

- Claude Code 的强项在于把长流程对象化、可观察化、可恢复化

## 4. 前台真相与治理输入深线

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

这条线的核心结论是：

- 用户可见真相和输入边界共同决定系统为什么可信

## 5. 源码先进性深线

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
6. `architecture/33-公开源码镜像的先进性、热点与技术债.md`
7. `architecture/38-Contract优先、运行时底盘与公开镜像缺口.md`
8. `philosophy/23-源码质量不是卫生而是产品能力.md`
9. `philosophy/28-复杂性应该收敛到扼流点而不是散落到产品层.md`
10. `philosophy/29-反竞争条件意识优于局部功能正确.md`

这条线的核心结论是：

- Claude Code 值得学的不是“零技术债”，而是 contract-first、race-aware 与 runtime-first 的偿债方向

## 6. 真正的使用路线

如果你的目标不是研究，而是把 Claude Code 真正用顺：

1. `02-使用指南.md`
2. `guides/01-使用指南.md`
3. `guides/03-CLAUDE.md、记忆层与上下文注入实践.md`
4. `guides/06-第一性原理实践：目标、预算、对象、边界与回写.md`
5. 根据需要再跳到 prompt、预算器、对象化或治理深线

这条线的核心结论是：

- 最佳使用方式不是写更长 prompt，而是先选对 runtime 形态

## 7. 最后一句

如果你只想记一个阅读原则：

- 先找 contract 和对象，再找预算和边界，最后才看热点文件和表面功能
