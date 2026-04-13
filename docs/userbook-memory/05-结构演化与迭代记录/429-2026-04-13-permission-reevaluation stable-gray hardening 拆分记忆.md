# permission-reevaluation stable-gray hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `203` 的 trigger-vs-successor 护栏
- `202` 的 sandbox persist stable-gray
- `199/201` 的 leaf-entry anti-linearity

逐步补平之后，

下一刀更值钱的，

不是继续改目录入口，

而是回到：

- `199-onSetPermissionMode、getLeaderToolUseConfirmQueue、recheckPermission、useRemoteSession 与 useInboxPoller：为什么 permission context 变更后的本地重判广播不是同一种 permission re-evaluation surface.md`

把这张 permission re-evaluation 页，

从旧式的“直接收结论”，

补成最近已经稳定下来的：

- `稳定层、条件层与灰度层`

口径。

## 为什么这轮值得单独提交

### 判断一：`199` 的正文主语已经够硬，真正缺的是 stable / conditional / gray 的停线

`199`

前六层已经把核心事实拆得很清楚：

- `onSetPermissionMode(...)` 改的是本地 permission context
- leader queue fanout 只触达本地 ask
- local `recheckPermission()` 是实义路径
- remote / worker `recheckPermission()` 是 no-op

当前更明显的缺口，

不是再补更多 queue 细节，

而是它的尾部还停在较旧的“结论直收”写法。

### 判断二：这页最需要保护的是“leader-local fanout surface”与“非 generic bus”两句稳定结论

这页最容易重新塌掉的误判是：

- 只要 permission context 变了，所有 pending ask 都会统一重判

所以这轮最该保住的是：

- leader-local permission context change 会形成一条本地 re-evaluation fanout surface
- 这条 surface 不等于 generic permission reevaluation bus

最该降到条件或灰度层的则是：

- 还有哪些 trigger 能打到同一 surface
- 哪些 ask 真会收到 recheck
- remote / worker 未来是否可能引入实义重判
- `setImmediate(...)`、queue wiring 与 no-op helper 的 exact 实现

### 判断三：这轮继续贯彻“正文合同厚度优先于新增 hub”的目录策略

当前 permission tail 的总图、页首反线性护栏和 sandbox persist 尾部都已经补过。

继续裂 README / hub 的收益，

低于把 `199`

这种仍停在旧式结论收束的叶页，

拉回统一的 stable / conditional / gray 口径。

## 这轮具体怎么拆

这轮只做三件事：

1. 修改 `199-...re-evaluation surface.md`
   - 在第六层与结论之间新增 `稳定层、条件层与灰度层`
   - 补一句 stop line：结论必须停在 leader-local fanout surface，不滑到 generic bus
   - 把结论开头改成“所以这页能安全落下的结论应停在”
2. 新增这条 `429` 记忆
   - 记录为什么这轮优先补 `199` 尾部口径
3. 更新 `memory/05 README`
   - 把最新批次索引推进到 `429`

## 苏格拉底式自审

### 问：为什么这轮不是继续回到 `203`？

答：因为 `203` 的 skeleton、topology 和 trigger-vs-successor 护栏已经够硬；当前更落后的，反而是 `199` 尾部还没共享最近统一的 stable / conditional / gray 口径。

### 问：为什么这轮不是继续去改 `201`？

答：因为 `201` 的正文和结论已经足够短硬，且当前更突出的不统一点是在 `199` 的尾部缺少成熟收束格式。

### 问：为什么这也算“保护稳定功能和灰度功能”？

答：因为这轮正是在把 `199` 页里哪些结论可稳定依赖、哪些仍受宿主和实现细节约束写成明确分层，避免把局部实现误抬成公开合同。
