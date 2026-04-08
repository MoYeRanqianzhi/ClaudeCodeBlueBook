# remote surface branch map split 拆分记忆

## 本轮继续深入的核心判断

remote 这条线在 132-143 已经拆得很细，但目录层开始出现新的结构债：

- 132、135、138、141、142、143 都在讲 remote surface
- 但它们的主语已经不再相同

本轮要补的更窄一句是：

- 132 是 remote surface 的根页，135 / 138 / 141 / 142 / 143 则是从 front-state consumer topology 继续收窄出去的后继问题

## 为什么这轮必须单列

如果不单列，正文最容易在四种偷换里回卷：

- 把 141 写成所有 remote 壳共享 ledger 的未完成版
- 把 142 写成 bridge 版 141
- 把 143 写成 141 的别名
- 把 `00-阅读路径` 当成局部子系统 anti-overlap map 的替代品

这四种都会把：

- front-state consumer topology
- foreground runtime
- shared interaction shell
- presence ledger
- gray runtime
- behavior bit

重新压扁。

## 本轮最关键的新判断

### 判断一：132 是根页，不是并列 remote 页之一

### 判断二：135 先固定 direct connect 的 foreground runtime 身份

### 判断三：138 只讲 shared interaction shell，不讲 authoritative presence truth

### 判断四：141 只讲 remote-session presence ledger

### 判断五：142 只讲 bridge mirror 的 gray runtime

### 判断六：143 只讲 global remote behavior bit，不讲 presence ledger

## 苏格拉底式自审

### 问：为什么这页不是 20 的附录？

答：20 在用户目标层分 continuation / ingress / permission；204 已经退回局部控制面，只收 remote surface。

### 问：为什么这页不是 197 的附录？

答：197 讲 ingress 深线；204 讲 remote surface 深线。

### 问：为什么这页不是 `00-阅读路径.md` 的复制？

答：`00` 解决入口问题；204 解决进到 remote surface 子系统之后的 anti-overlap map。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/204-activeRemote、remoteSessionUrl、outboundOnly、getIsRemoteMode 与 useReplBridge：为什么 remote surface 的 132、135、138、141、142、143 不是并列 remote 页，而是从 front-state consumer topology 分叉出去的五种后继问题.md`
- `bluebook/userbook/03-参考索引/02-能力边界/192-activeRemote、remoteSessionUrl、outboundOnly、getIsRemoteMode 与 useReplBridge 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/204-2026-04-08-remote surface branch map split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 204
- 索引层只补 192
- 记忆层只补 204

不回写 132，也不新增 `04-专题深潜` 投影页。

## 下一轮候选

1. 若继续功能面分析，可转去 `StructuredIO` 的 `can_use_tool` / `requires_action` / blocked-state publish 结构页。
2. 若继续专题投影层，可评估是否要补一个更偏用户目标的 remote surface 专题页，但前提是不能复制 06/16/20 的职责。
3. 若继续目录优化，可把 132-149 这一段再投成更高层的阅读路径分组，而不是继续平铺条目。
