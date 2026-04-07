# local artifact provenance split 拆分记忆

## 本轮继续深入的核心判断

170 已经把 `print` headless resume 的 source certainty 拆成：

- implicit recent local
- explicit local artifact
- conditional remote materialization

但正文还缺一句更窄的 local artifact 判断：

- 同属 explicit local artifact，也不等于 provenance 相同

本轮要补的更窄一句是：

- `print --resume .jsonl` 与 `print --resume session-id` 应分别落在 transcript-file-backed 与 session-registry-backed 两层

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 `.jsonl` 与 `session-id` 写成只是文件/UUID 的输入形状差异
- 把两者共享的 `loadConversationForResume(...)` 误写成它们共享全部 provenance
- 把 `.jsonl` 中从 transcript tip 推断 `sessionId` 的事实写没

这三种都会把：

- transcript-file-backed artifact
- session-registry-backed artifact

重新压扁。

## 本轮最关键的新判断

### 判断一：`print --resume session-id` 的 provenance 来自当前项目 session registry

### 判断二：`print --resume .jsonl` 的 provenance 来自显式 transcript file path

### 判断三：两者共享 `loadConversationForResume(...)` formal restore contract，但不共享 upstream artifact provenance

### 判断四：`.jsonl` 的 `sessionId` 还要从 transcript tip 推断，不能被写成用户直接给定

### 判断五：这页必须留在 explicit local provenance distinction，不回卷到 163/170/169 的其他层级

## 苏格拉底式自审

### 问：为什么这页不是 170 的附录？

答：因为 170 讲 certainty；171 讲 explicit local artifact 里的 provenance。

### 问：为什么一定要把 `loadMessagesFromJsonlPath(...)` 写进来？

答：因为只有把这条函数拉出来，才能直接证明 `.jsonl` 不是 registry lookup，而是 transcript chain reconstruction。

### 问：为什么一定要写 `.jsonl` 的 `sessionId` 来自 leaf tip？

答：因为这正是它和 plain UUID 路径最硬的 provenance 差异。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/171-loadMessagesFromJsonlPath、parseSessionIdentifier、loadConversationForResume 与 sessionId：为什么 print --resume .jsonl 与 print --resume session-id 不是同一种 local artifact provenance.md`
- `bluebook/userbook/03-参考索引/02-能力边界/160-loadMessagesFromJsonlPath、parseSessionIdentifier、loadConversationForResume 与 sessionId 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/171-2026-04-08-local artifact provenance split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 171
- 索引层只补 160
- 记忆层只补 171

不回写 163、169、170。

## 下一轮候选

1. 继续拆 bridge `--continue` 与 `--session-id`：为什么 bridge pointer continuity 与 explicit original-session targeting 不是同一种接回方式。
2. 继续拆 `.jsonl` tip `sessionId` 与 `--fork-session`：为什么 transcript provenance 与新 session ownership 不是同一种主权。
