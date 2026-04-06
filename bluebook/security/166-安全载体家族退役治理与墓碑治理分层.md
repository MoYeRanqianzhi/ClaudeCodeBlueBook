# 安全载体家族退役治理与墓碑治理分层：为什么artifact-family cleanup sunset-governor signer不能越级冒充artifact-family cleanup tombstone-governor signer

## 1. 为什么在 `165` 之后还必须继续写 `166`

`165-安全载体家族迁移治理与退役治理分层` 已经回答了：

`cleanup 线即便以后长出 sunset governor，也还需要一层正式主权去决定兼容期何时结束。`

但如果继续往下追问，  
还会碰到另一层很容易被误写成“宣布退役就够了”的错觉：

`只要 sunset governor 已经宣布旧世界不再有效，它就自动拥有了决定退役后还要留下什么最小标记的主权。`

Claude Code 当前源码同样不能支持这种更强说法。

因为继续看：

1. `src/query.ts:713-719` 的 `tombstone` control signal
2. `src/utils/messages.ts:2954-2957`、`src/screens/REPL.tsx:2646-2648` 与 `src/utils/sessionStorage.ts:1466-1473` 的 tombstone 消费链
3. `src/utils/plugins/cacheUtils.ts:56-72,145-171` 的 `.orphaned_at`
4. `src/utils/plugins/orphanedPluginFilter.ts:1-79` 与 `src/main.tsx:2546-2568` 的 marker-driven exclusion grammar
5. `src/utils/config.ts:428-438` 的 migration timestamps
6. `src/hooks/notifs/useModelMigrationNotifications.tsx:1-33` 的 timestamp-driven one-time notification

会发现 repo 已经清楚展示出：

1. `sunset governance` 负责决定对象何时不再算当前正式世界
2. `tombstone governance` 负责决定对象退役后还留下什么最小残留标记，供系统后续删除、隐藏、解释、通知与防止误复活

也就是说：

`artifact-family cleanup sunset-governor signer`

和

`artifact-family cleanup tombstone-governor signer`

仍然不是一回事。

前者最多能说：

`旧世界到这里为止不再算当前 truth。`

后者才配说：

`它退役之后还要留下什么最小标记，让未来 runtime、搜索器、恢复链和读者不会误把“已退役”重新读成“从未存在”或“仍可继续引用”。`

所以 `165` 之后必须继续补的一层就是：

`安全载体家族退役治理与墓碑治理分层`

也就是：

`sunset governor 负责宣布结束；tombstone governor 才负责治理结束之后留下的最小历史标记。`

## 2. 先做一条谨慎声明：`artifact-family cleanup tombstone-governor signer` 仍是研究命名，不是源码现成类型

这里同样要先讲清楚：

`Claude Code 当前源码里并没有一个字面存在的类型叫 artifact-family cleanup tombstone-governor signer。`

这里的 `artifact-family cleanup tombstone-governor signer` 仍是研究命名。  
它不是在声称 cleanup 线已经有一个未公开的 tombstone manager，  
而是在说：

1. repo 在 message / plugin / model 线已经展示出一组真实的 marker grammar
2. 这些 marker grammar 不等于 sunset deadline 本身
3. 它们承担的是退役后的最小残留事实表达

因此 `166` 不是在虚构已有实现，  
而是在给更深的一层缺口命名：

`会宣布旧世界结束，不等于会治理结束后该留下什么。`

## 3. 最短结论

Claude Code 当前源码至少给出了五类“sunset-governor signer 仍不等于 tombstone-governor signer”证据：

1. `query.ts:713-719` 遇到 orphaned messages 时不会只静默丢弃旧消息，而是显式 `yield { type: 'tombstone' }`；  
   `utils/messages.ts:2954-2957`、`REPL.tsx:2646-2648` 与 `sessionStorage.ts:1466-1473` 再消费它，把消息从 UI 与 transcript 移除  
   这说明对象退役后，系统还要治理一张最小控制信号
