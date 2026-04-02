# 案例样本库

本目录承接蓝皮书的样本层。

如果：

- `guides/` 负责方法
- `playbooks/` 负责运营

那么 `casebooks/` 负责：

- 真实失败样本
- 事故原型
- 结构反模式
- 制度边界在故障中的暴露方式

## 当前入口

1. [01-Prompt事故案例集：修宪漂移、路径失配与合法遗忘失效](01-Prompt事故案例集：修宪漂移、路径失配与合法遗忘失效.md)
2. [02-治理事故案例集：错误顺序、审批退化与稳定字节漂移](02-治理事故案例集：错误顺序、审批退化与稳定字节漂移.md)
3. [03-源码演化案例集：影子层化石化、传输泄漏与zombification](03-源码演化案例集：影子层化石化、传输泄漏与zombification.md)
4. [04-事故标签体系与交叉索引：阶段、资产、症状、根因与恢复动作](04-事故标签体系与交叉索引：阶段、资产、症状、根因与恢复动作.md)
5. [05-样本标签字典：Prompt、治理与结构演化的定义、边界与误分类警戒](05-样本标签字典：Prompt、治理与结构演化的定义、边界与误分类警戒.md)
6. [06-案例与源码锚点反查表：标签、样本、手册、章节与实现入口](06-案例与源码锚点反查表：标签、样本、手册、章节与实现入口.md)
7. [07-按症状反查表：从表象回到Prompt、治理与结构根因](07-按症状反查表：从表象回到Prompt、治理与结构根因.md)
8. [08-按阶段反查表：从design到evolution定位制度断裂点](08-按阶段反查表：从design到evolution定位制度断裂点.md)
9. [09-按资产反查表：section、stable-bytes、shadow-stub与recovery-asset定位](09-按资产反查表：section、stable-bytes、shadow-stub与recovery-asset定位.md)
10. [10-Prompt反例对照：长文案崇拜、主语漂移与共享前缀分叉](10-Prompt%E5%8F%8D%E4%BE%8B%E5%AF%B9%E7%85%A7%EF%BC%9A%E9%95%BF%E6%96%87%E6%A1%88%E5%B4%87%E6%8B%9C%E3%80%81%E4%B8%BB%E8%AF%AD%E6%BC%82%E7%A7%BB%E4%B8%8E%E5%85%B1%E4%BA%AB%E5%89%8D%E7%BC%80%E5%88%86%E5%8F%89.md)
11. [11-安全反例对照：免费扩张、假预算器与不可撤销自动化](11-%E5%AE%89%E5%85%A8%E5%8F%8D%E4%BE%8B%E5%AF%B9%E7%85%A7%EF%BC%9A%E5%85%8D%E8%B4%B9%E6%89%A9%E5%BC%A0%E3%80%81%E5%81%87%E9%A2%84%E7%AE%97%E5%99%A8%E4%B8%8E%E4%B8%8D%E5%8F%AF%E6%92%A4%E9%94%80%E8%87%AA%E5%8A%A8%E5%8C%96.md)
12. [12-源码反例对照：伪模块化、第二真相与zombie温床](12-%E6%BA%90%E7%A0%81%E5%8F%8D%E4%BE%8B%E5%AF%B9%E7%85%A7%EF%BC%9A%E4%BC%AA%E6%A8%A1%E5%9D%97%E5%8C%96%E3%80%81%E7%AC%AC%E4%BA%8C%E7%9C%9F%E7%9B%B8%E4%B8%8Ezombie%E6%B8%A9%E5%BA%8A.md)
13. [13-Prompt Evidence Envelope反例：原文崇拜、汇总崇拜与只读历史交接](13-Prompt%20Evidence%20Envelope%E5%8F%8D%E4%BE%8B%EF%BC%9A%E5%8E%9F%E6%96%87%E5%B4%87%E6%8B%9C%E3%80%81%E6%B1%87%E6%80%BB%E5%B4%87%E6%8B%9C%E4%B8%8E%E5%8F%AA%E8%AF%BB%E5%8E%86%E5%8F%B2%E4%BA%A4%E6%8E%A5.md)
14. [14-治理 Evidence Envelope反例：只看Token、只看审批与只看结果](14-%E6%B2%BB%E7%90%86%20Evidence%20Envelope%E5%8F%8D%E4%BE%8B%EF%BC%9A%E5%8F%AA%E7%9C%8BToken%E3%80%81%E5%8F%AA%E7%9C%8B%E5%AE%A1%E6%89%B9%E4%B8%8E%E5%8F%AA%E7%9C%8B%E7%BB%93%E6%9E%9C.md)
15. [15-结构 Evidence Envelope反例：只看文件Diff、目录美观与作者记忆](15-%E7%BB%93%E6%9E%84%20Evidence%20Envelope%E5%8F%8D%E4%BE%8B%EF%BC%9A%E5%8F%AA%E7%9C%8B%E6%96%87%E4%BB%B6Diff%E3%80%81%E7%9B%AE%E5%BD%95%E7%BE%8E%E8%A7%82%E4%B8%8E%E4%BD%9C%E8%80%85%E8%AE%B0%E5%BF%86.md)
16. [16-Prompt Host Implementation反例：只看卡片存在、只看CI通过与只交接摘要包](16-Prompt%20Host%20Implementation%E5%8F%8D%E4%BE%8B%EF%BC%9A%E5%8F%AA%E7%9C%8B%E5%8D%A1%E7%89%87%E5%AD%98%E5%9C%A8%E3%80%81%E5%8F%AA%E7%9C%8BCI%E9%80%9A%E8%BF%87%E4%B8%8E%E5%8F%AA%E4%BA%A4%E6%8E%A5%E6%91%98%E8%A6%81%E5%8C%85.md)
17. [17-治理 Host Implementation反例：只看仪表盘转绿、只看审批结束与对象升级失语](17-%E6%B2%BB%E7%90%86%20Host%20Implementation%E5%8F%8D%E4%BE%8B%EF%BC%9A%E5%8F%AA%E7%9C%8B%E4%BB%AA%E8%A1%A8%E7%9B%98%E8%BD%AC%E7%BB%BF%E3%80%81%E5%8F%AA%E7%9C%8B%E5%AE%A1%E6%89%B9%E7%BB%93%E6%9D%9F%E4%B8%8E%E5%AF%B9%E8%B1%A1%E5%8D%87%E7%BA%A7%E5%A4%B1%E8%AF%AD.md)
18. [18-结构 Host Implementation反例：只看门禁存在、只看恢复通过与危险路径口头化](18-%E7%BB%93%E6%9E%84%20Host%20Implementation%E5%8F%8D%E4%BE%8B%EF%BC%9A%E5%8F%AA%E7%9C%8B%E9%97%A8%E7%A6%81%E5%AD%98%E5%9C%A8%E3%80%81%E5%8F%AA%E7%9C%8B%E6%81%A2%E5%A4%8D%E9%80%9A%E8%BF%87%E4%B8%8E%E5%8D%B1%E9%99%A9%E8%B7%AF%E5%BE%84%E5%8F%A3%E5%A4%B4%E5%8C%96.md)
19. [19-Prompt Artifact反例：宿主卡退回原文、CI附件只剩绿灯与交接包回到摘要](19-Prompt%20Artifact%E5%8F%8D%E4%BE%8B%EF%BC%9A%E5%AE%BF%E4%B8%BB%E5%8D%A1%E9%80%80%E5%9B%9E%E5%8E%9F%E6%96%87%E3%80%81CI%E9%99%84%E4%BB%B6%E5%8F%AA%E5%89%A9%E7%BB%BF%E7%81%AF%E4%B8%8E%E4%BA%A4%E6%8E%A5%E5%8C%85%E5%9B%9E%E5%88%B0%E6%91%98%E8%A6%81.md)
20. [20-治理 Artifact反例：窗口卡退回状态色、仲裁附件退回计数与交接包失去回退对象](20-%E6%B2%BB%E7%90%86%20Artifact%E5%8F%8D%E4%BE%8B%EF%BC%9A%E7%AA%97%E5%8F%A3%E5%8D%A1%E9%80%80%E5%9B%9E%E7%8A%B6%E6%80%81%E8%89%B2%E3%80%81%E4%BB%B2%E8%A3%81%E9%99%84%E4%BB%B6%E9%80%80%E5%9B%9E%E8%AE%A1%E6%95%B0%E4%B8%8E%E4%BA%A4%E6%8E%A5%E5%8C%85%E5%A4%B1%E5%8E%BB%E5%9B%9E%E9%80%80%E5%AF%B9%E8%B1%A1.md)
21. [21-结构 Artifact反例：权威路径卡退回目录图、恢复附件只剩成功率与交接包回到作者说明](21-%E7%BB%93%E6%9E%84%20Artifact%E5%8F%8D%E4%BE%8B%EF%BC%9A%E6%9D%83%E5%A8%81%E8%B7%AF%E5%BE%84%E5%8D%A1%E9%80%80%E5%9B%9E%E7%9B%AE%E5%BD%95%E5%9B%BE%E3%80%81%E6%81%A2%E5%A4%8D%E9%99%84%E4%BB%B6%E5%8F%AA%E5%89%A9%E6%88%90%E5%8A%9F%E7%8E%87%E4%B8%8E%E4%BA%A4%E6%8E%A5%E5%8C%85%E5%9B%9E%E5%88%B0%E4%BD%9C%E8%80%85%E8%AF%B4%E6%98%8E.md)
22. [22-编译请求真相反例：多重真相生产者、协议真相泄漏与合法遗忘失忆](22-%E7%BC%96%E8%AF%91%E8%AF%B7%E6%B1%82%E7%9C%9F%E7%9B%B8%E5%8F%8D%E4%BE%8B%EF%BC%9A%E5%A4%9A%E9%87%8D%E7%9C%9F%E7%9B%B8%E7%94%9F%E4%BA%A7%E8%80%85%E3%80%81%E5%8D%8F%E8%AE%AE%E7%9C%9F%E7%9B%B8%E6%B3%84%E6%BC%8F%E4%B8%8E%E5%90%88%E6%B3%95%E9%81%97%E5%BF%98%E5%A4%B1%E5%BF%86.md)
23. [23-治理控制面反例：mode崇拜、仪表盘崇拜与默认继续幻觉](23-%E6%B2%BB%E7%90%86%E6%8E%A7%E5%88%B6%E9%9D%A2%E5%8F%8D%E4%BE%8B%EF%BC%9Amode%E5%B4%87%E6%8B%9C%E3%80%81%E4%BB%AA%E8%A1%A8%E7%9B%98%E5%B4%87%E6%8B%9C%E4%B8%8E%E9%BB%98%E8%AE%A4%E7%BB%A7%E7%BB%AD%E5%B9%BB%E8%A7%89.md)
24. [24-内核对象边界反例：多点权威、恢复资产篡位与anti-zombie口头化](24-%E5%86%85%E6%A0%B8%E5%AF%B9%E8%B1%A1%E8%BE%B9%E7%95%8C%E5%8F%8D%E4%BE%8B%EF%BC%9A%E5%A4%9A%E7%82%B9%E6%9D%83%E5%A8%81%E3%80%81%E6%81%A2%E5%A4%8D%E8%B5%84%E4%BA%A7%E7%AF%A1%E4%BD%8D%E4%B8%8Eanti-zombie%E5%8F%A3%E5%A4%B4%E5%8C%96.md)
25. [25-Prompt宿主消费反例：字符串崇拜、缓存黑箱与继续资格误判](25-Prompt%E5%AE%BF%E4%B8%BB%E6%B6%88%E8%B4%B9%E5%8F%8D%E4%BE%8B%EF%BC%9A%E5%AD%97%E7%AC%A6%E4%B8%B2%E5%B4%87%E6%8B%9C%E3%80%81%E7%BC%93%E5%AD%98%E9%BB%91%E7%AE%B1%E4%B8%8E%E7%BB%A7%E7%BB%AD%E8%B5%84%E6%A0%BC%E8%AF%AF%E5%88%A4.md)
26. [26-治理宿主消费反例：mode投影崇拜、pending action降格与rollback object文件化](26-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E6%B6%88%E8%B4%B9%E5%8F%8D%E4%BE%8B%EF%BC%9Amode%E6%8A%95%E5%BD%B1%E5%B4%87%E6%8B%9C%E3%80%81pending%20action%E9%99%8D%E6%A0%BC%E4%B8%8Erollback%20object%E6%96%87%E4%BB%B6%E5%8C%96.md)
27. [27-故障模型宿主消费反例：权威状态猜测、恢复指针神化与成功率崇拜](27-%E6%95%85%E9%9A%9C%E6%A8%A1%E5%9E%8B%E5%AE%BF%E4%B8%BB%E6%B6%88%E8%B4%B9%E5%8F%8D%E4%BE%8B%EF%BC%9A%E6%9D%83%E5%A8%81%E7%8A%B6%E6%80%81%E7%8C%9C%E6%B5%8B%E3%80%81%E6%81%A2%E5%A4%8D%E6%8C%87%E9%92%88%E7%A5%9E%E5%8C%96%E4%B8%8E%E6%88%90%E5%8A%9F%E7%8E%87%E5%B4%87%E6%8B%9C.md)
28. [28-Prompt宿主迁移反例：伪交接、黑箱灰度与继续资格回退幻觉](28-Prompt%E5%AE%BF%E4%B8%BB%E8%BF%81%E7%A7%BB%E5%8F%8D%E4%BE%8B%EF%BC%9A%E4%BC%AA%E4%BA%A4%E6%8E%A5%E3%80%81%E9%BB%91%E7%AE%B1%E7%81%B0%E5%BA%A6%E4%B8%8E%E7%BB%A7%E7%BB%AD%E8%B5%84%E6%A0%BC%E5%9B%9E%E9%80%80%E5%B9%BB%E8%A7%89.md)
29. [29-治理宿主迁移反例：权限账本缺席、假窗口对齐与免费继续回退幻觉](29-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E8%BF%81%E7%A7%BB%E5%8F%8D%E4%BE%8B%EF%BC%9A%E6%9D%83%E9%99%90%E8%B4%A6%E6%9C%AC%E7%BC%BA%E5%B8%AD%E3%80%81%E5%81%87%E7%AA%97%E5%8F%A3%E5%AF%B9%E9%BD%90%E4%B8%8E%E5%85%8D%E8%B4%B9%E7%BB%A7%E7%BB%AD%E5%9B%9E%E9%80%80%E5%B9%BB%E8%A7%89.md)
30. [30-结构宿主迁移反例：伪恢复采纳、指针健康幻觉与写回真相分叉](30-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E8%BF%81%E7%A7%BB%E5%8F%8D%E4%BE%8B%EF%BC%9A%E4%BC%AA%E6%81%A2%E5%A4%8D%E9%87%87%E7%BA%B3%E3%80%81%E6%8C%87%E9%92%88%E5%81%A5%E5%BA%B7%E5%B9%BB%E8%A7%89%E4%B8%8E%E5%86%99%E5%9B%9E%E7%9C%9F%E7%9B%B8%E5%88%86%E5%8F%89.md)
31. [31-Prompt宿主验收执行反例：表单化绿灯、假拒收与伪回退](31-Prompt%E5%AE%BF%E4%B8%BB%E9%AA%8C%E6%94%B6%E6%89%A7%E8%A1%8C%E5%8F%8D%E4%BE%8B%EF%BC%9A%E8%A1%A8%E5%8D%95%E5%8C%96%E7%BB%BF%E7%81%AF%E3%80%81%E5%81%87%E6%8B%92%E6%94%B6%E4%B8%8E%E4%BC%AA%E5%9B%9E%E9%80%80.md)
32. [32-治理宿主验收执行反例：mode绿灯、假窗口对齐与免费继续](32-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E9%AA%8C%E6%94%B6%E6%89%A7%E8%A1%8C%E5%8F%8D%E4%BE%8B%EF%BC%9Amode%E7%BB%BF%E7%81%AF%E3%80%81%E5%81%87%E7%AA%97%E5%8F%A3%E5%AF%B9%E9%BD%90%E4%B8%8E%E5%85%8D%E8%B4%B9%E7%BB%A7%E7%BB%AD.md)
33. [33-结构宿主验收执行反例：breadcrumb篡位、写回繁荣与anti-zombie口头化](33-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E9%AA%8C%E6%94%B6%E6%89%A7%E8%A1%8C%E5%8F%8D%E4%BE%8B%EF%BC%9Abreadcrumb%E7%AF%A1%E4%BD%8D%E3%80%81%E5%86%99%E5%9B%9E%E7%B9%81%E8%8D%A3%E4%B8%8Eanti-zombie%E5%8F%A3%E5%A4%B4%E5%8C%96.md)
34. [34-Prompt宿主修复演练反例：repair object伪绑定、摘要回滚与假重入](34-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E6%BC%94%E7%BB%83%E5%8F%8D%E4%BE%8B%EF%BC%9Arepair%20object%E4%BC%AA%E7%BB%91%E5%AE%9A%E3%80%81%E6%91%98%E8%A6%81%E5%9B%9E%E6%BB%9A%E4%B8%8E%E5%81%87%E9%87%8D%E5%85%A5.md)
35. [35-治理宿主修复演练反例：authority假恢复、假窗口重置与免费重入](35-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E6%BC%94%E7%BB%83%E5%8F%8D%E4%BE%8B%EF%BC%9Aauthority%E5%81%87%E6%81%A2%E5%A4%8D%E3%80%81%E5%81%87%E7%AA%97%E5%8F%A3%E9%87%8D%E7%BD%AE%E4%B8%8E%E5%85%8D%E8%B4%B9%E9%87%8D%E5%85%A5.md)
36. [36-结构宿主修复演练反例：breadcrumb篡位、旁路写回与anti-zombie伪证明](36-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E6%BC%94%E7%BB%83%E5%8F%8D%E4%BE%8B%EF%BC%9Abreadcrumb%E7%AF%A1%E4%BD%8D%E3%80%81%E6%97%81%E8%B7%AF%E5%86%99%E5%9B%9E%E4%B8%8Eanti-zombie%E4%BC%AA%E8%AF%81%E6%98%8E.md)
37. [37-Prompt宿主修复收口执行反例：假完成、假交接与假reopen](37-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E6%94%B6%E5%8F%A3%E6%89%A7%E8%A1%8C%E5%8F%8D%E4%BE%8B%EF%BC%9A%E5%81%87%E5%AE%8C%E6%88%90%E3%80%81%E5%81%87%E4%BA%A4%E6%8E%A5%E4%B8%8E%E5%81%87reopen.md)
38. [38-治理宿主修复收口执行反例：假关账、假交接与免费重开](38-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E6%94%B6%E5%8F%A3%E6%89%A7%E8%A1%8C%E5%8F%8D%E4%BE%8B%EF%BC%9A%E5%81%87%E5%85%B3%E8%B4%A6%E3%80%81%E5%81%87%E4%BA%A4%E6%8E%A5%E4%B8%8E%E5%85%8D%E8%B4%B9%E9%87%8D%E5%BC%80.md)
39. [39-结构宿主修复收口执行反例：假seal、假交接与假重开](39-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E6%94%B6%E5%8F%A3%E6%89%A7%E8%A1%8C%E5%8F%8D%E4%BE%8B%EF%BC%9A%E5%81%87seal%E3%80%81%E5%81%87%E4%BA%A4%E6%8E%A5%E4%B8%8E%E5%81%87%E9%87%8D%E5%BC%80.md)
40. [40-Prompt宿主修复监护执行反例：假观察、假冻结与假reopen](40-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%9B%91%E6%8A%A4%E6%89%A7%E8%A1%8C%E5%8F%8D%E4%BE%8B%EF%BC%9A%E5%81%87%E8%A7%82%E5%AF%9F%E3%80%81%E5%81%87%E5%86%BB%E7%BB%93%E4%B8%8E%E5%81%87reopen.md)
41. [41-治理宿主修复监护执行反例：假观察、假隔离与免费重开](41-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%9B%91%E6%8A%A4%E6%89%A7%E8%A1%8C%E5%8F%8D%E4%BE%8B%EF%BC%9A%E5%81%87%E8%A7%82%E5%AF%9F%E3%80%81%E5%81%87%E9%9A%94%E7%A6%BB%E4%B8%8E%E5%85%8D%E8%B4%B9%E9%87%8D%E5%BC%80.md)
42. [42-结构宿主修复监护执行反例：假稳定、假冻结与假重开](42-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%9B%91%E6%8A%A4%E6%89%A7%E8%A1%8C%E5%8F%8D%E4%BE%8B%EF%BC%9A%E5%81%87%E7%A8%B3%E5%AE%9A%E3%80%81%E5%81%87%E5%86%BB%E7%BB%93%E4%B8%8E%E5%81%87%E9%87%8D%E5%BC%80.md)
43. [43-Prompt宿主修复解除监护执行反例：静默放行、叙事放行与无责任release](43-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E8%A7%A3%E9%99%A4%E7%9B%91%E6%8A%A4%E6%89%A7%E8%A1%8C%E5%8F%8D%E4%BE%8B%EF%BC%9A%E9%9D%99%E9%BB%98%E6%94%BE%E8%A1%8C%E3%80%81%E5%8F%99%E4%BA%8B%E6%94%BE%E8%A1%8C%E4%B8%8E%E6%97%A0%E8%B4%A3%E4%BB%BBrelease.md)
44. [44-治理宿主修复解除监护执行反例：免责式出监、假清账与免费继续](44-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E8%A7%A3%E9%99%A4%E7%9B%91%E6%8A%A4%E6%89%A7%E8%A1%8C%E5%8F%8D%E4%BE%8B%EF%BC%9A%E5%85%8D%E8%B4%A3%E5%BC%8F%E5%87%BA%E7%9B%91%E3%80%81%E5%81%87%E6%B8%85%E8%B4%A6%E4%B8%8E%E5%85%8D%E8%B4%B9%E7%BB%A7%E7%BB%AD.md)
45. [45-结构宿主修复解除监护执行反例：假退休、归档表演与假保留重开](45-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E8%A7%A3%E9%99%A4%E7%9B%91%E6%8A%A4%E6%89%A7%E8%A1%8C%E5%8F%8D%E4%BE%8B%EF%BC%9A%E5%81%87%E9%80%80%E4%BC%91%E3%80%81%E5%BD%92%E6%A1%A3%E8%A1%A8%E6%BC%94%E4%B8%8E%E5%81%87%E4%BF%9D%E7%95%99%E9%87%8D%E5%BC%80.md)
46. [46-Prompt宿主修复稳态执行反例：假稳态、前缀托管表演与无阈值继续](46-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E6%89%A7%E8%A1%8C%E5%8F%8D%E4%BE%8B%EF%BC%9A%E5%81%87%E7%A8%B3%E6%80%81%E3%80%81%E5%89%8D%E7%BC%80%E6%89%98%E7%AE%A1%E8%A1%A8%E6%BC%94%E4%B8%8E%E6%97%A0%E9%98%88%E5%80%BC%E7%BB%A7%E7%BB%AD.md)
47. [47-治理宿主修复稳态执行反例：假稳态、能力托管表演与免费继续复活](47-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E6%89%A7%E8%A1%8C%E5%8F%8D%E4%BE%8B%EF%BC%9A%E5%81%87%E7%A8%B3%E6%80%81%E3%80%81%E8%83%BD%E5%8A%9B%E6%89%98%E7%AE%A1%E8%A1%A8%E6%BC%94%E4%B8%8E%E5%85%8D%E8%B4%B9%E7%BB%A7%E7%BB%AD%E5%A4%8D%E6%B4%BB.md)
48. [48-结构宿主修复稳态执行反例：假稳态、归档托管表演与假边界保留](48-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E6%89%A7%E8%A1%8C%E5%8F%8D%E4%BE%8B%EF%BC%9A%E5%81%87%E7%A8%B3%E6%80%81%E3%80%81%E5%BD%92%E6%A1%A3%E6%89%98%E7%AE%A1%E8%A1%A8%E6%BC%94%E4%B8%8E%E5%81%87%E8%BE%B9%E7%95%8C%E4%BF%9D%E7%95%99.md)
49. [49-Prompt宿主修复稳态纠偏执行反例：假修正卡、口头真相恢复与阈值装饰化](49-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E6%89%A7%E8%A1%8C%E5%8F%8D%E4%BE%8B%EF%BC%9A%E5%81%87%E4%BF%AE%E6%AD%A3%E5%8D%A1%E3%80%81%E5%8F%A3%E5%A4%B4%E7%9C%9F%E7%9B%B8%E6%81%A2%E5%A4%8D%E4%B8%8E%E9%98%88%E5%80%BC%E8%A3%85%E9%A5%B0%E5%8C%96.md)
50. [50-治理宿主修复稳态纠偏执行反例：假纠偏、假再托管与假阈值重绑](50-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E6%89%A7%E8%A1%8C%E5%8F%8D%E4%BE%8B%EF%BC%9A%E5%81%87%E7%BA%A0%E5%81%8F%E3%80%81%E5%81%87%E5%86%8D%E6%89%98%E7%AE%A1%E4%B8%8E%E5%81%87%E9%98%88%E5%80%BC%E9%87%8D%E7%BB%91.md)
51. [51-结构宿主修复稳态纠偏执行反例：假修正、伪复证与假责任保留](51-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E6%89%A7%E8%A1%8C%E5%8F%8D%E4%BE%8B%EF%BC%9A%E5%81%87%E4%BF%AE%E6%AD%A3%E3%80%81%E4%BC%AA%E5%A4%8D%E8%AF%81%E4%B8%8E%E5%81%87%E8%B4%A3%E4%BB%BB%E4%BF%9D%E7%95%99.md)

