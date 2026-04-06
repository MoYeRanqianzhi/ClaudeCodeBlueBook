# 蓝皮书入口

蓝皮书正文现在只先回答三件事：世界如何进入模型，扩张如何被定价，当前如何不被过去写坏。第一次进入先读 [09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md)，再回 [03-设计哲学](03-设计哲学.md) 与 [06-第一性原理与苏格拉底反思](06-第一性原理与苏格拉底反思.md)。

根 README 的职责只有三层：先定题，再定证据层，最后才决定要不要跨目录跳转；它不再负责把整套深链重新摊平。

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

## 三步进入法

- 第一步先定题，不先找页。
  回 `09 / 03 / 06`，先判断自己究竟在问请求装配、扩张定价，还是当前真相保护。
- 第二步再定证据层，不先追长链。
  判断归 `philosophy/`，对象归 `architecture/`，合同归 `api/`，模板归 `guides/`，verdict 归 `playbooks/`，反例归 `casebooks/`。
- 第三步最后才决定要不要跨目录。
  只有当问题已经变成“下一层证据去哪里找”时，才进入 `navigation/`。

## 按问题进入

- 想先建立主线宪法
  读 `09 -> 03 -> 06`。
- 想看 `world entry / request assembly / six-stage assembly chain`
  先回 `09`，再去 [philosophy/README.md](philosophy/README.md)、[architecture/README.md](architecture/README.md)、[guides/README.md](guides/README.md)。
- 想看扩张定价与当前世界准入主权
  先回 `09` 的第二张图，再去 [philosophy/19-安全与Token经济不是权衡而是同一优化](philosophy/19-安全与Token经济不是权衡而是同一优化.md)、[philosophy/22-安全、成本与体验必须共用预算器](philosophy/22-安全、成本与体验必须共用预算器.md)、[security/README.md](security/README.md)、[risk/README.md](risk/README.md)；这一组共同回答的治理前门是 `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup`。
- 想看防过去写坏现在的当前真相保护
  先回 `09` 的第三张图，再去 [architecture/84：current-truth surface 与反僵尸图谱](architecture/84-权威面与反僵尸图谱：single-writer surfaces、409 adoption、bridge pointer freshness与release shaping.md)、[philosophy/76：源码地图为什么先暴露权威入口、消费者子集与危险改动面](philosophy/76-真正成熟的源码地图，不是目录列得更细，而是更快暴露权威入口、消费者子集与危险改动面.md)、[philosophy/86：为什么先进内核先防过去写坏现在](philosophy/86-真正先进的内核，不是更会分层，而是更会阻止过去写坏现在.md)、[philosophy/87：为什么源码质量首先是复杂度中心合法](philosophy/87-真正成熟的源码质量判断，不是文件更小，而是复杂度中心合法、边界可证、下一次重构仍有路.md)、[guides/101：如何审读 current-truth surface](guides/101-如何用苏格拉底诘问法审读one writable present：single-writer、recovery asset与anti-zombie.md)、[guides/102：如何做源码质量证据分级](guides/102-如何给公开镜像做源码质量证据分级：contract、registry、authoritative surface、adapter subset与hotspot gap discipline.md) 与 [playbooks/79：one writable present 回归手册](playbooks/79-one writable present验证手册：single-writer authority、recovery asset与anti-zombie回归.md)。
- 想看使用者世界
  直接去 [userbook/README.md](userbook/README.md)。
- 想跨目录反查
  去 [navigation/README.md](navigation/README.md)。
- 想继续写、改或审蓝皮书
  先读 `06 -> 09 -> navigation/05`，先把对象链、同题坏解与改写顺序校正，再回具体目录。

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
