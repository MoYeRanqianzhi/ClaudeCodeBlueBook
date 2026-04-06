# useManageMCPConnections、toolExecution 与 print 的连续性治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `172` 时，
真正需要被单独钉住的已经不是：

`cleanup 线即便已经知道对象现在 ready 不 ready，`

而是：

`cleanup 线即便已经能回答“现在能不能用”，谁来决定这份可用性在断连、失鉴权、失败重试与时间流逝中怎样继续成立。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`readiness governor 不等于 continuity governor。`

这句话还不够硬。
所以这里单开一篇，只盯住：

- `src/services/mcp/useManageMCPConnections.ts`
- `src/services/tools/toolExecution.ts`
- `src/cli/print.ts`
- `src/tools/ReadMcpResourceTool/ReadMcpResourceTool.ts`

把 auto-reconnect、stale timer cleanup、manual reconnect、runtime downgrade、SDK client re-init 与 consumer hard gate 并排，
逼出一句更硬的结论：

`Claude Code 已经在 MCP 线上明确展示：当前 ready 只是时间轴上的一个瞬时 verdict；真正更强的制度问题是这份 ready truth 在断连、退化、重试、放弃和系统重建中由谁继续维持。cleanup 线当前缺的不是这种思想，而是这套 continuity governance 还没被正式接到旧 path、旧 promise 与旧 receipt 世界上。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 readiness，没有 continuity。`

而是：

`Claude Code 已经在 MCP 线上明确把“当前能不能用”和“这种可用性接下来怎样维持”拆成两层；cleanup 线当前缺的不是文化，而是这套 continuity governance 还没被正式接到旧 cleanup artifact family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| continuity budget | `src/services/mcp/useManageMCPConnections.ts:87-90` | 为什么 repo 把“继续争取可用性多久”建模成正式制度参数 |
| disconnect -> retry lifecycle | `src/services/mcp/useManageMCPConnections.ts:333-466` | 为什么 ready truth 断掉后不是立刻结束，而是进入有 budget 的 continuity process |
| reload / stale continuity cleanup | `src/services/mcp/useManageMCPConnections.ts:765-853` | 为什么旧 reconnect timer 和旧 continuity attempt 不能越级冒充 current world |
| operator continuity control | `src/services/mcp/useManageMCPConnections.ts:1043-1123` | 为什么 manual reconnect、disable 与 re-enable 都在改写 continuity authority |
| runtime readiness revocation | `src/services/tools/toolExecution.ts:1599-1628` | 为什么 ready truth 会被运行时证据持续撤销 |
| SDK pool continuity repair | `src/cli/print.ts:1392-1426` | 为什么 continuity 不只是单连接问题，而是 current usable pool 的持续维持问题 |
| current-time consumer gate | `src/tools/ReadMcpResourceTool/ReadMcpResourceTool.ts:78-95` | 为什么 consumer 只验证当前 readiness，不自动签 continuity |

## 4. `useManageMCPConnections()` 先证明：continuity 是时间过程，不是状态标签

`useManageMCPConnections.ts:87-90` 很值钱。

这里不是简单写一句“断了就重连”，
而是先定义三条 continuity constitution：

1. 最多重试五次
2. 从 1 秒开始指数退避
3. 最长退避不超过 30 秒

这说明 repo 追问的已经不是：

`此刻是不是 ready`

而是：

`ready truth 一旦中断，系统接下来还愿意为它维持多久的连续性。`

`333-466` 则把这条制度真正落成时间语法。

这里在 `onclose` 之后：

1. 先判定对象是否已 disable
2. remote transport 才进入 automatic reconnect
3. 每次 attempt 前都显式改成 `pending`
4. 成功时回到 `connected`
5. 达到上限时正式 give up
6. 每次失败后按指数 backoff 再尝试下一次

从第一性原理看，
这已经不再是单纯的 readiness state machine，
而是：

`readiness breaks -> continuity process begins`

repo 公开拒绝把一个 ready verdict 当作天然可持续的真相。

## 5. stale reconnect timer 清理再证明：continuity 还要回答“哪条持续线才是 current”

`765-853` 的 value 不只在于它会把新对象置成 `pending`。

更值钱的是它在处理 stale plugin clients 时，
会优先：

1. 清掉旧 reconnect timer
2. 对旧 connected client 解除 `onclose`
3. 再按新的 configs 重建当前 pending world

这条证据很硬。
它说明 continuity 不是：

`只要某条重试线还在跑，就说明系统还在维持连续性`

而是：

`只有与 current config、current session 对齐的尝试线，才配继续代表 continuity truth`

这对 cleanup 线极其重要。
因为将来旧 path、旧 promise、旧 receipt 即便已经回到当前世界，
也仍不自动说明：

`之前那条 continuity attempt 仍然合法。`

