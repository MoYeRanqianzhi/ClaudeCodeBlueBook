# 安全真相动作算子：为什么Claude Code不是在做静态权限判断，而是在执行allow、deny、degrade、step-up、de-scope、suppress与restore的控制面语法

## 1. 为什么在 `128` 之后还必须继续写“动作算子”

从 `126` 到 `128`，  
我们已经把 Claude Code 安全控制面的内核推进到了三层：

1. 安全真相的不对称性
2. 失败语义三分法
3. 缩域语义

这已经足够说明它不是简单权限系统。  
但如果继续追问，  
还会碰到一个更高层的问题：

`这些现象之间到底有没有一套统一语法？`

答案是：有。

因为从源码看，  
Claude Code 安全控制面并不是在反复做“允许/拒绝”这一个动作，  
而是在执行一组更丰富、更稳定的真相操作：

1. `allow`
2. `deny`
3. `degrade`
4. `step-up`
5. `de-scope`
6. `suppress`
7. `restore`

所以 `128` 之后必须继续补出的下一层就是：

`安全真相动作算子`

也就是：

`Claude Code 的安全控制面不是静态权限表，而是一套按风险对象持续变换系统真相的动作语法。`

## 2. 最短结论

Claude Code 安全设计真正成熟的地方，不只是有很多门、很多 veto、很多失败模式，  
而是：

`它把安全控制建模成一组稳定的动作算子。`

从源码看，这些算子至少包括：

1. `allow`
   通过 policy/gate/approval 后允许某条能力继续存在
2. `deny`
   在主权或高危变更场景下直接关闭路径
3. `degrade`
   在 availability 风险下退回 stale / cache / no-remote-settings 路径
4. `step-up`
   在授权级别不足时跳转到更高证明流程
5. `de-scope`
   裁掉高风险子能力，只保留较窄安全子集
6. `suppress`
   对重复、低优先级、被更高意图覆盖的对象做抑制
7. `restore`
   在高风险上下文结束后恢复先前被暂存的安全可接受能力

所以这一章的最短结论是：

`Claude Code 不是在回答“有没有权限”，而是在不断对系统真相执行一组风险感知的动作算子。`

再压成一句：

`它治理的不是权限表，而是真相的变换。`

## 3. 第一性原理：为什么成熟安全系统最终都会变成“动作语法”

静态权限系统默认的世界观是：

1. 主体固定
2. 能力固定
3. 环境固定
4. 决策只需查表

但 Claude Code 这种运行时控制面显然不是这样：

1. 模式会切换
2. 远程设置会热更新
3. 网络与身份状态会漂移
4. 高危配置会出现或消失
5. 第三方扩展会被接入、锁定、去重、抑制

在这种系统里，  
安全不可能只靠“当前允许/当前拒绝”两格表来表达。

它必须升级成：

`当环境变化时，系统对真相对象执行什么动作。`

这就是为什么最终会出现动作算子。

## 4. `allow`：让某条能力在当前证明链下继续存在

`allow` 是最表层的算子，  
但它在 Claude Code 里从不是裸允许。

例如：

1. `cli.tsx:151-159` 中 `allow_remote_control` 必须先经 policy limits 允许
2. `securityCheck.tsx:48-55` 中危险受管设置必须显式 `approved`
3. MCP 连接只有在 enabled + policy-allowed + approved 的子集里才继续保留

所以 `allow` 在这里不是初始状态，  
而是：

`证明链通过后的继续保留。`

## 5. `deny`：当主权边界断裂时，直接关掉路径

`deny` 在前面已经多次出现：

1. `auth.ts:1920-1969` 的 `forceLoginOrg` fail-closed
2. `cli.tsx:157-159` 的 Remote Control policy deny
3. `securityCheck.tsx:67-70` 的危险设置拒绝后 shutdown

这些 deny 的共同点是：

`它们面对的不是普通可用性问题，而是主权、组织、高危配置和高安全远程能力问题。`

所以 deny 不是“默认最严”，  
而是：

`当某类边界的证明链断裂时，最合适的动作。`

## 6. `degrade`：退回较弱但仍可运行的真相

`remoteManagedSettings/index.ts:432-442,492-501` 已经很清楚：

1. fetch 失败时回 stale cache
2. 无 cache 时 continue without remote settings

这不是 allow，也不是 deny。  
这是：

`degrade`

也就是：

`把系统从“最新真相”降到“仍可运行但更弱的真相”。`

degrade 的哲学是：

`我们先保住运行，再承认真相强度下降。`

## 7. `step-up`：把权限层级问题改写成更高证明流程

`mcp/auth.ts:1461-1470` 和 `1625-1650` 说明：

1. `403 insufficient_scope` 触发 `markStepUpPending`
2. 刻意绕开 refresh
3. 强制进入更高层授权路径

