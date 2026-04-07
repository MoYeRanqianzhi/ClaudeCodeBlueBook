# startup model source split 拆分记忆

## 本轮继续深入的核心判断

184 已经把 model 线里的 authority order 拆成：

- persisted preference
- live override
- resumed-agent fallback

但启动阶段仍缺一句更窄的判断：

- 最后都能影响当前 model，不等于它们共享同一种 startup source

本轮要补的更窄一句是：

- `ANTHROPIC_MODEL`、`settings.model`、`mainThreadAgentDefinition.model` 与 `setMainLoopModelOverride(effectiveModel)` 应分别落在 ambient env preference、saved setting、agent bootstrap source 与 live launch override 四层

并且还要再补一句：

- `setInitialMainLoopModel(...)` 记录的是 startup snapshot，不是 raw source 本体

## 为什么这轮必须单列

如果不单列，正文最容易在四种偷换里回卷：

- 把 `ANTHROPIC_MODEL` 写成 settings 的环境版别名
- 把 `settings.model` 写成当前 runtime 正在执行的 model
- 把 `mainThreadAgentDefinition.model` 写成“启动时最终 model 的真实来源”
- 把 `setMainLoopModelOverride(...)` 写成保留了原始来源信息的统一 model source

这四种都会把：

- source family
- sink
- snapshot

重新压扁。

## 本轮最关键的新判断

### 判断一：`ANTHROPIC_MODEL` 是 ambient env preference，不是 saved setting

### 判断二：`settings.model` 是 merged saved-setting snapshot，不是 env shadow

### 判断三：`mainThreadAgentDefinition.model` 只是 agent bootstrap candidate

### 判断四：`setMainLoopModelOverride(effectiveModel)` 是启动归并后的 live launch override sink

### 判断五：`setInitialMainLoopModel(...)` 是 startup snapshot，不是 raw source

### 判断六：同一个 override slot 里的 `undefined` / `null` / resolved string 也不是同一种 fallback 语义

## 苏格拉底式自审

### 问：为什么这页不是 184 的附录？

答：184 讲的是 authority order；185 讲的是 startup source family 与 launch collapse。一个问“谁说了算”，一个问“这些值原本来自哪一类来源，以及何时被压进同一个 slot”。

### 问：为什么一定要把 `setInitialMainLoopModel(...)` 拉进来？

答：因为如果不把 snapshot 单列，读者会把 precedence 计算后的结果误当成原始来源本体，source / sink / snapshot 三层又会重新缠在一起。

### 问：为什么不顺手把 `/model`、print、resume 的 writer 全部一起写完？

答：因为那会把当前窄页重新膨胀成 override writer 总页，稳定句子会失焦，而且和 107、166、184 的边界重新重叠。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/185-getUserSpecifiedModelSetting、ANTHROPIC_MODEL、settings.model、mainThreadAgentDefinition.model 与 setMainLoopModelOverride：为什么ambient env preference、saved setting、agent bootstrap 与 live launch override 不是同一种 model source.md`
- `bluebook/userbook/03-参考索引/02-能力边界/174-getUserSpecifiedModelSetting、ANTHROPIC_MODEL、settings.model、mainThreadAgentDefinition.model 与 setMainLoopModelOverride 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/185-2026-04-08-startup model source split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 185
- 索引层只补 174
- 记忆层只补 185

不回写 107、182、184。

## 下一轮候选

1. 若继续沿 model 线往下拆，可单列 `mainLoopModelOverride` 作为统一 writer register 的语义，但必须避免和 185 只差一句话。
2. 若转回 bridge 线，可写 `initialHistoryCap` / `isEligibleBridgeMessage` 的 UI-only projection contract，但必须避免回卷到 54 / 181 / 183。
3. print / resume 的 model writer 家族仍可后置，不作为 185 的正文膨胀项。
