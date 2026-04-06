# 安全载体家族重新并入治理与重新投影治理分层：为什么artifact-family cleanup reintegration-governor signer不能越级冒充artifact-family cleanup reprojection-governor signer

## 1. 为什么在 `174` 之后还必须继续写 `175`

`174-安全载体家族恢复治理与重新并入治理分层` 已经回答了：

`recovered truth` 即便已经成立，也还要单独回答它何时重新并入当前 `tool / status / event` world。

但如果继续往下追问，
还会碰到另一层同样容易被偷写的错觉：

`只要对象已经重新并入当前世界，系统就自动拥有了决定这份 current truth 该怎样被 control protocol、status pane、notification surface、health surface 与 reconnect dialog 重新讲述的主权。`

Claude Code 当前源码同样不能支持这种更强说法。

因为继续看：

1. `src/cli/print.ts:1610-1698,2957-2960,3127-3128` 的 `buildMcpServerStatuses()` 与 `mcp_status` / `reload_plugins` control responses
2. `src/commands/plugin/ManagePlugins.tsx:512-519` 的 `getMcpStatus()`
3. `src/components/mcp/MCPListPanel.tsx:307-337` 的 `statusText` projection
4. `src/hooks/notifs/useMcpConnectivityStatus.tsx:25-63` 的 selective notification grammar
5. `src/cli/handlers/mcp.tsx:26-35` 的 health glyph grammar
6. `src/components/mcp/MCPReconnect.tsx:40-63` 的 reconnect result copy
7. `src/cli/print.ts:2736-2758,3148-3204,3258-3295` 的 control success/error envelope

会发现 repo 已经清楚展示出：

1. `reintegration governance` 负责决定恢复后的对象何时重新进入 current world
2. `reprojection governance` 负责决定这份 current truth 怎样以不同粒度、不同句法、不同选择性被重新投影给不同 reader surface

也就是说：

`artifact-family cleanup reintegration-governor signer`

和

`artifact-family cleanup reprojection-governor signer`

仍然不是一回事。

前者最多能说：

`对象已经重新成为当前世界的一部分。`

后者才配说：

`这份当前真相现在该怎样被 control response、health、notification、panel status 与 reconnect copy 重新讲述给不同读者。`

所以 `174` 之后必须继续补的一层就是：

`安全载体家族重新并入治理与重新投影治理分层`

也就是：

`reintegration governor 决定对象何时重新进入当前世界；reprojection governor 才决定进入之后这份真相怎样被不同 surface 重新讲述。`

## 2. 先做一条谨慎声明：`artifact-family cleanup reprojection-governor signer` 仍是研究命名，不是源码现成类型

这里同样要先讲清楚：

`Claude Code 当前源码里并没有一个字面存在的类型叫 artifact-family cleanup reprojection-governor signer。`

这里的 `artifact-family cleanup reprojection-governor signer` 仍是研究命名。
它不是在声称 cleanup 线已经有一个未公开的 reprojection manager，
而是在说：

1. repo 已经把 reintegrated truth 重新讲述给多个 surface
2. 这些 surface 使用不同的枚举、文案、选择性提示与结构化 payload
3. repo 已经拒绝让某一份投影自动代表所有 reader 的 current truth

因此 `175` 不是在虚构已有实现，
而是在给更深的一层缺口命名：

`重新并入，不等于已经完成重新投影。`

## 3. 最短结论

Claude Code 当前源码至少给出了五类“reintegration-governor signer 仍不等于 reprojection-governor signer”证据：

1. `buildMcpServerStatuses()` 会把同一份 current truth 重新编码成 control protocol 用的结构化 `McpServerStatus[]`
2. `getMcpStatus()` 与 `MCPListPanel` 又把同一 truth 压成 plugin manager / panel status enum 与 label
3. `useMcpConnectivityStatus()` 只为 `failed / needs-auth` 发 toast，不为 `connected / pending` 发“恢复成功”通知；这说明 reprojection 有选择性 publication grammar
4. `handlers/mcp.tsx` 把同一 truth 压成 `✓ Connected / ! Needs authentication / ✗ Failed to connect`；这说明 health surface 的词法主权独立于 reintegration
5. `MCPReconnect` 把同一 truth 压成 `Successfully reconnected`、`requires authentication` 与 generic failure copy；这说明 dialog/reconnect surface 的叙事强度也不是 reintegration 本身能回答的

因此这一章的最短结论是：

