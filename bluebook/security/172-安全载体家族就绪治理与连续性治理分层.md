# 安全载体家族就绪治理与连续性治理分层：为什么artifact-family cleanup readiness-governor signer不能越级冒充artifact-family cleanup continuity-governor signer

## 1. 为什么在 `171` 之后还必须继续写 `172`

`171-安全载体家族重新激活治理与就绪治理分层` 已经回答了：

`active world 已经接入，不等于这个世界现在已经 ready for use。`

但如果继续往下追问，
还会碰到另一层非常容易被偷写的错觉：

`只要对象此刻已经 connected、当前工具面也允许消费它，就说明系统已经正式回答了它在接下来一段时间里会不会继续可用。`

Claude Code 当前源码同样不能支持这种更强说法。

因为继续看：

1. `src/services/mcp/useManageMCPConnections.ts:87-90,333-466` 的 automatic reconnection、指数退避、最大重试次数与最终放弃语义
2. `src/services/mcp/useManageMCPConnections.ts:765-853` 的 stale reconnect timer 清理、pending 重建与 `/reload-plugins` continuity reseed
3. `src/services/mcp/useManageMCPConnections.ts:1043-1123` 的 manual reconnect、disable cancel 与 re-enable reconnect path
4. `src/services/tools/toolExecution.ts:1599-1628` 的 `connected -> needs-auth` runtime downgrade
5. `src/cli/print.ts:1392-1426` 的 `hasPendingSdkClients / hasFailedSdkClients` re-init path
6. `src/tools/ReadMcpResourceTool/ReadMcpResourceTool.ts:78-95` 的 `connected` hard gate

会发现 repo 已经清楚展示出：

1. `readiness governance` 负责回答对象现在是不是 ready
2. `continuity governance` 负责回答 ready truth 在时间中断裂、退化、重试、放弃与恢复时怎样继续成立，或者怎样被正式撤销

也就是说：

`artifact-family cleanup readiness-governor signer`

和

`artifact-family cleanup continuity-governor signer`

仍然不是一回事。

前者最多能说：

`它现在能用。`

后者才配说：

`它在接下来的时间里如果断掉、超时、失鉴权、握手失败或被人工干预，系统由谁决定继续保持、重新争取还是正式放弃它的可用性。`

所以 `171` 之后必须继续补的一层就是：

`安全载体家族就绪治理与连续性治理分层`

也就是：

`readiness governor 决定对象现在能不能用；continuity governor 才决定这种可用性怎样跨时间维持、退化、重建或终止。`

## 2. 先做一条谨慎声明：`artifact-family cleanup continuity-governor signer` 仍是研究命名，不是源码现成类型

这里同样要先讲清楚：

`Claude Code 当前源码里并没有一个字面存在的类型叫 artifact-family cleanup continuity-governor signer。`

这里的 `artifact-family cleanup continuity-governor signer` 仍是研究命名。
它不是在声称 cleanup 线已经有一个未公开的 continuity manager，
而是在说：

1. repo 已经不只建模 “当前是否 connected”，还建模断连后的重试、退避、放弃与人工重连
2. repo 已经公开接受 ready truth 会在运行时退化成 `needs-auth` 或 `failed`
3. repo 已经让 SDK path 因 `pending / failed` client 而整批重建当前 MCP world

因此 `172` 不是在虚构已有实现，
而是在给更深一层缺口命名：

`现在能用，不等于接下来还能持续可用。`

## 3. 最短结论

Claude Code 当前源码至少给出了五类“readiness-governor signer 仍不等于 continuity-governor signer”证据：

1. `ReadMcpResourceTool` 只要求 `client.type === 'connected'`，说明 readiness 只回答当前是否可消费，不回答这种可消费性会维持多久
2. `useManageMCPConnections()` 在 `onclose` 后不是简单改成 `failed`，而是进入 `pending -> retry -> connected/failed` 的时间过程；这说明 continuity 是单独的治理面
3. reconnect path 明确有 `MAX_RECONNECT_ATTEMPTS`、指数退避与最终 give-up 语义；这说明“要不要继续保持可用性”不是 readiness verdict 自己能回答的
4. `toolExecution.ts` 会把一个原本 `connected` 的 client 降成 `needs-auth`；这说明 readiness 不是永久席位，而 continuity 必须处理 ready truth 的退化
5. `print.ts` 会因为 SDK client 仍处于 `pending / failed` 而整批 re-initialize；这说明 continuity 不只是单对象状态，而是 current usable pool 的持续维持机制

因此这一章的最短结论是：

`readiness governor 最多能说对象现在是否 ready；continuity governor 才能说这份 ready truth 在断连、退化、重试、人工干预和时间流逝中如何继续成立。`

再压成一句：

`ready now，不等于 stays ready over time。`

## 4. 第一性原理：readiness governance 回答“现在能不能消费”，continuity governance 回答“这种可消费性怎样跨时间维持”

