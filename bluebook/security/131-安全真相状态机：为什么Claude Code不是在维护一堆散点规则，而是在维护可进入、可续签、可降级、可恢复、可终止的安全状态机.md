# 安全真相状态机：为什么Claude Code不是在维护一堆散点规则，而是在维护可进入、可续签、可降级、可恢复、可终止的安全状态机

## 1. 为什么在 `130` 之后还必须继续写“状态机”

`129-安全真相动作算子` 已经回答了：

`Claude Code 的安全控制面不是静态权限表，而是在执行 allow、deny、degrade、step-up、de-scope、suppress 与 restore 这些动作算子。`

`130-安全真相的时态性` 又继续回答了：

`这些动作作用的也不是永久事实，而是会过期、要续签、会失效的租约性真相。`

但如果继续追问，  
还会碰到更高一层的问题：

`如果系统既有动作算子，又有时态租约，那么这些动作到底是在什么对象上运行？`

源码给出的答案不是“散点规则集合”，  
而更接近：

`一组可进入、可驻留、可续签、可降级、可恢复、可终止的安全状态机。`

所以 `130` 之后必须继续补出的下一层就是：

`安全真相状态机`

也就是：

`Claude Code 真正治理的不是零散规则，而是不同安全真相家族的合法跃迁。`

## 2. 最短结论

Claude Code 安全设计真正成熟的一点，不只是它有很多 gate、很多 veto、很多 lease，  
而在于：

`它把安全控制实现成多组状态家族，并为它们定义进入条件、驻留条件、退出算子与签字者。`

从源码看，这种状态机思维至少已经体现在五类对象上：

1. 权限模式家族  
   `transitionPermissionMode(...)` 负责 `plan/auto/...` 的合法切换，并在进入 auto 时 strip 危险权限、退出时 restore  
   `src/utils/permissions/permissionSetup.ts:597-645`
2. 受管设置审查家族  
   `approved/rejected/no_check_needed` 不是注释词，而是显式结果型状态  
   `src/services/remoteManagedSettings/securityCheck.tsx:12-22,67-72`
3. MCP 连接家族  
   `connected/failed/needs-auth/pending/disabled` 被正式写进 schema 和 union type  
   `src/entrypoints/sdk/coreSchemas.ts:167-173`  
   `src/services/mcp/types.ts:194-226`
4. 认证升级家族  
   `insufficient_scope` 不被压成 generic fail，而被改写成 `_pendingStepUpScope` 的挂起状态  
   `src/services/mcp/auth.ts:1345-1353,1461-1470,1625-1650`
5. 会话与配置租约家族  
   remote settings、bridge ingress JWT、resume pointer、trusted device token 都有 freshness / expiry / refresh 语义  
   `src/services/remoteManagedSettings/index.ts:415-501`  
   `src/bridge/bridgeMain.ts:279-300,1195-1201,1517-1521,2700-2728`  
   `src/bridge/trustedDevice.ts:15-31,54-59,89-97`

所以这一章的最短结论是：

`Claude Code 不是在维护一堆“如果这样就那样”的散点 if，而是在维护多组安全状态机。`

再压成一句：

`安全治理的对象不是规则，而是合法状态跃迁。`

## 3. 第一性原理：为什么真正的安全控制面最终一定会长成状态机

如果一个系统只处理下面四件事：

1. 主体不变
2. 能力不变
3. 环境不变
4. 真相不过期

那它确实可以靠查表活着。

但 Claude Code 处理的不是这种世界。

它处理的是：

1. permission mode 会切换
2. auto mode 有进入与退出窗口
3. managed settings 会热更新
4. remote settings cache 会 stale
5. MCP 连接会 pending、needs-auth、failed、reconnect
6. token 会临期、失效、续签
7. trusted device 会过 fresh enrollment window
8. bridge environment 会被后端 TTL 回收

一旦现实是这样，  
安全系统就不再是在回答：

`现在有没有权限？`

它真正回答的是：

1. 这个对象现在处于什么状态
2. 它凭什么进入这个状态
3. 它靠什么继续留在这个状态
4. 它会被什么算子推出这个状态
5. 谁才有资格宣布这次状态改变是真的

这五个问题合起来，  
就是状态机问题。

## 4. 源码已经显式暴露出的“状态家族意识”

最直接的证据不是评论文字，  
而是作者已经把很多安全对象写成了显式 state family。

### 4.1 MCP 连接不是布尔连接，而是五态家族

