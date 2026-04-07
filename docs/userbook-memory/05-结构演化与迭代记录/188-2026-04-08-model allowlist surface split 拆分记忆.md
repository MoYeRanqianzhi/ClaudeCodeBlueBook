# model allowlist surface split 拆分记忆

## 本轮继续深入的核心判断

187 已经拆开：

- source selection
- allowlist admission
- default fallback

但 model allowlist 线里还缺一句更窄的判断：

- 同一条 `isModelAllowed(...)` predicate，不等于同一种用户合同

本轮要补的更窄一句是：

- `model.tsx`、`validateModel(...)`、`getModelOptions()` 与 `getUserSpecifiedModelSetting()` 应分别落在 explicit rejection、reusable write validation、option hiding 与 silent getter veto 四层

## 为什么这轮必须单列

如果不单列，正文最容易在四种偷换里回卷：

- 把所有 allowlist surface 写成统一报错
- 把 option hiding 写成输入后拒绝
- 把 `validateModel(...)` 缩成 `/model` 的局部细节
- 把 getter-time silent veto 写成 write-time 同一种 UX

这四种都会把：

- write surface
- option surface
- read surface

重新压扁。

## 本轮最关键的新判断

### 判断一：`/model` 是 explicit rejection

### 判断二：`validateModel(...)` 是 reusable write-time validator，`/config` 也共用它

### 判断三：`getModelOptions()` 是 option hiding，而且稳定保留 `Default`

### 判断四：`getUserSpecifiedModelSetting()` 是 silent getter veto

### 判断五：同一 `isModelAllowed(...)` 被复用，不等于同一种 contract

## 苏格拉底式自审

### 问：为什么这页不是 187 的附录？

答：187 讲的是 veto 之后不会 reopen lower-source；188 讲的是同一 predicate 在不同 surface 上为什么表现成不同用户合同。一个问 stage split，一个问 surface split。

### 问：为什么 `getModelOptions()` 一定要进正文？

答：因为如果没有 option surface，读者还是会把“我看不到这个选项”误听成“系统拒绝了我刚刚输入的值”，这会把 hide 与 reject 重新压成一层。

### 问：为什么 `validateModel(...)` 不能退到脚注？

答：因为 `/config model` 明确复用了它；如果不把 reusable validator 单列，正文就会误把显式写入失败说成 `/model` 独有现象。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/188-model.tsx、validateModel、getModelOptions 与 getUserSpecifiedModelSetting：为什么显式拒绝、选项隐藏与 silent veto 不是同一种 allowlist contract.md`
- `bluebook/userbook/03-参考索引/02-能力边界/177-model.tsx、validateModel、getModelOptions 与 getUserSpecifiedModelSetting 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/188-2026-04-08-model allowlist surface split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 188
- 索引层只补 177
- 记忆层只补 188

不回写 187。

## 下一轮候选

1. 优先回 bridge 线：并行只读评估认为，v1 / v2 在 `previouslyFlushedUUIDs` 上的差异是更强的下一候选，但必须避免把 183 / 186 重写一遍。
2. 若继续 model 线，可整理 184-188 的阅读簇提示，但不应把正文页重新膨胀成综述。
3. 若转去更细的 UX 层，可单列 `Default` 作为 option surface 的稳定出口，但必须避免和 188 只差一个例子。
