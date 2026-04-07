# 蓝皮书入口

蓝皮书正文现在只先回答三件事：世界如何进入模型，扩张如何被定价，当前如何不被过去写坏。第一次进入先读 [09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md)，再回 [03-设计哲学](03-设计哲学.md) 与 [06-第一性原理与苏格拉底反思](06-第一性原理与苏格拉底反思.md)。

如果把蓝皮书入口再压成最短公式，只剩三条：

1. Prompt
   - 根入口只保留 `same-world compiler` 这句总钩子；顶层判断与 `first-reject path` 回 `philosophy/84`，same-world witness、实现顺序与 `continue qualification` 回 `guides/51`；若要追问为什么这仍不该再长出第二 Prompt 前门，再回 `06`。
2. 治理
   - `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup`
   - 任何 user-facing bucket 都只是这条收费链的读回助记，不是治理入口里的第二套主题；四类被收费资源、reject trio 与弱读回面统一回 [10-治理收费链入口卡：四类被收费资源、reject trio 与弱读回面](10-%E6%B2%BB%E7%90%86%E6%94%B6%E8%B4%B9%E9%93%BE%E5%85%A5%E5%8F%A3%E5%8D%A1%EF%BC%9A%E5%9B%9B%E7%B1%BB%E8%A2%AB%E6%94%B6%E8%B4%B9%E8%B5%84%E6%BA%90%E3%80%81reject%20trio%20%E4%B8%8E%E5%BC%B1%E8%AF%BB%E5%9B%9E%E9%9D%A2.md)
3. 当前真相保护
   - 先认 current-truth protection；canonical ladder 与 evidence ceiling 统一回 `guides/102`，why 统一回 `03 / philosophy/86 / philosophy/87`，对象与 writeback seam 统一回 `architecture/README`

这里还应再多记一句目录纪律：

- `continuity` 不是第四条并列母线，而是 Prompt 的 `Continuation`、治理的 `continuation pricing` 与源码质量的 `recovery non-sovereignty / anti-zombie` 在时间维度的交汇；一旦把它单独写成命令目录，就会重新把对象链拆散。

如果继续把“设计内涵”也压成 later maintainer 第一次就该抓住的三句制度判断，也只该剩：

1. Prompt 不是 instruction 美学，而是不同 consumer 不必重新协商当前世界。
2. 治理不是 budget 面板，而是动作、可见性、上下文、时间，乃至 classifier 自身都先被同一价格秩序批准。
3. 源码组织不是功能分层，而是先把 `谁定义现在 / 谁只消费现在 / 谁只能帮助恢复现在` 写进结构。

如果 later maintainer 第一次进蓝皮书时还看不见这三条，目录结构就还在迫使他先学对象层总结，再自己回压成第一性原理。

源码质量线若缺 `public-evidence ceiling`、canonical ladder 或 `current-truth surface candidate` 的降格判断，直接回 `guides/102` 与 `docs/development/00`；根入口不再第二次展开这套梯子。

如果只先记治理入口的一句话，也只记这句：

- 治理首答只认 `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup`；若只缺一屏速记，先回 [10-治理收费链入口卡：四类被收费资源、reject trio 与弱读回面](10-%E6%B2%BB%E7%90%86%E6%94%B6%E8%B4%B9%E9%93%BE%E5%85%A5%E5%8F%A3%E5%8D%A1%EF%BC%9A%E5%9B%9B%E7%B1%BB%E8%A2%AB%E6%94%B6%E8%B4%B9%E8%B5%84%E6%BA%90%E3%80%81reject%20trio%20%E4%B8%8E%E5%BC%B1%E8%AF%BB%E5%9B%9E%E9%9D%A2.md)，若缺 why/runtime seam/question ladder，再按 `85 / 83 / 100` 下潜。

如果继续把入口压成 later maintainer 能直接拿来排查的最小顺序，它还应再暴露三行：

1. Prompt 入口顺序
   - `same-world compiler -> philosophy/84 -> guides/51`
   - 根入口只给 Prompt 的 first-hop，不再第二次重列 Prompt formula、witness 与 counterfeit；`06` 只负责解释为什么这套 owner split 比再补一个 Prompt 入口更稳。
