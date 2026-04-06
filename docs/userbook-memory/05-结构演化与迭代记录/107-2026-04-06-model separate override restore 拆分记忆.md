# model separate override restore 拆分记忆

## 本轮继续深入的核心判断

52 已经说明 `model` 不走 `externalMetadataToAppState(...)`。

但如果只停在那个层面，读者仍然会保留一个更顽固的误解：

- 这是不是只是 mapper 少写了一项？

这轮要补的是更窄的一层：

- `model` 的恢复落点本来就更像 main-loop override sink，而不是普通 `AppState` patch sink

## 为什么这轮必须单列

如果不单列，正文很容易继续走向两种错误：

- 把 `model` 写成“和 mode 一样，只是实现不同”
- 把 `setMainLoopModelOverride(...)` 写成无关紧要的胶水噪音

这会把真正的 restore sink 差异再次抹平。

## 本轮最关键的新判断

### 判断一：`externalMetadataToAppState(...)` 从来就不是 metadata 全量逆映射器

这句是本轮最需要钉死的根句。

### 判断二：`model` 的恢复落点本来就不是状态树 patch，而是 override 声明

所以“为什么不统一走 mapper”本身就是错问题。

### 判断三：写回链与恢复链都共同指向这条分叉

model 改动时主动 `notifySessionMetadataChanged({ model })`，恢复时又单独 `setMainLoopModelOverride(...)`，这不是偶然分叉。

## 苏格拉底式自审

### 问：为什么这页不能并回 52？

答：因为 52 的主语是 session parameter family；107 的主语是 `model` 一项的 restore sink identity。

### 问：为什么这页不能并回 103？

答：因为 103 讲 observer metadata 为何不享有同一种恢复待遇；107 讲 durable-ish parameter 里的 `model` 为什么也不走普通 `AppState` mapper。

### 问：为什么要强调“不是错过，而是不该同路”？

答：因为这是防止读者把当前设计误解成实现遗漏的关键。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/107-model、externalMetadataToAppState、setMainLoopModelOverride 与 restoredWorkerState：为什么 metadata 里的 model 不是普通 AppState 回填项.md`
- `bluebook/userbook/03-参考索引/02-能力边界/96-model separate override restore 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/107-2026-04-06-model separate override restore 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 107
- 索引层只补 96
- 记忆层只补 107

不把它并回 52，也不把它并回 103。

## 下一轮候选

1. 单独拆 direct connect 路径对 `post_turn_summary` 的过滤为什么属于 consumer path，而不是 summary existence contract。
2. 单独拆 `streamlined` transformer 为什么是在 raw wire 之前改写，而不是终态收口之后补充。
3. 单独拆 `stream-json --verbose` 与 builder/control transport 面之间的对应关系，为什么不等于普通 public SDK consumer 视图。
