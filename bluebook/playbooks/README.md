# 运行手册

`playbooks/` 当前有 79 篇编号文档，范围 `01-79`。本目录负责把研究结论变成回归、演练、rollout、验收、修复和长期运行手册。

## 目录分层

- `01-05`: 回归、事故复盘、演练记录模板与样例库。
- `06-19`: 迁移工单、rollout 样例、Evidence Envelope 与 Artifact 样例。
- `20-28`: Rule Sample Kit、Evaluator Harness 与对象验证手册。
- `29-37`: 宿主接入审读与迁移演练、验收执行手册。
- `38-49`: 修复、收口、监护与解除监护执行手册。
- `50-61`: 稳态、稳态纠偏、再纠偏与改写执行手册。
- `62-79`: rewrite correction、refinement、repair card / protocol card 执行手册，以及三张控制面图对应的长期验证手册。

## 推荐入口

- [01-Prompt修宪回归手册：section-drift、boundary-drift与lawful-forgetting事故复盘](<01-Prompt修宪回归手册：section-drift、boundary-drift与lawful-forgetting事故复盘.md>)
- [04-演练记录模板：前提、触发器、观测、判定、修复与防再发](04-演练记录模板：前提、触发器、观测、判定、修复与防再发.md)
- [12-统一Rollout ABI模板：对象、Diff、阶段、观测与回退记录](<12-统一Rollout ABI模板：对象、Diff、阶段、观测与回退记录.md>)
- [29-Prompt宿主接入审读手册：输入面、section breakdown、cache break可解释性与continue qualification排查](<29-Prompt宿主接入审读手册：输入面、section breakdown、cache break可解释性与continue qualification排查.md>)
- [56-Prompt宿主修复稳态纠偏再纠偏执行手册：recorrection card、reject verdict order、protocol repair drill与threshold liability drill](<56-Prompt宿主修复稳态纠偏再纠偏执行手册：recorrection card、reject verdict order、protocol repair drill与threshold liability drill.md>)
- [71-Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行手册：repair card、共同reject order与reopen drill](<71-Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行手册：repair card、共同reject order与reopen drill.md>)
- [74-Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行手册：compiled request card、shared reject order与reopen drill](74-Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行手册：compiled request card、shared reject order与reopen drill.md)
- [77-请求装配控制面验证手册：authority chain、protocol transcript、continuation object与cache-safe fork回归](77-请求装配控制面验证手册：authority chain、protocol transcript、continuation object与cache-safe fork回归.md)
- [78-当前世界准入主权验证手册：trusted inputs、typed ask、最小可见面与continuation gate回归](78-当前世界准入主权验证手册：trusted inputs、typed ask、最小可见面与continuation gate回归.md)
- [79-one writable present验证手册：single-writer authority、recovery asset与anti-zombie回归](79-one writable present验证手册：single-writer authority、recovery asset与anti-zombie回归.md)

## 与其他目录配合

- 需要方法模板：回到 [../guides/README.md](../guides/README.md)
- 需要失败样本：回到 [../casebooks/README.md](../casebooks/README.md)
- 需要跨阶段导航：回到 [../navigation/README.md](../navigation/README.md)
- 想把高阶审读模板落成长期回归：从 `77-79`

## 维护约定

- `playbooks/` 负责“怎么演练、怎么回归、怎么值班”，不复制方法论正文。
- README 只保留阶段入口和代表性手册，不再逐条镜像全部 79 篇。
- 轮次推进与开发记忆统一回写到 `docs/`，不写进运行手册正文。
