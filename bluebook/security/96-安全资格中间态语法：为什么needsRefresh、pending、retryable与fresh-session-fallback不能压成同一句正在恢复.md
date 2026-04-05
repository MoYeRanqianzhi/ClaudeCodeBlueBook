# 安全资格中间态语法：为什么needsRefresh、pending、retryable与fresh-session-fallback不能压成同一句正在恢复

## 1. 为什么在 `95` 之后还必须继续写“资格中间态语法”

`95-安全资格重签发协议` 已经回答了：

`失效对象若想合法回来，必须走 regrant，而不能靠残留工件直接复活。`

但如果继续往下追问，  
还会遇到一个控制面表达层的问题：

`既然都不是 current，那这些“还没回来”的状态到底要怎么区分？`

如果系统把它们全都压成一句：

`正在恢复`

那就会立刻丢掉最关键的信息：

1. 这是还能 retry 的旧资格
2. 还是必须 fresh-session 的新资格
3. 这是等待用户显式 reload
4. 还是系统自己已放进 pending 连接队列
5. 这是可恢复中间态
6. 还是已经终局失效

所以 `95` 之后必须继续补出的下一层就是：

`安全资格中间态语法`

也就是：

`安全控制面必须把不同的资格中间态编码成不同语义，而不能把它们压成同一句“正在恢复”。`

## 2. 最短结论

从源码看，Claude Code 已经在多个子系统里自然长出了几类不同中间态：

1. `retryable resumable`
   旧资格本体未被证死，但当前尝试失败，可走同一路径再试  
   `src/bridge/bridgeMain.ts:2524-2539`
2. `fresh-session-fallback`
   原资格已断裂，系统不会续接，而是转入新资格签发  
   `src/bridge/bridgeMain.ts:2473-2489`
3. `needsRefresh`
   磁盘 materialization 已发生，但 active entitlement 尚未重新签发  
   `src/hooks/useManagePlugins.ts:287-303`; `src/utils/plugins/refresh.ts:123-138`
4. `pending`
   旧 MCP client 已降出 current，新资格正等待进入连接与发布链  
   `src/services/mcp/useManageMCPConnections.ts:817-839`
5. `disabled`
   当前策略不允许进入 regrant，必须先解除禁用  
   `src/services/mcp/useManageMCPConnections.ts:817-823`
6. `terminal-invalid`
   session 不存在或无 `environment_id`，旧资格已无继续路径  
   `src/bridge/bridgeMain.ts:2384-2408`

所以这一章的最短结论是：

`Claude Code 的安全性不只在于有中间态，还在于它拒绝把语义不同的中间态压扁成同一个恢复词。`

再压成一句：

`安全中间态不是缓冲区，而是语义护栏。`

## 3. bridge 子系统已经说明：不是所有“没成功”都叫恢复中

## 3.1 `terminal-invalid` 与 `retryable resumable` 是两种完全不同的世界

`src/bridge/bridgeMain.ts:2384-2408` 与 `src/bridge/bridgeMain.ts:2524-2539` 放在一起看很有力量。

同样都是 resume 没直接成功，  
系统却分得很清楚：

1. `session not found`
2. `session has no environment_id`

这两类会：

1. clear pointer
2. 报错退出
3. 不再维持旧资格的继续路径

而 transient reconnect failure 则不同：

1. 不 deregister
2. 不 clear pointer
3. 明说 `The session may still be resumable`
4. 指示 `try running the same command again`

这说明在 Claude Code 看来：

`失败` 不是单一语义。

至少要分成：

1. `terminal-invalid`
2. `retryable resumable`

如果把两者都压成“恢复失败”或“正在恢复”，  
用户就会失去最关键的信息：

`这条路到底还有没有资格继续走。`

## 3.2 `fresh-session-fallback` 也不是 retryable，而是资格换届

`src/bridge/bridgeMain.ts:2473-2489` 进一步说明另一类中间态：

1. 原 env 已 expired
2. 旧资格不能续接
3. 系统 warning：creating a fresh session instead

这不是 terminal-invalid，  
因为系统没有彻底终止工作。

这也不是 retryable resumable，  
因为系统没有让用户再次尝试恢复原资格。

它真正表达的是：

`旧资格结束了，但系统将进入新资格签发流程。`

这就是：

`fresh-session-fallback`

它的安全意义非常大。  
因为它明确阻止用户误以为：

`刚才还是同一个 session，只是后台帮我恢复了一下`

实际上不是。  
这是新资格，不是旧资格。

## 4. plugin 子系统已经说明：磁盘变化后的中间态不能被误说成已激活

## 4.1 `needsRefresh` 表示“变化已发生，但当前边界尚未承认”

`src/hooks/useManagePlugins.ts:287-303` 很直白：

1. plugin changed on disk
2. add notification
3. run `/reload-plugins` to activate
4. do not auto-refresh
5. do not reset `needsRefresh`

所以 `needsRefresh` 不是：

`快好了`

而是：

`变化已发生，但 active entitlement 尚未回到 current`

这是典型的：

`detected-but-not-regranted`

如果系统把它压成“插件已更新”或“正在刷新”，  
就会把用户引向错误预期：

`新权限已经在当前边界生效`

但源码明确拒绝这种说法。

## 4.2 `needsRefresh=false` 也不是时间自然流逝得到的，而是完整 refresh 的完成签字

`src/utils/plugins/refresh.ts:123-138` 明确把：

1. `needsRefresh: false`
2. `pluginReconnectKey + 1`

