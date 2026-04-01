# 架构专题

本目录回答的不是“有哪些文件夹”，而是“Claude Code 作为 runtime 是怎么成立的”。

## 八个运行时平面

### 1. 启动与装配平面

- [01-启动链路与CLI](01-%E5%90%AF%E5%8A%A8%E9%93%BE%E8%B7%AF%E4%B8%8ECLI.md)
- [03-扩展能力与远程架构](03-%E6%89%A9%E5%B1%95%E8%83%BD%E5%8A%9B%E4%B8%8E%E8%BF%9C%E7%A8%8B%E6%9E%B6%E6%9E%84.md)

### 2. Query 与执行平面

- [02-Agent循环与工具系统](02-Agent%E5%BE%AA%E7%8E%AF%E4%B8%8E%E5%B7%A5%E5%85%B7%E7%B3%BB%E7%BB%9F.md)
- [12-ClaudeAPI与流式工具执行](12-ClaudeAPI%E4%B8%8E%E6%B5%81%E5%BC%8F%E5%B7%A5%E5%85%B7%E6%89%A7%E8%A1%8C.md)
- [22-query-turn状态机、继续语义与恢复链](22-query-turn%E7%8A%B6%E6%80%81%E6%9C%BA%E3%80%81%E7%BB%A7%E7%BB%AD%E8%AF%AD%E4%B9%89%E4%B8%8E%E6%81%A2%E5%A4%8D%E9%93%BE.md)

### 3. 状态、记忆与恢复平面

- [06-上下文压缩与恢复链](06-%E4%B8%8A%E4%B8%8B%E6%96%87%E5%8E%8B%E7%BC%A9%E4%B8%8E%E6%81%A2%E5%A4%8D%E9%93%BE.md)
- [08-compact算法与上下文管理细拆](08-compact%E7%AE%97%E6%B3%95%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E7%AE%A1%E7%90%86%E7%BB%86%E6%8B%86.md)
- [09-会话存储记忆与回溯状态面](09-%E4%BC%9A%E8%AF%9D%E5%AD%98%E5%82%A8%E8%AE%B0%E5%BF%86%E4%B8%8E%E5%9B%9E%E6%BA%AF%E7%8A%B6%E6%80%81%E9%9D%A2.md)
- [16-远程恢复与重连状态机](16-%E8%BF%9C%E7%A8%8B%E6%81%A2%E5%A4%8D%E4%B8%8E%E9%87%8D%E8%BF%9E%E7%8A%B6%E6%80%81%E6%9C%BA.md)
- [17-双通道状态同步与外部元数据回写](17-%E5%8F%8C%E9%80%9A%E9%81%93%E7%8A%B6%E6%80%81%E5%90%8C%E6%AD%A5%E4%B8%8E%E5%A4%96%E9%83%A8%E5%85%83%E6%95%B0%E6%8D%AE%E5%9B%9E%E5%86%99.md)
- [25-会话持久化、TaskOutput与Sidechain恢复图](25-%E4%BC%9A%E8%AF%9D%E6%8C%81%E4%B9%85%E5%8C%96%E3%80%81TaskOutput%E4%B8%8ESidechain%E6%81%A2%E5%A4%8D%E5%9B%BE.md)
- [29-知识层栈：CLAUDE.md、Session Memory、Auto-memory与Attachments](29-%E7%9F%A5%E8%AF%86%E5%B1%82%E6%A0%88%EF%BC%9ACLAUDE.md%E3%80%81Session%20Memory%E3%80%81Auto-memory%E4%B8%8EAttachments.md)
- [60-恢复优先的双通道状态面：writeback、resume与reconnect一体化](60-%E6%81%A2%E5%A4%8D%E4%BC%98%E5%85%88%E7%9A%84%E5%8F%8C%E9%80%9A%E9%81%93%E7%8A%B6%E6%80%81%E9%9D%A2%EF%BC%9Awriteback%E3%80%81resume%E4%B8%8Ereconnect%E4%B8%80%E4%BD%93%E5%8C%96.md)

### 4. Prompt 与上下文成形平面

