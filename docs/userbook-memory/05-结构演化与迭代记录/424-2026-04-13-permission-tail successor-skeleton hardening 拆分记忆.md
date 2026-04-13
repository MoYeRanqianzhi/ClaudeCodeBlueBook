# permission-tail successor-skeleton hardening 拆分记忆

## 本轮继续深入的核心判断

在当前 worktree 已经把：

- `193`

这类 control-side-channel 根页继续拉回成熟口径之后，

下一刀更值钱的，

不是回头给 permission tail 再补 leaf 证据，

而是回到：

- `203-pendingPermissionHandlers、cancelRequest、recheckPermission、hostPattern.host 与 applyPermissionUpdate：为什么 permission tail 的 196、198、199、201、202 不是并列尾页，而是从 verdict ledger 分叉出去的四种后继问题.md`

把这张 permission-tail 分叉图页，

更明确地定型成：

- successor skeleton / anti-overlap map

而不是一页把 `196/198/199/201/202` 重新总述一遍的 leaf-proof 摘要。

## 为什么这轮值得单独提交

### 判断一：`203` 当前缺的不是事实，而是把“稳定的是阅读骨架”先说死

`203`

正文已经足够清楚地拆出了：

- `196` = verdict ledger 根页
- `198` = request-level closeout
- `199` = leader-local re-evaluation
- `201` = sandbox-network host-level sibling sweep
- `202` = persist write-surface propagation

但它页首那句总括，

仍然同时承担：

- 不重讲 leaf proof
- helper 降权
- 结构分叉
- 三层分级

四件事，

导致范围声明虽然对，

却还不够硬。

这轮真正补的，

不是新证据，

而是把：

- `196 -> 198 / 199 / 201 / 202`

这张分叉骨架先钉成稳定对象。

### 判断二：`203` 更像结构页，不该继续沿用 leaf-root 的“稳定 / 条件 / 灰度保护”尾部

这页在正文里已经把自己定义成：

- 局部 anti-overlap map

它要守住的，

不是哪几个 helper 已经变成稳定公开能力，

而是：

- 哪一页还是根页
- 哪几页已经换成不同后继问题

因此这轮更合适的尾部口径不是继续写：

- 稳定可见
- 条件公开
- 内部/灰度层

而是写成：

- `稳定阅读骨架 / 条件公开 / 内部证据层`

把“稳定”限定在阅读骨架本身。

### 判断三：最该加固的是 scope guard，不是再补一轮相邻页摘要

这轮继续深挖后确认，

`203` 的真正风险点在：

- 会不会回退成 `197`
- 会不会回退成 `20`
- 会不会回退成 `00-阅读路径.md`

也就是把：

- ingress 六层链条
- 用户目标层分工
- 阅读入口清单

重新写进 permission tail 子系统内部。

因此这轮最小但高价值的改法是：

- 把“不是 197 / 不是 20 / 不是 `00-阅读路径.md`”
- 收紧成“只处理 permission tail 子系统内的后继分叉，不回退到 ingress 链、用户目标层或阅读入口层”

从位阶上先挡住结构漂移。

## 这轮具体怎么拆

这轮只做三件事：

1. 修改 `203-...四种后继问题.md`
   - 把页首过重的总括拆成更硬的范围声明
   - 把第六层改成更明确的 scope guard
   - 把尾部改成 `稳定阅读骨架 / 条件公开 / 内部证据层`
   - 并补一句 stop line：结论应停在 `196` 是根页、`198/199/201/202` 是四种不同后继问题
2. 新增这条 `424` 记忆
   - 记录为什么这轮优先把 `203` 定型成 successor skeleton，而不是补 leaf 证据或再扩入口
3. 更新 `memory/05 README`
   - 把最新批次索引推进到 `424`

## 苏格拉底式自审

### 问：为什么这轮不是回去继续补 `196/198/199/201/202` 的页内证明？

答：因为这些 leaf 页已经能各自成立。当前更容易塌的是读者把五页重新听成并列尾页，所以该补的是分叉骨架，不是 leaf proof。

### 问：为什么这轮不只是把旧标题换成“稳定层、条件层与灰度层”？

答：因为 `203` 不是普通 leaf-root。它是结构页；更该保护的是阅读骨架，而不是把局部 helper 提升成稳定公开能力。

### 问：为什么这也算“优化相关目录结构”？

答：因为当前更值钱的结构优化不在新增 README/hub，而在让结构页自己把位阶守住：入口层、用户目标层、局部后继骨架层各自分工，不再串层。