`McpServerStatusSchema` 直接把 MCP status 定义成：

1. `connected`
2. `failed`
3. `needs-auth`
4. `pending`
5. `disabled`

见 `src/entrypoints/sdk/coreSchemas.ts:167-173`。

而 `src/services/mcp/types.ts:194-226` 又把这五态做成正式 union：

1. `ConnectedMCPServer`
2. `FailedMCPServer`
3. `NeedsAuthMCPServer`
4. `PendingMCPServer`
5. `DisabledMCPServer`

这说明作者从一开始就不是按“连上/没连上”理解 MCP，  
而是按：

`不同连接状态对应不同承诺上限、不同 repair path、不同 UI 语义`

来理解。

### 4.2 受管设置安全审查不是一个布尔 check，而是结果态家族

`src/services/remoteManagedSettings/securityCheck.tsx:12-22` 直接把结果定义成：

1. `approved`
2. `rejected`
3. `no_check_needed`

随后 `handleSecurityCheckResult(...)` 又在 `67-72` 把 `rejected` 直接接上 shutdown。

这说明这里处理的也不是：

`要不要弹窗`

而是：

`受管设置变化目前处于哪一种安全审查结论态。`

### 4.3 权限模式切换已经具备“合法跃迁”意识

`src/utils/permissions/permissionSetup.ts:597-645` 的 `transitionPermissionMode(...)` 尤其关键。

它明确体现出：

1. 同态切换直接返回，避免伪跃迁
2. `toMode === 'auto'` 时要先检查 auto gate
3. 进入 classifier 侧时要 `stripDangerousPermissionsForAutoMode(...)`
4. 离开 classifier 侧时要 `restoreDangerousPermissions(...)`
5. `plan` 退出时还要清理 `prePlanMode`

这已经不是“设置 mode 值”。  
这是：

`维护一个具有 entry action 与 exit action 的状态机。`

### 4.4 认证升级不是异常，而是挂起中的过渡态

`src/services/mcp/auth.ts:1345-1353` 解释得非常明确：

1. `403 insufficient_scope` 不能被简单 refresh 掉
2. 否则只会原地重试再 403
3. 所以必须先标记 step-up pending

于是同文件里出现了 `_pendingStepUpScope`  
`src/services/mcp/auth.ts:1388-1390`

以及显式 `markStepUpPending(scope)`  
`src/services/mcp/auth.ts:1461-1470`

再往下，`tokens()` 会在 `1625-1650` 检测 step-up pending，  
刻意省略 refresh token，迫使流程进入更高证明路径。

这说明这里治理的不是 error。  
治理的是：

`授权状态从 insufficient 到 step-up pending，再到更高授权完成的过渡机。`

## 5. 进入条件：状态不是想进就进，必须先过 admission gate

状态机的第一层不是状态名，  
而是：

`你凭什么进入。`

Claude Code 在这点上非常克制。

### 5.1 bridge 远程控制的进入条件是多门串联，不是单门放行

`src/entrypoints/cli.tsx:132-159` 展示了 bridge 的进入链：

1. 必须先有 auth token
2. 必须通过 GrowthBook disabled reason 检查
3. 必须满足最小版本要求
4. 必须通过组织 policy `allow_remote_control`

这不是 feature flag 判断。  
这是标准的多门 admission。

也就是说：

`“可以进入远程控制状态”本身就是一个高门槛状态，而不是默认可达起点。`

### 5.2 trusted device 不是任何时刻都能补签

`src/bridge/trustedDevice.ts:25-27,94-97` 很关键：

1. enrollment 只能发生在 `account_session.created_at < 10min`
2. 过了这个窗口，晚到 enrollment 会 `403 stale_session`

这说明：

`状态机的 entry condition 有时间窗。`

也就是：

`不是系统有补救路径，就代表任何时候都配进入那条补救状态。`

### 5.3 managed settings 只有在危险变化出现时才进入审查态

`src/services/remoteManagedSettings/securityCheck.tsx:22-35` 说明：

1. 没有危险设置就 `no_check_needed`
2. 危险设置没变化也 `no_check_needed`
3. non-interactive 模式也不会进入 dialog 审查流

也就是说审查态不是默认态。  
它只在：

`危险变化被检测到，且当前交互条件允许审查`

时才进入。

## 6. 驻留条件：进入还不够，状态必须被持续续签

很多系统的安全漏洞不发生在 entry，  
而发生在：