`reintegration governor 最多能说对象已经重新回到当前世界；reprojection governor 才能说这份 current truth 现在应当怎样被不同 reader surface 重新讲述。`

再压成一句：

`reintegrated，不等于 already reprojected to every reader.`

## 4. 第一性原理：reintegration governance 回答“对象回到当前世界了吗”，reprojection governance 回答“这份当前真相该怎样被重新讲述”

从第一性原理看，
重新并入治理与重新投影治理处理的是两个不同主权问题。

reintegration governor 回答的是：

1. recovered client 是否已进入 current state
2. recovered tools / commands / resources 是否已回到 current tool pool
3. event plane 是否重新接回
4. next turn consumer 是否已经能读到它
5. 对象是否重新成为 current world 的一部分

reprojection governor 回答的则是：

1. 哪些 reader 该看到结构化 status
2. 哪些 reader 该看到 glyph/label/copy
3. 哪些 reader 只该看到 failure/auth warning，而不该看到 success toast
4. 同一 truth 在不同 surface 上该被压成怎样的词法强度
5. 哪些 surface 该重讲 current truth，哪些 surface 该保持沉默

如果把这两层压成一句“反正已经并回来了”，
系统就会制造五类危险幻觉：

1. integrated-means-announced illusion
   只要对象已并回，就误以为所有 reader 已被正确告知
2. one-surface-speaks-for-all illusion
   误以为某一份 status text 能代表所有 consumer 的 current truth
3. success-toast-is-mandatory illusion
   误以为恢复成功后所有 surface 都应显式宣告成功
4. health-string-equals-control-truth illusion
   误以为 health glyph 就等于 structured control protocol
5. reconnect-copy-equals-status-plane illusion
   误以为 dialog 文案就等于 status / notification grammar

所以从第一性原理看：

`reintegration governance` 管的是 world membership；
`reprojection governance` 管的是 reader-facing retelling。

## 5. `buildMcpServerStatuses()` 先证明：reintegrated truth 进入 control protocol 仍要经过单独的结构化投影

`print.ts:1610-1698` 很值钱。

这里 `buildMcpServerStatuses()` 不只是回读当前对象，
而是在 `appState` / `sdkClients` / `dynamicMcpState` 之上重新组织出：

1. `name`
2. `status`
3. `serverInfo`
4. `error`
5. `config`
6. `scope`
7. `tools`
8. `capabilities`

随后 `2957-2960` 与 `3127-3128` 又分别把这份结构投影到：

1. `mcp_status`
2. `reload_plugins` control response

这说明 control protocol 自己并不直接消费 raw reintegration state。
它要的是真相的专门投影版本。

这条证据非常硬。
因为它说明：

`current-world membership`

并不自动等于：

`control-reader-ready publication`

## 6. `ManagePlugins` 与 `MCPListPanel` 再证明：同一份 reintegrated truth 还会被压成不同 UI status grammar

`ManagePlugins.tsx:512-519` 的 `getMcpStatus()` 把同一 truth 压成：

`connected / disabled / pending / needs-auth / failed`

这是一个 manager-facing normalized enum。

`MCPListPanel.tsx:307-337` 又继续把同一 truth 压成：

1. `connected`
2. `reconnecting (n/m)…`
3. `connecting…`
4. `needs authentication`
5. `failed`

也就是说，
同一份已经 reintegrated 的 truth，
在 UI world 里也不是自动等于同一句 current statement。

它还要再经过：

`which panel reads it`
`what granularity that panel needs`

的重新投影判断。

## 7. `useMcpConnectivityStatus()` 再证明：重新投影不只决定“说什么”，还决定“哪些真相根本不说”

`useMcpConnectivityStatus.tsx:25-63` 很值钱。

这里只为两类 truth 发 notification：

1. `failed`
2. `needs-auth`

它不会为：

1. `connected`
2. `pending`

发出对称的“恢复成功 / 正在重连” toast。

这说明 reprojection governance 不只处理：

`how to say`

还处理：

`whether to say at all`

从第一性原理看，
这非常先进。
它拒绝让 “对象已经 reintegrated” 自动变成 “所有读者都必须收到恢复宣告”。

对 cleanup 线来说，这条启示非常关键。
因为未来旧 path、旧 promise、旧 receipt 即便已经重新并入当前世界，
也仍不自动说明：

`每个 surface 都该用成功语气重新讲它。`

## 8. `/mcp` health 与 `MCPReconnect` 再证明：health surface、dialog surface 与 control surface 使用不同强度的重新投影词法

