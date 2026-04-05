# 使用专题

`guides/` 当前包含 95 篇实践文档和 1 个 README。

这个目录不重复产品介绍，而是把源码中的方法论翻译成可执行用法、审读模板、迁移工单和修复手册。

## 目录分层

- `01-10`: 使用上手、多 Agent 编排、`CLAUDE.md`、预算与 permission mode。
  入口：[`01-使用指南`](<01-使用指南.md>)、[`02-多Agent编排与Prompt模板`](<02-多Agent编排与Prompt模板.md>)、[`06-第一性原理实践：目标、预算、对象、边界与回写`](<06-第一性原理实践：目标、预算、对象、边界与回写.md>)、[`08-如何根据预算、阻塞与风险选择session、task、worktree与compact`](<08-如何根据预算、阻塞与风险选择session、task、worktree与compact.md>)。
- `11-20`: Builder 视角的方法线，包括协作语法、共享前缀、Contract-First、依赖图诚实性和未来维护者视角。
  入口：[`11-给Agent平台构建者：如何把源码写成治理界面并保留重构余量`](<11-给Agent平台构建者：如何把源码写成治理界面并保留重构余量.md>)、[`18-如何把Prompt当成共享前缀资产网络：侧问题、suggestion、memory与summary共用主线程前缀`](<18-如何把Prompt当成共享前缀资产网络：侧问题、suggestion、memory与summary共用主线程前缀.md>)、[`19-如何用Contract-First方法阅读和设计Agent Runtime：先找合同，再看热点文件`](<19-如何用Contract-First方法阅读和设计Agent Runtime：先找合同，再看热点文件.md>)、[`20-如何工程化地维持依赖图诚实性：leaf module、anti-cycle seam与single-source file`](<20-如何工程化地维持依赖图诚实性：leaf module、anti-cycle seam与single-source file.md>)。
- `21-29`: 审读清单、治理模板和源码塑形模板。
  入口：[`24-如何把Prompt写成可治理宪法：section registry、角色主权链、合法遗忘与可观测diff`](<24-如何把Prompt写成可治理宪法：section registry、角色主权链、合法遗忘与可观测diff.md>)、[`25-如何设计有顺序的治理系统：检查顺序、失败语义分型、可撤销自动化与稳定字节资产`](<25-如何设计有顺序的治理系统：检查顺序、失败语义分型、可撤销自动化与稳定字节资产.md>)、[`26-如何用构建系统塑形Agent Runtime：入口影子、transport shell、薄registry与反zombification`](<26-如何用构建系统塑形Agent Runtime：入口影子、transport shell、薄registry与反zombification.md>)、[`27-Prompt Constitution审读模板：section card、修宪工作流、失效台账与triage runbook`](<27-Prompt Constitution审读模板：section card、修宪工作流、失效台账与triage runbook.md>)。
- `30-50`: Rollout ABI、Evidence Envelope、Host Implementation、Validator、Harness 与 Builder-facing runtime 手册。
  入口：[`33-如何为Agent Runtime设计统一Rollout ABI：Diff卡、阶段评审卡、灰度结果与回退记录`](<33-如何为Agent Runtime设计统一Rollout ABI：Diff卡、阶段评审卡、灰度结果与回退记录.md>)、[`36-Prompt Host Implementation审读模板：编译真相、稳定字节、合法遗忘与交接闸门`](<36-Prompt Host Implementation审读模板：编译真相、稳定字节、合法遗忘与交接闸门.md>)、[`42-Prompt Artifact Harness Runner落地手册：Replay Queue、Prefix Ledger、Continuation Gate 与 Rewrite Adoption`](<42-Prompt Artifact Harness Runner落地手册：Replay Queue、Prefix Ledger、Continuation Gate 与 Rewrite Adoption.md>)、[`45-从第一性原理构建Agent Runtime：对象、协作语法、资源定价与恢复闭环`](<45-从第一性原理构建Agent Runtime：对象、协作语法、资源定价与恢复闭环.md>)、[`48-如何把Prompt写成上下文准入编译器：section law、stable prefix、协议真相与合法遗忘`](<48-如何把Prompt写成上下文准入编译器：section law、stable prefix、协议真相与合法遗忘.md>)、[`50-如何把源码先进性落成可演化内核：权威入口、单一来源、anti-cycle seam与未来维护者消费者`](<50-如何把源码先进性落成可演化内核：权威入口、单一来源、anti-cycle seam与未来维护者消费者.md>)。
- `51-56`: 宿主接入与迁移工单。
  入口：[`51-如何把Prompt魔力落成编译链实现：section registry、stable boundary、protocol rewrite与continue qualification`](<51-如何把Prompt魔力落成编译链实现：section registry、stable boundary、protocol rewrite与continue qualification.md>)、[`54-如何把Prompt宿主接入迁移成编译请求真相：迁移工单、交接包与灰度发布顺序`](<54-如何把Prompt宿主接入迁移成编译请求真相：迁移工单、交接包与灰度发布顺序.md>)、[`55-如何把治理宿主接入迁移成统一定价控制面：迁移工单、交接包与灰度发布顺序`](<55-如何把治理宿主接入迁移成统一定价控制面：迁移工单、交接包与灰度发布顺序.md>)、[`56-如何把故障模型宿主接入迁移成结构真相面：迁移工单、交接包与灰度发布顺序`](<56-如何把故障模型宿主接入迁移成结构真相面：迁移工单、交接包与灰度发布顺序.md>)。
