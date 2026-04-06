# 使用专题

`guides/` 当前有 102 篇编号文档，范围 `01-102`。本目录把源码研究翻成可执行的方法、模板、审读清单和构建手册，不重复产品说明文案。

还要先记一句：

- `guides/99-102` 负责把 `09` 的三条控制面判断落成 builder-facing 审读与证据方法；它们现在分别更明确覆盖 `message lineage`、`source-first pricing`、`one writable present` 与公开镜像证据分级，不再重新定义三条母线本身
- `guides/30-31` 保留旧一层 Prompt / 治理审读词汇，但现在应被当作通向 `99-101` 的桥接入口；正文不再承担“这页属于旧版模板”的作者说明，桥接职责统一由 README 描述
- `guides/57-59` 与 `81 / 90` 现在分别承担 Prompt / 治理 / 结构三条宿主迁移与深层执行纠偏；它们已经回到新对象链，默认不再被当作旧桥接页

## 目录分层

- `01-10`: 基础使用、多 Agent、记忆注入、预算与权限协作。
- `11-23`: Runtime 设计、Contract-First、依赖图诚实性与审读清单。
- `24-32`: Prompt Constitution、治理顺序、源码塑形与苏格拉底式审读，以及旧词汇到新控制面对象的桥接页。
- `33-47`: Rollout ABI、Evidence Envelope、Host Implementation、Validator 与 Builder 蓝图。
- `48-56`: Builder-facing 手册、统一蓝图与宿主迁移工单。
- `57-80`: 宿主迁移失真、验收执行、修复、收口、监护、解除监护与稳态纠偏执行。
- `81-102`: 再纠偏、改写纠偏、精修、三张控制面图对应的高阶审读模板与公开镜像证据分级方法。

## 推荐入口

- [../09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md](../09-%E4%B8%89%E5%BC%A0%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%B8%96%E7%95%8C%E8%BF%9B%E5%85%A5%E6%A8%A1%E5%9E%8B%E3%80%81%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7%E4%B8%8E%E9%98%B2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md): 三条控制面判断的主线宪法
- [01-使用指南](01-使用指南.md)
- [02-多Agent编排与Prompt模板](02-多Agent编排与Prompt模板.md)
- [06-第一性原理实践：目标、预算、对象、边界与回写](06-第一性原理实践：目标、预算、对象、边界与回写.md)
- [08-如何根据预算、阻塞与风险选择session、task、worktree与compact](08-如何根据预算、阻塞与风险选择session、task、worktree与compact.md)
- `21-32`: 共享前缀、Prompt 审读与治理顺序模板
- `99-102`: 三张控制面图对应的高阶审读模板与公开镜像证据分级方法
- 想直接抓 Prompt 对象链的 builder 审读模板：从 `99`
- 想直接抓 source-first pricing / externalized truth 的 builder 审读模板：从 `100`
- 想直接抓 `event-stream-vs-state-writeback / freshness gate / stale worldview / ghost capability` 的 builder 审读模板：从 `101`
- 想直接抓公开镜像源码质量分级方法：从 `102`

## 使用方式

- 想要“先学会用”：从 `01-10`
- 想把阅读源码变成稳定方法：从 `19-23`
- 想把方法沉到模板、卡片和 rollout 工件：从 `24-47`
- 想处理宿主迁移、验收、修复和后续纠偏：从 `48-101`
- 想把控制面总图变成 Builder 审读顺序：先回 [../09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md](../09-%E4%B8%89%E5%BC%A0%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%B8%96%E7%95%8C%E8%BF%9B%E5%85%A5%E6%A8%A1%E5%9E%8B%E3%80%81%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7%E4%B8%8E%E9%98%B2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md)，Prompt 线默认从 `30 -> 99` 起步、治理线默认从 `100` 起步、结构线默认从 `101` 起步；只有需要更早一层桥接时再补旧页
- 想处理 Prompt 迁移 / 验收 / 长期验证尾部：默认走 `57 -> 35 -> 77`
- 想处理治理迁移 / 验收 / 长期验证尾部：默认走 `58 -> 36 -> 78`
- 想处理结构迁移 / 验收 / 长期验证尾部：默认走 `59 -> 37 -> 79`
- 想把 builder 审读一路接到长期验证：Prompt 走 `99 -> 77`，治理走 `100 -> 78`，结构走 `101 -> 79`
- 想看公开镜像下的源码质量方法：先回 [../09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md](../09-%E4%B8%89%E5%BC%A0%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%B8%96%E7%95%8C%E8%BF%9B%E5%85%A5%E6%A8%A1%E5%9E%8B%E3%80%81%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7%E4%B8%8E%E9%98%B2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md)，再从 `102` 进入；更细的跨目录回链统一去 [../navigation/README.md](../navigation/README.md)
- 想看最新共同 `reject` 升级模板骨架：从 `93-98`
- 想做跨目录跳转：回到 [../navigation/README.md](../navigation/README.md)

## 维护约定

- README 只保留编号段和稳定起点，不再逐条镜像 `57-101` 这类高频重命名段。
- 需要失败样本时，回到 [../casebooks/README.md](../casebooks/README.md)。
- 需要运行手册和演练脚本时，回到 [../playbooks/README.md](../playbooks/README.md)。
