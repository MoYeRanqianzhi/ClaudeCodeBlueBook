# ingress-reading-chain skeleton hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `196` 的 permission ledger stable-gray
- `198` 的 permission closeout stable-gray
- `199` 的 permission reevaluation stable-gray
- `201` 的 sandbox host sweep stable-gray
- `202` 的 sandbox persist stable-gray
- `203` 的 trigger-vs-successor 护栏

逐步补平之后，

同家族里仍然更值钱的一刀，

不是继续补运行时事实，

而是回到：

- `197-handleIngressMessage、recentInboundUUIDs、onPermissionResponse、extractInboundMessageFields、resolveAndPrepend 与 pendingPermissionHandlers：为什么 bridge ingress 的 191-196 不是并列碎页，而是一条六层阅读链.md`

把这张局部阅读骨架页，

从旧式的：

- `稳定 / 条件 / 灰度保护`

拉回到最近已经稳定下来的结构页口径：

- `稳定阅读骨架 / 条件公开 / 内部证据层`

## 为什么这轮值得单独提交

### 判断一：`197` 是结构页，不该继续沿用 runtime-leaf 页的尾部语言

`197`

真正要保护的不是某个 helper 或某条 effect，

而是：

- `191-196` 这条 bridge ingress 阅读链的走法

它更像：

- `203`
- `218`
- `219`

这类 anti-overlap / skeleton 页，

不该继续停在：

- 稳定可见 / 条件公开 / 内部灰度

这种更偏 runtime leaf 的收束格式。

### 判断二：当前最该保住的是“有顺序的阅读骨架”，不是“中间节点名已经变成稳定公开能力”

`197`

已经把六层拆清了：

- `191` reader boundary
- `192` continuity boundary
- `193 -> 196` control / permission leg
- `194 -> 195` user leg / normalization

这轮真正该补的，

不是再讲这些层里发生了什么，

而是明确写出：

- 稳定的是这条阅读骨架本身
- 不稳定或不该升级的是各层里的 helper 名、reader 账本与条件化运行时表现

### 判断三：这轮继续贯彻“正文合同厚度优先于新增 hub”的目录策略

这张页本来就是：

- 局部 anti-overlap map

所以结构优化不在继续加 README / hub，

而在让它自己的尾部语言和同类结构页共享同一套术语，

避免结构页与事实页的收束口径再次漂移。

## 这轮具体怎么拆

这轮只做三件事：

1. 修改 `197-...六层阅读链.md`
   - 把旧式 `稳定 / 条件 / 灰度保护`
   - 改成 `稳定阅读骨架 / 条件公开 / 内部证据层`
   - 补一句 stop line：结论必须停在“有顺序的阅读骨架”，不滑到“六篇并列碎页”
   - 把结论开头改成“所以这页能安全落下的结论应停在”
2. 新增这条 `433` 记忆
   - 记录为什么这轮优先补 `197` 的 skeleton 收束
3. 更新 `memory/05 README`
   - 把最新批次索引推进到 `433`

## 苏格拉底式自审

### 问：为什么这轮不是继续回到 `191/192`？

答：因为 `191/192` 虽可能还有旧口径痕迹，但当前更不统一的，是 `197` 这种结构页还保留着 runtime-leaf 风格的尾部标题。

### 问：为什么这轮不是继续去改 `203`？

答：因为 `203` 已经共享了结构页口径。当前更落后的，是同类结构页 `197` 自己还没被拉平。

### 问：为什么这也算“优化相关目录结构”？

答：因为 `197` 本身就在承担第二层导航与 anti-overlap map 的结构职责；把它的尾部语言拉回 skeleton 页统一口径，本身就在降低目录系统里的结构表述漂移。
