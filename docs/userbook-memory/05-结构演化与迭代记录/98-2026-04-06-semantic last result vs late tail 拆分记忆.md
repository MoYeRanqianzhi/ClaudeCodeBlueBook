# semantic last result vs late tail 拆分记忆

## 本轮继续深入的核心判断

97 已经把 authoritative idle signal 拆出来了。

下一步最自然不是继续讲 idle 本身，而是继续往下压到：

- authoritative tail signals 为什么仍然不能抢走 result 的 semantic last-message 地位

因为这才把 idle / late task bookend / post_turn_summary / suggestion 全都收进同一条语义主位问题。

## 为什么这轮必须把 semantic last result 单列

如果不单列，读者会把 97 的结论停在：

- idle 很重要，而且必须晚于一堆收口条件

但更深一层真正关键的事实是：

- 重要不等于篡位
- late system tail 可以 authoritative，却仍不属于主结果层

## 本轮最关键的新判断

### 判断一：`lastMessage stays at the result` 是最硬的源码结论

这句几乎就是 98 的标题答案。

### 判断二：`heldBackResult` 与 `pendingSuggestion` 的关系证明“生成顺序”不等于“交付顺序”

这条补证很值钱。

### 判断三：`post_turn_summary` 也属于被排除出 semantic last result 的尾流系统层

这能把 98 从 idle 专题扩成更稳的一般语义边界。

### 判断四：`sessionState.ts` 里的 heuristic 风险证明这不是文档洁癖，而是真实 consumer 合同

### 判断五：`lastMessage` 还直接驱动 CLI 输出与退出语义

这条补证很值钱，因为它把 98 从“语义层级整理”升级成“如果写反，CLI 行为会直接出错”的硬约束。

## 为什么这轮不并回 97

97 讲 authoritative idle。
98 讲 semantic last result。

主语不同，不该揉回去。

## 苏格拉底式自审

### 问：为什么这轮最先该拆 suggestion？

答：因为它最能说明“已生成”与“已交付”不是同一件事，而 semantic last result 只认后者。

### 问：为什么 `post_turn_summary` 值得写进正文？

答：因为它证明被排除在主结果层之外的是一个系统尾流家族，不只是一条 idle 事件。

### 问：为什么 heuristic 风险能成为本页论据？

答：因为它说明如果不守住这条主位边界，consumer 会真的误判运行态。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/98-lastMessage stays at the result、SDK-only system events、pendingSuggestion、heldBackResult 与 post_turn_summary：为什么 headless print 的主结果语义不会让给晚到系统事件.md`
- `bluebook/userbook/03-参考索引/02-能力边界/87-Semantic last result vs late system tail 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/98-2026-04-06-semantic last result vs late tail 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小改动：

- 长文层只补 98
- 索引层只补 87
- 记忆层只补 98

不把 97-98 重新揉成一篇大的 idle/result 尾流总论。

## 下一轮候选

1. 单独拆 `pendingSuggestion`、`lastEmitted` 与 acceptance tracking 的延迟记账语义。
2. 单独拆 `post_turn_summary` 与 `task_summary` 的尾流层级差异。
3. 单独拆 headless `print` 的主结果层与 SDK tail layer 在 direct-connect / remote host 上的消费者差异。
