# 安全载体家族墓碑治理与复活治理分层：为什么artifact-family cleanup tombstone-governor signer不能越级冒充artifact-family cleanup resurrection-governor signer

## 1. 为什么在 `166` 之后还必须继续写 `167`

`166-安全载体家族退役治理与墓碑治理分层` 已经回答了：

`cleanup 线即便以后长出 tombstone governor，也还需要一层正式主权去决定旧世界结束后留下什么最小残留标记。`

但如果继续往下追问，  
还会碰到另一层很容易被误写成“有墓碑就说明以后怎么回来也清楚了”的错觉：

`只要 tombstone governor 已经决定退役后留下什么 marker，它就自动拥有了决定哪些旧对象可以回来、何时回来、以及回来后进入哪一层 current world 的主权。`

Claude Code 当前源码同样不能支持这种更强说法。

因为继续看：

1. `src/utils/plugins/cacheUtils.ts:69-92,122-171` 的 `.orphaned_at` 清除与 orphan GC
2. `src/utils/plugins/refresh.ts:1-85` 与 `src/commands/reload-plugins/reload-plugins.ts:1-42` 的 active plugin refresh grammar
3. `src/services/plugins/PluginInstallationManager.ts:47-113,149-176` 与 `src/hooks/useManagePlugins.ts:288-303` 的 `needsRefresh` / `/reload-plugins` 设计
4. `src/utils/plans.ts:164-279` 的 `copyPlanForResume()`、`copyPlanForFork()` 与 `recoverPlanFromMessages()`
5. `src/utils/conversationRecovery.ts:540-555` 的 resume 调用点
6. `src/utils/sessionStorage.ts:1466-1473` 的 tombstone 删除接口

会发现 repo 已经清楚展示出：

1. `tombstone governance` 负责决定对象退役后留下什么最小残留标记
2. `resurrection governance` 负责决定旧对象在什么证据、什么 lineage、什么 surface、什么 active layer 下可以被重新带回 current world

也就是说：

`artifact-family cleanup tombstone-governor signer`

和

`artifact-family cleanup resurrection-governor signer`

仍然不是一回事。

前者最多能说：

`旧世界结束后，给它留一个 marker。`

后者才配说：

`在什么条件下，这个旧对象还能被重新接纳，重新出现在 current runtime、current path、current active component 或 current transcript world 里。`

所以 `166` 之后必须继续补的一层就是：

`安全载体家族墓碑治理与复活治理分层`

也就是：

`tombstone governor 负责留下退役痕迹；resurrection governor 才负责治理对象怎样从历史世界重新回到当前世界。`

## 2. 先做一条谨慎声明：`artifact-family cleanup resurrection-governor signer` 仍是研究命名，不是源码现成类型

这里同样要先讲清楚：

`Claude Code 当前源码里并没有一个字面存在的类型叫 artifact-family cleanup resurrection-governor signer。`

这里的 `artifact-family cleanup resurrection-governor signer` 仍是研究命名。  
它不是在声称 cleanup 线已经有一个未公开的 resurrection manager，  
而是在说：

1. repo 在 plugin 与 plan 线上已经展示出真实的 resurrection grammar
2. 这些 grammar 回答的是“怎样让历史对象重新回到 current world”
3. cleanup 线如果未来真要把 tombstone world 做完整，也迟早要回答这些“谁配让它回来”的问题

因此 `167` 不是在虚构已有实现，  
而是在给更深的一层缺口命名：

`会留墓碑，不等于会治理对象怎样回来。`

## 3. 最短结论

Claude Code 当前源码至少给出了五类“tombstone-governor signer 仍不等于 resurrection-governor signer”证据：

1. `cacheUtils.ts:69-92,122-171` 并不因为 `.orphaned_at` 存在就自动让旧 plugin version 回来；  
   Pass 1 只会对 `installed_plugins.json` 当前仍声明为已安装的 version path 移除 marker  
   这说明 marker clearing 受 authoritative installed state 治理，而不是由 marker 自己决定
2. `refresh.ts:1-85` 与 `/reload-plugins` command 说明就算 plugin 已重新回到磁盘世界、marker 也被清掉，  
   它仍不自动回到 active components world；  
   `refreshActivePlugins()` 是单独的 Layer-3 resurrection primitive
3. `PluginInstallationManager.ts:47-113,149-176` 与 `useManagePlugins.ts:288-303` 说明 repo 明确把 “disk changed” 和 “active world 接纳它” 拆开：  
   new installs 才可能 auto-refresh，updates 则显式要求用户运行 `/reload-plugins`
4. `plans.ts:164-279` 说明 plan resurrection 也不是“看到旧内容就还原”这么简单；  
   `copyPlanForResume()` 只在 remote sessions 下，且要求 original session lineage、slug 与 snapshot/history evidence 才尝试恢复；  
   `copyPlanForFork()` 甚至明确不复用 original slug，而是生成 new slug 防 clobber
5. `sessionStorage.ts:1466-1473` 的 transcript tombstone 路径只回答怎样删，不回答怎样复活；  
   这说明 tombstone consumption 本身并不自动携带 resurrection grammar

