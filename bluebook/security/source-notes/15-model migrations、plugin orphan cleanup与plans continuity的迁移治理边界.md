# model migrations、plugin orphan cleanup 与 plans continuity 的迁移治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `164` 时，  
真正需要被单独钉住的已经不是：

`cleanup 线未来要不要修，`

而是：

`cleanup 线一旦修，旧世界要怎样退场。`

如果这个问题只停在主线长文里，  
最容易被压成一句抽象判断：

`repair governor 不等于 migration governor。`

这句话还不够硬。  
所以这里单开一篇，只盯住：

- `src/main.tsx`
- `src/migrations/*`
- `src/utils/plugins/installedPluginsManager.ts`
- `src/utils/plugins/cacheUtils.ts`
- `src/utils/plans.ts`

把 repo 里现成的 model/config/plugin/plan 迁移治理正例，与 cleanup 线未来仍要回答的 transition 问题直接对照出来。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 repair，没有 migration。`

而是：

`Claude Code 在别处已经很清楚地治理“旧世界怎样平滑退场”；cleanup 线当前缺的不是迁移文化，而是这套 migration governance 还没被正式接到 cleanup artifact family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| startup migration registry | `src/main.tsx:323-341` | 为什么 repo 已把迁移治理当成显式 startup governance |
| model migration governance | `src/migrations/migrateSonnet1mToSonnet45.ts`; `src/migrations/migrateLegacyOpusToCurrent.ts`; `src/migrations/migrateSonnet45ToSonnet46.ts` | 为什么 model repair 之后还要继续治理哪些 source 被改、哪些 source 只 remap、是否通知用户 |
| config key migration governance | `src/migrations/migrateBypassPermissionsAcceptedToSettings.ts`; `src/migrations/migrateReplBridgeEnabledToRemoteControlAtStartup.ts` | 为什么旧 key → 新 key 的过渡不是简单 rename，而是幂等、复制、删除时机治理 |
| plugin structure migration governance | `src/utils/plugins/installedPluginsManager.ts:96-213`; `src/utils/plugins/cacheUtils.ts:20-99` | 为什么 plugin 的旧文件、旧 cache、orphan versions 需要 grace window 和 phased cleanup |
| plan continuity governance | `src/utils/plans.ts:150-248` | 为什么 plan artifact 的过渡世界需要 resume reuse、fork copy 与 missing-file recovery 策略 |

## 4. model migrations 先证明：真正的 migration governor 不只是“改成新值”，而是先决定哪些旧世界值得继续活一段时间

`src/main.tsx:323-341` 直接维护 migration 调用链。  
这意味着：

`repo 已经承认旧世界退场不是偶发脚本，而是 startup governance 的正式组成。`

进一步看 model migration：

`migrateSonnet1mToSonnet45.ts:1-45` 会：

1. 只改 `userSettings`
2. 保留其他 source 不被提升成 global default
3. 还要迁移 in-memory override
4. 通过 completion flag 保持幂等

`migrateLegacyOpusToCurrent.ts:1-53` 又会：

1. 只对 first-party 用户生效
2. 只改 `userSettings`
3. 让 project/local/policy settings 继续原样存在
4. 但在 runtime 中 remap
5. 记录 timestamp 供 one-time notification

这些决策没有一条是在回答“模型修不修”。  
它们回答的是：

`修完之后，旧值怎样退场，哪些 source 被尊重，哪些用户应被告知。`

这就是 migration governance 的本体。

## 5. 配置键迁移再证明：迁移治理并不等于“把旧字段替换掉”，而是决定新旧字段怎样并存多久

`migrateBypassPermissionsAcceptedToSettings.ts:1-34` 很关键。

它不是暴力删除旧字段，  
而是：

1. 只有旧 global flag 存在才迁
2. 如果 settings 已有新字段，就不重复覆盖
3. 迁完后才移除旧字段

`migrateReplBridgeEnabledToRemoteControlAtStartup.ts:1-18` 同样说明：

1. 只有 old key 存在且 new key 未设置才复制
2. 复制到新 key
3. 再删除旧 key
4. 保证 idempotent

这说明 config-key 迁移治理回答的是：

`新旧 truth 怎样交接，才能既不重复写坏，也不让旧世界突然蒸发。`

cleanup 线如果未来要修 `plansDirectory`、receipt semantics 或 startup delete language，  
就迟早也要面对这类问题：

`旧 promise、旧 key、旧 path 是双读一段时间，还是立即作废。`

## 6. plugin 线给出最强迁移治理正例：旧版本不会立刻被粗暴删除，而是进入 orphan grace world

`installedPluginsManager.ts:96-213` 的 `migrateToSinglePluginFile()` 已经非常清楚：

1. v2 文件优先重命名到主文件
2. 只有 v1 时才 in-place 转成 v2
3. 再清理 legacy non-versioned cache

这已经是一种迁移治理。

但 `cacheUtils.ts:20-99` 更强：

1. 旧版本先被标记 `.orphaned_at`
2. `CLEANUP_AGE_MS = 7 days`
3. 超过 7 天才真正删除
4. 重新安装时又会移除 stale marker

这里的关键已经不是“修得对不对”，  
而是：

`旧世界要不要 grace window，以及 grace window 结束后谁来收尸。`

这正是 migration governor 的典型职责。

cleanup 线未来如果修 `plansDirectory` propagation gap，  
也一样要回答：

1. 老 home-root plans 保留多久
2. 老 cleanup semantics 何时失效
3. 过渡期内是 dual-read、dual-clean 还是 one-way migrate

## 7. plans 自己也已经证明：迁移治理并不总是“批量重写”，有时是 continuity strategy

`plans.ts:150-248` 的 `copyPlanForResume()` / `copyPlanForFork()` 很值钱。

它们处理的不是 repair。  
它们处理的是：

1. 旧 session plan 如何被新 session 继续使用
2. 缺失文件时怎样从 snapshot / history 恢复
3. fork 时怎样复制旧世界但避免 clobber

这说明 migration governance 有时并不是：

`rewrite old data`

而是：

`preserve continuity while changing ownership / path / session lineage`

cleanup 线未来若涉及 plan path 改造，  
它同样不能只问：

`新路径是什么`

还必须问：

`旧 plan artifact 怎样继续被 resume world 看见，以及何时停止继续被看见。`

## 8. 这篇源码剖面给主线带来的四条技术启示

### 启示一

repo 已经在 model、config、plugin、plan 四条线上证明：

`migration governance` 是正式控制面，而不是 repair 的附带脚本。

### 启示二

transition 不是只有一种形态。  
它至少包括：

1. source rewrite
2. runtime remap
3. one-time notification
4. completion flag
5. orphan grace window
6. continuity-preserving copy / reuse / recovery

### 启示三

cleanup 线若未来补 repair governor，  
紧接着就会面对 migration governor 问题：

1. 旧承诺何时作废
2. 旧 path 如何 phase out
3. 旧 receipt 何时需要重签

### 启示四

真正成熟的修复治理不只要让新世界正确，  
还要让旧世界退场时不继续制造误删、误导或 artifact orphaning。

## 9. 一条硬结论

这组源码真正说明的不是：

`cleanup 线未来只要补出 repair governor，就已经足够成熟。`

而是：

`repo 在模型、配置键、插件缓存与 plan continuity 上已经明确展示了 migration governance 的存在；因此 artifact-family cleanup repair-governor signer 仍不能越级冒充 artifact-family cleanup migration-governor signer。`

因此：

`cleanup 线真正缺的不是“修完”，而是“修完后旧世界怎样被体面带走”的最后一道治理设计。`
