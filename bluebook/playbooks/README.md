# 运行手册

`playbooks/` 当前有 79 篇编号文档，范围 `01-79`。本目录负责把研究结论变成回归、演练、rollout、验收、修复和长期运行手册。

还要先记一句：

- `77-79` 负责把 `09` 的三张控制面图落成长期验证手册；它们现在分别更明确覆盖 `message lineage`、`governance key` 与 `one writable present`，不再只是三篇并列回归文档
- `29-31` 是三条执行链的宿主接入排查入口，`77-79` 才是三条控制面的长期验证主入口；不要把两组页读成并列替代关系

## 目录分层

- `01-05`: 回归、事故复盘、演练记录模板与样例库。
- `06-19`: 迁移工单、rollout 样例、Evidence Envelope 与 Artifact 样例。
- `20-28`: Rule Sample Kit、Evaluator Harness 与对象验证手册。
- `29-37`: Prompt / 治理 / 结构三条宿主接入审读、迁移演练与验收执行手册。
- `38-49`: 修复、收口、监护与解除监护执行手册。
- `50-61`: 稳态、稳态纠偏、再纠偏与改写执行手册。
- `62-79`: rewrite correction、refinement、repair card / protocol card 执行手册，以及三张控制面图对应的长期验证手册。

## 推荐入口

- [01-Prompt修宪回归手册：section-drift、boundary-drift与lawful-forgetting事故复盘](<01-Prompt修宪回归手册：section-drift、boundary-drift与lawful-forgetting事故复盘.md>)
- [04-演练记录模板：前提、触发器、观测、判定、修复与防再发](04-演练记录模板：前提、触发器、观测、判定、修复与防再发.md)
- [12-统一Rollout ABI模板：对象、Diff、阶段、观测与回退记录](<12-统一Rollout ABI模板：对象、Diff、阶段、观测与回退记录.md>)
- [29-Prompt宿主接入审读手册：输入面、section breakdown、cache break可解释性与continue qualification排查](<29-Prompt宿主接入审读手册：输入面、section breakdown、cache break可解释性与continue qualification排查.md>)
- [30-治理宿主接入审读手册：authority source、decision window、pending action与rollback object排查](30-治理宿主接入审读手册：authority source、decision window、pending action与rollback object排查.md)
- [31-故障模型宿主接入审读手册：authority state、recovery boundary与anti-zombie结果面排查](31-故障模型宿主接入审读手册：authority state、recovery boundary与anti-zombie结果面排查.md)
- [35-Prompt宿主验收执行手册：compiled request truth验收卡、拒收顺序与回退剧本](35-Prompt宿主验收执行手册：compiled request truth验收卡、拒收顺序与回退剧本.md)
- [36-治理宿主验收执行手册：authority source、permission ledger、decision window、continuation gate与rollback剧本](36-治理宿主验收执行手册：authority source、permission ledger、decision window、continuation gate与rollback剧本.md)
- [37-结构宿主验收执行手册：authority state、resume order、recovery boundary、writeback path与anti-zombie剧本](37-结构宿主验收执行手册：authority state、resume order、recovery boundary、writeback path与anti-zombie剧本.md)
- [65-Prompt宿主修复稳态纠偏再纠偏改写纠偏精修执行手册：host consumption card、hard reject order与reopen drill](65-Prompt宿主修复稳态纠偏再纠偏改写纠偏精修执行手册：host consumption card、hard reject order与reopen drill.md)
- [66-治理宿主修复稳态纠偏再纠偏改写纠偏精修执行手册：host consumption card、hard reject order与reopen drill](66-治理宿主修复稳态纠偏再纠偏改写纠偏精修执行手册：host consumption card、hard reject order与reopen drill.md)
- [67-结构宿主修复稳态纠偏再纠偏改写纠偏精修执行手册：host consumption card、hard reject order与reopen drill](67-结构宿主修复稳态纠偏再纠偏改写纠偏精修执行手册：host consumption card、hard reject order与reopen drill.md)
- [77-请求装配控制面验证手册：authority chain、protocol transcript、continuation object与cache-safe fork回归](77-请求装配控制面验证手册：authority chain、protocol transcript、continuation object与cache-safe fork回归.md)
- [78-当前世界准入主权验证手册：trusted inputs、typed ask、最小可见面与continuation gate回归](78-当前世界准入主权验证手册：trusted inputs、typed ask、最小可见面与continuation gate回归.md)
- [79-one writable present验证手册：single-writer authority、recovery asset与anti-zombie回归](79-one writable present验证手册：single-writer authority、recovery asset与anti-zombie回归.md)

## 与其他目录配合

- 需要方法模板：回到 [../guides/README.md](../guides/README.md)
- 需要失败样本：回到 [../casebooks/README.md](../casebooks/README.md)
- 需要跨阶段导航：回到 [../navigation/README.md](../navigation/README.md)
- 想沿三条母线进入执行链：
- Prompt：`29 -> 35 -> 65 -> 77`
- 治理：`30 -> 36 -> 66 -> 78`
- 结构：`31 -> 37 -> 67 -> 79`
- 想直接做当前长期验证，而不是先做宿主接入排查：默认从 `77-79` 起步
- 想把高阶审读模板落成长期回归：从 `77-79`

## 维护约定

- `playbooks/` 负责“怎么演练、怎么回归、怎么值班”，不复制方法论正文。
- README 只保留阶段入口和代表性手册，不再逐条镜像全部 79 篇。
- 轮次推进与开发记忆统一回写到 `docs/`，不写进运行手册正文。
