# tombstone messages、.orphaned_at与migration timestamps的强请求清理墓碑治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `421` 时，
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
| message tombstone control signal | `src/query.ts:712-723`; `src/utils/messages.ts:2954-2957`; `src/QueryEngine.ts:757-760` | 为什么 orphaned message 不会只静默消失，而会留下 machine-consumable tombstone |
| tombstone execution chain | `src/screens/REPL.tsx:2646-2648`; `src/utils/sessionStorage.ts:121-123,925-945,1470-1473` | 为什么 tombstone 不是描述性文字，而是驱动 UI / transcript 删除的正式控制信号 |
| plugin orphan marker | `src/utils/plugins/cacheUtils.ts:23-24,66-176`; `src/services/plugins/pluginOperations.ts:523-547` | 为什么 `.orphaned_at` 是对象退役后的最小残留标记，而不是单纯垃圾文件 |
| marker-driven visibility control | `src/utils/plugins/orphanedPluginFilter.ts:1-91`; `src/main.tsx:2544-2568` | 为什么 marker 还会继续塑造 future search / visibility world |
| model transition trace | `src/utils/config.ts:427-438`; `src/hooks/notifs/useModelMigrationNotifications.tsx:5-50` | 为什么迁移完成后仍会保留最小历史痕迹去解释当前世界为什么刚变 |

## 4. message 线先证明：对象退役之后，系统可能需要显式 tombstone 来告诉后续消费者“该删谁”

`query.ts:712-723`
很关键。
当 streaming fallback 产生 orphaned messages 时，
系统不是只把旧消息从内存数组里粗暴过滤掉。

它会：

1. 为每个 orphaned message 产生 `type: 'tombstone'`
2. 记录 `tengu_orphaned_messages_tombstoned`
3. 清空与旧尝试关联的临时结构

`utils/messages.ts:2954-2957`
进一步说明：
遇到 tombstone，stream handler 不把它当内容渲染，而是走 `onTombstone` 分支。

`QueryEngine.ts:757-760`
则更明确：

`tombstone messages are control signals for removing messages`

也就是说，在 message 线里：

`对象结束`

和

`留下一个最小控制信号去驱动正确删除`

根本不是同一件事。

## 5. tombstone execution chain 再证明：墓碑不是一句说明，而是驱动 UI / transcript 改口的正式控制面

`REPL.tsx:2646-2648`
收到 tombstoned message 时，
会立刻：

1. 从当前消息列表里过滤该消息
2. 调 `removeTranscriptMessage(tombstonedMessage.uuid)`

而
`sessionStorage.ts:1470-1473`
则明确把这件事定义成：

`Used when a tombstone is received for an orphaned message`

更进一步，
`sessionStorage.ts:925-945`
专门为 tombstone removal 维护 slow path rewrite，
而
`sessionStorage.ts:121-123`
还要用 `MAX_TOMBSTONE_REWRITE_BYTES`
避免 tombstone rewrite 把超大 transcript 文件拖进 OOM。

这说明 tombstone 的语义不是：

`写一条历史说明，给人随便看看。`

而是：

`给系统一个继续消费的控制信号，让后续存储与显示世界一起改口。`

## 6. plugin 线给出第二个强正例：`.orphaned_at` 不是垃圾残留，而是被治理的机器墓碑

`cacheUtils.ts:23-24,66-176`
与
`pluginOperations.ts:523-547`
表明：

1. 插件被卸载或更新到新版本后，旧版本先被打上 `.orphaned_at`
2. orphan GC 会先消费 marker，再根据 age 做后续删除
3. `pluginOperations.ts` 直接把 `tombstones` 视为 teardown fallout

所以 `.orphaned_at` 更像一块真正的机器墓碑，
而不是普通元数据文件。

## 7. marker-driven exclusion 再证明：墓碑不是只服务历史解释，它还会主动约束未来读取世界

`orphanedPluginFilter.ts:1-91`
与
`main.tsx:2544-2568`
说明：

1. 先完成 orphan GC
2. 再扫描 `.orphaned_at`
3. 基于 marker 生成 grep / glob exclusion patterns
4. 把 exclusion cache 冻结在当前 session

这意味着 `.orphaned_at` 的作用不只是证明旧版本退役过，
它还会继续决定未来的搜索与读取不应再触及哪些目录。

