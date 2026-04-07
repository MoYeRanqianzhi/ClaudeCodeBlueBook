# durable session metadata split 拆分记忆

## 本轮继续深入的核心判断

117、120、133 已经把 init visibility、payload thickness 和 foreground consumption 拆开了。

但正文还缺一条更偏 session lifecycle 的结论：

- metadata 不是只在启动和前台活着，它还有一张 durable ledger

本轮要补的更窄一句是：

- transcript/sessionStorage 尾部那套 durable session metadata 不是 live `system/init`，也不是 foreground `external_metadata`

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 `system/init` 写成所有 metadata 的总入口
- 把 `external_metadata` 写成所有 metadata 的当前真值
- 把 transcript 尾部 metadata 写成“只是多写一次日志”

这三种都会把：

- startup publish
- live runtime
- durable session ledger

重新压扁。

## 本轮最关键的新判断

### 判断一：`system/init` 负责启动时公开什么

### 判断二：`external_metadata` 负责当前运行态在说什么

### 判断三：`sessionStorage` 尾部 metadata 负责 EOF/history/resume 后仍可回读的会话账

### 判断四：`reAppendSessionMetadata()` 是 tail-window durable 保全机制，不是重复写盘

### 判断五：session list / preview / resume 更依赖 durable ledger，而不是 foreground live state

## 苏格拉底式自审

### 问：为什么这页不是 133 的后半段？

答：因为 133 还停在“前台有没有消费”，这页讲的是“即使前台没消费，哪些 metadata 仍要被 durable ledger 保全并在后续 consumer 里重新读回”。

### 问：为什么一定要把 `listSessionsImpl` 和 `SessionPreview` 拉进来？

答：因为只有把它们摆出来，durable ledger 才不再只是底层写盘细节，而是明确存在后读 consumer 的正式合同。

### 问：为什么一定要写 `reAppendSessionMetadata()`？

答：因为它正是 durable ledger 与普通 live metadata 最大的实现分界点。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/152-sessionStorage、hydrateFromCCRv2InternalEvents、sessionRestore、listSessionsImpl、SessionPreview 与 sessionTitle：为什么 durable session metadata 不是 live system-init，也不是 foreground external-metadata.md`
- `bluebook/userbook/03-参考索引/02-能力边界/141-sessionStorage、hydrateFromCCRv2InternalEvents、sessionRestore、listSessionsImpl、SessionPreview 与 sessionTitle 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/152-2026-04-08-durable session metadata split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 152
- 索引层只补 141
- 记忆层只补 152

不回写 117、120、133、151。

## 下一轮候选

1. 单独拆 `claude assistant` 的 discovery / install wizard / chooser / attach 四段入口链，避免把“发现会话”和“附着会话”写成同一种 connect 流。
2. 单独拆 durable session metadata 与 remote session ownership 的边界，避免把 metadata ledger 写成 session 主权证明。
