# API 文档

本目录的目标不是机械抄类型，而是回答四个问题：

1. Claude Code 公开了哪些正式能力表面。
2. 这些能力分别通过命令、工具、事件流、控制协议、状态接口还是扩展接口暴露。
3. 哪些是稳定主路径，哪些只是 gate、consumer subset 或适配器子集。
4. 宿主开发者到底该按什么顺序接入。

## API 目录的七个平面

### 0. 能力全集与接入总图

- [23-能力平面、公开度与宿主支持矩阵](23-%E8%83%BD%E5%8A%9B%E5%B9%B3%E9%9D%A2%E3%80%81%E5%85%AC%E5%BC%80%E5%BA%A6%E4%B8%8E%E5%AE%BF%E4%B8%BB%E6%94%AF%E6%8C%81%E7%9F%A9%E9%98%B5.md)
- [24-命令、工具、会话、宿主与协作API全谱系](24-%E5%91%BD%E4%BB%A4%E3%80%81%E5%B7%A5%E5%85%B7%E3%80%81%E4%BC%9A%E8%AF%9D%E3%80%81%E5%AE%BF%E4%B8%BB%E4%B8%8E%E5%8D%8F%E4%BD%9CAPI%E5%85%A8%E8%B0%B1%E7%B3%BB.md)
- [25-命令、工具、任务与团队能力全集手册](25-%E5%91%BD%E4%BB%A4%E3%80%81%E5%B7%A5%E5%85%B7%E3%80%81%E4%BB%BB%E5%8A%A1%E4%B8%8E%E5%9B%A2%E9%98%9F%E8%83%BD%E5%8A%9B%E5%85%A8%E9%9B%86%E6%89%8B%E5%86%8C.md)
- [26-SDK、Control、Session与Remote接入全景矩阵](26-SDK%E3%80%81Control%E3%80%81Session%E4%B8%8ERemote%E6%8E%A5%E5%85%A5%E5%85%A8%E6%99%AF%E7%9F%A9%E9%98%B5.md)
- [29-动态能力暴露、裁剪链与运行时可见性](29-%E5%8A%A8%E6%80%81%E8%83%BD%E5%8A%9B%E6%9A%B4%E9%9C%B2%E3%80%81%E8%A3%81%E5%89%AA%E9%93%BE%E4%B8%8E%E8%BF%90%E8%A1%8C%E6%97%B6%E5%8F%AF%E8%A7%81%E6%80%A7.md)
- [30-源码目录级能力地图：commands、tools、services、状态与宿主平面](30-%E6%BA%90%E7%A0%81%E7%9B%AE%E5%BD%95%E7%BA%A7%E8%83%BD%E5%8A%9B%E5%9C%B0%E5%9B%BE%EF%BC%9Acommands%E3%80%81tools%E3%80%81services%E3%80%81%E7%8A%B6%E6%80%81%E4%B8%8E%E5%AE%BF%E4%B8%BB%E5%B9%B3%E9%9D%A2.md)
- [27-插件协议全生命周期：Manifest、Marketplace、Options、MCPB与Reload](27-%E6%8F%92%E4%BB%B6%E5%8D%8F%E8%AE%AE%E5%85%A8%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F%EF%BC%9AManifest%E3%80%81Marketplace%E3%80%81Options%E3%80%81MCPB%E4%B8%8EReload.md)
- [28-治理型API：Channels、Context Usage与Settings三重真相](28-%E6%B2%BB%E7%90%86%E5%9E%8BAPI%EF%BC%9AChannels%E3%80%81Context%20Usage%E4%B8%8ESettings%E4%B8%89%E9%87%8D%E7%9C%9F%E7%9B%B8.md)

### 1. 命令与控制面

- [01-命令与功能矩阵](01-%E5%91%BD%E4%BB%A4%E4%B8%8E%E5%8A%9F%E8%83%BD%E7%9F%A9%E9%98%B5.md)
- [05-控制请求与响应矩阵](05-%E6%8E%A7%E5%88%B6%E8%AF%B7%E6%B1%82%E4%B8%8E%E5%93%8D%E5%BA%94%E7%9F%A9%E9%98%B5.md)
- [06-内置命令域索引](06-%E5%86%85%E7%BD%AE%E5%91%BD%E4%BB%A4%E5%9F%9F%E7%B4%A2%E5%BC%95.md)
- [07-命令字段与可用性索引](07-%E5%91%BD%E4%BB%A4%E5%AD%97%E6%AE%B5%E4%B8%8E%E5%8F%AF%E7%94%A8%E6%80%A7%E7%B4%A2%E5%BC%95.md)

### 2. 工具与运行时注入面

- [02-Agent SDK与控制协议](02-Agent%20SDK%E4%B8%8E%E6%8E%A7%E5%88%B6%E5%8D%8F%E8%AE%AE.md)
- [08-工具协议与ToolUseContext](08-%E5%B7%A5%E5%85%B7%E5%8D%8F%E8%AE%AE%E4%B8%8EToolUseContext.md)

### 3. 事件、状态与恢复面