2. `QueryEngine.ts:756-759` 明确把 tombstone 当成 control signal 而不是普通内容，说明 tombstone 不是日志附言，而是 runtime grammar 的一部分
3. `cacheUtils.ts:56-72,145-171` 的 `.orphaned_at` 不是 sunset deadline 本身，而是退役后留在磁盘上的最小 marker；  
   它既驱动后续 7 天删除，也驱动重新安装时的 stale-marker 清除
4. `orphanedPluginFilter.ts:1-79` 与 `main.tsx:2546-2568` 证明 `.orphaned_at` 还会被转译成 grep/glob exclusion patterns，  
   说明 tombstone 不只是“记录发生过”，还会持续塑造未来读取世界
5. `config.ts:428-438` 中的 `opusProMigrationTimestamp`、`legacyOpusMigrationTimestamp`、`sonnet45To46MigrationTimestamp` 虽然源码不直接叫 tombstone，  
   但它们承担的是迁移完成后的最小历史留痕；`useModelMigrationNotifications.tsx:1-33` 正是靠这些残留标记决定要不要向用户解释“世界为什么刚刚变了”

因此这一章的最短结论是：

`sunset governor 最多能说旧世界何时结束；tombstone governor 才能说结束之后留下什么最小残留标记来约束未来解释。`

再压成一句：

`会退役，不等于会留下正确的退役痕迹。`

## 4. 第一性原理：sunset governance 回答“何时无效”，tombstone governance 回答“无效后还保留什么最小事实”

从第一性原理看，  
退役治理与墓碑治理处理的是两个不同真相面的主权问题。

sunset governor 回答的是：

1. 旧世界从哪个日期、哪个版本、哪次启动起不再有效
2. 兼容期是否结束
3. dual-world 是否切成 hard close
4. 旧对象是否不再允许继续被 runtime 接受
5. 旧语义是否应被正式降级成历史世界

tombstone governor 回答的则是：

1. 旧对象退役后是否要留一个 control signal
2. 这个 signal 是 timestamp、marker、warning、tombstone message 还是其他最小残留物
3. 哪些子系统仍应消费这个 marker
4. 这个 marker 何时再被进一步清除
5. 它是给未来读者解释历史，还是给 runtime 防止误复活，还是两者兼有

如果把这两层压成一句“反正已经宣布退役”，  
系统就会制造五类危险幻觉：

1. retired-means-silent-disappearance illusion  
   只要对象已退役，就误以为应该无痕消失
2. no-marker-needed illusion  
   只要 hard close 成立，就误以为未来读者和 runtime 不需要最小历史标记
3. deletion-equals-explanation illusion  
   只要删掉旧对象，就误以为已经解释了它为何消失
4. residue-equals-trash illusion  
   只要还有残留物，就误以为它只是垃圾，而不是受治理的 marker
5. marker-equals-sunset illusion  
   只要看到 marker，就误以为 marker 自己就是退役时点，而不是退役之后的约束媒介

所以从第一性原理看：

`sunset governor` 决定对象什么时候失效；  
`tombstone governor` 决定对象失效后，系统还保留什么最小事实来避免未来继续说谎。

## 5. 消息系统给出最硬正例：对象退役之后，Claude Code 并不会只让它静默蒸发，而是显式产出 `tombstone`

`query.ts:713-719` 非常关键。  
当 streaming fallback 造成 orphaned assistant messages 时，  
系统并不是简单地把旧 partial messages 从内存里扔掉。

它会：

1. 为每个 orphaned message `yield { type: 'tombstone' }`
2. 记录 `tengu_orphaned_messages_tombstoned`
3. 清空旧 attempt 遗留的 `assistantMessages`、`toolResults` 与 `toolUseBlocks`

这说明对消息系统来说：

`对象已不再有效`

和

`应留下一个最小控制信号告诉下游怎样处理它`

是两件事。

继续看 `utils/messages.ts:2954-2957`：  
stream handling 遇到 `message.type === 'tombstone'` 时，不是把它当正文内容渲染，而是调用 `onTombstone`。

再看 `REPL.tsx:2646-2648`：  
收到 tombstone 后，REPL 会：

1. 从 `messages` state 里过滤掉被 tombstone 的消息
2. 调 `removeTranscriptMessage(tombstonedMessage.uuid)`

