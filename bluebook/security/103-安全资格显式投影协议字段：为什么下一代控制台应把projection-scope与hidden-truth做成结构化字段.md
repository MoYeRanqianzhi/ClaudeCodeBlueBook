# 安全资格显式投影协议字段：为什么下一代控制台应把projection-scope与hidden-truth做成结构化字段

## 1. 为什么在 `102` 之后还必须继续写“显式投影协议字段”

`102-安全资格完成差异显化` 已经回答了：

`系统不应让用户自己猜某个 surface 漏看了什么，而应显式提示投影盲区。`

但如果继续往下追问，  
还会碰到一个更工程化的问题：

`这种“显式提示”到底应该靠什么落地？`

如果答案只是：

`靠每个组件自己写几句提示`

那仍然不够。  
因为这会把最关键的控制面语义继续散落在：

1. 注释
2. 局部 JSX 文案
3. 每个 surface 自己的临时判断

这样一来，  
投影诚实性就仍然只是实现习惯，  
而不是协议能力。

所以 `102` 之后必须继续补出的下一层就是：

`安全资格显式投影协议字段`

也就是：

`下一代统一安全控制台应把 projection scope、visible truth subset、hidden truth hint、handoff route 等做成结构化字段，而不是散落在注释和文案里。`

## 2. 最短结论

从源码看，Claude Code 当前已经拥有投影分层所需的大量原始信号，  
但仍缺少一层统一字段协议：

1. AppState 已有 bridge / MCP / plugin 的大量原始状态位  
   `src/state/AppStateStore.ts:133-215`
2. Notification 类型只有 `key/priority/timeout/fold` 等展示控制字段，没有 projection scope 或 hidden-truth 声明字段  
   `src/context/notifications.tsx:5-33`
3. `BridgeStatusInfo` 只有 `label/color`，没有“这是窄投影还是完整投影”的结构化标记  
   `src/bridge/bridgeStatusUtil.ts:113-140`
4. `/status` 明明是 aggregate projection，却只在注释里说明自己是 counts-only  
   `src/utils/status.tsx:96-114`

所以这一章的最短结论是：

`Claude Code 现在已经有足够的真相输入，但还缺少一套统一的 projection protocol fields 来把这些真相如何被不同 surface 投影显式编码出来。`

再压成一句：

`真相已有，字段未成。`

## 3. 源码已经给出“字段化”的四个信号，只是还没收口成统一协议

## 3.1 AppState 已经是底层 truth carrier，但不是 projection carrier

`src/state/AppStateStore.ts:133-215` 很值得细看。

这里已经有：

1. `replBridgeConnected`
2. `replBridgeSessionActive`
3. `replBridgeReconnecting`
4. `replBridgeError`
5. `mcp.clients/tools/commands/resources`
6. `mcp.pluginReconnectKey`
7. `plugins.needsRefresh`

这些都足以支撑非常丰富的 completion/projection 语义。  
但问题在于：

它们回答的是：

`底层真相是什么`

却没有回答：

`某个 surface 当前应投影哪一部分真相、遗漏哪一部分真相`

所以 AppState 目前更像：

`truth ledger`

而不是：

`projection ledger`

## 3.2 Notification 类型只编码展示行为，没有编码解释边界

`src/context/notifications.tsx:5-33` 里，`Notification` 目前包含：

1. `key`
2. `invalidates`
3. `priority`
4. `timeoutMs`
5. `fold`
6. `text` / `jsx`

这套字段对队列管理很成熟，  
但它完全没有编码：

1. 这是哪个 projection scope
2. 该通知只展示哪部分真相
3. 用户若要看更多应跳去哪里
4. 它禁止用户从这条通知里推导什么更强结论

这说明 notification 现在是：

`delivery protocol`

而不是：

`projection protocol`

## 3.3 `BridgeStatusInfo` 只有 label/color，说明投影层级还停留在隐式约定

`src/bridge/bridgeStatusUtil.ts:113-140` 中的 `BridgeStatusInfo` 只有：

1. `label`
2. `color`

这对于渲染桥接状态足够，  
但它并没有表达：

1. 当前这份 label 基于哪些 inputs
2. 它是 full bridge truth 还是 narrow footer truth
3. 它是否遗漏了 failed / detail / action route
4. 若用户要看更全的控制面应该 handoff 到哪里

于是不同组件只能靠：

1. 额外布尔位
2. 注释
3. 组件外部约束

来维持投影边界。

这就说明字段还没真正成协议。

## 3.4 `/status` 已有 summary 语义，却没有显式 `projection_kind='aggregate'`

`src/utils/status.tsx:96-114` 的注释已经直接承认：

1. 不想让 per-server rows 主导 Status pane
2. 所以只 show counts by state + `/mcp` hint

这说明 `/status` 明明已经是典型的：

`aggregate projection`

可这种性质并没有被编码成字段，  
仍然只是写在注释里的设计意图。

这意味着任何后续 surface 如果想复用 `/status` 的语义，  
都必须重新猜：

`这个 summary 到底是因为缺能力，还是因为故意降级`

这就是没有显式 projection fields 的代价。

## 4. 从第一性原理看，统一控制台至少缺哪几类 projection fields

如果完全从第一性原理出发，  
一个真正诚实的统一安全控制台，  
至少应把以下字段显式编码出来：

## 4.1 `projection_scope`

用于回答：

`这个 surface 当前到底是 full / aggregate / notification / narrow operational / local detail 哪一种投影层。`

建议值例如：

1. `authoritative_control`
2. `aggregate_summary`
3. `notification_only`
4. `narrow_operational`
5. `local_detail`

## 4.2 `visible_truth_subset`

用于回答：

`这个 surface 当前真正看见了哪些 completion facts。`

例如：

