# API 文档

本目录不追求“列出所有类型名”，而是回答三个问题：

1. Claude Code 有哪些正式能力表面。
2. 这些能力通过什么接口暴露。
3. 哪些接口是 runtime 主路径，哪些只是 gated/internal 痕迹。

当前目录建议按五组理解：

## 命令与控制面

- [命令与功能矩阵](01-%E5%91%BD%E4%BB%A4%E4%B8%8E%E5%8A%9F%E8%83%BD%E7%9F%A9%E9%98%B5.md)
- [控制请求与响应矩阵](05-%E6%8E%A7%E5%88%B6%E8%AF%B7%E6%B1%82%E4%B8%8E%E5%93%8D%E5%BA%94%E7%9F%A9%E9%98%B5.md)
- [内置命令域索引](06-%E5%86%85%E7%BD%AE%E5%91%BD%E4%BB%A4%E5%9F%9F%E7%B4%A2%E5%BC%95.md)
- [命令字段与可用性索引](07-%E5%91%BD%E4%BB%A4%E5%AD%97%E6%AE%B5%E4%B8%8E%E5%8F%AF%E7%94%A8%E6%80%A7%E7%B4%A2%E5%BC%95.md)

## 运行与工具面

- [Agent SDK 与控制协议](02-Agent%20SDK%E4%B8%8E%E6%8E%A7%E5%88%B6%E5%8D%8F%E8%AE%AE.md)
- [工具协议与 ToolUseContext](08-%E5%B7%A5%E5%85%B7%E5%8D%8F%E8%AE%AE%E4%B8%8EToolUseContext.md)

## 状态与事件面

- [SDK 消息与事件字典](04-SDK%E6%B6%88%E6%81%AF%E4%B8%8E%E4%BA%8B%E4%BB%B6%E5%AD%97%E5%85%B8.md)
- [会话与状态 API 手册](09-%E4%BC%9A%E8%AF%9D%E4%B8%8E%E7%8A%B6%E6%80%81API%E6%89%8B%E5%86%8C.md)
- [SDKMessageSchema 与事件流手册](11-SDKMessageSchema%E4%B8%8E%E4%BA%8B%E4%BB%B6%E6%B5%81%E6%89%8B%E5%86%8C.md)
- [状态消息、外部元数据与宿主消费矩阵](17-%E7%8A%B6%E6%80%81%E6%B6%88%E6%81%AF%E3%80%81%E5%A4%96%E9%83%A8%E5%85%83%E6%95%B0%E6%8D%AE%E4%B8%8E%E5%AE%BF%E4%B8%BB%E6%B6%88%E8%B4%B9%E7%9F%A9%E9%98%B5.md)
- [SDKMessage、worker_status 与 external_metadata 字段级对照手册](19-SDKMessage%E3%80%81worker_status%E4%B8%8Eexternal_metadata%E5%AD%97%E6%AE%B5%E7%BA%A7%E5%AF%B9%E7%85%A7%E6%89%8B%E5%86%8C.md)

## 提示词与上下文装配面

- [系统提示词、Frontmatter 与上下文注入手册](18-%E7%B3%BB%E7%BB%9F%E6%8F%90%E7%A4%BA%E8%AF%8D%E3%80%81Frontmatter%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E6%B3%A8%E5%85%A5%E6%89%8B%E5%86%8C.md)

## 扩展与连接面

- [MCP 与远程传输](03-MCP%E4%B8%8E%E8%BF%9C%E7%A8%8B%E4%BC%A0%E8%BE%93.md)
- [扩展 Frontmatter 与插件 Agent 手册](10-%E6%89%A9%E5%B1%95Frontmatter%E4%B8%8E%E6%8F%92%E4%BB%B6Agent%E6%89%8B%E5%86%8C.md)
- [MCP 配置与连接状态机](12-MCP%E9%85%8D%E7%BD%AE%E4%B8%8E%E8%BF%9E%E6%8E%A5%E7%8A%B6%E6%80%81%E6%9C%BA.md)