- [07-PromptInput与消息渲染链](07-PromptInput%E4%B8%8E%E6%B6%88%E6%81%AF%E6%B8%B2%E6%9F%93%E9%93%BE.md)
- [18-提示词装配链与上下文成形](18-%E6%8F%90%E7%A4%BA%E8%AF%8D%E8%A3%85%E9%85%8D%E9%93%BE%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E6%88%90%E5%BD%A2.md)
- [21-消息塑形、输出外置与Token经济](21-%E6%B6%88%E6%81%AF%E5%A1%91%E5%BD%A2%E3%80%81%E8%BE%93%E5%87%BA%E5%A4%96%E7%BD%AE%E4%B8%8EToken%E7%BB%8F%E6%B5%8E.md)
- [28-提示词契约分层、知识注入与缓存稳定性](28-%E6%8F%90%E7%A4%BA%E8%AF%8D%E5%A5%91%E7%BA%A6%E5%88%86%E5%B1%82%E3%80%81%E7%9F%A5%E8%AF%86%E6%B3%A8%E5%85%A5%E4%B8%8E%E7%BC%93%E5%AD%98%E7%A8%B3%E5%AE%9A%E6%80%A7.md)
- [31-提示词合同、缓存稳定性与多Agent语法](31-%E6%8F%90%E7%A4%BA%E8%AF%8D%E5%90%88%E5%90%8C%E3%80%81%E7%BC%93%E5%AD%98%E7%A8%B3%E5%AE%9A%E6%80%A7%E4%B8%8E%E5%A4%9AAgent%E8%AF%AD%E6%B3%95.md)
- [36-五层合同、缓存断点与Prompt装配时序](36-%E4%BA%94%E5%B1%82%E5%90%88%E5%90%8C%E3%80%81%E7%BC%93%E5%AD%98%E6%96%AD%E7%82%B9%E4%B8%8EPrompt%E8%A3%85%E9%85%8D%E6%97%B6%E5%BA%8F.md)
- [39-Prompt可重放前缀、可观测预算与Section编译器](39-Prompt%E5%8F%AF%E9%87%8D%E6%94%BE%E5%89%8D%E7%BC%80%E3%80%81%E5%8F%AF%E8%A7%82%E6%B5%8B%E9%A2%84%E7%AE%97%E4%B8%8ESection%E7%BC%96%E8%AF%91%E5%99%A8.md)
- [42-辅助循环、侧问题与后回合Fork共享前缀](42-%E8%BE%85%E5%8A%A9%E5%BE%AA%E7%8E%AF%E3%80%81%E4%BE%A7%E9%97%AE%E9%A2%98%E4%B8%8E%E5%90%8E%E5%9B%9E%E5%90%88Fork%E5%85%B1%E4%BA%AB%E5%89%8D%E7%BC%80.md)
- [46-Prompt稳定性解释层：cache-break detection的两阶段诊断器](46-Prompt%E7%A8%B3%E5%AE%9A%E6%80%A7%E8%A7%A3%E9%87%8A%E5%B1%82%EF%BC%9Acache-break%20detection%E7%9A%84%E4%B8%A4%E9%98%B6%E6%AE%B5%E8%AF%8A%E6%96%AD%E5%99%A8.md)
- [53-稳定前缀、动态尾部与旁路Fork：Claude Code的Cache-Aware Prompt Assembly](53-%E7%A8%B3%E5%AE%9A%E5%89%8D%E7%BC%80%E3%80%81%E5%8A%A8%E6%80%81%E5%B0%BE%E9%83%A8%E4%B8%8E%E6%97%81%E8%B7%AFFork%EF%BC%9AClaude%20Code%E7%9A%84Cache-Aware%20Prompt%20Assembly.md)
- [54-从UI Transcript到Protocol Transcript：Prompt不是聊天记录的直接重放](54-%E4%BB%8EUI%20Transcript%E5%88%B0Protocol%20Transcript%EF%BC%9APrompt%E4%B8%8D%E6%98%AF%E8%81%8A%E5%A4%A9%E8%AE%B0%E5%BD%95%E7%9A%84%E7%9B%B4%E6%8E%A5%E9%87%8D%E6%94%BE.md)
- [61-工作语法机：Claude Code如何把软件工程世界编译成模型可行动的Protocol Surface](61-%E5%B7%A5%E4%BD%9C%E8%AF%AD%E6%B3%95%E6%9C%BA%EF%BC%9AClaude%20Code%E5%A6%82%E4%BD%95%E6%8A%8A%E8%BD%AF%E4%BB%B6%E5%B7%A5%E7%A8%8B%E4%B8%96%E7%95%8C%E7%BC%96%E8%AF%91%E6%88%90%E6%A8%A1%E5%9E%8B%E5%8F%AF%E8%A1%8C%E5%8A%A8%E7%9A%84Protocol%20Surface.md)
- [64-语义压缩器：Claude Code如何把工作现场压成可继续行动的最小语义体](64-%E8%AF%AD%E4%B9%89%E5%8E%8B%E7%BC%A9%E5%99%A8%EF%BC%9AClaude%20Code%E5%A6%82%E4%BD%95%E6%8A%8A%E5%B7%A5%E4%BD%9C%E7%8E%B0%E5%9C%BA%E5%8E%8B%E6%88%90%E5%8F%AF%E7%BB%A7%E7%BB%AD%E8%A1%8C%E5%8A%A8%E7%9A%84%E6%9C%80%E5%B0%8F%E8%AF%AD%E4%B9%89%E4%BD%93.md)

