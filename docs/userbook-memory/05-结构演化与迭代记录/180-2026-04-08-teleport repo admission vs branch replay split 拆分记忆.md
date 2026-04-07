# teleport repo admission vs branch replay split 拆分记忆

## 本轮继续深入的核心判断

179 已经把 git 语义拆成：

- repository declaration
- branch projection

但 teleport runtime 里还缺一句更窄的判断：

- repo declaration / branch projection 进入运行时后，也不等于同一种恢复合同

本轮要补的更窄一句是：

- `validateSessionRepository(...)`、`getBranchFromSession(...)`、`checkOutTeleportedSessionBranch(...)` 与 `teleportToRemote(...)` 应分别落在 repo admission 与 branch replay 两层

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 repo 校验写成 branch checkout 的前置小步骤
- 把 branch replay 失败写成 teleport admission 失败
- 把 `sources` 的存在误写成 `outcomes` 的天然伴生

这三种都会把：

- admission gate
- replay hint

重新压扁。

## 本轮最关键的新判断

### 判断一：`validateSessionRepository(...)` 先是 repo admission gate

### 判断二：`getBranchFromSession(...)` / `checkOutTeleportedSessionBranch(...)` 先是 branch replay helper

### 判断三：`teleportResumeCodeSession(...)` 先过 admission，再把 branch 作为 replay hint 传下去

### 判断四：显式 `environmentId` create path 可以有 `sources`，同时明确写 `outcomes: []`

### 判断五：`branchError` 被写进 teleport notice，说明 replay 失败不是 admission verdict

## 苏格拉底式自审

### 问：为什么这页不是 179 的附录？

答：179 讲的是字段语义里的 declaration / projection；180 讲的是这些字段进入 teleport runtime 后如何变成 admission / replay 两张不同合同。

### 问：为什么一定要把显式 `environmentId` 路径拉进来？

答：因为没有这条旁证，读者仍可能误把 `sources` 的存在写成 outcome branch 的天然承诺。

### 问：为什么一定要把 `print.ts` / `main.tsx` 的消费链拉进来？

答：因为只有把 `branchError` 在恢复后被追加成 notice 这层写出来，才能直接证明 replay failure 与 admission failure 不是同一层收口。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/180-validateSessionRepository、getBranchFromSession、checkOutTeleportedSessionBranch 与 teleportToRemote：为什么 repo admission 与 branch replay 不是同一种 teleport contract.md`
- `bluebook/userbook/03-参考索引/02-能力边界/169-validateSessionRepository、getBranchFromSession、checkOutTeleportedSessionBranch 与 teleportToRemote 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/180-2026-04-08-teleport repo admission vs branch replay split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 180
- 索引层只补 169
- 记忆层只补 180

不回写 174、176、179。

## 下一轮候选

1. 继续拆 `session_context.model` 与 live / durable model ledger：为什么 session-create model stamp 不是同一种 runtime model truth。
2. 若继续沿 bridge create/replay 链往下拆，更好的候选是 `createBridgeSession.events` 与 REPL `initialMessages` ingress flush：为什么 session-create events 不是 `/remote-control` 历史回放机制。
3. `createBridgeSession.source` 与 `BridgePointer.source` 暂不再优先单列：并行 Agent 复核后判断它会高重叠回卷到 175 / 177。
