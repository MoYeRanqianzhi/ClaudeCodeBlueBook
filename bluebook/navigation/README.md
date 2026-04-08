# 跨目录入口

`navigation/` 只做跨目录 artifact gap 反查，不重新定义三条母线。只有两种情况留在这里：

1. 你已经知道主语，只缺下一种 artifact 或单跳去处。
2. 你在争某页是否越位改判。

如果你还缺主语或最小顺序，先回 [../README.md](../README.md)；这里不再重做 first-hop 判定，只负责在主语已知后指出缺的是哪种 artifact / 证据。
如果争议已经变成“总控页之间谁在越位代签、目录契约是否失真”，先回 [../meta/README.md](../meta/README.md)；那不是 artifact gap。

这里默认只回答 artifact gap，而不是页面归属。扁平反查规则如下：

- 缺目录法或入口升级规则，回 `../../docs/development/00-研究方法.md`
- 缺 Prompt 的 `compiled world basis / first reject`，回 `philosophy/84`
- 缺 Prompt why / 自校，回 [../06-第一性原理与苏格拉底反思.md](../06-%E7%AC%AC%E4%B8%80%E6%80%A7%E5%8E%9F%E7%90%86%E4%B8%8E%E8%8B%8F%E6%A0%BC%E6%8B%89%E5%BA%95%E5%8F%8D%E6%80%9D.md)
- 缺治理的 `repricing proof / lease checkpoint / cleanup witness`，回 `../10`
- 缺 signer / ledger / cleanup authority ambiguity，回 `security`
- 缺 post-cleanup readback，回 `risk`
- 缺 execution evidence / reopen drill，回 `playbooks`
- 缺当前真相线的 `ceiling note / downgrade stamp / unresolved-authority note / change-risk record`，回 `guides/102`
- 缺当前真相保护的 why-proof，回 `philosophy/86`；若继续追源码质量 why，再回 `philosophy/87`
- 缺当前真相线的对象、状态机、writeback seam 或对象摘要（如 `landing card`），回 `architecture/README`

## 维护约定

- `navigation/` 只保留最小 artifact gap 规则，不把 reading map 或稳定书架重新摊平成首页。
- 如果一个 route 句子开始代签 truth、ownership law 或 execution evidence，它就已经越位。
- 如果新的 route 提案删掉 artifact 名称后就不成立，说明它仍是页面归属说明，不是反查规则；先退回 `../README`、`../10`、`guides/102` 与 `docs/development/00`，不要把 `navigation/` 变成第二 frontdoor。