### 5. 协作与隔离平面

- [10-AgentTool与隔离编排](10-AgentTool%E4%B8%8E%E9%9A%94%E7%A6%BB%E7%BC%96%E6%8E%92.md)
- [30-多Agent任务对象、Mailbox与后台协作运行时](30-%E5%A4%9AAgent%E4%BB%BB%E5%8A%A1%E5%AF%B9%E8%B1%A1%E3%80%81Mailbox%E4%B8%8E%E5%90%8E%E5%8F%B0%E5%8D%8F%E4%BD%9C%E8%BF%90%E8%A1%8C%E6%97%B6.md)
- [34-workflow engine、LocalWorkflowTask与可见边界](34-workflow%20engine%E3%80%81LocalWorkflowTask%E4%B8%8E%E5%8F%AF%E8%A7%81%E8%BE%B9%E7%95%8C.md)
- [45-对象升级而非继续对话：session、task、worktree与compact的选择机理](45-%E5%AF%B9%E8%B1%A1%E5%8D%87%E7%BA%A7%E8%80%8C%E9%9D%9E%E7%BB%A7%E7%BB%AD%E5%AF%B9%E8%AF%9D%EF%BC%9Asession%E3%80%81task%E3%80%81worktree%E4%B8%8Ecompact%E7%9A%84%E9%80%89%E6%8B%A9%E6%9C%BA%E7%90%86.md)

### 6. 权限、安全与治理平面

