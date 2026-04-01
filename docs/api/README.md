# API 文档

本目录不追求“列出所有类型名”，而是回答三个问题：

1. Claude Code 有哪些正式能力表面。
2. 这些能力通过什么接口暴露。
3. 哪些接口是 runtime 主路径，哪些只是 gated/internal 痕迹。

当前目录：

- [命令与功能矩阵](01-%E5%91%BD%E4%BB%A4%E4%B8%8E%E5%8A%9F%E8%83%BD%E7%9F%A9%E9%98%B5.md)
- [Agent SDK 与控制协议](02-Agent%20SDK%E4%B8%8E%E6%8E%A7%E5%88%B6%E5%8D%8F%E8%AE%AE.md)
- [MCP 与远程传输](03-MCP%E4%B8%8E%E8%BF%9C%E7%A8%8B%E4%BC%A0%E8%BE%93.md)
- [SDK 消息与事件字典](04-SDK%E6%B6%88%E6%81%AF%E4%B8%8E%E4%BA%8B%E4%BB%B6%E5%AD%97%E5%85%B8.md)
- [控制请求与响应矩阵](05-%E6%8E%A7%E5%88%B6%E8%AF%B7%E6%B1%82%E4%B8%8E%E5%93%8D%E5%BA%94%E7%9F%A9%E9%98%B5.md)
- [内置命令域索引](06-%E5%86%85%E7%BD%AE%E5%91%BD%E4%BB%A4%E5%9F%9F%E7%B4%A2%E5%BC%95.md)
- [命令字段与可用性索引](07-%E5%91%BD%E4%BB%A4%E5%AD%97%E6%AE%B5%E4%B8%8E%E5%8F%AF%E7%94%A8%E6%80%A7%E7%B4%A2%E5%BC%95.md)

建议和蓝皮书主线搭配阅读：

- 先看 [导读](../bluebook/00-%E5%AF%BC%E8%AF%BB.md)
- 再看 [功能全景与 API 支持](../bluebook/05-%E5%8A%9F%E8%83%BD%E5%85%A8%E6%99%AF%E4%B8%8EAPI%E6%94%AF%E6%8C%81.md)
- 需要命令域全景时先看 `06`
- 需要字段与 gating 细节时再看 `07`
