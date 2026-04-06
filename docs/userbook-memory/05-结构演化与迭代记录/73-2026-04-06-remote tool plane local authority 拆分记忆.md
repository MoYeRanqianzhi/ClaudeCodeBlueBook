# remote tool plane local authority 拆分记忆

## 本轮继续深入的核心判断

第 72 页已经拆开：

- remote session 的 tool plane 仍然活着
- 而且不会和 command plane 一起变薄

但还缺一层更关键的主权判断：

- 这张本地工具面到底由谁主导

如果不单独补这一批，正文还会继续犯五种错：

- 把 `slash_commands` 写成工具面主轴
- 把工具池写成启动时默认值
- 漏掉 `initialMsg.mode` / `allowedPrompts` 对工具面的第一次改写
- 漏掉 `message.permissionMode` 的历史恢复作用
- 漏掉本地持久化权限更新会继续重塑工具面

## 本轮最关键的源码纠偏

### 纠偏一：本地 tool plane 的装配权明确在 `computeTools()`

这次最重要的源码事实不是又找到一个 merge hook，而是看清：

- `computeTools()` 直接从本地 `store.getState()` 取 `toolPermissionContext`
- 再装配工具池

这使“谁在装工具池”这个问题第一次有了很清晰的答案：

- 本地 REPL

### 纠偏二：远端提供的是 permission-context 输入，不是最终工具表

`initialMsg.mode` / `allowedPrompts` 和 `message.permissionMode` 都很重要，但它们的角色不是：

- 直接下发最终 tools

而是：

- 改写本地 `toolPermissionContext`

然后再由本地重算工具池。

### 纠偏三：本地用户行为仍然在持续治理工具面

这一轮真正把“本地主权”坐实的，是：

- `applyPermissionUpdate(...)`
- `persistPermissionUpdate(...)`
- queued item `recheckPermission()`

这些都说明本地工具面仍然处在本地治理回路中，而不是远端投影物。

## 苏格拉底式自审

### 问：为什么这批不能塞回第 72 页？

答：第 72 页回答的是：

- tool plane 为什么仍然活着

本轮问题已经换成：

- tool plane 由谁主导

也就是：

- local authority over tool plane

不是：

- plane mismatch

### 问：为什么这批必须单写？

答：因为“它还活着”和“谁在主导它”不是同一个问题。前者解释厚度，后者解释主权。只有把后者单独写出来，读者才不会把远端输入误写成远端主权。

### 问：为什么这批必须把初始化恢复、历史恢复、本地规则更新并列？

答：因为如果只写一条来源，正文就又会回到单因果叙述。真实源码显示至少有三类来源共同改写 `toolPermissionContext`，这正是需要单页拆开的原因。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/73-toolPermissionContext、initialMsg.mode、message.permissionMode、applyPermissionUpdate 与 computeTools：为什么 remote session 的本地 tool plane 主权不等于远端命令面主权.md`
- `bluebook/userbook/03-参考索引/02-能力边界/62-Remote toolPermissionContext、permissionMode restore 与 local tool-plane authority 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/73-2026-04-06-remote tool plane local authority 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `computeTools()` 如何取本地 store state
- `initialMsg.mode` / `allowedPrompts` 如何改写 `toolPermissionContext`
- `message.permissionMode` 如何在回放时改写 mode
- 本地持久化权限更新如何继续塑形工具面
- 为什么 `slash_commands` 不是工具面主轴

### 不应写进正文的

- 第 72 页关于 tool plane 仍然活着的整段复述
- 完整审批生命周期
- 每种 permission update 的内部结构细节
- 对远端产品意图的猜测性解读

这些继续只留在记忆层。

## 下一轮继续深入的候选问题

1. remote session 的 local authority 是否还能再拆成“mode authority / rule authority / store authority”三层？
2. 本地工具面主权与远端 `can_use_tool` / `toolUseConfirmQueue` 的边界，是否值得单独拆开？
3. direct connect 的本地工具面主权是否又是另一种模式，值得拉出对照？

只要这三问没答清，后续继续深入时仍容易把：

- remote tool plane 的输入

写成：

- remote tool plane 的主权
