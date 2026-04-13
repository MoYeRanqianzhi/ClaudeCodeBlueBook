# 安全载体家族强请求清理再赋权治理与强请求清理重配置治理分层速查表：seat truth、config truth、apply truth、needs-config与governor question

## 1. 这一页服务于什么

这一页服务于 [456-安全载体家族强请求清理再赋权治理与强请求清理重配置治理分层](../456-安全载体家族强请求清理再赋权治理与强请求清理重配置治理分层.md)。

如果 `456` 的长文解释的是：

`为什么“returned object 重新拿回 seat”仍不等于“它当前按哪组 config truth 重新工作”，`

那么这一页只做一件事：

`把 seat truth、config truth、apply truth、needs-config 与 stronger-request cleanup current gap 压成一张矩阵。`

## 2. 强请求清理再赋权治理与强请求清理重配置治理分层矩阵

| positive control / cleanup current gap | seat truth | config truth | apply truth | cleanup current gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| top-level plugin comeback | object can regain `Enabled` path | options / secrets still need split-save and cross-store scrub | save alone does not prove runtime already uses them | stronger-request cleanup has no explicit option-truth ledger after comeback | who decides which current option truth a returned seat now obeys | `pluginOptionsStorage.ts:90-193` |
| top-level config closure | object already exists | invalid / missing fields are pushed back into `unconfigured` schema slice | no closure means no honest ready claim | stronger-request cleanup has no explicit missing-config grammar | who decides whether seat existence has become config closure | `pluginOptionsStorage.ts:282-309` |
| per-server / per-channel comeback | server / channel seat is visible | payload still needs save + validation + stale-key scrub | `needs-config` blocks overclaim | stronger-request cleanup has no payload-truth plane for returned carriers | who decides which payload truth a returned seat currently serves | `mcpbHandler.ts:141-339,742-757,894-902`; `mcpPluginIntegration.ts:290-317` |
| flow-level config closure | object already sits in the menu | `configured` / `skipped` remains separate from mere existence | completion of steps still != already active world | stronger-request cleanup has no flow-level closure grammar | who decides when config truth is formally closed rather than merely editable | `PluginOptionsFlow.tsx:53-133` |
| UI-level running truth | object may be `Enabled` or `Enabled and configured` | configuration may already be saved | `Configuration saved` still != `take effect` | stronger-request cleanup has no save-vs-apply distinction yet | who decides whether saved truth has entered active runtime world | `ManagePlugins.tsx:1645-1668,1700-1707` |

## 3. 三个最重要的判断问题

判断一句“既然 returned object 已经重新拿回资格，所以它现在也已经按正确配置工作了”有没有越级，先问三句：

1. 这里说的是 `seat truth`，还是 `config truth`
2. 当前只是 `configured / saved`，还是已经 `take effect`
3. 这个对象现在缺的是 authority seat，还是缺 current input truth

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “对象 enable 了，所以配置一定已齐” | enabled != configured |
| “旧 secret 还在，所以 current truth 还承认它” | old presence != current validity |
| “已经保存过一次，所以 schema 已闭合” | save != closure |
| “UI 看得到对象，所以 payload 已 ready” | visibility != work-ready config truth |
| “配置已保存，所以当前运行时已经在用它” | saved != applied |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup reconfiguration grammar 不是：

`seat restored -> therefore object is ready`

而是：

`seat restored -> current config truth declared -> missing config surfaced -> save truth governed -> apply truth governed`

只有这些层被补上，
stronger-request cleanup re-entitlement-governance 才不会继续停留在：

`系统已经知道旧对象还配不配坐回座位，却没人正式决定它坐回去以后究竟按哪组 current truth 重新运转。`
