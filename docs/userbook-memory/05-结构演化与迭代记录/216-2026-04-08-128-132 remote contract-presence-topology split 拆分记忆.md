# 128-132 remote contract-presence-topology split 拆分记忆

## 本轮继续深入的核心判断

`128-132` 还不能被写成：

- 一条从 `4001` 慢慢走到 bridge UI 更厚的线性 remote 五连页

更准确的结构是：

- `128/129` = transport contract / recovery ownership 这一段
- `130/131` = surface presence / status ledger 这一段
- `132` = front-state consumer topology 的后继根页

所以这轮最该补的是：

- 一张新的 `05` 结构页，把“两段延伸 + 一个后继根页”钉死
- 一张新的 `03` 结构索引，保护 `128/129`、`130/131`、`132` 的主语切换
- 一条新的持久化记忆，记录为什么 `132` 不能继续留在 sibling 队列里

## 为什么这轮要把 `132` 抬成后继根页

### 判断一：`130/131` 还在问 signer / writer，`132` 已经在问 consumer topology

`130` 问的是：

- 哪条 surface 在签 URL presence、attachment fact、bridge summary 或 brief projection

`131` 问的是：

- warning、`remoteConnectionStatus`、`remoteBackgroundTaskCount` 与 brief line 分别写进哪张账

到了 `132`，问题已经变成：

- 哪条链路真正消费 formal runtime state
- 哪条链路只有 partial shadow
- 哪条链路更多只是 event / transcript projection

这已经不是同层 sibling。

### 判断二：formal runtime state 先于前台 surface

本轮最值钱的根句是：

- `SessionState` / `SessionExternalMetadata` 更接近 formal runtime state 的定义面

因此更稳的阅读顺序必须是：

1. 先问 formal runtime state 在哪
2. 再问本地有没有 shadow
3. 再问 transcript / footer / dialog / brief 怎么消费它

如果反过来从 surface 开始，

就很容易把：

- same wording
- same remote feel

误写成 same authoritative state。

### 判断三：bridge 的价值不在“多几个控件”，而在“多前台面共享同一批 shadow”

本轮最该保护的一句不是：

- bridge 看起来更完整

而是：

- bridge 当前更接近 authoritative state upload + local shadow + transcript / footer / dialog alignment

这也是为什么 `132` 必须抬成后继根：

- 它解决的是 consumer topology

不是：

- remote UI 厚薄比较

## 为什么这轮值得小幅更新 `04-专题深潜/23`

这轮值得下沉到症状页的，不是 `128/129` 的 transport 合同细节，

而是用户真会卡住的这类前台误判：

- footer 里还有 `remote`，但 brief line 已经写 `Reconnecting…` / `Disconnected`
- attached viewer 会显示 `Reconnecting…` 或 `N in background`，却没有 warning transcript、`/session` 或 footer `remote`
- bridge pill 消失了，却不能直接推出 bridge 不存在
- bridge 看起来只是比 remote session 多一个 dialog，但体感上像一套更完整的远端控制面

所以 `04` 只补：

- “这些前台信号不是同一种存在面 / 状态面”

而不把：

- `4001/4003`
- `headersRefreshed`
- sleep detection
- `reportState/reportMetadata`

这些结构证明一股脑拖进专题页。

## 本轮最关键的新判断

### 判断四：surface presence、status ledger 与 consumer topology 必须分三层

更稳的顺序是：

1. 先分 presence signer
2. 再分 ledger writer
3. 最后再分 consumer topology

这样才能避免把：

- `remoteSessionUrl`
- warning transcript
- brief line
- bridge dialog
- `worker_status`

写成一张 remote status 总表。

### 判断五：absence 仍然不能越层给 authority 签字

这一轮继续要保护的句子是：

- surface 缺席，不等于 contract / presence / runtime authority 缺席

尤其是：

- footer `remote` 的 lazy capture
- brief line 的 gate
- bridge pill 的 render condition

都只能当实现证据，

不能直接升级成稳定公共合同。

### 判断六：本轮起笔前的主工作树状态已再次确认

本轮开始前已核对：

- `git fetch origin`
- `git rev-list --left-right --count HEAD...origin/main` = `0 0`
- `/home/mo/m/projects/cc/analysis` 上 `merge --ff-only origin/main` = `Already up to date.`
- 主树 `status` 仍是 `## main...origin/main`
- `userbook` worktree 起笔时为 `## userbook`

所以本轮继续只在：

- `.worktrees/userbook`

里推进，不触碰主树与其他 worktree。

## 苏格拉底式自审

### 问：我现在还在 signer / writer 层，还是已经换到 consumer topology？

答：如果一句话还在比 surface 长得像不像，就还没真正进入 `132`。

### 问：我是不是把 bridge 写成了“只是 UI 更厚”？

答：先追问它有没有 shared shadow，以及这些 shadow 被哪些前台面共同消费。

### 问：我是不是把 warning、brief、remote pill 写成了一张表？

答：先问它们分别写进 transcript、`AppState`，还是只做 summary。

### 问：我是不是想把 `128/129` 一起下沉到 04？

答：如果一句话离不开 close code、refresh、sleep、recovery ownership，它就还在 05 结构层，不该提前污染症状页。