- [04-SDK消息与事件字典](04-SDK%E6%B6%88%E6%81%AF%E4%B8%8E%E4%BA%8B%E4%BB%B6%E5%AD%97%E5%85%B8.md)
- [09-会话与状态API手册](09-%E4%BC%9A%E8%AF%9D%E4%B8%8E%E7%8A%B6%E6%80%81API%E6%89%8B%E5%86%8C.md)
- [11-SDKMessageSchema与事件流手册](11-SDKMessageSchema%E4%B8%8E%E4%BA%8B%E4%BB%B6%E6%B5%81%E6%89%8B%E5%86%8C.md)
- [17-状态消息、外部元数据与宿主消费矩阵](17-%E7%8A%B6%E6%80%81%E6%B6%88%E6%81%AF%E3%80%81%E5%A4%96%E9%83%A8%E5%85%83%E6%95%B0%E6%8D%AE%E4%B8%8E%E5%AE%BF%E4%B8%BB%E6%B6%88%E8%B4%B9%E7%9F%A9%E9%98%B5.md)
- [19-SDKMessage、worker_status与external_metadata字段级对照手册](19-SDKMessage%E3%80%81worker_status%E4%B8%8Eexternal_metadata%E5%AD%97%E6%AE%B5%E7%BA%A7%E5%AF%B9%E7%85%A7%E6%89%8B%E5%86%8C.md)
- [20-宿主实现最小闭环与恢复案例手册](20-%E5%AE%BF%E4%B8%BB%E5%AE%9E%E7%8E%B0%E6%9C%80%E5%B0%8F%E9%97%AD%E7%8E%AF%E4%B8%8E%E6%81%A2%E5%A4%8D%E6%A1%88%E4%BE%8B%E6%89%8B%E5%86%8C.md)
- [31-失败语义、取消请求与孤儿修复API手册](31-%E5%A4%B1%E8%B4%A5%E8%AF%AD%E4%B9%89%E3%80%81%E5%8F%96%E6%B6%88%E8%AF%B7%E6%B1%82%E4%B8%8E%E5%AD%A4%E5%84%BF%E4%BF%AE%E5%A4%8DAPI%E6%89%8B%E5%86%8C.md)
- [32-Context Usage、Prompt预算与观测型宿主手册](32-Context%20Usage%E3%80%81Prompt%E9%A2%84%E7%AE%97%E4%B8%8E%E8%A7%82%E6%B5%8B%E5%9E%8B%E5%AE%BF%E4%B8%BB%E6%89%8B%E5%86%8C.md)
- [33-远程恢复、401与Close Code语义手册](33-%E8%BF%9C%E7%A8%8B%E6%81%A2%E5%A4%8D%E3%80%81401%E4%B8%8EClose%20Code%E8%AF%AD%E4%B9%89%E6%89%8B%E5%86%8C.md)
- [34-单一真相入口、权威状态面与Chokepoint手册](34-%E5%8D%95%E4%B8%80%E7%9C%9F%E7%9B%B8%E5%85%A5%E5%8F%A3%E3%80%81%E6%9D%83%E5%A8%81%E7%8A%B6%E6%80%81%E9%9D%A2%E4%B8%8EChokepoint%E6%89%8B%E5%86%8C.md)
- [35-Rollout证据消费API手册：worker_status、external_metadata、Context Usage与回退对象边界](35-Rollout%E8%AF%81%E6%8D%AE%E6%B6%88%E8%B4%B9API%E6%89%8B%E5%86%8C%EF%BC%9Aworker_status%E3%80%81external_metadata%E3%80%81Context%20Usage%E4%B8%8E%E5%9B%9E%E9%80%80%E5%AF%B9%E8%B1%A1%E8%BE%B9%E7%95%8C.md)
- [36-Evidence Envelope字段矩阵：宿主、CI、评审与交接四类消费者的共享消费顺序](36-Evidence%20Envelope%E5%AD%97%E6%AE%B5%E7%9F%A9%E9%98%B5%EF%BC%9A%E5%AE%BF%E4%B8%BB%E3%80%81CI%E3%80%81%E8%AF%84%E5%AE%A1%E4%B8%8E%E4%BA%A4%E6%8E%A5%E5%9B%9B%E7%B1%BB%E6%B6%88%E8%B4%B9%E8%80%85%E7%9A%84%E5%85%B1%E4%BA%AB%E6%B6%88%E8%B4%B9%E9%A1%BA%E5%BA%8F.md)
- [37-Prompt Host Artifact Contract：宿主卡、CI附件、评审卡与交接包的共享字段骨架](37-Prompt%20Host%20Artifact%20Contract%EF%BC%9A%E5%AE%BF%E4%B8%BB%E5%8D%A1%E3%80%81CI%E9%99%84%E4%BB%B6%E3%80%81%E8%AF%84%E5%AE%A1%E5%8D%A1%E4%B8%8E%E4%BA%A4%E6%8E%A5%E5%8C%85%E7%9A%84%E5%85%B1%E4%BA%AB%E5%AD%97%E6%AE%B5%E9%AA%A8%E6%9E%B6.md)
- [38-治理 Host Artifact Contract：对象、窗口、仲裁、失败语义与回退工件协议](38-%E6%B2%BB%E7%90%86%20Host%20Artifact%20Contract%EF%BC%9A%E5%AF%B9%E8%B1%A1%E3%80%81%E7%AA%97%E5%8F%A3%E3%80%81%E4%BB%B2%E8%A3%81%E3%80%81%E5%A4%B1%E8%B4%A5%E8%AF%AD%E4%B9%89%E4%B8%8E%E5%9B%9E%E9%80%80%E5%B7%A5%E4%BB%B6%E5%8D%8F%E8%AE%AE.md)
- [39-结构 Host Artifact Contract：权威路径、恢复资产、反zombie 与交接包字段骨架](39-%E7%BB%93%E6%9E%84%20Host%20Artifact%20Contract%EF%BC%9A%E6%9D%83%E5%A8%81%E8%B7%AF%E5%BE%84%E3%80%81%E6%81%A2%E5%A4%8D%E8%B5%84%E4%BA%A7%E3%80%81%E5%8F%8Dzombie%20%E4%B8%8E%E4%BA%A4%E6%8E%A5%E5%8C%85%E5%AD%97%E6%AE%B5%E9%AA%A8%E6%9E%B6.md)
- [40-Prompt Artifact Rule ABI：Shared Object、Stable Bytes、Lawful Forgetting 与 Reject Semantics 的机器可读结构](40-Prompt%20Artifact%20Rule%20ABI%EF%BC%9AShared%20Object%E3%80%81Stable%20Bytes%E3%80%81Lawful%20Forgetting%20%E4%B8%8E%20Reject%20Semantics%20%E7%9A%84%E6%9C%BA%E5%99%A8%E5%8F%AF%E8%AF%BB%E7%BB%93%E6%9E%84.md)
- [41-治理 Artifact Rule ABI：Decision Gain、Failure Semantics、Rollback Object 与 Reject 语义的机器可读结构](41-%E6%B2%BB%E7%90%86%20Artifact%20Rule%20ABI%EF%BC%9ADecision%20Gain%E3%80%81Failure%20Semantics%E3%80%81Rollback%20Object%20%E4%B8%8E%20Reject%20%E8%AF%AD%E4%B9%89%E7%9A%84%E6%9C%BA%E5%99%A8%E5%8F%AF%E8%AF%BB%E7%BB%93%E6%9E%84.md)
- [42-结构 Artifact Rule ABI：Authoritative Path、Recovery Asset、Anti-Zombie 与 Reject 语义的机器可读结构](42-%E7%BB%93%E6%9E%84%20Artifact%20Rule%20ABI%EF%BC%9AAuthoritative%20Path%E3%80%81Recovery%20Asset%E3%80%81Anti-Zombie%20%E4%B8%8E%20Reject%20%E8%AF%AD%E4%B9%89%E7%9A%84%E6%9C%BA%E5%99%A8%E5%8F%AF%E8%AF%BB%E7%BB%93%E6%9E%84.md)
- [43-Prompt Artifact Harness Runner API：Replay Queue、Alignment Assertion、Drift Ledger 与 Rewrite Adoption 的持续执行协议](43-Prompt%20Artifact%20Harness%20Runner%20API%EF%BC%9AReplay%20Queue%E3%80%81Alignment%20Assertion%E3%80%81Drift%20Ledger%20%E4%B8%8E%20Rewrite%20Adoption%20%E7%9A%84%E6%8C%81%E7%BB%AD%E6%89%A7%E8%A1%8C%E5%8D%8F%E8%AE%AE.md)
- [44-治理 Artifact Harness Runner API：Decision Window Replay Queue、Arbitration Assertion、Drift Ledger 与 Upgrade Adoption 协议](44-%E6%B2%BB%E7%90%86%20Artifact%20Harness%20Runner%20API%EF%BC%9ADecision%20Window%20Replay%20Queue%E3%80%81Arbitration%20Assertion%E3%80%81Drift%20Ledger%20%E4%B8%8E%20Upgrade%20Adoption%20%E5%8D%8F%E8%AE%AE.md)
- [45-结构 Artifact Harness Runner API：Authoritative Replay Queue、Anti-Zombie Assertion、Drift Ledger 与 Recovery Adoption 协议](45-%E7%BB%93%E6%9E%84%20Artifact%20Harness%20Runner%20API%EF%BC%9AAuthoritative%20Replay%20Queue%E3%80%81Anti-Zombie%20Assertion%E3%80%81Drift%20Ledger%20%E4%B8%8E%20Recovery%20Adoption%20%E5%8D%8F%E8%AE%AE.md)
- [50-治理控制面支持面手册：Settings、Permission、MCP、Context Usage、状态写回与继续门控](50-%E6%B2%BB%E7%90%86%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%94%AF%E6%8C%81%E9%9D%A2%E6%89%8B%E5%86%8C%EF%BC%9ASettings%E3%80%81Permission%E3%80%81MCP%E3%80%81Context%20Usage%E3%80%81%E7%8A%B6%E6%80%81%E5%86%99%E5%9B%9E%E4%B8%8E%E7%BB%A7%E7%BB%AD%E9%97%A8%E6%8E%A7.md)
- [46-Services 二级目录 Atlas：API、Compact、Memory、MCP、LSP 与 Observability 子系统的权威入口](46-services%20%E4%BA%8C%E7%BA%A7%E7%9B%AE%E5%BD%95%20Atlas%EF%BC%9AAPI%E3%80%81Compact%E3%80%81Memory%E3%80%81MCP%E3%80%81LSP%20%E4%B8%8E%20Observability%20%E5%AD%90%E7%B3%BB%E7%BB%9F%E7%9A%84%E6%9D%83%E5%A8%81%E5%85%A5%E5%8F%A3.md)
- [47-Tools 二级目录 Atlas：执行原语、交互控制、任务编排、扩展桥接与延迟暴露边界](47-tools%20%E4%BA%8C%E7%BA%A7%E7%9B%AE%E5%BD%95%20Atlas%EF%BC%9A%E6%89%A7%E8%A1%8C%E5%8E%9F%E8%AF%AD%E3%80%81%E4%BA%A4%E4%BA%92%E6%8E%A7%E5%88%B6%E3%80%81%E4%BB%BB%E5%8A%A1%E7%BC%96%E6%8E%92%E3%80%81%E6%89%A9%E5%B1%95%E6%A1%A5%E6%8E%A5%E4%B8%8E%E5%BB%B6%E8%BF%9F%E6%9A%B4%E9%9C%B2%E8%BE%B9%E7%95%8C.md)
- [48-Commands 二级目录 Atlas：会话控制、模式治理、扩展装配、交付诊断与内部命令边界](48-commands%20%E4%BA%8C%E7%BA%A7%E7%9B%AE%E5%BD%95%20Atlas%EF%BC%9A%E4%BC%9A%E8%AF%9D%E6%8E%A7%E5%88%B6%E3%80%81%E6%A8%A1%E5%BC%8F%E6%B2%BB%E7%90%86%E3%80%81%E6%89%A9%E5%B1%95%E8%A3%85%E9%85%8D%E3%80%81%E4%BA%A4%E4%BB%98%E8%AF%8A%E6%96%AD%E4%B8%8E%E5%86%85%E9%83%A8%E5%91%BD%E4%BB%A4%E8%BE%B9%E7%95%8C.md)

