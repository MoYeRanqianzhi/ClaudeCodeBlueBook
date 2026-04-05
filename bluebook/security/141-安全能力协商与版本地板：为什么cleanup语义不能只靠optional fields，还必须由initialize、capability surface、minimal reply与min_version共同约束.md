# 安全能力协商与版本地板：为什么cleanup语义不能只靠optional fields，还必须由initialize、capability surface、minimal reply与min_version共同约束

## 1. 为什么在 `140` 之后还必须继续写“能力协商与版本地板”

`140-安全遗忘契约兼容迁移` 已经回答了：

`cleanup 语义进入宿主生态时，不能粗暴强推，而必须通过 optional fields、降级语法、假成功防护与兼容回退渐进发布。`

但如果继续追问，  
还会碰到一个更深的问题：

`宿主到底凭什么宣布“我已经具备理解这套新安全语义的资格”？`

因为 `optional fields` 只能解决一部分问题：

1. 它能让旧 payload 不立即崩
2. 它能让新字段先进入 schema
3. 但它不能自动证明当前宿主已经懂得如何解释、消费、确认和回传这些字段

这意味着：

`兼容迁移若只有 optional fields，而没有能力协商与版本地板，系统仍可能在“能解析”与“真理解”之间发生严重偷换。`

所以 `140` 之后必须继续补的一层就是：

`安全能力协商与版本地板`

也就是：

`一套安全语义何时才能被当前宿主合法使用，不应由宿主自我想象，而应由 initialize、capability surface、minimal reply、version floor 与 unsupported verdict 共同界定。`

## 2. 最短结论

Claude Code 当前源码已经很清楚地展示出四条成熟原则：

1. 会话开始时先做 `initialize` 级别的显式协商，而不是默认两端天然同构  
   `src/entrypoints/sdk/controlSchemas.ts:57-95`  
   `src/cli/print.ts:4339-4508`
2. 当当前上下文只能提供部分能力时，返回 minimal reply，而不是假装完整镜像  
   `src/bridge/bridgeMessaging.ts:265-304`
3. 能力不是靠猜测存在，而是通过 capability / version surface 显式声明后再消费  
   `src/entrypoints/sdk/coreSchemas.ts:168-218`  
   `src/cli/print.ts:1277-1385`  
   `src/cli/print.ts:1666-1699`
4. 某些路径一旦版本过低或 secret grammar 不匹配，就必须直接拒绝，而不是继续 best-effort 兼容  
   `src/bridge/envLessBridgeConfig.ts:34-37,60-67,139-153`  
   `src/bridge/bridgeEnabled.ts:150-173`  
   `src/bridge/workSecret.ts:5-18`

这些证据合在一起说明：

`Claude Code 的高级安全性不只在于“字段如何加进去”，还在于“谁配说自己已经懂得这些字段”。`

因此这一章的最短结论是：

`cleanup 语义未来若要真正进入宿主生态，除了 optional fields 外，还必须有显式 capability surface、最小能力回复、明确 unsupported verdict，以及必要时直接卡住的 version floor。`

再压成一句：

`安全契约的升级，不只是发布新真相，还要发布“谁配理解这份真相”。`

## 3. 第一性原理：为什么“能解析”不等于“有资格消费”

如果一个宿主说：

`这个字段我没报错。`

这不等于：

`这个字段的语义我真的有资格消费。`

从第一性原理看，  
安全语义要被合法消费，至少要满足四件事：

1. 宿主知道这是不是本次会话正式协商过的能力
2. 宿主知道自己当前拿到的是完整能力面还是被缩域后的子集
3. 宿主知道当前版本是否还在被允许消费这套语法
4. 宿主在不支持时会诚实退让，而不是继续输出强词

如果缺这四件事，  
就会出现四类经典失真：

1. 把“能 parse”误说成“能解释”
2. 把“最小可见子集”误说成“全部能力”
3. 把“版本过低”误说成“暂时没显示”
4. 把“当前不支持”误说成“执行成功”

所以从第一性原理看：