因此这一章的最短结论是：

`tombstone governor 最多能说对象退役后留下什么；resurrection governor 才能说哪些退役对象在何种证据与何种层面下可以重新回来。`

再压成一句：

`会留墓碑，不等于会让它回来。`

## 4. 第一性原理：tombstone governance 回答“留什么残留物”，resurrection governance 回答“凭什么重新接纳它”

从第一性原理看，  
墓碑治理与复活治理处理的是两个不同方向的主权问题。

tombstone governor 回答的是：

1. 对象退役后是否留 marker
2. marker 是 tombstone、timestamp、warning 还是 dotfile
3. 哪些读取面要继续消费这个 marker
4. marker 何时再被进一步清除
5. 它怎样避免未来误读旧世界

resurrection governor 回答的则是：

1. 哪些历史对象允许重新回到 current world
2. 需要什么 evidence 才能回来
3. 回来的是同一 identity，还是 new identity
4. 回来的是 disk/materialized world，还是 active/runtime world
5. 谁来决定 re-entry 后的可见性、冲突边界与 lineage

如果把这两层压成一句“反正 marker 还在或 marker 已清掉”，  
系统就会制造五类危险幻觉：

1. marker-clear-means-resurrection illusion  
   只要墓碑被清掉，就误以为对象已经正式回到 current world
2. disk-return-means-active-return illusion  
   只要对象重新出现在磁盘上，就误以为运行时已经重新接纳它
3. content-recovered-means-identity-restored illusion  
   只要历史内容被恢复，就误以为原 identity 和原 ownership 也被恢复
4. tombstone-is-bidirectional illusion  
   误以为同一 marker grammar 既定义退役，也自动定义复活
5. any-old-object-can-come-back illusion  
   误以为只要历史对象曾经存在，就都可以不经额外授权重新成为 current truth

所以从第一性原理看：

`tombstone governor` 决定对象退役后留下什么最小痕迹；  
`resurrection governor` 决定对象凭什么、以什么身份、在什么层面重新回来。

## 5. plugin 线给出最强正例：清除 `.orphaned_at` 不等于对象已经回到 current active world

`cacheUtils.ts:69-92` 很关键。  
orphan cleanup 的 Pass 1 会：

1. 先读取 `installed_plugins.json`
2. 形成 `installedVersions` 集合
3. 只对这个 authoritative set 里的 version path 调 `removeOrphanedAtMarker()`

这说明：

`谁配清墓碑`

并不是 marker 自己说了算，  
也不是“看起来像重新安装过了”就算。  
它必须以 authoritative installed state 为准。

但这还不是 resurrection 的全部。

继续看 `refresh.ts:1-85` 与 `reload-plugins.ts:1-42`：  
repo 明确把 plugin world 分成三层：

1. Layer 1: intent
2. Layer 2: materialization
3. Layer 3: active components

`refreshActivePlugins()` 被直接命名成：

`Layer-3 refresh primitive: swap active plugin components in the running session`

而且 `refresh.ts:77-80` 还明确写出：

`/reload-plugins` 是 session-frozen exclusions 与 active components 的显式 re-read signal

这意味着：

1. `.orphaned_at` 被清掉，只能说明对象在 disk/materialized truth 上不再处于 orphan world
2. 它仍不自动说明 current session 的 active components 已经接纳它
3. 真正把它带回 running session 的，是单独的 resurrection grammar：`refreshActivePlugins()` / `/reload-plugins`

这就是最标准的：

`tombstone clearing != resurrection authority`

## 6. `needsRefresh` 再证明：Claude Code 不把“对象重新存在”偷写成“当前运行时已经承认它重新有效”

`PluginInstallationManager.ts:47-113,149-176` 与 `useManagePlugins.ts:288-303` 给出了更清楚的分层。

这里的制度非常谨慎：

1. 新 marketplace installs 有时会 auto-refresh
2. updates only 则会显式设置 `needsRefresh`
3. UI 再给用户提示：`Plugins changed. Run /reload-plugins to activate.`
4. 注释还明确写出：Do NOT auto-refresh，Do NOT reset `needsRefresh`

这意味着 repo 明确承认：

`对象已被 materialize / update`

和

`对象已被当前 active world 正式接纳`

不是同一个时刻，  
更不是同一个主权。

从安全设计看，这种克制非常先进。  
它防止系统因为“磁盘上有了新对象”就过早宣称当前 runtime 已经恢复正确。  
也就是说，  
真正成熟的 resurrection governance 会继续问：

`哪一层 world 已经回来，哪一层还没回来。`

## 7. plan 线给出第二个强正例：内容复活不等于 identity 复活

`plans.ts:164-279` 的 `copyPlanForResume()` / `copyPlanForFork()` 特别值钱。

`copyPlanForResume()` 并不是看到 plan file 缺失就一律恢复。  
它要求：

1. log 里有 slug
2. 把 slug 重新绑定到 original session ID
3. 只有在 remote sessions 才尝试 recovery
4. 先看 file snapshot
5. 再退回 message history
6. 两者都没有才放弃

