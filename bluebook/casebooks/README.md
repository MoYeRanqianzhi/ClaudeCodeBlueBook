# 案例库

`casebooks/` 当前有 75 篇编号文档，范围 `01-75`。本目录不重讲正确答案，而是收纳 Prompt、治理、结构和宿主落地里的失败样本、反例对照与失真原型。它只保留失败正文，不再夹带轮次级整改待办或“改写路径”。

## 目录分层

- `01-09`: 基础事故集、标签体系、源码锚点与三路反查。
- `10-24`: Prompt / 安全 / 结构反例，以及 Evidence Envelope、Host Implementation、Artifact 反例。
- `25-33`: 宿主消费、故障模型、迁移与验收执行反例。
- `34-45`: 修复、收口、监护、解除监护与稳态反例。
- `46-57`: 稳态纠偏、再纠偏与改写执行反例。
- `58-72`: 改写纠偏、精修与 card / reopen liability 反例。
- `73-75`: 三张控制面图长期验证失真反例。

## 推荐入口

- [01-Prompt事故案例集：修宪漂移、路径失配与合法遗忘失效](01-Prompt事故案例集：修宪漂移、路径失配与合法遗忘失效.md)
- [04-事故标签体系与交叉索引：阶段、资产、症状、根因与恢复动作](04-事故标签体系与交叉索引：阶段、资产、症状、根因与恢复动作.md)
- [10-Prompt反例对照：长文案崇拜、主语漂移与共享前缀分叉](10-Prompt反例对照：长文案崇拜、主语漂移与共享前缀分叉.md)
- [25-Prompt宿主消费反例：字符串崇拜、缓存黑箱与继续资格误判](25-Prompt宿主消费反例：字符串崇拜、缓存黑箱与继续资格误判.md)
- [34-Prompt宿主修复演练反例：repair object伪绑定、摘要回滚与假重入](34-Prompt宿主修复演练反例：repair object伪绑定、摘要回滚与假重入.md)
- [46-Prompt宿主修复稳态执行反例：假稳态、前缀托管表演与无阈值继续](46-Prompt宿主修复稳态执行反例：假稳态、前缀托管表演与无阈值继续.md)
- [64-Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行反例：假repair card、假protocol truth与假reopen liability](64-Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行反例：假repair card、假protocol truth与假reopen liability.md)
- [67-Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行反例：假repair card、假共同reject语义与假reopen liability](67-Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行反例：假repair card、假共同reject语义与假reopen liability.md)
- [70-Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行反例：假compiled request card、假shared reject语义与假reopen liability](70-Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏精修执行反例：假compiled request card、假shared reject语义与假reopen liability.md)
- [73-请求装配控制面验证失真反例：假authority chain、假protocol transcript与假continuation object](73-请求装配控制面验证失真反例：假authority chain、假protocol transcript与假continuation object.md)
- [74-当前世界准入主权验证失真反例：低信任扩权、假最小可见面与免费继续](74-当前世界准入主权验证失真反例：低信任扩权、假最小可见面与免费继续.md)
- [75-one writable present验证失真反例：健康投影篡位、恢复资产越权与anti-zombie伪证](75-one writable present验证失真反例：健康投影篡位、恢复资产越权与anti-zombie伪证.md)

## 怎么配合其他目录使用

- 想看正向方法：回到 [../guides/README.md](../guides/README.md)
- 想看运行手册和演练动作：回到 [../playbooks/README.md](../playbooks/README.md)
- 想做跨样本反查：回到 [../navigation/README.md](../navigation/README.md)
- 想看结构和协议的正向定义：回到 [../architecture/README.md](../architecture/README.md) 与 [../api/README.md](../api/README.md)
- 想看正向纠偏路径：优先回到 `guides/`、`playbooks/`、`api/`，不要继续停留在案例正文里找待办
- 想看共同 `reject` 与 `reopen` 的 card 失真样本：从 `70-72`
- 想看三张控制面图的长期验证为什么会被伪验证偷走：从 `73-75` 或 `../navigation/40`

## 维护约定

- README 只保留阶段入口和代表性反例，不再镜像全部 75 篇标题。
- 新样本应按编号段放回对应阶段，保持与 `playbooks/` 和 `navigation/` 的互补关系。
- 正向改写、修复顺序与协议对象统一写回 `guides/`、`playbooks/`、`api/`，不重新塞回案例正文。
- 轮次推进与开发记忆统一回写到 `docs/`，不写进案例正文。
