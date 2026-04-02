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

## 按目标阅读

- 想把 Prompt Constitution 从模板层推进到修宪回归与失稳复盘：`../guides/27 -> 01`
- 想把治理顺序从矩阵推进到审批事故、auto-mode 回收与 stable-bytes drift 运营：`../guides/28 -> 02`
- 想把源码塑形从结构模板推进到迁移退出、recovery drill 与 anti-zombie 演练：`../guides/29 -> 03`
- 想先看运营层入口，而不是直接挑单篇：`../navigation/10 -> README`

## 与其他目录的边界

- `guides/` 负责“怎么设计、怎么迁移、怎么做模板”。
- `playbooks/` 负责“怎么运行、怎么回归、怎么复盘、怎么演练”。
- `docs/` 仍只承载项目自己的持久化记忆和开发过程，不承载蓝皮书正文。
