# 安全载体家族强请求清理重配置治理与强请求清理重新激活治理分层速查表：persisted truth、active truth、mode policy、stale signal与governor question

## 1. 这一页服务于什么

这一页服务于 [361-安全载体家族强请求清理重配置治理与强请求清理重新激活治理分层](../361-安全载体家族强请求清理重配置治理与强请求清理重新激活治理分层.md)。

如果 `361` 的长文解释的是：

`为什么“returned object 现在该按哪组 current config truth 工作”仍不等于“这组 truth 何时真正接管 running session”，`

那么这一页只做一件事：

`把 persisted truth、active truth、mode policy 与 stronger-request cleanup current gap 压成一张矩阵。`

## 2. 强请求清理重配置治理与强请求清理重新激活治理分层矩阵

| positive control / cleanup current gap | persisted truth | active truth / take-effect signal | mode policy / stale signal | cleanup current gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| config save path | current options / secrets / payload already saved | saving alone still != active takeover | UI says `take effect` separately | stronger-request cleanup has no explicit take-effect grammar after config save | who decides when returned cleanup truth becomes running-session truth | `ManagePlugins.tsx:1645-1668,1700-1707` |
| Layer-3 refresh primitive | config truth already exists in stores | `refreshActivePlugins()` swaps active components | `needsRefresh` cleared only after refresh | stronger-request cleanup has no explicit active-world swap primitive | who decides when persisted cleanup truth may replace stale active world | `refresh.ts:1-176` |
| interactive plugin mode | object/config changes detected | no immediate active swap | `Do NOT auto-refresh`; notify `/reload-plugins` | stronger-request cleanup has no interactive stale-signal discipline | who decides that user-facing stale state must remain visible rather than silently auto-consumed | `useManagePlugins.ts:287-303` |
| install/update policy split | same disk-change family exists | new install may auto-refresh, update may not | scenario-sensitive reactivation rule | stronger-request cleanup has no scenario-sensitive takeover policy | who decides whether same cleanup truth change auto-activates or waits for explicit trigger | `PluginInstallationManager.ts:52-180` |
| headless path | config truth available before first ask | `refreshPluginState()` auto-consumes via `refreshActivePlugins()` | mode-specific auto-activation | stronger-request cleanup has no headless auto-consume rule | who decides that headless mode may auto-consume while interactive mode may not | `print.ts:1733-1768,3072-3092`; `AppStateStore.ts:209-214` |

## 3. 三个最重要的判断问题

判断一句“既然 returned object 的配置已经保存好了，所以它现在也已经真正生效了”有没有越级，先问三句：

1. 这里说的是 `persisted truth`，还是 `active truth`
2. 当前 mode 是 interactive、background，还是 headless
3. 系统显化的是 `stale signal`，还是已经完成 `take effect`

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “配置落盘了，所以当前 session 一定在用它” | saved != live |
| “disk change 了，所以 active components 一定已换” | disk change != active swap |
| “提示用户 `/reload-plugins` 只是 UX” | stale signal is a governance fact |
| “所有模式都该自动或都该手动” | reactivation policy is mode-sensitive |
| “配置真相已经闭合，所以运行真相也已经闭合” | config truth != active-world truth |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup reactivation grammar 不是：

`config truth closed -> therefore current world already updated`

而是：

`config truth closed -> stale world policy declared -> takeover trigger governed -> active swap governed`

只有这些层被补上，
stronger-request cleanup reconfiguration-governance 才不会继续停留在：

`系统已经知道对象现在该按哪组 truth 工作，却没人正式决定这组 truth 何时接管当前运行世界。`