## 宿主与传输面

- [StructuredIO 与 RemoteIO 宿主协议手册](13-StructuredIO%E4%B8%8ERemoteIO%E5%AE%BF%E4%B8%BB%E5%8D%8F%E8%AE%AE%E6%89%8B%E5%86%8C.md)
- [Control 子类型与宿主适配矩阵](14-Control%E5%AD%90%E7%B1%BB%E5%9E%8B%E4%B8%8E%E5%AE%BF%E4%B8%BB%E9%80%82%E9%85%8D%E7%9F%A9%E9%98%B5.md)
- [Control 协议字段对照与宿主接入样例](15-Control%E5%8D%8F%E8%AE%AE%E5%AD%97%E6%AE%B5%E5%AF%B9%E7%85%A7%E4%B8%8E%E5%AE%BF%E4%B8%BB%E6%8E%A5%E5%85%A5%E6%A0%B7%E4%BE%8B.md)
- [SDK 消息与 Control 闭环对照表](16-SDK%E6%B6%88%E6%81%AF%E4%B8%8EControl%E9%97%AD%E7%8E%AF%E5%AF%B9%E7%85%A7%E8%A1%A8.md)
- [宿主实现最小闭环与恢复案例手册](20-%E5%AE%BF%E4%B8%BB%E5%AE%9E%E7%8E%B0%E6%9C%80%E5%B0%8F%E9%97%AD%E7%8E%AF%E4%B8%8E%E6%81%A2%E5%A4%8D%E6%A1%88%E4%BE%8B%E6%89%8B%E5%86%8C.md)

建议和蓝皮书主线搭配阅读：

- 先看 [导读](../00-%E5%AF%BC%E8%AF%BB.md)
- 再看 [功能全景与 API 支持](../05-%E5%8A%9F%E8%83%BD%E5%85%A8%E6%99%AF%E4%B8%8EAPI%E6%94%AF%E6%8C%81.md)
- 需要命令域全景时先看 `01 -> 05 -> 06 -> 07`
- 需要工具协议与 runtime context 时再看 `02 -> 08`
- 需要 runtime event stream、宿主可观测信号与消息族时再看 `04 -> 11 -> ../architecture/12`
- 需要区分事件时间线、`worker_status`、`external_metadata` 与 consumer subset 时再看 `11 -> 17 -> ../architecture/17 -> ../philosophy/13`
- 需要区分 `systemPrompt` / `appendSystemPrompt` / agent prompt / skill frontmatter / attachment 注入时再看 `18 -> ../architecture/18 -> ../philosophy/14`
- 需要 session/state surface、runtime truth 与恢复接口时再看 `09 -> ../architecture/09 -> ../philosophy/06`
- 需要把 `SDKMessage`、`worker_status`、`external_metadata`、control subtype 放到同一字段图里时再看 `17 -> 19 -> ../architecture/17 -> ../architecture/22`
- 需要统一扩展面、frontmatter 字段、plugin/agent trust boundary 与 MCP 连接平面时再看 `03 -> 10 -> 12 -> ../philosophy/08`
- 需要 host control protocol、`control_request` / `control_response`、远程 host 适配路径时再看 `13 -> ../architecture/13 -> ../philosophy/09`
- 需要分清 schema 全集、bridge 子集、direct-connect 子集、remote-session 子集时再看 `14 -> ../architecture/14 -> ../philosophy/10`
- 需要字段级 payload 对照、最小 NDJSON 样例与宿主请求封套时再看 `15 -> ../architecture/15 -> ../philosophy/11`
- 需要把 request/response 和 follow-on SDKMessage 一起看成闭环时再看 `16 -> ../architecture/16 -> ../philosophy/12`
- 需要按 host implementer 视角把 control、event stream、snapshot、recovery 一起吃下时再看 `19 -> 20 -> ../architecture/25`
- 需要把 session API、resume 恢复、`output_file`、host snapshot 一起看成完整状态接入面时再看 `09 -> 19 -> 20 -> ../architecture/25`