- [05-权限系统与安全状态机](05-%E6%9D%83%E9%99%90%E7%B3%BB%E7%BB%9F%E4%B8%8E%E5%AE%89%E5%85%A8%E7%8A%B6%E6%80%81%E6%9C%BA.md)
- [11-权限系统全链路与Auto Mode](11-%E6%9D%83%E9%99%90%E7%B3%BB%E7%BB%9F%E5%85%A8%E9%93%BE%E8%B7%AF%E4%B8%8EAuto%20Mode.md)
- [19-安全分层、策略收口与沙箱边界](19-%E5%AE%89%E5%85%A8%E5%88%86%E5%B1%82%E3%80%81%E7%AD%96%E7%95%A5%E6%94%B6%E5%8F%A3%E4%B8%8E%E6%B2%99%E7%AE%B1%E8%BE%B9%E7%95%8C.md)
- [23-统一权限决策流水线与多路仲裁](23-%E7%BB%9F%E4%B8%80%E6%9D%83%E9%99%90%E5%86%B3%E7%AD%96%E6%B5%81%E6%B0%B4%E7%BA%BF%E4%B8%8E%E5%A4%9A%E8%B7%AF%E4%BB%B2%E8%A3%81.md)
- [32-安全、权限、治理与Token预算统一图](32-%E5%AE%89%E5%85%A8%E3%80%81%E6%9D%83%E9%99%90%E3%80%81%E6%B2%BB%E7%90%86%E4%B8%8EToken%E9%A2%84%E7%AE%97%E7%BB%9F%E4%B8%80%E5%9B%BE.md)
- [37-统一预算器：能力裁剪、Token延续与状态外化](37-%E7%BB%9F%E4%B8%80%E9%A2%84%E7%AE%97%E5%99%A8%EF%BC%9A%E8%83%BD%E5%8A%9B%E8%A3%81%E5%89%AA%E3%80%81Token%E5%BB%B6%E7%BB%AD%E4%B8%8E%E7%8A%B6%E6%80%81%E5%A4%96%E5%8C%96.md)
- [50-PolicySettings控制平面、Sandbox契约与三套预算器](50-PolicySettings%E6%8E%A7%E5%88%B6%E5%B9%B3%E9%9D%A2%E3%80%81Sandbox%E5%A5%91%E7%BA%A6%E4%B8%8E%E4%B8%89%E5%A5%97%E9%A2%84%E7%AE%97%E5%99%A8.md)
- [51-安全即输入边界控制平面：Managed Authority、Trusted Sources与Runtime Boundary Compilation](51-%E5%AE%89%E5%85%A8%E5%8D%B3%E8%BE%93%E5%85%A5%E8%BE%B9%E7%95%8C%E6%8E%A7%E5%88%B6%E5%B9%B3%E9%9D%A2%EF%BC%9AManaged%20Authority%E3%80%81Trusted%20Sources%E4%B8%8ERuntime%20Boundary%20Compilation.md)
- [56-能力可见性控制平面：Deferred、Delta与最小可见面](56-%E8%83%BD%E5%8A%9B%E5%8F%AF%E8%A7%81%E6%80%A7%E6%8E%A7%E5%88%B6%E5%B9%B3%E9%9D%A2%EF%BC%9ADeferred%E3%80%81Delta%E4%B8%8E%E6%9C%80%E5%B0%8F%E5%8F%AF%E8%A7%81%E9%9D%A2.md)
- [62-Narrow、Later、Outside：安全设计与省Token设计的统一反扩张运行时](62-Narrow%E3%80%81Later%E3%80%81Outside%EF%BC%9A%E5%AE%89%E5%85%A8%E8%AE%BE%E8%AE%A1%E4%B8%8E%E7%9C%81Token%E8%AE%BE%E8%AE%A1%E7%9A%84%E7%BB%9F%E4%B8%80%E5%8F%8D%E6%89%A9%E5%BC%A0%E8%BF%90%E8%A1%8C%E6%97%B6.md)
- [65-资源宪法：Claude Code如何统一分配能力、时间、注意力与权威](65-%E8%B5%84%E6%BA%90%E5%AE%AA%E6%B3%95%EF%BC%9AClaude%20Code%E5%A6%82%E4%BD%95%E7%BB%9F%E4%B8%80%E5%88%86%E9%85%8D%E8%83%BD%E5%8A%9B%E3%80%81%E6%97%B6%E9%97%B4%E3%80%81%E6%B3%A8%E6%84%8F%E5%8A%9B%E4%B8%8E%E6%9D%83%E5%A8%81.md)

### 7. 工程与底盘平面

