# blocked-state topic projection split 拆分记忆

## 本轮继续深入的核心判断

206 已经把 blocked-state promotion 和 publish ceiling 拆开了，

但从用户问题层看，还缺一张中层承接页：

- 用户知道“现在在等输入”
- 却不知道为什么这层 blocked 信息会有厚薄差异

本轮要补的更窄一句是：

- `04-专题深潜` 需要一张分诊页，把 “waiting bit / typed blocked context / pending JSON / restore gap” 直接映射到 206 / 51 / 133

## 为什么这轮必须单列

如果不单列，正文最容易在四种偷换里回卷：

- 把 206 继续留在 `05` 层，不给用户问题层入口
- 把 21 的 tail 专题误当成已经覆盖了 blocked-state 差异
- 把 `can_use_tool`、`requires_action_details`、`pending_action` 重新压成一句“都在等输入”
- 把专题页做成 206 的重写版，而不是用户分诊页

## 本轮最关键的新判断

### 判断一：21 解决的是 verdict 之后的 tail，不覆盖 blocked-state promotion

### 判断二：206 解决的是控制面结构，不直接服务用户症状入口

### 判断三：新的 `04` 页只负责把“为什么有时只有 waiting bit，有时上下文更厚”映射到 206 / 51 / 133

## 苏格拉底式自审

### 问：为什么这页不是 21 的附录？

答：21 讲 verdict 回来后的 tail；22 讲 verdict 之前的 blocked-state 投影。

### 问：为什么这页不是 206 的附录？

答：206 讲控制面结构；22 讲用户问题分诊。

### 问：为什么这页不补 03 速查？

答：这是用户目标投影，不是新的能力边界对象页。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/04-专题深潜/22-等待输入、权限提问与阻塞态投影专题.md`
- `docs/userbook-memory/05-结构演化与迭代记录/207-2026-04-08-blocked-state topic projection split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/04-专题深潜/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 只补 `04` 专题投影
- 不新增 `03` 索引页
- 不回写 206

## 下一轮候选

1. 若继续 blocked-state 线，可把 `206` 再往 restore / publish 分裂出更细的结构图。
2. 若继续 remote 线，可把 `204` 的 remote surface 分叉投成一个新的 `04` 专题页。
3. 若继续 headless / print 线，可回到 `post_turn_summary/task_summary` 的 foreground narrowing 继续向上投影。
