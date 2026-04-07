# inbound normalization split 拆分记忆

## 本轮继续深入的核心判断

194 已经拆开：

- user-only transcript adapter

但 adapter 内部还缺一句更细的判断：

- content block repair 与 attachment path-ref materialization 不是同一种前处理合同

本轮要补的更窄一句是：

- `normalizeImageBlocks(...)` 修 `message.content` 内坏块，`resolveInboundAttachments(...)` / `prependPathRefs(...)` 处理 `file_attachments`，二者不是同一种 inbound normalization contract

## 为什么这轮必须单列

如果不单列，正文最容易在四种偷换里回卷：

- 把 `message.content` 坏块修复和 `file_attachments` 下载落盘写成同一种 normalize
- 把 attachment prepend 误写成第二消费面
- 把 `resolveAndPrepend(...)` 当成合并两层合同的证据
- 把 hook / print 的差异误写成不稳定实现细节

这四种都会把：

- correctness repair
- best-effort materialization
- prompt sink alignment

重新压扁。

## 本轮最关键的新判断

### 判断一：`normalizeImageBlocks(...)` 属于 content-internal schema repair

### 判断二：`resolveInboundAttachments(...)` / `prependPathRefs(...)` 属于外挂附件的 materialization 与 sink 对齐

### 判断三：`resolveAndPrepend(...)` 只是 attachment pipeline wrapper，不会合并两层合同

### 判断四：hook / print 的接法差异证明 attachment 层可组合，而不是 transcript adapter 唯一主句

## 苏格拉底式自审

### 问：为什么这页不是 194 的简单续写？

答：194 讲 consumer 形状；195 讲同属 user adapter 的内部前处理为什么还要再分层。

### 问：为什么 attachment 处理不能算第二消费面？

答：因为它没有把消息送去别的系统，只是把 user payload 改写得更适合 prompt sink。

### 问：为什么 `resolveAndPrepend(...)` 不能证明两层就是一层？

答：因为 wrapper 只包装 attachment pipeline，本身并不碰 `normalizeImageBlocks(...)`。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/195-extractInboundMessageFields、normalizeImageBlocks、resolveInboundAttachments、prependPathRefs 与 resolveAndPrepend：为什么 image block repair 与 attachment path-ref prepend 不是同一种 inbound normalization contract.md`
- `bluebook/userbook/03-参考索引/02-能力边界/184-extractInboundMessageFields、normalizeImageBlocks、resolveInboundAttachments、prependPathRefs 与 resolveAndPrepend 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/195-2026-04-08-inbound normalization split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 195
- 索引层只补 184
- 记忆层只补 195

不回写 194。

## 下一轮候选

1. 若继续 permission 面，可看 `pendingPermissionHandlers` 的 request ownership 与竞态边界，但必须避免回卷 29 与 193。
2. 若继续 transcript 面，可看 webhook sanitize 与 attachment materialization 是否值得再拆，但必须避免把 195 切成纯实现噪音。
3. 若切回结构层，可把 191-195 收束成 ingress 阅读簇导航，而不是继续扩正文。
