# 执行手册

`playbooks/` 固定接入、验收、修复与长期验证的执行判据、拒收条件与回归检查。
这里只接受已经被承认的正式对象；如果你还在问“为什么如此设计”或“第一条反证信号是什么”，还没到 `playbooks/`。

更硬一点说：

- `playbooks/` 的职责不是解释对象链，而是对已经被承认的对象链出 `execution verdict`。
- 更具体地说，只有当 `10 / security / risk` 已经把主语、读回与对象边界定住，`playbooks/` 才开始决定验收、回退与 reopen 顺序。

若你还在判母线、对象链或 `continuity` 到底是什么意思，先离开本目录；这些都还不是 execution question。
若你在争的是 execution 页是否越位代签 why 或 object，回 [../meta/README.md](../meta/README.md)；那已是目录契约问题，不是 execution question。

## 什么时候进来

- 当你已经有正式对象定义，需要把它们写进接入、验收、修复或长期验证的执行顺序。
- 当你需要的不再是“为什么这样设计”，而是“下一步该验什么、拒收什么、回退什么”。
- 当你已经经过 `10 / security / risk` 的边界判定，准备把对象链压成现场顺序、`execution verdict` 与 rollback 边界。
- 当你需要把 later maintainer 的局部反对权转成正式拒收、回退与 reopen 顺序，而不再停在“看起来不对”的体感层。

更稳一点说，入场前只确认主语、用户侧 readback 与对象边界都已定住；不要在执行首页重跑 first-answer 或 why。
稳定手册编号存在，但索引不在首页展开；README 只定义 `execution verdict / rollback / reopen` 的 owner scope。

## 这里不回答什么

- 本目录不负责解释第一性原理，也不负责展开失败样本库。
- 本目录只回答“怎么执行、怎么验收、怎么回归、怎么拒收”；更细的跨阶段跳转统一回 [../navigation/README.md](../navigation/README.md)。
- 如果你还在问模仿对象或第一条反证信号，先回 `../navigation/05` 与 `../navigation/15`。

## 维护约定

- `playbooks/` 负责“怎么演练、怎么回归、怎么值班”，不复制方法论正文。
- README 只保留判断式入口与稳定起点，不再展开长链路由。
- README 只负责执行入口，不和 `41` 的第一性原理页或 `casebooks/` 的失真页混层。
- README 应优先暴露 verdict、rollback 与 reopen 边界，不重新退回为什么如此设计的解释层。
- 过程记录与变更记录统一回写到 `docs/`，不写进运行手册正文。
