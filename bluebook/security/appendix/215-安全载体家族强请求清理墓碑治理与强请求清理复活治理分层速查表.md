# 安全载体家族强请求清理墓碑治理与强请求清理复活治理分层速查表：authoritative clearing、re-entry gate、identity policy、active layer与governor question

## 1. 这一页服务于什么

这一页服务于 [231-安全载体家族强请求清理墓碑治理与强请求清理复活治理分层：为什么artifact-family cleanup stronger-request cleanup-tombstone-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-resurrection-governor signer](../231-安全载体家族强请求清理墓碑治理与强请求清理复活治理分层.md)。

如果 `231` 的长文解释的是：

`为什么“旧 stronger-request 世界结束后留下什么 marker”仍不等于“哪些旧对象可以重新回来、回来时算谁、进入哪一层 current world”，`

那么这一页只做一件事：

`把 authoritative clearing、re-entry gate、identity policy、active-layer admission 与 stronger-request cleanup current gap 压成一张矩阵。`

## 2. 强请求清理墓碑治理与强请求清理复活治理分层矩阵

| positive control / cleanup current gap | tombstone state | authoritative clearing / re-entry gate | identity policy / active layer | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| plugin orphan marker | old version remains marked by `.orphaned_at` | only authoritative installed set can clear marker | marker clear still != active components return | who decides which retired cleanup object may actually re-enter current world | `cacheUtils.ts:67-73,82-92,122-130` |
| plugin active world | object may exist again on disk | `/reload-plugins` + `refreshActivePlugins()` is explicit Layer-3 re-entry gate | active world is runtime admission, not automatic side effect | who decides when marker-cleared object becomes active truth in current session | `refresh.ts:1-18,72-79,123-137`; `reload-plugins.ts:37-56` |
| plugin update path | install/update already happened | updates only stop at `needsRefresh`; some new installs may auto-refresh, failure falls back to pending-like state | repo distinguishes auto-admit, manual admit, and not-yet-admitted worlds | who decides which resurrection path may auto-apply and which must remain explicit | `PluginInstallationManager.ts:56-59,135-179`; `useManagePlugins.ts:287-303` |
| plan recovery path | history / snapshot still exists | `copyPlanForResume()` requires lineage + evidence and is called from formal recovery flow | `copyPlanForFork()` creates new slug instead of restoring old identity | who decides whether cleanup object returns as old identity, new identity, or not at all | `plans.ts:164-231,239-257`; `conversationRecovery.ts:539-547` |
| tombstone deletion path | tombstone removes old transcript object | no re-entry logic here | delete path is not restore path | who distinguishes deletion grammar from resurrection grammar in cleanup world | `sessionStorage.ts:1468-1473` |
| stronger-request cleanup current gap | tombstone question is now visible | no explicit resurrection gate yet | old path / promise / receipt world still lack formal re-entry policy | who decides whether retired cleanup objects can come back, and on what identity / admission terms | current cleanup line evidence set |

## 3. 三个最重要的判断问题

判断一句
“既然旧 stronger-request 世界的 marker 已经清了，所以它也已经正式回来了”
有没有越级，
先问三句：

1. 这里说的是 `authoritative clearing`，还是 `active re-entry`
2. 当前恢复的是对象内容，还是对象身份
3. 这个对象回来的是 disk / materialized world，还是 active / runtime world

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “墓碑清了，所以对象已经回来” | marker clearing != resurrection |
| “对象在磁盘上，所以运行时已接纳它” | disk return != active return |
| “内容恢复了，所以原身份也恢复了” | content recovery != identity restoration |
| “tombstone path 天然自带复活语义” | deletion path != re-entry policy |
| “任何历史对象都可以回来” | resurrection requires explicit authority, evidence, and admission policy |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup resurrection grammar 不是：

`marker exists -> marker clears -> therefore object is back`

而是：

`marker exists -> authoritative clearing defined -> re-entry gate defined -> identity policy defined -> active-layer admission defined`

只有这些层被补上，
stronger-request cleanup tombstone-governance 才不会继续停留在：

`系统已经知道旧世界结束后留下什么 marker，却没人正式决定带着这些 marker 的旧对象凭什么重新回来。`
