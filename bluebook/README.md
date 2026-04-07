# 蓝皮书入口

蓝皮书正文现在只先回答三件事：世界如何进入模型，扩张如何被定价，当前如何不被过去写坏。第一次进入先读 [09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md)；Prompt 线先去 `philosophy/84`，治理线先去 [10-治理收费链入口卡：四类被收费资源、reject trio 与弱读回面](10-%E6%B2%BB%E7%90%86%E6%94%B6%E8%B4%B9%E9%93%BE%E5%85%A5%E5%8F%A3%E5%8D%A1%EF%BC%9A%E5%9B%9B%E7%B1%BB%E8%A2%AB%E6%94%B6%E8%B4%B9%E8%B5%84%E6%BA%90%E3%80%81reject%20trio%20%E4%B8%8E%E5%BC%B1%E8%AF%BB%E5%9B%9E%E9%9D%A2.md)，当前真相保护先去 `guides/102`；若要补 why / 自校，再回 [03-设计哲学](03-设计哲学.md) 与 [06-第一性原理与苏格拉底反思](06-第一性原理与苏格拉底反思.md)。

如果把蓝皮书入口再压成最短公式，只剩三条：

1. Prompt
   - 根入口只保留 `same-world compiler` 这句总钩子；Prompt 线先到 `philosophy/84`，需要 how 再到 `guides/51`，需要 why / 自校再回 `03 / 06`
2. 治理
   - 治理入口统一回 [10-治理收费链入口卡：四类被收费资源、reject trio 与弱读回面](10-%E6%B2%BB%E7%90%86%E6%94%B6%E8%B4%B9%E9%93%BE%E5%85%A5%E5%8F%A3%E5%8D%A1%EF%BC%9A%E5%9B%9B%E7%B1%BB%E8%A2%AB%E6%94%B6%E8%B4%B9%E8%B5%84%E6%BA%90%E3%80%81reject%20trio%20%E4%B8%8E%E5%BC%B1%E8%AF%BB%E5%9B%9E%E9%9D%A2.md)；why / runtime seam / question ladder 再分流到 `85 / 83 / 100`
3. 当前真相保护
   - 当前真相保护先回 `guides/102`；why 再回 `03 / philosophy/86 / philosophy/87`，对象与 writeback seam 再回 `architecture/README`

这里还应再多记一句目录纪律：

- `continuity` 不是第四条并列母线，而是 Prompt 的 `Continuation`、治理的 `continuation pricing` 与源码质量的 `recovery non-sovereignty / anti-zombie` 在时间维度的交汇；一旦把它单独写成命令目录，就会重新把对象链拆散。

如果继续追问“设计内涵为什么成立”，不要在根入口继续摊深链：

- Prompt 的 why 回 `03`
- 治理的 why 回 `philosophy/85`
- 当前真相保护的 why 回 `03 / philosophy/86 / philosophy/87`
- 源码质量的证据顺序回 `guides/102`

根 README 的职责只有三层：先定题，再定最小顺序，最后才决定要不要跨目录跳转；它不再负责把整套深链重新摊平。

## 最短进入规则

- 先定题，不先找页。
  回 `09 / 03 / 06`，先判断自己究竟在问请求装配、扩张定价，还是当前真相保护。
- 先按角色，不按编号线性走。
  `00` 只做导读与 locator，`09` 只做宪法总图，`03` 只做 why，`06` 只做自校，`01 / 02 / 05 / 07 / 08 / 10` 只做 bridge 或 locator。
- 先定顺序，不先追长链。
  先拿到上面的三组最小顺序，再决定自己缺的是 first reject signal、对象链，还是模板与 verdict。
- 先定层级，最后才跨目录。
  缺高阶主语回 `09 / 05 / 15 / 41`；缺对象与 contract 去 `philosophy / architecture / api / guides / playbooks / casebooks`；只有缺“下一层去哪里找”时才进入 [navigation/README.md](navigation/README.md)。

如果一个新结论第一次同时想落在 `README / navigation / guide` 三层，通常不是因为它太重要，而是因为还没判清它究竟是在定义主语、补最小顺序、下沉证据层，还是其实只缺一次 route trim；这时先回 [06-第一性原理与苏格拉底反思](06-%E7%AC%AC%E4%B8%80%E6%80%A7%E5%8E%9F%E7%90%86%E4%B8%8E%E8%8B%8F%E6%A0%BC%E6%8B%89%E5%BA%95%E5%8F%8D%E6%80%9D.md) 与 [../docs/development/00-研究方法.md](../docs/development/00-%E7%A0%94%E7%A9%B6%E6%96%B9%E6%B3%95.md) 反问。

## 三组最小排查顺序

- Prompt
  先回 `philosophy/84` 定 Prompt first answer；需要 how 再回 `guides/51`；需要 why / 自校再回 `03 / 06`。
- 治理
  先回 `10` 定治理链与弱读回面，再按争议落点分流到 `security / risk / playbooks`。
- 当前真相
  先回 `guides/102` 定证据顺序，再按 why / object / self-audit 分流到 `03 / philosophy/86 / philosophy/87 / architecture/README / 06`。

如果入口层不给这三组顺序，目录结构优化就仍然主要在帮读者“找到页”，还没有开始帮 later maintainer “先拿到同一套排查动作”。

治理线的四类被收费资源、reject trio 与弱读回面声明统一回 [10-治理收费链入口卡：四类被收费资源、reject trio 与弱读回面](10-%E6%B2%BB%E7%90%86%E6%94%B6%E8%B4%B9%E9%93%BE%E5%85%A5%E5%8F%A3%E5%8D%A1%EF%BC%9A%E5%9B%9B%E7%B1%BB%E8%A2%AB%E6%94%B6%E8%B4%B9%E8%B5%84%E6%BA%90%E3%80%81reject%20trio%20%E4%B8%8E%E5%BC%B1%E8%AF%BB%E5%9B%9E%E9%9D%A2.md)；根入口只保留 route，不再代行治理入口卡。

具体深链、稳定节点、专题侧门与跨目录下一跳，统一交给 [navigation/README.md](navigation/README.md)；根入口不再继续代行 route map。
