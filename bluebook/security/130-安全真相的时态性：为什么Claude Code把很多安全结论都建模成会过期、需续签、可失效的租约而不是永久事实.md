# 安全真相的时态性：为什么Claude Code把很多安全结论都建模成会过期、需续签、可失效的租约而不是永久事实

## 1. 为什么在 `129` 之后还必须继续写“时态性”

`129-安全真相动作算子` 已经回答了：

`Claude Code 的安全控制面不是静态权限表，而是在执行 allow、deny、degrade、step-up、de-scope、suppress 与 restore 这些动作算子。`

但如果继续追问，  
还会碰到一个更深的问题：

`这些动作到底是一次性动作，还是会随着时间继续失效、续签、重算？`

源码答案非常明确：

`它们很多都不是永久事实，而是时态性事实。`

也就是：

1. 某个授权现在成立，不代表一小时后还成立
2. 某个连接现在可用，不代表 token 不会过期
3. 某个 cache 现在可接受，不代表永远不 stale
4. 某个设备现在可信，不代表它不需要过期与再签

所以 `129` 之后必须继续补出的下一层就是：

`安全真相的时态性`

也就是：

`Claude Code 很多安全结论都被设计成租约：它们有 freshness、TTL、refresh、pending、expiry 与 downgrade 路径。`

## 2. 最短结论

Claude Code 安全设计真正成熟的一点，不只是它有很多门、很多动作算子，  
还在于：

`它把很多安全真相建模成会过期的对象，而不是永久属性。`

从源码看，至少有五类典型时态对象：

1. remote managed settings cache 会经历 `304 still valid`、stale reuse 与重新拉取  
   `remoteManagedSettings/index.ts:445-450`
2. trusted device token 有 90 天 rolling expiry，且 enrollment 受 fresh session 的 10 分钟窗口约束  
   `trustedDevice.ts:24-30`
3. MCP auth 有 `_pendingStepUpScope`，说明 scope 升级本身是一个挂起中的时间性状态  
   `mcp/auth.ts:1388-1390,1625-1650`
4. bridge session ingress JWT 会在到期前 5 分钟主动 refresh / reconnect  
   `bridgeMain.ts:279-300,1195-1201`
5. bridge environment / resume pointer 本身也有 stale / TTL / periodic refresh 语义  
   `bridgeMain.ts:1517-1521,2704-2728`
6. MCP `needs-auth` 结果还会被缓存，防止 stale token 造成 15 分钟风暴式重试  
   `mcp/client.ts:337-360,2311-2318`

所以这一章的最短结论是：

`Claude Code 保护的不是“静态安全状态”，而是“随时间保持仍然可信的安全状态”。`

再压成一句：

`安全真相在这里是租约，不是产权。`

## 3. 第一性原理：为什么成熟安全系统必须把真相做成租约

因为在现实系统里，  
安全从来不是一次性确定的。

以下事实都会随时间变化：

1. token 会过期
2. session 会 stale
3. cache 会老化
4. 设备信任会失效
5. 远程配置会变化
6. scope 要求会升级

如果系统还把这些对象当成永久事实，  
就会出现最危险的安全错觉：

`曾经成立过，所以现在大概还成立。`

成熟系统不会接受这种推理。  
它会把这些对象都建模成：

1. 有初始签发
2. 有有效期
3. 有续签条件
4. 有失效条件
5. 有失效后的降级动作

这就是“租约”视角。

## 4. remote managed settings：缓存真相有 freshness 边界

`src/services/remoteManagedSettings/index.ts:445-450` 写得很清楚：

1. `304 Not Modified`
2. `Cache still valid`
3. 使用 cached settings

而 `428-441,492-501` 又说明：

1. 拉取失败时可以使用 stale cache
2. 无 cache 时才 fail-open 到 no remote settings

这里最重要的不是 cache 本身，  
而是系统明确知道：

`cache 不是事实本身，它只是有 freshness 条件的事实副本。`

所以 remote settings 的真相并不是：

`有设置 / 没设置`

而是：

1. fresh enough
2. still valid via 304
3. stale but temporarily acceptable
4. unavailable, fallback to no-remote-settings

这是一种非常强的时间语义。

## 5. trusted device：设备信任本身就是租约

`src/bridge/trustedDevice.ts:24-30` 几乎是把租约语义直接写在注释里：

1. enrollment 必须发生在 `account_session.created_at < 10min`
2. token 是 `persistent (90d rolling expiry)`

这说明 trusted device 从来不是：

`设备被认证过一次，所以永久可信`

而是：

`设备信任本身有签发窗口、有滚动有效期、有持续续命机制。`

再结合同文件其他逻辑：

1. stale token 在 login 前会被 clear
2. enrollment 过了 fresh-session window 就会失败

这进一步说明：

`设备信任不是身份的附属属性，而是单独管理的时间性资格。`

## 6. MCP step-up：授权升级也有 pending 时态

`src/services/mcp/auth.ts:1388-1390` 暴露了一个很关键的内部状态：

`_pendingStepUpScope`

而 `1625-1650` 又说明：

1. 如果 `403 insufficient_scope` 发生
2. 且当前 token 不包含请求 scope
3. 系统会进入 `needsStepUp`
4. 甚至主动省略 refresh token，迫使走更高认证路径