如果 current truth 已换，
旧 continuity 线本身也必须被撤销。

## 6. manual reconnect 与 toggle path 再证明：continuity 是可被人类显式治理的操作主权

`1043-1123` 继续把问题收紧。

这里的 `reconnectMcpServer()` 和 `toggleMcpServer()` 明确展示出：

1. manual reconnect 会先取消已有 pending reconnect，再开一条新的 continuity line
2. disable 不只是 UI 状态变化，而是要先停掉一切正在进行的 retry
3. re-enable 不是直接假装 continuity 已恢复，而是先进入 `pending`，再重新争取 ready truth

这说明 continuity governance 不是背景线程自己“慢慢修”的黑盒。
它已经是一个正式的操作面：

`谁有权继续试`
`谁有权停下`
`谁有权重启`

如果 cleanup 线未来没有对应语法，
那么它即便补出了 ready / not-ready，
也仍然回答不了：

`对象一旦掉出 ready，后面到底该继续抢救，还是正式宣布 continuity 结束。`

## 7. `toolExecution.ts` 证明：continuity 从 ready truth 被撤销的那一刻开始

`toolExecution.ts:1599-1628` 很硬。

这里在 `McpAuthError` 时，
会把一个本来是 `connected` 的 client 降成：

`type: 'needs-auth'`

而且只在它之前真的 connected 时才改。

这说明 repo 已经公开承认：

1. ready truth 不是永久席位
2. runtime evidence 可以撤销 ready truth
3. 撤销之后系统必须进入新的 continuity judgment

从技术角度看，
这是比“有 retry loop”更强的证据。

因为它说明 continuity 的起点不一定是 transport close，
也可以是：

`当前 ready 的对象被新的运行时证据判定为不再可靠。`

这也正是 cleanup 线未来最难但最值钱的一层：

`对象不是因为消失才失去 continuity；它也可能在仍然存在时失去连续可用性。`

## 8. `print.ts` 证明：continuity 还存在 pool-level grammar，而不只是 per-client grammar

`print.ts:1392-1426` 特别值钱。

这里不只检查：

`有没有新 server 或被删掉的 server`

还继续检查：

1. `hasPendingSdkClients`
2. `hasFailedSdkClients`

只要这些条件成立，
就整批重新执行 `setupSdkMcpClients()`。

这说明 continuity 不只是：

`单个对象掉线了怎么办`

更是：

`当前 usable pool 还能不能继续被当成一个整体成立`

这条证据把 continuity 的主权层级提高了。
它不只属于 node-level lifecycle，
还属于 current system pool 的重新稳定化。

因此对 cleanup 研究来说，
未来真正难的并不只是为单个旧对象写 continuity grammar，
还包括：

`旧对象群一旦部分退化，谁配决定整个 current usable world 是否要整体重建。`

## 9. `ReadMcpResourceTool` 给出反向提醒：current-time hard gate 很硬，但它不是 continuity signer

`ReadMcpResourceTool.ts:78-95` 很有启发。

它对 consumer 说得非常硬：

`不是 connected 就别读`

这条 gate 非常先进，
因为它防止 consumer 用弱事实消费强对象。

但这条代码也恰好提醒我们：

`consumer hard gate 很硬，不等于 continuity question 已经被回答。`

它只验证：

`当前能不能读`

并不验证：

`接下来是否还能继续读`

所以 continuity governor 不能被偷写成 consumer gate 的附属物。

## 10. 这篇源码剖面给主线带来的四条技术启示

### 启示一

repo 已经在 reconnect budget 上明确展示：

`ready broken != continuity over`

### 启示二

repo 已经在 stale timer cleanup 上明确展示：

`continuity attempt != current continuity truth`

### 启示三

repo 已经在 runtime downgrade 上明确展示：

`ready now != ready a moment later`

### 启示四

repo 已经在 SDK pool re-init 上明确展示：

`single node ready != current usable pool continuity`

这四句合起来，
正好说明为什么 cleanup 线未来不能把 readiness governance 直接偷写成 complete continuity。

## 11. 一条硬结论

这组源码真正说明的不是：

`cleanup 线未来只要补出 readiness governance，就已经足够成熟。`

而是：

`repo 在 useManageMCPConnections 的 auto-reconnect/backoff/cancel/give-up path、toolExecution 的 runtime downgrade、print 的 pending/failed SDK pool re-init，以及 ReadMcpResourceTool 的 current-time hard gate 上，已经明确展示了 continuity governance 的存在；因此 artifact-family cleanup readiness-governor signer 仍不能越级冒充 artifact-family cleanup continuity-governor signer。`

因此：

`cleanup 线真正缺的不是“谁来宣布现在能用”，而是“谁来决定这种可用性在时间里如何继续成立、退化、恢复或停止”。`