2. governance failure order
   - `pricing-right mismatch -> truth-surface demotion -> asset-rollback ABI sealing -> shared reject verdict -> reopen qualification / human fallback`
   - 治理先判 `pricing-right signer / lease` 是否成立，再看 `truth-surface attestation` 有没有把 `reject / reopen` 外化清楚；`asset-rollback ABI` 只负责把收口动作做成可恢复 contract，不再冒充治理起点。
3. current-truth route order
   - `README -> guides/102 -> 03 / philosophy/86 / philosophy/87 -> architecture/README -> 06`

入口如果只给公式，不给这三组顺序，later maintainer 仍要下潜到深页后才拿得到真正的排查起点；这说明入口层还没有完成从“同词化”到“同序化”的升级。

根 README 的职责只有三层：先定题，再定最小顺序，最后才决定要不要跨目录跳转；它不再负责把整套深链重新摊平。
更硬一点说，目录优化也不是再补一个更长入口，而是先减少“第一次回答同一问题”的入口数，再把 `speaking rights / appeal chain` 固定住。

## 最短进入规则

- 先定题，不先找页。
  回 `09 / 03 / 06`，先判断自己究竟在问请求装配、扩张定价，还是当前真相保护。
- 先按角色，不按编号线性走。
  `00` 只做导读与 locator，`09` 只做宪法总图，`03` 只做 why，`06` 只做自校，`01 / 10` 只做源码定位或治理速记 bridge。
- 先定顺序，不先追长链。
  先拿到上面的三组最小顺序，再决定自己缺的是 first reject signal、对象链，还是模板与 verdict。
- 先定层级，最后才跨目录。
  缺高阶主语回 `09 / 05 / 15 / 41`；缺对象与 contract 去 `philosophy / architecture / api / guides / playbooks / casebooks`；只有缺“下一层去哪里找”时才进入 [navigation/README.md](navigation/README.md)。

如果一个新结论第一次同时想落在 `README / navigation / guide` 三层，通常不是因为它太重要，而是因为还没判清它究竟是在定义主语、补最小顺序、下沉证据层，还是其实只缺一次 route trim；这时先回 [06-第一性原理与苏格拉底反思](06-%E7%AC%AC%E4%B8%80%E6%80%A7%E5%8E%9F%E7%90%86%E4%B8%8E%E8%8B%8F%E6%A0%BC%E6%8B%89%E5%BA%95%E5%8F%8D%E6%80%9D.md) 与 [../docs/development/00-研究方法.md](../docs/development/00-%E7%A0%94%E7%A9%B6%E6%96%B9%E6%B3%95.md) 反问。

## 三组最小排查顺序

- Prompt
  缺顶层判断与 `first-reject path` 回 `philosophy/84`；缺 same-world witness、实现顺序与 `continue qualification` 回 `guides/51`，不先看 `systemPrompt` 截图、最后一条消息、summary prose 或 handoff card。
- 治理
  先按 `pricing-right mismatch -> truth-surface demotion -> asset-rollback ABI sealing -> shared reject verdict -> reopen qualification / human fallback` 排，不先看任何界面投影、状态百分比或继续快捷入口；四类被收费资源、弱读回面与 reject trio 统一回 `10`。
- 当前真相
  先按 `contract mismatch -> registry drift -> current-truth split -> stale-writer eviction -> mirror-gap demotion` 排，不先看目录体感、作者说明或“看起来还算能跑”的经验判断。

如果入口层不给这三组顺序，目录结构优化就仍然主要在帮读者“找到页”，还没有开始帮 later maintainer “先拿到同一套排查动作”。

治理线的四类被收费资源、reject trio 与弱读回面声明统一回 [10-治理收费链入口卡：四类被收费资源、reject trio 与弱读回面](10-%E6%B2%BB%E7%90%86%E6%94%B6%E8%B4%B9%E9%93%BE%E5%85%A5%E5%8F%A3%E5%8D%A1%EF%BC%9A%E5%9B%9B%E7%B1%BB%E8%A2%AB%E6%94%B6%E8%B4%B9%E8%B5%84%E6%BA%90%E3%80%81reject%20trio%20%E4%B8%8E%E5%BC%B1%E8%AF%BB%E5%9B%9E%E9%9D%A2.md)；根入口这里只保留 canonical chain 与治理 failure order，不再第二次重列。

具体深链、稳定节点、专题侧门与跨目录下一跳，统一交给 [navigation/README.md](navigation/README.md)；根入口不再继续代行 route map。
