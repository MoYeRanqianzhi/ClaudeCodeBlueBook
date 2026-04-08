# 执行手册

`playbooks/` 固定接入、验收、修复与长期验证的执行判据、拒收条件与回归检查。
这里只接受已经被承认的正式对象；如果你还在问“为什么如此设计”或“第一条反证信号是什么”，还没到 `playbooks/`。

更硬一点说：

- `playbooks/` 的职责不是解释对象链，而是对已经被承认的对象链出 `execution verdict`。
- 更具体地说，只有当 `10 / security / risk` 已经把主语、读回与对象边界定住，`playbooks/` 才开始决定验收、回退与 reopen 顺序。

若你还在判母线、对象链或 `continuity` 到底是什么意思，先离开本目录；这些都还不是 execution question。

## 什么时候进来

- 当你已经有正式对象定义，需要把它们写进接入、验收、修复或长期验证的执行顺序。
- 当你需要的不再是“为什么这样设计”，而是“下一步该验什么、拒收什么、回退什么”。
- 当你已经经过 `10 / security / risk` 的边界判定，准备把对象链压成现场顺序、`execution verdict` 与 rollback 边界。
- 当你需要把 later maintainer 的局部反对权转成正式拒收、回退与 reopen 顺序，而不再停在“看起来不对”的体感层。

更稳一点说，`playbooks/` 也必须继承 shared first-answer order：先确认母线、对象与用户侧 readback 都已定住，再判 `execution verdict`、rollback 与 reopen；如果顺序倒过来，执行手册就会重新退回“按模板代替对象链”。

## 只在 verdict 已定后再选执行入口

- 现有执行手册稳定编号仍是 `29-31`、`65-67`、`77-79`；下列条目只提供稳定起点，不替具体手册重跑 admission / repair / verification 判断。

- 如果你只先判断“宿主现在可准入还是不可准入”，看 [29-Prompt宿主接入审读手册：message lineage、projection consumer、protocol transcript与continuation qualification排查](29-Prompt%E5%AE%BF%E4%B8%BB%E6%8E%A5%E5%85%A5%E5%AE%A1%E8%AF%BB%E6%89%8B%E5%86%8C%EF%BC%9A%E8%BE%93%E5%85%A5%E9%9D%A2%E3%80%81section%20breakdown%E3%80%81cache%20break%E5%8F%AF%E8%A7%A3%E9%87%8A%E6%80%A7%E4%B8%8Econtinue%20qualification%E6%8E%92%E6%9F%A5.md)、[30-治理宿主接入审读手册：governance key、externalized truth chain、typed ask与continuation pricing排查](30-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E6%8E%A5%E5%85%A5%E5%AE%A1%E8%AF%BB%E6%89%8B%E5%86%8C%EF%BC%9Aauthority%20source%E3%80%81decision%20window%E3%80%81pending%20action%E4%B8%8Erollback%20object%E6%8E%92%E6%9F%A5.md)、[31-结构宿主接入审读手册：current-truth surface、per-host authority width、freshness gate与ghost capability证据排查](31-%E6%95%85%E9%9A%9C%E6%A8%A1%E5%9E%8B%E5%AE%BF%E4%B8%BB%E6%8E%A5%E5%85%A5%E5%AE%A1%E8%AF%BB%E6%89%8B%E5%86%8C%EF%BC%9Aauthority%20state%E3%80%81recovery%20boundary%E4%B8%8Eanti-zombie%E7%BB%93%E6%9E%9C%E9%9D%A2%E6%8E%92%E6%9F%A5.md)。
  - 失败信号：宿主仍在消费字符串、投影状态或恢复体感，而不是正式对象。
