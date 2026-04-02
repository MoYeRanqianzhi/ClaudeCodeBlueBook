# 安全资格动作完成权：为什么走上正确修复路径不等于资格已恢复，必须由对应completion-signer宣布完成

## 1. 为什么在 `99` 之后还必须继续写“动作完成权”

`99-安全资格错误路径禁令` 已经回答了：

`不仅要指出正确修复路径，还要封死近邻错路。`

但如果继续往下追问，  
还会遇到一个更关键的问题：

`即便用户已经走上了正确路径，系统又凭什么宣布这条路径已经完成？`

如果答案是：

`动作发起了，所以算完成`

那前面的路径治理仍然不够。  
因为：

1. `/reload-plugins` 发出，不等于所有 active components 已重新签发
2. bridge transport connect 发起，不等于 session 已真正回到 connected
3. `/mcp` reconnect 点下去，不等于 server 已经 connected

所以 `99` 之后必须继续补出的下一层就是：

`安全资格动作完成权`

也就是：

`正确动作的发起不等于完成，只有对应 completion-signer 才有资格宣布资格已恢复。`

## 2. 最短结论

从源码看，Claude Code 在 bridge、plugins、MCP 三条线上都在坚持同一原则：

1. action initiation 只是开始
2. completion 必须由 authoritative result 签字
3. 在 completion-signer 兑现前，系统不配撤销中间态或给出满额承诺

最关键的证据有三组：

1. bridge 的 `onStateChange('connected')` 明确延迟到 initial flush 完成后才触发，避免把“transport 已连上”误说成“session 已恢复 active”  
   `src/bridge/replBridge.ts:1234-1240,1306-1328`
2. plugin 的 `needsRefresh=false` 只在 `refreshActivePlugins()` 完成 full Layer-3 refresh 后写回，同时 bump `pluginReconnectKey`，说明 `/reload-plugins` 的 completion-signer 是完整 state swap，而不是命令本身  
   `src/utils/plugins/refresh.ts:59-71,72-138`
3. MCPReconnect 只有在 `result.client.type === 'connected'` 时才 `onComplete("Successfully reconnected ...")`；若是 `needs-auth/pending/failed/disabled`，则 completion 不成立  
   `src/components/mcp/MCPReconnect.tsx:40-62`

所以这一章的最短结论是：

`安全恢复真正被签发的不是“动作已执行”，而是“资格已重新成立”。`

再压成一句：

`路径可以由用户触发，完成只能由 signer 宣布。`

## 3. bridge 子系统已经明确：连接建立不等于资格恢复完成

## 3.1 `connected` 信号之所以值钱，是因为它被刻意延后到 flush 之后

`src/bridge/replBridge.ts:1234-1240` 已经把原则写得很清楚：

1. initial flush 只在 first connect 时执行
2. `onStateChange('connected')` 被 deferred until flush completes
3. 这样可以防止历史消息与新消息交错
4. 也延迟了 web UI 显示 session active 的时机

这说明 bridge 团队非常清楚：

`transport 连上`

和

`资格恢复完成`

不是同一时刻。

如果系统在 transport connect 的那一刻就宣布 `connected`，  
就会把：

`尚未持久化、尚未完成历史回放的中间态`

提前包装成

`已恢复 active`

Claude Code 刻意避免了这种错签字。

## 3.2 guard 逻辑说明 even flush completion 也必须由当前 transport 签字

`src/bridge/replBridge.ts:1306-1313` 进一步说明：

1. 如果 flush 期间 transport 被替换
2. stale transport 的 `.finally()` 不得 signal connected
3. 新 transport 才拥有 lifecycle

这说明 completion-signer 不只是某个事件，  
而是：

`当前 authoritative owner 的事件`

换句话说：

`旧对象的完成通知，即使看起来在时间上“更晚”，也不配替当前对象签字。`

这是一条非常硬的安全原则。