`安全协商的本质不是交换功能清单，而是划定资格边界。`

## 4. Claude Code 已经把 initialize 做成一场正式协商，而不是随手附带参数

### 4.1 `initialize` request 明确声明“本次会话准备谈什么”

`src/entrypoints/sdk/controlSchemas.ts:57-75` 里，  
`SDKControlInitializeRequestSchema` 一开始就把下面这些对象放进正式 request：

1. `hooks`
2. `sdkMcpServers`
3. `jsonSchema`
4. `systemPrompt`
5. `appendSystemPrompt`
6. `agents`
7. `promptSuggestions`
8. `agentProgressSummaries`

这说明 Claude Code 的哲学不是：

`先开跑，后面靠隐式副作用慢慢补齐会话能力。`

而是：

`会话开始时先讲清楚，这次会话允许携带哪些能力与配置。`

### 4.2 `initialize` response 则正式宣布“当前会话到底开放了哪些能力面”

`src/entrypoints/sdk/controlSchemas.ts:77-95` 又把 `initialize` response 做成正式 schema：

1. `commands`
2. `agents`
3. `output_style`
4. `available_output_styles`
5. `models`
6. `account`
7. `pid`
8. `fast_mode_state`

这说明初始化不是单向灌配置，  
而是一次带回应的能力协商。

### 4.3 `handleInitialize` 还明确规定：这场协商只能发生一次

`src/cli/print.ts:4355-4366` 非常关键。  
如果已初始化，再来一次 `initialize`，系统不会“尽量合并”，而是直接返回：

1. `Already initialized`
2. 同时把 `pending_permission_requests` 带回去

这说明 `initialize` 在 Claude Code 里更像：

`会话宪法签署时刻`

而不是：

`随时可重写的弱配置补丁`

这点对 cleanup 迁移很重要。  
因为 cleanup contract version、cleanup projection level、cleanup-supported actions 这类东西，  
更适合在正式协商面上声明，  
而不是等到会话跑到一半再让宿主自己猜。

## 5. 最小能力回复比“看起来更完整的回复”更安全

`src/bridge/bridgeMessaging.ts:265-304` 给出了一种非常成熟的设计：

1. 在 outbound-only 模式下，除 `initialize` 外的 mutating request 一律 error
2. 但 `initialize` 仍必须 success，否则服务器会直接杀连接
3. 于是 bridge 给出的不是“伪完整回复”，而是 minimal reply：
   `commands: []`
   `output_style: 'normal'`
   `available_output_styles: ['normal']`
   `models: []`
   `account: {}`
   `pid`

这里的关键不是字段少，  
而是哲学正确：

`当前上下文能安全承诺多少，就只回复多少。`

这说明 Claude Code 的成熟点不在于“尽量把看起来像完整 CLI 的外形补齐”，  
而在于：

`当当前环境只能证明一个最小能力面时，它宁可返回窄真相，也不返回丰满谎言。`

对 cleanup 迁移的启示非常直接：

1. 旧宿主不配看到完整 cleanup provenance 时，可以只返回 legacy-compatible minimal surface
2. 但不能把 minimal surface 伪装成 full cleanup support
3. 更不能让“没报错”被用户误读成“cleanup contract 已 fully negotiated”

## 6. Claude Code 已经把“能力需声明后才能消费”写进 MCP 生态

### 6.1 `McpServerStatusSchema` 已经公开承认：version 与 capabilities 是正式 surface

`src/entrypoints/sdk/coreSchemas.ts:168-218` 里，  
MCP server status 不是只报 `connected / failed` 这种粗状态，  
还允许显式带出：

1. `serverInfo.version`
2. `tools`
3. `capabilities.experimental`

这说明在 Claude Code 看来：

`能力不是隐含在“连上了”三个字里，能力应当是被显式暴露的状态对象。`

### 6.2 `print.ts` 不会无条件透传 capabilities，而是先按 allowlist 缩域

`src/cli/print.ts:1666-1699` 更关键。  
这里对 `experimental['claude/channel']` 的处理不是“有就转发”，  
而是：

