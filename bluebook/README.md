# 蓝皮书入口

蓝皮书根入口只先回答三件事：

- 世界如何进入模型
- 扩张如何被定价
- 当前如何不被过去写坏

第一次进入先在本页定题：Prompt 线先问 later consumer 在 `verify / delegate / tool choice / resume / handoff` 时是否还要重答“谁定义世界、边界在哪、工具还能不能用”，以及 `resume / handoff / compaction` 后留下来的 transcript / lineage 是否不仅“还像同一段故事”，还足以继续完成同一条 `lawful inheritance`：继续继承同一工作对象，让 `search-pruning` 维持同一批仍被排除的分支，让 `decision-retirement` 维持已退役判断不被 summary / 标题 / 最后一条消息之类 surface 静默带回候选集，并复现同一条 `continue / reject verdict`；若只剩易读 surface，它们最多证明 belonging，不证明 admissibility。治理线先问最早 `unpaid expansion` 是什么、现在是不是仍在同一 `authority lease` 里、这次是否真的新增 `decision delta`、继续前有没有补齐 `repricing proof / lease checkpoint / explicit cleanup trigger`；若没有新增 delta，审批回单、状态面板与 usage 尾链都只算 `receipt-grade / weak readback`。当前真相保护线先问当前为何不被过去写坏，若继续追源码质量 why，再问复杂度是否落在合法中心、现在是否仍只有一个可写现在、later maintainer 是否仍保有正式 veto。定清这三个第一问题后，根入口只做一次首跳：Prompt 去 `philosophy/84`，治理去 [10-治理收费链入口卡：最早 unpaid expansion、reject trio 与弱读回面](10-%E6%B2%BB%E7%90%86%E6%94%B6%E8%B4%B9%E9%93%BE%E5%85%A5%E5%8F%A3%E5%8D%A1%EF%BC%9A%E6%9C%80%E6%97%A9%20unpaid%20expansion%E3%80%81reject%20trio%20%E4%B8%8E%E5%BC%B1%E8%AF%BB%E5%9B%9E%E9%9D%A2.md)，当前真相保护去 `guides/102`。根入口不再提前列 second-hop artifact 或归属目录。
当前真相保护线也只先判证据 ceiling 与 current-truth 入口：`102` 先回答公开证据够不够支撑当前真相主张；若问题已经不在首跳，而是在分辨 why、object 或 verdict，再由对应归属页继续接手。

证据上限也先记一句：凡涉及路径级源码 certainty 的判断，首跳一律先去 `guides/102`；根入口不在这里继续判断证据状态。
目录升级顺序也只认一条：`根入口 -> guides/102 -> owner page`。没有经过 `102` 的 claim-state / promotion gate，`architecture/`、`api/` 与其他 frontdoor 页里的 noun 都不能自动读成 landed truth。

## 三条首跳

- Prompt
  - `philosophy/84`
  - 若 first principles 已站住、你需要 worked examples 或验证样例，再顺跳 `playbooks/09 / 20 / 23 / 26 / 77`
- 治理
  - [10-治理收费链入口卡：最早 unpaid expansion、reject trio 与弱读回面](10-%E6%B2%BB%E7%90%86%E6%94%B6%E8%B4%B9%E9%93%BE%E5%85%A5%E5%8F%A3%E5%8D%A1%EF%BC%9A%E6%9C%80%E6%97%A9%20unpaid%20expansion%E3%80%81reject%20trio%20%E4%B8%8E%E5%BC%B1%E8%AF%BB%E5%9B%9E%E9%9D%A2.md)
- 当前真相保护
  - `guides/102`

若只是想先看三条母线怎样互相照镜，再回 `09`；但 `09` 不代替这三个首跳，也不提前发 second-hop inventory。

## 目录角色协议

第一次进入不必先背完整目录树，只要先记住：蓝皮书不是按题材分桶，而是按发言权分桶。

- `README` 与 `userbook/`
  - 只负责定题与 first answer typing，不提前代答 why-proof、对象摘要或执行 verdict；若问题已经转成 admissibility、promotion 或 claim-state，就不再继续留在入口层。
- `philosophy/`
  - 只负责 why-proof，回答“为什么必须这样设计”，以及这套制度分别替 later consumer 退休了哪类世界、扩张与当前真相重判。
- `guides/`
  - 只负责 evidence ladder、claim-state 与 promotion / demotion 条件；`102` 是“根入口如何把 object claim 正式升级给 owner page”的唯一前门。
- `architecture/`
  - 只负责 promotion-passed 对象、对象态、writeback seam 与 `landing card` 级摘要；未过 promotion gate 的对象只保留 `writer claim state / unresolved-authority snapshot`，不提前升级成 landed truth。
- `navigation/`
  - 只负责 artifact gap 与 route dispute，不重新发放 first answer。
- `security / risk / playbooks/`
  - 分别只负责治理机制、post-cleanup readback 与 execution verdict。

目录优化真正要减少的，不是文件数，而是 later consumer 在两页里学到同一第一答案的概率。
若问题已经不是“首跳去哪”，而是“哪一页正在越位代签、目录契约是否失真”，统一回 [meta/README.md](meta/README.md)。

## 根入口只做三件事

1. 先定题，不先列 artifact 名。
   - 先判断自己究竟在问请求装配、扩张定价，还是当前真相保护；再判断自己卡住的是“接手者还要重答世界/边界/工具资格”“最早 `unpaid expansion` 还没补齐 `repricing proof / lease checkpoint / cleanup`，或当前只剩尾链回单、没有新增决策增益”，还是“当前真相还没被显式保护”。
2. 先给第一跳，不先摊 deep chain。
   - 根页只给 `84 / 10 / 102` 三个首跳；治理与当前真相保护线的后续 syllabus 一律交给目标页。
3. 先判是否要跨目录，最后才进入 route map。
   - 只有当问题已经变成“下一层 artifact / 证据该去哪里补”时，才转 [navigation/README.md](navigation/README.md)。
