# API 文档

本目录的目标不是机械抄类型，而是回答四个问题：

1. Claude Code 公开了哪些正式能力表面。
2. 这些能力分别通过命令、工具、事件流、控制协议、状态接口还是扩展接口暴露。
3. 哪些是稳定主路径，哪些只是 gate、consumer subset 或适配器子集。
4. 宿主开发者到底该按什么顺序接入。

## API 目录的六个平面

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

### 4. Prompt、知识与上下文装配面

- [18-系统提示词、Frontmatter与上下文注入手册](18-%E7%B3%BB%E7%BB%9F%E6%8F%90%E7%A4%BA%E8%AF%8D%E3%80%81Frontmatter%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E6%B3%A8%E5%85%A5%E6%89%8B%E5%86%8C.md)
- [21-提示词控制、知识注入与记忆API手册](21-%E6%8F%90%E7%A4%BA%E8%AF%8D%E6%8E%A7%E5%88%B6%E3%80%81%E7%9F%A5%E8%AF%86%E6%B3%A8%E5%85%A5%E4%B8%8E%E8%AE%B0%E5%BF%86API%E6%89%8B%E5%86%8C.md)

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

## 按接入任务阅读

### 1. 想知道能不能接

- 先读 `23 -> 24 -> 25 -> 29 -> 30 -> 01 -> 05 -> 07`
- 目标：先分清表面、字段和 availability，再决定是否落地

### 2. 想把 Claude Code 嵌进宿主

- 先读 `24 -> 26 -> 02 -> 13 -> 15 -> 16 -> 20`
- 补充 `11 -> 17 -> 19 -> 31 -> 32 -> 33 -> 34 -> 35`
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

主线结论先看 [../05-功能全景与 API 支持](../05-%E5%8A%9F%E8%83%BD%E5%85%A8%E6%99%AF%E4%B8%8EAPI%E6%94%AF%E6%8C%81.md)。