- [20-源码质量、分层与工程先进性](20-%E6%BA%90%E7%A0%81%E8%B4%A8%E9%87%8F%E3%80%81%E5%88%86%E5%B1%82%E4%B8%8E%E5%B7%A5%E7%A8%8B%E5%85%88%E8%BF%9B%E6%80%A7.md)
- [24-services层全景与utils-heavy设计](24-services%E5%B1%82%E5%85%A8%E6%99%AF%E4%B8%8Eutils-heavy%E8%AE%BE%E8%AE%A1.md)
- [33-公开源码镜像的先进性、热点与技术债](33-%E5%85%AC%E5%BC%80%E6%BA%90%E7%A0%81%E9%95%9C%E5%83%8F%E7%9A%84%E5%85%88%E8%BF%9B%E6%80%A7%E3%80%81%E7%83%AD%E7%82%B9%E4%B8%8E%E6%8A%80%E6%9C%AF%E5%80%BA.md)
- [38-Contract优先、运行时底盘与公开镜像缺口](38-Contract%E4%BC%98%E5%85%88%E3%80%81%E8%BF%90%E8%A1%8C%E6%97%B6%E5%BA%95%E7%9B%98%E4%B8%8E%E5%85%AC%E5%BC%80%E9%95%9C%E5%83%8F%E7%BC%BA%E5%8F%A3.md)
- [40-显式失败语义、重复响应与反竞争条件设计](40-%E6%98%BE%E5%BC%8F%E5%A4%B1%E8%B4%A5%E8%AF%AD%E4%B9%89%E3%80%81%E9%87%8D%E5%A4%8D%E5%93%8D%E5%BA%94%E4%B8%8E%E5%8F%8D%E7%AB%9E%E4%BA%89%E6%9D%A1%E4%BB%B6%E8%AE%BE%E8%AE%A1.md)
- [41-叶子模块、扼流点与循环依赖切断法](41-%E5%8F%B6%E5%AD%90%E6%A8%A1%E5%9D%97%E3%80%81%E6%89%BC%E6%B5%81%E7%82%B9%E4%B8%8E%E5%BE%AA%E7%8E%AF%E4%BE%9D%E8%B5%96%E5%88%87%E6%96%AD%E6%B3%95.md)
- [43-预算观测、Context Suggestions与调优闭环](43-%E9%A2%84%E7%AE%97%E8%A7%82%E6%B5%8B%E3%80%81Context%20Suggestions%E4%B8%8E%E8%B0%83%E4%BC%98%E9%97%AD%E7%8E%AF.md)
- [44-单一真相入口：mode、tool pool、state与metadata的权威面](44-%E5%8D%95%E4%B8%80%E7%9C%9F%E7%9B%B8%E5%85%A5%E5%8F%A3%EF%BC%9Amode%E3%80%81tool%20pool%E3%80%81state%E4%B8%8Emetadata%E7%9A%84%E6%9D%83%E5%A8%81%E9%9D%A2.md)
- [47-QueryGuard：本地查询生命周期的authoritative state machine](47-QueryGuard%EF%BC%9A%E6%9C%AC%E5%9C%B0%E6%9F%A5%E8%AF%A2%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F%E7%9A%84authoritative%20state%20machine.md)
- [52-Chokepoint、Typed Decision、Authoritative Surface、Race-Aware Runtime与Contract-First：Claude Code源码先进性五法](52-Chokepoint%E3%80%81Typed%20Decision%E3%80%81Authoritative%20Surface%E3%80%81Race-Aware%20Runtime%E4%B8%8EContract-First%EF%BC%9AClaude%20Code%E6%BA%90%E7%A0%81%E5%85%88%E8%BF%9B%E6%80%A7%E4%BA%94%E6%B3%95.md)
- [55-热点文件不是坏味道：Kernel、Shell与Chokepoint的分工](55-%E7%83%AD%E7%82%B9%E6%96%87%E4%BB%B6%E4%B8%8D%E6%98%AF%E5%9D%8F%E5%91%B3%E9%81%93%EF%BC%9AKernel%E3%80%81Shell%E4%B8%8EChokepoint%E7%9A%84%E5%88%86%E5%B7%A5.md)
- [57-可解释运行时：输入真相、状态真相与稳定性真相](57-%E5%8F%AF%E8%A7%A3%E9%87%8A%E8%BF%90%E8%A1%8C%E6%97%B6%EF%BC%9A%E8%BE%93%E5%85%A5%E7%9C%9F%E7%9B%B8%E3%80%81%E7%8A%B6%E6%80%81%E7%9C%9F%E7%9B%B8%E4%B8%8E%E7%A8%B3%E5%AE%9A%E6%80%A7%E7%9C%9F%E7%9B%B8.md)
- [58-让依赖图说真话：Leaf Module、Anti-Cycle Seam与Single-Source File](58-%E8%AE%A9%E4%BE%9D%E8%B5%96%E5%9B%BE%E8%AF%B4%E7%9C%9F%E8%AF%9D%EF%BC%9ALeaf%20Module%E3%80%81Anti-Cycle%20Seam%E4%B8%8ESingle-Source%20File.md)
- [63-可演化内核：Claude Code如何在持续增长中维持不变量](63-%E5%8F%AF%E6%BC%94%E5%8C%96%E5%86%85%E6%A0%B8%EF%BC%9AClaude%20Code%E5%A6%82%E4%BD%95%E5%9C%A8%E6%8C%81%E7%BB%AD%E5%A2%9E%E9%95%BF%E4%B8%AD%E7%BB%B4%E6%8C%81%E4%B8%8D%E5%8F%98%E9%87%8F.md)
- [66-演化制度设计：Claude Code如何在增长中保留重构可能性](66-%E6%BC%94%E5%8C%96%E5%88%B6%E5%BA%A6%E8%AE%BE%E8%AE%A1%EF%BC%9AClaude%20Code%E5%A6%82%E4%BD%95%E5%9C%A8%E5%A2%9E%E9%95%BF%E4%B8%AD%E4%BF%9D%E7%95%99%E9%87%8D%E6%9E%84%E5%8F%AF%E8%83%BD%E6%80%A7.md)

