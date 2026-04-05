# 安全真相的不对称性：为什么Claude Code对高风险放行要求更强证明，而对阻断与降级允许更早触发

## 1. 为什么在 `125` 之后还必须重新回到源码本体

从 `117` 到 `125`，  
我们把这份研究版源码的安全研究方法一路压缩成了：

1. 阶段门
2. 门的类型学
3. 结论上限
4. 联合签字
5. 否决权宪法
6. 缺席语义
7. 举证责任
8. 降级语法
9. 词法宪法

这条链已经把“如何不说过满”写得很严。  
但如果继续只停在元方法，  
还会欠一个更重要的问题：

`Claude Code 自己的安全控制面，究竟是不是按同一种哲学在工作？`

答案是：  
是，而且非常明显。

因为从权限模式、受管设置、组织主权、Remote Control 到 MCP OAuth step-up，  
源码反复表现出同一条原则：

`高风险放行需要更强证明；高风险阻断与降级则允许更早触发。`

所以 `125` 之后必须继续补出的下一层就是：

`安全真相的不对称性`

也就是：

`Claude Code 的安全设计不是对称判定“安全/不安全”，而是在不同风险层对“允许”与“拒绝”施加不对称的证明门槛。`

## 2. 最短结论

Claude Code 安全设计最深的一条工程哲学不是：

`尽量精确地区分一切。`

而是：

`在高风险放行上要求更强正证明，在高风险阻断上允许更早、甚至在部分信息下先收口。`

这在源码里至少体现为五条非常硬的事实：

1. 进入 auto mode 时，系统会主动剥离会绕过 classifier 的危险 allow 规则  
   `permissionSetup.ts:510-553,627-636`
2. 强制组织绑定的校验在无法确认组织时 fail-closed，而不是把“查不到”当成“先放行”  
   `auth.ts:1916-1969`
3. 远程受管设置整体获取是 availability 友好的 fail-open / stale-cache，但一旦涉及危险 shell setting、非安全 env var 与 hooks 变更，就会进入阻断对话与拒绝退出  
   `remoteManagedSettings/index.ts:413-442,456-467,492-501`; `securityCheck.tsx:15-20,33-35,38-70`; `ManagedSettingsSecurityDialog/utils.ts:20-23,44-62,87-117`
4. Remote Control 不是“能连就连”，而是先过 auth、GrowthBook、最小版本与组织 policy  
   `cli.tsx:132-159`
5. MCP OAuth 的 `insufficient_scope` 不被误当作普通 refresh failure，而会被提升成 step-up auth  
   `mcp/auth.ts:1345-1353,1461-1470,1625-1650`

所以这一章的最短结论是：

`Claude Code 的安全先进性，不只在于控制点多，而在于它明确把“允许”和“拒绝”的证明门槛设计成不对称。`

再压成一句：

`放行要证明，阻断可以先怀疑。`

## 3. 第一性原理：为什么安全系统的真相本来就不该对称

如果系统对“允许”和“拒绝”采用同样的证明门槛，  
会出现两种坏结果：

1. 为了不误伤，系统会把很多高风险操作过早放行
2. 为了不漏放，系统又会把低风险可恢复流程全部卡死

真正成熟的安全系统不会这样设计。  
它会先问：

`这次决策的错误成本是什么？`

如果错误放行的代价更大，  
那允许动作就必须要求更强的正证明。

如果错误阻断的代价较低、且可恢复，  
那系统就可以在怀疑条件下先降级、先 step-up、先收口。

所以从第一性原理看，  
安全真相本来就不是对称的：

1. `allow` 证明门槛更高
2. `deny / downgrade / step-up` 启动门槛更低

Claude Code 的源码恰恰在反复实现这一原则。

## 4. `auto mode`：对高风险自动放行采取更强证明门槛

`src/utils/permissions/permissionSetup.ts:510-553` 很关键。

进入 auto mode 之前，  
系统不是简单沿用既有 always-allow 规则，  
而是：

1. 把所有 allow 规则重新展开
2. 识别其中会绕过 classifier 的危险权限
3. 直接剥离并暂存这些规则

对应实现就是：

1. `stripDangerousPermissionsForAutoMode(...)`
2. `findDangerousClassifierPermissions(...)`
3. `removeDangerousPermissions(...)`

而 `permissionSetup.ts:627-636` 又进一步表明：

1. 只有 gate enabled 才能进入 auto mode
2. 进入时主动 `setAutoModeActive(true)`
3. 同时执行 `stripDangerousPermissionsForAutoMode(context)`
4. 离开时才 `restoreDangerousPermissions(context)`

