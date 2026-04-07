# bridge authority split 拆分记忆

## 本轮继续深入的核心判断

171 已经把 `print` explicit local artifact 内部继续拆成：

- transcript-file-backed local artifact
- session-registry-backed local artifact

但 bridge continuity 分支里还缺一句更窄的判断：

- 同属 bridge reconnect family，也不等于 authority 相同

本轮要补的更窄一句是：

- `remote-control --continue` 与 `remote-control --session-id` 应分别落在 pointer-led continuity authority 与 explicit original-session authority 两层

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 `--continue` 写成只是自动补全一个 `session-id`
- 把共享的 `reconnectSession(...)` 误写成共享整个 reconnect authority
- 把 pointer cleanup responsibility 错写成两条路径共同拥有

这三种都会把：

- local crash-recovery artifact
- explicit original-session targeting
- pointer cleanup ownership

重新压扁。

## 本轮最关键的新判断

### 判断一：`remote-control --session-id` 的 authority 来自显式指定的原 session

### 判断二：`remote-control --continue` 的 authority 来自 local crash-recovery pointer，而不是用户显式输入

### 判断三：两者共享 downstream attach protocol，但不共享 upstream authority artifact

### 判断四：pointer 只负责 continuity selection，不负责最终 original-environment truth；server session record 仍保留更高权威

### 判断五：只有 pointer-led path 才拥有 deterministic cleanup 与 retry policy 上的 pointer responsibility

## 苏格拉底式自审

### 问：为什么这页不是 34 的附录？

答：因为 34 讲 failure taxonomy；172 讲 authority split，以及为什么 cleanup policy 只绑定 pointer-led path。

### 问：为什么必须把 `resumePointerDir` 写进来？

答：因为只有把它写出来，才能直接证明 local artifact ownership 与 cleanup responsibility 并不对称。

### 问：为什么一定要写 pointer 里虽有 `environmentId`，却仍去 `getBridgeSession(...)`？

答：因为这正是 continuity selection authority 与 original-environment truth 分层的硬证据。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/172-readBridgePointerAcrossWorktrees、getBridgeSession、reconnectSession 与 environment_id：为什么 remote-control --continue 与 remote-control --session-id 不是同一种 bridge authority.md`
- `bluebook/userbook/03-参考索引/02-能力边界/161-readBridgePointerAcrossWorktrees、getBridgeSession、reconnectSession 与 environment_id 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/172-2026-04-08-bridge authority split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 172
- 索引层只补 161
- 记忆层只补 172

不回写 33、34、169。

## 下一轮候选

1. 继续拆 `toInfraSessionId`、compat session tag 与 infra candidate retry：为什么同一条 old session identity 在 reconnect API 前还要再分 tag 空间。
2. 继续拆 pointer `environmentId` 与 server `environment_id`：为什么 continuity hint 与 original-environment truth 不是同一种 authority thickness。
