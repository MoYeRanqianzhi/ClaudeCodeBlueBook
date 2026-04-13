# permission-closeout stable-gray hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `199` 的 permission reevaluation stable-gray
- `201` 的 sandbox host sweep stable-gray
- `202` 的 sandbox persist stable-gray
- `203` 的 trigger-vs-successor 护栏

逐步补平之后，

下一刀更值钱的，

不是继续扩目录入口，

而是回到：

- `198-cancelRequest、onResponse unsubscribe、pendingPermissionHandlers.delete 与 leader queue recheck：为什么 bridge permission race 的 prompt 撤场、订阅退役、响应消费与策略重判不是同一种收口合同.md`

把这张 permission closeout 页，

从旧式的“正文后直接收结论”，

补成最近已经稳定下来的：

- `稳定层、条件层与灰度层`

口径。

## 为什么这轮值得单独提交

### 判断一：`198` 的正文事实已经够硬，当前更明显的缺口只是尾部收束格式

`198`

前六层已经把关键 closeout 层拆得很清楚：

- `claim()` 只管 verdict ownership
- `cancelRequest(...)` 撤远端 stale prompt
- unsubscribe 退役本地 subscription
- `pendingPermissionHandlers.delete(...)` 负责 arrival-side consume
- leader queue recheck 关的是策略变化后的旧等待窗

所以现在更值钱的，

不是再补更多 race 事实，

而是把它的尾部拉回统一的 stable / conditional / gray 口径。

### 判断二：这页最需要保护的是“多层 closeout contract”与“非自动收完”两句稳定结论

这页最容易重新塌掉的误判是：

- 本地一旦赢了 verdict，其他 cleanup 就都自动做完

所以这轮最该保住的是：

- permission race 在 verdict 之后至少还有多层 closeout contract
- `claim()`、prompt 撤场、订阅退役、响应消费与策略重判不是同一种动作

最该降到条件或灰度层的则是：

- late response 最终会不会到场
- queue recheck 是否真的改写某个挂起 ask
- remote / inbox 是否会参与同一层重判
- helper 顺序与 race window 的 exact 实现

### 判断三：这轮继续贯彻“正文合同厚度优先于新增 hub”的目录策略

当前 permission tail 这簇已经连续多轮表明，

高 ROI 不在新增 README / hub，

而在：

- 把相邻 root / branch / leaf page 的收束口径逐步拉平

这轮对 `198` 的处理，

就是把 closeout 这条早期页补回当前统一的 stable / conditional / gray 格式。

## 这轮具体怎么拆

这轮只做三件事：

1. 修改 `198-...closeout contract.md`
   - 在第六层与结论之间新增 `稳定层、条件层与灰度层`
   - 补一句 stop line：结论必须停在多层 closeout contract，不滑到“本地胜出 = cleanup 自动做完”
   - 把结论开头改成“所以这页能安全落下的结论应停在”
2. 新增这条 `431` 记忆
   - 记录为什么这轮优先补 `198` 的 stable-gray 收束
3. 更新 `memory/05 README`
   - 把最新批次索引推进到 `431`

## 苏格拉底式自审

### 问：为什么这轮不是继续回到 `196`？

答：因为 `196` 虽也停在旧式结论收束，但当前 permission tail 相邻页里，`198` 与已经补过 stable-gray 的 `199/201/202` 形成了更直接的不一致，ROI 更高。

### 问：为什么这轮不是继续去改 `203`？

答：因为 `203` 的 skeleton、topology 与 trigger-vs-successor 护栏已经够硬；当前更落后的，是 `198` 这种早期 closeout 页尾部还没共享统一口径。

### 问：为什么这也算“保护稳定功能和灰度功能”？

答：因为这轮正是在把 `198` 页里哪些 closeout 结论可稳定依赖、哪些仍受 race timing 与 helper wiring 约束写成明确分层，避免把局部实现误抬成公开合同。