1. 先检查 feature gate
2. 再检查 channel 是否 allowlisted
3. 不符合就删掉这个 experimental capability

注释还写得很直白：

`不是安全边界，只是避免 dead buttons`

这说明即便在非硬安全边界上，  
团队也不接受：

`宿主看到一个自己其实不能安全消费的 capability，再让用户点出死按钮。`

这恰恰是一种很强的协商诚实性。

### 6.3 `elicitation` handler 也只在能力已声明时才注册

`src/cli/print.ts:1277-1385` 继续把这个哲学往前推。

代码明确承认：

1. `setRequestHandler` 会在 client 没有声明 elicitation capability 时抛错
2. 因此注册被包在 `try/catch`
3. 不具备这个 capability 的 client 会被直接跳过

这里最值得注意的不是 `skip silently` 本身，  
而是：

`只有在能力已被正式声明的前提下，系统才尝试启用对应语义。`

这对 cleanup future design 的启示是：

1. cleanup consume / cleanup acknowledge / cleanup audit display 这类语义若未来出现
2. 不应仅靠字段存在来判断
3. 更稳妥的做法是要求显式 capability bit 或 contract version

否则宿主很容易落入一种危险的灰区：

`我看见了像是 cleanup 的东西，所以我应该懂。`

而源码在别处已经清楚表明，  
Claude Code 并不接受这种推断式资格。

## 7. 版本地板不是产品运营小技巧，而是安全资格闸门

### 7.1 v1/v2 bridge 各自拥有独立的 `min_version`

`src/bridge/envLessBridgeConfig.ts:34-37` 明确写出：

1. env-less v2 path 有自己的 `min_version`
2. 它与 v1 的 `tengu_bridge_min_version` 分离
3. 这样 v2 的 bug 可以单独强制升级，而不阻断 v1

`src/bridge/bridgeEnabled.ts:150-173` 与  
`src/bridge/envLessBridgeConfig.ts:139-153` 则分别为 v1 / v2 做版本检查。

这说明版本地板在这里的角色不是：

`提醒一下有新版本`

而是：

`当当前版本不再配安全消费这条远程控制路径时，直接取消资格。`

### 7.2 `initReplBridge` 真的会因为版本不够而拒绝进入该路径

`src/bridge/initReplBridge.ts:140-150` 先把 min-version 检查放进正式启动顺序里。  
到 `src/bridge/initReplBridge.ts:410-420,456-460`，  
无论 v2 还是 v1，只要版本过低，就：

1. `logBridgeSkip('version_too_old', ...)`
2. `onStateChange?.('failed', 'run \`claude update\` to upgrade')`
3. `return null`

这很关键。  
因为这意味着 Claude Code 的版本地板不是 advisory，  
而是：

`真正阻止你进入某条安全路径的 admission gate`

对 cleanup 迁移的启示就是：

某些高风险 cleanup semantics 未来如果会改变：

1. host 对“旧痕迹何时可清”的判断
2. host 对“谁签了 cleanup”的解释
3. host 对“能否把该失败从前台撤场”的行为

那么它们未必适合只靠 optional fields 慢慢放进来。  
其中一部分很可能需要：

`cleanup contract min version`

这部分是对现有 version-floor 哲学的推论，  
不是当前源码中已经存在的 cleanup 字段。

## 8. secret grammar version 说明：有些东西根本不配 best-effort 兼容

`src/bridge/workSecret.ts:5-18` 直接把 `decodeWorkSecret()` 写成：

1. 解码
2. 检查 `version`
3. 只接受 `version === 1`
4. 其余全部抛 `Unsupported work secret version`

这说明 Claude Code 在真正高风险的 credential / ingress grammar 上，  
采用的不是：

`尽量宽松兼容一下旧 secret`

而是：

`grammar version 不对，就直接拒绝。`

同文件 `src/bridge/workSecret.ts:34-47` 还表明 URL path 的 `v1 / v2` 也是显式构造出来的，  
而不是模糊混用。

