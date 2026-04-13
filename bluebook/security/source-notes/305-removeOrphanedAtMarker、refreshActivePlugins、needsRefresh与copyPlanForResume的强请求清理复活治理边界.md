# removeOrphanedAtMarker、refreshActivePlugins、needsRefresh与copyPlanForResume的强请求清理复活治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `454` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 旧世界结束后留下什么墓碑，`

而是：

`stronger-request cleanup 旧世界即便留下了墓碑，谁来决定哪些对象还能回来、以及回来时算谁。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`tombstone governor 不等于 resurrection governor。`

这句话还不够硬。

所以这里单开一篇，
只盯住：

- `src/utils/plugins/cacheUtils.ts`
- `src/utils/plugins/refresh.ts`
- `src/commands/reload-plugins/reload-plugins.ts`
- `src/hooks/useManagePlugins.ts`
- `src/services/plugins/PluginInstallationManager.ts`
- `src/utils/plans.ts`
- `src/utils/conversationRecovery.ts`
- `src/utils/sessionStorage.ts`

把 repo 里现成的 authoritative clearing、Layer-3 refresh、explicit re-entry gate、mode-sensitive admission、lineage-based recovery 与 deletion-only tombstone path 并排，
直接钉死 stronger-request cleanup 线当前仍缺的不是墓碑本身，
而是 `re-entry authority grammar`。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 tombstone，没有 resurrection。`

而是：