绑在同一轮完整 refresh 之后。

这说明 `needsRefresh` 的消失不是超时、不是视图切换、不是重新渲染，  
而是：

`full Layer-3 regrant 完成后的状态签字`

所以 plugin 子系统已经在源码里说得很清楚：

`needsRefresh` 是一个制度化中间态，不是一个松散提示词。

## 5. MCP 子系统已经说明：`pending` 与 `disabled` 也绝不是同一句“暂不可用”

## 5.1 `pending` 是“允许进入 regrant，但尚未完成”

`src/services/mcp/useManageMCPConnections.ts:817-839` 里，  
新 client 会被赋成：

1. `pending`
2. 或 `disabled`

其中 `pending` 的语义是：

`这个对象已被允许进入连接流程，但当前尚未完成签发。`

它意味着：

1. 路径仍开着
2. 资格正在申请
3. 下一步是 connect / publish

这和 “不可用” 不是一回事。  
因为 `pending` 仍带着明确的正向后续。

## 5.2 `disabled` 是“当前策略不允许它进入 regrant”

同一段源码里，  
若 `isMcpServerDisabled(name)`，  
则状态直接是 `disabled`。

这说明 `disabled` 和 `pending` 绝不能压成一类：

1. `pending`
   允许重签发，只是未完成
2. `disabled`
   当前连重签发入口都没打开

如果 UI 把两者统一说成“尚未连接”，  
用户就会误以为：

`它们只是等待时间不同`

实际上不是。  
一个要等连接完成，  
一个要先改策略。

这就是安全中间态语法的必要性。

## 6. 这些中间态为什么必须不可压平

把 bridge、plugins、MCP 合在一起，  
就能看出至少六种状态差异：

1. `terminal-invalid`
   路已断，旧资格无后续
2. `retryable resumable`
   路还在，旧资格仍可再试
3. `fresh-session-fallback`
   旧资格终止，但系统会签发新资格
4. `needsRefresh`
   变化已发生，等待显式用户动作完成 regrant
5. `pending`
   系统已接受 regrant 申请，等待连接与发布完成
6. `disabled`
   当前策略封死了 regrant 入口

这些状态如果被统一叫“恢复中”，  
就会引发三种严重后果：

1. 误承诺
   用户以为还是同一资格
2. 误动作
   用户选错下一步，例如等待一个其实不会自动恢复的状态
3. 误治理
   系统把策略封禁、等待连接、等待用户 reload、资格终局失效混成一类

所以安全中间态语法真正保护的是：

`正确预期、正确动作、正确治理`

## 7. 哲学本质：中间态的价值不在过渡，而在诚实

很多系统会把中间态理解成一种 UI 过渡动画，  
仿佛它只是为了“别闪太快”。

但 Claude Code 的这些状态说明，  
中间态真正值钱的地方不是过渡视觉，  
而是：

`它让系统有能力诚实地说出对象此刻到底处在什么制度位置。`

例如：

1. `needsRefresh`
   不是“插件快好了”，而是“尚未激活”
2. `pending`
   不是“连接大概快成了”，而是“已准入申请，未完成签发”
3. `fresh-session-fallback`
   不是“旧资格正在恢复”，而是“旧资格结束，新资格即将开始”
4. `retryable resumable`
   不是“已经失败”，而是“这条恢复路仍有价值”

因此从哲学上说：

`安全中间态是控制面诚实性的最小语法。`

## 8. 第一性原理与苏格拉底式追问

## 8.1 第一性原理

如果从第一性原理问：

`为什么安全系统不能把所有非-current 状态压成一个“处理中”？`

答案是：

`因为不同非-current 状态，对应的是不同的真相、不同的承诺上限、不同的下一步动作。`

一旦压平，  
系统就会同时失去：

1. 解释能力
2. 引导能力
3. 边界诚实性

## 8.2 苏格拉底式自我追问

可以继续问六个问题：

1. 如果 `pending` 与 `disabled` 的下一步完全不同，为什么用户界面还可以共用同一句文案？
2. 如果 `needsRefresh` 必须靠用户动作完成，为什么还会有人把它理解成“系统会自己处理”？
3. 如果 `fresh-session-fallback` 已是新资格，为何不在控制面上更强烈地区分“新会话”与“旧会话恢复”？
4. 如果 `retryable resumable` 仍有恢复价值，系统是否该把剩余 retry value 做成显式等级？
5. 如果 `terminal-invalid` 已无后续路径，系统是否总能避免给出任何暗示用户还能再等一等的文案？
6. 如果这些中间态已经在不同子系统里存在，为什么还没有被提升为统一的安全状态家族？

这些追问都指向同一个结论：

`下一代安全控制台不只要展示状态，还要展示状态语法。`


## 10. 给系统设计者的技术启示

最后把这一章压成六条工程启示：

1. 不要把所有非-current 状态压成同一句“恢复中”
2. 中间态必须绑定不同的 next action，而不是只换颜色
3. 用户驱动的 regrant 与系统驱动的 regrant 必须分开表达
4. retryable、fallback、disabled、pending、terminal-invalid 必须有不同承诺上限
5. 中间态消失必须由对应 signer 触发，而不是靠时间自然抹平
6. 状态语法越清楚，安全控制面越不容易误导用户

这一章最终要守住的一条硬结论是：

`对 Claude Code 这类安全控制面来说，中间态之所以重要，不是因为系统正在变化，而是因为系统必须在变化过程中持续说真话。`