而 `sessionStorage.ts:1466-1473` 又把 tombstone 明确接到 transcript 删除接口上。  
甚至 `sessionStorage.ts:923-944` 还专门处理 tombstone slow path 与大文件 rewrite。

最后 `QueryEngine.ts:756-759` 明确写出：

`Tombstone messages are control signals for removing messages, skip them`

这组代码合在一起说明：

`tombstone` 不是附加注释，也不是单纯可选提示。  
它是退役后最小残留控制面的正式成员。

## 6. plugin 线给出第二个强正例：`.orphaned_at` 不是退役时钟，而是退役后的墓碑标记

`cacheUtils.ts:56-72` 的 `markPluginVersionOrphaned()` 和注释非常值钱。

这里的 `.orphaned_at` 不回答：

`这个版本哪一天应该退役`

因为那个问题已经由 orphan 进入 grace world 以及 `CLEANUP_AGE_MS = 7 days` 回答了。  
`.orphaned_at` 回答的是另一件事：

`它既然已经进入退役世界，系统接下来靠什么最小残留物持续记住这一事实。`

继续看 `processOrphanedPluginVersion():145-171`：

1. 如果没有 `.orphaned_at`，就先写入 marker
2. 如果 marker 已存在且超过 7 天，再真正删除

这意味着：

1. sunset/governance 决定旧版本已进入 orphan world
2. tombstone/marker governance 决定 orphan world 通过什么最小残留物被机器持续看见

更强的是 `orphanedPluginFilter.ts:1-79`：

1. 它会扫描 `.orphaned_at`
2. 基于 marker 生成 `--glob '!<dir>/**'` exclusion patterns
3. 把 exclusion cache 冻结在 session 内，除非 `/reload-plugins`

所以 `.orphaned_at` 的作用不仅是“留个痕迹”。  
它还决定：

`未来的搜索世界如何被约束。`

这说明 tombstone governor 的职责甚至比记录历史更强：  
它会继续塑造后来者的读取边界。

## 7. 模型迁移时间戳再给出第三类正对照：退役或迁移之后，系统有时需要保留一个最小历史注脚来解释“为什么现在变了”

`config.ts:428-438` 很重要。  
这里的：

1. `opusProMigrationTimestamp`
2. `legacyOpusMigrationTimestamp`
3. `sonnet45To46MigrationTimestamp`

都不是 migration 脚本本身，  
也不是 sunset 日期本身。

它们更接近一种：

`post-transition trace artifact`

也就是：

`这次变化已经发生过，系统需要留下一个最小历史注脚，供后续解释当前世界为什么变成这样。`

`useModelMigrationNotifications.tsx:1-33` 正是靠这些时间戳决定：

1. 是否在本次启动中发一次 notification
2. 是否提示用户现在已经迁到新模型
3. 是否展示 opt-out 说明

这里必须谨慎说：  
这些 timestamps 在源码里并没有被字面叫作 tombstone。  
但从功能上看，  
它们确实承担了 tombstone-like marker 的职责：

`不再重做迁移，而是留下一个最小残留事实，告诉当前系统这场变化刚刚发生过。`

所以 repo 在模型线上也已经说明：

`世界改变之后，常常还需要一个比“已经改完”更小、但又不能没有的历史标记。`

## 8. cleanup 线当前最核心的缺口：即便 future sunset governor 出现，也仍没有谁被正式授权决定旧 cleanup 世界退役后留下什么最小墓碑

把这些正对照拉回 cleanup 线，  
问题就变得非常具体。

今天即便假设 cleanup 线未来补出了 sunset governor，  
它最多也只是开始回答：

1. 旧 home-root plans 何时不再算当前正式 plan world
2. `cleanupPeriodDays=0` 的旧 startup-delete 强承诺何时不再该被继续那样理解
3. 旧 cleanup receipt semantics 何时从 dual-world 切到 hard close

但它仍没有正式回答：