### 4. Prompt、知识与上下文装配面

- [18-系统提示词、Frontmatter与上下文注入手册](18-%E7%B3%BB%E7%BB%9F%E6%8F%90%E7%A4%BA%E8%AF%8D%E3%80%81Frontmatter%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E6%B3%A8%E5%85%A5%E6%89%8B%E5%86%8C.md)
- [21-提示词控制、知识注入与记忆API手册](21-%E6%8F%90%E7%A4%BA%E8%AF%8D%E6%8E%A7%E5%88%B6%E3%80%81%E7%9F%A5%E8%AF%86%E6%B3%A8%E5%85%A5%E4%B8%8E%E8%AE%B0%E5%BF%86API%E6%89%8B%E5%86%8C.md)
- [49-Prompt编译与稳定性支持面手册：注入入口、协议转译、缓存断点与合法遗忘边界](49-Prompt%E7%BC%96%E8%AF%91%E4%B8%8E%E7%A8%B3%E5%AE%9A%E6%80%A7%E6%94%AF%E6%8C%81%E9%9D%A2%E6%89%8B%E5%86%8C%EF%BC%9A%E6%B3%A8%E5%85%A5%E5%85%A5%E5%8F%A3%E3%80%81%E5%8D%8F%E8%AE%AE%E8%BD%AC%E8%AF%91%E3%80%81%E7%BC%93%E5%AD%98%E6%96%AD%E7%82%B9%E4%B8%8E%E5%90%88%E6%B3%95%E9%81%97%E5%BF%98%E8%BE%B9%E7%95%8C.md)

### 5. 扩展、连接与宿主适配面

- [03-MCP与远程传输](03-MCP%E4%B8%8E%E8%BF%9C%E7%A8%8B%E4%BC%A0%E8%BE%93.md)
- [10-扩展Frontmatter与插件Agent手册](10-%E6%89%A9%E5%B1%95Frontmatter%E4%B8%8E%E6%8F%92%E4%BB%B6Agent%E6%89%8B%E5%86%8C.md)
- [12-MCP配置与连接状态机](12-MCP%E9%85%8D%E7%BD%AE%E4%B8%8E%E8%BF%9E%E6%8E%A5%E7%8A%B6%E6%80%81%E6%9C%BA.md)
- [27-插件协议全生命周期：Manifest、Marketplace、Options、MCPB与Reload](27-%E6%8F%92%E4%BB%B6%E5%8D%8F%E8%AE%AE%E5%85%A8%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F%EF%BC%9AManifest%E3%80%81Marketplace%E3%80%81Options%E3%80%81MCPB%E4%B8%8EReload.md)
- [28-治理型API：Channels、Context Usage与Settings三重真相](28-%E6%B2%BB%E7%90%86%E5%9E%8BAPI%EF%BC%9AChannels%E3%80%81Context%20Usage%E4%B8%8ESettings%E4%B8%89%E9%87%8D%E7%9C%9F%E7%9B%B8.md)
- [13-StructuredIO与RemoteIO宿主协议手册](13-StructuredIO%E4%B8%8ERemoteIO%E5%AE%BF%E4%B8%BB%E5%8D%8F%E8%AE%AE%E6%89%8B%E5%86%8C.md)
- [14-Control子类型与宿主适配矩阵](14-Control%E5%AD%90%E7%B1%BB%E5%9E%8B%E4%B8%8E%E5%AE%BF%E4%B8%BB%E9%80%82%E9%85%8D%E7%9F%A9%E9%98%B5.md)
- [15-Control协议字段对照与宿主接入样例](15-Control%E5%8D%8F%E8%AE%AE%E5%AD%97%E6%AE%B5%E5%AF%B9%E7%85%A7%E4%B8%8E%E5%AE%BF%E4%B8%BB%E6%8E%A5%E5%85%A5%E6%A0%B7%E4%BE%8B.md)
- [16-SDK消息与Control闭环对照表](16-SDK%E6%B6%88%E6%81%AF%E4%B8%8EControl%E9%97%AD%E7%8E%AF%E5%AF%B9%E7%85%A7%E8%A1%A8.md)
- [22-插件、Marketplace、MCPB、LSP与Channels接入边界手册](22-%E6%8F%92%E4%BB%B6%E3%80%81Marketplace%E3%80%81MCPB%E3%80%81LSP%E4%B8%8EChannels%E6%8E%A5%E5%85%A5%E8%BE%B9%E7%95%8C%E6%89%8B%E5%86%8C.md)

