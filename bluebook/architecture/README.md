# 架构专题

本目录收纳对 Claude Code runtime 的结构性深挖，默认按“从外到内”阅读：

1. [启动链路与 CLI](01-%E5%90%AF%E5%8A%A8%E9%93%BE%E8%B7%AF%E4%B8%8ECLI.md)
2. [Agent 循环与工具系统](02-Agent%E5%BE%AA%E7%8E%AF%E4%B8%8E%E5%B7%A5%E5%85%B7%E7%B3%BB%E7%BB%9F.md)
3. [扩展能力与远程架构](03-%E6%89%A9%E5%B1%95%E8%83%BD%E5%8A%9B%E4%B8%8E%E8%BF%9C%E7%A8%8B%E6%9E%B6%E6%9E%84.md)
4. [REPL 与 Ink 交互架构](04-REPL%E4%B8%8EInk%E4%BA%A4%E4%BA%92%E6%9E%B6%E6%9E%84.md)
5. [权限系统与安全状态机](05-%E6%9D%83%E9%99%90%E7%B3%BB%E7%BB%9F%E4%B8%8E%E5%AE%89%E5%85%A8%E7%8A%B6%E6%80%81%E6%9C%BA.md)
6. [上下文压缩与恢复链](06-%E4%B8%8A%E4%B8%8B%E6%96%87%E5%8E%8B%E7%BC%A9%E4%B8%8E%E6%81%A2%E5%A4%8D%E9%93%BE.md)
7. [PromptInput 与消息渲染链](07-PromptInput%E4%B8%8E%E6%B6%88%E6%81%AF%E6%B8%B2%E6%9F%93%E9%93%BE.md)
8. [compact 算法与上下文管理细拆](08-compact%E7%AE%97%E6%B3%95%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E7%AE%A1%E7%90%86%E7%BB%86%E6%8B%86.md)
9. [会话存储、记忆与回溯状态面](09-%E4%BC%9A%E8%AF%9D%E5%AD%98%E5%82%A8%E8%AE%B0%E5%BF%86%E4%B8%8E%E5%9B%9E%E6%BA%AF%E7%8A%B6%E6%80%81%E9%9D%A2.md)
10. [AgentTool 与隔离编排](10-AgentTool%E4%B8%8E%E9%9A%94%E7%A6%BB%E7%BC%96%E6%8E%92.md)
11. [权限系统全链路与 Auto Mode](11-%E6%9D%83%E9%99%90%E7%B3%BB%E7%BB%9F%E5%85%A8%E9%93%BE%E8%B7%AF%E4%B8%8EAuto%20Mode.md)

这几章和 `bluebook/` 的区别是：

- `bluebook/` 负责讲主线结论。
- `architecture/` 负责把机制拆开讲清楚。
