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

## 与其他目录的边界

- 需要字段、schema、控制协议时回到 [../api/README.md](../api/README.md)
- 需要运行时机制时回到 [../architecture/README.md](../architecture/README.md)
- 需要第一性原理解释时回到 [../philosophy/README.md](../philosophy/README.md)
- 需要长期运营、事故复盘、回归与演化演练时切到 [../playbooks/README.md](../playbooks/README.md)
- 需要具体失败样本、事故原型与反模式样本库时切到 [../casebooks/README.md](../casebooks/README.md)

后续继续补：

- 项目级 skills 工程化设计
- 宿主接入与远程协作实践