- 如果你只先判断“修复现在可收口还是不可收口”，看 [65-Prompt宿主修复稳态纠偏再纠偏改写纠偏精修执行手册：message lineage card、shared reject order与reopen drill](65-Prompt%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E7%B2%BE%E4%BF%AE%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Ahost%20consumption%20card%E3%80%81hard%20reject%20order%E4%B8%8Ereopen%20drill.md)、[66-治理宿主修复稳态纠偏再纠偏改写纠偏精修执行手册：governance key host consumption card、hard reject order与reopen drill](66-%E6%B2%BB%E7%90%86%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E7%B2%BE%E4%BF%AE%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Ahost%20consumption%20card%E3%80%81hard%20reject%20order%E4%B8%8Ereopen%20drill.md)、[67-结构宿主修复稳态纠偏再纠偏改写纠偏精修执行手册：event stream / state writeback card、freshness gate、hard reject order与reopen drill](67-%E7%BB%93%E6%9E%84%E5%AE%BF%E4%B8%BB%E4%BF%AE%E5%A4%8D%E7%A8%B3%E6%80%81%E7%BA%A0%E5%81%8F%E5%86%8D%E7%BA%A0%E5%81%8F%E6%94%B9%E5%86%99%E7%BA%A0%E5%81%8F%E7%B2%BE%E4%BF%AE%E6%89%A7%E8%A1%8C%E6%89%8B%E5%86%8C%EF%BC%9Ahost%20consumption%20card%E3%80%81hard%20reject%20order%E4%B8%8Ereopen%20drill.md)。
  - 失败信号：能描述故障现象，却说不清 reject 顺序、reopen 条件和回退对象。
- 如果你只先判断“验证现在已闭环还是仍属轶事”，看 [77-请求装配控制面验证手册：message lineage、projection consumer、continuation object与cache-safe fork回归](77-%E8%AF%B7%E6%B1%82%E8%A3%85%E9%85%8D%E6%8E%A7%E5%88%B6%E9%9D%A2%E9%AA%8C%E8%AF%81%E6%89%8B%E5%86%8C%EF%BC%9Aauthority%20chain%E3%80%81protocol%20transcript%E3%80%81continuation%20object%E4%B8%8Ecache-safe%20fork%E5%9B%9E%E5%BD%92.md)、[78-当前世界准入主权验证手册：governance key、externalized truth chain、typed ask、decision window、continuation pricing与durable-transient cleanup回归](78-%E5%BD%93%E5%89%8D%E4%B8%96%E7%95%8C%E5%87%86%E5%85%A5%E4%B8%BB%E6%9D%83%E9%AA%8C%E8%AF%81%E6%89%8B%E5%86%8C%EF%BC%9Atrusted%20inputs%E3%80%81typed%20ask%E3%80%81%E6%9C%80%E5%B0%8F%E5%8F%AF%E8%A7%81%E9%9D%A2%E4%B8%8Econtinuation%20gate%E5%9B%9E%E5%BD%92.md)、[79-one writable present验证手册：current-truth surface、freshness gate、stale worldview与ghost capability回归](79-one%20writable%20present%E9%AA%8C%E8%AF%81%E6%89%8B%E5%86%8C%EF%BC%9Asingle-writer%20authority%E3%80%81recovery%20asset%E4%B8%8Eanti-zombie%E5%9B%9E%E5%BD%92.md)。
  - 失败信号：还在用“跑过一遍 / 看起来稳定 / 体感恢复正常”代替回归证据，或还说不清当前 drift 对应哪一种 verdict。

## 这里不回答什么

- 本目录不负责解释第一性原理，也不负责展开失败样本库。
- 本目录只回答“怎么执行、怎么验收、怎么回归、怎么拒收”；更细的跨阶段跳转统一回 [../navigation/README.md](../navigation/README.md)。
- 如果你还在问模仿对象或第一条反证信号，先回 `../navigation/05` 与 `../navigation/15`。

## 维护约定

- `playbooks/` 负责“怎么演练、怎么回归、怎么值班”，不复制方法论正文。
- README 只保留判断式入口与稳定起点，不再展开长链路由。
- README 只负责执行前门，不和 `41` 的第一性原理页或 `casebooks/` 的失真页混层。
- README 应优先暴露 verdict、rollback 与 reopen 边界，不重新退回为什么如此设计的解释层。
- 过程记录与变更记录统一回写到 `docs/`，不写进运行手册正文。
