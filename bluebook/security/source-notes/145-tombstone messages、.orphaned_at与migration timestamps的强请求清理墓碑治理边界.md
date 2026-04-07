# tombstone messages、.orphaned_at与migration timestamps的强请求清理墓碑治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `294` 时，
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
| message tombstone control signal | `src/query.ts:712-719`; `src/utils/messages.ts:2954-2957`; `src/QueryEngine.ts:757-760` | 为什么 orphaned message 不会只静默消失，而会留下 machine-consumable tombstone |
| tombstone execution chain | `src/screens/REPL.tsx:2646-2648`; `src/utils/sessionStorage.ts:121-123,925-945,1470-1473` | 为什么 tombstone 不是描述性文字，而是驱动 UI / transcript 删除的正式控制信号 |
| plugin orphan marker | `src/utils/plugins/cacheUtils.ts:56-72,149-176`; `src/services/plugins/pluginOperations.ts:523-547` | 为什么 `.orphaned_at` 是对象退役后的最小残留标记，而不是单纯垃圾文件 |
| marker-driven visibility control | `src/utils/plugins/orphanedPluginFilter.ts:1-15,25-26,35-37,47-87`; `src/main.tsx:2544-2568` | 为什么 marker 还会继续塑造 future search / visibility world |
| model transition trace | `src/utils/config.ts:427-438`; `src/hooks/notifs/useModelMigrationNotifications.tsx:5-8,21-33,49-50` | 为什么迁移完成后仍会保留最小历史痕迹去解释当前世界为什么刚变 |

## 4. message 线先证明：对象退役之后，系统可能需要显式 tombstone 来告诉后续消费者“该删谁”

`query.ts:712-719`
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

这正是墓碑治理最关键的一点：

`它保留的不是旧对象本身，而是旧对象已经失效这一事实的最小机器可消费版本。`

## 6. plugin 线给出第二个强正例：`.orphaned_at` 不是垃圾残留，而是被治理的机器墓碑

`cacheUtils.ts:56-72`
的 `markPluginVersionOrphaned()` 与注释已经说明：

1. 插件被卸载或更新到新版本后，旧版本先被打上 `.orphaned_at`
2. 这个 marker 会被后续 orphan cleanup 继续消费

`pluginOperations.ts:523-547`
也明确把最后一个 scope 卸载后的 install path 交给 `markPluginVersionOrphaned()`，
并在注释里直写：

`Blocking creates tombstones`

更重要的是
`cacheUtils.ts:149-176`
里的 `processOrphanedPluginVersion()`：

1. 如果 marker 不存在，先写 marker
2. 如果 marker 超过 7 天，再删目录

这说明 `.orphaned_at` 的职责不是：

`对象还活着`

而是：

`对象已经退役，但系统仍需留下一个最小残留标记来决定后续怎么处理它。`

所以 `.orphaned_at` 更像一块真正的“机器墓碑”，
而不是普通元数据文件。

## 7. marker-driven exclusion 再证明：墓碑不是只服务历史解释，它还会主动约束未来读取世界

`orphanedPluginFilter.ts:1-15,25-26,35-37,47-87`
与
`main.tsx:2544-2568`
特别值钱。

这里的流程是：

1. 先完成 orphan GC
2. 再扫描 `.orphaned_at`
3. 基于 marker 生成 grep / glob exclusion patterns
4. 把 exclusion cache 冻结在当前 session

这意味着 `.orphaned_at` 的作用不只是：

`证明旧版本退役过`

它还会继续决定：

`未来的搜索与读取不应再触及哪些目录。`

这把墓碑治理从“历史注脚”提升成了“未来约束”。

也就是说：

`成熟的 tombstone，不只是留下痕迹，还会继续约束后来者别再走回旧世界。`

## 8. model 迁移时间戳给出第三类正对照：有些墓碑不长得像 tombstone，但功能上就是“变化已经发生过”的最小残留事实

`config.ts:427-438`
定义了：

1. `opusProMigrationComplete`
2. `opusProMigrationTimestamp`
3. `legacyOpusMigrationTimestamp`
4. `sonnet45To46MigrationTimestamp`

这些字段都不是迁移动作本身，
也不是 retirement date 本身。
它们是迁移之后留在 `GlobalConfig` 里的最小事实残留。

`useModelMigrationNotifications.tsx:5-8,21-33,49-50`
再说明这些字段的用途：

1. 判断这次启动是否刚刚发生过模型迁移
2. 只发一次高优先级提示
3. 在 `legacyOpusMigrationTimestamp` 场景里额外给出 opt-out 说明

这里必须谨慎说：
源码没有把这些字段字面命名成 tombstone。
但从功能上看，
它们确实承担了 tombstone-like marker 的职责：

`它们不是迁移动作，而是迁移动作完成后保留下来的最小历史事实，用于向当前系统解释“为什么现在变了”。`

## 9. 这篇源码剖面给主线带来的五条技术启示

### 启示一

repo 已经在 message 线明确展示：

`对象退役后，系统可能需要显式 tombstone control signal。`

### 启示二

repo 已经在 plugin 线明确展示：

`对象退役后留下的 marker 可以继续驱动后续删除、隐藏与搜索约束。`

### 启示三

repo 已经在 model 线明确展示：

`对象世界切换后，有时还需要一个最小历史注脚来解释当前世界为什么刚刚变化。`

### 启示四

repo 已经明确展示：

`marker` 不只是解释过去，
还会继续治理未来读取世界。

### 启示五

repo 甚至在插件卸载注释里直接承认：

`tombstones`

是 teardown / graph fallout 的真实风险对象，
这说明 post-retirement residue 从来不是抽象哲学问题，
而是工程上必须收口的安全对象。

## 10. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 只要补出 sunset governance，就已经足够成熟。`

而是：

`Claude Code 在 message tombstone、plugin orphan marker、marker-driven exclusion 与 migration trace artifact 上已经明确展示了 tombstone governance 的存在；因此 artifact-family cleanup stronger-request cleanup-sunset-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-tombstone-governor signer。`

再压成一句：

`cleanup 线真正缺的不是“谁来宣布旧世界结束”，而是“谁来决定结束后要留下什么最小残留事实来约束未来”。`
