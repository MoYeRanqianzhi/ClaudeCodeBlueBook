# task-result return-path vs continuity-source echo 拆分记忆

## 本轮继续深入的核心判断

在上一刀已经把：

- `92-headless print 的任务结果不会落在同一层账本.md`

补成：

- task result 不会并成同一本恢复账

之后，

下一刀最自然的后继节点，

不是回头再补 `90`，

而是顺着 `92 -> 95`

这条主干往下走，

把：

- runtime return path
- continuity source

先显式拆开。

## 为什么这轮值得单独提交

### 判断一：当前缺口不在“有没有回流路径”，而在“回流路径会不会被误听成接续来源”

`95` 这页已经在讲：

- XML re-entry 路
- direct SDK terminal 路

也就是：

- 同一份 task result 怎样回流

但如果没有先补一句范围声明，

读者仍容易把这页顺手读成：

- generic `resume / continue`
- bridge continuity

这类“接续来源”的另一种变体。

而这恰好是：

- `169`

那条线要回答的问题。

### 判断二：这刀比去改 `90` 更顺

并行只读分析已经明确：

- `90` 讲的是 `task-notification` 的 dual-consumer envelope
- `92` 讲的是多账本前提
- `95` 才是 `92` 之后的 return-path split

所以当前最稳的顺序是：

- 先有 `92` 的多账本前提
- 再有 `95` 的回流路径分叉

而不是回头在 `90` 再做 notification 对象论补丁。

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `95-headless print 的任务结果不会走同一条回流路径.md`
   的导语和第一性原理之间，
   补一句范围声明：
   - 这里分的是单次 task result 的 runtime return path：XML queue、SDK `task_notification` event 与 model re-entry 只是同一条回流轴上的不同节点，不是 generic `resume / continue` source 或 bridge continuity 的来源问题

这样：

- `95` 的主题不再悬空
- `92` 和 `95` 的父子关系更清楚
- `95` 不会再被误读成“另一种会话接续来源页”

## 苏格拉底式自审

### 问：为什么不直接去改 `169`，让它顺手多提一句 return path？

答：因为 `169` 的主轴是接续来源，不是单次结果怎样回流。把 return path 塞进去，会把“下一次从哪里继续”和“这一次怎么回流”重新揉成一层。

### 问：为什么这句要放在导语和第一性原理之间？

答：因为它承担的是范围声明。读者在还没进入两条路径之前，就应先知道这页讨论的是 runtime return path，而不是 continuity source。

### 问：为什么不顺手再改 `90`？

答：因为 `90` 的 notification 对象论已经足够承担本地前提。当前最值钱的是把 `92 -> 95` 这条主干继续收直，而不是重新回头补 cluster 侧枝。
