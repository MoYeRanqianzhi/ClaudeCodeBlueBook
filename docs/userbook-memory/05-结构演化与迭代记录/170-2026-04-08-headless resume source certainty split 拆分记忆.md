# headless resume source certainty split 拆分记忆

## 本轮继续深入的核心判断

169 已经把更宽的接续来源拆成：

- stable conversation history
- remote-hydrated transcript
- bridge pointer continuity

但正文还缺一句更窄的 headless 判断：

- 同属 `print` resume，也不等于 source certainty 相同

本轮要补的更窄一句是：

- `print --continue`、`print --resume session-id` 与 `print --resume url` 应分别落在 implicit local、explicit local 与 conditional remote materialization 三层

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 `print --continue` 和 `print --resume <session-id>` 写成只是自动/手动的 UI 差异
- 把 `print --resume <url>` 写成和本地显式 session-id 一样硬的恢复来源
- 把 `.jsonl` 错写成 remote source，而不是 local artifact family

这三种都会把：

- implicit recent local
- explicit local artifact
- conditional remote materialization

重新压扁。

## 本轮最关键的新判断

### 判断一：`print --continue` 的 certainty 来自默认最近本地会话

### 判断二：`print --resume session-id` / `.jsonl` 的 certainty 来自显式本地 artifact

### 判断三：`print --resume url` 的 certainty 先取决于 remote materialization 成不成立

### 判断四：remote source 甚至可能因为空内容退成 startup，因此 certainty 比 local explicit source 更弱

### 判断五：这页必须留在 headless source certainty，不回卷到 163 的 stage taxonomy 或 169 的更宽 source family

## 苏格拉底式自审

### 问：为什么这页不是 169 的附录？

答：因为 169 讲 source family；170 讲同一个 `print` host 内部的 source certainty ladder。

### 问：为什么一定要把 `.jsonl` 拉出来？

答：因为不拉出来，最容易把“显式本地 artifact”重新误写成“只剩 session-id 一种”。

### 问：为什么一定要写 remote empty -> startup？

答：因为这正是 remote materialization source certainty 更弱的直接证据。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/170-print --continue、print --resume session-id、print --resume url 与 loadConversationForResume：为什么同属 headless resume，也不是同一种 source certainty.md`
- `bluebook/userbook/03-参考索引/02-能力边界/159-print --continue、print --resume session-id、print --resume url 与 loadConversationForResume 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/170-2026-04-08-headless resume source certainty split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 170
- 索引层只补 159
- 记忆层只补 170

不回写 163、168、169。

## 下一轮候选

1. 继续拆 `remote-control --continue` 与 `--session-id`：为什么 bridge pointer continuity 与 explicit original-session targeting 不是同一种接回方式。
2. 继续拆 `print --resume session-id` 与 `print --resume .jsonl`：为什么同属 explicit local artifact，也不是同一种 provenance。
