# remote-control 批准对象与提示收口拆分记忆

## 本轮继续深入的核心判断

第 29 页已经拆开：

- 单次权限提示
- session control request
- bridge-safe commands
- viewerOnly

第 39 页已经拆开：

- host flags
- initial session seed
- child runtime constraint
- title fallback

但 remote-control 仍缺一层非常容易继续混写的批准运行时语义：

- 真实工具调用的 `can_use_tool`
- sandbox network ask 的 `SandboxNetworkAccess`
- bridge / channel / hook / classifier 的多方竞态
- `cancelRequest(...)`
- `control_cancel_request`

如果不单独补这一批，正文会继续犯七种错：

- 把 `can_use_tool` 写成只服务真实工具
- 把 network ask 写成普通工具审批
- 把 remote-control 写成唯一批准者
- 把 hook / classifier 写成只是“预检查”，而不是可能赢下竞态的批准者
- 把 `cancelRequest` 写成 deny
- 把 `control_cancel_request` 写成用户点击拒绝
- 把批准竞态和 session control request 重新压回同一层

## 苏格拉底式自审

### 问：为什么这批不能塞回第 29 页？

答：第 29 页解决的是：

- permission callback
- session control
- command contract

也就是：

- 远端到底在控制哪类对象

而本轮问题已经换成：

- 在权限提示内部，到底是谁在竞争给结论
- 这些结论如何收掉输掉的一侧 prompt
- 同样的 `can_use_tool` 为什么既能承载真实工具，也能承载 sandbox network ask

也就是从：

- control object partition

继续下钻到：

- approval race and teardown

所以需要新起一页。

### 问：为什么这批也不能塞回第 39 页？

答：第 39 页解决的是：

- standalone host flags 继承到哪一层对象

而本轮更偏：

- 会话在运行时怎样做 allow / deny / cancel

也就是：

- host configuration inheritance

之后的：

- runtime approval competition

所以不能再混回 39。

### 问：为什么不能把它写成“sandbox 补充说明”？

答：因为真正需要拆开的不是：

- sandbox 单独有什么提示

而是：

- 真实工具审批与 sandbox network ask 共用同一协议，却不是同一对象
- 自动批准和提示撤销都不能被写成 deny

如果只写 sandbox 补充，`claim()` 与双向 cancel 的骨架会继续丢失。

### 问：这批最该防的偷换是什么？

答：

- 协议相同 = 批准对象相同
- remote-control 在场 = 远端独占批准权
- prompt 消失 = 用户拒绝
- auto-approve = 从来没有 prompt
- `control_request` = 都是 session control

只要这五组没拆开，remote-control 的批准正文就还会继续糊。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/40-can_use_tool、SandboxNetworkAccess、hook-classifier 与 control_cancel_request：为什么 remote-control 的工具审批、网络放行、自动批准与提示撤销不是同一种批准.md`
- `bluebook/userbook/03-参考索引/02-能力边界/29-Remote Control 工具审批、网络放行、自动批准与提示撤销索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/40-2026-04-06-remote-control 批准对象与提示收口拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- 真实工具审批与 sandbox network ask 共用协议，但对象不同
- bridge 只是批准竞态中的一方，不是唯一批准者
- 本地 UI、channel、hook、classifier 都可能先赢
- `cancelRequest` / `control_cancel_request` 是 prompt teardown，不是 deny
- session control request 应与本页显式切边

### 不应写进正文的

- `resolvedToolUseIds` 的去重细节
- abort signal 的 listener 清理
- `requiresUserInteraction` 工具在 channel 分支里的死代码语义
- prompt 消失时 UI 的全部过渡动画
- `sdkPromise.catch(() => {})` 这类防噪实现

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `can_use_tool` 本身不是“真实工具专属协议”

`structuredIO.ts` 直接把：

- `SandboxNetworkAccess`

映射成一个 synthetic tool name，并继续走：

- `subtype: 'can_use_tool'`

所以正文必须写“同协议、不同批准对象”，不能偷写成“又一个工具”。

### `claim()` 才是整条批准面的第一性原理骨架

`PermissionContext.ts` 的 `claim()` 不是小实现细节，而是：

- 多方竞态谁先赢谁生效

的原子骨架。

如果记忆里不持续提醒这一点，正文就会滑回：

- 远端先问
- 本地再问
- hook 最后补

这种错误的串行叙事。

### `cancelRequest` 与 `control_cancel_request` 正好构成双向收口

- 本地 / hook / classifier 赢时，取消 bridge prompt
- bridge 赢时，反向 abort SDK consumer

这组对照是正文最值得保留的第一性原理骨架之一。

### 第 29 页只够做边界，不够解释 prompt lifecycle

第 29 页已经足够告诉读者：

- 单次权限提示
- session control request
- command whitelist

不是同一种合同。

但它并不解释：

- 谁先赢
- 输家 prompt 怎样收掉
- 为什么网络 ask 也能长得像 `can_use_tool`

因此本轮必须独立成页。

## 并行 agent 结果

本轮并行 agent 返回不稳定，有部分结果仍停留在旧批次主题。

因此本轮正文判断以主线本地源码复核为准，agent 结果只保留为：

- 后续继续扩展时可再复核的旁证来源

而不直接回灌正文。

## 后续继续深入时的检查问题

1. 我当前讲的是批准对象，还是批准者？
2. 我当前讲的是 allow / deny，还是 stale prompt teardown？
3. 我是不是又把共享协议写成了共享对象？
4. 我是不是又把远端写成唯一批准源？
5. 我是不是又把 session control 混回权限竞态正文？

只要这五问没先答清，下一页继续深入就会重新滑回：

- 批准面混写
- 或内部实现细节污染正文

而不是用户真正可用的 remote-control 批准语义正文。