### 8. 宿主、前台与产品边界平面

- [04-REPL与Ink交互架构](04-REPL%E4%B8%8EInk%E4%BA%A4%E4%BA%92%E6%9E%B6%E6%9E%84.md)
- [13-StructuredIO与RemoteIO控制平面](13-StructuredIO%E4%B8%8ERemoteIO%E6%8E%A7%E5%88%B6%E5%B9%B3%E9%9D%A2.md)
- [14-Bridge与宿主适配器分层](14-Bridge%E4%B8%8E%E5%AE%BF%E4%B8%BB%E9%80%82%E9%85%8D%E5%99%A8%E5%88%86%E5%B1%82.md)
- [15-宿主路径时序与竞速](15-%E5%AE%BF%E4%B8%BB%E8%B7%AF%E5%BE%84%E6%97%B6%E5%BA%8F%E4%B8%8E%E7%AB%9E%E9%80%9F.md)
- [26-REPL前台状态机、Sticky Prompt与消息动作](26-REPL%E5%89%8D%E5%8F%B0%E7%8A%B6%E6%80%81%E6%9C%BA%E3%80%81Sticky%20Prompt%E4%B8%8E%E6%B6%88%E6%81%AF%E5%8A%A8%E4%BD%9C.md)
- [35-REPL transcript search、selection与scroll协同](35-REPL%20transcript%20search%E3%80%81selection%E4%B8%8Escroll%E5%8D%8F%E5%90%8C.md)
- [27-能力迁移、Consumer Subset与产品边界](27-%E8%83%BD%E5%8A%9B%E8%BF%81%E7%A7%BB%E3%80%81Consumer%20Subset%E4%B8%8E%E4%BA%A7%E5%93%81%E8%BE%B9%E7%95%8C.md)
- [48-远程失败不是断线重连：401、Close Code与环境恢复的分层语义](48-%E8%BF%9C%E7%A8%8B%E5%A4%B1%E8%B4%A5%E4%B8%8D%E6%98%AF%E6%96%AD%E7%BA%BF%E9%87%8D%E8%BF%9E%EF%BC%9A401%E3%80%81Close%20Code%E4%B8%8E%E7%8E%AF%E5%A2%83%E6%81%A2%E5%A4%8D%E7%9A%84%E5%88%86%E5%B1%82%E8%AF%AD%E4%B9%89.md)
- [49-插件双真相：enabled、editable scope与policy block不能混写](49-%E6%8F%92%E4%BB%B6%E5%8F%8C%E7%9C%9F%E7%9B%B8%EF%BC%9Aenabled%E3%80%81editable%20scope%E4%B8%8Epolicy%20block%E4%B8%8D%E8%83%BD%E6%B7%B7%E5%86%99.md)
- [59-协议全集、控制平面主路径与Consumer Subset：Claude Code的宿主三层治理](59-%E5%8D%8F%E8%AE%AE%E5%85%A8%E9%9B%86%E3%80%81%E6%8E%A7%E5%88%B6%E5%B9%B3%E9%9D%A2%E4%B8%BB%E8%B7%AF%E5%BE%84%E4%B8%8EConsumer%20Subset%EF%BC%9AClaude%20Code%E7%9A%84%E5%AE%BF%E4%B8%BB%E4%B8%89%E5%B1%82%E6%B2%BB%E7%90%86.md)

## 推荐阅读链

