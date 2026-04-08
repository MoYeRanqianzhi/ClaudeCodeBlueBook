# 跨目录入口

`navigation/` 只做跨目录反查，不重新定义三条母线。只有两种情况留在这里：

1. 你已经知道主语，只缺下一层证据或 next-hop。
2. 你在争某页是否越位改判。

如果你还缺主语或最小顺序，先回 [../README.md](../README.md)；但三条线的正式 first-hop 要记死：

- Prompt 顶层主语与 first-reject path，直接回 `philosophy/84`
- 治理首答，直接回 `../10`
- 当前真相与 source-quality artifact chain，直接按 `../README.md -> guides/102`

这里默认只回答 artifact gap，而不是页面归属：

- 缺目录法或入口升级规则，回 `../../docs/development/00-研究方法.md`
- 缺当前真相的 artifact chain 起点、`ceiling note`、`downgrade stamp`、`unresolved-authority note` 或 `change-risk record`，回 `../README.md -> guides/102`
- 缺其他更细 route gap，再按下面三类分流

一句话该回哪层，先问它还缺哪种 artifact / verdict，而不是哪页“说了算”：

- 缺 Prompt 的 `compiled world verdict / first reject`，回根入口与 `philosophy/84`
- 缺治理的 `repricing proof / lease checkpoint / cleanup witness`，回 `../10`
- 缺当前真相的 `ceiling note / unresolved-authority note / change-risk record / why-proof / landing card / quality gate`，回 `guides/102 -> philosophy/87 -> architecture/README`
- 解释 why，回 `philosophy/`
- 判 evidence ceiling / ladder / downgrade，回 `guides/`
- 展开对象、状态机与 choke point，回 `architecture/`
- 声明 host contract 与字段 truth，回 `api/`
- 发现场 verdict、rollback 与 repair，回 `playbooks/`
- 保留失真样本，回 `casebooks/`
- 记录稳定经验与批次记忆，回 `docs/`

## 三类第一问题缺口

- 谁在定义世界
  - 缺顶层主语与 `first-reject path`，回 `philosophy/84`
  - 若争的是继承是否越权、continue qualification 或续租是否合法，回 `84 -> 81`
  - 缺“为什么这轮还不该重谈世界定义，而只该继续压回同一因果律”，回 [../06-第一性原理与苏格拉底反思.md](../06-%E7%AC%AC%E4%B8%80%E6%80%A7%E5%8E%9F%E7%90%86%E4%B8%8E%E8%8B%8F%E6%A0%BC%E6%8B%89%E5%BA%95%E5%8F%8D%E6%80%9D.md) 与 [../../docs/development/00-研究方法.md](../../docs/development/00-%E7%A0%94%E7%A9%B6%E6%96%B9%E6%B3%95.md)
- 谁在为扩张定价
  - 缺治理首答，回 `../10`
  - 已确认主语，只缺 signer / mechanism，回 `security`；缺 tail readback / reopen qualification，回 `risk`；缺 execution / repair drill，回 `playbooks`
  - 还在争 mode、usage、approval 或 cleanup result 谁说了算，先退回 `../10`
- 谁在宣布现在
  - 缺 `ceiling note`、`downgrade stamp` 或 `unresolved-authority note`，回 `guides/102`
  - 已有 promotion proof 但还没写出 `change-risk record`，继续停在 `guides/102`
  - 已有 `change-risk record` 但还没写 `why-proof`，回 `philosophy/87`
  - 已有 `change-risk record` 与 `why-proof`，但还没完成 `landing card / first fallback`，回 `architecture/README`
  - 已有 `landing card` 但还没过 `quality gate`，继续停在 `architecture/README` 按 `87` 的三条 why-proof 命题补齐
  - artifact 已齐但还在混 runtime-core evidence、operator-governance evidence 与公开镜像缺口，先退回 `06`

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

- `navigation/` 只保留稳定节点与 artifact gap，不把每条深链重新摊平成首页。
- 如果一个 route 句子开始代签 truth、ownership law 或 verdict，它就已经越位。
- 如果新的 route 提案删掉 artifact 名称后就不成立，说明它仍是页面归属说明，不是反查规则；先退回 `../README`、`../10`、`guides/102` 与 `docs/development/00`，不要把 `navigation/` 变成第二 frontdoor。
