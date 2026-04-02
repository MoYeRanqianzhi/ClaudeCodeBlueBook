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

## 与其他目录的边界

- `guides/` 负责“怎么设计、怎么迁移、怎么做模板”。
- `playbooks/` 负责“怎么运行、怎么回归、怎么复盘、怎么演练”。
- `playbooks/06-08` 继续回答“怎么按顺序迁移、灰度、停机与回退”。
- `playbooks/09-11` 继续回答“迁移后真实灰度发生了什么、看了哪些指标、如何回退”。
- `casebooks/` 负责“坏会怎样、为什么坏、具体坏在哪”。
- `docs/` 仍只承载项目自己的持久化记忆和开发过程，不承载蓝皮书正文。