这说明 Claude Code 对 auto mode 的哲学不是：

`用户既然以前 allow 过，那 auto 里就也继续 allow。`

而是：

`一旦进入 classifier 驱动的自动放行状态，任何可能绕过 classifier 的旧 allow 都必须先被拿掉。`

这就是典型的不对称真相：

1. 恢复默认/手动模式时，旧 allow 可以回放
2. 进入更高风险的自动模式时，旧 allow 不能天然继承

换句话说：

`高风险放行必须重新证明自己安全，而不能借旧权限记忆偷渡。`

## 5. `forceLoginOrg`：身份与组织主权采取 fail-closed

`src/utils/auth.ts:1916-1969` 是另一条更硬的证据。

这里作者明确写出：

1. `forceLoginOrgUUID` 属于 managed settings 的组织约束
2. 组织验证结果返回 result object，而不是把错误吞掉
3. 如果拿不到 authoritative profile，就 fail-closed
4. 本地可写缓存中的 org UUID 不可信，必须去 profile endpoint 验

最关键的是 `auth.ts:1920-1922,1950-1969`：

1. 无法确定 token 对应组织时，验证失败
2. 本地 `~/.claude.json` 中的 org UUID 因为可写，不可信
3. 只有服务端 profile 给出的 org UUID 才是 authoritative truth

这说明组织主权不是普通配置项，  
而是：

`高优先级身份边界。`

在这种边界上，  
系统宁可因为网络错误或 profile scope 缺失而不放行，  
也不会把“暂时查不到”当成“先当通过”。

这就是另一种不对称：

1. `allow org-bound access` 需要 authoritative proof
2. `deny / invalid` 只需要 proof missing

## 6. `remoteManagedSettings`：可用性上 fail-open，危险变更上 fail-closed

这一块最能体现 Claude Code 的成熟度。  
因为它没有粗暴地全部 fail-open，也没有粗暴地全部 fail-closed，  
而是按风险对象做了分层。

### 6.1 拉取与缓存层：availability-first

`src/services/remoteManagedSettings/index.ts:413-442,492-501` 很清楚：

1. 拉取失败时优先使用 stale cache
2. 没 cache 时继续 without remote settings
3. 整体是 fail-open / graceful degradation

这是因为这里守的是：

`远程设置分发的可用性`

在这个层面，  
错误阻断整个 CLI 的代价太高。

### 6.2 危险变更层：security-first

但 `remoteManagedSettings/index.ts:456-467` 又明确写出：

1. 新 settings 若有内容，先做 security check
2. 若用户拒绝，新的 settings 不应用
3. 继续使用 cached settings

再结合 `securityCheck.tsx:15-20,38-70`：

1. 危险设置变化会弹 blocking dialog
2. `approved / rejected / no_check_needed` 三态分明
3. `rejected` 时 `gracefulShutdownSync(1)`

而 `ManagedSettingsSecurityDialog/utils.ts:20-23,44-62,87-117` 又把危险对象定义得很明确：

1. 不在 `SAFE_ENV_VARS` 白名单中的 env var 都算危险
2. 危险 shell settings 单独抽出
3. hooks 只要存在就算危险对象
4. 任何危险对象变更都触发 prompt

这就形成了很高级的分层：

1. 远程设置拉取本身：availability-first
2. 危险设置应用：security-first

所以 Claude Code 不是单纯 fail-open，也不是单纯 fail-closed。  
它是在问：

`当前失败发生在“获取配置”层，还是发生在“危险变更生效”层？`

这是非常先进的 failure semantics。

## 7. `Remote Control / trusted device`：高安全远程能力采用多重前置门

`src/entrypoints/cli.tsx:132-159` 对 `/bridge` 路径的处理非常能说明问题。

进入 Remote Control 前，  
系统先依次要求：

1. 当前有 OAuth access token
2. GrowthBook 禁用原因不存在
3. 最小版本满足
4. `allow_remote_control` policy 被允许

也就是说，  
Remote Control 不是“功能可用就进入”，  
而是：

`主体、版本、实验门、组织策略都先过门。`

再结合 `src/bridge/bridgeApi.ts:27-35` 和 `src/bridge/trustedDevice.ts:15-31,54-59,89-97`：

1. Bridge API 支持额外的 `X-Trusted-Device-Token`
2. 这是给 `SecurityTier=ELEVATED` 的 bridge session 用的
3. trusted device enrollment 还受 fresh-session 时间窗约束
4. token 进入 keychain，且 gate 打开前甚至不会发送