## 3.3 无需 flush 的路径也只有在 gate 真实清空后才配 connected

`src/bridge/replBridge.ts:1315-1328` 里，  
如果没有 initial messages 或已完成 first flush，  
系统才会：

1. clear/draint flushGate
2. `onStateChange('connected')`

这说明 completion 仍然受条件约束，  
不是 connect 回调天然附带的礼物。

所以 bridge 域的 completion-signer 本质上是：

`满足一致性前提后的 current transport`

而不是：

`任何成功连上的 socket`

## 4. plugin 子系统已经明确：`/reload-plugins` 不是完成，完整 Layer-3 swap 才是完成

## 4.1 `refreshActivePlugins()` 的注释已经把 completion signer 写在了函数边界里

`src/utils/plugins/refresh.ts:59-71` 明确说：

1. refresh all active plugin components
2. clears all plugin caches
3. consumes `plugins.needsRefresh`
4. increments `mcp.pluginReconnectKey`

这说明 `/reload-plugins` 这条路径在设计上就被理解为：

`一个需要完整函数边界来完成签字的协议动作`

不是输入命令的那一瞬间，  
也不是 UI 收到通知的那一瞬间。

## 4.2 真正的完成签字发生在 `needsRefresh=false` 与 `pluginReconnectKey+1`

`src/utils/plugins/refresh.ts:123-138` 是关键落点。

这里在 full load、commands/agents 派生、MCP/LSP 补全之后，  
才一次性写回：

1. `needsRefresh: false`
2. `pluginReconnectKey: +1`

这说明 plugin 域的 completion-signer 不是：

`用户按下命令`

而是：

`完整 active state swap 已经落地`

只有到这一刻，  
系统才配把：

`待激活`

改口成

`已完成 refresh`

## 4.3 为什么这里不能由 notification 或 slash command 本身宣布完成

因为它们都只知道：

1. 用户想做这件事
2. 或用户刚开始做这件事

它们并不知道：

1. caches 是否真正清空
2. commands / agents 是否真正重载
3. MCP / LSP 是否真正纳入新状态

所以从第一性原理看：

`知道“动作被触发”不等于知道“资格已重新成立”。`

这就是 plugin completion-signer 必须落在 full Layer-3 refresh 内部的原因。

## 5. MCP 子系统已经明确：reconnect 按钮不是 signer，`result.client.type` 才是 signer

## 5.1 reconnect 尝试结束后，只有 `connected` 结果配签字成功

`src/components/mcp/MCPReconnect.tsx:40-46` 很清楚：

1. 调用 `reconnectMcpServer(serverName)`
2. `switch (result.client.type)`
3. 只有 `case "connected"` 时：
   `onComplete("Successfully reconnected ...")`

这说明 UI action 的完成签字不属于按钮点击事件，  
而属于：

`authoritative result type`

即使按钮点下去了、异步函数也返回了，  
如果 result 不是 `connected`，  
那 completion 就不成立。

## 5.2 `needs-auth/pending/failed/disabled` 结果都说明 completion 不能偷跑

同一段 `48-62` 又说明：

1. `needs-auth`
   不是 success，而是切到 auth path
2. `pending/failed/disabled`
   统一走 failure branch

这表明 MCP 域很清楚：

`reconnect attempt 结束`

和

`资格恢复完成`

是两回事。

completion-signer 必须具有足够强的 truth value。  
只有 `connected` 才够。

## 5.3 为什么这条原则很先进

很多系统会在“重试按钮返回 200”时就提示 reconnect success。  
Claude Code 没这么做。

它要求：

`最终 client state 本身`

来决定 success / failure / auth gap。

这说明 completion 在这里是状态驱动的，  
不是动作驱动的。

这正是成熟控制面的先进性：

`不拿动作回执冒充资格回执。`

## 6. completion-signer 的本质：谁有资格让系统停止修复叙事

