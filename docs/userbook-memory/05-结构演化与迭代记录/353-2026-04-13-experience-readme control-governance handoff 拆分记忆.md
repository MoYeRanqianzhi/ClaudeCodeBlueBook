# experience-readme control-governance handoff 拆分记忆

## 本轮继续深入的核心判断

这一轮不是继续扩写 `05-控制面深挖/README`，

也不是继续改治理总则页，

而是补：

- `02-能力地图/05-体验与入口/README.md`

到：

- `control vs governance`

这条链的显式 handoff。

## 为什么这轮值得单独提交

### 判断一：当前真正的断点，不再是“有没有 crosswalk”，而是“体验层会不会继续把 projection 当 truth”

前两刀已经分别补了：

- `05` 的 `control vs governance`
- `03-治理与边界/README` 的上游 echo

但体验层当前还只写到：

- `host -> session -> projection -> display`
- `无真相签发权`

它缺少一条更可执行的下文：

- 体验层里的高频词如果还没先归 `control`
  就不要升到 `governance`

### 判断二：这刀比继续修稳定/灰度边界更值

稳定/灰度边界现在已经在：

- `06`
- `13`
- `16`

这些页里持续对齐。

当前更大的残差反而是：

- 读者是否会在体验层就把 `/status / /doctor / /usage / /resume / /remote-control`
  这类词直接听成治理结论

所以这 4 行 handoff

比继续精修某一个单页的可见性语气更有系统收益。

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `02-能力地图/05-体验与入口/README.md`
   的 `无真相签发权` 后，
   加一段极小的 handoff：
   - 体验层只翻译 `host / session / projection / display`
   - 争议若还停在 host/session/viewer/status surface，先按 `control` 归位，再回 `05`
   - 只有争议已经落到 `decision window / continuation pricing / cleanup-before-resume`
     才升级成 `governance`，再回 `03-治理与边界`
   - `/status / /doctor / /usage / /resume / /remote-control`
     在这一层都先只算 `projection / readback / consumer`

这样：

- `体验层 -> control -> governance`
  成了一条显式链
- `05`
  的 crosswalk
  不再像悬空定义

## 苏格拉底式自审

### 问：为什么这句不直接写在 `05` 或 `03-治理与边界` 里就够了？

答：因为误判往往发生在体验层。只在 `05` 和治理页讲清，仍然会让读者在 `host/session/projection/display` 这一层先把入口词误听成 verdict。

### 问：为什么这里只做 handoff，不再讲一遍更完整的 crosswalk？

答：因为这页的职责是体验层翻译，不是重复承担动作层或治理层。这里最值钱的是把读者送到正确下一层，而不是再复制一套完整判据。
