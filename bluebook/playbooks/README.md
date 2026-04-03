# 运营与复盘手册

本目录承接蓝皮书的运营层。

如果 `guides/` 负责回答：

- 怎样设计
- 怎样迁移
- 怎样把制度压成模板

那么 `playbooks/` 负责回答：

- 怎样回归
- 怎样复盘
- 怎样演练
- 怎样在长期运行里继续守住制度

## 当前入口

1. [01-Prompt修宪回归手册：section-drift、boundary-drift与lawful-forgetting事故复盘](01-Prompt修宪回归手册：section-drift、boundary-drift与lawful-forgetting事故复盘.md)
2. [02-治理事故运营手册：approval-race、auto-mode撤销、stable-bytes漂移与stop-logic回归](02-治理事故运营手册：approval-race、auto-mode撤销、stable-bytes漂移与stop-logic回归.md)
3. [03-源码演化演练手册：build-surface、shadow-stub退出、recovery-drill与anti-zombie复盘](03-源码演化演练手册：build-surface、shadow-stub退出、recovery-drill与anti-zombie复盘.md)
4. [04-演练记录模板：前提、触发器、观测、判定、修复与防再发](04-演练记录模板：前提、触发器、观测、判定、修复与防再发.md)
5. [05-演练记录样例库：Prompt、治理与结构演化三类完整样例](05-演练记录样例库：Prompt、治理与结构演化三类完整样例.md)
6. [06-Prompt迁移工单：从长文案到Prompt Constitution的改写顺序与灰度策略](06-Prompt%E8%BF%81%E7%A7%BB%E5%B7%A5%E5%8D%95%EF%BC%9A%E4%BB%8E%E9%95%BF%E6%96%87%E6%A1%88%E5%88%B0Prompt%20Constitution%E7%9A%84%E6%94%B9%E5%86%99%E9%A1%BA%E5%BA%8F%E4%B8%8E%E7%81%B0%E5%BA%A6%E7%AD%96%E7%95%A5.md)
7. [07-治理迁移工单：从规则堆叠到统一定价秩序的改写顺序与停止条件](07-%E6%B2%BB%E7%90%86%E8%BF%81%E7%A7%BB%E5%B7%A5%E5%8D%95%EF%BC%9A%E4%BB%8E%E8%A7%84%E5%88%99%E5%A0%86%E5%8F%A0%E5%88%B0%E7%BB%9F%E4%B8%80%E5%AE%9A%E4%BB%B7%E7%A7%A9%E5%BA%8F%E7%9A%84%E6%94%B9%E5%86%99%E9%A1%BA%E5%BA%8F%E4%B8%8E%E5%81%9C%E6%AD%A2%E6%9D%A1%E4%BB%B6.md)
8. [08-结构迁移工单：从伪模块化到权威面与反zombie结构的改写顺序](08-%E7%BB%93%E6%9E%84%E8%BF%81%E7%A7%BB%E5%B7%A5%E5%8D%95%EF%BC%9A%E4%BB%8E%E4%BC%AA%E6%A8%A1%E5%9D%97%E5%8C%96%E5%88%B0%E6%9D%83%E5%A8%81%E9%9D%A2%E4%B8%8E%E5%8F%8Dzombie%E7%BB%93%E6%9E%84%E7%9A%84%E6%94%B9%E5%86%99%E9%A1%BA%E5%BA%8F.md)
9. [09-Prompt Rollout样例：从长文案到Prompt Constitution的灰度记录](09-Prompt%20Rollout%E6%A0%B7%E4%BE%8B%EF%BC%9A%E4%BB%8E%E9%95%BF%E6%96%87%E6%A1%88%E5%88%B0Prompt%20Constitution%E7%9A%84%E7%81%B0%E5%BA%A6%E8%AE%B0%E5%BD%95.md)
10. [10-治理 Rollout样例：从规则堆叠到统一定价秩序的灰度记录](10-%E6%B2%BB%E7%90%86%20Rollout%E6%A0%B7%E4%BE%8B%EF%BC%9A%E4%BB%8E%E8%A7%84%E5%88%99%E5%A0%86%E5%8F%A0%E5%88%B0%E7%BB%9F%E4%B8%80%E5%AE%9A%E4%BB%B7%E7%A7%A9%E5%BA%8F%E7%9A%84%E7%81%B0%E5%BA%A6%E8%AE%B0%E5%BD%95.md)
11. [11-结构 Rollout样例：从第二真相到权威面与反zombie结构的灰度记录](11-%E7%BB%93%E6%9E%84%20Rollout%E6%A0%B7%E4%BE%8B%EF%BC%9A%E4%BB%8E%E7%AC%AC%E4%BA%8C%E7%9C%9F%E7%9B%B8%E5%88%B0%E6%9D%83%E5%A8%81%E9%9D%A2%E4%B8%8E%E5%8F%8Dzombie%E7%BB%93%E6%9E%84%E7%9A%84%E7%81%B0%E5%BA%A6%E8%AE%B0%E5%BD%95.md)
12. [12-统一Rollout ABI模板：对象、Diff、阶段、观测与回退记录](12-%E7%BB%9F%E4%B8%80Rollout%20ABI%E6%A8%A1%E6%9D%BF%EF%BC%9A%E5%AF%B9%E8%B1%A1%E3%80%81Diff%E3%80%81%E9%98%B6%E6%AE%B5%E3%80%81%E8%A7%82%E6%B5%8B%E4%B8%8E%E5%9B%9E%E9%80%80%E8%AE%B0%E5%BD%95.md)
13. [13-Rollout证据卡样例库：Prompt、治理与结构三类最小填写示例](13-Rollout%E8%AF%81%E6%8D%AE%E5%8D%A1%E6%A0%B7%E4%BE%8B%E5%BA%93%EF%BC%9APrompt%E3%80%81%E6%B2%BB%E7%90%86%E4%B8%8E%E7%BB%93%E6%9E%84%E4%B8%89%E7%B1%BB%E6%9C%80%E5%B0%8F%E5%A1%AB%E5%86%99%E7%A4%BA%E4%BE%8B.md)
14. [14-Prompt Evidence Envelope落地手册：宿主消费、CI门禁、评审顺序与交接包](14-Prompt%20Evidence%20Envelope%E8%90%BD%E5%9C%B0%E6%89%8B%E5%86%8C%EF%BC%9A%E5%AE%BF%E4%B8%BB%E6%B6%88%E8%B4%B9%E3%80%81CI%E9%97%A8%E7%A6%81%E3%80%81%E8%AF%84%E5%AE%A1%E9%A1%BA%E5%BA%8F%E4%B8%8E%E4%BA%A4%E6%8E%A5%E5%8C%85.md)
15. [15-治理 Evidence Envelope落地手册：决策窗口、仲裁证据、对象升级与回退门禁](15-%E6%B2%BB%E7%90%86%20Evidence%20Envelope%E8%90%BD%E5%9C%B0%E6%89%8B%E5%86%8C%EF%BC%9A%E5%86%B3%E7%AD%96%E7%AA%97%E5%8F%A3%E3%80%81%E4%BB%B2%E8%A3%81%E8%AF%81%E6%8D%AE%E3%80%81%E5%AF%B9%E8%B1%A1%E5%8D%87%E7%BA%A7%E4%B8%8E%E5%9B%9E%E9%80%80%E9%97%A8%E7%A6%81.md)
16. [16-结构 Evidence Envelope落地手册：权威面、恢复资产、反zombie 与交接闸门](16-%E7%BB%93%E6%9E%84%20Evidence%20Envelope%E8%90%BD%E5%9C%B0%E6%89%8B%E5%86%8C%EF%BC%9A%E6%9D%83%E5%A8%81%E9%9D%A2%E3%80%81%E6%81%A2%E5%A4%8D%E8%B5%84%E4%BA%A7%E3%80%81%E5%8F%8Dzombie%20%E4%B8%8E%E4%BA%A4%E6%8E%A5%E9%97%B8%E9%97%A8.md)
17. [17-Prompt Artifact样例库：宿主卡、CI附件、评审卡与交接包最小填写示例](17-Prompt%20Artifact%E6%A0%B7%E4%BE%8B%E5%BA%93%EF%BC%9A%E5%AE%BF%E4%B8%BB%E5%8D%A1%E3%80%81CI%E9%99%84%E4%BB%B6%E3%80%81%E8%AF%84%E5%AE%A1%E5%8D%A1%E4%B8%8E%E4%BA%A4%E6%8E%A5%E5%8C%85%E6%9C%80%E5%B0%8F%E5%A1%AB%E5%86%99%E7%A4%BA%E4%BE%8B.md)
18. [18-治理 Artifact样例库：窗口卡、仲裁附件、评审卡与交接包最小填写示例](18-%E6%B2%BB%E7%90%86%20Artifact%E6%A0%B7%E4%BE%8B%E5%BA%93%EF%BC%9A%E7%AA%97%E5%8F%A3%E5%8D%A1%E3%80%81%E4%BB%B2%E8%A3%81%E9%99%84%E4%BB%B6%E3%80%81%E8%AF%84%E5%AE%A1%E5%8D%A1%E4%B8%8E%E4%BA%A4%E6%8E%A5%E5%8C%85%E6%9C%80%E5%B0%8F%E5%A1%AB%E5%86%99%E7%A4%BA%E4%BE%8B.md)
19. [19-结构 Artifact样例库：权威路径卡、恢复附件、评审卡与交接包最小填写示例](19-%E7%BB%93%E6%9E%84%20Artifact%E6%A0%B7%E4%BE%8B%E5%BA%93%EF%BC%9A%E6%9D%83%E5%A8%81%E8%B7%AF%E5%BE%84%E5%8D%A1%E3%80%81%E6%81%A2%E5%A4%8D%E9%99%84%E4%BB%B6%E3%80%81%E8%AF%84%E5%AE%A1%E5%8D%A1%E4%B8%8E%E4%BA%A4%E6%8E%A5%E5%8C%85%E6%9C%80%E5%B0%8F%E5%A1%AB%E5%86%99%E7%A4%BA%E4%BE%8B.md)
20. [20-Prompt Artifact Rule Sample Kit：Shared Object、Stable Bytes、Lawful Forgetting 与 Rewrite Hint 最小规则样例](20-Prompt%20Artifact%20Rule%20Sample%20Kit%EF%BC%9AShared%20Object%E3%80%81Stable%20Bytes%E3%80%81Lawful%20Forgetting%20%E4%B8%8E%20Rewrite%20Hint%20%E6%9C%80%E5%B0%8F%E8%A7%84%E5%88%99%E6%A0%B7%E4%BE%8B.md)
21. [21-治理 Artifact Rule Sample Kit：Decision Gain、Failure Semantics、Rollback Object 与 Reject 最小规则样例](21-%E6%B2%BB%E7%90%86%20Artifact%20Rule%20Sample%20Kit%EF%BC%9ADecision%20Gain%E3%80%81Failure%20Semantics%E3%80%81Rollback%20Object%20%E4%B8%8E%20Reject%20%E6%9C%80%E5%B0%8F%E8%A7%84%E5%88%99%E6%A0%B7%E4%BE%8B.md)
22. [22-结构 Artifact Rule Sample Kit：Authoritative Path、Recovery Asset、Anti-Zombie 与 Reject 最小规则样例](22-%E7%BB%93%E6%9E%84%20Artifact%20Rule%20Sample%20Kit%EF%BC%9AAuthoritative%20Path%E3%80%81Recovery%20Asset%E3%80%81Anti-Zombie%20%E4%B8%8E%20Reject%20%E6%9C%80%E5%B0%8F%E8%A7%84%E5%88%99%E6%A0%B7%E4%BE%8B.md)
23. [23-Prompt Artifact Evaluator Harness：Continuation Replay、跨消费者对齐与 Drift 回归实验室](23-Prompt%20Artifact%20Evaluator%20Harness%EF%BC%9AContinuation%20Replay%E3%80%81%E8%B7%A8%E6%B6%88%E8%B4%B9%E8%80%85%E5%AF%B9%E9%BD%90%E4%B8%8E%20Drift%20%E5%9B%9E%E5%BD%92%E5%AE%9E%E9%AA%8C%E5%AE%A4.md)
24. [24-治理 Artifact Evaluator Harness：Decision Gain Replay、跨消费者对齐与 Drift 回归实验室](24-%E6%B2%BB%E7%90%86%20Artifact%20Evaluator%20Harness%EF%BC%9ADecision%20Gain%20Replay%E3%80%81%E8%B7%A8%E6%B6%88%E8%B4%B9%E8%80%85%E5%AF%B9%E9%BD%90%E4%B8%8E%20Drift%20%E5%9B%9E%E5%BD%92%E5%AE%9E%E9%AA%8C%E5%AE%A4.md)
25. [25-结构 Artifact Evaluator Harness：Split-Brain Replay、Anti-Zombie 对齐与 Drift 回归实验室](25-%E7%BB%93%E6%9E%84%20Artifact%20Evaluator%20Harness%EF%BC%9ASplit-Brain%20Replay%E3%80%81Anti-Zombie%20%E5%AF%B9%E9%BD%90%E4%B8%8E%20Drift%20%E5%9B%9E%E5%BD%92%E5%AE%9E%E9%AA%8C%E5%AE%A4.md)
26. [26-编译请求真相验证手册：section continuity、stable bytes、protocol rewrite与lawful forgetting回归](26-%E7%BC%96%E8%AF%91%E8%AF%B7%E6%B1%82%E7%9C%9F%E7%9B%B8%E9%AA%8C%E8%AF%81%E6%89%8B%E5%86%8C%EF%BC%9Asection%20continuity%E3%80%81stable%20bytes%E3%80%81protocol%20rewrite%E4%B8%8Elawful%20forgetting%E5%9B%9E%E5%BD%92.md)
27. [27-治理控制面对象验证手册：authority source、decision window、continuation gate与rollback object回归](27-%E6%B2%BB%E7%90%86%E6%8E%A7%E5%88%B6%E9%9D%A2%E5%AF%B9%E8%B1%A1%E9%AA%8C%E8%AF%81%E6%89%8B%E5%86%8C%EF%BC%9Aauthority%20source%E3%80%81decision%20window%E3%80%81continuation%20gate%E4%B8%8Erollback%20object%E5%9B%9E%E5%BD%92.md)
28. [28-可演化内核对象验证手册：authority、transition、dependency、recovery asset与anti-zombie回归](28-%E5%8F%AF%E6%BC%94%E5%8C%96%E5%86%85%E6%A0%B8%E5%AF%B9%E8%B1%A1%E9%AA%8C%E8%AF%81%E6%89%8B%E5%86%8C%EF%BC%9Aauthority%E3%80%81transition%E3%80%81dependency%E3%80%81recovery%20asset%E4%B8%8Eanti-zombie%E5%9B%9E%E5%BD%92.md)
29. [29-Prompt宿主接入审读手册：输入面、section breakdown、cache break可解释性与continue qualification排查](29-Prompt%E5%AE%BF%E4%B8%BB%E6%8E%A5%E5%85%A5%E5%AE%A1%E8%AF%BB%E6%89%8B%E5%86%8C%EF%BC%9A%E8%BE%93%E5%85%A5%E9%9D%A2%E3%80%81section%20breakdown%E3%80%81cache%20break%E5%8F%AF%E8%A7%A3%E9%87%8A%E6%80%A7%E4%B8%8Econtinue%20qualification%E6%8E%92%E6%9F%A5.md)
30. [30-治理宿主接入审读手册：authority source、decision window、pending action与rollback object排查](30-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E6%8E%A5%E5%85%A5%E5%AE%A1%E8%AF%BB%E6%89%8B%E5%86%8C%EF%BC%9Aauthority%20source%E3%80%81decision%20window%E3%80%81pending%20action%E4%B8%8Erollback%20object%E6%8E%92%E6%9F%A5.md)
31. [31-故障模型宿主接入审读手册：authority state、recovery boundary与anti-zombie结果面排查](31-%E6%95%85%E9%9A%9C%E6%A8%A1%E5%9E%8B%E5%AE%BF%E4%B8%BB%E6%8E%A5%E5%85%A5%E5%AE%A1%E8%AF%BB%E6%89%8B%E5%86%8C%EF%BC%9Aauthority%20state%E3%80%81recovery%20boundary%E4%B8%8Eanti-zombie%E7%BB%93%E6%9E%9C%E9%9D%A2%E6%8E%92%E6%9F%A5.md)
32. [32-Prompt宿主迁移演练手册：compiled request truth交接包、灰度记录与回退演练](32-Prompt%E5%AE%BF%E4%B8%BB%E8%BF%81%E7%A7%BB%E6%BC%94%E7%BB%83%E6%89%8B%E5%86%8C%EF%BC%9Acompiled%20request%20truth%E4%BA%A4%E6%8E%A5%E5%8C%85%E3%80%81%E7%81%B0%E5%BA%A6%E8%AE%B0%E5%BD%95%E4%B8%8E%E5%9B%9E%E9%80%80%E6%BC%94%E7%BB%83.md)
33. [33-治理宿主迁移演练手册：统一定价控制面交接包、灰度记录与回退演练](33-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E8%BF%81%E7%A7%BB%E6%BC%94%E7%BB%83%E6%89%8B%E5%86%8C%EF%BC%9A%E7%BB%9F%E4%B8%80%E5%AE%9A%E4%BB%B7%E6%8E%A7%E5%88%B6%E9%9D%A2%E4%BA%A4%E6%8E%A5%E5%8C%85%E3%80%81%E7%81%B0%E5%BA%A6%E8%AE%B0%E5%BD%95%E4%B8%8E%E5%9B%9E%E9%80%80%E6%BC%94%E7%BB%83.md)
34. [34-故障模型宿主迁移演练手册：结构真相面交接包、灰度记录与回退演练](34-%E6%95%85%E9%9A%9C%E6%A8%A1%E5%9E%8B%E5%AE%BF%E4%B8%BB%E8%BF%81%E7%A7%BB%E6%BC%94%E7%BB%83%E6%89%8B%E5%86%8C%EF%BC%9A%E7%BB%93%E6%9E%84%E7%9C%9F%E7%9B%B8%E9%9D%A2%E4%BA%A4%E6%8E%A5%E5%8C%85%E3%80%81%E7%81%B0%E5%BA%A6%E8%AE%B0%E5%BD%95%E4%B8%8E%E5%9B%9E%E9%80%80%E6%BC%94%E7%BB%83.md)
35. [35-Prompt宿主验收执行手册：compiled request truth验收卡、拒收顺序与回退剧本](35-Prompt%E5%AE%BF%E4%B8%BB%E9%AA%8C%E6%94%B6%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Acompiled%20request%20truth%E9%AA%8C%E6%94%B6%E5%8D%A1%E3%80%81%E6%8B%92%E6%94%B6%E9%A1%BA%E5%BA%8F%E4%B8%8E%E5%9B%9E%E9%80%80%E5%89%A7%E6%9C%AC.md)
36. [36-治理宿主验收执行手册：authority source、permission ledger、decision window、continuation gate与rollback剧本](36-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E9%AA%8C%E6%94%B6%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Aauthority%20source%E3%80%81permission%20ledger%E3%80%81decision%20window%E3%80%81continuation%20gate%E4%B8%8Erollback%E5%89%A7%E6%9C%AC.md)
37. [37-结构宿主验收执行手册：authority state、resume order、recovery boundary、writeback path与anti-zombie剧本](37-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E9%AA%8C%E6%94%B6%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Aauthority%20state%E3%80%81resume%20order%E3%80%81recovery%20boundary%E3%80%81writeback%20path%E4%B8%8Eanti-zombie%E5%89%A7%E6%9C%AC.md)
38. [38-Prompt宿主修复演练手册：repair object共享升级卡、rollback drill与re-entry drill](38-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E6%BC%94%E7%BB%83%E6%89%8B%E5%86%8C%EF%BC%9Arepair%20object%E5%85%B1%E4%BA%AB%E5%8D%87%E7%BA%A7%E5%8D%A1%E3%80%81rollback%20drill%E4%B8%8Ere-entry%20drill.md)
39. [39-治理宿主修复演练手册：authority repair共享升级卡、rollback drill与re-entry drill](39-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E6%BC%94%E7%BB%83%E6%89%8B%E5%86%8C%EF%BC%9Aauthority%20repair%E5%85%B1%E4%BA%AB%E5%8D%87%E7%BA%A7%E5%8D%A1%E3%80%81rollback%20drill%E4%B8%8Ere-entry%20drill.md)
40. [40-结构宿主修复演练手册：authority recovery共享升级卡、rollback drill与re-entry drill](40-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E6%BC%94%E7%BB%83%E6%89%8B%E5%86%8C%EF%BC%9Aauthority%20recovery%E5%85%B1%E4%BA%AB%E5%8D%87%E7%BA%A7%E5%8D%A1%E3%80%81rollback%20drill%E4%B8%8Ere-entry%20drill.md)
41. [41-Prompt宿主修复收口执行手册：closeout card、completion verdict order、handoff warranty与reopen drill](41-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E6%94%B6%E5%8F%A3%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Acloseout%20card%E3%80%81completion%20verdict%20order%E3%80%81handoff%20warranty%E4%B8%8Ereopen%20drill.md)
42. [42-治理宿主修复收口执行手册：closeout card、completion verdict order、handoff warranty与reopen drill](42-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E6%94%B6%E5%8F%A3%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Acloseout%20card%E3%80%81completion%20verdict%20order%E3%80%81handoff%20warranty%E4%B8%8Ereopen%20drill.md)
43. [43-结构宿主修复收口执行手册：closeout card、completion verdict order、handoff warranty与reopen drill](43-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E6%94%B6%E5%8F%A3%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Acloseout%20card%E3%80%81completion%20verdict%20order%E3%80%81handoff%20warranty%E4%B8%8Ereopen%20drill.md)
44. [44-Prompt宿主修复监护执行手册：watch card、drift verdict order、handoff freeze与reopen drill](44-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%9B%91%E6%8A%A4%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Awatch%20card%E3%80%81drift%20verdict%20order%E3%80%81handoff%20freeze%E4%B8%8Ereopen%20drill.md)
45. [45-治理宿主修复监护执行手册：watch card、drift verdict order、quarantine order与reopen drill](45-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%9B%91%E6%8A%A4%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Awatch%20card%E3%80%81drift%20verdict%20order%E3%80%81quarantine%20order%E4%B8%8Ereopen%20drill.md)
46. [46-结构宿主修复监护执行手册：watch card、drift verdict order、handoff freeze与reopen drill](46-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%9B%91%E6%8A%A4%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Awatch%20card%E3%80%81drift%20verdict%20order%E3%80%81handoff%20freeze%E4%B8%8Ereopen%20drill.md)
47. [47-Prompt宿主修复解除监护执行手册：release card、release verdict order、handoff release与residual reopen drill](47-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E8%A7%A3%E9%99%A4%E7%9B%91%E6%8A%A4%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Arelease%20card%E3%80%81release%20verdict%20order%E3%80%81handoff%20release%E4%B8%8Eresidual%20reopen%20drill.md)
48. [48-治理宿主修复解除监护执行手册：release card、release verdict order、capability release与reopen liability drill](48-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E8%A7%A3%E9%99%A4%E7%9B%91%E6%8A%A4%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Arelease%20card%E3%80%81release%20verdict%20order%E3%80%81capability%20release%E4%B8%8Ereopen%20liability%20drill.md)
49. [49-结构宿主修复解除监护执行手册：release card、release verdict order、archive drill、boundary retirement与reopen reservation drill](49-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E8%A7%A3%E9%99%A4%E7%9B%91%E6%8A%A4%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Arelease%20card%E3%80%81release%20verdict%20order%E3%80%81archive%20drill%E3%80%81boundary%20retirement%E4%B8%8Ereopen%20reservation%20drill.md)
50. [50-Prompt宿主修复稳态执行手册：steady-state card、continuity verdict order、re-entry threshold与residual reopen drill](50-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Asteady-state%20card%E3%80%81continuity%20verdict%20order%E3%80%81re-entry%20threshold%E4%B8%8Eresidual%20reopen%20drill.md)
51. [51-治理宿主修复稳态执行手册：steady-state card、pricing verdict order、capability custody与liability drill](51-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Asteady-state%20card%E3%80%81pricing%20verdict%20order%E3%80%81capability%20custody%E4%B8%8Eliability%20drill.md)
52. [52-结构宿主修复稳态执行手册：steady-state card、steady verdict order、archive custody、re-entry threshold与reopen reservation drill](52-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Asteady-state%20card%E3%80%81steady%20verdict%20order%E3%80%81archive%20custody%E3%80%81re-entry%20threshold%E4%B8%8Ereopen%20reservation%20drill.md)
53. [53-Prompt宿主修复稳态纠偏执行手册：correction card、recovery verdict order、requalification drill与threshold reinstatement drill](53-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Acorrection%20card%E3%80%81recovery%20verdict%20order%E3%80%81requalification%20drill%E4%B8%8Ethreshold%20reinstatement%20drill.md)
54. [54-治理宿主修复稳态纠偏执行手册：correction card、correction verdict order、capability recustody与threshold rebinding drill](54-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Acorrection%20card%E3%80%81correction%20verdict%20order%E3%80%81capability%20recustody%E4%B8%8Ethreshold%20rebinding%20drill.md)
55. [55-结构宿主修复稳态纠偏执行手册：correction card、correction verdict order、archive restitution、re-entry threshold与reopen responsibility drill](55-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Acorrection%20card%E3%80%81correction%20verdict%20order%E3%80%81archive%20restitution%E3%80%81re-entry%20threshold%E4%B8%8Ereopen%20responsibility%20drill.md)
56. [56-Prompt宿主修复稳态纠偏再纠偏执行手册：recorrection card、reject verdict order、protocol repair drill与threshold liability drill](56-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Arecorrection%20card%E3%80%81reject%20verdict%20order%E3%80%81protocol%20repair%20drill%E4%B8%8Ethreshold%20liability%20drill.md)
57. [57-治理宿主修复稳态纠偏再纠偏执行手册：recorrection card、reject verdict order、window refreeze drill、capability liability与threshold rebinding drill](57-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Arecorrection%20card%E3%80%81reject%20verdict%20order%E3%80%81window%20refreeze%20drill%E3%80%81capability%20liability%E4%B8%8Ethreshold%20rebinding%20drill.md)
58. [58-结构宿主修复稳态纠偏再纠偏执行手册：recorrection card、authority-first reject order、single-source seam audit、anti-zombie evidence rebinding与reopen liability drill](58-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Arecorrection%20card%E3%80%81authority-first%20reject%20order%E3%80%81single-source%20seam%20audit%E3%80%81anti-zombie%20evidence%20rebinding%E4%B8%8Ereopen%20liability%20drill.md)
59. [59-Prompt宿主修复稳态纠偏再纠偏改写执行手册：rewrite card、reject verdict order、protocol rewrite drill与threshold liability drill](59-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Arewrite%20card%E3%80%81reject%20verdict%20order%E3%80%81protocol%20rewrite%20drill%E4%B8%8Ethreshold%20liability%20drill.md)
60. [60-治理宿主修复稳态纠偏再纠偏改写执行手册：rewrite card、reject verdict order、window repricing drill、capability liability与threshold rebinding drill](60-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Arewrite%20card%E3%80%81reject%20verdict%20order%E3%80%81window%20repricing%20drill%E3%80%81capability%20liability%E4%B8%8Ethreshold%20rebinding%20drill.md)
61. [61-结构宿主修复稳态纠偏再纠偏改写执行手册：rewrite card、authority-first reject order、single-source seam audit、anti-zombie evidence rebinding与reopen liability drill](61-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Arewrite%20card%E3%80%81authority-first%20reject%20order%E3%80%81single-source%20seam%20audit%E3%80%81anti-zombie%20evidence%20rebinding%E4%B8%8Ereopen%20liability%20drill.md)
62. [62-Prompt宿主修复稳态纠偏再纠偏改写纠偏执行手册：rewrite correction card、section registry与threshold drill](62-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Arewrite%20correction%20card%E3%80%81section%20registry%E4%B8%8Ethreshold%20drill.md)
63. [63-治理宿主修复稳态纠偏再纠偏改写纠偏执行手册：pricing、writeback seam与threshold drill](63-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Apricing%E3%80%81writeback%20seam%E4%B8%8Ethreshold%20drill.md)
64. [64-结构宿主修复稳态纠偏再纠偏改写纠偏执行手册：fresh merge、transport与reopen drill](64-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Afresh%20merge%E3%80%81transport%E4%B8%8Ereopen%20drill.md)
65. [65-Prompt宿主修复稳态纠偏再纠偏改写纠偏精修执行手册：host consumption card、hard reject order与reopen drill](65-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E7%B2%BE%E4%BF%AE%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Ahost%20consumption%20card%E3%80%81hard%20reject%20order%E4%B8%8Ereopen%20drill.md)
66. [66-治理宿主修复稳态纠偏再纠偏改写纠偏精修执行手册：host consumption card、hard reject order与reopen drill](66-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E7%B2%BE%E4%BF%AE%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Ahost%20consumption%20card%E3%80%81hard%20reject%20order%E4%B8%8Ereopen%20drill.md)
67. [67-结构宿主修复稳态纠偏再纠偏改写纠偏精修执行手册：host consumption card、hard reject order与reopen drill](67-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E7%B2%BE%E4%BF%AE%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Ahost%20consumption%20card%E3%80%81hard%20reject%20order%E4%B8%8Ereopen%20drill.md)