### 6. 机制对象宿主消费面

- [49-Prompt编译与稳定性支持面手册：注入入口、协议转译、缓存断点与合法遗忘边界](49-Prompt%E7%BC%96%E8%AF%91%E4%B8%8E%E7%A8%B3%E5%AE%9A%E6%80%A7%E6%94%AF%E6%8C%81%E9%9D%A2%E6%89%8B%E5%86%8C%EF%BC%9A%E6%B3%A8%E5%85%A5%E5%85%A5%E5%8F%A3%E3%80%81%E5%8D%8F%E8%AE%AE%E8%BD%AC%E8%AF%91%E3%80%81%E7%BC%93%E5%AD%98%E6%96%AD%E7%82%B9%E4%B8%8E%E5%90%88%E6%B3%95%E9%81%97%E5%BF%98%E8%BE%B9%E7%95%8C.md)
- [50-治理控制面支持面手册：Settings、Permission、MCP、Context Usage、状态写回与继续门控](50-%E6%B2%BB%E7%90%86%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%94%AF%E6%8C%81%E9%9D%A2%E6%89%8B%E5%86%8C%EF%BC%9ASettings%E3%80%81Permission%E3%80%81MCP%E3%80%81Context%20Usage%E3%80%81%E7%8A%B6%E6%80%81%E5%86%99%E5%9B%9E%E4%B8%8E%E7%BB%A7%E7%BB%AD%E9%97%A8%E6%8E%A7.md)
- [51-编译请求真相宿主消费面手册：systemPrompt输入、section breakdown、cache break reason与continue qualification](51-%E7%BC%96%E8%AF%91%E8%AF%B7%E6%B1%82%E7%9C%9F%E7%9B%B8%E5%AE%BF%E4%B8%BB%E6%B6%88%E8%B4%B9%E9%9D%A2%E6%89%8B%E5%86%8C%EF%BC%9AsystemPrompt%E8%BE%93%E5%85%A5%E3%80%81section%20breakdown%E3%80%81cache%20break%20reason%E4%B8%8Econtinue%20qualification.md)
- [52-统一定价治理宿主消费面手册：authority source、decision window、pending action、rollback object与continuation gate](52-%E7%BB%9F%E4%B8%80%E5%AE%9A%E4%BB%B7%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E6%B6%88%E8%B4%B9%E9%9D%A2%E6%89%8B%E5%86%8C%EF%BC%9Aauthority%20source%E3%80%81decision%20window%E3%80%81pending%20action%E3%80%81rollback%20object%E4%B8%8Econtinuation%20gate.md)
- [53-故障模型宿主消费面手册：authority state、generation evidence、recovery boundary与anti-zombie projection](53-%E6%95%85%E9%9A%9C%E6%A8%A1%E5%9E%8B%E5%AE%BF%E4%B8%BB%E6%B6%88%E8%B4%B9%E9%9D%A2%E6%89%8B%E5%86%8C%EF%BC%9Aauthority%20state%E3%80%81generation%20evidence%E3%80%81recovery%20boundary%E4%B8%8Eanti-zombie%20projection.md)
- [54-Prompt宿主验收协议：compiled request truth、section registry、protocol transcript health与continue qualification](54-Prompt%E5%AE%BF%E4%B8%BB%E9%AA%8C%E6%94%B6%E5%8D%8F%E8%AE%AE%EF%BC%9Acompiled%20request%20truth%E3%80%81section%20registry%E3%80%81protocol%20transcript%20health%E4%B8%8Econtinue%20qualification.md)
- [55-治理宿主验收协议：authority source、permission ledger、decision window、continuation gate与rollback object](55-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E9%AA%8C%E6%94%B6%E5%8D%8F%E8%AE%AE%EF%BC%9Aauthority%20source%E3%80%81permission%20ledger%E3%80%81decision%20window%E3%80%81continuation%20gate%E4%B8%8Erollback%20object.md)
- [56-结构宿主验收协议：authority state、resume order、recovery boundary、writeback path与anti-zombie projection](56-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E9%AA%8C%E6%94%B6%E5%8D%8F%E8%AE%AE%EF%BC%9Aauthority%20state%E3%80%81resume%20order%E3%80%81recovery%20boundary%E3%80%81writeback%20path%E4%B8%8Eanti-zombie%20projection.md)
- [57-Prompt宿主修复协议：repair object、reject escalation、rollback boundary与re-entry qualification](57-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E5%8D%8F%E8%AE%AE%EF%BC%9Arepair%20object%E3%80%81reject%20escalation%E3%80%81rollback%20boundary%E4%B8%8Ere-entry%20qualification.md)
- [58-治理宿主修复协议：authority repair、ledger rebuild、decision window reset、continuation repricing与rollback object](58-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E5%8D%8F%E8%AE%AE%EF%BC%9Aauthority%20repair%E3%80%81ledger%20rebuild%E3%80%81decision%20window%20reset%E3%80%81continuation%20repricing%E4%B8%8Erollback%20object.md)
- [59-结构宿主修复协议：authority recovery、resume replay order、writeback restoration、anti-zombie verdict与boundary reset](59-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E5%8D%8F%E8%AE%AE%EF%BC%9Aauthority%20recovery%E3%80%81resume%20replay%20order%E3%80%81writeback%20restoration%E3%80%81anti-zombie%20verdict%E4%B8%8Eboundary%20reset.md)
- [60-Prompt宿主修复收口协议：restored request object、protocol truth witness、rollback witness与re-entry warranty](60-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E6%94%B6%E5%8F%A3%E5%8D%8F%E8%AE%AE%EF%BC%9Arestored%20request%20object%E3%80%81protocol%20truth%20witness%E3%80%81rollback%20witness%E4%B8%8Ere-entry%20warranty.md)
- [61-治理宿主修复收口协议：authority settlement、ledger seal、window closure、continuation warranty与rollback clearance](61-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E6%94%B6%E5%8F%A3%E5%8D%8F%E8%AE%AE%EF%BC%9Aauthority%20settlement%E3%80%81ledger%20seal%E3%80%81window%20closure%E3%80%81continuation%20warranty%E4%B8%8Erollback%20clearance.md)
- [62-结构宿主修复收口协议：authority seal、writeback seal、anti-zombie witness与boundary closure](62-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E6%94%B6%E5%8F%A3%E5%8D%8F%E8%AE%AE%EF%BC%9Aauthority%20seal%E3%80%81writeback%20seal%E3%80%81anti-zombie%20witness%E4%B8%8Eboundary%20closure.md)
- [63-Prompt宿主修复监护协议：watch window、handoff watch、baseline drift ledger与reopen gate](63-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%9B%91%E6%8A%A4%E5%8D%8F%E8%AE%AE%EF%BC%9Awatch%20window%E3%80%81handoff%20watch%E3%80%81baseline%20drift%20ledger%E4%B8%8Ereopen%20gate.md)
- [64-治理宿主修复监护协议：authority watch、ledger residue、window watch、continuation repricing与rollback quarantine](64-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%9B%91%E6%8A%A4%E5%8D%8F%E8%AE%AE%EF%BC%9Aauthority%20watch%E3%80%81ledger%20residue%E3%80%81window%20watch%E3%80%81continuation%20repricing%E4%B8%8Erollback%20quarantine.md)
- [65-结构宿主修复监护协议：authority watch、writeback watch、anti-zombie watch与boundary quarantine](65-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%9B%91%E6%8A%A4%E5%8D%8F%E8%AE%AE%EF%BC%9Aauthority%20watch%E3%80%81writeback%20watch%E3%80%81anti-zombie%20watch%E4%B8%8Eboundary%20quarantine.md)
- [66-Prompt宿主修复解除监护协议：watch release object、stability witness、baseline drift ledger seal、continuation clearance、handoff release warranty与reopen residual gate](66-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E8%A7%A3%E9%99%A4%E7%9B%91%E6%8A%A4%E5%8D%8F%E8%AE%AE%EF%BC%9Awatch%20release%20object%E3%80%81stability%20witness%E3%80%81baseline%20drift%20ledger%20seal%E3%80%81continuation%20clearance%E3%80%81handoff%20release%20warranty%E4%B8%8Ereopen%20residual%20gate.md)
- [67-治理宿主修复解除监护协议：authority release、ledger residue clearance、window exit、continuation settlement、quarantine release与reopen liability](67-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E8%A7%A3%E9%99%A4%E7%9B%91%E6%8A%A4%E5%8D%8F%E8%AE%AE%EF%BC%9Aauthority%20release%E3%80%81ledger%20residue%20clearance%E3%80%81window%20exit%E3%80%81continuation%20settlement%E3%80%81quarantine%20release%E4%B8%8Ereopen%20liability.md)
- [68-结构宿主修复解除监护协议：authority release、resume stability seal、writeback release、anti-zombie archive与boundary retirement](68-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E8%A7%A3%E9%99%A4%E7%9B%91%E6%8A%A4%E5%8D%8F%E8%AE%AE%EF%BC%9Aauthority%20release%E3%80%81resume%20stability%20seal%E3%80%81writeback%20release%E3%80%81anti-zombie%20archive%E4%B8%8Eboundary%20retirement.md)
- [69-Prompt宿主修复稳态协议：truth continuity、stable prefix custody、baseline dormancy seal、continuation eligibility、handoff continuity与reopen threshold](69-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E5%8D%8F%E8%AE%AE%EF%BC%9Atruth%20continuity%E3%80%81stable%20prefix%20custody%E3%80%81baseline%20dormancy%20seal%E3%80%81continuation%20eligibility%E3%80%81handoff%20continuity%E4%B8%8Ereopen%20threshold.md)
- [70-治理宿主修复稳态协议：authority continuity、ledger dormancy seal、window dormancy、continuation pricing covenant、capability custody与reopen threshold](70-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E5%8D%8F%E8%AE%AE%EF%BC%9Aauthority%20continuity%E3%80%81ledger%20dormancy%20seal%E3%80%81window%20dormancy%E3%80%81continuation%20pricing%20covenant%E3%80%81capability%20custody%E4%B8%8Ereopen%20threshold.md)
- [71-结构宿主修复稳态协议：authority continuity、writeback custody、resume continuity seal、anti-zombie dormancy、archive truth与reopen reservation boundary](71-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E5%8D%8F%E8%AE%AE%EF%BC%9Aauthority%20continuity%E3%80%81writeback%20custody%E3%80%81resume%20continuity%20seal%E3%80%81anti-zombie%20dormancy%E3%80%81archive%20truth%E4%B8%8Ereopen%20reservation%20boundary.md)
- [72-Prompt宿主修复稳态纠偏协议：truth continuity recovery、stable prefix recustody、baseline dormancy reseal、continuation requalification、handoff continuity repair与reopen threshold reinstatement](72-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%8D%8F%E8%AE%AE%EF%BC%9Atruth%20continuity%20recovery%E3%80%81stable%20prefix%20recustody%E3%80%81baseline%20dormancy%20reseal%E3%80%81continuation%20requalification%E3%80%81handoff%20continuity%20repair%E4%B8%8Ereopen%20threshold%20reinstatement.md)
- [73-治理宿主修复稳态纠偏协议：authority reassertion、ledger reseal、window refreeze、continuation repricing、capability recustody与reopen threshold rebinding](73-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%8D%8F%E8%AE%AE%EF%BC%9Aauthority%20reassertion%E3%80%81ledger%20reseal%E3%80%81window%20refreeze%E3%80%81continuation%20repricing%E3%80%81capability%20recustody%E4%B8%8Ereopen%20threshold%20rebinding.md)
- [74-结构宿主修复稳态纠偏协议：authority rebind、resume lineage rebuild、writeback recustody、anti-zombie reproof、archive truth restitution与reopen reservation rebinding](74-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%8D%8F%E8%AE%AE%EF%BC%9Aauthority%20rebind%E3%80%81resume%20lineage%20rebuild%E3%80%81writeback%20recustody%E3%80%81anti-zombie%20reproof%E3%80%81archive%20truth%20restitution%E4%B8%8Ereopen%20reservation%20rebinding.md)
- [75-Prompt宿主修复稳态纠偏再纠偏协议：compiled request truth restitution、protocol transcript repair、lawful forgetting reseal、continuation requalification rebinding与threshold liability reinstatement](75-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E5%8D%8F%E8%AE%AE%EF%BC%9Acompiled%20request%20truth%20restitution%E3%80%81protocol%20transcript%20repair%E3%80%81lawful%20forgetting%20reseal%E3%80%81continuation%20requalification%20rebinding%E4%B8%8Ethreshold%20liability%20reinstatement.md)
- [76-治理宿主修复稳态纠偏再纠偏协议：authority source restitution、ledger reseal、decision window refreeze、continuation pricing rebinding、capability liability recustody与threshold rebinding](76-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E5%8D%8F%E8%AE%AE%EF%BC%9Aauthority%20source%20restitution%E3%80%81ledger%20reseal%E3%80%81decision%20window%20refreeze%E3%80%81continuation%20pricing%20rebinding%E3%80%81capability%20liability%20recustody%E4%B8%8Ethreshold%20rebinding.md)
- [77-结构宿主修复稳态纠偏再纠偏协议：authority surface restitution、single-source reseal、resume lineage reproof、writeback custody rebinding、anti-zombie evidence restitution与reservation liability rebinding](77-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E5%8D%8F%E8%AE%AE%EF%BC%9Aauthority%20surface%20restitution%E3%80%81single-source%20reseal%E3%80%81resume%20lineage%20reproof%E3%80%81writeback%20custody%20rebinding%E3%80%81anti-zombie%20evidence%20restitution%E4%B8%8Ereservation%20liability%20rebinding.md)
- [78-Prompt宿主修复稳态纠偏再纠偏改写协议：compiled request truth restitution、protocol transcript repair、stable prefix reseal、lawful forgetting reseal、continuation requalification与threshold liability reinstatement](78-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E5%8D%8F%E8%AE%AE%EF%BC%9Acompiled%20request%20truth%20restitution%E3%80%81protocol%20transcript%20repair%E3%80%81stable%20prefix%20reseal%E3%80%81lawful%20forgetting%20reseal%E3%80%81continuation%20requalification%E4%B8%8Ethreshold%20liability%20reinstatement.md)
- [79-治理宿主修复稳态纠偏再纠偏改写协议：authority source restitution、ledger reseal、decision window refreeze、continuation pricing rebinding、capability liability recustody与threshold rebinding](79-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E5%8D%8F%E8%AE%AE%EF%BC%9Aauthority%20source%20restitution%E3%80%81ledger%20reseal%E3%80%81decision%20window%20refreeze%E3%80%81continuation%20pricing%20rebinding%E3%80%81capability%20liability%20recustody%E4%B8%8Ethreshold%20rebinding.md)
- [80-结构宿主修复稳态纠偏再纠偏改写协议：authority surface restitution、single-source writeback seam、lineage reproof、anti-zombie evidence restitution与reopen liability rebinding](80-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E5%8D%8F%E8%AE%AE%EF%BC%9Aauthority%20surface%20restitution%E3%80%81single-source%20writeback%20seam%E3%80%81lineage%20reproof%E3%80%81anti-zombie%20evidence%20restitution%E4%B8%8Ereopen%20liability%20rebinding.md)
- [81-Prompt宿主修复稳态纠偏再纠偏改写纠偏协议：compiled request truth、section registry与threshold liability](81-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E5%8D%8F%E8%AE%AE%EF%BC%9Acompiled%20request%20truth%E3%80%81section%20registry%E4%B8%8Ethreshold%20liability.md)
- [82-治理宿主修复稳态纠偏再纠偏改写纠偏协议：authority、window、pricing与threshold](82-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E5%8D%8F%E8%AE%AE%EF%BC%9Aauthority%E3%80%81window%E3%80%81pricing%E4%B8%8Ethreshold.md)
- [83-结构宿主修复稳态纠偏再纠偏改写纠偏协议：authority、lineage、transport与reopen liability](83-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E5%8D%8F%E8%AE%AE%EF%BC%9Aauthority%E3%80%81lineage%E3%80%81transport%E4%B8%8Ereopen%20liability.md)
- [84-Prompt宿主修复稳态纠偏再纠偏改写纠偏精修协议：lineage、registry boundary与reopen liability](84-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E7%B2%BE%E4%BF%AE%E5%8D%8F%E8%AE%AE%EF%BC%9Alineage%E3%80%81registry%20boundary%E4%B8%8Ereopen%20liability.md)
- [85-治理宿主修复稳态纠偏再纠偏改写纠偏精修协议：ledger、writeback seam与reopen liability](85-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E7%B2%BE%E4%BF%AE%E5%8D%8F%E8%AE%AE%EF%BC%9Aledger%E3%80%81writeback%20seam%E4%B8%8Ereopen%20liability.md)
- [86-结构宿主修复稳态纠偏再纠偏改写纠偏精修协议：authority、fresh merge与reopen liability](86-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E7%B2%BE%E4%BF%AE%E5%8D%8F%E8%AE%AE%EF%BC%9Aauthority%E3%80%81fresh%20merge%E4%B8%8Ereopen%20liability.md)
- [87-Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏协议：authority chain、registry-boundary、synthesis custody与long-term reopen liability](87-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E7%B2%BE%E4%BF%AE%E7%BA%A0%E5%81%8F%E5%8D%8F%E8%AE%AE%EF%BC%9Aauthority%20chain%E3%80%81registry-boundary%E3%80%81synthesis%20custody%E4%B8%8Elong-term%20reopen%20liability.md)
- [88-治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏协议：authority chain、window truth、classifier pricing与long-term reopen liability](88-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E7%B2%BE%E4%BF%AE%E7%BA%A0%E5%81%8F%E5%8D%8F%E8%AE%AE%EF%BC%9Aauthority%20chain%E3%80%81window%20truth%E3%80%81classifier%20pricing%E4%B8%8Elong-term%20reopen%20liability.md)
- [89-结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏协议：authority surface、fresh merge、anti-zombie与long-term reopen liability](89-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E7%B2%BE%E4%BF%AE%E7%BA%A0%E5%81%8F%E5%8D%8F%E8%AE%AE%EF%BC%9Aauthority%20surface%E3%80%81fresh%20merge%E3%80%81anti-zombie%E4%B8%8Elong-term%20reopen%20liability.md)
- [90-Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修协议：authority chain、protocol truth、repair attestation与long-term reopen liability](90-Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修协议：authority%20chain、protocol%20truth、repair%20attestation与long-term%20reopen%20liability.md)
- [91-治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修协议：authority chain、pricing causality、writeback seam与long-term reopen liability](91-治理宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修协议：authority%20chain、pricing%20causality、writeback%20seam与long-term%20reopen%20liability.md)
- [92-结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修协议：authority surface、fresh merge、fail-closed与long-term reopen liability](92-结构宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修协议：authority%20surface、fresh%20merge、fail-closed与long-term%20reopen%20liability.md)

