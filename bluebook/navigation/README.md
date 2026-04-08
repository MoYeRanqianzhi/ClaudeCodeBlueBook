# 跨目录入口

`navigation/` 只做跨目录 artifact gap 反查，不重新定义三条母线。只有两种情况留在这里：

1. 你已经知道主语，只缺下一种 artifact 或单跳去处。
2. 你在争某页是否越位改判。

如果你还缺主语或最小顺序，先回 [../README.md](../README.md)；这里不再重做 first-hop 判定，只负责在主语已知后指出缺的是哪种 artifact / verdict。

这里默认只回答 artifact gap，而不是页面归属：

- 缺目录法或入口升级规则，回 `../../docs/development/00-研究方法.md`
- 缺当前真相线最早的证据分级与 artifact 起点，回 `../guides/102`
- 缺其他更细 route gap，再按下面三类分流

一句话该回哪层，先问它还缺哪种 artifact / verdict，而不是先猜该由哪页收口：

- 缺 Prompt 的 `compiled world verdict / first reject`，回根入口与 `philosophy/84`
- 缺治理的 `repricing proof / lease checkpoint / cleanup witness`，回 `../10`
- 缺当前真相线的证据分级与 `change-risk record`，回 `guides/102`
- 缺当前真相线的 why-proof，回 `philosophy/87`
- 缺当前真相线的对象、状态机、writeback seam 或 `landing card`，回 `architecture/README`
- 解释 why，回 `philosophy/`
- 判 evidence ceiling / ladder / downgrade，回 `guides/`
- 展开对象、状态机与 choke point，回 `architecture/`
- 声明 host contract 与字段 truth，回 `api/`
- 发现场 verdict、rollback 与 repair，回 `playbooks/`
- 保留失真样本，回 `casebooks/`
- 记录稳定经验与批次记忆，回 `docs/`

## 三类常见 artifact gap

- 已知是 Prompt 线
  - 缺 `compiled world verdict / first reject`，回 `philosophy/84`
  - 缺 continue qualification、继承越权或 lawful forgetting 的对象展开，回 `philosophy/84`
  - 缺 why / 自校，而不是缺对象与首跳，回 [../06-第一性原理与苏格拉底反思.md](../06-%E7%AC%AC%E4%B8%80%E6%80%A7%E5%8E%9F%E7%90%86%E4%B8%8E%E8%8B%8F%E6%A0%BC%E6%8B%89%E5%BA%95%E5%8F%8D%E6%80%9D.md)
- 已知是治理线
  - 缺 `repricing proof / lease checkpoint / cleanup witness`，先回 `../10`
  - 已知主语，只缺 signer / mechanism，回 `security`；缺 tail readback / reopen qualification，回 `risk`；缺 execution / repair drill，回 `playbooks`
  - 如果还在争 mode、usage、approval 或 cleanup result 该先补哪类 artifact，说明主语未定清，先退回 `../10`
- 已知是当前真相保护线
  - 缺 `ceiling note`、`downgrade stamp`、`unresolved-authority note` 或 `change-risk record`，回 `guides/102`
  - 缺 why-proof，回 `philosophy/87`
  - 缺 `landing card / writeback seam`，回 `architecture/README`
  - 如果 artifact 已齐但还在混 `runtime-core evidence`、`operator-governance evidence` 与公开镜像缺口，回 `06`

## 稳定节点

- [01-第一性原理阅读地图](01-第一性原理阅读地图.md)
  - 已知缺第一性原理阅读顺序或主线 reading map 时再来。
- [02-能力、API与治理检索图](02-能力、API与治理检索图.md)
  - 已知缺能力、接口或治理入口检索时再来。
- [04-目录职责、规范入口与兼容别名页说明](04-目录职责、规范入口与兼容别名页说明.md)
  - 已知在争某个入口、atlas、矩阵、verdict 或记忆该落哪一层时再来。
- [05-设计母线导航：工作语法、反扩张与可演化内核](05-设计母线导航：工作语法、反扩张与可演化内核.md)
  - 已知缺母线 reading map、而不是缺 owner README 单跳时再来。
- [15-苏格拉底审读导航：请求装配控制面、统一定价治理与当前真相保护](15-苏格拉底审读导航：请求装配控制面、统一定价治理与当前真相保护.md)
  - 已知缺失稳前的高阶追问与第一条反证信号时再来。
- [41-机制哲学导航：请求装配、统一定价治理与当前真相保护如何回到第一性原理](41-机制哲学导航：请求装配、统一定价治理与当前真相保护如何回到第一性原理.md)
  - 已知缺第一性原理回压，而不是缺对象层单跳时再来。
- [46-宿主迁移工单导航：Prompt、治理与故障模型支持面如何进入实施顺序、交接包与灰度发布](46-宿主迁移工单导航：Prompt、治理与故障模型支持面如何进入实施顺序、交接包与灰度发布.md)
  - 已知要进入宿主实现、迁移、验收与收口链时再来。

## 维护约定

- `navigation/` 只保留稳定节点与 artifact gap，不把每条深链重新摊平成首页。
- 如果一个 route 句子开始代签 truth、ownership law 或 verdict，它就已经越位。
- 如果新的 route 提案删掉 artifact 名称后就不成立，说明它仍是页面归属说明，不是反查规则；先退回 `../README`、`../10`、`guides/102` 与 `docs/development/00`，不要把 `navigation/` 变成第二 frontdoor。
