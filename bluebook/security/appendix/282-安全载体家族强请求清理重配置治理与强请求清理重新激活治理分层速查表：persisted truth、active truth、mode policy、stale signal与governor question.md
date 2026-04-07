# 安全载体家族强请求清理重配置治理与强请求清理重新激活治理分层速查表：persisted truth、active truth、mode policy、stale signal与governor question

## 1. 这一页服务于什么

这一页服务于 [298-安全载体家族强请求清理重配置治理与强请求清理重新激活治理分层：为什么artifact-family cleanup stronger-request cleanup-reconfiguration-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-reactivation-governor signer](../298-安全载体家族强请求清理重配置治理与强请求清理重新激活治理分层.md)。

如果 `298` 的长文解释的是：

`为什么“旧 stronger-request 对象已经有了 current config truth”仍不等于“这组 truth 已经接管当前 running session”，`

那么这一页只做一件事：

`把 persisted truth、active truth、mode policy、stale signal 与 stronger-request cleanup current gap 压成一张矩阵。`

## 2. 强请求清理重配置治理与强请求清理重新激活治理分层矩阵

| positive control / cleanup current gap | persisted truth | active truth / stale signal | mode policy | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| plugin config save surface | `Configuration saved` is visible | `take effect` is still pending | interactive path requires explicit `/reload-plugins` | who decides when saved cleanup truth becomes running-session truth | `ManagePlugins.tsx:1631-1707` |
| Layer-3 refresh primitive | new config already exists on disk | `refreshActivePlugins()` swaps active components and consumes `needsRefresh` | reactivation is a distinct runtime choreography | who decides when persisted cleanup truth may replace stale active truth | `refresh.ts:1-18,59-160` |
| explicit reload command | pending plugin changes already exist | `/reload-plugins` converts them into `Reloaded: ...` active state | user-initiated activation contract | who decides when a visible command is required to activate returned cleanup truth | `reload-plugins/index.ts:1-16`; `reload-plugins.ts:1-56` |
| interactive stale-state discipline | new truth is known | active world may remain stale on purpose | `Do NOT auto-refresh` notification-only policy | who decides when stale cleanup world may persist visibly instead of being silently replaced | `useManagePlugins.ts:287-303` |
| background install/update split | plugin state changed on disk | new installs may auto-refresh; updates stop at `needsRefresh` | scenario-sensitive rollout policy | who decides which changed cleanup truth may auto-apply and which must stay pending | `PluginInstallationManager.ts:52-60,123-180` |
| headless auto-consume path | plugin/config truth is ready before first ask | `refreshPluginState()` auto-consumes via `refreshActivePlugins()` | headless mode uses a different activation authority | who decides when non-interactive cleanup truth may auto-takeover the session | `AppStateStore.ts:206-214`; `print.ts:1733-1765,1881-1912` |
| stronger-request cleanup current gap | reconfiguration question is now visible | no explicit cleanup reactivation grammar yet | old path / promise / receipt world still lack formal active takeover rules | who decides when returned cleanup truth truly becomes current running truth | current cleanup line evidence set |

## 3. 三个最重要的判断问题

判断一句
“既然旧 stronger-request 对象的 current config truth 已经写好，所以它现在也已经重新生效了”
有没有越级，
先问三句：

1. 这里说的是 `persisted truth`，还是 `active truth`
2. 当前只是 `saved`，还是已经 `take effect`
3. 这是 interactive、background，还是 headless 场景

## 4. 最常见的六类误读

| 误读 | 实际问题 |
| --- | --- |
| “配置保存了，所以运行时已经切过去了” | saved != active |
| “磁盘状态变了，所以当前会话已经接纳了它” | disk change != active takeover |
| “看到了 `needsRefresh`，所以已经完成了刷新” | stale signal != activation verdict |
| “所有模式都该采用同一套激活策略” | mode policy is part of governance |
| “schema valid 了，所以当前世界必然按它工作” | config validity != running-session validity |
| “已经重新激活了，所以后面一定 ready” | activation != readiness |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup reactivation grammar 不是：

`config truth exists -> therefore current world has switched`

而是：

`config truth exists -> stale signal surfaced -> activation authority selected -> Layer-3 takeover executed -> running truth updated`

只有这些层被补上，
stronger-request cleanup reconfiguration-governance 才不会继续停留在：

`系统已经知道旧对象现在该按哪组 truth 工作，却没人正式决定这组 truth 何时真正接管当前运行世界。`
