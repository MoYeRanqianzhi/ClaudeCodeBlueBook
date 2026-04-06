# 蓝皮书入口

蓝皮书正文现在只先回答三件事：世界如何进入模型，扩张如何被定价，当前如何不被过去写坏。第一次进入先读 [09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md)，再回 [03-设计哲学](03-设计哲学.md) 与 [06-第一性原理与苏格拉底反思](06-第一性原理与苏格拉底反思.md)。

## 目录职责

- `bluebook/00-09`
  宪法主线与最短判断。
- 各子目录 `README`
  专题入口、编号段职责与稳定跳转。
- [navigation/README.md](navigation/README.md)
  judgment map 与跨目录反查。
- [userbook/README.md](userbook/README.md)
  面向使用者的稳定入口，不替代蓝皮书主线。
- [../docs/README.md](../docs/README.md)
  研究过程、长期记忆与变更记录，不承载正文。

## 按问题进入

- 想先建立主线宪法
  读 `09 -> 03 -> 06`。
- 想看请求装配 / Prompt 设计哲学
  先回 `09`，再去 [philosophy/README.md](philosophy/README.md)、[architecture/README.md](architecture/README.md)、[guides/README.md](guides/README.md)。
- 想看扩张定价、安全与省 token
  先回 `09` 的第二张图，再去 [philosophy/19-安全与Token经济不是权衡而是同一优化](philosophy/19-安全与Token经济不是权衡而是同一优化.md)、[philosophy/22-安全、成本与体验必须共用预算器](philosophy/22-安全、成本与体验必须共用预算器.md)、[security/README.md](security/README.md)、[risk/README.md](risk/README.md)。
- 想看当前真相保护与源码先进性
  先回 `09` 的第三张图，再去 [philosophy/76-真正成熟的源码地图，不是目录列得更细，而是更快暴露权威入口、消费者子集与危险改动面](philosophy/76-真正成熟的源码地图，不是目录列得更细，而是更快暴露权威入口、消费者子集与危险改动面.md)、[philosophy/59-源码先进性不在静态分层，而在未来维护者也是正式消费者](philosophy/59-源码先进性不在静态分层，而在未来维护者也是正式消费者.md)、[architecture/README.md](architecture/README.md)、[guides/README.md](guides/README.md)。
- 想看使用者世界
  直接去 [userbook/README.md](userbook/README.md)。
- 想跨目录反查
  去 [navigation/README.md](navigation/README.md)。

## 证据梯度

目录结构真正值钱的地方，不是入口更多，而是每层只承载一种证据职责：

- `bluebook/00-09`
  宪法主线与总判断。
- `philosophy/`
  不可约判断与第一性原理。
- `architecture/`
  运行时对象、chokepoint 与 current-truth protection。
- `api/`
  contract、schema 与 host-facing truth。
- `guides/`
  模板、审读清单与矩阵母版。
- `playbooks/`
  准入、收口、回归与拒收 verdict。
- `casebooks/`
  distortion、伪证信号与误判样本。
- `navigation/`
  judgment map 与跨目录反查。
- `docs/`
  长时记忆、研究过程与变更记录。

如果一页同时在做判断、矩阵、verdict、样本和记忆，目录结构就会重新退回临时拼盘。