把 bridge、plugins、MCP 合在一起，  
completion-signer 的共同定义就很清楚了：

1. 它必须掌握最终真相
2. 它必须足以撤销中间态
3. 它必须足以把文案 ceiling 升到更高状态
4. 它必须足以把 dominant route 从“继续修复”切到“恢复完成”

换句话说，completion-signer 真正拥有的不是“说完成”这句话，  
而是：

`停止修复叙事的权力`

谁没有这个权力，  
谁就不该提前把状态改成完成。

## 7. 哲学本质：完成权是控制面里最容易被偷走的一层主权

这一章最重要的哲学结论是：

`在安全控制面里，最容易被偷走的主权不是开始动作的权力，而是宣布动作完成的权力。`

因为宣布完成带来的收益很大：

1. 提示可以消失
2. 用户焦虑会下降
3. 系统看起来更顺滑
4. 状态机会显得更简单

但也正因为如此，  
很多系统会忍不住让：

1. 按钮点击
2. optimistic update
3. 网络返回
4. 局部 view 刷新

来偷走 completion 权。

Claude Code 在这些路径上的成熟点就在于：

`它宁可延迟一点宣布完成，也不让错误层级提前签字。`

## 8. 第一性原理：为什么没有 completion-signer 的修复路径仍然不可信

如果从第一性原理问：

`为什么系统即便已有正确路径、正确文案、正确状态，仍必须继续治理 completion-signer？`

答案是：

`因为只要 completion 仍可被低权限层提前宣布，前面所有治理都会在最后一步被短路。`

也就是说：

1. 正确路径会被 premature success 掏空
2. 中间态语法会被 optimistic completion 掏空
3. 承诺 ceiling 会被越权完成词掏空
4. 错误路径禁令会被“看起来已修好”绕开

所以安全链条最后一定会落到：

`谁有资格说“现在真的好了”`

## 9. 苏格拉底式自我反思

可以继续问六个问题：

1. bridge 域除了 flush-complete 之外，是否还有别的 connected projection 在更弱信号上偷跑？
2. plugin 域的 `needsRefresh=false` 是否已经覆盖所有 active entitlement，而不仅是 commands/agents 的子集？
3. MCP 域除了 `result.client.type === connected` 之外，是否还需要更强条件，例如 tools/resources 真的可见？
4. 当前 UI 是否总能把“动作已发起”与“动作已完成”在文案上区分开？
5. 是否所有中间态的消失都绑定到了相应 completion-signer，而不是 timeout 或弱投影？
6. 下一代安全控制台是否应把 completion-signer 做成显式 schema 字段，而不是隐含在不同子系统代码里？

这些问题说明：

Claude Code 已经具备 completion-signer 意识，  
但还可以更彻底地把它协议化、字段化、产品化。

## 10. 对目录结构与后续研究的启发

写到这里，这条资格安全链已经推进成七层：

1. 资格对象
2. 重签发路径
3. 中间态语法
4. 承诺上限
5. 默认动作路由
6. 错误路径禁令
7. 动作完成权

所以下一步最自然的深化方向会是：

`安全资格完成投影`

也就是继续回答：

`即便动作已被正确 signer 完成，不同宿主和不同 surface 是否仍只能看到这份完成真相的子集。`

## 11. 给系统设计者的技术启示

最后把这一章压成六条工程启示：

1. 不要把 action initiation 当作 completion
2. 让 completion 只由 authoritative result 签字
3. 中间态的清除必须绑定 completion-signer，而不是绑定按钮点击
4. optimistic success 应慎用在资格恢复路径上
5. 连接建立、命令执行、UI 刷新都不能替代真正的资格恢复完成
6. 若不治理完成权，前面所有状态治理都会在最后一步被短路

这一章最终要守住的一条硬结论是：

`对 Claude Code 这类安全控制面来说，真正成熟的不是修复路径存在，而是只有正确的 signer 才能宣布这条路径已经完成。`