1. `bridge.failed`
2. `bridge.reconnecting`
3. `mcp.counts_only`
4. `mcp.server.connected`
5. `mcp.server.tools_present`

## 4.3 `hidden_truth_hint`

用于回答：

`当前有哪些相关真相并未在此处展示，用户不应误解为不存在。`

例如：

1. `failure_details_routed_to_notifications`
2. `server_level_detail_hidden`
3. `auth_substate_not_shown_here`
4. `completion_signer_detail_hidden`

## 4.4 `overclaim_ceiling`

用于回答：

`此处最多允许把文案说到什么程度。`

它与前文的 lexical ceiling 一致，  
但现在变成显式结构化字段，  
不再只靠组件作者自觉。

## 4.5 `handoff_route`

用于回答：

`如果用户要看更全真相或完成下一步，应转去哪一个 stronger surface。`

例如：

1. `/mcp`
2. `/remote-control`
3. `/status`
4. `/reload-plugins`

## 4.6 `forbidden_inference`

用于回答：

`用户在当前 surface 上最不该据此推导出的错误结论是什么。`

例如：

1. `no_notification != all_clear`
2. `connected != effectively_authenticated`
3. `not_shown_here != not_present`
4. `summary != detailed_control_plane`

这类字段一旦显式存在，  
投影诚实性才真正从“理念”落到“协议”。

## 5. 为什么这些字段不是锦上添花，而是解决当前散落语义的最低成本办法

目前系统已经有很多“半结构化”语义：

1. 注释说 footer 不展示 failed
2. 注释说 `/status` 只做 count
3. 某些通知隐式附带 `/mcp`
4. 某些 menu 通过 `connected && tools > 0` 定义更强完成语义

这些东西若继续散落在组件里，  
就会导致三个问题：

1. 新 surface 无法稳定复用旧语义
2. 不同 surface 的投影边界难以统一评审
3. 用户无法从结构层面理解“这里看见的是子集”

而如果把它们收口成上面的字段协议，  
则会得到三种直接收益：

1. 工程复用
   新控制台、新通知、新 footer 都能按字段渲染
2. 评审明确
   可以审查字段，而不是审查散落注释
3. 用户诚实
   可以把字段直接翻译成 UI disclosure

## 6. 技术先进性：Claude Code 现在离“字段化协议”只差最后一层产品化

这一章最值得强调的技术判断是：

`Claude Code 的先进性并不在于它缺乏统一协议，而在于它已经把统一协议所需的底层真相和局部纪律几乎全都准备好了。`

也就是说，  
它现在处在一个非常好的位置：

1. truth signals 已经有
2. 状态语法已存在
3. 路由与禁令已存在
4. completion-signer 也已存在
5. projection difference 也能从代码里读出来

它真正缺少的，  
只是把这些语义从：

`分布式习惯`

收口为：

`显式协议字段`

这恰恰是成熟系统最值得做的下一步。

## 7. 哲学本质：字段化不是技术细节，而是把诚实性制度化

很多人会把这种工作理解成：

`再加几个字段`

但这其实是对问题的低估。

从哲学上看，  
字段化的本质是：

`把“诚实地承认自己看见了多少真相”从开发者美德，升级为系统制度。`

只有字段化之后：

1. 真相范围
2. 盲区范围
3. handoff 责任
4. 禁止推论

才真正能被机器、评审、UI 和用户共同消费。

所以这一步并不是实现打磨，  
而是：

`控制面诚实性的制度化。`

## 8. 苏格拉底式自我反思

可以继续问六个问题：

1. 如果现在已经能从注释里读出 projection scope，为什么还不把它正式写进类型系统？
2. 如果 notification 已经承担特定投影职责，为什么 `Notification` 类型里还没有 `projection_scope` 与 `handoff_route`？
3. 如果 `BridgeStatusInfo` 只含 `label/color`，是否已经不足以支撑下一代统一控制台？
4. 如果 `/status` 是 aggregate projection，为什么它还没有显式声明自己不是 detailed control plane？
5. 如果很多 overclaim 风险已经被研究出来，为什么还不把 `forbidden_inference` 作为结构字段？
6. 下一代控制台若想真正统一，这些字段该放在 AppState projection layer、view model，还是专门的 security control-plane schema 中？

这些追问说明：

Claude Code 的下一代机会已经非常明确：  
不是去重新发明安全真相，  
而是把已有真相的投影语义结构化。

## 9. 对目录结构与后续研究的启发

写到这里，这条资格安全链已经推进成十层：

1. 资格对象
2. 重签发路径
3. 中间态语法
4. 承诺上限
5. 默认动作路由
6. 错误路径禁令
7. 动作完成权
8. 完成投影
9. 完成差异显化
10. 显式投影协议字段

所以下一步最自然的深化方向会是：

`统一安全控制台的卡片/字段落位设计`

也就是从字段协议继续推进到：

`这些字段在真正的 UI 上该如何摆放、优先级如何排序、哪些必须抢占。`

## 10. 给系统设计者的技术启示

最后把这一章压成六条工程启示：

1. 先把 truth signals 与 projection semantics 区分开来
2. 为每个 surface 显式编码 projection_scope，而不是继续靠注释
3. 把 hidden_truth_hint 与 handoff_route 做成结构字段，减少局部文案承担的逻辑负担
4. 把 overclaim_ceiling 与 forbidden_inference 结构化，避免新 surface 越权
5. 不要把 aggregate surface、notification surface、local detail surface 混成一种 view model
6. 真正成熟的统一控制台，必须同时统一 truth 和 truth projection

这一章最终要守住的一条硬结论是：

`对 Claude Code 这类安全控制面来说，下一代最值得做的不是再加更多零散提示，而是把“看见了什么、没看见什么、该去哪看更多”做成结构化协议字段。`
