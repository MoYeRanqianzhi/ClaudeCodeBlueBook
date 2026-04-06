# pendingLastEmittedEntry inert stale staging 拆分记忆

## 本轮继续深入的核心判断

99 已经把 `pendingLastEmittedEntry` 的存在理由讲清了。

102 又把 cleanup path 与 missing telemetry settlement 讲清了。

继续往下压时，最容易误写的一层是：

- 某些 cleanup 分支里它没被一起清掉，是不是已经足以推出用户可见 bug？

这轮的核心判断是：

- 不对称残留是真实存在的
- 但从当前控制流看，它更像 inert stale staging，而不是 visible protocol bug

## 为什么这轮必须单列

如果不单列，正文只会在两种坏方向里二选一：

- 要么把它完全忽略，写成“一切都对称”
- 要么把它夸大成“deferred suggestion stream 已损坏”

这两种都不够严谨。

## 本轮最关键的新判断

### 判断一：`pendingLastEmittedEntry` 天生就是 incomplete staging

它没有 `emittedAt`，这一点值得被拿出来单独强调。

### 判断二：真正的外层 gate 是 `pendingSuggestion`

这句话能把“残留 slot = 残留 suggestion”这个误判直接打断。

### 判断三：cleanup 非对称存在，但它的严重性必须克制表述

最稳的写法是：

- internal stale staging

而不是：

- visible stream corruption

### 判断四：这页必须主动标记“推断”边界

因为“更像 inert”是基于当前控制流路径的判断，不该包装成公开稳定合同。

## 苏格拉底式自审

### 问：为什么这页不能并回 99？

答：99 的主语是 staging 的必要性与 promotion 语义；104 的主语是 cleanup asymmetry 后为什么仍不太像 visible bug。

### 问：为什么这页不能并回 102？

答：102 的主语是 telemetry settlement；104 的主语是 internal staging hygiene。

### 问：为什么要强调 `pendingSuggestion` 的 gate 性？

答：因为这是说明“残留 slot 仍然缺少外部后果路径”的最硬依据。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/104-pendingLastEmittedEntry、pendingSuggestion、lastEmitted、interrupt 与 end_session：为什么 headless print 的 deferred suggestion staging 会留下 inert stale slot.md`
- `bluebook/userbook/03-参考索引/02-能力边界/93-pendingLastEmittedEntry inert stale staging 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/104-2026-04-06-pendingLastEmittedEntry inert stale staging 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 104
- 索引层只补 93
- 记忆层只补 104

不把它并回 99，也不把它并回 102。

## 下一轮候选

1. 单独拆 `model` 为什么在 metadata restore 里属于 separate override，而不是 `externalMetadataToAppState(...)` 的对称逆映射。
2. 单独拆 `post_turn_summary` 的 stdout-vs-SDKMessage split 为什么不等于“完全不可见”。
3. 单独拆 direct connect 路径对 `post_turn_summary` 的过滤为什么属于 consumer path，而不是 summary existence contract。
