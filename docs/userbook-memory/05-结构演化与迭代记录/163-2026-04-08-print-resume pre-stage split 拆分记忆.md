# print-resume pre-stage split 拆分记忆

## 本轮继续深入的核心判断

162 已经把 interactive host family 和 headless print host family 拆开了。

但正文还缺一个更细的 print 侧结论：

- `print.ts` resume 内部的 parse / hydrate / restore / fallback / rewind 也不是同一种前置阶段

本轮要补的更窄一句是：

- `print.ts` 的 `--resume` 并不是“远端回灌后正式恢复”两步，而是至少五段不同 pre-restore stage 串起来的链

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 URL / `.jsonl` / UUID 解释路径误写成同一种 session-id 恢复
- 把 remote hydrate 误写成 formal restore
- 把 empty-session fallback / `resumeSessionAt` 误写成恢复结果自然组成部分

这三种都会把：

- identifier parsing
- remote materialization
- formal restore
- absence semantics
- message trimming

重新压扁。

## 本轮最关键的新判断

### 判断一：`parseSessionIdentifier()` 是输入解释层，不是恢复层

### 判断二：`hydrateFromCCRv2InternalEvents()` / `hydrateRemoteSession()` 是 remote-to-local transcript materialization

### 判断三：`loadConversationForResume()` 才是 formal restore load

### 判断四：empty-session fallback 决定的是 absence semantics，不是 restore 成败本身

### 判断五：`resumeSessionAt` 是 post-restore message-level rewind

## 苏格拉底式自审

### 问：为什么这页不是 162 的附录？

答：因为 162 只拆宿主族；163 继续往 print host 内部拆 pre-stage taxonomy。

### 问：为什么一定要写 empty-session fallback？

答：因为 URL / CCR v2 的空 transcript 在 print host 里会被解释成 startup hooks，而不是单纯失败，这条非常容易被漏写。

### 问：为什么一定要写 `resumeSessionAt`？

答：因为它证明 print resume 在 formal restore 之后还可能继续做链裁剪。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/163-print.ts、parseSessionIdentifier、hydrateRemoteSession 与 loadConversationForResume：为什么 print resume 的 parse、hydrate、restore 不是同一种前置阶段.md`
- `bluebook/userbook/03-参考索引/02-能力边界/152-print.ts、parseSessionIdentifier、hydrateRemoteSession 与 loadConversationForResume 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/163-2026-04-08-print-resume pre-stage split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 163
- 索引层只补 152
- 记忆层只补 163

不回写 160、162。

## 下一轮候选

1. 继续拆 transcript 合法化、interrupt 修复与 hook 注入为什么都在“恢复前后”发生，却不是同一种 runtime stage。
2. 继续拆 print/headless 路径里的 remote hydration、metadata 回填与 empty-session startup fallback 为什么不是同一种 remote recovery stage。
