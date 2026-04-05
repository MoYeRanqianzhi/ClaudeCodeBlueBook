# model deprecation、migration notifications 与 plugin orphan grace window 的退役治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `165` 时，  
真正需要被单独钉住的已经不是：

`cleanup 线未来要不要迁，`

而是：

`cleanup 线即便会迁，谁来宣布旧世界何时正式退役。`

如果这个问题只停在主线长文里，  
最容易被压成一句抽象判断：

`migration governor 不等于 sunset governor。`

这句话还不够硬。  
所以这里单开一篇，只盯住：

- `src/utils/model/deprecation.ts`
- `src/hooks/notifs/useDeprecationWarningNotification.tsx`
- `src/hooks/notifs/useModelMigrationNotifications.tsx`
- `src/migrations/migrateLegacyOpusToCurrent.ts`
- `src/utils/model/model.ts`
- `src/utils/plugins/cacheUtils.ts`
- `src/utils/plugins/orphanedPluginFilter.ts`
- `src/main.tsx`

把 repo 里现成的模型退役日期、迁移通知、plugin orphan grace window 与 visibility cutoff 直接并排，  
逼出一句更硬的结论：

`Claude Code 已经知道“怎样过渡”，也已经在别处知道“何时结束过渡”；cleanup 线当前缺的不是文化，而是这套 sunset governance 还没被正式接到 cleanup artifact family 上。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 migration，没有 sunset。`

而是：

`Claude Code 在模型与插件线上已经明确把“过渡”和“退役”拆成两张时钟；cleanup 线当前缺的不是这套思想，而是这套退役治理还没被正式接到旧 plan path、旧 cleanup promise 与旧 receipt semantics 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| model retirement dates | `src/utils/model/deprecation.ts:29-100` | 为什么 repo 已把 retirement date 当成正式 provider-specific 治理对象 |
| deprecation notification surface | `src/hooks/notifs/useDeprecationWarningNotification.tsx:6-31`; `src/main.tsx:2872-2892` | 为什么 sunset warning 是单独的 runtime surface，而不是 migration 副产品 |
| model migration notification surface | `src/hooks/notifs/useModelMigrationNotifications.tsx:7-33` | 为什么 “刚迁完” 与 “即将退役” 是两种不同通知 |
| legacy compatibility still alive | `src/migrations/migrateLegacyOpusToCurrent.ts:12-53`; `src/utils/model/model.ts:552-554` | 为什么 migration 已发生时，旧显式字符串仍可能继续被 runtime remap |
| plugin grace window | `src/utils/plugins/cacheUtils.ts:23-24,74-171` | 为什么 orphan version 会先进入 grace world，再在 deadline 后删除 |
| plugin visibility sunset | `src/utils/plugins/orphanedPluginFilter.ts:1-79`; `src/main.tsx:2546-2568` | 为什么旧 plugin version 可能先从 search visibility 退役，再从磁盘层真正删除 |

## 4. 模型线先证明：migration notification 与 deprecation warning 回答的是两件事

`useModelMigrationNotifications.tsx:7-33` 很清楚。  
这段代码只在 migration timestamp 是“最近几秒内写入”时发通知。

它回答的是：

`这次启动刚把你迁到了新模型。`

但 `deprecation.ts:29-100` 维护的是另一套真相：

1. 哪个 substring 代表旧模型
2. 对不同 provider 的 retirement date 是什么
3. 哪些 provider 已经不再算 deprecated，哪些仍在倒计时

`useDeprecationWarningNotification.tsx:6-31` 与 `main.tsx:2872-2892` 再把这套真相投影到 UI：

1. 一进入 REPL 就能进 initial notification queue
2. 模型变化后还能继续在 effect 中提醒
3. 远程模式下会被跳过，说明这也是受 runtime surface 约束的正式输出

这说明：

`刚迁完`

和

`即将退役`

根本不是同一句话。  
前者是 migration clock，  
后者是 sunset clock。

## 5. `legacy opus` 再证明：迁移已经完成时，旧世界也可能仍被兼容

`migrateLegacyOpusToCurrent.ts:12-53` 做的很像一条“已经把旧世界送上车”的迁移：

1. 把 `userSettings` 从显式旧字符串改成 `opus`
2. 写入 `legacyOpusMigrationTimestamp`
3. 让启动后可以弹一次“Model updated to Opus 4.6”通知

但这还不是 sunset。

因为 `model.ts:552-554` 的 `isLegacyModelRemapEnabled()` 仍然保留：

`CLAUDE_CODE_DISABLE_LEGACY_MODEL_REMAP`

这个开关。  
也就是说：

1. migration 已发生
2. 旧显式模型字符串仍能继续被 runtime remap
3. 退役并没有随着迁移同时完成

这条证据非常硬。  
它直接证明：

`旧世界仍被兼容`

和

`旧世界已经退役`

不是同一个状态。

## 6. plugin 线给出更清楚的 sunset grammar：先切 visibility，再切 storage

`cacheUtils.ts:23-24` 先把规则写死：

- `.orphaned_at`
- `CLEANUP_AGE_MS = 7 days`

然后 `cleanupOrphanedPluginVersionsInBackground():74-171` 把退役过程拆成两步：

1. 旧版本变成 orphan 时，先打标
2. 超过 7 天后才真正删除

这已经说明 plugin 线不把“有新版本了”直接写成“旧版本立刻消失”。

但更值钱的是 `orphanedPluginFilter.ts:1-79` 与 `main.tsx:2546-2568`：

1. orphan GC 先跑完，确保 marker 与 reinstalled world 已对齐
2. 然后 warm Grep/Glob exclusion cache
3. exclusion list 在 session 内冻结，除非 `/reload-plugins`

这意味着旧 plugin version 会经历两次退役：

1. visibility sunset  
   先从搜索/匹配世界消失
2. storage sunset  
   grace window 到期后再从磁盘上真正删除

这套拆法非常值得 cleanup 线学习。  
因为它清楚地承认：

`旧 artifact 还在磁盘上，不等于它仍该被当前世界继续看见。`

## 7. 这篇源码剖面给主线带来的四条技术启示

### 启示一

repo 已经在模型线上清楚展示：

`migration notification`

和

`retirement warning`

是两套不同制度。

### 启示二

repo 已经在 plugin 线上清楚展示：

`grace window`

和

`hard delete`

中间还可以插入一层：

`visibility cutoff`

### 启示三

`migration completed`

只是说明迁移脚本不该再重跑，  
并不自动说明旧世界已经被正式关闭。

### 启示四

cleanup 线未来如果只补 migration grammar，  
却不补：

1. compatibility deadline
2. visibility cutoff
3. hard-close authority

那么旧 plan path、旧 cleanup promise 与旧 receipt semantics  
仍会以“大家都知道它们该退出，但没人知道从什么时候起它们真的不算数”的方式继续制造模糊地带。

## 8. 一条硬结论

这组源码真正说明的不是：

`cleanup 线未来只要补出 migration governance，就已经足够成熟。`

而是：

`repo 在 model deprecation、migration notifications、plugin orphan grace window 与 session-level exclusion 上已经明确展示了 sunset governance 的存在；因此 artifact-family cleanup migration-governor signer 仍不能越级冒充 artifact-family cleanup sunset-governor signer。`

因此：

`cleanup 线真正缺的不是“怎么带旧世界走一段路”，而是“谁来宣布这段路何时结束”。`