这说明高安全远程能力的放行不是“多一个 header”这么简单，  
而是：

`先证明你是对的主体、对的组织、对的设备、对的话题、对的时机。`

这也是不对称性：

1. 想拿到 elevated remote control，要穿过多重正证明门
2. 任何一门缺失，都可以直接阻断

## 8. `MCP OAuth step-up`：对 scope 升级的怀疑优先于“先 refresh 试试”

`src/services/mcp/auth.ts:1345-1353,1461-1470,1625-1650` 非常精彩。

作者明确写出：

1. `403 insufficient_scope` 不是普通 token 过期
2. RFC 6749 §6 禁止用 refresh 做 scope elevation
3. 所以检测到 `insufficient_scope` 后，应标记 `step-up pending`
4. 随后故意省略 `refresh_token`，迫使 SDK 走 PKCE auth flow

这里的关键不是技术细节，  
而是它背后的安全哲学：

`当错误语义已经表明“你缺的不是 freshness，而是 authority”，系统不能再拿低级恢复路径瞎试。`

也就是说：

1. 普通过期：可以 refresh
2. scope 不足：必须 step-up

这是一种非常强的语义不对称：

`更高权限不能从更低权限的恢复路径里自然长出来。`

这也是 Claude Code 安全设计先进性的直接体现。

## 9. 哲学本质：Claude Code 保护的不是“动作”，而是“谁有资格让系统继续说‘可以’”

把前面的源码合起来，  
会得到一个更深的结论：

Claude Code 的安全系统真正保护的对象，  
不是单个命令、单个按钮、单个 API 调用。

它保护的是：

`谁有资格让系统继续维持“允许、连接、已就绪、可继续”的叙事。`

具体来说：

1. auto mode 中旧 allow 不能自动继承
2. 组织绑定查不到就不能继续说“你是对的组织”
3. 危险 managed settings 未批准就不能继续说“这些设置可生效”
4. bridge 缺主体/策略/设备证明就不能继续说“Remote Control 可用”
5. MCP scope 不足就不能继续说“refresh 后也许还能接着用”

所以 Claude Code 的安全哲学不是：

`尽量晚一点拦。`

而是：

`只要继续说“可以”所需的证明链断了，就要立刻停止那条真相叙事。`

## 10. 技术启示：多重安全技术的先进性到底先进在哪里

从技术角度看，这套系统先进的地方不在“花样多”，  
而在三点：

1. 它把不同风险对象分配给不同 failure semantics
   availability 相关可以 stale/fail-open，主权/权限/高危配置相关则更偏 fail-closed。
2. 它把“缺证”建模成正式状态，而不是异常旁注
   `needs-auth`、`pending step-up`、trusted-device missing、org validation failed 都不是 incidental error。
3. 它把恢复路径与风险语义强绑定
   token 过期走 refresh；scope 不足走 step-up；危险设置变更走 blocking approval；auto mode 先 strip dangerous rules。

这三点组合起来，就是一种很强的设计能力：

`不是把所有风险都交给一个中心分类器，而是让不同控制面按各自风险语义做最合适的真相管理。`

## 11. 苏格拉底式反思：如果我想把这套设计再推进一层，还该继续问什么

可以继续追问八句：

1. 哪些低风险 fail-open 路径未来会被误用到高风险对象
2. 哪些高风险 veto 仍然缺少用户可解释性
3. auto mode 的 strip / restore 是否应该可视化成显式账本
4. `needs-auth`、`insufficient_scope`、org-mismatch 是否都应被统一成更清晰的用户语义
5. 危险 managed settings 的批准是否应绑定更强 signer，而不只是交互确认
6. bridge trusted device 的证明链是否应向用户显式暴露剩余时效与当前缺口
7. 哪些阻断仍然只是“能拦”，还没有做到“拦得可解释”
8. 当前系统对中国等高波动网络环境用户的 fail-closed 成本是否仍偏高

这些问题共同指向一个更高层判断：

`Claude Code 已经拥有很成熟的不对称安全真相管理，但它还可以继续把这种不对称性产品化、可解释化、低误伤化。`

## 12. 一条硬结论

Claude Code 安全设计的真正先进性，  
不只在于它有 classifier、hooks、managed settings、policy、trusted device、step-up auth 这些零件，

而在于它把这些零件统一成了同一种安全哲学：

`高风险放行需要更强证明；证明链一旦断裂，系统就应更早阻断、降级或改走更高认证路径。`

这使它保护的从来不只是某个动作，  
而是：

`系统继续说“可以”的资格。`