`handlers/mcp.tsx:26-35` 很硬。

它把连接 truth 压成：

1. `✓ Connected`
2. `! Needs authentication`
3. `✗ Failed to connect`

这是一种 health-check reader 的 glyph grammar。

`MCPReconnect.tsx:40-63` 又把同一 truth 压成：

1. `Successfully reconnected to ...`
2. `... requires authentication. Use /mcp to authenticate.`
3. `Failed to reconnect to ...`

这说明 dialog/reconnect surface 面向的是另一类 reader：

1. 它更重 action copy
2. 它更接近当前单次操作的结果叙事

所以即便对象已经 reintegrated，
不同 surface 也仍然保有各自的重新投影主权。

## 9. 技术先进性与哲学本质：Claude Code 真正先进的地方，是它拒绝让“回到当前世界”自动篡位成“所有读者都以同一种句法重新理解当前世界”

从技术角度看，Claude Code 在这条线上的先进性，
不只是因为它会把 truth 投影到很多 surface。

更值钱的是它已经在多个点上同时承认：

1. 同一 truth 可以有多种 reader-facing grammar
2. 不是每个 surface 都该对称发“恢复成功”
3. 结构化 control payload、glyph health、toast warning、dialog copy 并不互相替代
4. 读者拿到的不是 raw reintegration，而是被重新压缩过的 current truth
5. 不同 surface 的 silence 也是正式设计的一部分

这背后的哲学本质是：

`真正成熟的系统，不会让“世界已经接回对象”自动冒充“所有读者都已被同一种话重新说服”。`

也就是说，
它不只追问 world-entry honesty，
还追问 reader-facing projection honesty。

对 cleanup 线最关键的技术启示因此不是：

`只要把对象接回当前世界，就算完整。`

而是：

`必须同时补出 reintegrated truth 该怎样被不同 reader surface 重新讲述的 reprojection grammar。`

否则系统仍会停在另一种危险的半治理状态：

`它能说对象已经回来，却没人正式决定哪些读者现在该看到什么版本的当前真相。`

## 10. 苏格拉底式自诘：我的判断有没有再次越级

为了避免把 “源码里有很多 status 文案” 直接写成 “cleanup 线只差多做几套 UI copy”，
这里必须主动追问自己五个问题。

### 第一问

`我是不是把 reprojection 简化成了文案问题？`

不能这样写。
它还包括结构化 payload、枚举归一化、glyph grammar、notification silence policy 与 dialog action copy。

### 第二问

`只要对象已经 reintegrated，reprojection 是否就自动完成？`

也不能。
源码已经把 `buildMcpServerStatuses()`、`getMcpStatus()`、`useMcpConnectivityStatus()`、health glyph 与 reconnect dialog 明确拆开。

### 第三问

`我是不是把 reprojection 和 republication 完全当成同一层了？`

也要谨慎。
当前证据更强地支持：

`same truth reprojected to multiple readers`

而不一定已经足够支持下一层 “哪些 surface 可以重新做更强 attest/promise” 的正式固化。

### 第四问

`为什么 `useMcpConnectivityStatus()` 不发 success notification 也算治理证据？`

因为不投影、少投影、本地化投影，本身就是 projection authority 的一部分。

### 第五问

`我是不是把 control protocol、UI panel、notification 与 health CLI 混成一个 reader？`

不能。
它们只是不同 consumer，读取的是同一 current truth 的不同重新投影视图。

所以这一章最该继续约束自己的，
就是始终把：

`reintegrated`
`structured status`
`health string`
`warning toast`
`action copy`

当成五个不同强度的事实。

## 11. 一条硬结论

这组源码真正说明的不是：

`Claude Code 只要已经把恢复后的对象重新并入当前世界，就已经自动拥有决定所有 consumer 如何重新理解这份 truth 的主权。`

而是：

`repo 在 buildMcpServerStatuses 的 control projection、ManagePlugins/MCPListPanel 的 status grammar、useMcpConnectivityStatus 的 selective notification policy、handlers/mcp 的 health glyph grammar，以及 MCPReconnect 的 action-oriented reconnect copy 上，已经明确展示了 reprojection governance 的存在；因此 artifact-family cleanup reintegration-governor signer 仍不能越级冒充 artifact-family cleanup reprojection-governor signer。`

再压成最后一句：

`重新并入负责回答“它回到当前世界了吗”；重新投影，才负责回答“不同读者现在该看到什么版本的当前真相”。`
