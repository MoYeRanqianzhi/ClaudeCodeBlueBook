# removeOrphanedAtMarker、refreshActivePlugins与copyPlanForResume的强请求清理复活治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `199` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 旧世界结束后留下什么墓碑，`

而是：

`stronger-request cleanup 旧世界即便留下了墓碑，谁来决定哪些对象还能回来、以及回来时算谁。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`tombstone governor 不等于 resurrection governor。`

这句话还不够硬。
所以这里单开一篇，只盯住：

- `src/utils/plugins/cacheUtils.ts`
- `src/utils/plugins/refresh.ts`
- `src/commands/reload-plugins/reload-plugins.ts`
- `src/services/plugins/PluginInstallationManager.ts`
- `src/hooks/useManagePlugins.ts`
- `src/utils/plans.ts`
- `src/utils/conversationRecovery.ts`
- `src/utils/sessionStorage.ts`

把 repo 里现成的 marker clearing、active refresh、plan recovery 与 transcript tombstone removal 并排，
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
| authoritative marker clearing | `src/utils/plugins/cacheUtils.ts:69-92,122-171` | 为什么 `.orphaned_at` 只有在 authoritative installed set 重新声明该版本时才会被清除 |
| active plugin resurrection | `src/utils/plugins/refresh.ts:1-85`; `src/commands/reload-plugins/reload-plugins.ts:1-42` | 为什么 marker clearing / disk presence 不等于 active components 已重新回到当前 session |
| explicit re-entry gate | `src/services/plugins/PluginInstallationManager.ts:47-113,149-176`; `src/hooks/useManagePlugins.ts:288-303` | 为什么 repo 明确要求 `/reload-plugins` 作为 re-entry signal，而不是默认自动接纳 |
| lineage-based plan recovery | `src/utils/plans.ts:164-279`; `src/utils/conversationRecovery.ts:540-555` | 为什么 plan resurrection 需要 lineage、evidence 与 identity policy，而不是简单 undelete |
| deletion-only tombstone path | `src/utils/sessionStorage.ts:1466-1473` | 为什么 tombstone consumption 本身不自动携带 resurrection grammar |

## 4. plugin 线先证明：`.orphaned_at` 被清掉，并不等于插件已经重新回到当前 active world

`cacheUtils.ts:69-92` 很清楚。
orphan cleanup 的 Pass 1 会：

1. 先读取 `installed_plugins.json`
2. 形成 authoritative `installedVersions`
3. 只对这个集合里的 version path 执行 `removeOrphanedAtMarker()`

这说明：

`谁配清墓碑`

不是 marker 自己决定的，
而是由 authoritative installed state 决定。

但这只是第一步。
`refresh.ts:1-85` 又明确把 plugin world 拆成三层：

1. intent
2. materialization
3. active components

而 `refreshActivePlugins()` 被直接命名为：

`Layer-3 refresh primitive`

`reload-plugins.ts:1-42` 也进一步说明：
用户显式运行 `/reload-plugins`，才会触发 `refreshActivePlugins(context.setAppState)`。

这说明 plugin resurrection 至少包含两层不同问题：

1. 墓碑能不能清
2. 清掉后是否重新进入 active components world

源码明确告诉我们：
这两件事不是同一个主权。

## 5. `needsRefresh` 再证明：repo 明确拒绝把“对象重新存在”偷写成“当前会话已经重新接纳它”

`PluginInstallationManager.ts:47-113,149-176` 写得很直白：

1. new installs 才可能 auto-refresh
2. updates only 则设置 `needsRefresh`
3. `useManagePlugins.ts:288-303` 再提示用户：`Plugins changed. Run /reload-plugins to activate.`
4. 注释明确要求：`Do NOT auto-refresh`

也就是说，
Claude Code 在 plugin 线上明确承认：

`对象已经在 disk world 更新`

和

`对象已经被当前 active world 接纳`

不是同一件事。

这条设计避免系统因为“墓碑清了”或“新对象到盘了”就提前声称当前运行时已恢复正确。

## 6. plan 线给出第二个强正例：对象复活时，系统还要治理它是沿原 identity 回来，还是以新 identity 回来

`plans.ts:164-229` 的 `copyPlanForResume()` 很值钱。

它不是看到 plan file 缺失就粗暴恢复。
它要求：

1. log 里确实有 slug
2. 把 slug 绑定回 original session ID
3. 只在 remote session 才尝试 recovery
4. 优先用 file snapshot
5. 失败后才回到 message history

这说明 plan resurrection 的本体不是：

`内容还在，就给你拉回来`

而是：

`只有在 lineage 和 evidence 都成立时，才允许对象重新进入 current session world。`

更关键的是 `copyPlanForFork():234-258`：

1. 不复用 original slug
2. 生成 new slug
3. 写入 new file 避免 clobber

这直接证明：

`内容回来`

不等于

`原身份回来`

也就是说 resurrection governance 还必须回答：

`re-entry 后对象到底算 old identity 还是 new identity。`

## 7. conversationRecovery 再说明：复活不是局部 helper 的偶发行为，而是被正式接进恢复主线

`conversationRecovery.ts:540-555` 并不是随手调用 `copyPlanForResume()`。
它把 plan recovery 接进了恢复主线，
说明 resurrection 不是局部 helper 的偶发行为，而是正式恢复制度的一部分。

这对 stronger-request cleanup 的启示很强：

`真正的 resurrection governance 不会只停在局部 helper，它必须进入正式恢复链。`

## 8. tombstone 删除路径反证：删除 grammar 的存在不自动携带复活 grammar

`sessionStorage.ts:1466-1473` 的 tombstone 删除接口只回答：

`从 transcript 中删掉被 tombstone 的消息。`

它并没有再回答：

`这些对象在什么条件下还能回来。`

这说明：

1. tombstone consumption 是 deletion grammar
2. resurrection governance 是 re-entry grammar
3. 前者的存在不自动携带后者

对 stronger-request cleanup 线的启示非常直接：

`旧 cleanup marker 留下来了，不等于旧 cleanup object 就获得了重新进入 current world 的资格。`

## 9. 这篇源码剖面给主线带来的四条技术启示

### 启示一

repo 已经在 plugin 线明确展示：

`authoritative marker clearing` 不等于 `active re-entry`。

### 启示二

repo 已经在 plugin 管理链里明确展示：

`needsRefresh` / `/reload-plugins` 是正式的 re-entry gate，而不是 UI 附加提示。

### 启示三

repo 已经在 plan 线明确展示：

`resurrection` 必须同时治理 lineage、evidence 与 identity policy。

### 启示四

cleanup 线如果只补 tombstone grammar，
却不补：

1. re-entry gate
2. identity policy
3. active-layer admission

那么旧 cleanup 世界就会以“marker 留下了，但谁配回来没人正式回答”的方式继续制造歧义。

## 10. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 只要补出 tombstone governance，就已经足够成熟。`

而是：

`repo 在 authoritative marker clearing、active refresh、explicit re-entry gate 与 lineage-based plan recovery 上已经明确展示了 resurrection governance 的存在；因此 artifact-family cleanup stronger-request cleanup-tombstone-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-resurrection-governor signer。`

因此：

`cleanup 线真正缺的不是“怎样留下墓碑”，而是“带着墓碑的旧对象凭什么重新回来”。`
