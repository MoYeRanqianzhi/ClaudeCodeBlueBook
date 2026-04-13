# remote-surface stable-gray hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经补完：

- `204` 的 legacy scope guard
- `139-149` 的子家族入口

之后，

当前更值钱的下一刀，

不是继续细拆目录，

而是把：

- `204-activeRemote、remoteSessionUrl、outboundOnly、getIsRemoteMode 与 useReplBridge：为什么 remote surface 的 132、135、138、141、142、143 不是并列 remote 页，而是从 front-state consumer topology 分叉出去的五种后继问题.md`

补成和 `214/216` 同节奏的 stable / conditional / gray hardening。

## 为什么这轮值得单独提交

### 判断一：当前缺口已经不在“204 有没有 branch map”，而在“204 会不会把稳定骨架、条件显隐与灰度运行时重新压成一层”

`204` 现在已经有：

- 页首 scope guard
- `132 -> 135 -> 138 -> 141/142/143` 的分叉结论

但它还没有像 `214`、`216` 那样，

在后段显式把：

- 稳定可见骨架
- 条件公开行为
- 内部 / 灰度证据

三层分账。

于是读者虽然已经知道：

- 这些页不是并列 remote 页

却还容易在收口时再次把：

- foreground runtime
- shared interaction shell
- presence ledger
- gray runtime
- behavior bit

压成同一种 remote surface。

### 判断二：这轮不是再补结构，而是补合同厚度

本轮真正缺的不是：

- 新的 branch map
- 新的 family hub

而是让 `204` 自己也承担：

- 保护稳定功能
- 标出条件显隐
- 隔离灰度运行时证据

的责任。

这和 `214/216` 的写法已经是一致方向，

只是 `204` 还没补齐。

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `204-...五种后继问题.md`
   的结论前，
   增加一段 `稳定层与灰度层`：
   - `稳定可见`
   - `条件公开`
   - `内部/灰度层`
   并把 `132/135/138/141/142/143` 分别放回这三层

这样：

- `204`
  就不只是一张 anti-overlap map
- 它还会变成 remote surface 这簇页面的稳定骨架页
- 后面如果继续读 `216/217`，也能保持同一套分层口径

## 苏格拉底式自审

### 问：为什么这轮不是继续抽更细的 `144-149` 子家族？

答：因为目录层现在已经足够细了；真正还不够硬的是 `204` 本身还没把 stable / conditional / gray 三层写明。

### 问：为什么 `204` 需要补这三层，而不是把这项工作留给 `216`？

答：因为 `216` 只负责 `139-143`。`204` 仍是 `132` 之后整条 remote surface 分叉图的上位骨架，如果它自己不分账，读者会在进入后继页前先把几种 surface 压扁。

### 问：为什么这轮不是再补页首，而是补结尾层级？

答：因为页首范围声明已经有了。当前真正缺的是读者读完整页之后，能否明确知道哪些对象属于稳定骨架，哪些只是条件显隐或灰度证据。
