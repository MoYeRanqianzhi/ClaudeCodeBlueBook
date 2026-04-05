# 安全失败语义三分法：为什么Claude Code不把所有失败都压成deny，而是按风险对象选择fail-open、fail-closed与step-up

## 1. 为什么在 `126` 之后还必须继续写“失败语义三分法”

`126-安全真相的不对称性` 已经回答了：

`Claude Code 对高风险放行要求更强证明，而对阻断与降级允许更早触发。`

但如果继续追问，  
还会碰到一个更工程化的问题：

`这些“更早触发”的阻断，到底有哪些形态？`

因为如果只说：

`它会更保守`

仍然不够。  
源码实际上显示，Claude Code 并不是把所有失败都压成同一种 `deny`，  
而是按照风险对象把失败分成至少三种不同语义：

1. `fail-open`
2. `fail-closed`
3. `step-up`

这三种动作背后的系统哲学完全不同。

所以 `126` 之后必须继续补出的下一层就是：

`安全失败语义三分法`

也就是：

`Claude Code 不是简单决定“过/不过”，而是先决定当前失败属于 availability 问题、主权问题，还是授权层级问题，然后分别选择 fail-open、fail-closed 或 step-up。`

## 2. 最短结论

Claude Code 安全设计真正成熟的地方，不只是它在“放行”与“阻断”上不对称，  
还在于它对“失败”本身采用了分型治理。

从源码看：

1. 远程受管设置拉取失败时，系统选择 `fail-open` / stale degrade  
   `remoteManagedSettings/index.ts:413-442,492-501`
2. 强制组织绑定、Remote Control policy、危险受管设置变更被拒绝时，系统选择 `fail-closed`  
   `auth.ts:1920-1969`; `cli.tsx:151-159`; `securityCheck.tsx:63-72`
3. MCP OAuth 的 `403 insufficient_scope` 不被压成普通失败，而被提升为 `step-up auth`  
   `mcp/auth.ts:1345-1353,1461-1470,1625-1650`

所以这一章的最短结论是：

`Claude Code 不把所有失败都压成 deny，而是按风险对象选择 fail-open、fail-closed 与 step-up。`

再压成一句：

`失败不是一种状态，而是三种语义。`

## 3. 第一性原理：为什么成熟系统必须把失败分型

如果所有失败都被压成一种语义，  
系统会同时损失两种能力：

1. 它会对低风险、可恢复的 availability 问题过度阻断
2. 它会对高风险、主权相关的问题阻断得不够坚决

换句话说，  
单一失败语义只会迫使系统在“误伤”和“漏放”之间做粗糙取舍。

成熟系统不会这样。  
它会先问：

`这次失败意味着什么真相没有成立？`

如果没成立的是：

1. 配置分发的可用性
2. 身份/组织/策略主权
3. 授权级别与 scope

那失败动作就不该一样。

所以从第一性原理看，  
failure semantics 的成熟度，本质上是在看：

`系统能不能区分“现在不能用”与“你不配用”以及“你需要更高授权后再用”。`

## 4. `fail-open`：当守的是 availability，不是主权

`src/services/remoteManagedSettings/index.ts:413-442,492-501` 非常典型。

作者已经明写：

1. fetch/load remote settings
2. fetch 失败时优先使用 stale cache
3. 没 cache 时 continue without remote settings
4. 整体 `fail open`

这说明在 remote managed settings 的“获取层”，  
系统守护的主要对象不是高危动作放行，  
而是：

`远程配置分发的可用性`

在这个层面，  
错误地阻断整个 CLI 的代价太高，  
而继续沿用旧 cache 或无 settings 继续跑的代价相对较低。

所以 `fail-open` 在这里不是松懈，  
而是：

`一种经过风险计算的可用性优先。`

更重要的是，  
Claude Code 并没有把这个 `fail-open` 随便外溢到其他层。  
一旦进入危险设置“应用层”，语义立刻变化。

## 5. `fail-closed`：当守的是主权、身份与高危变更

这里至少有三条源码证据。

### 5.1 组织主权：`forceLoginOrg`

`src/utils/auth.ts:1920-1969` 明确写出：

1. 如果设置了 `forceLoginOrgUUID`
2. 又无法验证 token 的 org
3. 则 validation fails

而且它特别强调：

1. 本地可写缓存不可被信任
2. 必须去 authoritative profile endpoint 验

这就是典型的 `fail-closed`：

`查不到，不算通过。`

### 5.2 组织策略：Remote Control policy

`src/entrypoints/cli.tsx:151-159` 也很清楚：

1. 先等 policy limits load
2. 若 `allow_remote_control` 不允许
3. 直接 `exitWithError`

这里系统没有试图说：

`那就先弱化一下远程控制能力。`

而是直接 fail-closed。  
因为 Remote Control 守的是高安全远程能力，不适合在策略不明时半开放。

### 5.3 危险设置变更：用户拒绝即退出