从第一性原理看，
就绪治理与连续性治理处理的是两个不同主权问题。

readiness governor 回答的是：

1. 当前 client 是不是 `connected`
2. 当前 tool consumer 能不能立刻消费它
3. 当前 auth 与 capability 条件有没有闭合
4. 当前 surface 应显示 ready、pending、failed 还是 needs-auth
5. 这一刻的 usable truth 是否成立

continuity governor 回答的则是：

1. 一旦 transport 断掉，要不要自动重连
2. 自动重连最多试几次、以什么 backoff 节奏继续
3. 什么时候该从 “继续争取可用” 转成 “正式放弃”
4. 一旦 ready truth 被运行时证据撤销，谁来决定重试、重鉴权或整批重建
5. 人工 disable、manual reconnect、SDK re-init 怎样改写这条持续可用性时间线

如果把这两层压成一句“反正现在是 connected”，
系统就会制造五类危险幻觉：

1. ready-means-stable illusion
   只要当前 ready，就误以为接下来也会继续 ready
2. retry-is-incidental illusion
   误以为 auto-reconnect 只是实现细节，而不是正式 continuity 主权
3. downgrade-is-local-noise illusion
   误以为 `needs-auth` 只是局部错误，而不是 ready truth 被撤销
4. give-up-is-natural illusion
   误以为最终停止重连只是时间到了，不需要显式治理语义
5. pool-health-equals-node-health illusion
   误以为单个 client 此刻 ready，就说明整个 current MCP world 的持续可用性已经成立

所以从第一性原理看：

`readiness governance` 处理现在时的可消费性；
`continuity governance` 处理时间轴上的可维持性。

## 5. `useManageMCPConnections()` 先证明：当前 ready 之后，repo 还单独维护一整条 continuity lifecycle

`useManageMCPConnections.ts:87-90` 一上来就把 continuity budget 写死成三项制度参数：

1. `MAX_RECONNECT_ATTEMPTS = 5`
2. `INITIAL_BACKOFF_MS = 1000`
3. `MAX_BACKOFF_MS = 30000`

这已经说明 repo 追问的不是：

`对象现在是不是 ready`

而是：

`ready truth 一旦断掉，系统接下来还要为它争取多久。`

`333-466` 更硬。

这里在 `client.client.onclose` 后做的不是直接宣告“现在不 ready 了”就结束，
而是继续进入一条正式 continuity path：

1. 先检查对象是否已被 disable；若已 disable，则跳过 continuity attempt
2. 若是 remote transport，则进入 automatic reconnection
3. 每次 attempt 前把状态更新成 `pending`
4. 每次尝试都可能回到 `connected`
5. 最终可以因为达到上限而进入 give-up
6. backoff 以指数方式增长，而不是平铺重试

这里最值钱的，不是代码里有 retry。

而是 repo 明确拒绝把：

`当前 connected`

偷写成：

`未来仍然可持续 connected`

它要求系统在时间上持续重新裁决。

这正是 continuity governance 的本体。

## 6. stale timer 清理、manual reconnect 与 toggle path 再证明：continuity 不只是自动重试，而是“继续维持可用性”的正式操作主权

`useManageMCPConnections.ts:765-853` 非常关键。

这里在 `/reload-plugins` 和 session change 场景下，
不仅会把新对象初始化为 `pending`，
还会优先清理 stale reconnect timer，
避免旧 config、旧 closure 与旧 continuity attempt 冒充新的 current world。

这说明 continuity 不是：

`谁还在自动重试谁就算继续活着`

而是：

`只有与 current config、current world 对齐的重试线，才配继续代表 continuity truth`

`1043-1123` 又把 continuity 主权进一步显化成人工操作：

1. manual reconnect 会先取消已有 pending reconnect，再显式触发新的 reconnect attempt
2. disable 会先取消 pending reconnect，再把对象转成 `disabled`
3. re-enable 会先置成 `pending`，再重新连一次

这条证据非常值钱。
它说明 continuity governance 不是 background retry 的副作用，
而是正式回答：

`继续试、停止试、重新试，分别由谁触发、何时重启、何时停表。`

如果 cleanup 线未来只有 readiness grammar，
没有这种 “stop / retry / reseed / give-up” grammar，
那它就仍然无法正式回答：

`旧 path、旧 promise、旧 receipt 一旦当前 ready truth 断掉，后面由谁维持它的连续可用性。`

## 7. `toolExecution.ts` 与 `print.ts` 再证明：continuity 处理的是 ready truth 的退化与重建，而不只是连接成功那一瞬间

`toolExecution.ts:1599-1628` 给出一个特别强的反例。

这里在 `McpAuthError` 时，
会把一个原本 `connected` 的 client 更新成：

`type: 'needs-auth'`

而且只在原状态真的还是 `connected` 时才改。

这说明 repo 已经公开承认：

