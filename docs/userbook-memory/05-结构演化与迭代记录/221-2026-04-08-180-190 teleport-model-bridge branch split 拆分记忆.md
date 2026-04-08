# 180-190 teleport-model-bridge branch split 拆分记忆

## 本轮继续深入的核心判断

`180-190` 还不能被写成：

- 一条从 teleport、model 再走到 bridge write 的线性十一连

更准确的结构是三条后继线：

- `178 -> 179 -> 180` = teleport runtime branch
- model line
  - `178 -> 182` = ledger trunk
  - `184 -> 185 -> 187 -> 188` = selection / source / allowlist trunk
- bridge line
  - `176 -> 181 -> 183 -> 186 -> 189 -> 190` = outbound birth / hydrate / replay / write trunk
  - `190 -> 191 -> {192, 193 -> 206}` = post-connect ingress / control / blocked-state branch

所以这轮最该补的是：

- 在现有 `219` / `206` / `221` 三个结构面里把三条后继线钉死
- 不再额外增殖 model-only 范围页，避免把目录写成“model 另起一棵树”
- 只在总 README / 阅读路径 / `03-参考索引/README.md` 里补一条 model 深读导航

## 为什么 `180` 不该并进 model / bridge 主线

### 判断一：`180` 接的是 `179` 的 git-context 线

`180` 追的是：

- repo admission
- branch replay

为什么不是同一种 teleport contract。

它不是：

- session birth vs history hydrate

也不是：

- model ledger / authority / source

所以更稳的结构不是：

- `180 -> 181`

而是：

- `179 -> 180`

## 为什么 model 更稳是“ledger trunk + selection/allowlist trunk”

### 判断二：`182` 只负责 model ledger

`182` 先把：

- stamp
- shadow
- usage
- fallback

拆成不同 ledger。

### 判断三：`184 -> 185 -> 187 -> 188` 是另一条 selection / source / allowlist 线

`184` 先问 authority，
`185` 再问 startup source family，
`187` 再问 source selection 之后的 allowlist veto，
`188` 最后问 explicit rejection / option hiding / silent veto 的 surface split。

所以更稳的结构不是：

- `182 -> 184 -> 185 -> 187 -> 188`

作为同一条必须线性下钻的单 trunk，

而是：

- `182` = model ledger trunk
- `184 -> 185 -> 187 -> 188` = model selection / allowlist trunk

### 判断三点五：`184` 更稳是 resolution trunk，不是 `182` 的第二层细目

如果只按编号往下滑，

最容易把：

- `182` 的 stamp / shadow / usage / fallback
- `184` 的 preference / override / resumed fallback

写成同一个表。

但更稳的分法是：

- `182` 先问 model fact 有几张 ledger
- `184` 再问 runtime authority 怎么排序
- `185` 才追 authority 上游的 startup source family
- `187` 再追选定 candidate 之后的 allowlist admission
- `188` 最后追这些 admission 在不同 surface 上怎么显影

也就是说，

- `182` 不是 `184` 的前置页
- `184` 也不是 `182` 的细节附录

它们只是同属 model line，

但回答的是不同层的问题。

## 为什么 bridge 线更稳是“outbound trunk + post-190 descendants”

### 判断四：`181` 先问 create-time events 为什么不是 history hydrate

### 判断五：`183` 继续把初始历史账拆成 local seed 与 success ledger

### 判断六：`186` 再把 replay object 与 model prompt authority 拆开

### 判断七：`189` 与 `190` 是这条桥接线 outbound trunk 的后段，不是 183 的并列尾页

`189` 先追 continuity inheritance，
`190` 再追 REPL / daemon write contract。

所以更稳的结构不是：

- `183` 后面并列挂 `186/189/190`

而是：

- `181 -> 183 -> 186 -> 189 -> 190`

### 判断七点五：`190` 不是 bridge terminal，而是 outbound trunk tip

如果停在 `190`，

最容易再次把 bridge 写成：

- create / hydrate / replay / write

的自然终点。

但更稳的结构是：

- `190` 只把 outbound write contract 收口
- 后面立刻还会长出 `191` 的 ingress triage root
- 再分到 `192` 的 read-side continuity
- 以及 `193 -> 206` 的 control side-channel / blocked-state publish 问题

所以更稳的 bridge 句子已经不是：

- `181 -> 183 -> 186 -> 189 -> 190`

而是：

- `181 -> 183 -> 186 -> 189 -> 190`
- 然后再转入 `191 -> {192, 193 -> 206}`

## 本轮最关键的新判断

### 判断八：`180`、model 线、bridge 线共享一些 helper 名，但不共享同一个 runtime contract

更稳的顺序是：

1. 先问它属于哪条后继线
2. 再问它在这条线里是根页还是 zoom
3. 最后才看 shared helper / transport 是否带来 discoverability shortcut

这样才能避免把：

- `teleportToRemote`
- `model`
- `writeBatch`

写成一条编号尾巴。

## 为什么这轮不再新建独立 model branch map

### 判断九：model 深读仍应挂在 `180-190` branch map 下，而不是另起一张范围页

这轮继续深读之后更清楚的一点是：

- model line 的确需要更厚的 first-principles 解释

但它仍然属于：

- `180-190` 这张 teleport / model / bridge 的三股后继图

如果再新建一张 standalone model branch map，

目录上会马上制造两个坏信号：

1. 像是在暗示 `182/184/185/187/188` 已经脱离 `180-190` 主图
2. 像是在暗示 `183/186` 是 model 线中间“空出来”的缺页

这两种暗示都会让读者重新回到：

- 按编号线性推进

的误判里。

所以更稳的目录优化不是再加一页，

而是：

- 把 model 的 trunk / zoom / stable-vs-gray 纪律补进现有 `219`
- 把 quick index 的落笔纪律补进现有 `206`
- 把“为什么不另起一页”写进当前记忆

## 主树状态记录

本轮开始前已再次核对：

- `git fetch origin`
- `git rev-list --left-right --count HEAD...origin/main` = `26 0`

并确认：

- `/home/mo/m/projects/cc/analysis` 主树仍处于 `ahead 26`
- 同时仍存在未解决冲突

所以本轮继续只在：

- `.worktrees/userbook`

里推进，不触碰主树冲突面。

## 苏格拉底式自审

### 问：我现在写的是 teleport runtime、model，还是 bridge history/write？

答：如果一句话说不清自己属于哪条线，就不要落字。

### 问：我是不是因为几页都出现 `createBridgeSession`、`writeBatch`、`model`，就把它们混成同一条主线？

答：先分字段语义、runtime contract、ledger、write path，再看是否真的同根。

### 问：我是不是把 `189` 和 `190` 都写成 generic dedup 尾页？

答：先问当前句子在追 continuity inheritance，还是 write contract split。

### 问：我是不是把 `185/187/188` 只写成“模型设置细节”？

答：先分 startup source、admission veto 与 surface contract；这些不是同一层。
