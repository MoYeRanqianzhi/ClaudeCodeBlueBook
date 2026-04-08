# removeOrphanedAtMarker、refreshActivePlugins与copyPlanForResume的强请求清理复活治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `327` 时，
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
- `src/services/plugins/PluginInstallationManager.ts`
- `src/hooks/useManagePlugins.ts`
- `src/utils/plans.ts`
- `src/utils/conversationRecovery.ts`
- `src/utils/sessionStorage.ts`

把 repo 里现成的 authoritative clearing、Layer-3 refresh、explicit re-entry gate、lineage-based recovery 与 deletion-only tombstone path 并排，
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
| active plugin resurrection | `src/utils/plugins/refresh.ts:1-18,72-80,123-137`; `src/commands/reload-plugins/reload-plugins.ts:37-56` | 为什么 marker clearing / disk presence 不等于 active components 已重新回到当前 session |
| explicit and mode-sensitive re-entry gate | `src/services/plugins/PluginInstallationManager.ts:56-59,135-179`; `src/hooks/useManagePlugins.ts:28-34,287-303` | 为什么 repo 会继续区分 auto-refresh、manual `/reload-plugins` 与 not-yet-admitted worlds |
| lineage-based plan recovery | `src/utils/plans.ts:164-231,233-257`; `src/utils/conversationRecovery.ts:539-547` | 为什么 plan resurrection 需要 lineage、evidence 与 identity policy，而不是简单 undelete |
| deletion-only tombstone path | `src/utils/sessionStorage.ts:871-945,1468-1474` | 为什么 tombstone consumption 本身不自动携带 resurrection grammar |

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

## 5. Layer-3 refresh 再证明：repo 明确把 current-world 接纳写成显式 re-entry gate

`refresh.ts:1-18`
直接把 active plugin return 定义成：

`Layer-3 refresh primitive: swap active plugin components in the running session`

并显式区分：

1. Layer 1: intent
2. Layer 2: materialization
3. Layer 3: active components

`refresh.ts:72-80,123-137`
继续把 `refreshActivePlugins()` 写成当前会话里的真正激活入口：

1. clear all caches
2. clear orphan exclusions
3. 重建 enabled / disabled / commands / agents / hooks / MCP / LSP
4. 把 `needsRefresh` 消费为 `false`
5. bump `pluginReconnectKey`

而
`reload-plugins.ts:37-56`
则把这件事公开成一个显式命令事实：

`Reloaded: ...`

这说明 repo 明确拒绝把：

`marker clearing`

偷写成：

`current session 已接纳该对象`

## 6. `needsRefresh` 再证明：Claude Code 不把 comeback 压成一个“回来/没回来”开关

`PluginInstallationManager.ts:56-59`
先给出高层策略：

1. New installs -> auto-refresh
2. Updates only -> set `needsRefresh`

继续看
`PluginInstallationManager.ts:135-179`：

1. 新 marketplace 安装完成时，repo 会尝试 `refreshActivePlugins()`
2. auto-refresh 失败时，会回退为 `needsRefresh`
3. 如果只是 updates only，系统直接保持显式 pending-like 状态

再看
`useManagePlugins.ts:28-34,287-303`：

1. 初始 Layer-3 load 之后，后续 refresh 一律走 `/reload-plugins`
2. `needsRefresh` 只会弹通知：
   `Plugins changed. Run /reload-plugins to activate.`
3. 注释明确写着：
   `Do NOT auto-refresh`

这说明 repo 实际上在治理三种不同的 return world：

1. auto-admit world
2. explicit-admit world
3. not-yet-admitted world

对 stronger-request cleanup 的启示很硬：

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

`sessionStorage.ts:871-945,1468-1474`
把 tombstone 删除路径写得极其单向：

1. 操作是按 UUID 删除旧对象
2. fast path / slow path 只回答怎样安全删掉 transcript entry
3. 注释只说它用于 tombstone received for an orphaned message

它完全不回答：

1. 这些对象在什么条件下还能回来
2. 回来时是否还是原 UUID
3. 回来时谁来宣布它重新成为 current truth

这恰恰是一条非常硬的反证：

`成熟系统不会把 re-entry 语义偷塞进 deletion helper 里。`

## 9. 这组源码给出的技术启示

1. marker clearing 不是 resurrection，只是恢复资格判断的前置条件。
2. current-world readmission 必须是显式 active-layer gate，而不是磁盘状态的自动副作用。
3. comeback path 至少要继续拆成 auto-admit、explicit-admit 与 pending-not-yet-admitted 三种世界。
4. lineage 与 evidence 是复活治理的核心，而不是 plan 线的偶发细节。
5. content continuity 与 identity continuity 需要被显式拆开治理。
6. deletion helper 越纯，越能反证 resurrection grammar 必须被单列，而不能偷偷塞进旧的 cleanup 路径。

## 10. 苏格拉底式自反诘问：我是不是又把“旧世界结束后留下了 marker”误认成了“系统已经知道谁配回来”

如果对这一层做更严格的自我审查，
至少要追问六句：

1. 如果 tombstone grammar 已经足够强，为什么还要再拆 resurrection？  
   因为会留下标记，不等于知道谁配重新进入 current world。
2. 如果 `.orphaned_at` 会被清掉，是不是就说明对象已经完全回来了？  
   不是。marker clearing 只是撤销退役标记，不等于 active world 已接纳。
3. 如果磁盘上对象已经恢复，是不是就说明当前 session 可以继续用？  
   也不对。disk/materialized return 和 active/runtime return 被明确拆层。
4. 如果 plan 内容能恢复，是不是就说明原身份也恢复了？  
   不是。`copyPlanForFork()` 明确证明 content return 与 identity return 可以分开。
5. 如果 resurrection grammar 已存在，是不是就意味着任何旧对象都该能回来？  
   恰恰相反。成熟 resurrection 首先治理“谁不配回来”。
6. 如果 cleanup 线还没有显式 resurrection 代码，是不是说明这层还不值得写？  
   恰恰相反。越是缺这层明确 grammar，越容易把“还能回来吗”偷写成“反正 marker 清掉就算回来”。

这一串反问最终逼出一句更稳的判断：

`resurrection 的关键，不在系统会不会让某些旧对象重新出现，而在系统能不能正式决定哪些历史对象配重新被当前世界承认。`

## 11. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 未来只要补出 tombstone governance，就已经足够成熟。`

而是：

`Claude Code 在 authoritative marker clearing、Layer-3 refresh primitive、explicit /reload-plugins re-entry gate、needsRefresh pending world，以及 lineage-based plan recovery 上已经明确展示了 resurrection governance 的存在；因此 artifact-family cleanup stronger-request cleanup-tombstone-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-resurrection-governor signer。`

再压成一句：

`cleanup 线真正缺的不是“怎么给旧世界立碑”，而是“谁来决定哪些带碑的旧对象还能重新回来”。`
