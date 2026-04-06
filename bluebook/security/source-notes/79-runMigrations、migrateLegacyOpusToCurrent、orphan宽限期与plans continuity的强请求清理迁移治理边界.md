# runMigrations、migrateLegacyOpusToCurrent、orphan宽限期与plans continuity的强请求清理迁移治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `228` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup drift 应该修哪一层，`

而是：

`一旦修法确定，旧 stronger-request 世界要怎样退场。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`repair governor 不等于 migration governor。`

这句话还不够硬。

所以这里单开一篇，
只盯住：

- `src/main.tsx`
- `src/migrations/migrateLegacyOpusToCurrent.ts`
- `src/migrations/migrateReplBridgeEnabledToRemoteControlAtStartup.ts`
- `src/utils/plugins/cacheUtils.ts`
- `src/utils/plans.ts`

把 repo 里现成的 model/config/plugin/plan 迁移治理正例，
与 stronger-request cleanup 线未来仍要回答的 transition 问题，
直接对照出来。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 repair，没有 migration。`

而是：

`Claude Code 在别处已经很清楚地治理“旧世界怎样平滑退场”；stronger-request cleanup 线当前缺的不是迁移文化，而是这套 migration governance 还没被正式接到 cleanup artifact family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| startup migration chain | `src/main.tsx:323-345` | 为什么 repo 已把迁移治理当成显式 startup governance |
| model migration governance | `src/migrations/migrateLegacyOpusToCurrent.ts:13-57` | 为什么 model repair 之后还要继续治理哪些 source 被改、哪些 source 只 remap、是否通知用户 |
| config-key migration governance | `src/migrations/migrateReplBridgeEnabledToRemoteControlAtStartup.ts:3-21` | 为什么旧 key -> 新 key 的过渡不是简单 rename，而是复制、删除时机与幂等治理 |
| orphan grace-window governance | `src/utils/plugins/cacheUtils.ts:23-24,52-74,89-105` | 为什么旧 plugin world 要进入 orphan + grace window，而不是立即消失 |
| plan continuity governance | `src/utils/plans.ts:153-255` | 为什么 plan artifact 的过渡需要 resume reuse、missing-file recovery 与 fork copy/new-slug policy |

## 4. `runMigrations()` 先证明：真正成熟的系统不会把“新规则落地”偷写成“旧世界自然消失”

`main.tsx:323-345` 直接维护：

1. `CURRENT_MIGRATION_VERSION`
2. startup migration chain
3. version gate after successful run

这意味着：

`repo 已经承认旧世界退场不是偶发脚本，而是 startup governance 的正式组成。`

这条正例对 stronger-request cleanup 的价值在于，
它明确告诉我们：

`repair direction chosen`

之后，
真正成熟的系统还会继续问：

`old world exits how`

## 5. model migration 先给出最强正例：成熟系统不会把“更正新规则”直接写成“粗暴覆盖所有旧值”

`migrateLegacyOpusToCurrent.ts:13-57`
展示的不是简单“把旧模型改成新模型”，
而是：

1. 只重写 `userSettings`
2. project/local/policy source 保持原样
3. runtime 继续 remap
4. 记录 `legacyOpusMigrationTimestamp` 供 REPL 做 one-time notification

这说明 model migration governance 真正回答的是：

1. 哪些 source 被 rewrite
2. 哪些 source 只被 remap
3. 哪些用户需要显式 notice
4. 哪些旧 source 必须继续被尊重

而这些都不是 repair 自己能回答的。

## 6. config-key migration 再证明：迁移治理并不等于“把旧字段替换掉”，而是决定新旧字段怎样交接

`migrateReplBridgeEnabledToRemoteControlAtStartup.ts:3-21`
非常值钱。

它不是暴力删旧 key，
而是：

1. 只有 old key 存在且 new key 未设置时才复制
2. 复制到新 key
3. 再删除 old key
4. 整个过程保持 idempotent

这说明 config-key migration 的技术本质不是 rename，
而是：

`handoff without double-write and without silent loss`

stronger-request cleanup 线未来如果修 startup-delete wording、
调整 `plansDirectory` cleanup world、
或补 stronger receipt semantics，
同样会遇到这类问题：

`旧 law、旧 knob、旧 wording 是双读一段时间，还是立即作废。`

## 7. plugin orphan 宽限期给出最强迁移正例：旧世界体面退出，往往意味着先被标记、再进入 grace window、最后才真正清理

`cacheUtils.ts:23-24,52-74,89-105`
最值钱的地方在于：

1. 旧版本先被标记 `.orphaned_at`
2. `CLEANUP_AGE_MS = 7 days`
3. 超过 7 天才真正删除
4. 重新安装时还会移除 stale marker

这里体现的就是最典型的：

`phased retirement grammar`

它对 stronger-request cleanup 的启示非常直接：

`旧 cleanup law、旧 path、旧 receipt world 也未必应该立即蒸发；它们很可能需要自己的 orphan / grace / cutover strategy。`

## 8. plans continuity 再证明：有些 migration 甚至不是 rewrite，而是 continuity-preserving reuse / recovery / copy

`plans.ts:153-255`
的 `copyPlanForResume()` / `copyPlanForFork()`
说明：

1. resume 时复用原 slug
2. 文件缺失时先从 snapshot / message history 恢复
3. fork 时复制内容但换新 slug，避免 clobber

这说明 migration governance 有时并不是：

`rewrite old world`

而是：

`preserve continuity while changing lineage`

这对 stronger-request cleanup 尤其重要。
一旦 cleanup law 未来修到 plans / receipts / continuity surfaces，
就必须继续回答：

`旧 artifact 在 transition 期间怎样被 continue、怎样被 recover、何时停止被看见。`

## 9. 这组源码给出的技术启示

Claude Code 的多重安全技术真正先进的地方，
不是“它会在旧版本不对时马上换成新版本”，
而是：

`它会根据旧世界类型选择不同 transition grammar。`

这组源码给出的稳定技术启示至少有五条：

1. 迁移应被提升成显式 startup governance，而不是散落的补丁
2. source rewrite、runtime remap 与 user notification 不必绑定为同一动作
3. old-key/new-key handoff 必须有 idempotent grammar，避免重复写坏
4. phased retirement 往往比 immediate deletion 更接近真实安全世界
5. continuity-preserving reuse/recovery/copy 是 migration grammar，而不是 repair 的附属物

## 10. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 未来只要补出 repair governor，就已经足够成熟。`

而是：

`repo 在模型、配置键、plugin orphan 宽限期与 plans continuity 上已经明确展示了 migration governance 的存在；因此 artifact-family cleanup stronger-request cleanup-repair-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-migration-governor signer。`

再压成一句：

`cleanup 线真正缺的不是“修完”，而是“修完后旧 stronger-request 世界怎样被有秩序地带走”的最后一道治理设计。`
