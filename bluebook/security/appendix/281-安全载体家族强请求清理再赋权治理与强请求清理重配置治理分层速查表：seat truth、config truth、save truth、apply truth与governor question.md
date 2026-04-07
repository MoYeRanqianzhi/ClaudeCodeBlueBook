# 安全载体家族强请求清理再赋权治理与强请求清理重配置治理分层速查表：seat truth、config truth、save truth、apply truth与governor question

## 1. 这一页服务于什么

这一页服务于 [297-安全载体家族强请求清理再赋权治理与强请求清理重配置治理分层：为什么artifact-family cleanup stronger-request cleanup-re-entitlement-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-reconfiguration-governor signer](../297-安全载体家族强请求清理再赋权治理与强请求清理重配置治理分层.md)。

如果 `297` 的长文解释的是：

`为什么“旧 stronger-request 对象重新拿回 seat”仍不等于“它现在按哪组 current config truth 重新工作”，`

那么这一页只做一件事：

`把 seat truth、config truth、save truth、apply truth 与 stronger-request cleanup current gap 压成一张矩阵。`

## 2. 强请求清理再赋权治理与强请求清理重配置治理分层矩阵

| positive control / cleanup current gap | seat truth | config truth | save truth / apply truth | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| top-level plugin comeback | object regains seat / enabled path | options and secrets still need split-save + scrub | save alone does not prove runtime already uses them | who decides which current config truth qualifies a returned cleanup object to work | `pluginOptionsStorage.ts:90-193,282-309` |
| per-server / per-channel comeback | server / channel seat is visible | payload still needs save + schema-valid config | `needs-config` blocks overclaim of readiness | who decides which payload truth a returned cleanup seat now obeys | `mcpbHandler.ts:141-339,742-757,894-902`; `mcpPluginIntegration.ts:290-317` |
| flow-level config closure | object already exists | `configured` vs `skipped` remains a separate outcome | no steps != no object; steps done != already applied | who decides when config truth is formally closed rather than merely editable | `PluginOptionsFlow.tsx:53-133` |
| UI-level running truth | object may be `Enabled` | `Enabled and configured` is stronger than `Enabled` | `Configuration saved` still != `take effect` | who decides whether saved config has become active world truth | `ManagePlugins.tsx:1645-1668,1700-1707` |
| stronger-request cleanup current gap | resurrection and re-entitlement questions are now visible | no explicit cleanup config grammar yet | old path / promise / receipt world still lack formal work-ready config truth | who decides which current config truth a returned cleanup object must satisfy before it can honestly work | `utils/cleanup.ts:33-45,300-303,575-597`; `utils/plans.ts:79-110` |

## 3. 三个最重要的判断问题

判断一句
`既然旧 stronger-request 对象已经重新拿到资格，所以它现在也已经按正确配置工作了`
有没有越级，
先问三句：

1. 这里说的是 `seat truth`，还是 `config truth`
2. 当前只是 `configured`，还是已经 `take effect`
3. 这个对象现在缺的是存在资格，还是缺当前输入真相

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “对象 enable 了，所以配置一定已齐” | enabled != configured |
| “secret 以前存过，所以现在仍可直接用” | old secret presence != current config validity |
| “保存过一次，所以 schema 已全部满足” | save != full validation closure |
| “UI 能看到对象，所以 payload 已 ready” | visibility != work-ready config truth |
| “配置已保存，所以当前运行时已经在用它” | saved != applied |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup reconfiguration grammar 不是：

`seat restored -> therefore object is ready`

而是：

`seat restored -> config truth declared -> missing config surfaced -> save truth governed -> apply truth governed`

只有这些层被补上，
stronger-request cleanup re-entitlement-governance 才不会继续停留在：

`系统已经知道旧对象配不配拿回 seat，却没人正式决定它拿回 seat 之后凭哪组 current truth 重新工作。`
