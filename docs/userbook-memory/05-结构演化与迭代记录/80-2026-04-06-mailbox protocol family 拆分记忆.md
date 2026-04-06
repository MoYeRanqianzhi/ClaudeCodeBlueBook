# mailbox protocol family 拆分记忆

## 本轮继续深入的核心判断

74-79 已经把 approval shell 和 authority map 拆得足够细了。

下一步如果还想继续稳定扩展，就不该再停留在：

- shell / queue / callback

而该往下一层走到：

- mailbox message family

否则 77/78 这两页虽然已经拆开 worker tool ask 和 worker sandbox ask，但读者仍会在 transport 层把它们重新合并成：

- “发给 leader 的结构化审批消息”

## 为什么这轮不再继续写新的 shell 页面

继续写新的 shell 页面当然还能补：

- shutdown 请求
- plan approval UI
- inbox unread 分类

但现在更缺的是：

- 协议族层面的总边界

而不是新的 UI 外观细节。

## 本轮最关键的新判断

### 判断一：`permission_request` 族在镜像 SDK tool control continuation

这族消息最靠近：

- `can_use_tool`
- `updated_input`
- `permission_updates`

所以它不是普通 approval request，而是：

- tool continuation family

### 判断二：`sandbox_permission_request` 族是 host approval 最小协议

它没有：

- `tool_use_id`
- `permission_updates`

只带：

- host
- allow

因此它不是精简版 permission_request，而是另一族：

- host approval family

### 判断三：`plan_approval_request` 族已经跳到 workflow transition

它带的是：

- `planFilePath`
- `planContent`
- `permissionMode`

leader 侧默认 auto-approve，所以这族消息的核心不是 queue-based approval，而是：

- plan workflow transition

## 苏格拉底式自审

### 问：为什么这轮不把 `shutdown_request` 一起并进去？

答：因为 `shutdown_request` 虽然也走 mailbox，但它更像：

- lifecycle termination family

把它和 approval-adjacent 三族混在一起，只会重新失焦。

### 问：为什么这轮既写长文又写索引？

答：长文负责回答：

- 为什么 transport 一样却不是同一协议族

索引负责回答：

- 我现在该去哪一页看哪个协议

两者作用不同。

### 问：为什么这轮应该接在 79 后面？

答：因为 79 已经把 approval shell 压到同一张主权图里，80 正好再把这张图往下一层压到：

- mailbox protocol family

这是自然的向下收束，而不是横向跳题。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/80-teammateMailbox、permission_request、sandbox_permission_request 与 plan_approval_request：为什么 swarms 的结构化邮箱消息不是同一种协议族.md`
- `bluebook/userbook/03-参考索引/02-能力边界/69-Mailbox permission_request、sandbox_permission_request 与 plan_approval_request protocol family 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/80-2026-04-06-mailbox protocol family 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小改动：

- 只在 68-80 连续链末端补协议族页
- 索引层只补一张 69

不去改与 approval shell 主链无关的其它目录。

## 下一轮候选

1. 单独拆 `shutdown_request` / `shutdown_approved` / `shutdown_rejected` 生命周期消息族。
2. 把 inbox unread 分类、mark-read、regular pass-through 压成一页消息路由层专题。
3. 回到 79，再上收一张 approval shell vs mailbox protocol 双层导航图。
