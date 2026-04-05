# 安全载体家族退役治理与墓碑治理分层速查表：sunset decision、tombstone decision、positive control、cleanup post-retirement gap与governor question

## 1. 这一页服务于什么

这一页服务于 [166-安全载体家族退役治理与墓碑治理分层：为什么artifact-family cleanup sunset-governor signer不能越级冒充artifact-family cleanup tombstone-governor signer](../166-安全载体家族退役治理与墓碑治理分层：为什么artifact-family%20cleanup%20sunset-governor%20signer不能越级冒充artifact-family%20cleanup%20tombstone-governor%20signer.md)。

如果 `166` 的长文解释的是：

`为什么决定旧世界何时正式结束，与决定结束后还留下什么最小残留标记，仍然是两层治理主权，`

那么这一页只做一件事：

`把 repo 里现成的 sunset decision / tombstone decision 正例，与 cleanup 线当前仍缺的 post-retirement marker grammar，压成一张矩阵。`

## 2. 退役治理与墓碑治理分层矩阵

| line | sunset decision | tombstone decision | positive control | cleanup post-retirement gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| orphaned assistant messages | decide failed streaming attempt is no longer valid current truth | emit `tombstone` control signal so UI/transcript remove the orphaned message consistently | explicit tombstone messages consumed by stream handler, REPL, transcript storage | cleanup line has no equivalent marker when old cleanup claims are retired | what marker tells later readers an old cleanup object was retired rather than silently absent | `query.ts:713-719`; `utils/messages.ts:2954-2957`; `REPL.tsx:2646-2648`; `sessionStorage.ts:1466-1473`; `QueryEngine.ts:756-759` |
| plugin orphan versions | decide old version leaves current installed world and enters orphan/grace world | stamp `.orphaned_at`, later clear or consume it for GC and exclusion | `.orphaned_at` + marker-driven grep/glob exclusions | cleanup line has no explicit post-retirement marker for old path/promise/receipt worlds | who decides what minimal marker survives after cleanup artifact retirement | `cacheUtils.ts:56-72,145-171`; `orphanedPluginFilter.ts:1-79`; `main.tsx:2546-2568`; `pluginOperations.ts:526-547` |
| model transition notes | decide old model/default no longer remains the active current world | persist migration timestamps so startup can explain the change once | migration timestamps in global config + one-time migration notifications | cleanup line has no equivalent transition note explaining why a previously valid cleanup interpretation changed | what minimal post-transition trace should explain a retired cleanup interpretation | `config.ts:428-438`; `resetProToOpusDefault.ts`; `migrateLegacyOpusToCurrent.ts`; `migrateSonnet45ToSonnet46.ts`; `useModelMigrationNotifications.tsx:1-33` |
| cleanup line overall | may eventually decide old cleanup world is sunset | no explicit tombstone grammar is visible for retired cleanup artifacts | tombstone/marker grammar exists elsewhere in repo | retired cleanup worlds could become silent ambiguity | who governs residual markers after old cleanup meanings stop being valid | cleanup source cluster + positive controls above |

## 3. 三个最重要的判断问题

判断一句“cleanup sunset 已经完整”有没有越级，先问三句：

1. 这只是 sunset decision，还是已经明确退役后留下什么最小 marker
2. 旧对象不再有效之后，是会静默消失，还是会留下受治理的 tombstone / marker / note
3. 如果未来读者仍可能误读旧世界，那么这些最小残留标记由谁决定、由谁消费、何时再清除

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “既然已经 sunset，就不需要再留痕” | retirement != tombstone governance |
| “残留 marker 只是垃圾，不算控制面” | some markers are machine-consumable control artifacts |
| “删掉旧对象就已经解释清楚了” | deletion != explanation |
| “只要有 warning 就算有 tombstone” | not every warning or timestamp is a tombstone-level marker |
| “marker 一存在，就代表对象还有效” | marker may exist precisely because the object is no longer valid |

## 5. 一条硬结论

真正成熟的 lifecycle grammar 不是：

`sunset decision -> old world ends`

而是：

`sunset decision -> assign tombstone authority -> leave minimal residual truth -> constrain later readers/runtime -> optionally clear tombstone later`

只有中间三层被补上，  
cleanup sunset governance 才不会继续停留在“知道旧世界什么时候该结束，却没人负责告诉后来者它为什么结束、别再怎样误读它”的半治理状态。
