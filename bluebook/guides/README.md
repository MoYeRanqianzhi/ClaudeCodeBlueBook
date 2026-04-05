# 使用专题

`guides/` 当前有 98 篇编号文档，范围 `01-98`。本目录把源码研究翻成可执行的方法、模板、审读清单和构建手册，不重复产品说明文案。

## 目录分层

- `01-10`: 基础使用、多 Agent、记忆注入、预算与权限协作。
- `11-23`: Runtime 设计、Contract-First、依赖图诚实性与审读清单。
- `24-32`: Prompt Constitution、治理顺序、源码塑形与苏格拉底式审读。
- `33-47`: Rollout ABI、Evidence Envelope、Host Implementation、Validator 与 Builder 蓝图。
- `48-56`: Builder-facing 手册、统一蓝图与宿主迁移工单。
- `57-80`: 宿主迁移失真、验收执行、修复、收口、监护、解除监护与稳态纠偏执行。
- `81-98`: 再纠偏、改写纠偏、精修与 refinement correction 执行模板。

## 推荐入口

- [01-使用指南](01-使用指南.md)
- [02-多Agent编排与Prompt模板](02-多Agent编排与Prompt模板.md)
- [06-第一性原理实践：目标、预算、对象、边界与回写](06-第一性原理实践：目标、预算、对象、边界与回写.md)
- [08-如何根据预算、阻塞与风险选择session、task、worktree与compact](08-如何根据预算、阻塞与风险选择session、task、worktree与compact.md)
- [21-共享前缀快照策略模板：何时保存、何时复用、何时suppress](21-共享前缀快照策略模板：何时保存、何时复用、何时suppress.md)
- [30-如何用苏格拉底诘问法审读Prompt魔力：主语、共享前缀、边界与合法遗忘](30-如何用苏格拉底诘问法审读Prompt魔力：主语、共享前缀、边界与合法遗忘.md)

## 使用方式

- 想要“先学会用”：从 `01-10`
- 想把阅读源码变成稳定方法：从 `19-23`
- 想把方法沉到模板、卡片和 rollout 工件：从 `24-47`
- 想处理宿主迁移、验收、修复和后续纠偏：从 `48-98`
- 想看最新共同 `reject` 升级模板骨架：从 `93-98`
- 想做跨目录跳转：回到 [../navigation/README.md](../navigation/README.md)

## 维护约定

- README 只保留编号段和稳定起点，不再逐条镜像 `57-98` 这类高频重命名段。
- 需要失败样本时，回到 [../casebooks/README.md](../casebooks/README.md)。
- 需要运行手册和演练脚本时，回到 [../playbooks/README.md](../playbooks/README.md)。
