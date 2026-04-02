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
- 再往下一层，应由 `../navigation/29 -> ../guides/39-41` 继续回答“怎样把这些 drift 原型编译成 validator / linter / reject rule”。
- `docs/` 仍只承载项目自己的开发记忆，不承载蓝皮书正文。
