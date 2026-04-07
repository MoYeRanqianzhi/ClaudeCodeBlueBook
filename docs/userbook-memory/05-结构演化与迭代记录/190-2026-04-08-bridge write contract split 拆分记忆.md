# bridge write contract split 拆分记忆

## 本轮继续深入的核心判断

55 已经拆开：

- dedup family taxonomy

189 已经拆开：

- continuity contract

但 bridge 写入侧还缺一句更窄的判断：

- shared transport sink 不等于 shared write contract

本轮要补的更窄一句是：

- `writeMessages(...)`、`writeSdkMessages(...)`、`initialMessageUUIDs`、`recentPostedUUIDs` 与 `flushGate` 应分别落在 REPL/internal-message contract、daemon/direct-SDK contract 与 shared echo suppress layer 三层

## 为什么这轮必须单列

如果不单列，正文最容易在四种偷换里回卷：

- 把两个 write 入口写成“最后都 writeBatch，所以一样”
- 把 `writeSdkMessages(...)` 缩成 “skip conversion”
- 把 shared `recentPostedUUIDs` 写成同一合同的证据
- 把 55 / 189 的主题重新拼回一页

这四种都会把：

- write contract
- dedup
- continuity

重新压扁。

本轮中途曾尝试把 190 写成：

- shared echo filter family vs continuity contract

但并行只读评估认为那条句子会回卷到 55 / 183 / 189；因此改写为更干净的：

- REPL path vs daemon path write contract split

## 本轮最关键的新判断

### 判断一：`writeMessages(...)` 是 REPL/internal-message write contract

### 判断二：`writeSdkMessages(...)` 是 daemon/direct-SDK write contract

### 判断三：`initialMessageUUIDs` 与 `flushGate` 只属于前者

### 判断四：`recentPostedUUIDs` 只是两边共享的 echo suppress 层，不足以抹平合同差异

## 苏格拉底式自审

### 问：为什么这页不是 55 的附录？

答：55 讲的是去重家族如何分层；190 讲的是 bridge 写入口为什么本来就在回答不同的写入合同。一个问 dedup taxonomy，一个问 write contract split。

### 问：为什么这页不是 189 的附录？

答：189 讲的是 continuity ledger；190 讲的是写入口的对象形状、startup suppress 与 `flushGate` 语义。一个问 ledger inheritance，一个问 write contract。

### 问：为什么不把这页缩成“daemon path 没有 initial messages”？

答：因为这只是差异的一部分；真正新增的句子是：两条 path 从入口对象开始就不是同一种 contract。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/190-writeMessages、writeSdkMessages、initialMessageUUIDs、recentPostedUUIDs 与 flushGate：为什么 REPL path 与 daemon path 不是同一种 bridge write contract.md`
- `bluebook/userbook/03-参考索引/02-能力边界/179-writeMessages、writeSdkMessages、initialMessageUUIDs、recentPostedUUIDs 与 flushGate 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/190-2026-04-08-bridge write contract split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 190
- 索引层只补 179
- 记忆层只补 190

不回写 55、189。

## 下一轮候选

1. 若继续 bridge 线，可单列 `handleIngressMessage(...)` 对 `recentPostedUUIDs` / `recentInboundUUIDs` 的 consumer contract，但必须避免重写 55。
2. 若切回 model 线，可整理 184-188 的阅读簇提示，但不应把正文膨胀成综述。
3. 若继续 daemon vs REPL 线，可再看 control request / result path 是否共享同一 contract，但必须避免和 134 重叠。