`Claude Code 在 plugin 与 plan 两条线上已经明确把“留下墓碑”和“重新接纳对象”拆成两层；stronger-request cleanup 线当前缺的不是这种文化，而是这套 resurrection governance 还没被正式接到旧 cleanup artifact family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| authoritative marker clearing | `src/utils/plugins/cacheUtils.ts:67-72,82-92,122-130` | 为什么 `.orphaned_at` 只有在 authoritative installed set 重新声明该版本时才会被清除 |
| active plugin resurrection | `src/utils/plugins/refresh.ts:1-17,59-79,123-137`; `src/commands/reload-plugins/reload-plugins.ts:37-56` | 为什么 marker clearing / disk presence 不等于 active components 已重新回到当前 session |
| explicit and mode-sensitive re-entry gate | `src/hooks/useManagePlugins.ts:28-35,288-303`; `src/services/plugins/PluginInstallationManager.ts:53-58,135-160` | 为什么 repo 会继续区分 auto-refresh、manual `/reload-plugins` 与 not-yet-admitted worlds |
| lineage-based plan recovery | `src/utils/plans.ts:164-231,233-257`; `src/utils/conversationRecovery.ts:539-547` | 为什么 plan resurrection 需要 lineage、evidence 与 identity policy，而不是简单 undelete |
| deletion-only tombstone path | `src/utils/sessionStorage.ts:925-945,1470-1473` | 为什么 tombstone consumption 本身不自动携带 resurrection grammar |

## 4. plugin 线先证明：`.orphaned_at` 被清掉，并不等于插件已经重新回到当前 active world

`cacheUtils.ts:67-72`
先把 orphan cleanup 写成两段：

1. Pass 1 清已安装版本的 `.orphaned_at`
2. Pass 2 才处理真正 orphaned 的版本

而
`cacheUtils.ts:82-92`
又继续把 authoritative clearing 写得非常明确：

1. 先读取 `installed_plugins.json`
2. 形成 authoritative `installedVersions`
3. 只对这个集合里的 version path 执行 `removeOrphanedAtMarker()`

再看
`cacheUtils.ts:122-130`，
`removeOrphanedAtMarker()` 只删 marker，
并不负责任何 active return。

这说明：

`谁配清墓碑`

不是 marker 自己决定的，
而是由 authoritative installed state 决定。

但这还不是 resurrection。

更准确地说，
它只回答了：

`这个对象重新具备了被考虑返回的资格。`

它并没有回答：

`当前会话是否已经正式重新承认它。`

## 5. Layer-3 refresh 再证明：repo 明确把 current-world 接纳写成显式 re-entry gate

`refresh.ts:1-17`
直接把 active plugin return 定义成：

`Layer-3 refresh primitive: swap active plugin components in the running session`

并显式区分：

1. Layer 1: intent
2. Layer 2: materialization
3. Layer 3: active components

这三层分得越清，
越能看出：

`materialized on disk`

和

`admitted into current runtime`

根本不是同一件事。

`refresh.ts:59-79`
继续把 `refreshActivePlugins()` 写成真正的 re-entry gate：

1. 清所有 plugin caches
2. 清 orphan exclusions
3. 把 `/reload-plugins` 当成 explicit "disk changed, re-read it" signal

`123-137`
再把 active return 落到：

1. `enabled / disabled / commands / errors`
2. `agentDefinitions`
3. `mcp.pluginReconnectKey + 1`
4. `needsRefresh: false`

而
`reload-plugins.ts:37-56`
则把这件事公开成一个用户可见的显式命令事实：

`Reloaded: ...`

这说明 repo 明确拒绝把：

`marker clearing`

偷写成：

`current session 已经接纳`

它要求专门的 Layer-3 re-entry primitive 来签字。

## 6. `needsRefresh` 与 background install 继续证明：成熟系统不追求“一律自动恢复”，而追求“按路径分配 admission policy”

`useManagePlugins.ts:28-35`
已经把设计意图说得很直白：

1. 初始 mount 是 initial Layer-3 load
2. 后续 refresh 走 `/reload-plugins`
3. `On needsRefresh ... Does NOT auto-refresh`
4. 所有 Layer-3 swap 都走 `refreshActivePlugins()`，为了 `one consistent mental model`

`288-303`
又更明确：

1. 插件状态变化后只发通知
2. `Run /reload-plugins to activate`
3. `Do NOT auto-refresh`
4. `Do NOT reset needsRefresh`

这说明 interactive world 的 comeback grammar 是：

`pending but not yet admitted`

但
`PluginInstallationManager.ts:53-58,135-160`
又给出另一类路径：

1. 新安装 marketplace 时可 `auto-refresh plugins`
2. 如果 auto-refresh 失败，再 fallback 到 `needsRefresh`
3. 仅 updates-only 时则直接停在 `needsRefresh`

这组代码非常先进，
因为它没有追求表面上的“所有路径都自动恢复”。

它真正追求的是：

`哪种 comeback path 对当前世界足够安全、足够确定，可以 auto-admit；哪种 comeback path 仍必须保持 explicit-admit。`

这对 stronger-request cleanup 的启示很硬：

`真正成熟的 resurrection governance，必须回答“哪种 return path 可以自动被 current world 接纳，哪种必须保持显式”。`

## 7. plan 线给出第二个强正例：对象复活时，系统还要治理 lineage、evidence 与 identity policy

`plans.ts:164-231`
的 `copyPlanForResume()` 很值钱。

它不是看到 plan file 缺失就粗暴恢复。
它要求：

1. log 里确实有 slug
2. 把 slug 绑定回 original session ID
3. 先尝试直接读取 plan file
4. 只有在 `ENOENT` 且 remote session 才尝试 recovery
5. 优先用 file snapshot，失败后再回到 message history

这说明 plan resurrection 的本体不是：

`内容还在，就给你拉回来`

而是：

`只有在 lineage 和 evidence 都成立时，才允许对象重新进入 current session world。`

更关键的是
`plans.ts:233-257`
里的 `copyPlanForFork()`：

1. 不复用 original slug
2. 生成 new slug
3. 把原计划内容写进新文件

这直接证明：

`内容回来`

不等于

`原身份回来`

也就是说 resurrection governance 还必须回答：

`re-entry 后对象到底算 old identity 还是 new identity。`

`conversationRecovery.ts:539-547`
又把这件事接进正式恢复主线，
说明 resurrection 不是局部 helper，
而是正式 recovery grammar 的一部分。

## 8. tombstone 删除路径反证：删除 grammar 的存在不自动携带复活 grammar

`sessionStorage.ts:925-945,1470-1473`
把 tombstone 删除路径写得极其单向：

1. 操作是按 UUID 删除旧对象
2. fast path / slow path 只回答怎样安全删掉 transcript entry
3. 注释只说它用于 `tombstone received for an orphaned message`

它完全不回答：

1. 这些对象在什么条件下还能回来
2. 回来时是否还是原 UUID
3. 回来时谁来宣布它重新成为 current truth

这恰恰是一条非常硬的反证：

`成熟系统不会把 re-entry 语义偷塞进 deletion helper 里。`

删除 helper 越干净，
越说明 resurrection grammar 必须被单独签字。

## 9. 这组源码给出的技术启示

1. marker clearing 不是 resurrection，只是恢复资格判断的前置条件。
2. current-world readmission 必须是显式 active-layer gate，而不是磁盘状态的自动副作用。
3. comeback path 至少要继续拆成 auto-admit、explicit-admit 与 pending-not-yet-admitted 三种世界。
4. lineage 与 evidence 是复活治理的核心，而不是 plan 线的偶发细节。
5. content continuity 与 identity continuity 需要被显式拆开治理。
6. deletion helper 越纯，越能反证 resurrection grammar 必须被单列，而不能偷偷塞进旧的 cleanup 路径。

## 10. 为什么这些正对照会反过来暴露 stronger-request cleanup 的当前缺口

和这些成熟 resurrection grammar 对照，
stronger-request cleanup 线当前真正缺的已经不是：

`世界关门后留下什么 marker`

而是：

`哪些带碑对象配重新进入当前世界`

更具体地说，
现在还没有哪一层正式决定：

1. 旧 startup wording 在什么 evidence 下还能回来
2. 旧 cleanup law 回来时算旧身份还是新身份
3. 旧 promise vocabulary 的 comeback 是 content return 还是资格 return
4. 旧 receipt objects 回来时进入哪一层 active world
5. 哪些 resurrection path 可以 auto-admit，哪些必须 explicit-admit

这意味着 stronger-request cleanup 当前虽然已经开始显露 tombstone-governance，
却还没有谁正式回答：

`谁配回来、怎么回来、回到哪一层 current world。`

## 11. 苏格拉底式自反诘问：我是不是又把“旧世界结束后留下了 marker”误认成了“系统已经知道谁配回来”

如果对这一层做更严格的自我审查，
至少要追问六句：

1. 如果 tombstone grammar 已经足够强，为什么还要再拆 resurrection？
   因为会留下标记，不等于知道谁配重新进入 current world。
2. 如果 `.orphaned_at` 会被清掉，是不是就说明对象已经完全回来了？
   不是。marker clearing 只是撤销退役标记，不等于 active world 已接纳。
3. 如果磁盘上对象已经恢复，是不是就说明当前 session 可以继续用？
   也不对。disk/materialized return 和 active/runtime return 被明确拆层。
4. 如果 plan 内容成功恢复，是不是就说明还是原来的 plan？
   也不对。resume 与 fork 已明确拆成 old slug 和 new slug 两种身份政策。
5. 如果 deletion helper 已经很完善，是不是 comeback grammar 也就自然成立？
   不是。删除的单向语义恰恰反证 resurrection 必须被单独签字。
6. 如果 cleanup 线现在还没有显式 resurrection 代码，是不是说明这层还不值得写？
   恰恰相反。越是缺这层正式 admission grammar，越容易把“可恢复的历史对象”误写成“已被当前世界重新承认”。

这一串反问最后逼出一句更稳的判断：

`resurrection 的关键，不在旧对象能不能重新出现，而在系统能不能正式决定谁配重新被当前世界承认、以什么身份承认、以及承认到哪一层。`

## 12. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 只要补出 tombstone governance，就已经足够成熟。`

而是：

`Claude Code 在 authoritative marker clearing、Layer-3 refresh primitive、explicit /reload-plugins gate、needsRefresh pending world、lineage-based plan recovery 与 new-slug identity policy 上已经明确展示了 resurrection governance 的存在；因此 artifact-family cleanup stronger-request cleanup-tombstone-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-resurrection-governor signer。`

再压成一句：

`cleanup 线真正缺的不是“谁来给旧世界立碑”，而是“谁来决定哪些带碑对象还能回来、回来时算谁、回到哪一层当前世界”。`
