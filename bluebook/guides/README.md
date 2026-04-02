# 使用专题

本目录收纳从源码反推的实战方法，不重复产品文案。

## 当前入口

1. [01-使用指南](01-%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97.md)
2. [02-多Agent编排与Prompt模板](02-%E5%A4%9AAgent%E7%BC%96%E6%8E%92%E4%B8%8EPrompt%E6%A8%A1%E6%9D%BF.md)
3. [03-CLAUDE.md、记忆层与上下文注入实践](03-CLAUDE.md%E3%80%81%E8%AE%B0%E5%BF%86%E5%B1%82%E4%B8%8E%E4%B8%8A%E4%B8%8B%E6%96%87%E6%B3%A8%E5%85%A5%E5%AE%9E%E8%B7%B5.md)
4. [04-Channels、托管策略与组织级治理实践](04-Channels%E3%80%81%E6%89%98%E7%AE%A1%E7%AD%96%E7%95%A5%E4%B8%8E%E7%BB%84%E7%BB%87%E7%BA%A7%E6%B2%BB%E7%90%86%E5%AE%9E%E8%B7%B5.md)
5. [05-企业托管设置实战：channelsEnabled、allowedChannelPlugins与危险配置审批](05-%E4%BC%81%E4%B8%9A%E6%89%98%E7%AE%A1%E8%AE%BE%E7%BD%AE%E5%AE%9E%E6%88%98%EF%BC%9AchannelsEnabled%E3%80%81allowedChannelPlugins%E4%B8%8E%E5%8D%B1%E9%99%A9%E9%85%8D%E7%BD%AE%E5%AE%A1%E6%89%B9.md)
6. [06-第一性原理实践：目标、预算、对象、边界与回写](06-%E7%AC%AC%E4%B8%80%E6%80%A7%E5%8E%9F%E7%90%86%E5%AE%9E%E8%B7%B5%EF%BC%9A%E7%9B%AE%E6%A0%87%E3%80%81%E9%A2%84%E7%AE%97%E3%80%81%E5%AF%B9%E8%B1%A1%E3%80%81%E8%BE%B9%E7%95%8C%E4%B8%8E%E5%9B%9E%E5%86%99.md)
7. [07-用Context Usage与状态回写调优Prompt和预算](07-%E7%94%A8Context%20Usage%E4%B8%8E%E7%8A%B6%E6%80%81%E5%9B%9E%E5%86%99%E8%B0%83%E4%BC%98Prompt%E5%92%8C%E9%A2%84%E7%AE%97.md)
8. [08-如何根据预算、阻塞与风险选择session、task、worktree与compact](08-%E5%A6%82%E4%BD%95%E6%A0%B9%E6%8D%AE%E9%A2%84%E7%AE%97%E3%80%81%E9%98%BB%E5%A1%9E%E4%B8%8E%E9%A3%8E%E9%99%A9%E9%80%89%E6%8B%A9session%E3%80%81task%E3%80%81worktree%E4%B8%8Ecompact.md)
9. [09-如何降低人类-模型协调成本：Sticky Prompt、Suggestion、Session Memory与接手连续性](09-%E5%A6%82%E4%BD%95%E9%99%8D%E4%BD%8E%E4%BA%BA%E7%B1%BB-%E6%A8%A1%E5%9E%8B%E5%8D%8F%E8%B0%83%E6%88%90%E6%9C%AC%EF%BC%9ASticky%20Prompt%E3%80%81Suggestion%E3%80%81Session%20Memory%E4%B8%8E%E6%8E%A5%E6%89%8B%E8%BF%9E%E7%BB%AD%E6%80%A7.md)
10. [10-如何在约束中保持高行动力：permission mode、反馈式审批与渐进能力暴露](10-%E5%A6%82%E4%BD%95%E5%9C%A8%E7%BA%A6%E6%9D%9F%E4%B8%AD%E4%BF%9D%E6%8C%81%E9%AB%98%E8%A1%8C%E5%8A%A8%E5%8A%9B%EF%BC%9Apermission%20mode%E3%80%81%E5%8F%8D%E9%A6%88%E5%BC%8F%E5%AE%A1%E6%89%B9%E4%B8%8E%E6%B8%90%E8%BF%9B%E8%83%BD%E5%8A%9B%E6%9A%B4%E9%9C%B2.md)
11. [11-给Agent平台构建者：如何把源码写成治理界面并保留重构余量](11-%E7%BB%99Agent%E5%B9%B3%E5%8F%B0%E6%9E%84%E5%BB%BA%E8%80%85%EF%BC%9A%E5%A6%82%E4%BD%95%E6%8A%8A%E6%BA%90%E7%A0%81%E5%86%99%E6%88%90%E6%B2%BB%E7%90%86%E7%95%8C%E9%9D%A2%E5%B9%B6%E4%BF%9D%E7%95%99%E9%87%8D%E6%9E%84%E4%BD%99%E9%87%8F.md)
12. [12-如何把Prompt当成人机协作接口：固定主语、反馈纠偏与低成本接手](12-%E5%A6%82%E4%BD%95%E6%8A%8APrompt%E5%BD%93%E6%88%90%E4%BA%BA%E6%9C%BA%E5%8D%8F%E4%BD%9C%E6%8E%A5%E5%8F%A3%EF%BC%9A%E5%9B%BA%E5%AE%9A%E4%B8%BB%E8%AF%AD%E3%80%81%E5%8F%8D%E9%A6%88%E7%BA%A0%E5%81%8F%E4%B8%8E%E4%BD%8E%E6%88%90%E6%9C%AC%E6%8E%A5%E6%89%8B.md)
13. [13-如何在秩序中释放有效自由：mode选择、审批协商与能力按需出现](13-%E5%A6%82%E4%BD%95%E5%9C%A8%E7%A7%A9%E5%BA%8F%E4%B8%AD%E9%87%8A%E6%94%BE%E6%9C%89%E6%95%88%E8%87%AA%E7%94%B1%EF%BC%9Amode%E9%80%89%E6%8B%A9%E3%80%81%E5%AE%A1%E6%89%B9%E5%8D%8F%E5%95%86%E4%B8%8E%E8%83%BD%E5%8A%9B%E6%8C%89%E9%9C%80%E5%87%BA%E7%8E%B0.md)
14. [14-如何为未来维护者设计Agent Runtime：注释、命名、leaf module与重构余量](14-%E5%A6%82%E4%BD%95%E4%B8%BA%E6%9C%AA%E6%9D%A5%E7%BB%B4%E6%8A%A4%E8%80%85%E8%AE%BE%E8%AE%A1Agent%20Runtime%EF%BC%9A%E6%B3%A8%E9%87%8A%E3%80%81%E5%91%BD%E5%90%8D%E3%80%81leaf%20module%E4%B8%8E%E9%87%8D%E6%9E%84%E4%BD%99%E9%87%8F.md)
15. [15-如何把UI真相翻译成Protocol真相：transcript重写、边界补写与恢复不变量](15-%E5%A6%82%E4%BD%95%E6%8A%8AUI%E7%9C%9F%E7%9B%B8%E7%BF%BB%E8%AF%91%E6%88%90Protocol%E7%9C%9F%E7%9B%B8%EF%BC%9Atranscript%E9%87%8D%E5%86%99%E3%80%81%E8%BE%B9%E7%95%8C%E8%A1%A5%E5%86%99%E4%B8%8E%E6%81%A2%E5%A4%8D%E4%B8%8D%E5%8F%98%E9%87%8F.md)
16. [16-如何用资源定价设计Agent Runtime：mode、visibility、externalization与continuation](16-%E5%A6%82%E4%BD%95%E7%94%A8%E8%B5%84%E6%BA%90%E5%AE%9A%E4%BB%B7%E8%AE%BE%E8%AE%A1Agent%20Runtime%EF%BC%9Amode%E3%80%81visibility%E3%80%81externalization%E4%B8%8Econtinuation.md)
17. [17-如何把未来维护者当正式消费者：风险命名、制度注释、seam与状态机](17-%E5%A6%82%E4%BD%95%E6%8A%8A%E6%9C%AA%E6%9D%A5%E7%BB%B4%E6%8A%A4%E8%80%85%E5%BD%93%E6%AD%A3%E5%BC%8F%E6%B6%88%E8%B4%B9%E8%80%85%EF%BC%9A%E9%A3%8E%E9%99%A9%E5%91%BD%E5%90%8D%E3%80%81%E5%88%B6%E5%BA%A6%E6%B3%A8%E9%87%8A%E3%80%81seam%E4%B8%8E%E7%8A%B6%E6%80%81%E6%9C%BA.md)
18. [18-如何把Prompt当成共享前缀资产网络：侧问题、suggestion、memory与summary共用主线程前缀](18-%E5%A6%82%E4%BD%95%E6%8A%8APrompt%E5%BD%93%E6%88%90%E5%85%B1%E4%BA%AB%E5%89%8D%E7%BC%80%E8%B5%84%E4%BA%A7%E7%BD%91%E7%BB%9C%EF%BC%9A%E4%BE%A7%E9%97%AE%E9%A2%98%E3%80%81suggestion%E3%80%81memory%E4%B8%8Esummary%E5%85%B1%E7%94%A8%E4%B8%BB%E7%BA%BF%E7%A8%8B%E5%89%8D%E7%BC%80.md)
19. [19-如何用Contract-First方法阅读和设计Agent Runtime：先找合同，再看热点文件](19-%E5%A6%82%E4%BD%95%E7%94%A8Contract-First%E6%96%B9%E6%B3%95%E9%98%85%E8%AF%BB%E5%92%8C%E8%AE%BE%E8%AE%A1Agent%20Runtime%EF%BC%9A%E5%85%88%E6%89%BE%E5%90%88%E5%90%8C%EF%BC%8C%E5%86%8D%E7%9C%8B%E7%83%AD%E7%82%B9%E6%96%87%E4%BB%B6.md)
20. [20-如何工程化地维持依赖图诚实性：leaf module、anti-cycle seam与single-source file](20-%E5%A6%82%E4%BD%95%E5%B7%A5%E7%A8%8B%E5%8C%96%E5%9C%B0%E7%BB%B4%E6%8C%81%E4%BE%9D%E8%B5%96%E5%9B%BE%E8%AF%9A%E5%AE%9E%E6%80%A7%EF%BC%9Aleaf%20module%E3%80%81anti-cycle%20seam%E4%B8%8Esingle-source%20file.md)
21. [21-共享前缀快照策略模板：何时保存、何时复用、何时suppress](21-%E5%85%B1%E4%BA%AB%E5%89%8D%E7%BC%80%E5%BF%AB%E7%85%A7%E7%AD%96%E7%95%A5%E6%A8%A1%E6%9D%BF%EF%BC%9A%E4%BD%95%E6%97%B6%E4%BF%9D%E5%AD%98%E3%80%81%E4%BD%95%E6%97%B6%E5%A4%8D%E7%94%A8%E3%80%81%E4%BD%95%E6%97%B6suppress.md)
22. [22-Contract-First审读清单：如何系统读懂Agent Runtime的合同、权威面与热点文件](22-Contract-First%E5%AE%A1%E8%AF%BB%E6%B8%85%E5%8D%95%EF%BC%9A%E5%A6%82%E4%BD%95%E7%B3%BB%E7%BB%9F%E8%AF%BB%E6%87%82Agent%20Runtime%E7%9A%84%E5%90%88%E5%90%8C%E3%80%81%E6%9D%83%E5%A8%81%E9%9D%A2%E4%B8%8E%E7%83%AD%E7%82%B9%E6%96%87%E4%BB%B6.md)
23. [23-Dependency-Honesty Review Checklist：如何评审leaf module、anti-cycle seam与single-source file](23-Dependency-Honesty%20Review%20Checklist%EF%BC%9A%E5%A6%82%E4%BD%95%E8%AF%84%E5%AE%A1leaf%20module%E3%80%81anti-cycle%20seam%E4%B8%8Esingle-source%20file.md)
24. [24-如何把Prompt写成可治理宪法：section registry、角色主权链、合法遗忘与可观测diff](24-%E5%A6%82%E4%BD%95%E6%8A%8APrompt%E5%86%99%E6%88%90%E5%8F%AF%E6%B2%BB%E7%90%86%E5%AE%AA%E6%B3%95%EF%BC%9Asection%20registry%E3%80%81%E8%A7%92%E8%89%B2%E4%B8%BB%E6%9D%83%E9%93%BE%E3%80%81%E5%90%88%E6%B3%95%E9%81%97%E5%BF%98%E4%B8%8E%E5%8F%AF%E8%A7%82%E6%B5%8Bdiff.md)
25. [25-如何设计有顺序的治理系统：检查顺序、失败语义分型、可撤销自动化与稳定字节资产](25-%E5%A6%82%E4%BD%95%E8%AE%BE%E8%AE%A1%E6%9C%89%E9%A1%BA%E5%BA%8F%E7%9A%84%E6%B2%BB%E7%90%86%E7%B3%BB%E7%BB%9F%EF%BC%9A%E6%A3%80%E6%9F%A5%E9%A1%BA%E5%BA%8F%E3%80%81%E5%A4%B1%E8%B4%A5%E8%AF%AD%E4%B9%89%E5%88%86%E5%9E%8B%E3%80%81%E5%8F%AF%E6%92%A4%E9%94%80%E8%87%AA%E5%8A%A8%E5%8C%96%E4%B8%8E%E7%A8%B3%E5%AE%9A%E5%AD%97%E8%8A%82%E8%B5%84%E4%BA%A7.md)
26. [26-如何用构建系统塑形Agent Runtime：入口影子、transport shell、薄registry与反zombification](26-%E5%A6%82%E4%BD%95%E7%94%A8%E6%9E%84%E5%BB%BA%E7%B3%BB%E7%BB%9F%E5%A1%91%E5%BD%A2Agent%20Runtime%EF%BC%9A%E5%85%A5%E5%8F%A3%E5%BD%B1%E5%AD%90%E3%80%81transport%20shell%E3%80%81%E8%96%84registry%E4%B8%8E%E5%8F%8Dzombification.md)
27. [27-Prompt Constitution审读模板：section card、修宪工作流、失效台账与triage runbook](27-Prompt%20Constitution%E5%AE%A1%E8%AF%BB%E6%A8%A1%E6%9D%BF%EF%BC%9Asection%20card%E3%80%81%E4%BF%AE%E5%AE%AA%E5%B7%A5%E4%BD%9C%E6%B5%81%E3%80%81%E5%A4%B1%E6%95%88%E5%8F%B0%E8%B4%A6%E4%B8%8Etriage%20runbook.md)
28. [28-治理顺序审计模板：失败语义矩阵、自动化租约、审批竞速与稳定字节台账](28-%E6%B2%BB%E7%90%86%E9%A1%BA%E5%BA%8F%E5%AE%A1%E8%AE%A1%E6%A8%A1%E6%9D%BF%EF%BC%9A%E5%A4%B1%E8%B4%A5%E8%AF%AD%E4%B9%89%E7%9F%A9%E9%98%B5%E3%80%81%E8%87%AA%E5%8A%A8%E5%8C%96%E7%A7%9F%E7%BA%A6%E3%80%81%E5%AE%A1%E6%89%B9%E7%AB%9E%E9%80%9F%E4%B8%8E%E7%A8%B3%E5%AE%9A%E5%AD%97%E8%8A%82%E5%8F%B0%E8%B4%A6.md)
29. [29-源码塑形审读模板：发布面矩阵、入口影子、transport shell与反zombification清单](29-%E6%BA%90%E7%A0%81%E5%A1%91%E5%BD%A2%E5%AE%A1%E8%AF%BB%E6%A8%A1%E6%9D%BF%EF%BC%9A%E5%8F%91%E5%B8%83%E9%9D%A2%E7%9F%A9%E9%98%B5%E3%80%81%E5%85%A5%E5%8F%A3%E5%BD%B1%E5%AD%90%E3%80%81transport%20shell%E4%B8%8E%E5%8F%8Dzombification%E6%B8%85%E5%8D%95.md)
30. [30-如何用苏格拉底诘问法审读Prompt魔力：主语、共享前缀、边界与合法遗忘](30-%E5%A6%82%E4%BD%95%E7%94%A8%E8%8B%8F%E6%A0%BC%E6%8B%89%E5%BA%95%E8%AF%98%E9%97%AE%E6%B3%95%E5%AE%A1%E8%AF%BBPrompt%E9%AD%94%E5%8A%9B%EF%BC%9A%E4%B8%BB%E8%AF%AD%E3%80%81%E5%85%B1%E4%BA%AB%E5%89%8D%E7%BC%80%E3%80%81%E8%BE%B9%E7%95%8C%E4%B8%8E%E5%90%88%E6%B3%95%E9%81%97%E5%BF%98.md)
31. [31-如何用苏格拉底诘问法审读安全与省Token：输入边界、决策增益与可撤销自动化](31-%E5%A6%82%E4%BD%95%E7%94%A8%E8%8B%8F%E6%A0%BC%E6%8B%89%E5%BA%95%E8%AF%98%E9%97%AE%E6%B3%95%E5%AE%A1%E8%AF%BB%E5%AE%89%E5%85%A8%E4%B8%8E%E7%9C%81Token%EF%BC%9A%E8%BE%93%E5%85%A5%E8%BE%B9%E7%95%8C%E3%80%81%E5%86%B3%E7%AD%96%E5%A2%9E%E7%9B%8A%E4%B8%8E%E5%8F%AF%E6%92%A4%E9%94%80%E8%87%AA%E5%8A%A8%E5%8C%96.md)
32. [32-如何用苏格拉底诘问法审读源码先进性：权威面、恢复资产与未来维护者消费者](32-%E5%A6%82%E4%BD%95%E7%94%A8%E8%8B%8F%E6%A0%BC%E6%8B%89%E5%BA%95%E8%AF%98%E9%97%AE%E6%B3%95%E5%AE%A1%E8%AF%BB%E6%BA%90%E7%A0%81%E5%85%88%E8%BF%9B%E6%80%A7%EF%BC%9A%E6%9D%83%E5%A8%81%E9%9D%A2%E3%80%81%E6%81%A2%E5%A4%8D%E8%B5%84%E4%BA%A7%E4%B8%8E%E6%9C%AA%E6%9D%A5%E7%BB%B4%E6%8A%A4%E8%80%85%E6%B6%88%E8%B4%B9%E8%80%85.md)
33. [33-如何为Agent Runtime设计统一Rollout ABI：Diff卡、阶段评审卡、灰度结果与回退记录](33-%E5%A6%82%E4%BD%95%E4%B8%BAAgent%20Runtime%E8%AE%BE%E8%AE%A1%E7%BB%9F%E4%B8%80Rollout%20ABI%EF%BC%9ADiff%E5%8D%A1%E3%80%81%E9%98%B6%E6%AE%B5%E8%AF%84%E5%AE%A1%E5%8D%A1%E3%80%81%E7%81%B0%E5%BA%A6%E7%BB%93%E6%9E%9C%E4%B8%8E%E5%9B%9E%E9%80%80%E8%AE%B0%E5%BD%95.md)
34. [34-如何让宿主、评审者与后来者共享同一Rollout ABI：对象、指标、回退与附件消费顺序](34-%E5%A6%82%E4%BD%95%E8%AE%A9%E5%AE%BF%E4%B8%BB%E3%80%81%E8%AF%84%E5%AE%A1%E8%80%85%E4%B8%8E%E5%90%8E%E6%9D%A5%E8%80%85%E5%85%B1%E4%BA%AB%E5%90%8C%E4%B8%80Rollout%20ABI%EF%BC%9A%E5%AF%B9%E8%B1%A1%E3%80%81%E6%8C%87%E6%A0%87%E3%80%81%E5%9B%9E%E9%80%80%E4%B8%8E%E9%99%84%E4%BB%B6%E6%B6%88%E8%B4%B9%E9%A1%BA%E5%BA%8F.md)
35. [35-如何用苏格拉底诘问法审读Evidence Envelope：对象、窗口、字节与回退边界](35-%E5%A6%82%E4%BD%95%E7%94%A8%E8%8B%8F%E6%A0%BC%E6%8B%89%E5%BA%95%E8%AF%98%E9%97%AE%E6%B3%95%E5%AE%A1%E8%AF%BBEvidence%20Envelope%EF%BC%9A%E5%AF%B9%E8%B1%A1%E3%80%81%E7%AA%97%E5%8F%A3%E3%80%81%E5%AD%97%E8%8A%82%E4%B8%8E%E5%9B%9E%E9%80%80%E8%BE%B9%E7%95%8C.md)
36. [36-Prompt Host Implementation审读模板：编译真相、稳定字节、合法遗忘与交接闸门](36-Prompt%20Host%20Implementation%E5%AE%A1%E8%AF%BB%E6%A8%A1%E6%9D%BF%EF%BC%9A%E7%BC%96%E8%AF%91%E7%9C%9F%E7%9B%B8%E3%80%81%E7%A8%B3%E5%AE%9A%E5%AD%97%E8%8A%82%E3%80%81%E5%90%88%E6%B3%95%E9%81%97%E5%BF%98%E4%B8%8E%E4%BA%A4%E6%8E%A5%E9%97%B8%E9%97%A8.md)
37. [37-治理 Host Implementation审读模板：决策窗口、仲裁证据、对象升级与回退边界](37-%E6%B2%BB%E7%90%86%20Host%20Implementation%E5%AE%A1%E8%AF%BB%E6%A8%A1%E6%9D%BF%EF%BC%9A%E5%86%B3%E7%AD%96%E7%AA%97%E5%8F%A3%E3%80%81%E4%BB%B2%E8%A3%81%E8%AF%81%E6%8D%AE%E3%80%81%E5%AF%B9%E8%B1%A1%E5%8D%87%E7%BA%A7%E4%B8%8E%E5%9B%9E%E9%80%80%E8%BE%B9%E7%95%8C.md)
38. [38-结构 Host Implementation审读模板：权威路径、恢复资产、反zombie 与危险路径交接](38-%E7%BB%93%E6%9E%84%20Host%20Implementation%E5%AE%A1%E8%AF%BB%E6%A8%A1%E6%9D%BF%EF%BC%9A%E6%9D%83%E5%A8%81%E8%B7%AF%E5%BE%84%E3%80%81%E6%81%A2%E5%A4%8D%E8%B5%84%E4%BA%A7%E3%80%81%E5%8F%8Dzombie%20%E4%B8%8E%E5%8D%B1%E9%99%A9%E8%B7%AF%E5%BE%84%E4%BA%A4%E6%8E%A5.md)
39. [39-Prompt Artifact Validator模板：共享对象、稳定字节、合法遗忘与交接拒收](39-Prompt%20Artifact%20Validator%E6%A8%A1%E6%9D%BF%EF%BC%9A%E5%85%B1%E4%BA%AB%E5%AF%B9%E8%B1%A1%E3%80%81%E7%A8%B3%E5%AE%9A%E5%AD%97%E8%8A%82%E3%80%81%E5%90%88%E6%B3%95%E9%81%97%E5%BF%98%E4%B8%8E%E4%BA%A4%E6%8E%A5%E6%8B%92%E6%94%B6.md)
40. [40-治理 Artifact Validator模板：决策窗口、仲裁证据、回退对象与行动语义拒收](40-%E6%B2%BB%E7%90%86%20Artifact%20Validator%E6%A8%A1%E6%9D%BF%EF%BC%9A%E5%86%B3%E7%AD%96%E7%AA%97%E5%8F%A3%E3%80%81%E4%BB%B2%E8%A3%81%E8%AF%81%E6%8D%AE%E3%80%81%E5%9B%9E%E9%80%80%E5%AF%B9%E8%B1%A1%E4%B8%8E%E8%A1%8C%E5%8A%A8%E8%AF%AD%E4%B9%89%E6%8B%92%E6%94%B6.md)
41. [41-结构 Artifact Validator模板：权威路径、恢复资产、anti-zombie 与交接拒收](41-%E7%BB%93%E6%9E%84%20Artifact%20Validator%E6%A8%A1%E6%9D%BF%EF%BC%9A%E6%9D%83%E5%A8%81%E8%B7%AF%E5%BE%84%E3%80%81%E6%81%A2%E5%A4%8D%E8%B5%84%E4%BA%A7%E3%80%81anti-zombie%20%E4%B8%8E%E4%BA%A4%E6%8E%A5%E6%8B%92%E6%94%B6.md)
42. [42-Prompt Artifact Harness Runner落地手册：Replay Queue、Prefix Ledger、Continuation Gate 与 Rewrite Adoption](42-Prompt%20Artifact%20Harness%20Runner%E8%90%BD%E5%9C%B0%E6%89%8B%E5%86%8C%EF%BC%9AReplay%20Queue%E3%80%81Prefix%20Ledger%E3%80%81Continuation%20Gate%20%E4%B8%8E%20Rewrite%20Adoption.md)
43. [43-治理 Artifact Harness Runner落地手册：Decision Window、Alignment Gate、Arbitration Ledger 与 Object Upgrade](43-%E6%B2%BB%E7%90%86%20Artifact%20Harness%20Runner%E8%90%BD%E5%9C%B0%E6%89%8B%E5%86%8C%EF%BC%9ADecision%20Window%E3%80%81Alignment%20Gate%E3%80%81Arbitration%20Ledger%20%E4%B8%8E%20Object%20Upgrade.md)
44. [44-结构 Artifact Harness Runner落地手册：Authoritative Queue、Recovery Ledger、Anti-Zombie 审读与 Recovery Adoption](44-%E7%BB%93%E6%9E%84%20Artifact%20Harness%20Runner%E8%90%BD%E5%9C%B0%E6%89%8B%E5%86%8C%EF%BC%9AAuthoritative%20Queue%E3%80%81Recovery%20Ledger%E3%80%81Anti-Zombie%20%E5%AE%A1%E8%AF%BB%E4%B8%8E%20Recovery%20Adoption.md)
45. [45-从第一性原理构建Agent Runtime：对象、协作语法、资源定价与恢复闭环](45-%E4%BB%8E%E7%AC%AC%E4%B8%80%E6%80%A7%E5%8E%9F%E7%90%86%E6%9E%84%E5%BB%BAAgent%20Runtime%EF%BC%9A%E5%AF%B9%E8%B1%A1%E3%80%81%E5%8D%8F%E4%BD%9C%E8%AF%AD%E6%B3%95%E3%80%81%E8%B5%84%E6%BA%90%E5%AE%9A%E4%BB%B7%E4%B8%8E%E6%81%A2%E5%A4%8D%E9%97%AD%E7%8E%AF.md)
46. [46-Agent Runtime宿主落地模板：Control、状态写回、Context Usage、恢复与证据包络](46-Agent%20Runtime%E5%AE%BF%E4%B8%BB%E8%90%BD%E5%9C%B0%E6%A8%A1%E6%9D%BF%EF%BC%9AControl%E3%80%81%E7%8A%B6%E6%80%81%E5%86%99%E5%9B%9E%E3%80%81Context%20Usage%E3%80%81%E6%81%A2%E5%A4%8D%E4%B8%8E%E8%AF%81%E6%8D%AE%E5%8C%85%E7%BB%9C.md)
47. [47-统一蓝图手册：把协作语法、资源定价与可演化内核编译成Agent Runtime](47-%E7%BB%9F%E4%B8%80%E8%93%9D%E5%9B%BE%E6%89%8B%E5%86%8C%EF%BC%9A%E6%8A%8A%E5%8D%8F%E4%BD%9C%E8%AF%AD%E6%B3%95%E3%80%81%E8%B5%84%E6%BA%90%E5%AE%9A%E4%BB%B7%E4%B8%8E%E5%8F%AF%E6%BC%94%E5%8C%96%E5%86%85%E6%A0%B8%E7%BC%96%E8%AF%91%E6%88%90Agent%20Runtime.md)
48. [48-如何把Prompt写成上下文准入编译器：section law、stable prefix、协议真相与合法遗忘](48-%E5%A6%82%E4%BD%95%E6%8A%8APrompt%E5%86%99%E6%88%90%E4%B8%8A%E4%B8%8B%E6%96%87%E5%87%86%E5%85%A5%E7%BC%96%E8%AF%91%E5%99%A8%EF%BC%9Asection%20law%E3%80%81stable%20prefix%E3%80%81%E5%8D%8F%E8%AE%AE%E7%9C%9F%E7%9B%B8%E4%B8%8E%E5%90%88%E6%B3%95%E9%81%97%E5%BF%98.md)
49. [49-如何把安全与省Token写成治理控制面：typed decision、渐进暴露、Context Usage与继续预算](49-%E5%A6%82%E4%BD%95%E6%8A%8A%E5%AE%89%E5%85%A8%E4%B8%8E%E7%9C%81Token%E5%86%99%E6%88%90%E6%B2%BB%E7%90%86%E6%8E%A7%E5%88%B6%E9%9D%A2%EF%BC%9Atyped%20decision%E3%80%81%E6%B8%90%E8%BF%9B%E6%9A%B4%E9%9C%B2%E3%80%81Context%20Usage%E4%B8%8E%E7%BB%A7%E7%BB%AD%E9%A2%84%E7%AE%97.md)
50. [50-如何把源码先进性落成可演化内核：权威入口、单一来源、anti-cycle seam与未来维护者消费者](50-%E5%A6%82%E4%BD%95%E6%8A%8A%E6%BA%90%E7%A0%81%E5%85%88%E8%BF%9B%E6%80%A7%E8%90%BD%E6%88%90%E5%8F%AF%E6%BC%94%E5%8C%96%E5%86%85%E6%A0%B8%EF%BC%9A%E6%9D%83%E5%A8%81%E5%85%A5%E5%8F%A3%E3%80%81%E5%8D%95%E4%B8%80%E6%9D%A5%E6%BA%90%E3%80%81anti-cycle%20seam%E4%B8%8E%E6%9C%AA%E6%9D%A5%E7%BB%B4%E6%8A%A4%E8%80%85%E6%B6%88%E8%B4%B9%E8%80%85.md)
51. [51-如何把Prompt魔力落成编译链实现：section registry、stable boundary、protocol rewrite与continue qualification](51-%E5%A6%82%E4%BD%95%E6%8A%8APrompt%E9%AD%94%E5%8A%9B%E8%90%BD%E6%88%90%E7%BC%96%E8%AF%91%E9%93%BE%E5%AE%9E%E7%8E%B0%EF%BC%9Asection%20registry%E3%80%81stable%20boundary%E3%80%81protocol%20rewrite%E4%B8%8Econtinue%20qualification.md)
52. [52-如何把统一定价治理落成控制面实现：authority source、decision window、Context Usage与rollback object](52-%E5%A6%82%E4%BD%95%E6%8A%8A%E7%BB%9F%E4%B8%80%E5%AE%9A%E4%BB%B7%E6%B2%BB%E7%90%86%E8%90%BD%E6%88%90%E6%8E%A7%E5%88%B6%E9%9D%A2%E5%AE%9E%E7%8E%B0%EF%BC%9Aauthority%20source%E3%80%81decision%20window%E3%80%81Context%20Usage%E4%B8%8Erollback%20object.md)
53. [53-如何把故障模型编码进源码结构：authority surface、dependency seam、stale-safe merge与recovery boundary](53-%E5%A6%82%E4%BD%95%E6%8A%8A%E6%95%85%E9%9A%9C%E6%A8%A1%E5%9E%8B%E7%BC%96%E7%A0%81%E8%BF%9B%E6%BA%90%E7%A0%81%E7%BB%93%E6%9E%84%EF%BC%9Aauthority%20surface%E3%80%81dependency%20seam%E3%80%81stale-safe%20merge%E4%B8%8Erecovery%20boundary.md)

