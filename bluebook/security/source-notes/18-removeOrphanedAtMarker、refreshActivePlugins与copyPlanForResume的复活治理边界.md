# removeOrphanedAtMarker、refreshActivePlugins 与 copyPlanForResume 的复活治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `167` 时，  
真正需要被单独钉住的已经不是：

`cleanup 线未来谁来给旧世界留下墓碑，`

而是：

`cleanup 线即便给旧世界留下了墓碑，谁来决定哪些对象还能回来、以及回来时算谁。`

如果这个问题只停在主线长文里，  
最容易被压成一句抽象判断：

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
逼出一句更硬的结论：

`Claude Code 已经在别处明确展示：对象退役后留下墓碑，并不自动回答对象如何重新回到 current world；cleanup 线当前缺的不是这种思想，而是这套复活治理还没被正式接到旧 path、旧 promise 与旧 receipt 世界上。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 tombstone，没有 resurrection。`

而是：

`Claude Code 在 plugin 与 plan 线上已经明确把“留下墓碑”和“重新接纳对象”拆成两层；cleanup 线当前缺的不是文化，而是这套 resurrection governance 还没被正式接到旧 cleanup artifact family 上。`

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

`PluginInstallationManager.ts:47-113,149-176` 特别重要。

它写得很直白：

1. New installs 才可能 auto-refresh
2. Updates only 则设置 `needsRefresh`
3. `useManagePlugins.ts:288-303` 再提示用户：`Plugins changed. Run /reload-plugins to activate.`
4. 注释明确要求：Do NOT auto-refresh

也就是说，  
Claude Code 在 plugin 线上明确承认：

`对象已经在 disk world 更新`

和

`对象已经被当前 active world 接纳`

不是同一件事。

这条设计非常先进。  
它避免系统因为“墓碑清了”或“新对象到盘了”就提前声称当前运行时已恢复正确。

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
它明确在 resume 主线里：

1. 解析 session ID
2. 把 original session ID 传进去
3. 然后再继续 copy file history 与恢复 messages

这说明 plan resurrection 已经不是边缘补丁。  
它是恢复主线中的正式一步。

从安全设计看，这很关键。  
因为它说明真正成熟的 resurrection governance  
不会只停在 “有个 helper 能救回来”，  
而会把：

`何时调用、带什么 lineage、带什么 target identity`

都正式接进主恢复链。

## 8. transcript tombstone 路径给出关键反对照：会删不等于会复活

`sessionStorage.ts:1466-1473` 的 `removeTranscriptMessage()` 很干净。  
它只回答：

`收到 tombstone 后，怎样按 UUID 删掉 transcript entry。`

但它完全不回答：

`将来怎样把这个 message 带回来。`

这条反对照很重要。  
它提醒我们：

`拥有良好的 tombstone discipline，并不自动代表拥有良好的 resurrection discipline。`

也就是说：

`删除 grammar`

和

`复活 grammar`

根本不是同一件事。

## 9. 这篇源码剖面给主线带来的四条技术启示

### 启示一

repo 已经在 plugin 线上明确展示：

`marker clearing`

和

`active re-entry`

是两层主权。

### 启示二

repo 已经在 plan 线上明确展示：

`内容恢复`

和

`identity 恢复`

不是同一件事。

### 启示三

repo 已经在恢复主线里明确展示：

`resurrection` 需要 lineage 与 evidence，而不只是旧对象曾经存在过。

### 启示四

cleanup 线未来如果只补 tombstone grammar，  
却不补：

1. path resurrection
2. promise resurrection
3. receipt resurrection

那么旧 cleanup 世界就会以“大家都知道它退役过，也知道 marker 可能被清掉，但没人知道它什么时候、以什么身份、在什么层面重新回来”的方式继续制造歧义。

## 10. 一条硬结论

这组源码真正说明的不是：

`cleanup 线未来只要补出 tombstone governance，就已经足够成熟。`

而是：

`repo 在 authoritative marker clearing、Layer-3 plugin refresh、needsRefresh / reload-plugins、plan recovery 与 forked new-slug policy 上已经明确展示了 resurrection governance 的存在；因此 artifact-family cleanup tombstone-governor signer 仍不能越级冒充 artifact-family cleanup resurrection-governor signer。`

因此：

`cleanup 线真正缺的不是“谁来给旧世界留墓碑”，而是“谁来决定哪些旧对象还能回来、以及回来时算谁”。`