1. ready truth 会在运行时被撤销
2. 被撤销后，系统不能继续假装 continuity 仍成立
3. continuity governance 必须回答撤销后是等待重鉴权、等待重连，还是正式退出

`print.ts:1392-1426` 又把这层治理推进到 SDK client pool。

这里不是只检查 “有没有新增 server”，
而是进一步追问：

1. 有没有 `pending` SDK clients 还没升格
2. 有没有 `failed` SDK clients 已经卡死
3. 如果有，就整批重新初始化当前 SDK MCP servers

这说明 continuity 并不只是某个单一连接的故事。
它还回答：

`当前 usable pool 还能不能继续作为一个整体成立。`

从技术角度看，这非常先进。
它把可用性从瞬时 verdict 提升成了时间中的 system responsibility。

## 8. `ReadMcpResourceTool` 再次提醒：consumer hard gate 只验证 readiness，不自动替 continuity 背书

`ReadMcpResourceTool.ts:78-95` 仍然很硬。

它看到 `client.type !== 'connected'` 就直接拒绝消费。

这说明 consumer gate 的制度只到这里：

`当前 ready，我才读。`

它并不会进一步说：

`既然这一刻能读，所以接下来也一定持续能读。`

换句话说，
consumer gate 证明了 readiness 很硬，
却也反过来暴露出 continuity 需要由别的层单独负责。

否则系统就会把一次成功读取，
偷写成一条跨时间的稳定承诺。

## 9. 技术先进性与哲学本质：Claude Code 真正先进的地方，是它拒绝让“当前可用”自动篡位成“持续可用”

从技术角度看，Claude Code 在这条线上的先进性，
不只是有 reconnect。

更值钱的是它已经在多个点上同时承认：

1. ready truth 会断
2. 断了之后要继续试
3. 继续试有预算、有节奏、有终点
4. 旧 continuity attempt 可能因为 stale config 而失效
5. 一个对象 ready，不等于整个 current usable pool 继续成立

这背后的哲学本质是：

`真正成熟的安全系统，不会让“这一刻能用”自动冒充“这段时间都能用”。`

也就是说，
它不只追问空间边界，
还追问时间诚实性。

对 cleanup 线最关键的技术启示因此不是：

`把 ready / not-ready 写清楚就够了。`

而是：

`必须同时补出 ready truth 的 temporal maintenance grammar。`

否则系统仍会停在另一种危险的半治理状态：

`它能说对象现在可用，却没人正式回答这种可用性在接下来的时间里如何维持、退化、恢复或放弃。`

## 10. 苏格拉底式自诘：我的判断有没有再次越级

为了避免把 “源码里有 auto-reconnect” 直接写成 “cleanup 线只差照抄一套 retry loop”，
这里必须主动追问自己五个问题。

### 第一问

`我是不是把 continuity 简化成了 retry 次数？`

不能这样写。
retry budget 只是 continuity 的一部分，
它还包括 stale timer 清理、disable cancel、manual reconnect、runtime downgrade 与 pool-level re-init。

### 第二问

`只要有 onclose -> reconnect，就已经拥有 continuity governance 了吗？`

也不能这么绝对。
continuity governance 回答的是谁能定义继续、停止、重启和放弃的制度。
具体实现可以分散在 hook、tool error path 和 SDK setup 里，
不必只长成一个独立模块。

### 第三问

`我是不是把 readiness downgrade 和 continuity failure 混成一层了？`

不能这样写。
`needs-auth` 只是 ready truth 被撤销，
还不自动等于 continuity 已正式终止。
终止与否，仍要看后续是否继续重试、重鉴权或被人工 disable。

### 第四问

`consumer hard gate 能不能直接代表 continuity verdict？`

不能。
consumer gate 只说“这一刻能不能读”，
不说“接下来是否还能持续读”。

### 第五问

`我是不是又把单对象 continuity 和系统池 continuity 混成一个 verdict？`

也不能。
`print.ts` 已经证明 pool-level continuity 可能要求整批 re-init，
这比单对象 ready 更强，也更接近系统级 continuity 主权。

所以这一章最该继续约束自己的，
就是始终把：

`ready now`
`retrying now`
`stays usable over time`

当成三个不同强度的事实。

## 11. 一条硬结论

这组源码真正说明的不是：

`Claude Code 只要已经能够判断旧 cleanup 对象现在是否 ready，就已经自动拥有治理它在时间中持续可用的主权。`

而是：

`repo 在 useManageMCPConnections 的 auto-reconnect/backoff/give-up/cancel path、toolExecution 对 connected client 的运行时降级、print 对 pending/failed SDK clients 的整批 re-init，以及 ReadMcpResourceTool 的当前时 consumer hard gate 上，已经明确展示了 continuity governance 的存在；因此 artifact-family cleanup readiness-governor signer 仍不能越级冒充 artifact-family cleanup continuity-governor signer。`

再压成最后一句：

`就绪负责回答“现在能不能用”；连续性，才负责回答“这种可用性能不能在时间里继续成立”。`
