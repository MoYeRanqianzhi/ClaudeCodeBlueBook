# useManageMCPConnections、toolExecution与print的强请求清理连续性治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `332` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 旧对象现在能不能被继续使用，`

而是：

`stronger-request cleanup 旧对象即便此刻已经 ready，谁来决定这份可用性在断连、退化、重试、放弃、人工停表与 pool repair 中怎样继续成立。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`readiness governor 不等于 continuity governor。`

这句话还不够硬。
所以这里单开一篇，
只盯住：

- `src/services/mcp/useManageMCPConnections.ts`
- `src/services/tools/toolExecution.ts`
- `src/cli/print.ts`
- `src/tools/ReadMcpResourceTool/ReadMcpResourceTool.ts`

把 continuity budget、指数 backoff、final give-up、stale reconnect timer cleanup、manual reconnect、disable cancel、runtime downgrade、SDK client pool re-init 与 consumer hard gate 并排，
直接钉死 stronger-request cleanup 线当前仍缺的不是 current-time readiness，
而是 `temporal continuity governance grammar`。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 readiness，没有 continuity。`

而是：

`Claude Code 在 MCP 线上已经明确把“对象当前能不能用”和“这种可用性接下来怎样继续成立”拆成两层；stronger-request cleanup 线当前缺的不是这种文化，而是这套 continuity governance 还没被正式接到旧 cleanup artifact family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| continuity constitution | `src/services/mcp/useManageMCPConnections.ts:88-90` | 为什么 repo 把“继续争取可用性多久”建模成正式制度参数 |
| disconnect -> retry lifecycle | `src/services/mcp/useManageMCPConnections.ts:333-464` | 为什么 ready truth 断掉后不是立刻结束，而是进入有 budget 的 continuity process |
| reload / stale continuity cleanup | `src/services/mcp/useManageMCPConnections.ts:765-853` | 为什么旧 reconnect timer 和旧 continuity attempt 不能越级冒充 current world |
| operator continuity control | `src/services/mcp/useManageMCPConnections.ts:1043-1123` | 为什么 manual reconnect、disable 与 re-enable 都在改写 continuity authority |
| runtime readiness revocation | `src/services/tools/toolExecution.ts:1599-1628` | 为什么 ready truth 会被运行时证据持续撤销 |
| SDK pool continuity repair | `src/cli/print.ts:1392-1426` | 为什么 continuity 不只是单连接问题，而是 current usable pool 的持续维持问题 |
| current-time consumer gate | `src/tools/ReadMcpResourceTool/ReadMcpResourceTool.ts:78-95` | 为什么 consumer 只验证当前 readiness，不自动签 continuity |

## 4. `useManageMCPConnections()` 先证明：continuity 是时间过程，不是状态标签

`src/services/mcp/useManageMCPConnections.ts:88-90`
很值钱。

这里不是简单写一句“断了就重连”，
而是先定义三条 continuity constitution：

1. 最多重试五次
2. 从 1 秒开始指数退避
3. 最长退避不超过 30 秒

这说明 repo 追问的已经不是：

`此刻是不是 ready`

而是：

`ready truth 一旦中断，系统接下来还愿意为它维持多久的连续性。`

`src/services/mcp/useManageMCPConnections.ts:333-464`
则把这条制度真正落成时间语法。

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

`src/services/mcp/useManageMCPConnections.ts:765-853`
的价值不只在于它会把新对象置成 `pending`。

更值钱的是它在处理 stale plugin clients 时，
会优先：

1. 清掉旧 reconnect timer
2. 对旧 connected client 解除 `onclose`
3. 再按新的 configs 重建当前 pending world

这条证据很硬。
它说明 continuity 不是：

`只要某条重试线还在跑，就说明系统还在维持连续性`

而是：

`只有与 current config、current session、current plugin world 对齐的尝试线，才配继续代表 continuity truth`

这对 stronger-request cleanup 极其重要。
因为将来旧 path、旧 promise、旧 receipt 即便已经回到当前世界，
也仍不自动说明：

`之前那条 continuity attempt 仍然合法。`

如果 current truth 已换，
旧 continuity 线本身也必须被撤销。

## 6. manual reconnect 与 toggle path 再证明：continuity 是可被人类显式治理的操作主权

`src/services/mcp/useManageMCPConnections.ts:1043-1123`
继续把问题收紧。

这里的 `reconnectMcpServer()` 和 `toggleMcpServer()` 明确展示出：

1. manual reconnect 会先取消已有 pending reconnect，再开一条新的 continuity line
2. disable 不只是 UI 状态变化，而是要先停掉一切正在进行的 retry
3. re-enable 不是直接假装 continuity 已恢复，而是先进入 `pending`，再重新争取 ready truth

这说明 continuity governance 不是背景线程自己“慢慢修”的黑盒。
它已经是一个正式的操作面：

1. 谁有权继续试
2. 谁有权停下
3. 谁有权重启

从技术先进性看，
这里最值得学习的不是“提供了重连按钮”，
而是 repo 把按钮语义、timer 语义与 state transition
统一写进了同一条治理线。

## 7. `toolExecution.ts` 与 `print.ts` 证明：continuity 从 ready truth 被撤销的那一刻开始，并在 pool-level 上重建 current world

`src/services/tools/toolExecution.ts:1599-1628`
很硬。

这里在 `McpAuthError` 时，
会把一个本来是 `connected` 的 client 降成：

`type: 'needs-auth'`

而且只在原状态确实是 `connected` 时才改。

这说明 repo 已经公开承认：

1. ready truth 不是永久席位
2. runtime evidence 可以撤销 ready truth
3. 撤销之后系统必须进入新的 continuity judgment

从技术角度看，
这是比“有 retry loop”更强的证据。

因为它说明 continuity 的起点不一定是 transport close，
也可以是：

`当前 ready 的对象被新的运行时证据判定为不再可靠。`

`src/cli/print.ts:1392-1426`
特别值钱。

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

这一步把 continuity 从单连接鲁棒性
提升成了系统级自我修复能力。

## 8. `ReadMcpResourceTool` 给出反向提醒：current-time hard gate 很硬，但它不是 continuity signer

`src/tools/ReadMcpResourceTool/ReadMcpResourceTool.ts:78-95`
很有启发。

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

所以 stronger-request cleanup continuity governor
不能被偷写成 consumer gate 的附属物。

## 9. 更深一层的技术先进性：Claude Code 把“持续可依赖性”当成一等安全对象

这组源码给出的技术启示至少有四条：

1. 安全系统不能只建模 `state now`，还要建模 `state over time`
2. stale timer、old closure 与 retry line 本身就是安全对象，必须受 current-world revocation 约束
3. runtime downgrade 必须能回写全局状态，否则 consumer 会继续拿旧 ready truth 做决策
4. 局部修复与整池修复必须分层，否则系统无法表达恢复范围

用苏格拉底式反问压缩，
可以得到四个自检问题：

1. 如果没有 retry budget，系统凭什么说自己理解“持续可用”？
2. 如果没有 stale-line cleanup，旧世界凭什么不冒充 current truth？
3. 如果 disable 不会停掉正在排队的 retry，操作员到底在治理什么？
4. 如果只会验证 current-time gate，不会处理 ready truth 被撤销后的时间线，系统到底在保护哪种“可用性”？

## 10. 这篇源码剖面给主线带来的五条技术启示

### 启示一

repo 已经在 retry budget 上明确展示：

`temporal dependability`

本身就是制度对象，
不是 current-time readiness 的自然延伸。

### 启示二

repo 已经在 stale reconnect timer cleanup 上明确展示：

`旧 continuity line`

本身也是风险对象，
必须接受 current-world revocation。

### 启示三

repo 已经在 manual reconnect / disable cancel / re-enable reconnect 上明确展示：

`continuity`

是可被人类显式治理的 stop / restart 主权。

### 启示四

repo 已经在 `toolExecution.ts` 上明确展示：

`runtime revocation`

会把 continuity 问题从未来的潜在风险拉回现在的制度现实。

### 启示五

repo 已经在 `print.ts` 的 SDK pool re-init 上明确展示：

`continuity`

不只属于单对象，也属于整个 current usable world。

## 11. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 只要补出 readiness governance，就已经足够成熟。`

而是：

`Claude Code 在 continuity budget、retry/backoff/give-up grammar、stale retry line cleanup、operator stop/restart control、runtime downgrade 与 pool-level repair 上已经明确展示了 continuity governance 的存在；因此 artifact-family cleanup stronger-request cleanup-readiness-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-continuity-governor signer。`

再压成一句：

`cleanup 线真正缺的不是“谁来判断 returned object 此刻能不能用”，而是“谁来决定这份可用性在时间里怎样继续成立”。`