这说明 `step-up` 既不是 deny，也不是 degrade。  
它是在说：

`当前这条链不够强，但可以跳到更高证明层。`

这是一种非常成熟的算子，  
因为它承认：

`失败的不是主体本身，而是当前证明等级。`

## 8. `de-scope`：裁掉危险边缘，只保留可证明安全的子集

这一章与前一章直接相连。

最典型的证据包括：

1. `permissionSetup.ts:510-579`
   auto mode 先 strip dangerous allow rules
2. `sandboxTypes.ts:22-24,82-83,117-119`
   managed-only domains / managed-only read paths / ignore unsandboxed escape
3. `mcp/config.ts:1164-1245`
   project/plugin/manual server 先被压到 approved + policy-allowed + non-duplicate 子集
4. `loadPluginAgents.ts:153-165`
   plugin agent 的高风险字段被直接忽略

这都是 de-scope。  
它的本质不是“你不能用”，  
而是：

`你只能用裁剪后的那部分。`

## 9. `suppress`：被更强意图覆盖的对象不进入主舞台

`mcp/config.ts:228-309,1216-1228` 提供了一个很漂亮的算子例子。

这里对重复 plugin server 和 claude.ai connector 做的不是 deny，  
也不是 error，  
而是：

`suppress`

具体表现为：

1. 重复 server 不进入最终 server set
2. 但 suppressions 会被 surface 到 UI
3. 它们是 informational，不算 errors

这说明系统理解的是：

`这些对象不是非法，它们只是被更高优先级对象覆盖了。`

这是很成熟的控制面语义。

## 10. `restore`：高风险上下文结束后，恢复先前被合法暂存的能力

`permissionSetup.ts:561-579` 的 `restoreDangerousPermissions(...)` 就是 restore 算子。

它说明：

1. 被 strip 的规则不是永久删除
2. 它们被 stash
3. 离开 auto mode 时可以恢复

restore 的存在非常重要，  
因为没有 restore，  
系统就只能在：

1. 永久禁用
2. 永不裁剪

之间二选一。

而 restore 让系统获得第三种能力：

`在高风险窗口内暂时缩域，窗口结束后再合法回放。`

## 11. 为什么这七个算子能统一成一套语法

它们表面不同，  
但共同回答的是同一个问题：

`当当前证明链发生变化时，系统应该如何更新自己能说的真相。`

对应关系是：

1. 证明成立 -> `allow`
2. 主权断裂 -> `deny`
3. 真相变弱但仍可运行 -> `degrade`
4. 证明等级不足 -> `step-up`
5. 只部分可证明 -> `de-scope`
6. 被更强对象覆盖 -> `suppress`
7. 高风险窗口结束 -> `restore`

这就是为什么我说：

`Claude Code 在治理真相变换，而不是只在查权限。`

## 12. 技术先进性：从“权限系统”升级到“安全控制面语法”

这套设计真正先进的地方在于：

1. 它允许不同 risk object 触发不同算子
2. 算子之间是可组合的
3. 算子背后有明确的边界签字人
4. 算子结果能进入 UI / 状态面 / 日志面

例如一个对象完全可能经历：

1. 先 `de-scope`
2. 再 `step-up`
3. 最后 `restore`

而不是永远只会得到一个 `allowed/denied` 布尔结果。

这就是从老式权限系统升级到现代安全控制面的关键一步。

## 13. 苏格拉底式反思：如果我要把这套算子继续推进一层，还该追问什么

可以继续问八句：

1. 当前还有哪些代码路径其实已在做算子变换，但名字还没统一
2. 哪些 UI 仍把 `suppress`、`de-scope`、`deny` 混说成同一种失败
3. 哪些 `restore` 仍然过于隐式，缺乏账本化
4. 哪些 `degrade` 路径应该补更明确的 freshness disclosure
5. 哪些 `step-up` 路径应该对用户暴露更清晰的 upgrade reason
6. 哪些 `suppress` 其实应该升级成 explicit override graph
7. 是否还缺少一种“quarantine”算子，用于暂时隔离而非完全 deny
8. 整套蓝皮书是否也应改用这套算子语法重写索引结构

这些问题共同指向：

`Claude Code 的安全设计已经接近一套形式化控制面语法，只是还没有完全显式命名。`

## 14. 一条硬结论

Claude Code 安全设计真正的高级之处，  
不是有多少规则，  
而是它已经在源码里稳定实现了一套动作算子：

`allow / deny / degrade / step-up / de-scope / suppress / restore`

这套语法让系统可以随着证明链变化，  
持续修正自己能说、能做、能保留到什么程度。

所以它保护的最终对象不是某个单一能力，  
而是：

`系统真相在风险变化中的正确变换。`

