# 安全载体家族强请求清理复活治理与强请求清理再赋权治理分层速查表：return state、old entitlement、policy veto、identity fallback与governor question

## 1. 这一页服务于什么

这一页服务于 [296-安全载体家族强请求清理复活治理与强请求清理再赋权治理分层：为什么artifact-family cleanup stronger-request cleanup-resurrection-governor signer不能越级冒充artifact-family cleanup stronger-request cleanup-re-entitlement-governor signer](../296-安全载体家族强请求清理复活治理与强请求清理再赋权治理分层.md)。

如果 `296` 的长文解释的是：

`为什么“旧对象可以回来”仍不等于“回来后恢复哪些旧资格”，`

那么这一页只做一件事：

`把 config/secret wipe、explicit enable、policy veto、scope legality、identity fallback 与 stronger-request cleanup current gap 压成一张矩阵。`

## 2. 强请求清理复活治理与强请求清理再赋权治理分层矩阵

| positive control / cleanup current gap | return state | old entitlement surface | post-return gate / identity fallback | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| last-scope uninstall cleanup | object may come back later | old `pluginConfigs` / `pluginSecrets` are explicitly wiped on last-scope removal | config trust is not auto-restored by comeback | who decides whether returned cleanup object gets its old config/secrets trust back | `pluginOptionsStorage.ts:201-208,210-272`; `pluginOperations.ts:528-540` |
| explicit enable operation | object may already exist on disk or in settings | enabled truth still requires a dedicated settings write | return != enabled entitlement | who decides whether a returned cleanup object is merely present or actually re-enabled | `pluginOperations.ts:573-727` |
| policy-blocked return | object can reappear materially | higher policy may still deny effective use | policy veto survives comeback | who decides whether returned cleanup object is still blocked by stronger policy | `pluginPolicy.ts:11-19`; `pluginOperations.ts:650-657` |
| scope / seat legality | object can reappear under one scope | old seat is not automatically reclaimed | cross-scope legality and override rules still apply | who decides whether comeback restores the old seat or requires a new precedence position | `pluginOperations.ts:664-687`; `installedPluginsManager.ts:827-830,859-861` |
| plan content return | content can come back | old identity may not | fork path gets `newSlug`, resume path reuses lineage only when appropriate | who decides whether returned cleanup object comes back as old identity or only as new identity carrying old content | `plans.ts:233-257`; `REPL.tsx:1790-1797` |
| stronger-request cleanup current gap | resurrection question is now visible | no explicit re-entitlement grammar yet | old path / old promise / old receipt world still lack formal qualification-return policy | who decides which old cleanup rights come back after the object itself comes back | `utils/cleanup.ts:33-45,300-303,575-597`; `utils/plans.ts:79-110` |

## 3. 三个最重要的判断问题

判断一句
`既然旧 stronger-request 对象已经回来了，所以它也恢复了原来的资格`
有没有越级，
先问三句：

1. 这里说的是 `return state`，还是 `old entitlement surface`
2. 当前恢复的是对象存在，还是 enabled/configured/authorized truth
3. 这个对象回来的是 old identity，还是 only content with a new seat

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “对象回来了，所以它默认还是 enabled” | return != enabled truth |
| “对象回来了，所以旧配置当然也回来” | comeback != config/secrets trust return |
| “对象回来了，所以 policy 也默认放行” | comeback != policy clearance |
| “内容回来就等于原身份回来” | content return != identity/seat return |
| “存在即可证明 entitlement 已恢复” | existence != entitlement |

## 5. 一条硬结论

真正成熟的 stronger-request cleanup re-entitlement grammar 不是：

`object returns -> therefore old entitlement returns`

而是：

`object returns -> old entitlement surfaces evaluated separately -> policy/seat/identity decided -> only then can qualification be said to return`

只有这些层被补上，
stronger-request cleanup resurrection-governance 才不会继续停留在：

`系统已经知道旧对象怎样回来，却没人正式决定它回来后恢复哪些旧资格。`