## 按目标阅读

- 想把 Prompt Constitution 从模板层推进到修宪回归与失稳复盘：`../guides/27 -> 01`
- 想把治理顺序从矩阵推进到审批事故、auto-mode 回收与 stable-bytes drift 运营：`../guides/28 -> 02`
- 想把源码塑形从结构模板推进到迁移退出、recovery drill 与 anti-zombie 演练：`../guides/29 -> 03`
- 想先看运营层入口，而不是直接挑单篇：`../navigation/10 -> README`
- 想直接看真实失败样本和事故原型，而不是先读手册：`../navigation/11 -> ../casebooks/README`
- 想把手册层和样本层继续压成统一记录格式：`04 -> ../casebooks/04 -> ../navigation/12`
- 想直接看三类完整填表示例，而不是自己从空模板起步：`05 -> ../navigation/13`
- 想把反例对照继续落成真正可执行的改写顺序、灰度与回退：`../navigation/17 -> 06 -> 07 -> 08`
- 想把迁移工单继续落成完整 rollout 证据样例，而不是只停在计划：`../navigation/18 -> 09 -> 10 -> 11`
- 想把 rollout 样例继续压成统一 diff 卡、阶段评审卡、灰度结果卡与回退记录 ABI：`../navigation/19 -> 12 -> 13`
- 想把统一 ABI 继续接回宿主消费、回退对象与复盘真相面：`../navigation/20 -> ../architecture/76 -> ../api/35 -> ../guides/34`
- 想让这些证据继续被宿主、CI、评审与交接共享成同一套 envelope：`../navigation/21 -> ../architecture/77 -> ../api/36 -> ../guides/35`
- 想直接看 shared envelope 一旦被不同消费者拆散会怎样坏掉，而不是只看理想做法：`../navigation/22 -> ../casebooks/13 -> ../casebooks/14 -> ../casebooks/15`
- 想直接把这套 envelope 落成宿主、CI、评审与交接的统一检查点，而不是只停在原则与反例：`../navigation/23 -> 14 -> 15 -> 16`
- 想直接看这套 implementation playbook 在真实执行里最常怎样重新失真：`../navigation/24 -> ../casebooks/16 -> ../casebooks/17 -> ../casebooks/18`
- 想直接看宿主卡、CI附件、评审卡与交接包真正填出来是什么样，而不是只看 contract：`../navigation/27 -> 17 -> 18 -> 19`
- 想直接看这些最小共享工件在团队执行里最常怎样重新退回局部真相，而不是误把样例当落地完成：`../navigation/28 -> ../casebooks/19 -> ../casebooks/20 -> ../casebooks/21`
- 想直接看这些 rule packet 在不同消费者里怎样被最小样例、失败样例与 rewrite 样例反复验证：`../navigation/31 -> 20 -> 21 -> 22`
- 想直接看这些规则样例怎样继续被组织成可重放验证、跨消费者对齐与 drift 回归实验室：`../navigation/32 -> 23 -> 24 -> 25`
- 想直接看这些实验室怎样继续进入 replay queue、alignment gate、drift ledger 与 rewrite adoption 的持续执行底盘：`../navigation/33 -> ../api/43 -> ../api/44 -> ../api/45 -> ../architecture/78 -> ../philosophy/74`
- 想把刚回灌出来的机制对象继续变成长期运行里的真实回归门禁，而不是停在架构解释层：`../navigation/39 -> 26 -> 27 -> 28`
- 想把这些 support-surface misuse 继续压成宿主接入排查、演练与拒收顺序，而不是停在反例描述：`../navigation/45 -> 29 -> 30 -> 31`
- 想把这些宿主迁移工单继续压成交接样例、灰度记录与回退演练，而不是停在实施顺序：`../navigation/47 -> 32 -> 33 -> 34`
- 想把这些宿主验收协议继续压成值班、CI、评审与交接共享的执行卡、拒收顺序与回退剧本，而不是停在 contract 字段层：`../navigation/51 -> 35 -> 36 -> 37`
- 想继续看这些宿主验收执行明明已经存在，为什么仍会重新退回表单化绿灯、假拒收与伪回退，而不是误把执行卡当完成证明：`../navigation/52 -> ../casebooks/31 -> ../casebooks/32 -> ../casebooks/33`
- 想继续把这些宿主修复监护协议压成真正值班可执行的 watch card、drift verdict order 与 reopen drill，而不是停在 watch contract 字段层：`../navigation/63 -> 44 -> 45 -> 46`
- 想继续把这些宿主修复解除监护协议压成真正值班可执行的 release card、release verdict order 与 reopen 责任演练，而不是停在 release contract 字段层：`../navigation/67 -> 47 -> 48 -> 49`
- 想继续看这些宿主修复解除监护执行明明已经存在，为什么仍会重新退回静默放行、免责式出监与假退休，而不是误把 released 当成正式证明：`../navigation/68 -> ../casebooks/43 -> ../casebooks/44 -> ../casebooks/45`
- 想继续把这些宿主修复稳态协议压成真正值班可执行的巡检卡、稳态判定顺序、再入场阈值与 residual reopen 责任演练，而不是停在 steady-state contract 字段层：`../navigation/71 -> 50 -> 51 -> 52`
- 想继续看这些宿主修复稳态执行明明已经存在，为什么仍会重新退回假稳态、假托管与假阈值，而不是误把 steady-state card 当成正式证明：`../navigation/72 -> ../casebooks/46 -> ../casebooks/47 -> ../casebooks/48`
- 想继续把这些宿主修复稳态纠偏协议压成真正值班可执行的 correction card、执行顺序与再入场责任演练，而不是停在 correction protocol 字段层：`../navigation/75 -> 53 -> 54 -> 55`
- 想继续看这些宿主修复稳态纠偏执行明明已经存在，为什么仍会重新退回假修正卡、假恢复顺序与假责任演练，而不是误把 correction card 当成正式恢复证明：`../navigation/76 -> ../casebooks/49 -> ../casebooks/50 -> ../casebooks/51`