1. 旧 plan path 退役后是否要留下 marker，告诉未来读者这是历史路径而不是当前 truth
2. 旧 startup-delete promise 退役后是否要留下最小 tombstone，避免读者把“只 suppress future writes”误读成“系统已完成 startup deletion”
3. 旧 cleanup receipt semantics 退役后是否要留下 rejection marker / deprecation note / non-authoritative receipt tag
4. `CleanupResult` 若继续不进入统一 receipt plane，cleanup family 退役后由什么最小残留物解释“哪些东西删过、哪些没删、哪些只是声明过”

也就是说，  
cleanup 线当前真正缺的不只是 sunset grammar，  
还缺一层更细的主权：

`谁配决定退役之后还留下什么最小历史标记。`

而 repo 在 message / plugin / model 线已经证明：

`这层主权本来就应该存在。`

## 9. 技术先进性：Claude Code 真正先进的地方，是它在多个子系统里把“对象结束”与“结束后最小残留物”继续拆成两层

从技术角度看，Claude Code 在这条线上的先进性，  
不只是它会宣布 retirement，  
而是它已经在多个子系统里承认：

1. invalid 之后不一定是 silent disappearance
2. marker 不等于正文，不等于普通通知，而是 machine-consumable control artifact
3. 最小残留物既可以驱动删除，也可以驱动隐藏，也可以驱动解释
4. 受治理的 residue 与未治理的 stale junk 不是同一回事

这背后的设计启示非常强：

`真正成熟的系统，不只知道何时宣布旧世界结束，还知道结束后必须留下多少历史痕迹才足够防止未来继续说谎。`

因此对 cleanup 线最关键的技术启示不是：

`给它补一条 sunset date 或 hard-close switch 就行。`

而是：

`必须同时补 sunset grammar 和 tombstone grammar。`

否则系统会停在另一种危险的半治理状态：

`大家都知道旧世界已经不算数，但未来读者没有任何受治理的最小标记来知道它为何不算数、哪些子系统仍应避开它。`

## 10. 苏格拉底式自诘：我的判断有没有再次越级

为了避免把“源码里存在 marker”直接写成“cleanup 线只差抄一份 marker 即可”，  
这里必须主动追问自己四个问题。

### 第一问

`我是不是把任何 timestamp 或 warning 都一概当成 tombstone？`

不能这样写。  
只有当残留物在对象退役后继续承担解释、隐藏、清理或防误复活职责时，  
它才接近 tombstone grammar。  
普通日志或普通提示不自动具备这一层主权。

### 第二问

`sunset governor 和 tombstone governor 一定要做成两个模块吗？`

也不能这么绝对。  
它们可以由同一实现承载，  
但回答的问题不同：  
一个回答“何时结束”，  
一个回答“结束后还留下什么最小历史痕迹”。

### 第三问

`如果 cleanup 线未来只是很小的语义降级，也还需要 tombstone governance 吗？`

只要旧 path、旧 promise 或旧 receipt 还可能被未来读者、工具或恢复链误读，  
就至少要回答：

`退役后靠什么最小标记告诉他们它已经不是当前 truth。`

这已经是 tombstone 问题。

### 第四问

`我真正该继续约束自己的是什么？`

是这句：

`不要把任何 marker grammar 的存在，误写成 cleanup world 已经拥有完整 tombstone constitution。`

当前更稳妥的说法只能是：
repo 已经展示了 message tombstone、plugin marker 与 migration timestamp 这类残留标记正例，
但这还不自动推出：

`所有 cleanup artifact family 都已经有同等级、同语义的 post-retirement marker grammar。`

## 11. 一条硬结论

这组源码真正说明的不是：

`Claude Code 只要决定了 cleanup 旧世界何时退役，就已经自动拥有了治理退役后最小残留标记的主权。`

而是：

`repo 在 tombstone messages、.orphaned_at markers、marker-driven exclusion grammar 与 migration timestamps 上已经明确展示了 tombstone governance 的存在；因此 artifact-family cleanup sunset-governor signer 仍不能越级冒充 artifact-family cleanup tombstone-governor signer。`

再压成最后一句：

`退役负责宣布对象结束；墓碑，才负责让后来者知道它为何结束、并且别再把它当回事。`
