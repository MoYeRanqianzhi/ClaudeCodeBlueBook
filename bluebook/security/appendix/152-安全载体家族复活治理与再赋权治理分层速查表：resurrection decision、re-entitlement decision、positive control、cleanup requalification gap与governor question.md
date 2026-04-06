# 安全载体家族复活治理与再赋权治理分层速查表：resurrection decision、re-entitlement decision、positive control、cleanup requalification gap与governor question

## 1. 这一页服务于什么

这一页服务于 [168-安全载体家族复活治理与再赋权治理分层：为什么artifact-family cleanup resurrection-governor signer不能越级冒充artifact-family cleanup re-entitlement-governor signer](../168-安全载体家族复活治理与再赋权治理分层：为什么artifact-family%20cleanup%20resurrection-governor%20signer不能越级冒充artifact-family%20cleanup%20re-entitlement-governor%20signer.md)。

如果 `168` 的长文解释的是：

`为什么决定对象能否回来，与决定对象回来后恢复哪些旧资格，仍然是两层治理主权，`

那么这一页只做一件事：

`把 repo 里现成的 resurrection decision / re-entitlement decision 正例，与 cleanup 线当前仍缺的 requalification grammar，压成一张矩阵。`

## 2. 复活治理与再赋权治理分层矩阵

| line | resurrection decision | re-entitlement decision | positive control | cleanup requalification gap | governor question | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| plugin object comeback | object may return to disk/materialized world and later to active Layer-3 world | decide whether old enabled state, config, secrets, scope, and policy allowance are restored | `refreshActivePlugins()` + `setPluginEnabledOp()` + `deletePluginOptions()` + policy guard | cleanup line has no explicit rule for whether resurrected cleanup objects recover old strong claims | who decides what old cleanup authority comes back with the object | `pluginOptionsStorage.ts:210-267`; `pluginOperations.ts:573-734`; `pluginPolicy.ts:1-18`; `installedPluginsManager.ts:820-861` |
| plugin scope/precedence | object can be found again by full pluginId or settings lookup | decide whether it returns at old scope, higher-precedence override, or merely user default scope | scope resolution and precedence logic in `setPluginEnabledOp()` | cleanup line has no explicit rule for whether a restored artifact reclaims its original trust scope | who decides restored cleanup truth returns at old scope vs a weaker/new one | `pluginOperations.ts:640-699` |
| plan content return | plan content may be recovered or copied back into current workflow | decide whether original slug/identity is restored or a new slug is assigned | `copyPlanForResume()` vs `copyPlanForFork()` | cleanup line has no explicit rule for whether restored receipts/promises regain original identity | who decides restored cleanup artifacts keep original identity vs new identity | `plans.ts:164-258`; `conversationRecovery.ts:540-555` |
| cleanup line overall | may eventually decide old cleanup object can re-enter current world | no explicit re-entitlement authority for restored cleanup artifacts is visible yet | re-entitlement governance exists elsewhere in repo | restored cleanup worlds still lack a formal qualification grammar | who governs what authority a resurrected cleanup object regains | cleanup source cluster + positive controls above |

## 3. 三个最重要的判断问题

判断一句“cleanup resurrection 已经完整”有没有越级，先问三句：

1. 这只是 resurrection decision，还是已经明确对象回来后恢复哪些旧资格
2. 对象回来后，是只恢复存在，还是恢复 enabled/configured/identity/scope truth
3. 如果旧资格不是全部自动恢复，那么哪些资格能回来、哪些不能回来，由谁决定

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “对象回来了，所以当然还是原来那个可用对象” | resurrection != re-entitlement |
| “重新安装/恢复后，旧 secrets 和配置自然回来” | return != secret/config restoration |
| “恢复旧内容就等于恢复旧身份” | content recovery != identity restoration |
| “disk/materialized world 已恢复，所以 effective entitlement 也恢复了” | existence != entitlement |
| “只要 policy 没再报错，就说明资格自动续上了” | policy check is one gate, not the whole qualification grammar |

## 5. 一条硬结论

真正成熟的 comeback grammar 不是：

`object returns -> original authority returns`

而是：

`object returns -> assign re-entitlement authority -> decide enabled/config/secret/identity scope -> requalify only the permitted subset`

只有中间两层被补上，  
cleanup resurrection governance 才不会继续停留在“知道对象怎样回来，却没人负责决定它回来后还能说多强、拿多大资格”的半治理状态。
