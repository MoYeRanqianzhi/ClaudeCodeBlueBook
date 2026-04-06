# 安全资格默认动作路由：为什么每一种资格状态都必须绑定唯一dominant-route，而不能把修复选择权外包给用户

## 1. 为什么在 `97` 之后还必须继续写“默认动作路由”

`97-安全资格承诺上限` 已经回答了：

`每一种状态只能说到自己的 lexical ceiling。`

但如果继续往下追问，  
还会遇到一个非常实际的问题：

`当系统已经诚实地说清当前状态后，它接下来应该把用户送去哪里？`

如果答案是：

`你自己看着办`

那前面的状态语法和承诺上限都会被削弱。  
因为用户仍要自己在多个动作里猜：

1. 是该 `/login`
2. 还是 `/mcp`
3. 还是 `/reload-plugins`
4. 还是 `/remote-control`
5. 还是直接重试原命令

所以 `97` 之后必须继续补出的下一层就是：

`安全资格默认动作路由`

也就是：

`每一种资格状态都应绑定唯一 dominant route，而不能把修复选择权外包给用户自己猜。`

## 2. 最短结论

从源码看，Claude Code 已经在多个子系统里自然形成了状态到动作的收口：

1. plugin changed / `needsRefresh` -> `/reload-plugins`  
   `src/hooks/useManagePlugins.ts:293-301`; `src/hooks/notifs/usePluginAutoupdateNotification.tsx:60-63`
2. MCP failed / needs-auth -> `/mcp`  
   `src/hooks/notifs/useMcpConnectivityStatus.tsx:36-60`; `src/components/mcp/MCPReconnect.tsx:48-61`
3. bridge no OAuth -> `/login`  
   `src/bridge/initReplBridge.ts:144-150`
4. bridge session expired -> `/remote-control` / `claude remote-control`  
   `src/bridge/replBridge.ts:2293-2297`; `src/bridge/bridgeApi.ts:472-490`
5. retryable resume failure -> retry the same command  
   `src/bridge/bridgeMain.ts:2524-2539`
6. env mismatch during resume -> fresh session path, not retry old resume path  
   `src/bridge/bridgeMain.ts:2484-2489`

所以这一章的最短结论是：

`Claude Code 不只是给状态命名，还在给状态绑定 dominant route。`

再压成一句：

`正确状态如果没有正确默认动作，安全控制面仍然是不完整的。`

## 3. plugin 子系统已经说明：`needsRefresh` 的 dominant route 只能是 `/reload-plugins`

## 3.1 notification 文案已经把动作空间收口到一条路径

`src/hooks/useManagePlugins.ts:293-301` 的文案是：

`Plugins changed. Run /reload-plugins to activate.`

这里值得注意的不是单纯提示了一个命令，  
而是它没有给出多选动作空间。

它没有说：

1. maybe wait
2. maybe restart
3. maybe reload

而是明确说：

`Run /reload-plugins`

这说明 `needsRefresh` 的 dominant route 是被系统刻意收口过的。

## 3.2 auto-update 通知也复用了同一路由，说明这不是偶然文案，而是制度

`src/hooks/notifs/usePluginAutoupdateNotification.tsx:60-63` 进一步说明：

即便是 plugin autoupdate，  
通知也依然说：

`Run /reload-plugins to apply`

这说明 plugin 域已经形成了一条稳定的动作纪律：

`只要问题本质是 active entitlement 尚未刷新，默认修复路径就是 /reload-plugins。`

从安全角度看，这很关键。  
因为它避免用户在：

`已 materialize、未 activate`

的状态下盲试无效动作。

## 4. MCP 子系统已经说明：failed 与 needs-auth 的 dominant route 都必须收口到 `/mcp`

## 4.1 failed 不该让用户猜网络、配置还是认证，而是先回 MCP 控制面

`src/hooks/notifs/useMcpConnectivityStatus.tsx:36-47` 对 failed local clients 与 failed claude.ai connectors 的提示都统一挂上：

`· /mcp`

这说明在 Claude Code 的制度里，  
MCP failed 的第一默认动作不是：

`等等看`

也不是：

`自己改配置文件`

而是：

`进入 /mcp 控制面`

因为只有在那里，  
用户才有机会看到更细的 server state 与 reconnect/auth controls。

## 4.2 needs-auth 也统一指向 `/mcp`，说明 dominant route 依赖的是控制域，而不是错误文本差异

同文件 `50-60` 行对 `needs auth` 的提示也统一挂了：

`· /mcp`

这很重要。  
因为虽然 `failed` 和 `needs-auth` 的原因不同，  
但它们共享同一个 dominant route：

`/mcp`

这说明动作路由的设计不是简单按报错字符串分流，  
而是按：

`哪一个控制面拥有这类资格问题的处置权`

来分流。

## 4.3 具体 reconnect 组件进一步把 auth 缺口收敛成 `/mcp to authenticate`

`src/components/mcp/MCPReconnect.tsx:48-61` 里对 `needs-auth` 的完成文案是：

`Use /mcp to authenticate.`

这又一次证明：

1. `needs-auth` 不是模糊等待态
2. 它的 dominant route 很明确
3. 该 route 不是任意 auth 命令，而是 MCP 域自己的控制面

所以 MCP 子系统在动作路由上非常成熟：

`状态分层不同，但入口仍统一收口到拥有处置权的 /mcp。`

## 5. bridge 子系统已经说明：不同失败类型必须指向不同 dominant route

## 5.1 no OAuth 是 `/login`，因为缺的是资格前提，不是连接性

`src/bridge/initReplBridge.ts:144-150` 很有代表性。

这里在检查到没有 OAuth token 时：

1. 不是给 policy error
2. 不是让用户重试 remote-control
3. 而是直接 `onStateChange('failed', '/login')`

