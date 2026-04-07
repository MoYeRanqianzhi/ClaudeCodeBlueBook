# remote memory persistence split 拆分记忆

## 本轮继续深入的核心判断

148 已经把 env remote axis 和 interactive remote bit 分开了。

但正文还缺一个更贴近使用面的 storage 结论：

- remote memory 不是一个目录，也不是一种写回器

本轮要补的更窄一句是：

- `CLAUDE_CODE_REMOTE_MEMORY_DIR` 只控制 memdir/auto-memory 根，而 `SessionMemory` 仍挂在 session transcript 账本上

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 memdir 根写成所有 memory 的总根
- 把 headless `print` 写成 session memory 的替身
- 把 interactive remote、assistant viewer、headless remote 压成同一种 memory 持久化语义

这三种都会把：

- auto-memory / agent-memory
- session memory
- transcript persistence
- remote viewer / remote print

重新压扁。

## 本轮最关键的新判断

### 判断一：`CLAUDE_CODE_REMOTE_MEMORY_DIR` 决定的是 remote 场景下 memdir 根是否存在、落在哪里

### 判断二：`SessionMemory` 仍属于 `projectDir/sessionId/session-memory/summary.md` 这条 session ledger

### 判断三：interactive remote 与 assistant viewer 会共享“跳过本地 session memory”的边界

### 判断四：headless `print` 主要 drain 的是 `extractMemories`，不是 `SessionMemory`

### 判断五：因此 remote memory persistence 至少是 auto-memory 根与 session 账本的双轨体系

## 苏格拉底式自审

### 问：为什么这页不是 148 的 storage 版附录？

答：因为 148 讲的是 remote 行为轴，这页讲的是持久化账本。前者问“哪根 remote 轴在起作用”，后者问“到底写到哪张账上”。

### 问：为什么一定要把 assistant viewer 拉进来？

答：因为它能证明 remote consumer 不自动等于本地 memory writer。

### 问：为什么一定要把 `extractMemories` 拉进来？

答：因为如果不把它写出来，headless `print` 很容易被误写成 `SessionMemory` 的 headless 替身。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/149-CLAUDE_CODE_REMOTE_MEMORY_DIR、memdir、SessionMemory、extractMemories 与 print：为什么 remote 记忆持久化不是单根目录，而是 auto-memory 根与 session 账本的双轨体系.md`
- `bluebook/userbook/03-参考索引/02-能力边界/138-CLAUDE_CODE_REMOTE_MEMORY_DIR、memdir、SessionMemory、extractMemories 与 print 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/149-2026-04-07-remote memory persistence split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 149
- 索引层只补 138
- 记忆层只补 149

不回写 145、148。

## 下一轮候选

1. 单独拆 `system/init.slash_commands`、`REMOTE_SAFE_COMMANDS`、plain-text wire routing 与 runtime 再解释为什么不是同一种 slash 合同。
2. 单独拆 `StatusLine` 里的 `remote.session_id` 为什么在 attached viewer / remote TUI 里不是同一种 session presence。
