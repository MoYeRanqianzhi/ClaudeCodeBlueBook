# git context split 拆分记忆

## 本轮继续深入的核心判断

178 已经把 `session_context` 拆成：

- repo source
- branch outcome
- model stamp

但 git 这两层内部还缺一句更窄的判断：

- `sources` 与 `outcomes` 不只是两个并列字段，而是 declaration 与 projection 两种不同 git 主语

本轮要补的更窄一句是：

- `session_context.sources` 与 `session_context.outcomes` 应分别落在 repository declaration 与 branch projection 两层

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 `sources` 与 `outcomes` 写成同一份 repo metadata
- 把 `sources.revision` 写成 `outcomes.branches[0]` 的另一种表示
- 把 owner/repo 一致误写成对象主语一致

这三种都会把：

- source-side repo declaration
- outcome-side branch projection

重新压扁。

## 本轮最关键的新判断

### 判断一：`sources` 先是 repository declaration

### 判断二：`outcomes` 先是 branch projection

### 判断三：`sources.revision` 与 `outcomes.branches[0]` 不属于同一值域

### 判断四：repo helper 当前消费 `sources`，branch helper 当前消费 `outcomes`

### 判断五：同一 owner/repo 字符串并不自动说明主语相同

## 苏格拉底式自审

### 问：为什么这页不是 178 的附录？

答：因为 178 讲的是 sources/outcomes/model 三分；179 讲的是 sources 与 outcomes 在 git 语义上的继续分裂。

### 问：为什么必须把 `getBranchFromSession(...)` 拉进来？

答：因为没有它，就少了一条“本地 helper 消费面已分家”的硬证据。

### 问：为什么一定要保留 `parseGitRemote(...)` / `parseGitHubRepository(...)`？

答：因为 repository declaration 的来源构造正是 `sources` 这一侧的硬证据，能把它和 outcome-side branch naming 区分开。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/179-session_context.sources、session_context.outcomes、parseGitRemote、parseGitHubRepository 与 getBranchFromSession：为什么 repo declaration 与 branch projection 不是同一种 git context.md`
- `bluebook/userbook/03-参考索引/02-能力边界/168-session_context.sources、session_context.outcomes、parseGitRemote、parseGitHubRepository 与 getBranchFromSession 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/179-2026-04-08-git context split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 179
- 索引层只补 168
- 记忆层只补 179

不回写 152、167、178。

## 下一轮候选

1. 继续拆 `session_context.model` 与 runtime model readback：为什么 session-create model stamp 与 live/durable model ledger 不是同一种 model 语义。
2. 继续拆 `createBridgeSession.source` 与 `BridgePointer.source`：为什么同名 source 也不等于同一种 authority object，但必须比 177 更窄。
