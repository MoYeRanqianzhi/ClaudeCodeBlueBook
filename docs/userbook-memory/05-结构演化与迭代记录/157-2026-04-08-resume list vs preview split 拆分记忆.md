# resume list vs preview split 拆分记忆

## 本轮继续深入的核心判断

156 已经把 local preview 与 attached viewer remote history 拆开了。

但正文还缺一个更细的本地 durable 结论：

- `/resume` 自己内部的列表摘要面和 preview transcript 面也不是同一种 surface

本轮要补的更窄一句是：

- `getSessionFilesLite + enrichLogs` 产出的列表摘要面，不等于 `SessionPreview + loadFullLog` 产出的 preview transcript 面

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把列表摘要写成 preview 的缩略版
- 把 `enrichLogs()` 写成 full transcript hydrate
- 把共享 durable source 写成共享 consumer contract

这三种都会把：

- local durable list surface
- local durable preview surface

重新压扁。

## 本轮最关键的新判断

### 判断一：`getSessionFilesLite()` 先只解决“哪些 session 值得进列表”

### 判断二：`enrichLogs()` 补的是摘要字段与过滤，不是正文 hydrate

### 判断三：`LogSelector` 列表消费的是 title/metadata/snippet

### 判断四：`SessionPreview` 才真正触发 `loadFullLog()` 和 `Messages`

### 判断五：`loadFullLog()` 的核心工作是 transcript reconstruction，不是列表补字段

## 苏格拉底式自审

### 问：为什么这页不是 156 的附录？

答：因为 156 讲的是 local preview vs remote history；157 完全留在 local durable 侧，只继续拆 preview 之前的列表摘要面。

### 问：为什么一定要把 `LogSelector` 写进来？

答：因为只有把列表 consumer 写出来，读者才不会把 `enrichLogs()` 误当成 preview 的前置 hydrate。

### 问：为什么一定要写 `loadFullLog()`？

答：因为它是 preview 面真正跨过的边界，标志从 metadata/summarized surface 进入 transcript reconstruction。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/157-getSessionFilesLite、enrichLogs、LogSelector、SessionPreview 与 loadFullLog：为什么 resume 的列表摘要面不是 preview transcript.md`
- `bluebook/userbook/03-参考索引/02-能力边界/146-getSessionFilesLite、enrichLogs、LogSelector、SessionPreview 与 loadFullLog 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/157-2026-04-08-resume list vs preview split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 157
- 索引层只补 146
- 记忆层只补 157

不回写 152、156。

## 下一轮候选

1. 继续拆 `enrichLogs()` 的 progressive loading 与 deep search/snippet 面为什么不是同一种列表 consumer。
2. 继续拆 `/resume` preview 的 full hydrate 与 `SessionPreview` 交互动作为什么不是同一种 resume ownership。
