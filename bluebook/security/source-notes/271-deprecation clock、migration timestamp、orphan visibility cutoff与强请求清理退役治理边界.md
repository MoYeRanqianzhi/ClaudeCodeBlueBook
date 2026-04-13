# deprecation clock、migration timestamp、orphan visibility cutoff与强请求清理退役治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `420` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 旧世界怎样被带过渡，`

而是：

`旧 stronger-request 世界从什么时候起正式不再算当前世界。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`migration governor 不等于 sunset governor。`

这句话还不够硬。

所以这里单开一篇，
只盯住：

- `src/main.tsx`
- `src/utils/model/deprecation.ts`
- `src/hooks/notifs/useModelMigrationNotifications.tsx`
- `src/hooks/notifs/useDeprecationWarningNotification.tsx`
- `src/screens/REPL.tsx`
- `src/migrations/migrateLegacyOpusToCurrent.ts`
- `src/utils/model/model.ts`
- `src/utils/plugins/cacheUtils.ts`
- `src/utils/plugins/orphanedPluginFilter.ts`

把 repo 里现成的 migration registry、migration timestamp、provider-specific retirement date、runtime warning、plugin grace window 与 session visibility cutoff 并排，
直接钉死 stronger-request cleanup 在 sunset grammar 上的当前缺口。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 migration，没有 sunset。`

而是：

