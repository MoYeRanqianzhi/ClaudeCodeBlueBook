# permission-ledger stable-gray hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `198` 的 permission closeout stable-gray
- `199` 的 permission reevaluation stable-gray
- `201` 的 sandbox host sweep stable-gray
- `202` 的 sandbox persist stable-gray
- `203` 的 trigger-vs-successor 护栏

逐步补平之后，

下一刀更值钱的，

不是继续扩目录入口，

而是回到：

- `196-pendingPermissionHandlers、BridgePermissionCallbacks、request_id、handlePermissionResponse 与 isBridgePermissionResponse：为什么 bridge permission race 的 verdict ledger 不是 generic control callback ownership.md`

把这张 permission verdict ledger 根页，

从旧式的“正文后直接收结论”，

补成最近已经稳定下来的：

- `稳定层、条件层与灰度层`

口径。

## 为什么这轮值得单独提交

### 判断一：`196` 的正文主语已经够硬，当前更明显的缺口只是尾部收束格式

`196`

前六层已经把关键 ownership 事实拆得很清楚：

- `pendingPermissionHandlers` 是本地 ledger
- `request_id` 是 permission race 的配对键
- `handlePermissionResponse(...)` 是 ledger drain 点
- `isBridgePermissionResponse(...)` 进一步收窄到 permission verdict payload

当前更值钱的，

不是再补更多 ledger 细节，

而是把它的尾部拉回统一的 stable / conditional / gray 口径。

### 判断二：这页最需要保护的是“本地 pending verdict ledger”与“非 generic registry”两句稳定结论

这页最容易重新塌掉的误判是：

- 只要带 `request_id` 的 `control_response`，都会走同一张通用 registry

所以这轮最该保住的是：

- permission leg 内部存在一张本地 pending verdict ledger
- 这张 ledger 不等于 generic control callback registry

最该降到条件或灰度层的则是：

- 某个 pending verdict 何时被 drain
- permission leg 是否会再分更多 subtype gate
- helper wiring 与 payload gate 的 exact 细节
- future branch / subtype 扩张

### 判断三：这轮继续贯彻“正文合同厚度优先于新增 hub”的目录策略

当前 permission tail 这簇已经连续几轮表明，

高 ROI 不在新增 README / hub，

而在：

- 把 root / branch / leaf page 的 stable / conditional / gray 收束逐步拉平

这轮对 `196` 的处理，

就是把这张 verdict ledger 根页补回当前统一的收束格式。

## 这轮具体怎么拆

这轮只做三件事：

1. 修改 `196-...verdict ledger.md`
   - 在第六层与结论之间新增 `稳定层、条件层与灰度层`
   - 补一句 stop line：结论必须停在本地 pending verdict ledger，不滑到 generic registry
   - 把结论开头改成“所以这页能安全落下的结论应停在”
2. 新增这条 `432` 记忆
   - 记录为什么这轮优先补 `196` 的 stable-gray 收束
3. 更新 `memory/05 README`
   - 把最新批次索引推进到 `432`

## 苏格拉底式自审

### 问：为什么这轮不是继续回到 `203`？

答：因为 `203` 的 skeleton、topology 与 trigger-vs-successor 护栏已经够硬；当前更不统一的，是 `196` 这种 root page 的尾部还没共享最近的 stable / conditional / gray 口径。

### 问：为什么这轮不是继续去补 `198/199/201/202`？

答：因为它们刚完成相应 hardening。当前 permission tail 相邻页里，`196` 是最明显仍停在旧式结论收束的根页。

### 问：为什么这也算“保护稳定功能和灰度功能”？

答：因为这轮正是在把 `196` 页里哪些 ledger ownership 结论可稳定依赖、哪些仍受 arrival timing 与 helper wiring 约束写成明确分层，避免把局部实现误抬成公开合同。
