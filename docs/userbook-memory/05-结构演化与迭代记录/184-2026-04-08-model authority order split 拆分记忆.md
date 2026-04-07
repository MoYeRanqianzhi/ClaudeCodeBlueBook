# model authority order split 拆分记忆

## 本轮继续深入的核心判断

183 已经把 bridge 初始历史的几组 UUID 集合拆成：

- wire slot
- local seed
- success ledger

但 model 线里还缺一句更窄的判断：

- 会影响最终 model 的几个对象，也不等于共享同一种主权顺序

本轮要补的更窄一句是：

- `settings.model`、`getMainLoopModelOverride()`、`currentAgentDefinition` 与 `restoreAgentFromSession(...).model` 应分别落在 persisted preference、live authority、resume short-circuit 与 resumed-agent fallback 四层

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 `settings.model` 写成当前 runtime authoritative model
- 把 override 写成 settings 的临时镜像
- 把 resumed-agent model 写成无条件恢复旧 session 的 model

这三种都会把：

- preference
- authority
- fallback

重新压扁。

## 本轮最关键的新判断

### 判断一：`settings.model` 先是 persisted preference

### 判断二：`getMainLoopModelOverride()` 先是 live runtime authority

### 判断三：`currentAgentDefinition` 会先行短路 resumed-agent restore

### 判断四：`restoreAgentFromSession(...).model` 只有在更强主权缺席时才补位

### 判断五：一起影响 `getMainLoopModel()`，不等于共享同一种 authority 层

## 苏格拉底式自审

### 问：为什么这页不是 182 的附录？

答：182 讲的是 stamp / shadow / usage / fallback 四张账；184 讲的是谁先抢到当前 runtime 的 model 主权。一个讲 ledger family，一个讲 authority order。

### 问：为什么一定要把 `currentAgentDefinition` 拉进来？

答：因为不把它写成先行短路条件，读者会天然把 resumed-agent model 误读成“正式恢复时总会回填回来”的强主权。

### 问：为什么一定要把 `settings.model` 单独写成 preference？

答：因为只有这样，才能明确它和 live override 的区别不是“持久 / 非持久”这么简单，而是主权层级本来就不同。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/184-getUserSpecifiedModelSetting、settings.model、getMainLoopModelOverride、currentAgentDefinition 与 restoreAgentFromSession：为什么 persisted model preference、live override 与 resumed-agent fallback 不是同一种 model authority.md`
- `bluebook/userbook/03-参考索引/02-能力边界/173-getUserSpecifiedModelSetting、settings.model、getMainLoopModelOverride、currentAgentDefinition 与 restoreAgentFromSession 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/184-2026-04-08-model authority order split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 184
- 索引层只补 173
- 记忆层只补 184

不回写 52、107、158、182、183。

## 下一轮候选

1. 若继续沿 model 线往下拆，可再写 env / settings / override 之间 “持久保存” 与 “当前解释权” 的错位，但必须避免回卷到 184。
2. 若继续沿 bridge 线往下拆，可再写 `initialHistoryCap` 与 “UI-only history” 的对象边界，但必须避免回卷到 54 / 181 / 183。
3. `createBridgeSession.source` 与 `BridgePointer.source` 仍暂不再优先单列：高重叠回卷到 175 / 177。
