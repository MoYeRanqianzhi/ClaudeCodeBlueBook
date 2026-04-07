# permission reevaluation surface split 拆分记忆

## 本轮继续深入的核心判断

198 已经拆开：

- permission race 的四层 closeout

但 closeout 之前还缺一句更细的判断：

- permission context 变更后的本地重判广播只触达 leader queue，不是所有 ask surface 的统一 re-evaluation

本轮要补的更窄一句是：

- `onSetPermissionMode(...)`、`getLeaderToolUseConfirmQueue()` 与 local `recheckPermission()` 形成一条 leader-local re-evaluation surface，而 remote / inbox 的 `recheckPermission()` 明确是 no-op

## 为什么这轮必须单列

如果不单列，正文最容易在四种偷换里回卷：

- 把 mode change 写成所有 pending ask 的统一重判
- 把 `recheckPermission()` 当成 generic permission API
- 忽略 remote / inbox 的 no-op surface
- 把 re-evaluation 和 198 的 closeout 写成一件事

这四种都会把：

- local permission context
- leader queue fanout
- remote/worker no-op

重新压扁。

## 本轮最关键的新判断

### 判断一：`onSetPermissionMode(...)` 先改的是本地 permission context，不是直接替 ask 出 verdict

### 判断二：leader queue fanout 只触达本地 `ToolUseConfirm` surface

### 判断三：`interactiveHandler.ts` 的 `recheckPermission()` 是真实重判路径

### 判断四：`useRemoteSession` / `useInboxPoller` 的 `recheckPermission()` 是显式 no-op，不共享这条本地重判面

## 苏格拉底式自审

### 问：为什么这页不是 198 的附录？

答：198 讲的是 verdict 之后怎么收；199 讲的是 closeout 之前，哪些 ask surface 会先收到本地重判广播。

### 问：为什么 `recheckPermission()` 不能直接当成统一接口？

答：因为同名方法在 local ask 上会真重判，在 remote/worker ask 上明确是 no-op。

### 问：为什么这页不能只写“CCR 改 mode 会触发重判”？

答：因为真正的主语是本地 leader permission context 变化，CCR 只是一个触发源。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/199-onSetPermissionMode、getLeaderToolUseConfirmQueue、recheckPermission、useRemoteSession 与 useInboxPoller：为什么 permission context 变更后的本地重判广播不是同一种 permission re-evaluation surface.md`
- `bluebook/userbook/03-参考索引/02-能力边界/188-onSetPermissionMode、getLeaderToolUseConfirmQueue、recheckPermission、useRemoteSession 与 useInboxPoller 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/199-2026-04-08-permission reevaluation surface split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 199
- 索引层只补 188
- 记忆层只补 199

不回写 198。

## 下一轮候选

1. 若切回结构层，可把 191-199 再投影进更高层功能面导航，但不能复制 197 的局部结构页。
2. 若继续 transcript 面，可看 webhook sanitize 若源码后续可见，是否值得从 195 的 normalization 线分离。
3. 若继续 permission 面，可看 sandbox network bridge 的 host-level sibling cleanup 与 tool-level closeout 是否值得拆开，但必须避免回卷 198/199。
