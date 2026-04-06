# remote bridge control handoff semantics 拆分记忆

## 本轮继续深入的核心判断

第 29 页已经拆开：

- control object 分类
- safe command 与 session control

第 40 页已经拆开：

- `can_use_tool`
- 竞态批准
- `control_cancel_request` 不是 deny

第 51 页已经拆开：

- `worker_status`
- `requires_action_details`
- `pending_action`
- 运行态投影面

第 54 页已经拆开：

- transport continuity
- recovery 窗口

但还缺一层很容易继续混写的“这组 control / result 动作驱动 state handoff”：

- `initialize`
- `can_use_tool`
- `control_response`
- `control_cancel_request`
- `result`

如果不单独补这一批，正文会继续犯六种错：

- 把 handshake 写成批准
- 把 pending ask 写成被动通知
- 把 `control_response` 写成 prompt teardown
- 把 `control_cancel_request` 写成 deny
- 把 `result` 写成另一种 control reply
- 把 truthful error 与 recovery drop 混成“控制失败”

## 苏格拉底式自审

### 问：为什么这批不能塞回第 29 页？

答：第 29 页回答的是：

- control object 有哪些
- safe commands 和 session control 怎样分类

而本轮问题已经换成：

- 哪一种动作负责把远端从 `requires_action` 拉回 `running`
- 哪一种动作才把整轮落回 `idle`

也就是：

- phase-driving control handoff

不是：

- control object taxonomy

### 问：为什么这批不能塞回第 40 页？

答：第 40 页回答的是：

- 批准竞态如何发生
- `control_cancel_request` 为什么不是 deny

而本轮问题已经换成：

- `control_response`、`control_cancel_request` 与 `result` 分别在 state handoff 里负责什么

也就是：

- control action roles in phase handoff

不是：

- permission race semantics

### 问：为什么这批不能塞回第 51 页？

答：第 51 页回答的是：

- 远端看到哪些 phase / pending_action / summary 投影面

而本轮问题已经换成：

- 哪一种 control/result 动作驱动这些 phase 改变

也就是：

- state drivers

不是：

- state projection surfaces

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/56-initialize、can_use_tool、control_response、control_cancel_request 与 result：为什么 remote bridge 的握手、提问、作答、撤销与回合收口不是同一种状态交接.md`
- `bluebook/userbook/03-参考索引/02-能力边界/45-Remote Control can_use_tool、control_response、control_cancel_request、result 与 state handoff 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/56-2026-04-06-remote bridge control handoff semantics 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `initialize` 是握手，不是批准
- `can_use_tool` 是 pending ask，并驱动 `requires_action`
- `control_response` 与 `control_cancel_request` 都会把 phase 拉回 `running`，但语义不同
- `result` 才把整轮落到 `idle`
- outbound-only / unsupported subtype 必须 truthful error
- recovery 窗口里这组 control / result 动作会被故意 drop

### 不应写进正文的

- page 29 已经写过的 subtype 全量分类
- page 40 已经写过的竞态来源细节
- callback wiring 与 pendingRequests 容器实现

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### handshake / ask / answer / cancel / result 五分法是本批第一根骨架

没有这根骨架，正文就会重新把：

- 所有 control message

压成：

- 一种“远端回复”

### `running` 与 `idle` 的不同返回路径是本批第二根骨架

没有这根骨架，正文就会把：

- `control_response`
- `control_cancel_request`
- `result`

写成同一种收口。

### truthful error 是本批第三根骨架

没有这根骨架，正文就会把：

- 不支持这个动作
- 暂时不能做这个动作

都写成“远端已经处理成功”。

## 后续继续深入时的检查问题

1. 我当前讲的是 control taxonomy，还是 phase-driving handoff？
2. 我是不是又把 handshake 写成批准？
3. 我是不是又把 cancel 写成 deny？
4. 我是不是又把 result 写成另一种 response？
5. 我是不是又把 truthful error 与 recovery drop 混成一类失败？
6. 我是不是又把正文滑回第 29/40/51 页的旧边界？

只要这六问没先答清，下一页继续深入就会重新滑回：

- control object 分类学
- 或运行态投影复述

而不是用户真正可用的 remote bridge state handoff 正文。