## 8. model migration timestamp 给出第三类正对照：有些墓碑不长得像 tombstone，但功能上就是“变化已经发生过”的最小残留事实

`config.ts:427-438`
定义了：

1. `opusProMigrationTimestamp`
2. `legacyOpusMigrationTimestamp`
3. `sonnet45To46MigrationTimestamp`

这些字段都不是迁移动作本身，
也不是 retirement date 本身。
但
`useModelMigrationNotifications.tsx:5-50`
继续消费它们来判断：

1. 这次启动是否刚刚发生过模型迁移
2. 当前 runtime 是否需要一次性的历史解释

这说明有些残留物虽然源码里不直接叫 tombstone，
但功能上确实承担了 tombstone-like marker 的职责：

`它们是变化已经发生过的最小历史事实，用于向当前系统解释为什么现在变了。`

## 9. 这篇源码剖面给主线带来的七条技术启示

1. 结束对象和留下残留 marker 是两层不同治理。
2. 墓碑最成熟的形式往往是机器可消费的 control signal，而不是人类说明句。
3. marker 的职责不只是记史，还包括继续约束未来搜索、恢复与解释。
4. `.orphaned_at` 这类文件不是垃圾，而是 sunset 之后仍被制度化消费的最小残留事实。
5. migration timestamp 这类 trace artifact 证明并非所有 tombstone 都需要长得像“墓碑消息”，但功能上仍属于 post-retirement residue。
6. rewrite budget 也是 tombstone grammar 的组成部分，因为后事治理仍受资源上限约束。
7. stronger-request cleanup 如果未来要长出 tombstone-governor plane，关键不只是“保留一个 note”，而是明确 marker type、consumer set 与 future effect。

## 10. 苏格拉底式自反诘问：我是不是又把“旧世界已经正式结束”误认成了“结束后的解释义务也结束了”

如果对这一层做更严格的自我审查，
至少要追问八句：

1. 如果 sunset time 已经明确，为什么还要再拆 tombstone？
   因为知道何时结束，不等于知道结束后还要留下什么最小事实。
2. 如果对象已经不再有效，为什么不直接删干净？
   因为未来读取、恢复、审计与解释仍可能需要一个最小 marker，防止误复活或误叙述。
3. 如果 marker 还在，是不是说明旧世界仍有效？
   不是。marker 正是在表达“旧世界已经失效”这一最小事实。
4. 如果 warning 或 timestamp 已经解释过一次，是否就不再需要 tombstone grammar？
   不够。warning 面向人类，tombstone 还必须面向机器后续消费。
5. 如果 `.orphaned_at` 这类 marker 只存在于 plugin 线，cleanup 线是不是可以不需要？
   不能这样推。不同 marker 形式可以不同，但“谁来签 post-retirement residue”必须被回答。
6. 如果 tombstone 只是控制信号，为什么还要区分 consumer set？
   因为 UI、storage、search、audit 消费它的方式和风险都不同，不区分消费者，就不可能区分 future effect。
7. 如果 cleanup 线还没有显式 tombstone 代码，是不是说明这层还不值得写？
   恰恰相反。越是缺这层明确 grammar，越容易在未来把退役后的残留义务偷写成“反正已经结束了”。
8. 如果我继续把 tombstone 当成 sunset 的副产品，会漏掉什么？
   会漏掉 marker type、consumer、rewrite budget、future effect 与 second-stage cleanup authority 这些真正决定“后事是否被治理”的制度对象。

这一串反问最终逼出一句更稳的判断：

`tombstone 的关键，不在系统会不会保留一点旧痕迹，而在系统能不能正式决定哪些最小残留事实必须留下来继续约束后来者。`

## 11. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 未来只要补出 sunset governance，就已经足够成熟。`

而是：

`Claude Code 在 message tombstone、plugin orphan marker、marker-driven visibility control 与 migration timestamp trace artifact 上已经明确展示了 tombstone governance 的存在；因此 artifact-family cleanup stronger-request cleanup-sunset-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-tombstone-governor signer。`

再压成一句：

`cleanup 线真正缺的不是“谁来宣布旧世界结束”，而是“谁来决定结束后还留下什么最小机器可消费事实”。`
