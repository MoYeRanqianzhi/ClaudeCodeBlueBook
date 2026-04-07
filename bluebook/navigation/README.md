# 跨目录入口

`navigation/` 只做跨目录反查，不重新定义三条母线。只有两种情况留在这里：

1. 你已经知道主语，只缺下一层证据或 next-hop。
2. 你在争某页是否越位改判。

如果你还缺主语、最小顺序或 first reject path，先回 [../README.md](../README.md) 与 `09`。

这里默认只回答 next-hop：

- 缺主语、最小顺序或 first reject path，回 `../README.md` 与 `09`
- 缺目录法或入口升级规则，回 `../../docs/development/00-研究方法.md`
- 缺源码质量证据 ceiling，回 `guides/102`

## 三类 route 缺口

- Prompt
  - 缺顶层主语与 `first-reject path`，回 `philosophy/84`
  - 缺“为什么这轮还只该 route trim”，回 [../06-第一性原理与苏格拉底反思.md](../06-%E7%AC%AC%E4%B8%80%E6%80%A7%E5%8E%9F%E7%90%86%E4%B8%8E%E8%8B%8F%E6%A0%BC%E6%8B%89%E5%BA%95%E5%8F%8D%E6%80%9D.md) 与 [../../docs/development/00-研究方法.md](../../docs/development/00-%E7%A0%94%E7%A9%B6%E6%96%B9%E6%B3%95.md)
- 治理
  - 缺治理首答，回 `../10`
  - 已确认主语，只缺 signer / weak readback / reopen / execution path，回 `security / risk / playbooks`
  - 还在争 mode、usage、approval 或 cleanup result 谁说了算，先退回 `../README` 与 `09`
- 当前真相
  - 缺方法入口或 evidence ceiling，回 `09 -> guides/102`
  - 已确认 ceiling，只剩 `sole writer / recovery asset / anti-zombie` 争议，回 `guides/101` 与 `architecture/README`
  - 还在混 runtime-core evidence、operator-governance evidence 与公开镜像缺口，先退回 `06`

## 稳定节点

- [01-第一性原理阅读地图](01-第一性原理阅读地图.md)
  - 第一次进入蓝皮书时的主线阅读路由。
- [02-能力、API与治理检索图](02-能力、API与治理检索图.md)
  - 按问题反查能力、接口与治理入口。
- [04-目录职责、规范入口与兼容别名页说明](04-目录职责、规范入口与兼容别名页说明.md)
  - 判断某个入口、atlas、矩阵、verdict 或记忆该落在哪一层。
- [05-设计母线导航：工作语法、反扩张与可演化内核](05-设计母线导航：工作语法、反扩张与可演化内核.md)
  - 校正你到底在模仿什么，不让三条母线退回结果词。
- [15-苏格拉底审读导航：请求装配控制面、统一定价治理与当前真相保护](15-苏格拉底审读导航：请求装配控制面、统一定价治理与当前真相保护.md)
  - 失稳前的高阶追问入口，负责暴露第一条反证信号。
- [41-机制哲学导航：请求装配、统一定价治理与当前真相保护如何回到第一性原理](41-机制哲学导航：请求装配、统一定价治理与当前真相保护如何回到第一性原理.md)
  - 把深专题结论回压成第一性原理，不再停在对象层总结。
- [46-宿主迁移工单导航：Prompt、治理与故障模型支持面如何进入实施顺序、交接包与灰度发布](46-宿主迁移工单导航：Prompt、治理与故障模型支持面如何进入实施顺序、交接包与灰度发布.md)
  - 进入宿主实现、迁移、验收与收口链。

## 维护约定

- `navigation/` 只保留稳定节点与 route gap，不把每条深链重新摊平成首页。
- 如果一个 route 句子开始代签 truth、owner law 或 verdict，它就已经越位。
- 如果新的 route 提案还需要解释 canonical formula、最小顺序或目录法，就先退回 `../README`、`09` 与 `docs/development/00`。
