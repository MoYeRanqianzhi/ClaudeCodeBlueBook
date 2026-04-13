# 跨目录入口

`navigation/` 只做跨目录 artifact gap 反查，不重新定义三条母线。只有两种情况留在这里：

1. 你已经知道主语与当前 claim-state rung，只缺下一种 artifact 或单跳去处。
2. 你在争某页是否越位改判。

如果你还缺主语、claim-state rung 或最小顺序，先回 [../README.md](../README.md) 与 `guides/102`；这里不再重做 first-hop 判定，只负责在主语与 rung 已知后指出缺的是哪种 artifact / 证据。
如果争议已经变成“总控页之间谁在越位代签、目录契约是否失真”，先回 [../meta/README.md](../meta/README.md)；那不是 artifact gap。
目录层级也先认一条：`根入口 -> guides/102 -> owner page`。`navigation/` 默认接在这条 first-hop 之后，只继续指出下一种 artifact 或最近的 fail-closed seam；它不是第四个 frontdoor。
如果你缺的是源码质量 evidence grading、why-proof 或 object seam，而不是“下一跳缺什么 artifact”，也不要停在这里：evidence grading 回 `guides/102`，why-proof 回 `philosophy/87`，object seam 回 `architecture/README`。
更硬一点说，`navigation/` 不产出 `advanced / pass / veto-ready` 之类读法；它只回答“下一跳缺哪种 artifact”。

这里默认只回答 artifact gap。先做三问：

1. 主语是否已锁定为 Prompt / 治理 / 当前真相。
2. 你缺的是 why、mechanism、artifact ceiling、object seam 还是 execution evidence。
3. 只取第一条匹配出口；一旦出口已给出，就不要在 `navigation/` 里继续追第二跳。

最小反查规则如下：

- 缺目录法或入口升级规则，回 `../../docs/development/00-研究方法.md`
- Prompt
  - 若还答不出 later consumer 是否仍继承同一工作对象、已排除分支与 continue/reject verdict，回 `philosophy/84`
  - 若 `84` 已站住、只缺 builder-facing object chain、`carrier / witness` 区分或 worked example，回 `philosophy/81`
  - 若问题已缩成 Prompt 自校，只缺苏格拉底式反问，回 [../06-第一性原理与苏格拉底反思.md](../06-%E7%AC%AC%E4%B8%80%E6%80%A7%E5%8E%9F%E7%90%86%E4%B8%8E%E8%8B%8F%E6%A0%BC%E6%8B%89%E5%BA%95%E5%8F%8D%E6%80%9D.md)
- Governance
  - 缺 `repricing proof / lease checkpoint / cleanup witness`，回 `../10`
  - 缺 signer / ledger / cleanup authority ambiguity，回 `security`
  - 缺 cleanup aftermath、`receipt-grade` readback 或 reopen eligibility readback，回 `risk`
  - 缺 execution evidence / rollback / reopen drill，回 `playbooks`
- Current-truth / source-quality
  - 缺 `public artifact ceiling / ceiling note / downgrade stamp / unresolved-authority note / change-risk record`，回 `guides/102`
  - 缺 current-truth why-proof，回 `philosophy/86`
  - 缺源码质量 why-proof、`合法复杂度中心` 或 later-maintainer veto 的 why，回 `philosophy/87`
  - 缺 repo-specific seam type locator（如 `generation guard / server-head adoption / host truth externalization / release-surface split`），回 `../01-源码结构地图.md`
  - 若当前问的是对象、状态机、writeback seam、`local veto cue / first retreat layer / landing card` 或最近的 `fail-closed seam`，claim-state 未锁定时先回 `guides/102`；已锁定为 object claim 时回 `architecture/README`
  - 若当前问的是 `release-surface shaping / compile-time gate / runtime gate / artifact surface`，且 claim-state 已锁定为 object claim，回 `architecture/84`

## 维护约定

- `navigation/` 只保留最小 artifact gap 规则，不把 reading map、owner inventory 或稳定书架重新摊平成首页。
- `navigation/` 默认接在 first-hop 之后工作；若一句 route 还能单独决定 first answer，它就已经越位成第二 frontdoor。
- 如果一个 route 句子开始代签 truth、ownership law 或 execution evidence，它就已经越位。
- 如果一个 route 句子开始替公开 artifact 代签 support promise、`signer ceiling` 或 `effect ceiling`，它也已经越位；先退回 `guides/102` 与 `architecture/84`。
- 如果一个 route 句子开始把 `first retreat layer` 直接写成修复计划、产品承诺或执行脚本，它也已经越位；route 只配指向最近的 fail-closed seam，不配代写修法。
- 如果新的 route 提案删掉 artifact 名称后就不成立，说明它仍是页面归属说明，不是反查规则；先退回 `../README`、`../10`、`guides/102` 与 `docs/development/00`，不要把 `navigation/` 变成第二 frontdoor。
