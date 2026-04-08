# ingress and permission tail stable-gray hardening 拆分记忆

## 本轮继续深入的核心判断

在 `197` 和 `203` 这两个局部结构页之后，

下一步最该补的已经不是：

- 再新建一张 `191-202` 范围图
- 或再扩一个新的目录分支

而是把现有局部 anti-overlap map 里的：

- 稳定可见 effect
- 条件公开行为
- 内部账本 / cleanup 证据

分得更硬。

也就是说，这轮的目录优化不是继续增页，

而是：

- 继续让 `197` 负责 ingress 六层阅读链
- 继续让 `203` 负责 permission tail 四种后继问题
- 只补一条新的结构记忆，记录为什么这里不该再 proliferate

## 为什么 `197` 该补的是 stable-gray hardening，而不是新图

### 判断一：`197` 已经回答了“191-196 如何组织”，但还没把“哪些 effect 真能写成用户合同”钉死

这组页现在的结构问题已经解决：

- reader boundary
- continuity boundary
- control leg
- user leg
- normalization
- permission verdict ledger

都已收进一条六层阅读链。

真正还容易滑坡的是：

- 把 `recentInboundUUIDs`
- `extractInboundMessageFields(...)`
- `resolveAndPrepend(...)`

直接写成稳定能力名。

所以这轮更稳的做法不是再画一张新图，

而是补清：

- 用户真正可观察到的是 control side-channel、user-only transcript adapter、permission verdict 返回腿
- replay continuity、attachment materialization、remote prompt 往返都属于条件公开
- UUID 集、helper 顺序与前处理细节都只是内部证据

## 为什么 `203` 该补的是 stable-gray hardening，而不是新图

### 判断二：`203` 已经回答了“196 之后怎么分叉”，但还没把“哪些收口后果是用户真的能观察到的”钉死

这组页现在的结构问题也已经解决：

- `196` = verdict ledger 根页
- `198` = request-level closeout
- `199` = local re-evaluation
- `201` = host-level sibling sweep
- `202` = persist write-surface propagation

真正还容易滑坡的是：

- 把 `pendingPermissionHandlers`
- `sandboxBridgeCleanupRef`
- unsubscribe / delete 顺序

写成“permission tail 的稳定对象”。

所以这轮更稳的做法不是再画一张新图，

而是补清：

- 用户会观察到的是 prompt 收口、mode 改变后的重判、同 host 请求成组 settle、persist 后当前上下文和 live sandbox 立刻吃到新规则
- 这些行为都带有 leader / sandbox / persist 条件
- map、cleanup ref 与 helper 联动只保留在内部证据层

## 本轮最关键的新判断

### 判断三：`191-202` 这组现在缺的不是“树形结构”，而是“合同厚度”

前一阶段已经把：

- `197`
- `203`

立成两个局部结构页。

所以本轮如果再去新建一张新的范围页，

目录上只会制造新的歧义：

1. 像是在暗示 `197/203` 还不是真正的局部总图
2. 像是在暗示 `191-202` 还缺一层新的树形组织

但当前真正的空白并不在那里。

当前空白在于：

- 读者已经知道怎么读
- 但还不知道哪些 effect 可以写成稳定合同，哪些只能当内部实现证据

所以这轮继续深入必须收在：

- stable / conditional / internal 的硬分层

而不是：

- 新增 branch map

## 主树状态记录

本轮开始前已再次核对：

- `git fetch origin`
- `git rev-list --left-right --count HEAD...origin/main` = `28 0`

并确认：

- `/home/mo/m/projects/cc/analysis` 主树仍是 `ahead 28`
- `origin/main` 没有新的可拉取提交

所以本轮继续只在：

- `.worktrees/userbook`

里推进，不触碰主树。

## 苏格拉底式自审

### 问：我现在是在补树形，还是在补稳定 / 条件 / 灰度的厚度？

答：如果 `197/203` 的树形没有被推翻，就不要再靠新页解决旧页的合同厚度问题。

### 问：我是不是把“helper 很重要”误写成“helper 就是稳定合同”？

答：重要证据不等于公开合同；先看用户能观察到什么，再决定 helper 是否值得写进正文主句。

### 问：我是不是因为 `191-202` 这一段页数很多，就本能想再画一张更大的总图？

答：页数多不等于还缺树形；先问当前真正缺的是导航，还是边界厚度。
