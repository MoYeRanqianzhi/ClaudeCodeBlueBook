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
12. [ClaudeAPI 与流式工具执行](12-ClaudeAPI%E4%B8%8E%E6%B5%81%E5%BC%8F%E5%B7%A5%E5%85%B7%E6%89%A7%E8%A1%8C.md)
13. [StructuredIO 与 RemoteIO 控制平面](13-StructuredIO%E4%B8%8ERemoteIO%E6%8E%A7%E5%88%B6%E5%B9%B3%E9%9D%A2.md)
14. [Bridge 与宿主适配器分层](14-Bridge%E4%B8%8E%E5%AE%BF%E4%B8%BB%E9%80%82%E9%85%8D%E5%99%A8%E5%88%86%E5%B1%82.md)
15. [宿主路径时序与竞速](15-%E5%AE%BF%E4%B8%BB%E8%B7%AF%E5%BE%84%E6%97%B6%E5%BA%8F%E4%B8%8E%E7%AB%9E%E9%80%9F.md)
16. [远程恢复与重连状态机](16-%E8%BF%9C%E7%A8%8B%E6%81%A2%E5%A4%8D%E4%B8%8E%E9%87%8D%E8%BF%9E%E7%8A%B6%E6%80%81%E6%9C%BA.md)
17. [双通道状态同步与外部元数据回写](17-%E5%8F%8C%E9%80%9A%E9%81%93%E7%8A%B6%E6%80%81%E5%90%8C%E6%AD%A5%E4%B8%8E%E5%A4%96%E9%83%A8%E5%85%83%E6%95%B0%E6%8D%AE%E5%9B%9E%E5%86%99.md)
18. [提示词装配链与上下文成形](18-%E6%8F%90%E7%A4%BA%E8%AF%8D%E8%A3%85%E9%85%8D%E9%93%BE%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E6%88%90%E5%BD%A2.md)
19. [安全分层、策略收口与沙箱边界](19-%E5%AE%89%E5%85%A8%E5%88%86%E5%B1%82%E3%80%81%E7%AD%96%E7%95%A5%E6%94%B6%E5%8F%A3%E4%B8%8E%E6%B2%99%E7%AE%B1%E8%BE%B9%E7%95%8C.md)
20. [源码质量、分层与工程先进性](20-%E6%BA%90%E7%A0%81%E8%B4%A8%E9%87%8F%E3%80%81%E5%88%86%E5%B1%82%E4%B8%8E%E5%B7%A5%E7%A8%8B%E5%85%88%E8%BF%9B%E6%80%A7.md)
21. [消息塑形、输出外置与 Token 经济](21-%E6%B6%88%E6%81%AF%E5%A1%91%E5%BD%A2%E3%80%81%E8%BE%93%E5%87%BA%E5%A4%96%E7%BD%AE%E4%B8%8EToken%E7%BB%8F%E6%B5%8E.md)

这几章和 `bluebook/` 的区别是：

- `bluebook/` 负责讲主线结论。
- `architecture/` 负责把机制拆开讲清楚。

建议按问题阅读：

- 想看 query loop、Claude API stream、tool execution、fallback 与 recovery 的完整链路：`02 -> 06 -> 12`
- 想看权限决议、状态机与 Auto Mode：`05 -> 11`
- 想看会话状态、记忆与可恢复性：`06 -> 08 -> 09`
- 想看多 Agent 的隔离编排：`10`
- 想看扩展与 remote 装配：`03`
- 想看 host protocol、桥接、direct-connect、remote session 的控制平面：`13`
- 想看 bridge、direct-connect、remote-session 各自位于哪一层：`14`
- 想看本地 host、bridge、direct-connect、remote-session 的时序与 race：`15`
- 想看 401/4001/4003、epoch rebuild、worker_status 回写等恢复状态机：`16`
- 想看 `SDKMessage`、`worker_status`、`external_metadata` 如何组成双通道状态真相：`17`
- 想看 prompt 如何从 system sections、agent prompt、attachment、fork cache 一路装出来：`18`
- 想看 trust、permission、filesystem、sandbox、hooks、policy、MCP auth 的完整安全边界：`19`
- 想看这个仓库为什么在工程结构上显得先进：`20`
- 想看省 token 为什么不只是 compact，而是消息塑形、目录外移和大块输出外置：`21`