## 按使用目标阅读

- 想先把 Claude Code 用顺手：`01`
- 想把多 Agent 用对，而不是只会并行：`01 -> 02`
- 想把规则层、长期记忆、会话连续性分层设计清楚：`01 -> 03`
- 想把 Prompt 写成可运行的 contract，而不是一次性文案：`01 -> 02 -> 03 -> ../philosophy/18 -> ../architecture/36`
- 想把 channels 用在团队里而不是把风险直接带进会话：`01 -> 04 -> 05 -> ../api/28 -> ../architecture/37 -> ../risk/05`
- 想理解 Claude Code 为什么能同时兼顾安全、成本与体验：`01 -> ../architecture/32 -> ../architecture/37 -> ../philosophy/22`
- 想从源码反推更一般的 Agent runtime 设计法：`01 -> ../architecture/33 -> ../architecture/38 -> ../philosophy/23`
- 想把复杂任务压缩成一套可执行方法：`01 -> 06 -> ../architecture/36 -> ../architecture/37`
- 想真正调优 prompt 和预算，而不是凭感觉乱改：`06 -> 07 -> ../api/32 -> ../architecture/37`
- 想知道什么时候该 compact、什么时候该升级成 task / session / worktree：`06 -> 07 -> 08 -> ../architecture/45`
- 想降低长任务里的人类-模型协调成本，而不是只会继续聊：`06 -> 08 -> 09 -> ../architecture/67 -> ../philosophy/54`
- 想在约束下保持高行动力，而不是靠放大权限硬冲：`06 -> 07 -> 10 -> ../architecture/68 -> ../philosophy/55`
- 想从 Claude Code 反推自己的 Agent 平台实现方法：`06 -> 11 -> ../architecture/66 -> ../architecture/69 -> ../philosophy/56`
- 想把 prompt 当成人机协作接口，而不是继续把它写成一次性长文案：`09 -> 12 -> ../architecture/64 -> ../architecture/67 -> ../philosophy/54`
- 想在秩序里释放有效自由，而不是一路提权：`10 -> 13 -> ../architecture/62 -> ../architecture/68 -> ../philosophy/55`
- 想给未来维护者留下可接手的 runtime，而不是只做当前功能：`11 -> 14 -> ../architecture/66 -> ../architecture/69 -> ../philosophy/56`
- 想知道 UI 真相怎样被翻译成 protocol 真相，而不是继续把显示层误当执行层：`12 -> 15 -> ../architecture/54 -> ../philosophy/57`
- 想把权限、可见性、结果外置和 continuation 写成一套统一定价秩序：`13 -> 16 -> ../architecture/56 -> ../architecture/65 -> ../philosophy/58`
- 想把未来维护者也当正式消费者，而不是把工程制度留在团队口头记忆里：`14 -> 17 -> ../architecture/69 -> ../philosophy/59`
- 想把 prompt 进一步理解成共享前缀资产网络，而不是很多相似小调用：`09 -> 12 -> 18 -> ../architecture/42 -> ../philosophy/30`
- 想研究 Claude Code 源码时先找合同，再看热点文件：`11 -> 14 -> 19 -> ../architecture/38 -> ../api/34`
- 想工程化维持依赖图诚实性，而不是把模块化做成抽象洁癖：`14 -> 17 -> 20 -> ../architecture/58 -> ../philosophy/45`
- 想把共享前缀方法真正写成团队可复用模板，而不是只停在理解层：`18 -> 21 -> ../navigation/07`
- 想把 contract-first 阅读法落成系统审读清单，而不是继续靠经验看大文件：`19 -> 22 -> ../navigation/07`
- 想把依赖图诚实性落成结构评审清单，而不是继续停在抽象判断：`20 -> 23 -> ../navigation/07`
- 想把 Prompt Constitution 写成 builder-facing 设计动作，而不是继续停在哲学层：`24 -> ../architecture/73 -> ../navigation/08`
- 想把安全与省 token 写成有顺序的治理系统，而不是只会谈统一预算器：`25 -> ../architecture/74 -> ../navigation/08`
- 想把构建、入口、transport 与恢复写成同一套工程动作，而不是只看目录漂亮：`26 -> ../architecture/75 -> ../navigation/08`
- 想把 Prompt Constitution 继续压成团队修宪流程、失效台账与 triage runbook：`24 -> 27 -> ../navigation/09`
- 想把治理顺序继续压成失败语义矩阵、自动化租约、审批竞速与稳定字节台账：`25 -> 28 -> ../navigation/09`
- 想把源码塑形继续压成发布面矩阵、入口影子策略与反-zombie 审读清单：`26 -> 29 -> ../navigation/09`
- 想把这些团队模板继续推进成运营、回归、事故复盘与演化演练：`27 -> ../playbooks/01`，`28 -> ../playbooks/02`，`29 -> ../playbooks/03`，统一入口见 `../navigation/10`
- 想直接看这些制度在真实失败形态里长什么样，而不是只看模板与手册：统一入口见 `../navigation/11`，对应样本见 `../casebooks/01-03`
- 想把手册层和样本层继续接成可复用的索引层：统一入口见 `../navigation/12`，对应文档是 `../casebooks/04` 与 `../playbooks/04`
- 想把索引层继续压成可反查、可定义、可示例的参考层：统一入口见 `../navigation/13`，对应文档是 `../casebooks/05-06` 与 `../playbooks/05`
- 想把参考层继续压成现场可用的诊断入口，而不是先猜标签、阶段和资产：统一入口见 `../navigation/14`，对应文档是 `../casebooks/07-09`
- 想在事故发生前先用第一性原理问题自校 Prompt 魔力、安全定价与源码先进性：统一入口见 `../navigation/15`，对应文档是 `30-32`
- 想把这些自校问题继续压成“坏解法 / 为什么坏 / 正解 / 改写路径”的对照样例：统一入口见 `../navigation/16`，对应文档是 `../casebooks/10-12`
- 想把 rollout 样例继续压成统一证据 ABI，而不是每次重新发明 Diff 卡、阶段评审卡与回退记录：`30 -> 31 -> 32 -> 33 -> ../navigation/19 -> ../playbooks/12 -> ../playbooks/13`
- 想让宿主、评审者与后来者共享同一套 rollout 证据真相，而不是各自维护一份解释：`33 -> 34 -> ../navigation/20 -> ../architecture/76 -> ../api/35`
- 想继续用第一性原理问题审读 shared evidence envelope 是否真的成立，而不是只看字段有没有填：`34 -> 35 -> ../navigation/21 -> ../architecture/77 -> ../api/36 -> ../philosophy/68`
- 想把 host implementation 的检查点和反例继续反压成统一审读模板，而不是继续靠资深 reviewer 心法：`35 -> ../navigation/25 -> 36 -> 37 -> 38`
- 想把这些统一审读模板继续压成正式共享工件协议，而不是继续靠不同角色各自导出材料：`../navigation/26 -> ../api/37 -> ../api/38 -> ../api/39`
- 想把这些统一审读模板继续落成正式宿主卡、CI附件、评审卡与交接包协议，而不是继续靠团队本地约定：`../navigation/26 -> ../api/37 -> ../api/38 -> ../api/39`
- 想把 artifact drift 继续编译成自动校验、reviewer gate 与 handoff reject，而不是停在反例识别：`../navigation/29 -> 39 -> 40 -> 41 -> ../philosophy/70`
- 想把这些 validator / linter 继续压成 machine-readable rule ABI，而不是继续靠不同消费者手抄规则：`../navigation/30 -> ../api/40 -> ../api/41 -> ../api/42 -> ../philosophy/71`
- 想把这些 runner / ledger 协议继续下沉成团队每天真的会执行的操作手册，而不是继续停在 API / 架构层：`../navigation/34 -> 42 -> 43 -> 44 -> ../philosophy/75`
- 想把顶层目录地图继续拆到 `services/`、`tools/`、`commands/` 的二级目录，并明确权威入口、消费者子集与危险改动面：`../navigation/35 -> ../api/46 -> ../api/47 -> ../api/48 -> ../philosophy/76`
- 想把这些方法继续收束成可迁移的 Agent Runtime 构建指南、宿主模板与统一蓝图，而不是继续停在阅读与审读层：`../navigation/36 -> 45 -> 46 -> 47 -> ../philosophy/77`
- 想把这些构建方法继续下沉成上下文编译、治理控制面与可演化内核三条 builder-facing 手册，而不是重新退回“强 prompt / 强规则 / 好结构”的表面叙述：`../navigation/37 -> 48 -> 49 -> 50 -> ../philosophy/78 -> ../philosophy/79 -> ../philosophy/80`
- 想把这些 builder-facing 手册继续回灌成真正的运行时机制层，而不是停在方法摘要：`../navigation/38 -> ../architecture/79 -> ../architecture/80 -> ../architecture/81`
- 想把这些第一性原理继续翻译成实现者真的可以照着搭的 builder-facing 手册：`../navigation/42 -> 51 -> 52 -> 53 -> ../philosophy/81 -> ../philosophy/82 -> ../philosophy/83`

