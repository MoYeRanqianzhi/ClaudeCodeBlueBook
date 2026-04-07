# removeOrphanedAtMarker、refreshActivePlugins与copyPlanForResume的强请求清理复活治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `263` 时，
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
| authoritative marker clearing | `src/utils/plugins/cacheUtils.ts:67-73,82-92,122-130` | 为什么 `.orphaned_at` 只有在 authoritative installed set 重新声明该版本时才会被清除 |
| active plugin resurrection | `src/utils/plugins/refresh.ts:1-18,72-79,123-137`; `src/commands/reload-plugins/reload-plugins.ts:37-56` | 为什么 marker clearing / disk presence 不等于 active components 已重新回到当前 session |
| explicit and mode-sensitive re-entry gate | `src/services/plugins/PluginInstallationManager.ts:56-59,135-179`; `src/hooks/useManagePlugins.ts:287-303` | 为什么 repo 会继续区分 auto-refresh、manual `/reload-plugins` 与 not-yet-admitted worlds |
| lineage-based plan recovery | `src/utils/plans.ts:164-231,239-257`; `src/utils/conversationRecovery.ts:539-547` | 为什么 plan resurrection 需要 lineage、evidence 与 identity policy，而不是简单 undelete |
| deletion-only tombstone path | `src/utils/sessionStorage.ts:1468-1473` | 为什么 tombstone consumption 本身不自动携带 resurrection grammar |

## 4. plugin 线先证明：`.orphaned_at` 被清掉，并不等于插件已经重新回到当前 active world

`cacheUtils.ts:67-73`
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

`refresh.ts:1-18`
又把 plugin world 明确拆成：

1. intent
2. materialization
3. active components

`refresh.ts:72-79,123-137`
继续把 `refreshActivePlugins()` 固定成 Layer-3 refresh primitive：

1. clear plugin caches
2. clear orphan exclusions
3. load active commands / agents / hooks / MCP / LSP
4. consume `needsRefresh`
5. bump `pluginReconnectKey`

再看
`reload-plugins.ts:37-56`，
显式运行 `/reload-plugins`，
系统才会返回：

`Reloaded: ...`

也就是说 plugin 线已经把：

`marker clearing`

和

`active-layer admission`

写成了两个不同主权。

## 5. `needsRefresh` 再证明：repo 明确拒绝把“对象重新存在”偷写成“当前会话已经重新接纳它”

`PluginInstallationManager.ts:56-59`
先给出大前提：

1. `New installs -> auto-refresh plugins`
2. `Updates only -> set needsRefresh`

继续看
`PluginInstallationManager.ts:135-179`：

1. 新 marketplace 安装完成时，repo 会尝试 `refreshActivePlugins()`
2. 但 auto-refresh 失败时，会回退为 `needsRefresh`
3. 如果只是 updates only，系统直接设置 `needsRefresh`

再看
`useManagePlugins.ts:287-303`：

1. `needsRefresh` 的 effect 只发通知
2. 通知文案是：
   `Plugins changed. Run /reload-plugins to activate.`
3. 注释明确写着：
   `Do NOT auto-refresh`

这说明 Claude Code 并不把 resurrection grammar 压成一个粗糙的 “回来 / 不回来” 开关。

它实际上在治理三种不同 world：

1. 可以 auto-admit 的 world
2. 必须 explicit admit 的 world
3. 还没被接纳、只能停在 `needsRefresh` 的 world

这对 stronger-request cleanup 的启示很强：

`真正成熟的 resurrection governance，必须回答“哪种 return path 可以自动被 current world 接纳，哪种必须保持显式”。`

## 6. plan 线给出第二个强正例：对象复活时，系统还要治理 lineage、evidence 与 identity policy

`plans.ts:164-231` 的 `copyPlanForResume()` 很值钱。

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
`plans.ts:239-257`
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

再看
`conversationRecovery.ts:539-547`，
恢复主线会主动调用 `copyPlanForResume(log, asSessionId(sessionId))`，
说明 resurrection 不是局部 helper 的偶发行为，
而是正式恢复制度的一部分。

## 7. tombstone 删除路径反证：删除 grammar 的存在不自动携带复活 grammar

`sessionStorage.ts:1468-1473`
把 tombstone 删除路径写得极其克制：

1. 注释只说：
   `Remove a message from the transcript by UUID.`
2. 场景只说：
   `Used when a tombstone is received for an orphaned message.`
3. 实现只做：
   `removeMessageByUuid(targetUuid)`

它没有再回答：

1. 这些对象在什么条件下还能回来
2. 回来时是否还是原 UUID
3. 回来时谁来宣布它重新成为 current truth

这恰恰是一条非常硬的反证：

`deletion grammar`

和

`re-entry grammar`

本来就不是同一层主权。

## 8. 这篇源码剖面给主线带来的四条技术启示

### 启示一

repo 已经在 plugin 线明确展示：

`authoritative marker clearing` 不等于 `active re-entry`。

### 启示二

repo 已经在 plugin 管理链里明确展示：

`对象重新出现之后，还要区分 auto-admit、manual admit 与 not-yet-admitted 三种回归世界。`

### 启示三

repo 已经在 plan 线明确展示：

`resurrection 还要治理 lineage、evidence 与 identity policy。`

### 启示四

所以 stronger-request cleanup 线真正缺的不是抽象上“承认历史对象也许能回来”，
而是把：

`marker clearing authority`

`re-entry gate`

`identity policy`

`active-layer admission`

正式制度化。

## 9. 苏格拉底式边界自校：什么才算真正的复活治理

### 诘问一

`如果只有 marker clearing，没有 re-entry gate，这算 resurrection governance 吗？`

不算。
这最多说明历史判断被撤销了，
还不说明当前世界已经接纳它。

### 诘问二

`如果只有内容恢复，没有 identity policy，这算 resurrection governance 吗？`

也不稳。
没有 identity policy，
系统就很容易把“内容回来”误当作“旧资格也回来”。

### 诘问三

`如果只有 active admission，没有 lineage/evidence，这算 resurrection governance 吗？`

仍然不完整。
没有 lineage/evidence，
系统就缺少回答“为什么是它、凭什么是它”的最小证明链。

## 10. 一条边界结论

对 stronger-request cleanup 线而言，
Claude Code 当前源码已经足够证明：

`墓碑治理回答“结束后留下什么最小残留事实”，复活治理回答“哪些历史对象在什么证据、什么身份与什么接纳层级下可以重新回来”。`

但源码同样也提醒我们不要越级：

`别把 repo 某些子系统已经存在的 resurrection grammar，直接误写成 stronger-request cleanup 线已经拥有同等完备的 cleanup resurrection constitution。`
