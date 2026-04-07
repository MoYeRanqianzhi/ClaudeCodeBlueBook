# resume runtime stage split 拆分记忆

## 本轮继续深入的核心判断

163 已经把 print host 内部的 pre-stage chain 拆开了。

但正文还缺一个更贴近恢复边界的结论：

- transcript 合法化、interrupt 修复与 hook 注入不是同一种 runtime stage

本轮要补的更窄一句是：

- `deserializeMessagesWithInterruptDetection()` 的 legalize 与 repair 已经是两层，而 interactive 的 `SessionEnd -> SessionStart` 和 print 的 delayed interrupted-resume 又是另一层边界注入

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 sentinel 当成 sanitation residue
- 把 SessionStart 当成 transcript replay
- 把 interactive 与 print 的 hook / requeue 顺序差异抹平

这三种都会把：

- legalization
- repair
- hook boundary

重新压扁。

## 本轮最关键的新判断

### 判断一：`deserializeMessagesWithInterruptDetection()` 前半段只负责合法化

### 判断二：continuation message + assistant sentinel 构成单独的 repair 结构

### 判断三：interactive 路径的 hook 边界是 “旧会话 SessionEnd -> 新会话 SessionStart”

### 判断四：print 路径没有前置 SessionEnd，但有 delayed interrupted prompt requeue

### 判断五：SessionStart 产物不是单纯 message replay，而是 runtime side-effects bundle

## 苏格拉底式自审

### 问：为什么这页不是 160 的附录？

答：因为 160 讲 payload taxonomy；164 讲 runtime staging order。

### 问：为什么这页不是 163 的附录？

答：因为 163 讲 print host 内部 pre-stage；164 讲 shared resume boundary 附近的 runtime stage。

### 问：为什么一定要写 `takeInitialUserMessage()`？

答：因为它最能说明 SessionStart 的产物会进入不同 consumer，而不是自然落回 transcript。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/164-deserializeMessages、SessionEnd、SessionStart 与 interrupted-resume：为什么恢复前后的合法化、修复与 hook 注入不是同一种 runtime stage.md`
- `bluebook/userbook/03-参考索引/02-能力边界/153-deserializeMessages、SessionEnd、SessionStart 与 interrupted-resume 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/164-2026-04-08-resume runtime stage split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 164
- 索引层只补 153
- 记忆层只补 164

不回写 160、163。

## 下一轮候选

1. 继续拆 print/headless 路径里的 remote hydration、metadata 回填与 empty-session startup fallback 为什么不是同一种 remote recovery stage。
2. 继续拆 interactive live `/resume` 与 startup direct resume 为什么共享 restore contract，却不是同一种 session-unwind stage。
