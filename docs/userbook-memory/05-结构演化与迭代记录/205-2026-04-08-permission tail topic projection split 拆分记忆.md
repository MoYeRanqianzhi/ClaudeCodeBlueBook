# permission tail topic projection split 拆分记忆

## 本轮继续深入的核心判断

203 已经把 permission tail 收成：

- verdict ledger 根页
- closeout / re-evaluation / host sweep / persist surfaces 四分叉

但从用户问题层看，还缺一张中层承接页：

- 用户知道“审批回来了”
- 却不知道现在该先查哪一层

本轮要补的更窄一句是：

- `04-专题深潜` 需要一张分诊页，把桥接审批回到本地后的用户问题直接映射到 198 / 199 / 201 / 202 / 203

## 为什么这轮必须单列

如果不单列，正文最容易在四种偷换里回卷：

- 把 203 的四分叉继续留在 `05` 层，不给用户问题层入口
- 把 20 的五轴分工误当成已经覆盖了 permission tail 分诊
- 把 198 / 199 / 201 / 202 重新压回“审批回来后的各种细节”
- 把专题页做成 203 的重写版，而不是用户分诊页

这四种都会把：

- 用户症状
- 局部根页
- 四种后继问题

重新压扁。

## 本轮最关键的新判断

### 判断一：20 解决的是 continuation / ingress / permission verdict 的用户目标层分工，不覆盖 permission tail 分诊

### 判断二：203 解决的是局部控制面 anti-overlap，不直接服务用户症状入口

### 判断三：新的 `04` 页只负责把“审批回来后我该查哪一层”映射到 198 / 199 / 201 / 202

## 苏格拉底式自审

### 问：为什么这页不是 20 的附录？

答：20 还在分 continuation / ingress / approval；21 已经默认 verdict 回到本地，只分 tail。

### 问：为什么这页不是 203 的附录？

答：203 讲局部结构图；21 讲用户问题分诊。

### 问：为什么这页不补 03 速查？

答：这是用户目标投影，不是新的能力边界对象页。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/04-专题深潜/21-桥接审批后处理与权限尾部分诊专题.md`
- `docs/userbook-memory/05-结构演化与迭代记录/205-2026-04-08-permission tail topic projection split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/04-专题深潜/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 只补 `04` 专题投影
- 不新增 `03` 索引页
- 不回写 203

## 下一轮候选

1. 若继续更深一层，可转去 `StructuredIO / requires_action / pending_action / blocked-state publish ceiling`。
2. 若继续远端结构线，可再补一个更偏用户问题层的 remote surface 专题页，但前提是不能复制 06/16/20 的职责。