- `57-80`: 迁移失真、验收执行、修复、收口、监护、解除监护、稳态与稳态纠偏模板。
  入口：[`57-如何把Prompt宿主迁移失真压回compiled request truth：固定纠偏顺序、拒收规则与模板骨架`](<57-如何把Prompt宿主迁移失真压回compiled request truth：固定纠偏顺序、拒收规则与模板骨架.md>)、[`60-如何把Prompt宿主验收执行失真压回compiled request truth：固定纠偏顺序、拒收升级路径与改写模板骨架`](<60-如何把Prompt宿主验收执行失真压回compiled request truth：固定纠偏顺序、拒收升级路径与改写模板骨架.md>)、[`63-如何把Prompt宿主修复失真压回compiled request truth：固定纠偏顺序、拒收升级路径与改写模板骨架`](<63-如何把Prompt宿主修复失真压回compiled request truth：固定纠偏顺序、拒收升级路径与改写模板骨架.md>)、[`66-如何把Prompt宿主修复收口失真压回compiled request truth：固定纠偏顺序、拒收升级路径与改写模板骨架`](<66-如何把Prompt宿主修复收口失真压回compiled request truth：固定纠偏顺序、拒收升级路径与改写模板骨架.md>)、[`69-如何把Prompt宿主修复监护失真压回compiled request truth：固定纠偏顺序、拒收升级路径与改写模板骨架`](<69-如何把Prompt宿主修复监护失真压回compiled request truth：固定纠偏顺序、拒收升级路径与改写模板骨架.md>)、[`72-如何把Prompt宿主修复解除监护失真压回compiled request truth：固定纠偏顺序、拒收升级路径与改写模板骨架`](<72-如何把Prompt宿主修复解除监护失真压回compiled request truth：固定纠偏顺序、拒收升级路径与改写模板骨架.md>)、[`75-如何把Prompt宿主修复稳态失真压回compiled request truth：固定纠偏顺序、拒收升级路径与改写模板骨架`](<75-如何把Prompt宿主修复稳态失真压回compiled request truth：固定纠偏顺序、拒收升级路径与改写模板骨架.md>)、[`78-如何把Prompt宿主修复稳态纠偏执行失真压回compiled request truth：固定纠偏顺序、拒收升级路径与改写模板骨架`](<78-如何把Prompt宿主修复稳态纠偏执行失真压回compiled request truth：固定纠偏顺序、拒收升级路径与改写模板骨架.md>)。
- `81-95`: 再纠偏、rewrite、refinement 与长期 reopen 责任模板。
  入口：[`81-如何把Prompt宿主修复稳态纠偏再纠偏执行失真压回compiled request truth：固定纠偏顺序、拒收升级路径与protocol、forgetting、threshold改写模板骨架`](<81-如何把Prompt宿主修复稳态纠偏再纠偏执行失真压回compiled request truth：固定纠偏顺序、拒收升级路径与protocol、forgetting、threshold改写模板骨架.md>)、[`84-如何把Prompt宿主修复稳态纠偏再纠偏改写执行失真压回compiled request truth：固定rewrite顺序、拒收升级路径与rewrite、prefix、threshold改写模板骨架`](<84-如何把Prompt宿主修复稳态纠偏再纠偏改写执行失真压回compiled request truth：固定rewrite顺序、拒收升级路径与rewrite、prefix、threshold改写模板骨架.md>)、[`87-Prompt宿主修复稳态纠偏再纠偏改写纠偏执行失真：registry、boundary与threshold模板`](<87-Prompt宿主修复稳态纠偏再纠偏改写纠偏执行失真：registry、boundary与threshold模板.md>)、[`90-Prompt宿主修复稳态纠偏再纠偏改写纠偏精修执行失真：lineage、synthesis与liability模板`](<90-Prompt宿主修复稳态纠偏再纠偏改写纠偏精修执行失真：lineage、synthesis与liability模板.md>)、[`93-Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行失真：authority chain、protocol truth与liability模板`](<93-Prompt宿主修复稳态纠偏再纠偏改写纠偏精修纠偏执行失真：authority chain、protocol truth与liability模板.md>)。

## 从哪里开始读

- 想直接提高 Claude Code 使用效率：`01 -> 02 -> 06 -> 08 -> 10`
- 想提炼自己的 Agent Runtime 方法：`11 -> 18 -> 19 -> 20 -> 45 -> 47`
- 想做 Host/SDK 接入或迁移：从 `51-56` 进入，再顺着 `57-80` 看纠偏和修复模板。
- 想找跨目录导航而不是在长链里手找：转到 [../navigation/README.md](<../navigation/README.md>)。

## 与其他目录的边界

- [../api/README.md](<../api/README.md>): 负责字段、协议和宿主消费面。
- [../architecture/README.md](<../architecture/README.md>): 负责状态机、装配链、恢复链和结构边界。
- [../navigation/README.md](<../navigation/README.md>): 负责跨目录检索和阅读路径。
- [../playbooks/README.md](<../playbooks/README.md>): 负责运营、回归和演练剧本。
- [../casebooks/README.md](<../casebooks/README.md>): 负责失败样本和反例库。