- 想看 turn runtime 内核：`02 -> 12 -> 22`
- 想看状态与恢复：`06 -> 09 -> 16 -> 17 -> 25 -> 60`
- 想看 prompt contract：`18 -> 21 -> 28 -> 29`
- 想看 prompt 魔力如何落到五层合同、缓存断点与协作语法：`18 -> 28 -> 31 -> 36`
- 想看 prompt 为什么还能继续下沉到可重放、可观测、可编译：`28 -> 31 -> 36 -> 39`
- 想看 prompt 魔力怎样扩展到 `/btw`、suggestion、memory、summary 这些辅助循环：`31 -> 39 -> 42`
- 想看 prompt 为什么继续升级成“可解释稳定性系统”：`39 -> 42 -> 46`
- 想看 prompt 如何进一步落成“稳定前缀 + 动态尾部 + 旁路 fork”的组装底盘：`39 -> 42 -> 46 -> 53`
- 想看 UI transcript 为什么还要在 API 边界前被重新编译成 protocol transcript：`53 -> 54`
- 想看 prompt 为什么还能再上升成“工作语法机”：`39 -> 53 -> 54 -> 61`
- 想看 prompt 为什么还能继续上升成“语义压缩器”：`53 -> 61 -> 64`
- 想看“最小可见面”怎样把 deferred、delta 与 managed-only 输入写成统一控制平面：`51 -> 54 -> 56`
- 想看多 Agent、workflow 与隔离：`10 -> 30 -> 34 -> 45`
- 想看权限、安全、治理与 token 预算统一图：`05 -> 11 -> 19 -> 23 -> 32 -> 37 -> 50 -> 51`
- 想看安全为什么更像输入边界控制平面而不是事后检查：`19 -> 23 -> 50 -> 51`
- 想看安全和省 token 为什么其实共享 `Narrow / Later / Outside` 三种动作：`21 -> 37 -> 51 -> 56 -> 62`
- 想看安全、省 token 与治理为什么还能再上升成“资源宪法”：`50 -> 51 -> 62 -> 65`
- 想看宿主控制平面：`13 -> 14 -> 15 -> 17 -> 59`
- 想看为什么协议全集、权威主路径与 consumer subset 必须分三层：`13 -> 14 -> 17 -> 59`
- 想看远程失败为什么也是分层语义而不是“断线重连”：`15 -> 16 -> 48`
- 想看 REPL 前台如何从状态机深入到 search / selection / scroll 协同：`04 -> 26 -> 35`
- 想看源码先进性、热点与产品边界：`20 -> 24 -> 33 -> 38`
- 想看源码先进性如何继续压成几种可迁移工程模式：`20 -> 40 -> 41 -> 47 -> 52`
- 想看热点大文件为什么仍然可以是成熟架构的一部分：`52 -> 55`
- 想看源码先进性为什么最终会收束成“可演化内核”：`41 -> 47 -> 52 -> 58 -> 63`
- 想看源码先进性为什么还能继续上升成“演化制度设计”：`63 -> 66`
- 想看预算观测、状态回写与 cache break 为什么应该合写成“可解释运行时”：`17 -> 43 -> 57`
- 想看状态回写为什么属于 durability，而不是遥测附属层：`17 -> 25 -> 57 -> 60`
- 想看 leaf module、anti-cycle seam 与 single-source file 为什么同属一套依赖图治理方法：`41 -> 58`
- 想看显式失败、重复响应与 race-aware runtime：`13 -> 14 -> 17 -> 40`
- 想看 chokepoint、leaf module 与依赖图切断：`24 -> 38 -> 41`
- 想看预算为什么会走向“观测 -> 建议 -> 调优”的闭环：`21 -> 37 -> 43`
- 想看为什么关键状态必须收口成 authoritative surface：`17 -> 41 -> 44`
- 想看为什么复杂任务应先升级对象再继续对话：`25 -> 30 -> 34 -> 45`
- 想看本地查询为什么也需要同步 authority 与 generation 防竞态：`26 -> 40 -> 47`
- 想看插件系统为什么要把 enabled truth、editable scope 与 policy block 分开：`27 -> 44 -> 49`

主线结论先看 [../03-设计哲学](../03-%E8%AE%BE%E8%AE%A1%E5%93%B2%E5%AD%A6.md) 和 [../07-运行时契约、知识层与生态边界](../07-%E8%BF%90%E8%A1%8C%E6%97%B6%E5%A5%91%E7%BA%A6%E3%80%81%E7%9F%A5%E8%AF%86%E5%B1%82%E4%B8%8E%E7%94%9F%E6%80%81%E8%BE%B9%E7%95%8C.md)。
