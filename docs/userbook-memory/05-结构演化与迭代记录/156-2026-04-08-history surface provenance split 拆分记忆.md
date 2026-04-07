# history surface provenance split 拆分记忆

## 本轮继续深入的核心判断

153 已经把 attached viewer 内部的分页哨兵和 remote presence 拆开了。

但正文还缺一条更外层的 history 结论：

- attached viewer 的 remote history 不是 `/resume` preview 的本地 transcript 快照

本轮要补的更窄一句是：

- `/resume` preview 读本地 durable JSONL，attached viewer 读 remote session events API；两边都长得像 transcript，但不是同一种 history surface

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 attached viewer 写成 `/resume` preview 的联网版
- 把共享的 `Messages` renderer 写成共享的历史来源
- 把 preview 的 lite->full hydration 与 attached viewer 的 latest->older paging 混成一套

这三种都会把：

- local durable preview
- remote event paging

重新压扁。

## 本轮最关键的新判断

### 判断一：`/resume` preview 先拿 lite log，再用 `loadFullLog()` 补全本地 transcript

### 判断二：attached viewer 通过 remote session events API 补 history

### 判断三：两边共享 `Messages` 壳，但不共享 authoritative history source

### 判断四：preview 的失败语义和 attached viewer paging 的失败语义也不同

## 苏格拉底式自审

### 问：为什么这页不是 153 的附录？

答：因为 153 还在 attached viewer 内部比较 paging sentinel 和 presence surface；156 已经跨到另一个 consumer `/resume` preview，比较的是两张 history provenance。

### 问：为什么一定要写 `getSessionFilesLite()`？

答：因为它能把 preview 的“先索引、后 hydrate”模型钉死，避免被误写成一次性全量读文件。

### 问：为什么一定要写 `Messages`？

答：因为共享同一个 transcript renderer 正是造成错觉的原因，必须点破。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/156-getSessionFilesLite、loadFullLog、SessionPreview、useAssistantHistory 与 fetchLatestEvents：为什么 resume preview 的本地 transcript 快照不是 attached viewer 的 remote history.md`
- `bluebook/userbook/03-参考索引/02-能力边界/145-getSessionFilesLite、loadFullLog、SessionPreview、useAssistantHistory 与 fetchLatestEvents 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/156-2026-04-08-history surface provenance split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 156
- 索引层只补 145
- 记忆层只补 156

不回写 58、118、153。

## 下一轮候选

1. 继续拆 `/resume` preview 的 lite/full hydration 与 session list enrichment 的边界。
2. 继续拆 attached viewer remote history 与 live event stream 的 consumer 差异，避免把 latest page 和 live append 混成一张面。
