# remote approval shell vs authority 拆分记忆

## 本轮继续深入的核心判断

第 73 页已经拆开：

- remote session 的本地 tool plane 主权在本地
- 远端更多是在喂 permission-context 输入

但还缺一个更容易误判的局部：

- `can_use_tool` 进入本地 queue 以后
- 不等于本地权限引擎接管

如果不单独补这一批，正文还会继续犯五种错：

- 把 remote `ToolUseConfirm` 写成本地权限链的一部分
- 把 queue item 的存在写成本地主权接管
- 漏掉 `createToolStub(...)` / synthetic message 只是 UI 适配壳
- 漏掉 remote `recheckPermission()` 明确 no-op
- 漏掉 remote `onUserInteraction()` 也是 no-op，classifier 明确还在 container
- 漏掉最终响应其实回到 `manager.respondToPermissionRequest(...)`

## 本轮最关键的源码纠偏

### 纠偏一：remote ask 借的是 queue/UI，没借走本地治理闭环

最关键的新事实不是“它也有 ToolUseConfirm”，而是：

- local `useCanUseTool(...)` 会建 `PermissionContext`
- remote `useRemoteSession.onPermissionRequest(...)` 不会

这说明两边虽然 UI 形状一致，但治理闭环不同。

### 纠偏二：`recheckPermission()` 的 no-op 是这批最强证据

本地路径里：

- `setToolPermissionContext()` 会触发 queue item 重检

remote 路径里：

- `recheckPermission()` 直接 no-op

这几乎把“queue reuse != governance reuse”写成了源码注释。

### 纠偏三：`onUserInteraction()` 也在提醒这只是交互壳复用

remote 路径里：

- `onUserInteraction()` 直接 no-op
- 注释明确 classifier runs on the container

这说明不仅最终重判不在本地，连交互前后的 classifier/治理前置链也没有搬到本地。

### 纠偏四：最终按钮动作只是把结果送回远端

远端 ask 在本地允许 / 拒绝 / 中止之后，最关键动作不是本地继续执行，而是：

- `manager.respondToPermissionRequest(...)`

这再次说明最终主权闭环不在本地。

## 苏格拉底式自审

### 问：为什么这批不能塞回第 73 页？

答：第 73 页回答的是：

- 本地 tool plane 的主权来源

本轮问题已经换成：

- 远端审批请求与本地 queue/UI 的边界

也就是：

- approval shell vs authority

不是：

- tool plane authority inputs

### 问：为什么这批必须单写？

答：因为用户在界面上首先看到的是一个 PermissionRequest 弹层，这很容易让人下意识以为“本地权限系统接手了”。这是一个非常具体、非常高频的误判，值得单独拆页。

### 问：为什么必须把 `createToolStub(...)` 写进去？

答：因为这能更强地证明 queue item 只是一个 UI 适配壳，而不是本地真实工具生命周期对象。没有这个点，正文对“壳层”二字会显得证据不足。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/74-can_use_tool、ToolUseConfirm、createToolStub、recheckPermission 与 manager.respondToPermissionRequest：为什么 remote session 的远端工具审批会借用本地权限队列 UI，却不会直接接管本地 tool plane.md`
- `bluebook/userbook/03-参考索引/02-能力边界/63-Remote can_use_tool、toolUseConfirmQueue 与 local approval shell 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/74-2026-04-06-remote approval shell vs authority 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `onPermissionRequest` 如何构造 remote `ToolUseConfirm`
- `createToolStub(...)` / synthetic message 的 UI 适配作用
- `onAllow` / `onReject` / `onAbort` 如何回发远端
- `recheckPermission()` no-op 与本地 queue recheck 的差异
- 为什么 queue reuse 不等于 governance reuse

### 不应写进正文的

- 第 73 页关于本地 tool plane 主权来源的整段复述
- direct connect / bridge 的完整对照
- 本地 `hasPermissionsToUseTool(...)` 决策树细节
- 对远端容器内部决策逻辑的猜测

这些继续只留在记忆层。

## 下一轮继续深入的候选问题

1. remote session 的 local authority 是否还能再拆成 tool-plane authority 与 approval-shell authority 两层？
2. direct connect 的 `can_use_tool` UI 壳与 remote session 的 `can_use_tool` UI 壳，是否值得拉出对照？
3. `toolUseConfirmQueue`、`PermissionRequest`、`requestPrompt` 三类本地 prompt/approval 容器，是否值得继续拆成“同容器不同主权”专题？

只要这三问没答清，后续继续深入时仍容易把：

- 本地审批 UI

误写成：

- 本地审批主权