## 按目标阅读

- 想看 prompt 的制度边界怎样在真实事故里暴露：`../playbooks/01 -> 01`
- 想看治理顺序怎样在真实事故里失真：`../playbooks/02 -> 02`
- 想看源码先进性怎样在长期演化里退化：`../playbooks/03 -> 03`
- 想先看样本层入口而不是直接挑案例：`../navigation/11 -> README`
- 想把样本层做成可检索索引，而不是三篇孤立案例：`04 -> ../playbooks/04 -> ../navigation/12`
- 想直接看标签怎么定义、哪些情况容易误分、以及怎样从标签反查源码入口：`05 -> 06 -> ../navigation/13`
- 想从现场症状直接反查，而不是先猜标签名：`07 -> ../navigation/14`
- 想先按生命周期阶段判断问题诞生位置，而不是把所有锅都丢给 runtime：`08 -> ../navigation/14`
- 想先按受损制度资产反查，而不是先按文件名搜索：`09 -> ../navigation/14`
- 想把这些自反问题继续落成“同题坏解 vs Claude Code 式正解”的迁移样例：`../navigation/15 -> 10 -> 11 -> 12 -> ../navigation/16`
- 想看 shared evidence envelope 一旦被不同消费者拆散会怎样退回半真相：`../navigation/21 -> ../navigation/22 -> 13 -> 14 -> 15`
- 想把这些失真样本继续压成宿主、CI、评审与交接的真实检查点：`../navigation/23 -> ../playbooks/14 -> ../playbooks/15 -> ../playbooks/16`
- 想直接看这些真实检查点在实施里最常怎样重新退回形式主义：`../navigation/24 -> 16 -> 17 -> 18`
- 想把这些实施级失真继续反压成统一审读模板，而不是继续靠经验识别：`../navigation/25 -> ../guides/36 -> ../guides/37 -> ../guides/38`
- 想直接看这些最小共享工件在真实执行里最常怎样重新退回局部真相：`../navigation/28 -> 19 -> 20 -> 21`
- 想继续看机制对象明明已经进入验证层，为什么仍会重新退回 prompt 崇拜、仪表盘崇拜与目录审美：`../navigation/40 -> 22 -> 23 -> 24`
- 想继续看这些宿主消费面明明已经存在，为什么仍会重新退回字符串、仪表盘、成功率与作者说明：`../navigation/44 -> 25 -> 26 -> 27`
- 想继续看这些宿主迁移演练明明已经执行，为什么仍会重新退回伪交接、假灰度与回退幻觉：`../navigation/48 -> 28 -> 29 -> 30`
- 想继续看这些宿主验收执行明明已经存在，为什么仍会重新退回表单化绿灯、假拒收与伪回退：`../navigation/52 -> 31 -> 32 -> 33`
- 想继续看这些宿主修复演练明明已经存在，为什么仍会重新退回假修复、假回滚与假重入：`../navigation/56 -> 34 -> 35 -> 36`
- 想继续看这些宿主修复收口执行明明已经存在，为什么仍会重新退回假完成、假交接与假重开：`../navigation/60 -> 37 -> 38 -> 39`
- 想继续看这些宿主修复监护执行明明已经存在，为什么仍会重新退回假观察、假冻结与假重开：`../navigation/64 -> 40 -> 41 -> 42`
- 想继续看这些宿主修复解除监护执行明明已经存在，为什么仍会重新退回静默放行、免责式出监与假退休：`../navigation/68 -> 43 -> 44 -> 45`
- 想继续看这些宿主修复稳态执行明明已经存在，为什么仍会重新退回假稳态、假托管与假阈值：`../navigation/72 -> 46 -> 47 -> 48`
- 想继续看这些宿主修复稳态纠偏执行明明已经存在，为什么仍会重新退回假修正卡、假恢复顺序与假责任演练：`../navigation/76 -> 49 -> 50 -> 51`

