# 跨目录入口

`navigation/` 只负责跨目录反查，不重新定义三条母线。需要权威短语与最短主线时先回 [../09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md](../09-%E4%B8%89%E5%BC%A0%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%B8%96%E7%95%8C%E8%BF%9B%E5%85%A5%E6%A8%A1%E5%9E%8B%E3%80%81%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7%E4%B8%8E%E9%98%B2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md)；只有当问题已经变成“我要跨目录找哪一层证据”时再留在这里。

## 稳定节点

- [01-第一性原理阅读地图](01-第一性原理阅读地图.md)
  第一次进入蓝皮书时的主线阅读路由。
- [02-能力、API与治理检索图](02-能力、API与治理检索图.md)
  按问题反查能力、接口与治理入口。
- [04-目录职责、规范入口与兼容别名页说明](04-目录职责、规范入口与兼容别名页说明.md)
  判断某个入口、atlas、矩阵、verdict 或记忆该落在哪一层。
- [15-苏格拉底审读导航：请求装配控制面、统一定价治理与当前真相保护](15-苏格拉底审读导航：Prompt魔力、安全定价与源码先进性的自我校准.md)
  失稳前的高阶审读入口。
- [41-机制哲学导航：请求装配、统一定价治理与当前真相保护如何回到第一性原理](41-机制哲学导航：Prompt魔力、统一定价治理与故障模型编码如何回到第一性原理.md)
  把深专题回压成第一性原理。
- [46-宿主迁移工单导航：message lineage、governance key 与 current-truth surface 如何进入实施顺序、交接包与灰度发布](46-宿主迁移工单导航：Prompt、治理与故障模型支持面如何进入实施顺序、交接包与灰度发布.md)
  进入宿主实现、迁移、验收与收口链。

## 三条跨目录链

- 请求装配线
  `09 -> architecture/82 -> philosophy/84 -> guides/99 -> playbooks/77 -> casebooks/73`
- 扩张定价线
  `09 -> architecture/83 -> philosophy/19 / philosophy/22 -> guides/100 -> playbooks/78 -> casebooks/74`；核心治理线是 `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup`
- 当前真相线
  `09 -> architecture/84 -> philosophy/76 / philosophy/86 / philosophy/87 -> guides/101 / guides/102 -> playbooks/79 -> casebooks/75`

如果问题已经进入运行手册层，不要在这里重新拼全链；直接去对应的 `playbooks/README.md`、`guides/README.md` 或 `security/README.md`。

## 什么时候用它

- 需要跨章节、跨目录、跨证据层反查时
- 需要确认某个问题该先看判断、架构、模板、verdict 还是反例时
- 需要把 `architecture / guides / playbooks / casebooks` 串成同一条判断链时
- 需要确认某个入口页究竟是正文前门、判断地图还是记忆层时

## 维护约定

- `navigation/` 只给稳定节点，不把每条深链摊平成首页。
- 目录细节与编号段说明回各目录 `README` 或编号页。
- 过程记录与变更记忆统一回 `docs/`。
