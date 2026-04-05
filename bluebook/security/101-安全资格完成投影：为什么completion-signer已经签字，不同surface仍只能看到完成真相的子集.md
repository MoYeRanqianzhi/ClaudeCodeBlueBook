# 安全资格完成投影：为什么completion-signer已经签字，不同surface仍只能看到完成真相的子集

## 1. 为什么在 `100` 之后还必须继续写“完成投影”

`100-安全资格动作完成权` 已经回答了：

`只有对应 completion-signer 才有资格宣布修复动作真的完成。`

但如果继续往下追问，  
还会遇到一个更微妙的问题：

`completion-signer 已经签字之后，所有界面是不是就都能看到同一份完整完成真相？`

答案也是否定。

因为控制面里的不同 surface，  
往往只能看到：

`完成真相的某个投影子集`

而不是完整真相本体。

这就是 `100` 之后必须继续补出的下一层：

`安全资格完成投影`

也就是：

`即便 authoritative signer 已经签字，不同 surface 仍只能按自己的视角看到完成真相的子集，因此任何 surface 都不该越权冒充“完整完成控制台”。`

## 2. 最短结论

从源码看，Claude Code 已经表现出很清楚的 completion projection 分层：

1. BridgeDialog 能看到较完整的 bridge status inputs：`error`、`connected`、`sessionActive`、`reconnecting`  
   `src/components/BridgeDialog.tsx:137-156`
2. PromptInputFooter 刻意不看 `error`，并且对 implicit remote 只显示 reconnecting，说明 footer 只允许投影 completion 真相的极窄子集  
   `src/components/PromptInput/PromptInputFooter.tsx:173-185`
3. `useReplBridge` 把 failed 明确路由到 notification，而不是 footer pill，说明失败投影被分配到了另一个 surface  
   `src/hooks/useReplBridge.tsx:102-112,339-349`
4. MCP notifications 只投影 failed / needs-auth 这类“仍需动作”的问题，不投影 connected 成功真相  
   `src/hooks/notifs/useMcpConnectivityStatus.tsx:30-63`
5. `/status` 视图只做按状态计数聚合，不给单 server 级 completion 细节  
   `src/utils/status.tsx:96-114`
6. MCPRemoteServerMenu 甚至不把 `connected` 本身当成足够完成信号，而是进一步要求 `connected && tools > 0` 才视为 effectively authenticated  
   `src/components/mcp/MCPRemoteServerMenu.tsx:88-100`

所以这一章的最短结论是：

`completion 真相已经成立，不代表每个 surface 都有资格把它完整说出来。`

再压成一句：

`完成是一份真相，投影却可以分层。`

## 3. bridge 域已经清楚区分了“完整状态面”和“窄投影面”

## 3.1 BridgeDialog 看到的是较完整的 bridge status truth bundle

`src/components/BridgeDialog.tsx:137-156` 里，  
BridgeDialog 用的是：

1. `error`
2. `connected`
3. `sessionActive`
4. `reconnecting`
5. `getBridgeStatus(...)`

这说明 Dialog 这类主控制面拿到的是较完整的状态输入。  
它有资格根据多个字段推导：

1. failed
2. reconnecting
3. active
4. connecting

也就是说，  
BridgeDialog 更接近：

`完整完成控制面`

## 3.2 PromptInputFooter 故意只拿一个窄子集，说明它被制度性降级了

`src/components/PromptInput/PromptInputFooter.tsx:173-185` 非常关键。

这里作者明确写出：

1. failed state 由 notification surface 承担，不在 footer pill 中显示
2. 调 `getBridgeStatus(...)` 时故意传 `error: undefined`
3. implicit remote 场景下，只显示 `Remote Control reconnecting`

这意味着 footer 并不是一个“简化版完整控制台”，  
而是：

`受限投影面`

它被制度性剥夺了两种权力：

1. 展示 failed truth 的权力
2. 在 implicit remote 下展示除 reconnecting 外其余状态的权力

所以从安全语义看，  
PromptInputFooter 并不是缺实现，  
而是被有意降级为：

`只显示最低必要 completion projection`

## 3.3 这说明“没显示”不等于“没发生”，而是“这个 surface 不配说”

这一点非常重要。

很多系统会把：

`某 surface 上没显示的状态`

误读成：

`系统里不存在这份状态真相`

Claude Code 这里明显不是这样。

BridgeDialog 能看到的，  
footer 不一定能看到；  
footer 不显示 failed，  
不代表 failed 不存在；  
而只是：

`failed 的解释主权被分配给了另一个 surface。`

这就是完成投影的核心：

`真相统一，表达分层。`

## 4. useReplBridge 进一步证明：失败投影被有意识地路由到 notification，而不是所有 surface 共享

## 4.1 `notifyBridgeFailed()` 说明 failed 真相有自己的投影宿主

`src/hooks/useReplBridge.tsx:102-112` 定义的 `notifyBridgeFailed(detail?)` 很值得注意：

1. 用 notification surface
2. `key: 'bridge-failed'`
3. 文案为 `Remote Control failed`
4. 可附带 detail
5. priority 为 `immediate`

这说明 bridge failure 真相不是“全局无差别显示”，  
而是：

`被定向投影到 notification plane`

## 4.2 失败状态写回 AppState 后，footer 仍然不显示它，证明这是 deliberate projection split

`src/hooks/useReplBridge.tsx:339-349` 在 failed 分支里明确写回：

1. `replBridgeError`
2. `replBridgeReconnecting: false`
3. `replBridgeSessionActive: false`
4. `replBridgeConnected: false`

这说明失败真相已经进入状态层。  
可 footer 依然故意不展示 failed。

所以这是个很有力的证据：