`Claude Code 在模型与插件线上已经明确把“怎样过渡”与“何时正式结束过渡”拆成多张时钟；stronger-request cleanup 线当前缺的不是这套思想，而是这套 sunset governance 还没被正式映射到旧 startup wording、旧 cleanup path、旧 covered-family covenant 与旧 receipt semantics 的边界判定上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| migration registry | `src/main.tsx:323-346` | 为什么 migration version 只回答要不要重跑迁移动作，不回答旧世界何时正式结束 |
| retirement-date plane | `src/utils/model/deprecation.ts:21-25,33-100` | 为什么 repo 已把 retirement date 当成 provider-specific truth |
| one-time migration notice | `src/hooks/notifs/useModelMigrationNotifications.tsx:5-50`; `src/migrations/migrateLegacyOpusToCurrent.ts:13-57` | 为什么 “刚迁完” 与 “已经退役” 是两种不同制度 |
| sustained warning surface | `src/hooks/notifs/useDeprecationWarningNotification.tsx:6-42`; `src/screens/REPL.tsx:744-762`; `src/main.tsx:2872-2895` | 为什么 sunset warning 是单独 runtime surface，而不是 migration 副产物 |
| compatibility residue | `src/utils/model/model.ts:549-554` | 为什么 migration 已发生时，旧世界仍可能继续被 remap |
| storage sunset | `src/utils/plugins/cacheUtils.ts:23-24,66-176` | 为什么旧 plugin world 先进入 grace period，再进入 deletion |
| visibility sunset | `src/utils/plugins/orphanedPluginFilter.ts:1-91`; `src/main.tsx:2544-2568` | 为什么旧 plugin version 可能先从 visibility world 退役，再从 storage world 消失 |

## 4. `CURRENT_MIGRATION_VERSION` 先证明：迁移注册表不是退役裁决表

`main.tsx:323-346`
把 migration 写成了正式 startup registry：

1. `CURRENT_MIGRATION_VERSION` 定义当前迁移集
2. version 不一致时运行整组 startup migration
3. 完成后再把 `migrationVersion` 写回 global config

这已经非常正式。

但它回答的仍然只是：

`哪些过渡动作这次启动需要被重放`

而不是：

`旧世界从什么时候起正式不能再算 current truth`

这条对 stronger-request cleanup 的启示很硬：

`即便未来 cleanup 线也长出自己的 startup migration plane，这仍然不等于它已经拥有 sunset authority。`

## 5. 模型线再证明：migration clock 与 sunset clock 本来就是两张不同的时钟

`useModelMigrationNotifications.tsx:5-50`
只在 migration timestamp 刚写入时弹一次通知。

它回答的是：

`this launch just moved you to a newer model`

但
`deprecation.ts:21-25,33-100`
回答的是另一件事：

`this model retires on a provider-specific date`

更重要的是，
`useDeprecationWarningNotification.tsx:6-42`
和
`REPL.tsx:744-762`
把 deprecation warning 做成持续 hook，
而
`main.tsx:2872-2895`
又在 initial notification queue 里重复投影一次。

这说明源码自己就在区分：

1. `migration clock`
   说的是“刚带你上车”
2. `sunset clock`
   说的是“旧列车什么时候正式停运”
3. `warning surface`
   说的是“在停运前，谁要被持续提醒”

如果这些是同一主权，
源码根本不需要同时维护 migration timestamp、retirement date、REPL warning hook 与 startup warning queue。

## 6. `legacy opus` 再证明：迁移完成时，旧世界仍可能继续被兼容，因而 sunset 远没有结束

`migrateLegacyOpusToCurrent.ts:13-57`
做了很完整的迁移：

1. 只改 `userSettings`
2. 写 `legacyOpusMigrationTimestamp`
3. 为 REPL 的 one-time migration notice 提供条件

但
`model.ts:549-554`
仍保留：

`CLAUDE_CODE_DISABLE_LEGACY_MODEL_REMAP`

这说明：

1. migration 已发生
2. 旧世界仍在 runtime remap 中活着
3. sunset 还没有 hard-close

这一点的技术含义很强：

`旧值是否仍被 tolerated`

本身就是 sunset grammar 的一部分。

如果系统只有 migration 没有 sunset，
它就不会需要显式保存这种 compatibility residue。

## 7. plugin 线给出更细的 sunset grammar：先切 visibility，再切 storage

`cacheUtils.ts:23-24,66-176`
把 orphan plugin version 的命运写成：

1. 先写 `.orphaned_at`
2. 再等 `7 days`
3. 超时后才删目录

这已经说明 storage sunset 有自己的 clock。

但更值钱的是
`orphanedPluginFilter.ts:1-91`
与
`main.tsx:2544-2568`
继续把另一层拆出来：

1. orphan GC 先校正 marker state
2. 随后 warm grep/glob exclusion cache
3. exclusion list 一旦生成就在 session 内冻结
4. 直到显式 `/reload-plugins` 才刷新

这说明旧 world 可以先退出：

`search visibility world`

再晚一点才退出：

`disk storage world`

而且这个 visibility cutoff
还是 session-scoped current-world control，
不是简单的磁盘事实。

这对 stronger-request cleanup 的启示非常直接：

`旧 cleanup law 是否还“算当前世界”，和旧 bytes 是否还留在 carrier 上，本来就不是同一个问题。`

## 8. 这组源码给出的技术启示

Claude Code 的多重安全技术真正先进的地方，
不是“它会在旧版本不对时马上换成新版本”，
而是：

`它会根据旧世界的风险类型，分别治理 migration registry、migration timestamp、retirement date、warning surface、visibility cutoff 与 storage cutoff。`

这组源码给出的稳定技术启示至少有七条：

1. migration registry 不能替代 retirement clock
2. migration timestamp 不能替代 deprecation warning
3. warning surface 不能替代 hard-close authority
4. runtime remap 的继续存在本身就是“旧世界尚未结束”的证据
5. phased retirement 往往先切 visibility，再切 storage
6. session-scoped frozen exclusion cache 是 `current world` 的治理，而不是磁盘 housekeeping 的附注
7. 是否算 current truth 必须独立于“是否还在磁盘上”来治理

## 9. 苏格拉底式自反诘问：我是不是又把“旧世界已经被过渡处理”误认成了“旧世界已经正式结束”

如果对这一层做更严格的自我审查，
至少要追问八句：

1. 如果 migration strategy 已经明确，为什么还要再拆 sunset？
   因为会并存，不等于知道并存何时结束。
2. 如果 migration notification 已经显示，是否就等于 sunset 已经发生？
   不等于。那只是 launch-local change receipt，不是 hard-close verdict。
3. 如果 deprecation warning 已在 startup queue 和 REPL hook 里出现，是否就说明旧世界已经失效？
   也不等于。warning 是持续压力，不是 current-truth cutoff 本身。
4. 如果 runtime remap 仍在，是否说明 sunset 不存在？
   反而相反。它证明 sunset 还没完成。
5. 如果 orphan 版本还在磁盘上，是否说明它仍算当前世界？
   也不对。visibility world 可能已经先把它切掉。
6. 如果 exclusion cache 冻结到 session 结束，是不是说明这只是性能优化，与安全无关？
   不能这么看。冻结的是当前 session 对“什么还算当前插件世界”的判断边界。
7. 如果 cleanup 线现在还没有显式 sunset 代码，是不是说明这层还不值得写？
   恰恰相反。越缺正式 cutoff grammar，越容易把兼容世界误说成 current truth。
8. 如果我继续把 sunset 当成 migration 的附属物，会漏掉什么？
   会漏掉日期、warning、visibility、runtime acceptance 与 storage deletion 这些不同层面的“合法性收回”机制。

这一串反问最后逼出一句更稳的判断：

`sunset 的关键，不在系统能不能让旧世界先共存一段时间，而在系统能不能正式决定这段共存从什么时候起不再被承认为当前世界。`

## 10. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 只要补出 migration governance，就已经足够成熟。`

而是：

`Claude Code 在 migration registry、provider-specific retirement dates、migration timestamp、runtime deprecation warning、plugin grace window 与 session-level visibility cutoff 上已经明确展示了 sunset governance 的存在；因此 artifact-family cleanup stronger-request cleanup-migration-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-sunset-governor signer。`

再压成一句：

`cleanup 线真正缺的不是“怎么把旧世界带着走一段路”，而是“谁来宣布这段路何时结束”。`
