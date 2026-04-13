# sandbox-host-sweep stable-gray hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `199` 的 permission reevaluation stable-gray
- `202` 的 sandbox persist stable-gray
- `203` 的 trigger-vs-successor 护栏

逐步补平之后，

下一刀更值钱的，

不是继续扩目录入口，

而是回到：

- `201-hostPattern.host、sandboxBridgeCleanupRef、sandboxPermissionRequestQueue filter、onResponse unsubscribe 与 cancelRequest：为什么 sandbox network bridge 的同 host sibling cleanup 不是同一种 tool-level permission closeout.md`

把这张 sandbox host sibling sweep 页，

从旧式的“正文后直接收结论”，

补成最近已经稳定下来的：

- `稳定层、条件层与灰度层`

口径。

## 为什么这轮值得单独提交

### 判断一：`201` 的正文主语已经够硬，当前真正落后的只是尾部收束格式

`201`

前五层已经把关键事实拆得足够清楚：

- `SandboxNetworkAccess` 是 transport shell
- queue settle 主语是 `hostPattern.host`
- `sandboxBridgeCleanupRef` 是 host-keyed cleanup map
- 本地与远端 verdict 都会打到同一 host sweep

当前更明显的缺口，

不是再补更多 sibling cleanup 细节，

而是它的尾部还停在较旧的“直接结论”写法。

### 判断二：这页最需要保护的是“host-level sibling sweep”与“非 tool-level closeout 放大版”两句稳定结论

这页最容易重新塌掉的误判是：

- approve/deny 一次 host verdict，不过是顺手多清了几条 request cleanup

所以这轮最该保住的是：

- sandbox network bridge 里存在一条 host-level sibling sweep 合同
- 这条合同不等于 tool-level closeout 的放大版

最该降到条件或灰度层的则是：

- 当前 queue 里同 host 挂起项的分布
- `sandboxBridgeCleanupRef` 的按 host 聚合登记情况
- filter / cleanup wiring 与 helper 顺序
- future build 是否会再细分 transport shell / cleanup map

### 判断三：这轮继续贯彻“正文合同厚度优先于新增 hub”的目录策略

当前 permission tail 这簇已经连续几轮表明，

高 ROI 不在新增 README/hub，

而在：

- 把相邻 leaf / branch page 的稳定层、条件层与灰度层口径逐步拉平

这轮对 `201` 的处理，

正是在把这条 host sweep 线补回统一的收束格式。

## 这轮具体怎么拆

这轮只做三件事：

1. 修改 `201-...sibling cleanup.md`
   - 在正文与结论之间新增 `稳定层、条件层与灰度层`
   - 补一句 stop line：结论必须停在 host-level sibling sweep，不滑到 tool-level closeout 放大版
   - 把结论开头改成“所以这页能安全落下的结论应停在”
2. 新增这条 `430` 记忆
   - 记录为什么这轮优先补 `201` 的 stable-gray 收束
3. 更新 `memory/05 README`
   - 把最新批次索引推进到 `430`

## 苏格拉底式自审

### 问：为什么这轮不是继续回到 `203`？

答：因为 `203` 的 skeleton、topology 与 trigger-vs-successor 护栏已经够硬；当前更不统一的，是 `201` 尾部还没共享最近的 stable / conditional / gray 口径。

### 问：为什么这轮不是继续去改 `202` 或 `199`？

答：因为它们刚完成相应 hardening。当前 permission tail 相邻页里，`201` 是最明显仍停在旧式结论收束的那一页。

### 问：为什么这也算“保护稳定功能和灰度功能”？

答：因为这轮正是在把 `201` 页里哪些结论可稳定依赖、哪些仍受 queue 分布与 cleanup wiring 约束写成明确分层，避免把局部实现误抬成公开合同。