## 按接入任务阅读

### 1. 想知道能不能接

- 先读 `23 -> 24 -> 25 -> 29 -> 30 -> 01 -> 05 -> 07`
- 目标：先分清表面、字段和 availability，再决定是否落地

### 2. 想把 Claude Code 嵌进宿主

- 先读 `24 -> 26 -> 02 -> 13 -> 15 -> 16 -> 20`
- 补充 `11 -> 17 -> 19 -> 31 -> 32 -> 33 -> 34 -> 35 -> 36`
- 想把宿主卡、CI附件、评审卡与交接包继续压成统一工件协议：`35 -> 36 -> 37 -> 38 -> 39 -> ../navigation/26`
- 想把 Prompt 构建层继续回灌成可消费的编译/稳定性支持面，而不是把内部编译细节误当公共 ABI：`18 -> 21 -> 49 -> ../architecture/79`
- 想把 Settings、Permission、MCP、Context Usage 与状态写回继续收口成统一治理支持面，而不是只把它们当分散 control request：`28 -> 32 -> 35 -> 50 -> ../architecture/80`
- 想让宿主直接围绕编译请求真相消费 section breakdown、message breakdown 与 continue qualification，而不是继续猜 prompt 黑箱：`49 -> 51 -> ../navigation/43`
- 想让宿主直接围绕 authority source、decision window、pending action、rollback object 与 continuation gate 组织治理面板与交接：`50 -> 52 -> ../navigation/43`
- 想让宿主直接围绕 authority state、generation evidence、recovery boundary 与 anti-zombie projection 组织恢复与回退，而不是继续看目录图和恢复成功率：`53 -> ../navigation/43`
- 想把这些纠偏顺序继续压成宿主、SDK、CI 与交接都能共享的验收卡与拒收协议，而不是继续停在 builder 心里：`../navigation/50 -> 54 -> 55 -> 56 -> ../guides/57 -> ../guides/58 -> ../guides/59`
- 想把这些执行纠偏继续压成宿主、SDK、CI、评审与交接都能共享的修复卡、reject 升级语义与重入规则，而不是继续停在 builder 心里：`../navigation/54 -> 57 -> 58 -> 59 -> ../guides/60 -> ../guides/61 -> ../guides/62`
- 想把这些修复纠偏继续压成宿主、SDK、CI、评审与交接都能共享的收口卡、完成语义与交接保证面，而不是继续停在 builder 心里：`../navigation/58 -> 60 -> 61 -> 62 -> ../guides/63 -> ../guides/64 -> ../guides/65`
- 想把这些收口纠偏继续压成宿主、SDK、CI、评审与交接都能共享的监护窗口、漂移观察与重开闸门面，而不是继续停在 builder 心里：`../navigation/62 -> 63 -> 64 -> 65 -> ../guides/66 -> ../guides/67 -> ../guides/68`
- 想把这些监护纠偏继续压成宿主、SDK、CI、评审与交接都能共享的解除判定、稳定释压、解除隔离、归档保证与 residual reopen 责任面，而不是继续停在 builder 心里：`../navigation/66 -> 66 -> 67 -> 68 -> ../guides/69 -> ../guides/70 -> ../guides/71`
- 想把这些解除监护纠偏继续压成宿主、SDK、CI、评审与交接都能共享的稳态协议，而不是继续靠 summary、dashboard 与 pointer 维持 released 幻觉：`../navigation/70 -> 69 -> 70 -> 71 -> ../guides/72 -> ../guides/73 -> ../guides/74`
- 想把这些稳态协议继续压成宿主、SDK、CI、评审与交接都能共享的巡检卡、稳态判定顺序、再入场阈值与 residual reopen 责任演练，而不是继续停在 contract 字段层：`../navigation/71 -> ../playbooks/50 -> ../playbooks/51 -> ../playbooks/52`
- 想把这些稳态纠偏继续压成宿主、SDK、CI、评审与交接都能共享的修正对象、拒收升级语义与长期 reopen 责任面，而不是继续停在 builder 心里：`../navigation/74 -> 72 -> 73 -> 74 -> ../guides/75 -> ../guides/76 -> ../guides/77`
- 想把这些纠偏规则面继续压成固定 correction card、reject 顺序与 re-entry / reopen 责任演练，而不是继续停在 contract 字段层：`../navigation/75 -> ../playbooks/53 -> ../playbooks/54 -> ../playbooks/55`
- 想把这些稳态纠偏执行失真继续压成宿主、SDK、CI、评审与交接都能共享的再纠偏对象、拒收升级语义与长期 reopen 责任面，而不是继续把 correction prose、mode 平静感与 pointer 健康感误当恢复对象：`../navigation/78 -> 75 -> 76 -> 77 -> ../guides/78 -> ../guides/79 -> ../guides/80`
- 想把这些再纠偏协议继续压成宿主、SDK、CI、评审与交接都能共享的 recorrection card、reject 顺序与 re-entry / reopen 责任演练，而不是继续停在 rule surface 字段层：`../navigation/79 -> ../playbooks/56 -> ../playbooks/57 -> ../playbooks/58`
- 想继续看这些再纠偏执行为什么仍会重新退回假 recorrection card、假 reject 顺序与假 reopen 责任演练，而不是误把 recorrection card 当成正式恢复证明：`../navigation/80 -> ../casebooks/52 -> ../casebooks/53 -> ../casebooks/54`
- 想把这些再纠偏改写纠偏继续压成宿主、SDK、CI、评审与交接都能共享的 rewrite correction 对象、拒收语义与长期 reopen 责任面，而不是继续把 rewrite prose、dashboard 平静感与 pointer 健康感误当终态协议：`../navigation/86 -> 81 -> 82 -> 83 -> ../guides/84 -> ../guides/85 -> ../guides/86`
- 想把这些 rewrite correction 固定顺序继续压成宿主、SDK、CI、评审与交接都能共同消费的对象、hard reject 语义与长期 reopen 责任账本，而不是继续停在 builder-facing 模板层：`../navigation/90 -> 84 -> 85 -> 86`
- 想把 validator / linter 继续压成 machine-readable rule ABI：`../navigation/30 -> 40 -> 41 -> 42 -> ../philosophy/71`
- 想把这些 rule packet 继续压成最小规则样例、失败样例与 evaluator 接口：`../navigation/31 -> ../playbooks/20 -> ../playbooks/21 -> ../playbooks/22 -> ../philosophy/72`
- 想把这些样例接口继续接成 replay harness、cross-consumer alignment 与 drift regression lab：`../navigation/32 -> ../playbooks/23 -> ../playbooks/24 -> ../playbooks/25 -> ../philosophy/73`
- 想把这些实验室继续接成 replay queue、drift ledger 与 rewrite adoption 的持续执行协议：`../navigation/33 -> 43 -> 44 -> 45 -> ../architecture/78 -> ../philosophy/74`
- 想把源码顶层地图继续压成二级目录 atlas，而不是继续停在一级目录概览：`../navigation/35 -> 46 -> 47 -> 48 -> ../philosophy/76`
- 目标：把 request / response / follow-on event / snapshot / recovery 一起看成闭环