这给 cleanup 设计一个很重要的上限提醒：

`不是所有新语义都该按 optional field 渐进迁移。`

如果某个 cleanup contract 会改变：

1. 审计可追溯性
2. 清理权限归属
3. 旧失败痕迹是否还能被保留

那它就更接近 secret grammar 这种“错了就不能含糊过去”的对象。

## 9. `system:init` 已经把 CLI version 作为正式真相发给宿主

`src/entrypoints/sdk/coreSchemas.ts:1457-1493` 里，  
`SDKSystemMessageSchema` 已正式包含：

1. `claude_code_version`
2. `permissionMode`
3. `mcp_servers`
4. `plugins`
5. `output_style`
6. `session_id`

这说明系统并不是完全缺少“宿主感知当前 CLI 版本”的 formal channel。  
也就是说，  
未来如果要继续推进 cleanup contract negotiation，  
并不一定要从零造一条版本真相通道。

更可能的现实路径是：

1. 复用已有 `claude_code_version`
2. 再补 dedicated cleanup contract version / capability bit
3. 让宿主根据 version + capability 共同决定自己配看到多强的 cleanup truth

这是基于现有 system message surface 做的推论，  
不是当前源码里已经存在的 cleanup capability 字段。

## 10. 对 cleanup 未来工程化的直接启示

综合以上源码，可以得到一个更成熟的 rollout 原则：

### 10.1 optional fields 只解决“词法进入”，不解决“资格进入”

所以 cleanup future design 至少应区分两层：

1. lexical admission  
   字段进入 schema，但可缺席
2. semantic admission  
   当前 host / bridge / surface 已被正式承认为懂得这套 cleanup truth

### 10.2 真正重要的不是“字段被看见”，而是“能力被宣布”

更安全的候选对象可能包括：

1. `cleanup_capabilities`
2. `cleanup_contract_version`
3. `supported_cleanup_actions`
4. `cleanup_projection_level`

这些名称是基于现有 capability/version 设计哲学做的推导，  
不是当前源码中已存在字段。

### 10.3 不同层要允许不同强度的 admission gate

从现有代码看，至少已有三种 gate：

1. optional-compatible gate
2. capability-declared gate
3. version-floor gate

cleanup future design 不应把所有语义都硬塞进第一类。

更合理的是：

1. 低风险显示字段走 optional-compatible gate
2. 交互动作走 capability-declared gate
3. 高风险清理签字语义走 version-floor gate

## 11. 我们当前能说到哪一步，不能说到哪一步

基于当前可见源码，  
我们可以稳妥地说：

1. Claude Code 已经拥有正式的 initialize 协商面
2. 已经拥有 minimal capability reply 的成熟实践
3. 已经把 capability/version 做成正式状态对象
4. 已经在高风险路径上使用 version floor 和 grammar version reject

但我们不能说：

1. cleanup capability 已经存在
2. cleanup contract version 已经存在
3. cleanup future rollout 已明确采用 version floor

所以这一章的证据边界必须压在：

`Claude Code 已经清楚展示出“安全语义升级不仅需要兼容迁移，还需要能力协商与版本地板”这一工程哲学；cleanup-specific 实现仍是顺着这条哲学向前推的合理下一步。`

## 12. 苏格拉底式追问：如果这章还要继续提高标准，还缺什么

还可以继续追问六个问题：

1. 哪些 cleanup semantics 只需要 optional-compatible gate，哪些必须升到 version-floor gate
2. cleanup capability 应该挂在 `initialize` response、`system:init` 还是 control response family
3. 低版本 host 收到新 cleanup fields 时，最小诚实 UI 文案应该是什么
4. cleanup contract version 是否应该与 projection level 分开
5. duplicate/orphan cleanup ack 是否需要独立 capability 才能消费
6. conformance tests 是否应覆盖“字段存在但 capability 未声明”的灰区

这些问题说明：

`兼容迁移解决的是“新语义怎么进来”，能力协商与版本地板解决的则是“谁配说自己已经跟上来了”。`