这说明 bridge 域已经清楚区分：

`资格前提缺失`

和

`连接过程失败`

前者的 dominant route 必须是：

`/login`

因为不先补足前提，  
任何 remote-control 相关动作都会是错路。

## 5.2 session expired 是 `/remote-control`，因为缺的是 bridge session 本体

`src/bridge/replBridge.ts:2293-2297` 与 `src/bridge/bridgeApi.ts:472-490` 都把 expiry 文案收口到：

1. `/remote-control to reconnect`
2. `Please restart with claude remote-control or /remote-control`

这说明在 expiry 场景下，  
dominant route 不是 `/login`，  
也不是 retry 原 resume path，  
而是：

`重新建立 bridge session`

也就是说：

1. auth 缺口 -> `/login`
2. bridge session expiry -> `/remote-control`

这正是成熟动作路由的表现：  
不同断点去不同控制面，不乱引。

## 5.3 retryable resume failure 是“重试同一路径”，而不是切走到新控制面

`src/bridge/bridgeMain.ts:2524-2539` 的文案是：

`The session may still be resumable — try running the same command again.`

这说明该状态的 dominant route 不是：

1. `/remote-control`
2. `/login`
3. fresh session

而是：

`retry the same command`

因为此时旧资格仍有 retry value，  
系统不应过早把用户赶往别的域。

这说明动作路由同样受资格语义约束：

`还有旧资格价值时，默认动作应沿原路径继续，而不是跳域。`

## 5.4 env mismatch 则必须切走到 fresh-session path，不能让用户误以为继续 retry 有意义

`src/bridge/bridgeMain.ts:2484-2489` 的 warning 已经把路线说得很清楚：

`Creating a fresh session instead.`

这意味着 env mismatch 的 dominant route 不是 retry old session，  
而是：

`切换到新资格签发路径`

这很关键。  
因为它说明系统不是机械地把所有失败都指向同一类动作，  
而是根据：

`旧资格是否仍值得继续`

来决定默认路由。

## 6. 这些 dominant route 为什么必须唯一

把 plugin、MCP、bridge 合在一起看，  
可以抽出一个共同原则：

1. `needsRefresh` -> `/reload-plugins`
2. `mcp failed / needs-auth` -> `/mcp`
3. `no OAuth` -> `/login`
4. `session expired` -> `/remote-control`
5. `retryable resume` -> retry same command
6. `env mismatch` -> fresh session path

如果系统不收口到唯一 dominant route，  
就会出现三种问题：

1. 用户误动作
   例如在 auth 缺口时反复 `/remote-control`
2. 解释失真
   看似给了很多建议，实则没有明确责任域
3. 恢复路径分叉
   多条近似动作同时存在，用户难以判断哪条才是制度正路

所以 dominant route 的价值在于：

`把状态语义、权限归属与下一步动作压成一条链。`

## 7. 哲学本质：好的安全控制面不是“提示很多”，而是“把错路关掉”

这一章最重要的哲学结论是：

`安全控制面真正成熟，不在于它给用户很多可能动作，而在于它能把错误邻近动作从一开始就收掉。`

也就是说，  
默认动作路由的本质不是导航便利性，  
而是：

`动作空间治理`

当系统说：

1. `/reload-plugins`
2. `/mcp`
3. `/login`
4. `/remote-control`
5. retry same command

它其实是在做一件更深的事：

`把错误路径排除在默认世界模型之外。`

这正是安全设计的高级形态：

`不是只告诉你怎么修，而是先阻止你走错。`

## 8. 第一性原理与苏格拉底式追问

## 8.1 第一性原理

如果从第一性原理问：

`为什么一个状态除了要有名称和文案，还必须有 dominant route？`

答案是：

`因为状态本身并不完成修复，修复必须落到具体动作，而动作若不收口，状态语义就无法真正进入用户行为。`

所以安全控制面必须同时治理三件事：

1. state
2. promise
3. route

缺任何一个，  
控制面都是半成品。

## 8.2 苏格拉底式自我反思

可以继续问六个问题：

1. 如果 `/mcp` 已是 failed 与 needs-auth 的 dominant route，为什么某些 surface 还可能只显示 failed 而不显示 `/mcp`？
2. 如果 `/login` 与 `/remote-control` 分别对应 auth 缺口与 session expiry，当前界面是否总能避免把两者混成一个“连接失败”？
3. 如果 retry same command 只适用于 retryable resume，系统是否在其他 fatal 场景下也偶尔误给过同样提示？
4. 如果 plugin 变更一律走 `/reload-plugins`，是否所有相关 notification 与 command output 都已统一？
5. 如果 dominant route 的目标是收缩动作空间，哪些状态现在还存在两个以上几乎同等显眼的修复入口？
6. 如果动作路由也是协议，下一代安全控制台是否应把 dominant route 显式编码进状态 schema，而不是散落在文案里？

这些追问说明：

Claude Code 已经拥有很多正确路由，  
但还可以继续把它们从“实现习惯”提升为“显式协议”。


## 10. 给系统设计者的技术启示

最后把这一章压成六条工程启示：

1. 每个非-current 状态都应绑定唯一 dominant route
2. dominant route 应归属于拥有该问题处置权的控制域
3. auth 缺口、session expiry、资格换届、待激活、待连接不能共用同一默认动作
4. future action 应写进文案，而不是留给用户自己推理
5. 不要给用户多个近似等价的默认修复入口
6. 路由若不收口，状态与文案再准确也会在行为层失效

这一章最终要守住的一条硬结论是：

`对 Claude Code 这类安全控制面来说，真正成熟的不是告诉用户“出了问题”，而是把每一种问题直接送到唯一正确的修复路径上。`