这说明 plan resurrection 的本体不是：

`旧内容在，那就拿回来`

而是：

`有足够 lineage 和 evidence，才允许把旧 plan 重新带回 current session world。`

更强的是 `copyPlanForFork()`：

1. 它不会复用 original slug
2. 而是生成 new slug
3. 明确避免 original 与 forked session clobber

这等于直接写明：

`恢复内容`

并不等于

`恢复原身份`

也就是说，  
resurrection governance 还必须回答：

`对象回来时，是以 old identity 回来，还是以 new identity 回来。`

这已经明显超出了 tombstone governance 的职责。

## 8. message 线给出关键反对照：tombstone path 本身只回答怎样删，并不回答怎样复活

`sessionStorage.ts:1466-1473` 的 `removeTranscriptMessage()` 很干净。  
它只回答：

`收到 tombstone 后怎样把目标消息从 transcript 删掉。`

`QueryEngine.ts:756-759` 也只把 tombstone 当作 remove control signal。  
这里没有哪一处暗示：

`因为曾经有 tombstone，所以后面也自然有 resurrection grammar。`

这条反对照很重要。  
它提醒我们：

`拥有良好的 tombstone discipline，不自动代表拥有良好的 resurrection discipline。`

所以 cleanup 线未来如果只学到：

1. 如何给旧 path 打标
2. 如何给旧 promise 降级
3. 如何给旧 receipt 留下注脚

仍然不等于它已经回答：

`哪些旧对象可以重新进 current world。`

## 9. 技术先进性：Claude Code 真正先进的地方，是它在多个子系统里把“墓碑被消费”与“对象被重新接纳”继续拆成两层

从技术角度看，Claude Code 在这条线上的先进性，  
不只是它会删 marker、会做 recovery。  
更值钱的是它已经在多个子系统里承认：

1. marker removal 不等于 active re-entry
2. disk presence 不等于 runtime acceptance
3. history recovery 不等于 identity restoration
4. automatic cleanup 不等于 authorized revival
5. current world 的接纳应当是显式的、分层的、带证据的

这背后的设计启示非常强：

`真正成熟的系统，不只知道对象退役后留什么墓碑，还知道对象想回来时，必须经过另一套单独的复活治理。`

因此对 cleanup 线最关键的技术启示不是：

`给旧对象留 marker，再提供一个去 marker 的函数。`

而是：

`必须同时补 tombstone grammar 和 resurrection grammar。`

否则系统会停在另一种危险的半治理状态：

`大家都知道旧对象退役过，也知道 marker 能被清掉，但没人知道清掉之后它是否真的、以及以什么身份重新回到了 current world。`

## 10. 苏格拉底式自诘：我的判断有没有再次越级

为了避免把“源码里有恢复函数”直接写成“cleanup 线只差照抄恢复函数”，  
这里必须主动追问自己四个问题。

### 第一问

`我是不是把任何 marker 清除都当成 resurrection？`

不能这样写。  
marker clearing 最多说明 tombstone 被撤销；  
对象是否真的回到 current runtime / current identity / current active world，  
还要看单独的 re-entry grammar。

### 第二问

`tombstone governor 和 resurrection governor 一定要做成两个模块吗？`

也不能这么绝对。  
它们可以由同一实现承载，  
但回答的问题不同：  
一个回答“退役后留什么”，  
一个回答“后来凭什么回来”。

### 第三问

`如果 cleanup 线将来只有很小的恢复路径，也还需要 resurrection governance 吗？`

只要旧 path、旧 promise 或旧 receipt 还有可能重新被 current world 接纳，  
就至少要回答：

`谁配让它回来，以及回来的是哪一层 truth。`

这已经是 resurrection 问题。

### 第四问

`我真正该继续约束自己的是什么？`

是这句：

`不要把 marker clearing、disk return、active return 与 identity return 混成同一个 resurrection 事件。`

当前更稳妥的说法只能是：
repo 已经在 plugin 与 plan 线上明确展示了 re-entry grammar，
但这些 grammar 本身就要求继续区分：

1. tombstone 被撤销
2. 对象重新出现在 materialized world
3. active/runtime world 重新接纳它
4. identity 是否仍算原来那个 seat

因此本章能成立的是：

`tombstone != resurrection`

不能偷加的 stronger claim，
则是：

`任何 comeback 都已经被单一 resurrection 事件完整覆盖。`

## 11. 一条硬结论

这组源码真正说明的不是：

`Claude Code 只要决定了 cleanup 旧世界退役后留下什么墓碑，就已经自动拥有了治理哪些旧对象可以重新回到 current world 的主权。`

而是：

`repo 在 authoritative marker clearing、Layer-3 plugin refresh、needsRefresh / reload-plugins、plan recovery 与 forked new-slug policy 上已经明确展示了 resurrection governance 的存在；因此 artifact-family cleanup tombstone-governor signer 仍不能越级冒充 artifact-family cleanup resurrection-governor signer。`

再压成最后一句：

`墓碑负责让旧对象退场后可被正确记住；复活，才负责决定它是否还能回来、以及回来时算谁。`
