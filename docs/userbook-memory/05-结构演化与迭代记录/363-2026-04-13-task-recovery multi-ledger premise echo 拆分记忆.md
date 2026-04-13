# task-recovery multi-ledger premise echo 拆分记忆

## 本轮继续深入的核心判断

在上一刀已经把：

- `02-任务对象、输出回流、通知与恢复.md`

补成：

- `task recovery` 恢复的是后台任务对象与结果回收能力

之后，

下一刀最值钱的不再是继续补 leaf echo，

而是要往 headless print cluster 的根页下沉一层，

把：

- “任务结果回来以后也不会并成同一本恢复账”

这件事钉死。

## 为什么这轮值得单独提交

### 判断一：当前缺口不在“回流会不会发生”，而在“回流回来后是不是同一本账”

现在这条线已经有三层：

- `task recovery` 叶子页
  讲恢复的是后台任务对象与结果回收能力
- `90`
  讲 `task-notification` 不是普通进度提示
- `95`
  讲任务结果不会走同一条回流路径

但如果直接从叶子页跳到 `95`，

读者仍容易漏掉一个更前提的问题：

- 这些结果即使回来了，
  也不是回到同一本账上

所以当前更值钱的根页，

是：

- `92-headless print 的任务结果不会落在同一层账本.md`

### 判断二：这一刀比去补 `95` 更稳

并行只读分析给出两种候选：

- `95`：把 runtime return path 与 generic resume/continuity source 分开
- `92`：先把 task ledger / command lifecycle ledger / attachment ledger 分开

当前 recovery/continuity 横轴刚刚补完 `task recovery` 叶子页，

最自然的下一步不是先选哪条回流路径，

而是先说明：

- 返回的结果不会并成同一本恢复账

也就是：

- 多账本前提

所以这刀应先落 `92`。

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `92-headless print 的任务结果不会落在同一层账本.md`
   的导语和第一性原理之间，
   补一小段：
   - 从 `task recovery` 轴看，这里最重要的不是“任务结果会不会回来”，而是“回来以后也不会并成同一本恢复账”
   - `task recovery` 恢复的是后台任务对象与结果回收能力
   - 它不会把 `task_id` 的 task bookend、queued command `uuid` 的消费生命周期、以及模型看到的 `<task-notification>` 内容压平成一张统一状态表
   - 后面 93-99 的 triad / return-path / flush-ordering 拆分都建立在这个多账本前提上

这样：

- `task recovery` 叶子页与 `92-99` 簇之间终于有了真正的桥
- recovery/continuity 横轴不会太快跳成“选哪条 return path”
- `90 / 92 / 95`
  也不会继续被读成同一层的并列细节页

## 苏格拉底式自审

### 问：为什么不直接补 `95`，它不是更像“结果回流”吗？

答：因为 `95` 讨论的是哪条回流路径负责 close / re-entry，而当前更前提的问题是“这些结果落在哪几本账上”。先补 `92`，结构顺序更稳。

### 问：为什么不再去改 `90`？

答：因为 `90` 的主轴是 `task-notification` 的 dual-consumer envelope。现在再补，只会重复“不是普通进度提示”，推进不了 recovery/continuity 的多账本前提。

### 问：为什么这段要放在导语和第一性原理之间？

答：因为它承担的是“从横轴转入这簇 proof 页”的桥接句。放得太后，就会继续让读者先掉进“同一本账”的误读，再被正文纠正。
