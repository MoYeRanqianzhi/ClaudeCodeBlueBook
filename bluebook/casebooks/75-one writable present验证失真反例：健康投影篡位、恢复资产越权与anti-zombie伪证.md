# one writable present验证失真反例：健康投影篡位、恢复资产越权与anti-zombie伪证

这一章不再回答“one writable present 该怎样持续验证”，而是回答：

- 为什么团队明明已经有 `playbooks/79` 这一类验证手册，仍会把 pointer 还在、telemetry 转绿、恢复成功与目录更整洁误当成当前态仍只有一个正式写入面。

它主要回答五个问题：

1. 为什么 one writable present 最危险的失败方式不是“没有结构边界”，而是“边界还在，但健康投影开始篡位为 authority”。
2. 为什么恢复资产最容易从 recovery asset 变成 current truth。
3. 为什么 anti-zombie 最容易退回注释、测试绿灯与复盘 prose。
4. 为什么 compile-time / runtime / artifact 一旦混写，later maintainer 的 rejectability 就会崩塌。
5. 怎样用苏格拉底式追问避免把这些反例读成“再补几条结构卫生规则”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/utils/task/framework.ts:158-269`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/utils/worktree.ts:1046-1172`

这些锚点共同说明：

- one writable present 真正要保护的，不是“系统看起来更健康”，而是当前态仍只有一个正式 authority surface，恢复资产不篡位，stale writer 无法重新写坏现在。

## 1. 第一性原理

one writable present 验证最危险的，不是：

- 没有 pointer
- 没有恢复链
- 没有健康信号

而是：

- 这些东西都还在，却已经不再绑定同一个 current truth

一旦如此，团队就会重新回到：

1. 看 pointer 是否还能指过去。
2. 看 telemetry 是否仍然转绿。
3. 看 reconnect 是否似乎成功。
4. 看目录是不是更整齐。
5. 看作者是不是还能解释。

而不再围绕：

- 同一个 `single_writer_surface + recovery_asset_ledger + anti_zombie_evidence + release_surface_matrix + later_maintainer_rejectability`

## 2. 健康投影篡位 vs single-writer authority continuity

### 坏解法

- host projection、telemetry、health dashboard、reconnect 成功感或“当前 worktree 很干净”被直接当成 single-writer authority 的证明。

### 为什么坏

- `health_projection_as_authority` 会把 current truth 退回投影竞赛。
- `projection_consensus_masks_truth_split` 表示多个消费者各自看不同 projection，却共同给出“通过”。
- later 团队会重新失去“到底谁配写当前真相”的正式入口。

### Claude Code 式正解

- 健康投影只能帮助观测 authority，不能替代 authority。
- single-writer continuity 必须继续绑定正式写入面，而不是绑定“大家都没看出问题”。

## 3. 恢复资产越权 vs recovery asset non-sovereignty

### 坏解法

- pointer、resume file、session ledger、transport breadcrumb 只要“能把人带回来”，就被直接当成当前主真相消费。

### 为什么坏

- `recovery_asset_declared_present` 会让恢复资产从“帮助回到真相”变成“自己宣布真相”。
- 系统会把“恢复成功率”误读成“当前态仍正确”。
- 一旦恢复资产越权，later 修改者会无法分辨自己是在回到 authority，还是在消费第二权威面。

### Claude Code 式正解

- recovery asset 必须继续只是 recovery asset；任何恢复入口都应先回到正式对象，再决定后续读写。
- “找得到”不等于“它现在就是真相”。

## 4. anti-zombie 伪证 vs formal stale-writer guard

### 坏解法

- 注释里写了不能 zombie，测试大多是绿的，复盘 prose 也承认了风险，于是团队默认 anti-zombie 已成立。

### 为什么坏

- `stale_writer_guard_unattested` 的危险在于：过去对象仍可能跨 `await` 写坏现在，但没人能正式拒绝它。
- anti-zombie 一旦退回口头文化，就会把结构先进性退回作者自觉。
- later 维护者会知道“这里有风险”，却无法从机制里直接拒绝错误实现。

### Claude Code 式正解

- anti-zombie 必须继续体现为 generation guard、fresh merge、stale drop、terminal re-check 等正式证据。
- 绿灯只能证明某次没出事，不能替代 stale-writer 不可达的对象级证明。

## 5. 三层混写与 later maintainer rejectability 崩塌

### 坏解法

- compile-time、runtime、artifact 三层被混成一层；later maintainer 只能靠作者解释，无法独立判断哪里该 reject。

### 为什么坏

- `release_surface_conflated` 会让“看起来发得出去”取代“当前态仍由唯一写入面支配”。
- `author_memory_required_for_reject` 意味着 later maintainer 的 rejectability 已经丢失。
- 一旦 transport、ingress、worktree guard 退回作者说明，系统就会重新依赖好运气而不是 fail-closed。

### Claude Code 式正解

- compile-time、runtime 与 artifact 三层边界必须继续分层。
- later maintainer 应能不问作者就指出 authority、recovery、anti-zombie 与 fail-closed 的拒收边界。

## 6. 从更多角度看它为什么迷惑

这类假象之所以迷惑，至少有五个原因：

1. 它借用了真正先进结构的外观：恢复、桥接、transport、worktree、telemetry 都看起来在认真工作。
2. 它满足了不同角色最容易满足的局部需求：宿主要能继续写，CI 要健康，评审要结构漂亮，交接要能接上。
3. 它把 later 团队应消费的结构真相面偷换成了多个健康投影。
4. 它把 fail-closed 的第一性原理偷换成了“现在看起来没出事”的运气。
5. 它把源码先进性从可复证的对象链偷换成了更像先进架构的叙事。

## 7. 苏格拉底式追问

在你准备宣布“one writable present 验证仍然健康”前，先问自己：

1. 当前到底谁配写当前真相。
2. recovery asset 是在帮助回到 authority，还是已经偷偷篡位。
3. 过去的对象是否仍无法写坏现在，而不只是“这次恰好没写坏”。
4. compile-time、runtime 与 artifact 三层边界有没有被混写。
5. later maintainer 如果拿不到作者记忆，是否仍能独立给出 reject verdict。
6. 如果删掉所有健康投影，这套结构先进性还剩下什么。