## 与其他目录的边界

- `guides/` 负责“怎么设计”。
- `playbooks/` 负责“怎么运行、怎么复盘”。
- `casebooks/` 负责“坏会怎样、为什么坏、坏在哪”。
- `casebooks/13-15` 继续回答“shared evidence envelope 一旦被宿主、CI、评审与交接拆散消费，会怎样重新退回局部真相”。
- 再往下一层，应由 `../navigation/23 -> ../playbooks/14-16` 继续回答“怎样把这些失真重新收口成统一检查点”。
- `casebooks/16-18` 继续回答“这些统一检查点在真实执行里最常会怎样重新退回存在性合规、流程合规与作者兜底”。
- 再往下一层，应由 `../navigation/25 -> ../guides/36-38` 继续回答“怎样把这些实施级失真反压成统一审读模板”。
- `casebooks/19-21` 继续回答“这些最小共享工件在 artifact 层最常会怎样重新退回原文、计数、状态色、目录图与作者说明等局部真相”。
- 再往下一层，应由 `../navigation/28 -> ../casebooks/19-21` 继续回答“shared artifact 明明已经存在时，四类角色最常怎样各自重新说谎”。
- `casebooks/22-24` 继续回答“机制对象明明已经进入验证层，为什么仍会重新退回多重真相生产、mode/仪表盘崇拜、多点权威与 anti-zombie 口头化等形式主义替身”。
- 再往下一层，应由 `../navigation/40 -> ../casebooks/22-24` 继续回答“这些机制对象最常怎样死于看起来已经落地的假验证与假先进性”。
- `casebooks/25-27` 继续回答“宿主消费面明明已经存在，为什么仍会重新退回 prompt 字符串、治理投影、恢复成功率与作者说明等假信号”。
- 再往下一层，应由 `../navigation/44 -> ../casebooks/25-27` 继续回答“这些 host-consumable support surface 最常怎样死于 consumer misuse 与第二真相重建”。
- `casebooks/28-30` 继续回答“宿主迁移演练明明已经执行，为什么仍会重新退回伪交接、假灰度与回退幻觉等更高级第二真相”。
- 再往下一层，应由 `../navigation/48 -> ../casebooks/28-30` 继续回答“这些迁移演练最常怎样死于看起来已经跑过 drill 的假稳定”。
- `casebooks/31-33` 继续回答“宿主验收执行明明已经存在，为什么仍会重新退回表单化绿灯、假拒收、伪回退、mode 投影、breadcrumb 篡位与监控绿灯等更高级执行幻觉”。
- 再往下一层，应由 `../navigation/52 -> ../casebooks/31-33` 继续回答“这些验收执行最常怎样死于看起来已经更制度化的假严格与假回退”。
- 再往下一层，应由 `../navigation/53 -> ../guides/60-62` 继续回答“怎样把这些执行失真重新压回固定纠偏顺序、拒收升级路径与改写模板骨架”。
- `casebooks/34-36` 继续回答“宿主修复演练明明已经存在，为什么仍会重新退回 repair object 伪绑定、authority 假恢复、breadcrumb 篡位、摘要回滚、免费重入与 anti-zombie 伪证明等更高级修复幻觉”。
- 再往下一层，应由 `../navigation/56 -> ../casebooks/34-36` 继续回答“这些修复演练最常怎样死于看起来已经更制度化的假修复、假回滚与假重入”。
- 再往下一层，应由 `../navigation/57 -> ../guides/63-65` 继续回答“怎样把这些 repair drill 失真重新压回固定纠偏顺序、拒收升级路径与改写模板骨架”。
- `casebooks/37-39` 继续回答“宿主修复收口执行明明已经存在，为什么仍会重新退回假完成、假交接、假关账、免费重开、假 seal 与假连续性等更高级收口幻觉”。
- 再往下一层，应由 `../navigation/60 -> ../casebooks/37-39` 继续回答“这些收口执行最常怎样死于看起来已经正式 closeout 的假完成、假交接与假重开”。
- 再往下一层，应由 `../navigation/61 -> ../guides/66-68` 继续回答“怎样把这些 closeout execution 失真重新压回固定纠偏顺序、拒收升级路径与改写模板骨架”。
- `casebooks/40-42` 继续回答“宿主修复监护执行明明已经存在，为什么仍会重新退回假观察、假冻结、免费重开、pointer 健康感、dashboard 崇拜与作者记忆等更高级监护幻觉”。
- 再往下一层，应由 `../navigation/64 -> ../casebooks/40-42` 继续回答“这些 watch execution 最常怎样死于看起来已经在认真观察的假监护、假冻结与假重开”。
- 再往下一层，应由 `../navigation/65 -> ../guides/69-71` 继续回答“怎样把这些 watch execution 失真重新压回固定纠偏顺序、拒收升级路径与改写模板骨架”。
- `casebooks/43-45` 继续回答“宿主修复解除监护执行明明已经存在，为什么仍会重新退回静默放行、免责式出监、假退休、归档表演与假保留重开等更高级 release 幻觉”。
- 再往下一层，应由 `../navigation/68 -> ../casebooks/43-45` 继续回答“这些 watch release execution 最常怎样死于看起来已经正式 released 的假放行、假责任与假退休”。
- 再往下一层，应由 `../navigation/69 -> ../guides/72-74` 继续回答“怎样把这些 watch release execution 失真重新压回固定纠偏顺序、拒收升级路径与改写模板骨架”。
- `casebooks/46-48` 继续回答“宿主修复稳态执行明明已经存在，为什么仍会重新退回假稳态、假托管、假阈值、免费继续复活、pointer 健康感与作者记忆等更高级 steady-state 幻觉”。
- 再往下一层，应由 `../navigation/72 -> ../casebooks/46-48` 继续回答“这些 steady-state execution 最常怎样死于看起来已经正式 steady 的假稳态、假托管与假阈值”。
- 下一层入口见 `../navigation/73 -> ../guides/75-77`，继续回答“怎样把这些 steady-state execution 失真重新压回固定纠偏顺序、拒收升级路径与改写模板骨架”。
- `casebooks/49-51` 继续回答“宿主修复稳态纠偏执行明明已经存在，为什么仍会重新退回假修正卡、假恢复顺序、假再托管、伪复证与假责任保留等更高级 correction 幻觉”。
- 再往下一层，应由 `../navigation/76 -> ../casebooks/49-51` 继续回答“这些 steady-state correction execution 最常怎样死于看起来已经正式 restored 的假修正卡、假恢复顺序与假责任演练”。
- `../navigation/77 -> ../guides/78-80` 继续回答“怎样把这些 steady-state correction execution 失真重新压回固定顺序、拒收升级路径与改写模板骨架”。
- `../navigation/78 -> ../api/75-77` 继续回答“怎样把这些 steady-state correction-of-correction 继续压成宿主可消费的修正对象、拒收升级语义与长期 reopen 责任面”。
- `../navigation/79 -> ../playbooks/56-58` 继续回答“怎样把这些 steady-state correction-of-correction protocol 继续压成固定 recorrection card、reject 顺序与 re-entry / reopen 责任演练”。
- 再往下一层，应由 `../navigation/80 -> ../casebooks/52-54` 继续回答“为什么这些 steady-state correction-of-correction execution 明明已经存在，仍会重新退回假 recorrection card、假 reject 顺序与假 reopen 责任演练”。
- 再往下一层，应由 `../navigation/29 -> ../guides/39-41` 继续回答“怎样把这些 drift 原型编译成 validator / linter / reject rule”。
- `docs/` 仍只承载项目自己的开发记忆，不承载蓝皮书正文。