### 3. 想控制 prompt、知识和记忆

- 先读 `18 -> 21`
- 再连到 `../architecture/18 -> ../architecture/28 -> ../architecture/29`

### 4. 想接扩展、插件和 MCP

- 先读 `03 -> 10 -> 12`
- 再读 `22 -> 27 -> 28`
- 最后回到 `../architecture/03 -> ../architecture/27 -> ../philosophy/20`

### 5. 想先搞清“支持了什么”与“承诺了什么”

- 先读 `23 -> 24 -> 29 -> 30`
- 再回到 `../08`
- 最后按具体平面跳转到命令、宿主、状态、扩展任一专题

## 写作约束

- `query(prompt)` 不代表全部 SDK 面。
- 代码里有 schema，不等于所有 adapter 都支持。
- 有类型声明，不等于当前提取树里已有完整实现。
- 有实现，不等于产品公开承诺稳定支持。
- 关键状态应先找 authoritative surface，再找调用点散布。
- internal compiler surface 不等于公共 ABI。
- 内部 continuation / classifier 细节不应被宿主直接依赖。
- 再往下一层，应由 `../navigation/26 -> 37-39` 继续回答“怎样把统一审读对象压成正式共享工件协议”。
- 再往下一层，应由 `../navigation/30 -> 40-42` 继续回答“怎样把 hard fail、lint warn、reviewer gate、handoff reject 与 rewrite hint 压成 machine-readable rule packet”。
- 再往下一层，应由 `../navigation/31 -> ../playbooks/20-22` 继续回答“怎样把 machine-readable rule packet 写成最小可验证样例与 evaluator 样例”。
- 再往下一层，应由 `../navigation/32 -> ../playbooks/23-25` 继续回答“怎样把这些 evaluator 样例接成可重放验证与跨消费者对齐实验室”。
- 再往下一层，应由 `../navigation/33 -> 43-45 -> ../architecture/78` 继续回答“怎样把 replay case、alignment assertion、drift ledger 与 rewrite adoption 接成持续执行协议与底盘”。
- 再往下一层，应由 `../navigation/35 -> 46-48 -> ../philosophy/76` 继续回答“怎样把顶层目录地图继续拆成二级目录 atlas，并显式暴露权威入口、消费者子集与危险改动面”。
- 再往下一层，应由 `../navigation/38 -> 49-50 -> ../architecture/79-80` 继续回答“怎样把 builder-facing 方法线重新压成可消费支持面与机制对象”。
- 再往下一层，应由 `../navigation/43 -> 51-53` 继续回答“怎样把机制对象的实现顺序继续压成宿主、SDK、CI 与交接真正可消费的支持面，而不重新绑死内部实现”。
- 再往下一层，应由 `../navigation/50 -> 54-56` 继续回答“怎样把迁移纠偏继续压成宿主可消费的验收卡、拒收语义与规则面”。
- 再往下一层，应由 `../navigation/54 -> 57-59` 继续回答“怎样把执行纠偏继续压成宿主可消费的修复卡、reject escalation 与 rollback 重入规则面”。
- 再往下一层，应由 `../navigation/62 -> 63-65` 继续回答“怎样把收口纠偏继续压成宿主可消费的监护窗口、漂移观察与重开闸门面”。
- 再往下一层，应由 `../navigation/66 -> 66-68` 继续回答“怎样把监护纠偏继续压成宿主可消费的解除判定、稳定释压、解除隔离、归档保证与 residual reopen 责任面”。
- 再往下一层，应由 `../navigation/70 -> 69-71` 继续回答“怎样把解除监护纠偏继续压成宿主可消费的无人盯防延续、继续定价、写回托管与 residual reopen threshold 面”。
- 再往下一层，应由 `../navigation/71 -> ../playbooks/50-52` 继续回答“怎样把稳态协议继续压成宿主、CI、评审与交接共享的巡检卡、稳态判定顺序与再入场责任演练”。
- 再往下一层，应由 `../navigation/74 -> 72-74` 继续回答“怎样把稳态纠偏继续压成宿主、SDK、CI、评审与交接共享的修正对象、拒收升级语义与长期 reopen 责任面”。
- 再往下一层，应由 `../navigation/75 -> ../playbooks/53-55` 继续回答“怎样把这些纠偏规则面继续压成固定 correction card、reject 顺序与 re-entry / reopen 责任演练”。
- `../navigation/78 -> 75-77` 继续回答“怎样把这些稳态纠偏再纠偏继续压成宿主、SDK、CI、评审与交接共享的修正对象、拒收升级语义与长期 reopen 责任面”。
- `../navigation/79 -> ../playbooks/56-58` 继续回答“怎样把这些再纠偏规则面继续压成固定 recorrection card、reject 顺序与 re-entry / reopen 责任演练”。
- 再往下一层，应由 `../navigation/80 -> ../casebooks/52-54` 继续回答“为什么这些再纠偏执行明明已经存在，仍会重新退回假 recorrection card、假 reject 顺序与假 reopen 责任演练”。
- 再往下一层，应由 `../navigation/81 -> ../guides/81-83` 继续回答“怎样把这些再纠偏执行失真重新压回固定顺序、拒收升级路径与改写模板骨架”。
- 再往下一层，应由 `../navigation/82 -> ../api/78-80` 继续回答“怎样把这些再纠偏改写继续压成宿主可消费的修正对象、拒收语义与长期 reopen 责任面”。
- 再往下一层，应由 `../navigation/83 -> ../playbooks/59-61` 继续回答“怎样把这些再纠偏改写协议继续压成固定 rewrite card、reject 顺序与 re-entry / reopen 责任演练”。
- 再往下一层，应由 `../navigation/86 -> 81-83` 继续回答“怎样把这些再纠偏改写纠偏继续压成宿主可消费的 rewrite correction 对象、拒收语义与长期 reopen 责任面”。
- 再往下一层，应由 `../navigation/87 -> ../playbooks/62-64` 继续回答“怎样把这些 rewrite correction protocol 继续压成固定 rewrite correction card、reject 顺序与 re-entry / reopen 责任演练”。
- 再往下一层，应由 `../navigation/88 -> ../casebooks/58-60` 继续回答“为什么这些 rewrite correction execution 明明已经存在，仍会重新退回假 rewrite correction card、假 reject 顺序与假 reopen 责任演练”。
- 再往下一层，应由 `../navigation/89 -> ../guides/87-89` 继续回答“怎样把这些 rewrite correction execution 失真重新压回固定 rewrite correction 顺序、拒收升级路径与改写模板骨架”。
- 再往下一层，应由 `../navigation/90 -> 84-86` 继续回答“怎样把这些 rewrite correction 固定顺序继续压成宿主可消费对象、hard reject 语义与长期 reopen 责任账本”。
- `../navigation/91 -> ../playbooks/65-67` 继续回答“怎样把这些 rewrite correction 精修协议继续压成固定宿主消费卡、hard reject 顺序与 reopen 责任演练”。
- `../navigation/92 -> ../casebooks/61-63` 继续回答“为什么这些 refinement execution 明明已经存在，仍会重新退回假 host consumption card、假 hard reject 顺序与假 reopen 责任演练”。
- `../navigation/93 -> ../guides/90-92` 继续回答“怎样把这些 refinement execution 失真重新压回固定 refinement 顺序、拒收升级路径与改写模板骨架”。
- `../navigation/94 -> ../api/87-89` 继续回答“怎样把这些 refinement correction 继续压成宿主可消费的修正对象、拒收语义与长期 reopen 责任面”。
- `../navigation/95 -> ../playbooks/68-70` 继续回答“怎样把这些 refinement correction protocol 继续压成固定 repair card、reject 顺序与 reopen 责任演练”。
- `../navigation/96 -> ../casebooks/64-66` 继续回答“为什么这些 refinement correction execution 明明已经存在，仍会重新退回假 repair card、假 reject 顺序与假 reopen 责任演练”。
- `../navigation/97 -> ../guides/93-95` 继续回答“怎样把这些 refinement correction execution 失真重新压回固定 refinement correction 顺序、拒收升级路径与改写模板骨架”。
- `../navigation/98 -> 90-92` 继续回答“怎样把这些 refinement correction fixed order 继续压成宿主可消费的 repair 对象、共同 reject 语义与长期 reopen 责任面”。
- 再往下一层，应由 `../navigation/99 -> ../playbooks/71-73` 继续回答“怎样把这些 refinement correction repair protocol 继续压成固定 repair card、共同 reject 顺序与 reopen 责任演练”。
- 机制对象宿主消费面不等于内部实现面。
- host-consumable projection 不等于 internal compiler / internal fault-model trace。

主线结论先看 [../05-功能全景与 API 支持](../05-%E5%8A%9F%E8%83%BD%E5%85%A8%E6%99%AF%E4%B8%8EAPI%E6%94%AF%E6%8C%81.md)。