`进入之后，系统默认它会永远继续成立。`

Claude Code 在很多地方都拒绝这种偷懒。

### 6.1 remote settings 不是“拉到一次就永久有效”

`src/services/remoteManagedSettings/index.ts:420-450,492-501` 很清楚地把 remote settings 分成：

1. fresh fetch success
2. `304 Not Modified` 下 cache still valid
3. fetch 失败但 stale cache 仍可临时使用
4. 连 cache 都没有时 fail-open 到 `null`

这说明它的驻留条件不是：

`曾经取到过`

而是：

`现在依然被 freshness 证据支撑，或者至少处于被允许的 stale 降级态。`

### 6.2 bridge 会话不是“连上就完事”，而是靠续签活着

`src/bridge/bridgeMain.ts:279-300,1195-1201` 表明：

1. ingress JWT 到期前 5 分钟会主动 refresh
2. v2 场景下甚至通过 `reconnectSession(...)` 重新触发 server re-dispatch

这说明 `connected` 不是静止形容词。  
它是：

`持续被 refresh 维持的存活态。`

### 6.3 resume pointer 不是“写一次就永远可恢复”

`src/bridge/bridgeMain.ts:1517-1521,2700-2728` 又把恢复能力也做成 lease：

1. backend environment 有 4 小时 TTL
2. pointer 会按小时刷新
3. fatal 退出场景下 resume 不再成立

这说明“可恢复”本身也是状态机里的条件态，  
不是永久资产。

## 7. 退出算子：状态机真正成熟的地方，在于退出被语法化

如果只有进入与驻留，  
系统仍然只是一个脆弱缓存。

Claude Code 的成熟之处在于：  
状态退出不是混乱消失，  
而是被动作算子语法化。

### 7.1 `needs-auth` 是一种有意的退出，不是失败噪音

`src/services/mcp/client.ts:337-360,2311-2318` 表明：

1. auth failure 会进入 `needs-auth`
2. 结果还会被缓存
3. 缓存期内连接尝试会被主动跳过

所以系统不是“失败后继续傻试”，  
而是：

`从 connectable 状态退出到 needs-auth 状态，并抑制无意义重连。`

### 7.2 `rejected` 会触发 hard exit

`src/services/remoteManagedSettings/securityCheck.tsx:67-72` 说明：

`rejected` 不是一个 UI 标签。  
它是一个终止算子触发点。

### 7.3 permission mode 的退出伴随 restore

`src/utils/permissions/permissionSetup.ts:627-637` 说明：

1. 进入 auto 会 strip dangerous permissions
2. 离开 auto 会 restore dangerous permissions

这意味着：

`状态退出不只意味着离开，还意味着退出动作必须回写到能力面。`

所以这里的状态机不是纯描述性的。  
它是具备副作用合同的。

## 8. 谁才配宣布状态变化为真：状态机背后还有“签字者”

光有状态名仍然不够。  
因为安全系统最危险的错觉之一是：

`谁都能说状态变了。`

Claude Code 源码里更可靠的做法是：

`不同状态家族有不同 authoritative signer。`

例如：

1. permission mode 家族的合法切换，主要由 `transitionPermissionMode(...)` 这条控制路径签字  
   `src/utils/permissions/permissionSetup.ts:597-645`
2. managed settings 审查家族的结论，由 `checkManagedSettingsSecurity(...)` 和 `handleSecurityCheckResult(...)` 这对函数签字  
   `src/services/remoteManagedSettings/securityCheck.tsx:12-22,67-72`
3. MCP 连接家族的 `needs-auth` 进入，由 `handleRemoteAuthFailure(...)` 与 auth cache 逻辑签字  
   `src/services/mcp/client.ts:335-360,2308-2318`
4. step-up pending 家族的进入，由 `wrapFetchWithStepUpDetection(...)` 与 `markStepUpPending(...)` 签字  
   `src/services/mcp/auth.ts:1345-1353,1461-1470`
5. bridge lease 家族的续签与失效边界，由 `tokenRefresh.schedule(...)`、backend TTL 与 pointer refresh 共同签字  
   `src/bridge/bridgeMain.ts:279-300,1195-1201,1517-1521,2720-2728`

这件事的哲学含义很重：

`状态机不是一组值，而是一组只有特定控制面节点才配发布的值。`

换句话说：

`真正被保护的，不只是状态本身，还有状态解释权。`