## 与其他目录的边界

- 需要字段、schema、控制协议时回到 [../api/README.md](../api/README.md)
- 需要运行时机制时回到 [../architecture/README.md](../architecture/README.md)
- 需要第一性原理解释时回到 [../philosophy/README.md](../philosophy/README.md)
- 需要长期运营、事故复盘、回归与演化演练时切到 [../playbooks/README.md](../playbooks/README.md)
- 需要具体失败样本、事故原型与反模式样本库时切到 [../casebooks/README.md](../casebooks/README.md)
- 再往下一层，应由 `../navigation/25 -> 36-38` 继续回答“怎样把 host implementation 检查点与失真样本统一压成 builder-facing 审读模板”。
- 再往下一层，应由 `../navigation/26 -> ../api/37-39` 继续回答“怎样把统一审读对象压成宿主卡、CI附件、评审卡与 handoff package 的正式共享工件协议”。
- 再往下一层，应由 `../navigation/29 -> 39-41` 继续回答“怎样把 shared header、hard contract 与 drift 原型编译成 validator / linter / reject rule”。
- `../philosophy/70` 负责回答“为什么真正成熟的校验，不是字段齐全，而是共享对象能拒绝漂移”。
- 再往下一层，应由 `../navigation/30 -> ../api/40-42` 继续回答“怎样把这些 validator / linter 正式压成 machine-readable rule packet”。
- `../philosophy/71` 负责回答“为什么真正成熟的规则，不是更多检查，而是不同消费者共享同一拒收语义”。
- 再往下一层，应由 `../navigation/34 -> 42-44` 继续回答“怎样把 replay queue、alignment gate、drift review 与 adoption runbook 压成 builder-facing 手册”。
- `../philosophy/75` 负责回答“为什么真正成熟的继续，不是复用上一轮结论，而是重新消费上一轮留下的判断条件”。
- 再往下一层，应由 `../navigation/36 -> 45-47` 继续回答“怎样把前面所有对象、语法、预算、恢复与 atlas 原则统一压成可迁移的 Agent Runtime 构建方法”。
- `../philosophy/77` 负责回答“为什么真正成熟的构建，不是复刻功能，而是先固定对象、边界、预算与恢复闭环”。
- 再往下一层，应由 `../navigation/37 -> 48-50` 继续回答“怎样把 Prompt 魔力、安全/省 token 同构与源码先进性继续压成上下文编译、治理控制面与可演化内核三条 builder-facing 方法线”。
- `../philosophy/78-80` 负责回答“为什么世界必须先被编译进模型、治理必须同时决定允许什么/看见什么/继续多久、结构必须先替未来维护者保留反驳能力”。
- 再往下一层，应由 `../navigation/38 -> ../architecture/79-81` 继续回答“怎样把这些方法线重新回灌成 compiled request truth、governance control plane 与 evolvable kernel object boundary 三条机制层对象”。
- 再往下一层，应由 `../navigation/42 -> 51-53` 继续回答“怎样把这些第一性原理重新翻译成 section registry / authority source / authority surface 等可执行实现顺序”。
- `../philosophy/81-83` 负责回答“为什么这些实现顺序不是经验技巧，而是 Prompt 编译链、统一定价治理与故障模型编码的不可约判断”。

后续继续补：

- 项目级 skills 工程化设计
- 宿主接入与远程协作实践