`src/services/remoteManagedSettings/securityCheck.tsx:15-20,38-70` 和  
`src/components/ManagedSettingsSecurityDialog/utils.ts:20-23,44-62,87-117`
共同表明：

1. 危险 shell settings
2. 非白名单 env vars
3. hooks 变更

一旦发生变化，会弹 blocking dialog。  
而 `rejected` 路径会触发 `gracefulShutdownSync(1)`。

这又是另一类 `fail-closed`：

`高危配置若未获批准，不是弱化启用，而是直接不继续。`

## 6. `step-up`：当问题不是“你错了”，而是“你还不够”

`src/services/mcp/auth.ts:1345-1353,1461-1470,1625-1650` 是整套设计里最有技术味的一段。

作者明确把：

`403 insufficient_scope`

解释成：

`不是 token freshness 问题，而是 scope level 问题。`

于是系统不会：

1. 把它压成普通 `failed`
2. 也不会简单 `deny forever`
3. 更不会盲目 refresh

而是：

1. mark step-up pending
2. 故意省略 refresh token
3. 迫使 SDK 走 PKCE auth flow

这说明 `step-up` 是一种独立语义：

`当前授权等级不够，但可以通过更高证明路径重获资格。`

这与 `fail-closed` 完全不同。  
`fail-closed` 是：

`现在不允许，且当前这条链不该继续。`

而 `step-up` 是：

`现在不允许，但存在一条更高证明路径。`

这就是成熟系统与粗糙系统的差别。

## 7. 为什么 `step-up` 比普通错误更先进

因为很多系统会把所有异常都压成：

1. unauthorized
2. failed
3. retry later

但 Claude Code 这里清楚区分了：

1. token 过期
2. 组织不匹配
3. scope 不足
4. policy 不允许
5. 危险设置未批准

其中只有 scope 不足被识别为：

`需要更高层证明，而不是普通恢复或普通失败。`

这说明作者理解的不是“认证有没有过”，  
而是：

`当前失败位于哪一层授权阶梯。`

这是一种非常先进的权限语义建模。

## 8. 三分法背后的统一哲学

把前面的源码合在一起，  
会得到一张很稳定的图：

1. availability risk -> `fail-open`
2. sovereignty / identity / dangerous mutation risk -> `fail-closed`
3. insufficient authority level -> `step-up`

这三者不是三个杂乱特例，  
而是同一套哲学的三个分支：

`失败动作应当匹配失败所揭示的真相缺口。`

如果缺的是：

1. 配置拉取的可用性
   那就降级继续。
2. 主体与边界证明
   那就直接关闭。
3. 权限层级
   那就改走更高证明路径。

这就是为什么我把这一章叫做“失败语义三分法”。

## 9. 技术启示：多重安全技术真正先进的地方不是“层数多”，而是“失败动作对症”

从技术角度看，  
Claude Code 最值得学习的一点是：

`它没有把分类器、策略、认证、远程设置、MCP 连接都压进同一类 error handling。`

相反，它让不同控制面保留自己的 failure semantic：

1. cache/stale degrade
2. hard deny
3. step-up auth
4. capability stripping

这带来两个直接收益：

1. 不会因为高安全边界而把所有可恢复流程都卡死
2. 也不会因为追求顺滑体验而把主权边界放松

所以安全技术真正先进的地方，  
不在“组件多”，  
而在：

`对不同失败原因给出不同且正确的系统动作。`

## 10. 苏格拉底式反思：如果我想把这套三分法继续推进一层，还该问什么

可以继续追问八句：

1. 当前还有哪些失败路径其实属于 `step-up`，却仍被压成普通 `failed`
2. 哪些 `fail-open` 路径未来可能误入主权边界
3. 哪些 `fail-closed` 路径还缺少对用户的可解释降级说明
4. auto mode 的 dangerous rule strip 是否应被正式命名成第四类失败语义 `de-scope`
5. Remote Control 的 trusted-device 缺失是否应明确呈现为 “step-up device trust” 而非 generic auth failure
6. 受管设置危险变更的批准是否还应支持更细 signer 分层
7. 对中国等高波动网络环境用户，哪些 `fail-closed` 其实应该先转 `step-up` 或 `stale degrade`
8. 当前系统是否仍有把“权限层级问题”误归成“连接问题”的地方

这些问题共同指向一个更高层判断：

`Claude Code 的下一代安全产品化，不只是更多 gate，而是更细 failure taxonomy。`

## 11. 一条硬结论

Claude Code 安全设计的成熟，不只在于它知道何时该拦，  
还在于它知道：

`该用哪一种方式拦。`

对于可用性问题，它会 `fail-open`。  
对于主权与高危变更问题，它会 `fail-closed`。  
对于授权层级不足问题，它会 `step-up`。

这说明它保护的不是抽象的“安全感”，  
而是：

`不同风险对象所要求的正确失败方式。`