## 与其他目录的边界

- `guides/` 负责“怎么设计、怎么迁移、怎么做模板”。
- `playbooks/` 负责“怎么运行、怎么回归、怎么复盘、怎么演练”。
- `playbooks/06-08` 继续回答“怎么按顺序迁移、灰度、停机与回退”。
- `playbooks/09-11` 继续回答“迁移后真实灰度发生了什么、看了哪些指标、如何回退”。
- `playbooks/12-13` 继续回答“怎样把 rollout 证据压成统一 ABI，并给出最小填写样例”。
- 再往下一层，应由 `navigation/20 -> architecture/76 -> api/35` 继续回答“这套 ABI 怎样进入宿主消费、回退对象与复盘真相面”。
- 再往下一层，应由 `navigation/21 -> architecture/77 -> api/36` 继续回答“这些证据怎样被宿主、CI、评审与交接共享成同一套 envelope”。
- 再往下一层，应由 `navigation/22 -> casebooks/13-15` 继续回答“这套 envelope 最常见会怎样被不同消费者拆散并失真”。
- 再往下一层，应由 `navigation/23 -> playbooks/14-16` 继续回答“怎样把这套 envelope 真正落成宿主、CI、评审与交接的检查点”。
- 再往下一层，应由 `navigation/24 -> casebooks/16-18` 继续回答“这些检查点在真实执行里最常会怎样重新退回形式主义”。
- 再往下一层，应由 `navigation/27 -> playbooks/17-19` 继续回答“这些共享工件协议真正填出来时长什么样”。
- 再往下一层，应由 `navigation/28 -> casebooks/19-21` 继续回答“这些最小共享工件在真实执行里最常怎样重新退回局部真相”。
- 再往下一层，应由 `navigation/29 -> guides/39-41` 继续回答“怎样把这些局部真相漂移正式编译成自动校验、reviewer gate 与 handoff reject”。
- 再往下一层，应由 `navigation/31 -> playbooks/20-22` 继续回答“怎样把这些 machine-readable 规则包压成可反复验证的最小样例、失败样例与 evaluator 接口”。
- 再往下一层，应由 `navigation/32 -> playbooks/23-25` 继续回答“怎样把这些样例接口接成可重放验证、跨消费者对齐与 drift 回归实验室”。
- 再往下一层，应由 `../navigation/33 -> ../api/43-45 -> ../architecture/78` 继续回答“怎样把这些实验室继续接成可持续执行的 runner / ledger 底盘”。
- 再往下一层，应由 `../navigation/39 -> 26-28 -> ../architecture/79-81 -> ../api/49-50` 继续回答“怎样让 compiled request truth、governance object 与 evolvable kernel object boundary 进入持续回归与拒收门禁”。
- 再往下一层，应由 `../navigation/45 -> 29-31 -> ../api/51-53 -> ../casebooks/25-27` 继续回答“怎样把宿主消费面误用继续压成排查顺序、演练集、拒收条件与复盘动作”。
- 再往下一层，应由 `../navigation/47 -> 32-34 -> ../guides/54-56` 继续回答“怎样把这些宿主迁移工单继续压成交接样例、灰度记录与回退演练”。
- 再往下一层，应由 `../navigation/50 -> ../api/54-56 -> ../navigation/51 -> 35-37` 继续回答“怎样把这些宿主验收协议继续压成固定执行卡、拒收顺序与回退处理剧本”。
- 再往下一层，应由 `../navigation/52 -> ../casebooks/31-33` 继续回答“为什么这些宿主验收执行明明已经存在，仍会重新退回假严格、假拒收与假回退”。
- 再往下一层，应由 `../navigation/54 -> ../api/57-59 -> ../navigation/55 -> 38-40` 继续回答“怎样把这些宿主修复协议继续压成共享升级卡、rollback drill 与 re-entry drill”。
- 再往下一层，应由 `../navigation/56 -> ../casebooks/34-36` 继续回答“为什么这些宿主修复演练明明已经存在，仍会重新退回假修复、假回滚与假重入”。
- 再往下一层，应由 `../navigation/58 -> ../api/60-62 -> ../navigation/59 -> 41-43` 继续回答“怎样把这些宿主修复收口协议继续压成固定收口卡、完成判定顺序与交接剧本”。
- 再往下一层，应由 `../navigation/62 -> ../api/63-65 -> ../navigation/63 -> 44-46` 继续回答“怎样把这些宿主修复监护协议继续压成固定监护卡、漂移判定顺序与重开演练”。
- 再往下一层，应由 `../navigation/66 -> ../api/66-68 -> ../navigation/67 -> 47-49` 继续回答“怎样把这些宿主修复解除监护协议继续压成固定 release card、release verdict 顺序、capability / handoff release 与 reopen 责任演练”。
- 再往下一层，应由 `../navigation/68 -> ../casebooks/43-45` 继续回答“为什么这些宿主修复解除监护执行明明已经存在，仍会重新退回静默放行、免责式出监与假退休”。
- 再往下一层，应由 `../navigation/70 -> ../api/69-71 -> ../navigation/71 -> 50-52` 继续回答“怎样把这些宿主修复稳态协议继续压成固定巡检卡、稳态判定顺序、再入场阈值与 residual reopen 责任演练”。
- 再往下一层，应由 `../navigation/72 -> ../casebooks/46-48` 继续回答“为什么这些宿主修复稳态执行明明已经存在，仍会重新退回假稳态、假托管与假阈值”。
- 再往下一层，应由 `../navigation/73 -> ../guides/75-77` 继续回答“怎样把这些稳态执行失真重新压回固定纠偏顺序、拒收升级路径与改写模板骨架”。
- 再往下一层，应由 `../navigation/74 -> ../api/72-74 -> ../navigation/75 -> 53-55` 继续回答“怎样把这些稳态纠偏协议继续压成固定 correction card、执行顺序与 re-entry / reopen 责任演练”。
- 再往下一层，应由 `../navigation/76 -> ../casebooks/49-51` 继续回答“为什么这些宿主修复稳态纠偏执行明明已经存在，仍会重新退回假修正卡、假恢复顺序与假责任演练”。
- `../navigation/77 -> ../guides/78-80` 继续回答“怎样把这些稳态纠偏执行失真重新压回固定顺序、拒收升级路径与改写模板骨架”。
- `../navigation/78 -> ../api/75-77` 继续回答“怎样把这些稳态纠偏再纠偏继续压成宿主可消费的修正对象、拒收升级语义与长期 reopen 责任面”。
- `../navigation/79 -> 56-58` 继续回答“怎样把这些稳态纠偏再纠偏协议继续压成固定 recorrection card、reject 顺序与 re-entry / reopen 责任演练”。
- `53-55` 负责 first-order correction execution；`56-58` 负责 correction-of-correction protocol execution。
- `../navigation/80 -> ../casebooks/52-54` 继续回答“为什么这些稳态纠偏再纠偏执行明明已经存在，仍会重新退回假 recorrection card、假 reject 顺序与假 reopen 责任演练”。
- `../navigation/81 -> ../guides/81-83` 继续回答“怎样把这些稳态纠偏再纠偏执行失真重新压回固定顺序、拒收升级路径与改写模板骨架”。
- 再往下一层，应由 `../navigation/82 -> ../api/78-80` 继续回答“怎样把这些稳态纠偏再纠偏改写继续压成宿主可消费的修正对象、拒收升级语义与长期 reopen 责任面”。
- `../navigation/83 -> 59-61` 继续回答“怎样把这些稳态纠偏再纠偏改写协议继续压成固定 rewrite card、reject 顺序与 re-entry / reopen 责任演练”。
- `59-61` 负责 correction-of-correction rewrite protocol execution。
- `../navigation/87 -> 62-64` 继续回答“怎样把这些稳态纠偏再纠偏改写纠偏协议继续压成固定 rewrite correction card、reject 顺序与 re-entry / reopen 责任演练”。
- `62-64` 负责 correction-of-correction rewrite correction protocol execution。
- `../navigation/91 -> 65-67` 继续回答“怎样把这些稳态纠偏再纠偏改写纠偏精修协议继续压成固定 host consumption card、hard reject 顺序与 reopen 责任演练”。
- `65-67` 负责 correction-of-correction rewrite correction refinement protocol execution。
- `../navigation/92 -> ../casebooks/61-63` 继续回答“为什么这些 refinement execution 明明已经存在，仍会重新退回假 host consumption card、假 hard reject 顺序与假 reopen 责任演练”。
- `../navigation/93 -> ../guides/90-92` 继续回答“怎样把这些 refinement execution 失真重新压回固定 refinement 顺序、拒收升级路径与改写模板骨架”。
- 再往下一层，应由 `../navigation/94 -> ../api/87-89` 继续回答“怎样把这些 refinement correction 继续压成宿主可消费的修正对象、拒收语义与长期 reopen 责任面”。
- 再往下一层，应由 `../navigation/84 -> ../casebooks/55-57` 继续回答“为什么这些稳态纠偏再纠偏改写执行明明已经存在，仍会重新退回假 rewrite card、假 reject 顺序与假 reopen 责任演练”。
- 再往下一层，应由 `../navigation/88 -> ../casebooks/58-60` 继续回答“为什么这些稳态纠偏再纠偏改写纠偏执行明明已经存在，仍会重新退回假 rewrite correction card、假 reject 顺序与假 reopen 责任演练”。
- `casebooks/` 负责“坏会怎样、为什么坏、具体坏在哪”。
- `docs/` 仍只承载项目自己的持久化记忆和开发过程，不承载蓝皮书正文。
