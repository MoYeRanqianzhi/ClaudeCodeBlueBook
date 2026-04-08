# tombstone messages、.orphaned_at与migration timestamps的强请求清理墓碑治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `389` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 旧世界何时不再算当前世界，`

而是：

`旧 stronger-request cleanup 世界即便已经退役，结束之后还留下什么最小标记来约束未来解释。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`sunset governor 不等于 tombstone governor。`

这句话还不够硬。

所以这里单开一篇，
只盯住：

- `src/query.ts`
- `src/utils/messages.ts`
- `src/QueryEngine.ts`
- `src/screens/REPL.tsx`
- `src/utils/sessionStorage.ts`
- `src/utils/plugins/cacheUtils.ts`
- `src/services/plugins/pluginOperations.ts`
- `src/utils/plugins/orphanedPluginFilter.ts`
- `src/main.tsx`
- `src/utils/config.ts`
- `src/hooks/notifs/useModelMigrationNotifications.tsx`

把 repo 里现成的 `tombstone messages`、`.orphaned_at` 与 migration timestamps 并排，
直接钉死 stronger-request cleanup 线当前仍缺的不是“退役时钟”，
而是 `post-retirement marker grammar`。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 sunset，没有 tombstone。`

而是：

`Claude Code 在 message、plugin 与 model 三条线上已经明确把“对象结束”和“结束后还留下什么最小残留标记”拆成两层；stronger-request cleanup 线当前缺的不是这种思想，而是这套墓碑治理还没被正式接到旧 cleanup artifact family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| message tombstone control signal | `src/query.ts:706-722`; `src/utils/messages.ts:2948-2960`; `src/QueryEngine.ts:757-760` | 为什么 orphaned message 不会只静默消失，而会留下 machine-consumable tombstone |
| tombstone execution chain | `src/screens/REPL.tsx:2646-2648`; `src/utils/sessionStorage.ts:121-123,925-945,1470-1473` | 为什么 tombstone 不是描述性文字，而是驱动 UI / transcript 删除的正式控制信号 |
| plugin orphan marker | `src/utils/plugins/cacheUtils.ts:23-24,149-176`; `src/services/plugins/pluginOperations.ts:523-547` | 为什么 `.orphaned_at` 是对象退役后的最小残留标记，而不是单纯垃圾文件 |
| marker-driven visibility control | `src/utils/plugins/orphanedPluginFilter.ts:1-15,25-26,35-37,47-87`; `src/main.tsx:2544-2568` | 为什么 marker 还会继续塑造 future search / visibility world |
| model transition trace | `src/utils/config.ts:427-438`; `src/hooks/notifs/useModelMigrationNotifications.tsx:5-8,21-33,49-50` | 为什么迁移完成后仍会保留最小历史痕迹去解释当前世界为什么刚变 |

## 4. message 线先证明：对象退役之后，系统可能需要显式 tombstone 来告诉后续消费者“该删谁”

`query.ts:706-722`
很关键。
当 streaming fallback 产生 orphaned messages 时，
系统不是只把旧消息从内存数组里粗暴过滤掉。

它会：

1. 为每个 orphaned message 产生 `type: 'tombstone'`
2. 记录 `tengu_orphaned_messages_tombstoned`
3. 清空与旧尝试关联的临时结构

更重要的是，
注释直接解释了这样做的原因：

`These partial messages ... have invalid signatures`

也就是说，
这里的 tombstone 不是美化性命名，
而是为了阻止后续消费者继续把一段已失效对象误当成可增量修改的 current truth。

`utils/messages.ts:2948-2960`
进一步说明：
遇到 tombstone，stream handler 不把它当内容渲染，而是走 `onTombstone` 分支。

`QueryEngine.ts:757-760`
则更明确：

`tombstone messages are control signals for removing messages`

这意味着在 message 线里，

`对象结束`

和

`留下一个最小控制信号告诉后来者怎样处理这个结束`

从一开始就是两层不同语义。

## 5. UI / transcript 线再证明：墓碑不是“记史”而已，它还必须驱动世界改写，而且改写本身也受预算治理

`REPL.tsx:2646-2648`
把 tombstone consumer 写得非常直白：

1. 从 UI message list 里过滤掉目标消息
2. 调 `removeTranscriptMessage(tombstonedMessage.uuid)`

也就是说，
tombstone 一旦出现，
它不只是解释“这条消息已经不算”，
而是正式命令两个下游世界同时改口：

1. 可见消息世界
2. transcript 存储世界

`sessionStorage.ts`
又把这件事继续做硬：

1. `MAX_TOMBSTONE_REWRITE_BYTES = 50MB`  
   `121-123`
2. 如果目标不在 fast path 末尾窗口里，才进入 slow-path 全文件重写  
   `925-945`
3. 如果文件过大，则直接 warn 并放弃 slow path  
   `925-945`
4. `removeTranscriptMessage()` 的注释明确写着：  
   `Used when a tombstone is received for an orphaned message.`  
   `1470-1473`

这组代码说明了两个更深的设计事实：

1. tombstone 是正式 control surface，不是可有可无的解释句子
2. 即便是“删除失效对象”这种看似天然正确的动作，也必须受资源上限治理

换句话说，
Claude Code 不只是会说“旧对象该没了”，
它还会问：

`为了让这个“该没了”真正落地，我们最多愿意付出多大的 rewrite 代价。`

这是非常成熟的安全设计思路，
因为它拒绝把无限成本伪装成安全正确性的一部分。

## 6. plugin 线继续证明：`.orphaned_at` 是磁盘世界里的 delayed tombstone，而不是普通清理细节

`cacheUtils.ts:23-24`
先定义：

1. `ORPHANED_AT_FILENAME = '.orphaned_at'`
2. `CLEANUP_AGE_MS = 7 days`

`149-176`
再把对象退役流程写成：

1. 先找 `.orphaned_at`
2. 没找到就先 `markPluginVersionOrphaned(versionPath)`
3. 找到了就以 marker 的 `mtimeMs` 计算宽限期
4. 超过 7 天才真正 `rm(versionPath, { recursive: true, force: true })`

这意味着 `.orphaned_at` 不是收尾噪音，
而是一个正式的 delayed-delete tombstone。

`pluginOperations.ts:523-547`
更值得注意，
因为它除了在最后一个 scope 卸载时调用 `markPluginVersionOrphaned(installPath)`，
还在注释里直接承认：

`Blocking creates tombstones`

这句话很关键。
它说明源码作者自己已经意识到：

`退役后的残留物`

不是副现象，
而是 teardown graph 无法避免、也必须被治理的制度对象。

所以 plugin 线对 stronger-request cleanup 的启示非常硬：

`旧对象退役之后，留下 marker 不是失败；没有谁为这个 marker 的未来语义签字，才是失败。`

## 7. visibility 线更进一步：marker 不是只给 GC 看，它还继续塑造未来搜索世界

`orphanedPluginFilter.ts:1-15,25-26,35-37,47-87`
做的事情比“以后删盘”更强：

1. 扫描 `.orphaned_at`
2. 把 marker 父目录翻译成 ripgrep `--glob '!<dir>/**'` exclusion
3. 只要 session cache 已经 warm，exclusion list 就冻结到下次显式 `/reload-plugins`

`main.tsx:2544-2568`
又强调了 warmup 的时序：

1. 先初始化 versioned plugins
2. 再跑 orphan GC
3. 再 warm Grep/Glob exclusion cache

注释说得很清楚：

`Sequencing matters`

原因在于：

`warmup scans disk for .orphaned_at markers`

也就是说，
marker 一旦被写下，
它的效力并不只体现在将来可能删除哪个目录，
还体现在当前 session 立刻应该把哪些旧版本从搜索可见世界排除。

这说明 tombstone governance 的真正力量不在“给过去立碑”，
而在：

`它持续约束未来解释。`

一个对象已经 retired，
但如果后来者还能在 grep / glob world 里把它误看成当前代码，
那 retirement 就只是半成品。

## 8. model 线给出另一种墓碑：migration timestamp 不是删除标记，却仍是 tombstone-like trace artifact

`config.ts:427-438`
把：

1. `opusProMigrationTimestamp`
2. `legacyOpusMigrationTimestamp`
3. `sonnet45To46MigrationTimestamp`

写成 global config 的正式字段。

这些字段都不是迁移动作本身，
也不是 retirement date 本身。
但
`useModelMigrationNotifications.tsx:5-8,21-33,49-50`
继续消费它们来判断：

1. 这次启动是否刚刚发生过模型迁移
2. 当前 runtime 是否需要一次性的历史解释
3. 超过 `recent(ts) < 3000ms` 后，这个历史解释窗口自动关闭

这说明有些残留物虽然源码里不直接叫 tombstone，
但功能上确实承担了 tombstone-like marker 的职责：

`它们是变化已经发生过的最小历史事实，用于向当前系统解释为什么现在变了。`

更进一步说，
这种 marker 不是为了让旧世界继续有效，
而是为了防止当前世界在没有最小历史上下文的情况下被误解。

## 9. 这篇源码剖面给主线带来的七条技术启示

1. 结束对象和留下残留 marker 是两层不同治理。
2. 墓碑最成熟的形式往往是机器可消费的 control signal，而不是人类说明句。
3. marker 的职责不只是记史，还包括继续约束未来搜索、恢复与解释。
4. `.orphaned_at` 这类文件不是垃圾，而是 sunset 之后仍被制度化消费的最小残留事实。
5. migration timestamp 这类 trace artifact 证明并非所有 tombstone 都需要长得像“墓碑消息”，但功能上仍属于 post-retirement residue。
6. destructive rewrite 必须有成本上限，否则 tombstone 自己会变成新的资源风险。
7. stronger-request cleanup 如果未来要长出 tombstone-governor plane，关键不只是“保留一个 note”，而是明确 marker type、consumer set、future effect 与 second-stage responsibility。

## 10. 苏格拉底式自反诘问：我是不是又把“旧世界已经正式结束”误认成了“旧世界结束后的一切解释义务也结束了”

如果对这一层做更严格的自我审查，
至少要追问六句：

1. 如果 sunset time 已经明确，为什么还要再拆 tombstone？  
   因为知道何时结束，不等于知道结束后还要留下什么最小事实。
2. 如果对象已经不再有效，为什么不直接删干净？  
   因为未来读取、恢复、审计与解释仍可能需要一个最小 marker 防止误复活或误叙述。
3. 如果 marker 还在，是不是说明旧世界仍有效？  
   不是。marker 正是在表达“旧世界已经失效”这一最小事实。
4. 如果 warning 或 timestamp 已经解释过一次，是否就不再需要 tombstone grammar？  
   不够。warning 面向人类，tombstone 还必须面向机器后续消费。
5. 如果 `.orphaned_at` 这类 marker 只存在于 plugin 线，cleanup 线是不是可以不需要？  
   不能这样推。不同 marker 形式可以不同，但“谁来签 post-retirement residue”必须被回答。
6. 如果 cleanup 线还没有显式 tombstone 代码，是不是说明这层还不值得写？  
   恰恰相反。越是缺这层明确 grammar，越容易把退役后的残留义务偷写成“反正已经结束了”。

这一串反问最终逼出一句更稳的判断：

`tombstone 的关键，不在系统会不会保留一点旧痕迹，而在系统能不能正式决定哪些最小残留事实必须留下来继续约束后来者。`

## 11. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 未来只要补出 sunset governance，就已经足够成熟。`

而是：

`Claude Code 在 message tombstone、plugin orphan marker、marker-driven visibility control 与 migration timestamp trace artifact 上已经明确展示了 tombstone governance 的存在；因此 artifact-family cleanup stronger-request cleanup-sunset-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-tombstone-governor signer。`

再压成一句：

`cleanup 线真正缺的不是“谁来宣布旧世界结束”，而是“谁来决定结束后还留下什么最小机器可消费事实”。`