这意味着 step-up 并不是一个瞬时布尔值。  
它是一个时态对象：

1. scope 不足被观察到
2. step-up pending 被记录
3. refresh path 被改写
4. 等待更高认证完成

所以系统管理的不是：

`有权限 / 没权限`

而是：

`当前权限等级不足，且正处于升级中的挂起状态。`

## 7. bridge session：远程会话真相靠主动续签维持

`src/bridge/bridgeMain.ts:279-300` 写得很明确：

1. session ingress JWT 会到期
2. 系统会在到期前 5 分钟主动 refresh
3. v2 场景甚至通过 `reconnectSession` 触发 server re-dispatch

而 `1195-1201` 又显示这套 refresh/schedule 是会话建立后就主动挂上的。

这说明 bridge session 在 Claude Code 里不是：

`连上了，所以稳定存在`

而是：

`连上之后还必须不断续签，续签失败就会失去同一会话真相。`

这是一种非常成熟的 session lease 语义。

## 8. bridge pointer / resumability：恢复真相也有 TTL

`src/bridge/bridgeMain.ts:1517-1521` 明确写出：

1. backend 会用 `4h TTL` 回收 stale environments
2. 某些 fatal 退出场景下 resume 已不可能

而 `2704-2728` 又进一步说明：

1. pointer 会每小时刷新一次
2. 目的是让 5 小时以上的 session crash 后仍有 fresh pointer
3. staleness 还会检查 file mtime，与 backend rolling TTL 配合

这说明 resume / pointer 这类恢复资产也不是永久真相，  
而是：

`必须持续保鲜的恢复租约。`

所以 Claude Code 对“可恢复”这件事的理解也非常严谨：

`它不是 once resumable, always resumable。`

## 9. MCP `needs-auth` 缓存：负真相同样有时间性

`src/services/mcp/client.ts:337-360` 和 `2311-2318` 说明：

1. auth failure 会把 client 置成 `needs-auth`
2. 该结果会被缓存
3. 连接尝试会在缓存期内被直接跳过

而 `363-370` 的注释又说明这样做是为了避免 stale token mass-401 引发风暴。

这很重要，  
因为它说明：

`负真相也有 TTL。`

也就是说：

1. 不是一旦 auth fail 就永久失败
2. 也不是每次都重新试直到把系统打爆
3. 而是进入一个带时效的 `needs-auth lease`

这也是成熟时态系统的标志。

## 10. 技术先进性：Claude Code 真正先进的不是“会刷新”，而是“把安全状态设计成时间对象”

很多系统也会 refresh token，  
但 Claude Code 这里更高级的地方在于：

1. cache validity 有明确语义
2. trusted device 有签发窗口与 rolling expiry
3. step-up 有 pending 状态
4. bridge ingress JWT 有 proactive refresh
5. resumability 有 pointer refresh 与 backend TTL
6. negative auth state 也有防风暴缓存

这些不是几段零散定时器，  
而是在共同实现一种统一思想：

`安全状态必须携带时间。`

这比“支持 refresh”要高级得多。

## 11. 哲学本质：Claude Code 保护的是“仍然有效的资格”，而不是“曾经有效的资格”

把这章与前面的：

1. 不对称真相
2. 失败语义
3. 缩域语义
4. 动作算子

连起来看，会得到一个更深的结论：

Claude Code 最终保护的不是：

`某人曾经被允许过`

而是：

`某人当前仍然有效地被允许。`

这就是为什么：

1. token 要 refresh
2. scope 要 step-up
3. trusted device 要 rolling expiry
4. resume pointer 要 hourly refresh
5. stale cache 只能暂借，不能永久冒充 fresh truth

所以它真正治理的是：

`有效中的资格`

而不是：

`历史上的资格`

## 12. 苏格拉底式反思：如果我要把这套时态性再推进一层，还该继续问什么

可以继续追问八句：

1. 当前还有哪些安全状态仍被当成永久属性，而其实应被建模成 lease
2. 哪些 freshness 规则现在仍然太隐式，缺少用户可见性
3. `needs-auth`、`step-up pending`、`stale cache` 是否都应统一呈现剩余租期
4. bridge trusted device 的 90d rolling expiry 是否应在 UI 中显式倒计时
5. 哪些 `restore` 动作其实应要求再验 freshness，而不是直接回放
6. 当前哪些 fail-open stale path 还缺 freshness debt disclosure
7. 某些中国高波动网络场景下，哪类 lease 会比平台预期更频繁失效
8. 整套蓝皮书是否也应补一层“安全租约总图”

这些问题共同指向：

`Claude Code 已经拥有很强的安全时态系统，但它还可以继续把 lease / expiry / refresh / stale 的语义显式产品化。`

## 13. 一条硬结论

Claude Code 安全设计的成熟，  
不只在于它会：

1. 允许
2. 阻断
3. 升级认证
4. 缩域

还在于它清楚地知道：

`这些结论都不是永久事实，而是会过期、会续签、会失效、会回退的时间性真相。`

所以它保护的最终对象不是“有没有资格”，  
而是：

`当前这一刻，你的资格是否仍然有效。`

