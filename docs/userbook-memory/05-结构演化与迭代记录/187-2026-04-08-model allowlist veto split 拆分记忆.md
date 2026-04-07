# model allowlist veto split 拆分记忆

## 本轮继续深入的核心判断

184 已经拆开：

- authority order

185 已经拆开：

- startup source family

但 model 线里还缺一句更窄的判断：

- source precedence 不等于 allowlist admission

本轮要补的更窄一句是：

- `getUserSpecifiedModelSetting()` 先做 source selection，再做一次 source-blind `isModelAllowed(...)` veto；被 veto 的高优先级 candidate 不会 reopen 更低优先级来源，而是把下游直接送到 `undefined` / default

## 为什么这轮必须单列

如果不单列，正文最容易在四种偷换里回卷：

- 把 getter 写成平滑的 fallback ladder
- 把 allowlist veto 写成“继续试下一个来源”
- 把 `/model` 的显式报错写成 getter-time 同一种合同
- 把 resume / agent producer 又抬回正文中心

这四种都会把：

- source selection
- admission veto
- default fallback

重新压扁。

## 本轮最关键的新判断

### 判断一：source selection 只保留一个 candidate，不保留多来源候选集

### 判断二：`isModelAllowed(...)` 是 source-blind admission veto，不是 reopen lower-source 的 gate

### 判断三：被 veto 后返回的是 `undefined`，不是下一个来源

### 判断四：`getMainLoopModel()` 会直接转入 built-in default，而不是重跑来源链

### 判断五：`/model` / `validateModel()` 属于另一种 user-facing validation contract

## 苏格拉底式自审

### 问：为什么这页不是 184 的附录？

答：184 讲的是谁拥有主权；187 讲的是 candidate 选出来以后，admission veto 怎样改变下游语义。一个问 authority，一个问 stage split。

### 问：为什么这页不是 185 的附录？

答：185 讲的是 candidate 从哪来；187 讲的是 candidate 选出来之后被 allowlist 拒绝时，为什么不会 reopen 低优先级来源。一个问 source family，一个问 admission semantics。

### 问：为什么不把 `/model` UX 写成正文中心？

答：因为那会把主语换成显式交互，而这页真正新增的句子是 silent getter-time veto 对下游的影响。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/187-getUserSpecifiedModelSetting、isModelAllowed、ANTHROPIC_MODEL、settings.model 与 getMainLoopModel：为什么 source selection 之后的 allowlist veto 不会回退到更低优先级来源.md`
- `bluebook/userbook/03-参考索引/02-能力边界/176-getUserSpecifiedModelSetting、isModelAllowed、ANTHROPIC_MODEL、settings.model 与 getMainLoopModel 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/187-2026-04-08-model allowlist veto split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 187
- 索引层只补 176
- 记忆层只补 187

不回写 184、185。

## 下一轮候选

1. 若继续 model 线，可单列 `/model` / `validateModel()` 的显式拒绝与 getter-time silent veto 不是同一种 user-facing contract，但必须避免和 187 的 admission semantics 重叠过大。
2. 若切回 bridge 线，可单列 v1 / v2 在 `previouslyFlushedUUIDs` 上的差异，但必须避免把 183 重写一遍。
3. 若转去更宽的目录优化，可把 model 线的 184-187 组织成一条更显式的阅读簇，但不应破坏现有最小增量目录策略。
