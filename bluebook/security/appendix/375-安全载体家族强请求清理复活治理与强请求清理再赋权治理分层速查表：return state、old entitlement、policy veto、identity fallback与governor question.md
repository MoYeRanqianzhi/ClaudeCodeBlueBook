# 安全载体家族强请求清理复活治理与强请求清理再赋权治理分层速查表：return state、old entitlement、policy veto、identity fallback与governor question

## 1. 这一页服务于什么

这一页服务于 [391-安全载体家族强请求清理复活治理与强请求清理再赋权治理分层](../391-安全载体家族强请求清理复活治理与强请求清理再赋权治理分层.md)。

如果 `391` 的长文解释的是：

`为什么“旧 stronger-request 对象可以回来”仍不等于“它回来后恢复哪些旧资格、旧配置、旧身份与旧可用 truth”，`

那么这一页只做一件事：

`把 comeback、enabled truth、config / secrets、policy veto、closure write 与 identity fallback 压成一张矩阵。`

## 2. 强请求清理复活治理与强请求清理再赋权治理分层矩阵

| positive control / cleanup current gap | return state | old entitlement / identity effect | higher veto / downgrade | cleanup current gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| plugin comeback after uninstall | object can reappear | old configs and secrets do not auto-return | last-scope uninstall wipes both | stronger-request cleanup has no explicit post-return config / secrets rule | who decides which old cleanup qualifications survive comeback at all | `pluginOptionsStorage.ts:201-272`; `pluginOperations.ts:523-540` |
| plugin enable path | object exists again | enabled truth still needs explicit settings write | policy / scope checks still gate it | stronger-request cleanup has no explicit enable-truth re-sign path after comeback | who decides whether returned cleanup object is actually re-entitled to run | `pluginOperations.ts:560-727` |
| policy-blocked plugin | object may exist or return | old entitlement still not restored | org policy can veto install / enable | stronger-request cleanup has no higher-governance veto plane for returned carriers | who decides whether higher governance may permanently block re-entitlement | `pluginPolicy.ts:11-19`; `pluginOperations.ts:650-657` |
| installed-vs-enabled divergence | disk / materialized metadata exists | effective entitlement still treated as false | system downgrades to not-installed so user can re-enable | stronger-request cleanup has no divergence guard separating existence from entitlement | who distinguishes mere existence from effective current entitlement | `installedPluginsManager.ts:827-830,859-861` |
| dependency closure install | one plugin request may return a whole closure | entitlement is written as a batch, not inferred from presence | blocked dependency vetoes the closure | stronger-request cleanup has no closure-level re-entitlement grammar | who decides whether comeback re-signs only one object or an old relation bundle | `pluginInstallationHelpers.ts:330-339,361-367,414-437` |
| forked plan comeback | content returns | old identity is not automatically restored | new slug becomes fallback identity | stronger-request cleanup has no identity fallback rule for returned carriers | who decides whether cleanup comeback keeps old seat or only gets a weaker new seat | `plans.ts:233-257`; `REPL.tsx:1790-1797` |

## 3. 三个最重要的判断问题

判断一句“既然旧 stronger-request 对象已经回来了，所以它原来的资格也一起回来了”有没有越级，先问三句：

1. 这里说的是 `return state`，还是 `effective entitlement`
2. 当前回来的是对象内容，还是对象的 old identity / old seat
3. 更高层的 policy、scope、config 与 closure truth 是否已经重新签字

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “对象回来，所以旧配置也还有效” | return != configured |
| “对象回来，所以旧 secrets 也继续可信” | return != secrets trust |
| “对象回来，所以自动恢复 enabled truth” | return != enabled |
| “对象回来，所以 policy 不该再挡它” | comeback does not override higher governance |
| “内容回来，所以还是旧身份” | content return != identity restoration |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup re-entitlement grammar 不是：

`object returns -> therefore old qualification returns`

而是：

`object returns -> old config / secrets policy checked -> enabled truth re-signed -> closure / seat / identity fallback decided`

只有这些层被补上，
stronger-request cleanup resurrection-governance 才不会继续停留在：

`系统已经知道旧对象如何回来，却没人正式决定它回来后还算不算原来那个被授权的对象。`