## 9. 这套状态机设计的先进性到底先进在哪里

如果只从“有没有 sandbox / classifier”看，  
Claude Code 的先进性很容易被低估。

它真正先进的地方至少有四点。

### 9.1 它把负状态也产品化了

很多系统只认真设计 success state，  
把失败态压成一个 generic error。

Claude Code 没这么做。  
`needs-auth`、`pending`、`disabled`、`rejected`、stale cache、step-up pending 都说明：

`它把不能继续说“可以”的状态，也做成了一等公民。`

### 9.2 它把过渡态当成核心对象，而不是尴尬中间态

`pending`、`step-up pending`、`reconnect before expiry` 这些都表明：

`过渡态不是边角料，而是运行时安全真相的主要工作区。`

这是成熟控制面才会有的意识。

### 9.3 它把“继续成立”的证明做成持续义务

从 remote settings freshness 到 bridge JWT refresh 再到 trusted device expiry，  
源码反复表达的是同一件事：

`状态一旦进入，并不意味着它天然有驻留权。`

### 9.4 它把系统安全的真正焦点从“规则数量”转成“非法跃迁封堵”

这也是最关键的一点。

真正难的不是再多写十条 deny rule，  
而是回答：

1. 哪些状态可以直接跳
2. 哪些必须先降级
3. 哪些必须先进入 pending
4. 哪些旧状态必须被 invalidate
5. 哪些状态即使看起来相近，也绝不能互转

Claude Code 在多个模块里的实现方式已经说明团队在朝这个方向走。

## 10. 哲学本质：安全不是在判断对象“是什么”，而是在治理对象“还能如何变化”

这就是这一章真正想说的核心。

从第一性原理看，  
安全不是静态本体论，  
而是动态变化论。

真正危险的从来不是：

`系统里有某个对象。`

而是：

`对象已经不再满足旧条件，但系统还允许它沿用旧状态。`

所以 Claude Code 安全控制面的哲学本质可以被压成一句话：

`它治理的不是对象本身，而是对象从一种真相跳到另一种真相时是否合法。`

这就是为什么：

1. 不对称性重要
2. 失败语义重要
3. 缩域重要
4. 动作算子重要
5. 时态租约重要
6. 最终状态机更重要

因为前五者，  
最后都只是为了回答状态机的四个问题：

1. 能不能进
2. 能留多久
3. 该怎么退
4. 谁来签字

## 11. 苏格拉底式反思：如果要把这套状态机再推进一代，还缺什么

继续追问，还能看到几处明显未完成之处。

### 11.1 我们真的已经拥有统一状态机了吗

没有。  
我们拥有很多状态机片段，  
但它们仍散落在：

1. union type
2. cache entry
3. enum string
4. boolean + comment
5. timer + side effect

之间。

所以第一个反问是：

`既然状态机已经客观存在，为什么还允许它继续隐身在分散字段里？`

### 11.2 非法跃迁是否已经被统一机检

也没有。  
某些地方已经有显式 guard，  
但从整个系统看，  
“哪些状态不得直跳”仍大量依赖局部作者记忆。

所以第二个反问是：

`如果维护者换人，这些禁止跳转的宪法还能不能继续被守住？`

### 11.3 状态家族的 signer 是否已经结构化

也还不够。  
我们能从代码推断 signer，  
但 signer 多数仍是隐含的。

所以第三个反问是：

`如果 UI、SDK host、CLI 和 remote bridge 同时解释同一状态，谁拥有最终解释权，是否已经被协议化？`

### 11.4 状态历史是否已经有统一账本

也没有完全做到。  
很多地方有 trace、有 log、有 timer、有 cache，  
但仍缺一层统一的 security truth ledger。

所以第四个反问是：

`当一次状态变化被质疑时，系统能否完整回答它何时进入、凭何驻留、因何退出、是谁签字？`

## 12. 本章结论

把前面所有章节压到这一层，  
Claude Code 安全性的更深本质就变得很清楚了：

`它不是在维护一堆安全规则。`

它真正维护的是：

1. 多组安全状态家族
2. 每组状态的 admission 条件
3. 每组状态的续签条件
4. 每组状态的退出算子
5. 每组状态的 authoritative signer

所以如果要学习 Claude Code 的技术启示，  
最值得学的不是“如何再加几个 deny”，  
而是：

`如何把安全控制面从散点规则，推进成有状态、有时态、有签字权、有非法跃迁禁令的运行时状态机。`