`同一份失败真相同时存在于状态层，但只被允许在 notification surface 完整投影。`

这不是信息缺失，  
而是投影权限边界。

## 5. MCP 域同样证明：不同 surface 对 completion 真相的粒度完全不同

## 5.1 notification surface 只投影“仍需动作”的异常态，不投影 success

`src/hooks/notifs/useMcpConnectivityStatus.tsx:30-63` 的设计非常典型。

它只在以下状态时发 notification：

1. failed local clients
2. failed claude.ai connectors
3. needs-auth local servers
4. needs-auth claude.ai servers

也就是说，  
notification surface 的作用不是播报：

`哪些已经 connected`

而是只播报：

`哪些 completion 没成立，还需要动作`

所以 notification 是：

`repair-needed projection`

而不是：

`full completion projection`

## 5.2 `/status` 只做按 state 的计数汇总，故意不暴露单体 completion 细节

`src/utils/status.tsx:96-114` 更进一步。

这里 `/status` 对 MCP 只做：

1. `connected` count
2. `pending` count
3. `needsAuth` count
4. `failed` count
5. 再附上 `/mcp` hint

这说明 `/status` 的投影粒度是：

`aggregated completion view`

它并不回答：

1. 哪个 server connected
2. 哪个 server tools 已可用
3. 哪个 server auth half-complete

所以 `/status` 看见的 completion 真相，  
天然比 `/mcp` 这类专用控制面更窄。

## 5.3 MCPRemoteServerMenu 又把 connected 再次细分成“真正有效的 auth projection”

`src/components/mcp/MCPRemoteServerMenu.tsx:88-100` 非常有价值。

这里作者定义：

`isEffectivelyAuthenticated = server.isAuthenticated || (server.client.type === 'connected' && serverToolsCount > 0)`

这说明在 menu surface 里，  
甚至：

`connected`

都不总是足以代表更强的完成语义。

必须进一步满足：

`tools > 0`

才配被投影成 effectively authenticated。

这进一步证明：

`completion projection 可以在不同 surface 上被再次收紧。`

也就是说，  
同一个 connected 真相，  
在不同 surface 中的可说上限仍然不同。

## 6. 为什么完成投影必须分层，而不能让所有 surface 说同样满的话

把 bridge 与 MCP 合起来看，  
至少存在四种不同投影层：

1. `authoritative control surface`
   看到更完整 truth bundle
2. `narrow operational surface`
   只显示极少必要状态
3. `notification surface`
   只显示仍需动作的异常或阻断
4. `aggregate status surface`
   只显示 counts / summary，而非单体真相

如果把这些 surface 都要求成“显示同样满的话”，  
就会出现三类问题：

1. 窄 surface 过度承诺
2. notification surface 被成功态噪音淹没
3. 聚合 surface 冒充详细控制台

所以完成投影分层不是实现偶然，  
而是：

`为了让不同 surface 只承担自己配承担的解释权。`

## 7. 哲学本质：真相可以统一，解释权不必平均分配

这一章最重要的哲学结论是：

`安全控制面的成熟，不要求所有界面说同样的话，而要求所有界面只说自己配说的话。`

也就是说：

1. completion 真相是统一的
2. 但 surface 看到的是子集
3. 解释权因此必须分层

这和前面的：

1. 状态语法
2. 承诺上限
3. 默认动作路由
4. completion-signer

其实是一脉相承的。

它们都在回答同一类问题：

`谁在什么条件下，配说到什么程度。`

## 8. 第一性原理：为什么“所有地方都显示同样信息”反而更危险

如果从第一性原理问：

`为什么不把 completion 真相统一同步到所有 surface，让所有地方都显示一样？`

答案是：

`因为不同 surface 的认知成本、动作责任和可见上下文不同。`

如果硬做成一样，  
通常只会发生两件事：

1. 要么统一降到最弱，失去实用性
2. 要么统一升到最满，让弱 surface 过度承诺

Claude Code 的选择更成熟：

`让真相统一存在，但让投影按 surface 责任分级。`

## 9. 苏格拉底式自我反思

可以继续问六个问题：

1. BridgeDialog 与 footer 的投影差异是否已经在用户心智里足够清楚，还是仍可能被误解成状态不一致？
2. notification surface 是否应该更明确地声明“这里只显示仍需动作的问题，而不代表系统全貌”？
3. `/status` 的 counts 投影是否应显式提醒“这是 summary，不是 detailed control plane”？
4. MCPRemoteServerMenu 里的 effectively authenticated 是否还应继续拆出更显式的证据字段，而不只留在局部逻辑里？
5. completion-signer 已经存在，但 surface projection 权限是否仍缺少统一 schema 化表达？
6. 下一代安全控制台是否应把 `authoritative / aggregated / notification / narrow operational` 这些投影层显式编码出来？

这些追问说明：

Claude Code 已经有了很成熟的投影意识，  
但还可以继续把它从零散组件纪律提升成统一的 projection protocol。


## 11. 给系统设计者的技术启示

最后把这一章压成六条工程启示：

1. 不要要求所有 surface 说同样满的话
2. authoritative surface、notification surface、aggregate surface 应承担不同解释责任
3. 弱 surface 应主动限制自己可投影的 completion truth 子集
4. 成功态与失败态不一定应该出现在同一投影层
5. 连接成功、auth 有效、tools 可用、session active 这些完成语义可以继续细分
6. 若不治理投影权限，局部 surface 很容易冒充完整控制台

这一章最终要守住的一条硬结论是：

`对 Claude Code 这类安全控制面来说，真正成熟的不是让所有界面同步同一句完成文案，而是让每个界面只投影自己配拥有的那一部分完成真相。`
