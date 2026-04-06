# main迁移链、orphan宽限期与plans continuity的强请求清理迁移治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `196` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup drift 应该修哪一层，`

而是：

`一旦修法确定，旧 stronger-request 世界要怎样退场。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`repair governor 不等于 migration governor。`

这句话还不够硬。
所以这里单开一篇，只盯住：

- `src/main.tsx`
- `src/migrations/*`
- `src/utils/plugins/cacheUtils.ts`
- `src/utils/plans.ts`

把 repo 里现成的 model/config/plugin/plan 迁移治理正例，与 stronger-request cleanup 线未来仍要回答的 transition 问题直接对照出来。

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 只有 repair，没有 migration。`

而是：

`Claude Code 在别处已经很清楚地治理“旧世界怎样平滑退场”；stronger-request cleanup 线当前缺的不是迁移文化，而是这套 migration governance 还没被正式接到 cleanup artifact family 上。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| startup migration chain | `src/main.tsx:323-341` | 为什么 repo 已把迁移治理当成显式 startup governance |
| model migration governance | `src/migrations/migrateLegacyOpusToCurrent.ts:13-51` | 为什么 model repair 之后还要继续治理哪些 source 被改、哪些 source 只 remap、是否通知用户 |
| config-key migration governance | `src/migrations/migrateReplBridgeEnabledToRemoteControlAtStartup.ts:3-18` | 为什么旧 key -> 新 key 的过渡不是简单 rename，而是复制、删除时机与幂等治理 |
| orphan grace-window governance | `src/utils/plugins/cacheUtils.ts:20-99` | 为什么旧 plugin world 要进入 orphan + grace window，而不是立即消失 |
| plan continuity governance | `src/utils/plans.ts:150-248` | 为什么 plan artifact 的过渡需要 resume reuse、missing-file recovery 与 fork copy/new-slug policy |

## 4. `main.tsx` 先证明：真正成熟的系统不会把“新规则落地”偷写成“旧世界自然消失”

`main.tsx:323-341` 直接维护 migration 调用链。

这意味着：

`repo 已经承认旧世界退场不是偶发脚本，而是 startup governance 的正式组成。`

这条正例对 stronger-request cleanup 的价值在于，
它明确告诉我们：

`repair direction chosen` 之后，
真正成熟的系统还会继续问：

`old world exits how`

## 5. model 与 config-key 迁移再证明：迁移治理回答的不是“修不修”，而是“哪些旧世界怎样交接”

`migrateLegacyOpusToCurrent.ts:13-51` 已经清楚展示：

1. 只改 `userSettings`
2. project/local/policy settings 保留原样
3. runtime 继续 remap
4. 记录 timestamp 供 one-time notification

`migrateReplBridgeEnabledToRemoteControlAtStartup.ts:3-18` 又说明：

1. 旧 key 存在且新 key 未设置时才复制
2. 复制后再删旧 key
3. 整个过程 idempotent

这些正例共同证明：

`迁移治理` 回答的是：

1. 哪些 source 被 rewrite
2. 哪些 source 只被 remap
3. 旧 truth 何时删除
4. 通知与幂等怎么做

而这些都不是 repair 自己能回答的。

## 6. plugin orphan 宽限期给出最强迁移正例：旧世界体面退出，往往意味着先被标记、再进入 grace window、最后才真正清理

`cacheUtils.ts:20-99` 很值钱。

这里 repo 对旧 plugin world 的处理不是：

`new version arrives -> delete old immediately`

而是：

1. 先写 `.orphaned_at`
2. `CLEANUP_AGE_MS = 7 days`
3. 超过 7 天才真正删除
4. 重新安装时还会移除 stale marker

这就是最标准的：

`phased retirement grammar`

它对 stronger-request cleanup 的启示非常直接：

`旧 cleanup law、旧 path、旧 receipt world 也未必应该立即蒸发；它们很可能需要自己的 orphan / grace / cutover strategy。`

## 7. plans continuity 再证明：有些 migration 甚至不是 rewrite，而是 continuity-preserving reuse / recovery / copy

`plans.ts:150-248` 的 `copyPlanForResume()` / `copyPlanForFork()` 说明：

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

## 8. 一条硬结论

这组源码真正说明的不是：

`stronger-request cleanup 未来只要补出 repair governor，就已经足够成熟。`

而是：

`repo 在模型、配置键、插件 orphan 宽限期与 plans continuity 上已经明确展示了 migration governance 的存在；因此 artifact-family cleanup stronger-request cleanup-repair-governor signer 仍不能越级冒充 artifact-family cleanup stronger-request cleanup-migration-governor signer。`

因此：

`cleanup 线真正缺的不是“修完”，而是“修完后旧 stronger-request 世界怎样被体面带走”的最后一道治理设计。`
